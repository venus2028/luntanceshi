<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.ext.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.UserGroupDb" %>
<%@ page import="com.redmoon.forum.plugin.*" %>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String dirCode = ParamUtil.get(request, "dirCode");
String orderBy = ParamUtil.get(request, "orderBy");
if (orderBy.equals(""))
	orderBy = "name";
String sort = ParamUtil.get(request, "sort");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.dir" key="msg_login"/></title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<script>
var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
			
	window.location.href = "dir_priv_m.jsp?dirCode=<%=dirCode%>&orderBy=" + orderBy + "&sort=" + sort;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="leafPriv" scope="page" class="cn.js.fan.module.cms.LeafPriv"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String op = ParamUtil.get(request, "op");
String isAll = ParamUtil.get(request, "isAll");
if (dirCode.equals("")) {
	dirCode = Leaf.ROOTCODE;
	isAll = "y";
}

if (isAll.equals("y")) {
	dirCode = Leaf.ROOTCODE;
	if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN)) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
}

leafPriv.setDirCode(dirCode);
if (!(leafPriv.canUserDel(privilege.getUser(request)) || leafPriv.canUserExamine(privilege.getUser(request)))) {
	out.print(StrUtil.Alert_Back(privilege.MSG_INVALID + SkinUtil.LoadString(request, "res.label.cms.dir","priv_msg")));
	return;
}

Leaf leaf = new Leaf();
leaf = leaf.getLeaf(dirCode);

if (op.equals("add")) {
	String name = ParamUtil.get(request, "name");
	String[] ary = StrUtil.split(name, ",");
	if (ary==null) {
		out.print(StrUtil.Alert("请选择用户！"));
		return;
	}
	int type = ParamUtil.getInt(request, "type");
	if (type==1) {
		User user = new User();
		for (int i=0; i<ary.length; i++) {
			user = user.getUser(ary[i]);
			if (!user.isLoaded()) {
				out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.cms.dir","user_not_exsist")));
				return;
			}
		}
	}
	int i = 0;
	try {
		for (i=0; i<ary.length; i++) {
			leafPriv.add(ary[i], type);
		}
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","add_success")));
	}
	catch (ErrMsgException e) {
		// out.print(StrUtil.Alert_Back(e.getMessage()));
		out.print(StrUtil.Alert_Back("操作失败：用户" + ary[i] + "可能已拥有权限！"));
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
	if (leafPriv.save()) {
		if (isAll.equals("y"))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "res.label.cms.dir","modify_success"), "dir_priv_m.jsp?isAll=" + isAll));
		else
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "res.label.cms.dir","modify_success"), "dir_priv_m.jsp?isAll=" + isAll + "&dirCode=" + StrUtil.UrlEncode(dirCode)));
	}
	else
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","modify_Failure")));
	return;
}

if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	LeafPriv lp = new LeafPriv();
	lp = lp.getLeafPriv(id);
	if (lp.del())
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","success_del")));
	else
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","del_Failure")));
}

// 论坛用户组权限
if (op.equals("priv")) {
	UserGroupPrivDb upd = new UserGroupPrivDb();
	String groupCode = ParamUtil.get(request, "group_code");
	upd = upd.getUserGroupPrivDb(groupCode, dirCode);
	QObjectMgr qom = new QObjectMgr();
	if (qom.save(request, upd, "cms_forum_user_group_priv_save"))
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "dir_priv_m.jsp?dirCode=" + dirCode));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><%=leaf.getName()%>&nbsp;-&nbsp;权限</td>
    </tr>
  </tbody>
</table>
<%
String sql = "select id from dir_priv" + " order by " + orderBy + " " + sort;
Vector result = null;
if (isAll.equals("y"))
	result = leafPriv.list(sql);
else
	result = leafPriv.list();
Iterator ir = result.iterator();
%>
<br>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="24"><strong>后台用户权限</strong></td>
  </tr>
