<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.guestbook.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String siteCode = ParamUtil.get(request, "siteCode");
String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	String dir_code = ParamUtil.get(request, "dir_code");
	if (dir_code.equals("not")) {
		out.print(StrUtil.Alert_Back("该节点不能被选择，请选择其它节点！"));
		return;
	}
	Leaf lf = new Leaf();
	lf = lf.getLeaf(dir_code);
	String addPage = DocumentMgr.getWebEditPage();
	if(lf.getType() == Leaf.TYPE_DOCUMENT){
		response.sendRedirect(request.getContextPath() + "/" + addPage + "?op=editarticle&dir_code=" + StrUtil.UrlEncode(dir_code));
	}else{
		response.sendRedirect(request.getContextPath() + "/" + addPage + "?op=add&dir_code=" + StrUtil.UrlEncode(dir_code));
	}
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>发布文章</title>
<link href="../default.css" rel="stylesheet" type="text/css">
<script>
function addform_submit() {
	if (addform.dir_code.value=="not") {
		alert("该节点不能被选择，请选择其它节点！");
		return false;
	}
}
</script>
</head>
<body leftmargin="0">
<jsp:useBean id="msg" scope="page" class="cn.js.fan.module.guestbook.MessageDb"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">添加文章</td>
  </tr>
</table>
<br>
<form name="addform" action="doc_add.jsp?op=add" method="post" onSubmit="return addform_submit()">
<table width="98%" border='0' align="center" cellpadding='3' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 colspan="2" align="left" class="thead">
	选择目录</td>
  </tr>
  
  <tr>
    <td width="14%" height=26 align="left">请选择目录：</td>
    <td width="86%" height="26" align="left">
		<select name="dir_code" onChange="if(this.options[this.selectedIndex].value=='not'){alert(this.options[this.selectedIndex].text+' <lt:Label res="res.label.webedit" key="can_not_be_selected"/>');  return false;}">
		<%
		Leaf lf = new Leaf();
		lf = lf.getLeaf(siteCode);
		if (lf==null)
			lf = dir.getLeaf("root");
		DirectoryView dv = new DirectoryView(lf);
		dv.ShowDirectoryAsOptions(out, lf, lf.getLayer());
		%>
		</select>
	</td>
  </tr>
  <tr>
    <td height=26 colspan="2" align="center">
      <input name="submit" type="submit" value="添加文章">
	</td>
  </tr>
</table>
</form>
</body>
</html>