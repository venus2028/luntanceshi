<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.db.*" %>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String root_code = ParamUtil.get(request, "root_code");
if (root_code.equals("")) {
	root_code = "root";
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><lt:Label res="res.label.cms.dir" key="content"/></title>
<LINK href="default.css" type=text/css rel=stylesheet>
<script src="../inc/common.js"></script>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String op = ParamUtil.get(request, "op");
%>
<jsp:useBean id="leafPriv" scope="page" class="cn.js.fan.module.cms.LeafPriv"/>
<%
LeafPriv lp = new LeafPriv();
lp.setDirCode(root_code);

if (op.equals("AddChild")) {
    String parent_code = ParamUtil.get(request, "parent_code").trim();
	lp.setDirCode(parent_code);
	if (!lp.canUserExamine(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	boolean re = false;
	try {
		re = dir.AddChild(request);
		if (!re) {
			out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","add_msg")));
		}
		else {
			String code = ParamUtil.get(request, "code");
		%>
			<script>
			window.parent.dirmainFrame.doAdd("<%=parent_code%>", "<%=code%>");
			alert("操作成功！");
			</script>
		<%
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
else if (op.equals("del")) {
	String delcode = ParamUtil.get(request, "delcode");
	lp.setDirCode(delcode);
	if (!lp.canUserExamine(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	Leaf delleaf = dir.getLeaf(delcode);
	if (delleaf==null) {
	}
	else {
		try {
			dir.del(delcode);
			// out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "res.label.cms.dir","success_del"), "dir_top_ajax.jsp?root_code=" + StrUtil.UrlEncode(root_code)));
			%>
			<script>
			window.parent.dirmainFrame.doDel("<%=delcode%>");
			alert("操作成功！");
			</script>			
			<%
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert(e.getMessage()));
		}
	}
}
else if (op.equals("modify")) {
	String code = ParamUtil.get(request, "code");
	lp.setDirCode(code);
	if (!lp.canUserExamine(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	boolean re = true;
	try {
		re = dir.update(request);
		if (re) {
			// out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","modify_finished")));
			// 修改目录
			Leaf lf = new Leaf();
			lf = lf.getLeaf(code);
			%>
			<script>
			window.parent.dirmainFrame.doModify("<%=code%>", "<%=lf.getName()%>");
			alert("操作成功！");
			</script>
			<%
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
else if (op.equals("move")) {
	String code = ParamUtil.get(request, "code");
	lp.setDirCode(code);
	if (!lp.canUserExamine(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	boolean re = false;
 	String direction = ParamUtil.get(request, "direction", false);	
	Leaf leaf = new Leaf();
	leaf = leaf.getLeaf(code);
	leaf = leaf.getBrother(direction);
	String brotherCode = "";
	if (leaf!=null)
		brotherCode = leaf.getCode();
	try {
		re = dir.move(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re) {
		%>
		<script>
		<%if (direction.equals("down")) {%>
		window.parent.dirmainFrame.doMove("<%=code%>", "<%=brotherCode%>");
		<%}else{%>
		window.parent.dirmainFrame.doMove("<%=brotherCode%>", "<%=code%>");
		<%}%>
		</script>
		<%
		//out.print(StrUtil.Alert("操作成功！"));
	}
}
%>
</body>
</html>