</table>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
    <tr>
      <td class="thead" style="PADDING-LEFT: 10px;cursor:hand" noWrap width="13%" onClick="doSort('name')"><lt:Label res="res.label.cms.dir" key="user"/>
        <%if (orderBy.equals("name")) {
			if (sort.equals("asc")) 
				out.print("<img src='../forum/admin/images/arrow_up.gif' width=8px height=7px align=absMiddle>");
			else
				out.print("<img src='../forum/admin/images/arrow_down.gif' width=8px height=7px align=absMiddle>");
		}%>
      </td>
      <td class="thead" noWrap width="17%" onClick="doSort('dir_code')" style="cursor:hand"><img src="images/tl.gif" align="absMiddle" width="10" height="15">目录<span class="right-title" style="cursor:hand">
        <%if (orderBy.equals("dir_code")) {
			if (sort.equals("asc")) 
				out.print("<img src='../forum/admin/images/arrow_up.gif' width=8px height=7px align=absMiddle>");
			else
				out.print("<img src='../forum/admin/images/arrow_down.gif' width=8px height=7px align=absMiddle>");
		}%>
      </span></td>
      <td class="thead" noWrap width="5%" onClick="doSort('priv_type')" style="cursor:hand"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.dir" key="model"/>
        <%if (orderBy.equals("priv_type")) {
			if (sort.equals("asc")) 
				out.print("<img src='../forum/admin/images/arrow_up.gif' width=8px height=7px align=absMiddle>");
			else
				out.print("<img src='../forum/admin/images/arrow_down.gif' width=8px height=7px align=absMiddle>");
		}%>
      </td>
      <td class="thead" noWrap width="35%"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.dir" key="prv"/></td>
      <td width="10%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15"><lt:Label res="res.label.cms.dir" key="oper"/></td>
    </tr>
<%
int i = 0;
Directory dir = new Directory();
while (ir.hasNext()) {
 	LeafPriv lp = (LeafPriv)ir.next();
	Leaf lf = dir.getLeaf(lp.getDirCode());
	i++;
	%>
  <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method=post>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<%=lp.getName()%>
	  <input type=hidden name="id" value="<%=lp.getId()%>">
      <input type=hidden name="dirCode" value="<%=lp.getDirCode()%>">
      <input type=hidden name="isAll" value="<%=isAll%>">
	  </td>
      <td><a href="dir_priv_m.jsp?dirCode=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a></td>
      <td><%=lp.getType()==0?SkinUtil.LoadString(request, "res.label.cms.dir","user_group"):SkinUtil.LoadString(request, "res.label.cms.dir","user")%></td>
      <td>
	  <input name=see type=checkbox <%=lp.getSee()==1?"checked":""%> value="1"><lt:Label res="res.label.cms.dir" key="browse"/>&nbsp;
	  <input name=append type=checkbox <%=lp.getAppend()==1?"checked":""%> value="1"> 
	  <lt:Label res="res.label.cms.dir" key="add"/> &nbsp;
	  <input name=del type=checkbox <%=lp.getDel()==1?"checked":""%> value="1">
	  <lt:Label res="res.label.cms.dir" key="del"/>&nbsp;
	  <input name=modify type=checkbox <%=lp.getModify()==1?"checked":""%> value="1"> 
	  <lt:Label res="res.label.cms.dir" key="modify"/> 
	  <input name=examine type=checkbox <%=lp.getExamine()==1?"checked":""%> value="1">
	  <lt:Label res="res.label.cms.dir" key="check"/> </td>
      <td>
	  <input type=submit value="<%=SkinUtil.LoadString(request, "res.label.cms.dir","modify")%>">
&nbsp;<input type=button onClick="if (confirm('您确定要删除吗？')) window.location.href='dir_priv_m.jsp?op=del&isAll=<%=isAll%>&dirCode=<%=StrUtil.UrlEncode(lp.getDirCode())%>&id=<%=lp.getId()%>'" value=<%=SkinUtil.LoadString(request, "res.label.cms.dir","del")%>> </td>
    </tr></form>
<%}%>
  </tbody>
