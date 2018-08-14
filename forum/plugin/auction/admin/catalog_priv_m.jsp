<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.web.*"%>
<html>
<head>
<title>管理登录</title>
<link href="../../../../common.css" rel="stylesheet" type="text/css">
<link href="../manager/default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="leafPriv" scope="page" class="com.redmoon.forum.plugin.auction.LeafPriv"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
String op = ParamUtil.get(request, "op");
String dirCode = ParamUtil.get(request, "dirCode");

leafPriv.setDirCode(dirCode);
if (!(leafPriv.canUserDel(privilege.getUser(request)) || leafPriv.canUserExamine(privilege.getUser(request)))) {
	out.print(StrUtil.Alert_Back("用户需对该节点拥有删除和审核的权限！"));
	return;
}

Leaf leaf = new Leaf();
leaf = leaf.getLeaf(dirCode);

if (op.equals("add")) {
	String name = ParamUtil.get(request, "name");
	int type = ParamUtil.getInt(request, "type");
	if (type==1) {
		User user = new User();
		user = user.getUser(name);
		if (!user.isLoaded()) {
			out.print(StrUtil.Alert_Back("该用户不存在！"));
			return;
		}
	}
	try {
		if (leafPriv.add(name, type))
			out.print(StrUtil.Alert("添加成功！"));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}

if (op.equals("modify")) {
	int id = ParamUtil.getInt(request, "id");
	int see = 0, append=0, del=0, modify=0, examine=0;
	String strsee = ParamUtil.get(request, "see");
	if (StrUtil.isNumeric(strsee)) {
		see = Integer.parseInt(strsee);
	}
	String strappend = ParamUtil.get(request, "append");
	if (StrUtil.isNumeric(strappend)) {
		append = Integer.parseInt(strappend);
	}
	String strmodify = ParamUtil.get(request, "modify");
	if (StrUtil.isNumeric(strmodify)) {
		modify = Integer.parseInt(strmodify);
	}
	String strdel = ParamUtil.get(request, "del");
	if (StrUtil.isNumeric(strdel)) {
		del = Integer.parseInt(strdel);
	}
	String strexamine = ParamUtil.get(request, "examine");
	if (StrUtil.isNumeric(strexamine)) {
		examine = Integer.parseInt(strexamine);
	}
	
	leafPriv.setId(id);
	leafPriv.setAppend(append);
	leafPriv.setModify(modify);
	leafPriv.setDel(del);
	leafPriv.setSee(see);
	leafPriv.setExamine(examine);
	if (leafPriv.save())
		out.print(StrUtil.Alert("修改成功！"));
	else
		out.print(StrUtil.Alert("修改失败！"));
}

if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	LeafPriv lp = new LeafPriv();
	lp = lp.getLeafPriv(id);
	if (lp.del())
		out.print(StrUtil.Alert("删除成功！"));
	else
		out.print(StrUtil.Alert("删除失败！"));
}

%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理 <%=leaf.getName()%> 权限</td>
    </tr>
  </tbody>
</table>
<%
Vector result = leafPriv.list();
Iterator ir = result.iterator();
%>
<br>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px" noWrap width="18%">用户</td>
      <td class="thead" noWrap width="13%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">类型</td>
      <td class="thead" noWrap width="43%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">权限</td>
      <td width="26%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
    </tr>
<%
int i = 0;
while (ir.hasNext()) {
 	LeafPriv lp = (LeafPriv)ir.next();
	i++;
	%>
  <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method=post>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<%=lp.getName()%>
	  <input type=hidden name="id" value="<%=lp.getId()%>">
      <input type=hidden name="dirCode" value="<%=lp.getDirCode()%>">
</td>
      <td><%=lp.getType()==0?"用户组":"用户"%></td>
      <td>
	  <input name=see type=checkbox <%=lp.getSee()==1?"checked":""%> value="1">浏览&nbsp;
	  <input name=append type=checkbox <%=lp.getAppend()==1?"checked":""%> value="1"> 
	  添加 &nbsp;
	  <input name=del type=checkbox <%=lp.getDel()==1?"checked":""%> value="1">
	  删除&nbsp;
	  <input name=modify type=checkbox <%=lp.getModify()==1?"checked":""%> value="1"> 
	  修改 
	  <input name=examine type=checkbox <%=lp.getExamine()==1?"checked":""%> value="1">
	  审核 </td>
      <td>
	  <input type=submit value="修改">
&nbsp;<input type=button onClick="window.location.href='dir_priv_m.jsp?op=del&dirCode=<%=StrUtil.UrlEncode(leaf.getCode())%>&id=<%=lp.getId()%>'" value=删除> </td>
    </tr></form>
<%}%>
  </tbody>
</table>
<HR noShade SIZE=1>
<DIV style="WIDTH: 95%" align=right>
  <INPUT 
onclick="javascript:location.href='catalog_priv_add.jsp?dirCode=<%=StrUtil.UrlEncode(leafPriv.getDirCode())%>';" type=image 
height=20 width=80 src="images/btn_add.gif">
</DIV>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.pwd.value!=form1.pwd_confirm.value)
		errmsg += "密码与确认密码不致，请检查！\n"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>