</table><br>
<%if (!isAll.equals("y")) {%>
<DIV style="WIDTH: 95%" align=right>
  <INPUT name="button" type="button" onclick="window.location.href='dir_priv_add.jsp?dirCode=<%=StrUtil.UrlEncode(dirCode)%>'" value="<%=SkinUtil.LoadString(request,"op_add")%>">
</DIV>
<%}%>
<%
if (!isAll.equals("y")) {
	String code;
	String desc;
	UserGroupDb ugroup = new UserGroupDb();
	result = ugroup.list();
	ir = result.iterator();
	int k=0;
%>
<br>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="24"><strong>论坛用户权限</strong></td>
  </tr>
</table>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="1" cellPadding="3" width="95%" align="center">
	  <tbody>
		<tr>
		  <td class="thead" style="PADDING-LEFT: 10px" noWrap width="12%"><lt:Label res="res.label.forum.admin.user_group_m" key="code"/></td>
		  <td class="thead" noWrap width="15%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
			  <lt:Label res="res.label.forum.admin.user_group_m" key="desc"/></td>
		  <td class="thead" noWrap width="64%"><img src="images/tl.gif" align="absMiddle" width="10" height="15">权限</td>
		  <td width="9%" noWrap class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">
			  <lt:Label key="op"/></td>
		</tr>
  <form name=form_priv<%=k%> action="dir_priv_m.jsp?op=priv" method="post">		
		<tr class="row" style="BACKGROUND-COLOR: #ffffff">
		  <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">
		  <%=UserGroupDb.ALL%>		  </td>
		  <td>全部用户</td>
		  <td>
		  <%
		  UserGroupPrivDb ugpd = new UserGroupPrivDb();
		  ugpd = ugpd.getUserGroupPrivDb(UserGroupDb.ALL, dirCode);
		  %>
		  <input name="view_doc" type="checkbox" value=1 <%=ugpd.getBoolean("view_doc")?"checked":""%>>
		  查看文章
          <input name="download_attach" type="checkbox" value=1 <%=ugpd.getBoolean("download_attach")?"checked":""%>>
下载附件
<input name="group_code" type=hidden value="<%=UserGroupDb.ALL%>">
<input name="dir_code" type=hidden value="<%=dirCode%>">
<input name="dirCode" type=hidden value="<%=dirCode%>"></td>
		  <td><input name="submit23" type=submit value="确定"></td>
		</tr>
  </form>
<%
	while (ir.hasNext()) {
		UserGroupDb ug = (UserGroupDb)ir.next();
		code = ug.getCode();
		desc = ug.getDesc();
		k++;
		%>
        <form name=form_priv<%=k%> action="dir_priv_m.jsp?op=priv" method="post">				
		<tr class="row" style="BACKGROUND-COLOR: #ffffff">
		  <td style="PADDING-LEFT: 10px">&nbsp;<img src="images/arrow.gif" align="absmiddle">&nbsp;<a href="../forum/admin/user_group_op.jsp?op=edit&code=<%=StrUtil.UrlEncode(code)%>"><%=code%></a></td>
		  <td><%=desc%></td>
		  <td><%
		  ugpd = ugpd.getUserGroupPrivDb(code, dirCode);
		  %>
		    <input name="view_doc" type="checkbox" value=1 <%=ugpd.getBoolean("view_doc")?"checked":""%>>
查看文章
  <input name="download_attach" type="checkbox" value=1 <%=ugpd.getBoolean("download_attach")?"checked":""%>>
下载附件
<input name="group_code" type=hidden value="<%=code%>">
<input name="dir_code" type=hidden value="<%=dirCode%>">
<input name="dirCode" type=hidden value="<%=dirCode%>">
<lt:Label res="res.forum.person.UserPrivDb" key="attach_pay"/>
<select name="money_code">
  <option value="">
  <lt:Label key="wu"/>
  </option>
  <%	  
        ScoreMgr sm = new ScoreMgr();
        Vector vscore = sm.getAllScore();
        Iterator irscore = vscore.iterator();
        String str = "";
        while (irscore.hasNext()) {
            ScoreUnit su = (ScoreUnit) irscore.next();
            if (su.isExchange()) {
%>
  <option value="<%=su.getCode()%>"><%=su.getName()%></option>
  <%	  
          }
      }
%>
</select>
<script>
form_priv<%=k%>.money_code.value = "<%=StrUtil.getNullString(ugpd.getString("money_code"))%>";
</script>
<lt:Label res="res.forum.person.UserPrivDb" key="money_sum"/>
<input name="money_sum" size=3 value="<%=ugpd.get("money_sum")%>"></td>
		  <td><input name="submit232" type=submit value="确定"></td>
		</tr>
		</form>
		<%}%>
</table>
<%}%>
</body>
<script language="javascript">
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (form1.pwd.value!=form1.pwd_confirm.value)
		errmsg += "<lt:Label res="res.label.cms.dir" key="msg_check"/>" + "\n"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</html>