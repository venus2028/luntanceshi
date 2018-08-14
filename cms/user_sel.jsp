<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.base.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<%
String mode = ParamUtil.get(request, "mode");
%>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="expires" content="wed, 26 Feb 1997 08:21:57 GMT">
<title><lt:Label res="res.label.forum.admin.forum_user_sel" key="select_user"/></title>
<link href="default.css" rel="stylesheet" type="text/css">
<script src="../inc/common.js"></script>
<script language="JavaScript">
<!--
function setPerson(userName, userRealName) {
	window.opener.setPerson(userName, userRealName);
	window.close();
}

function selAllCheckBox(checkboxname){
  var checkboxboxs = document.all.item(checkboxname);
  if (checkboxboxs!=null)
  {
	  if (checkboxboxs.length==null) {
	  checkboxboxs.checked = true;
  }
  for (i=0; i<checkboxboxs.length; i++)
  {
	  checkboxboxs[i].checked = true;
  }
  }
}

function deSelAllCheckBox(checkboxname) {
  var checkboxboxs = document.all.item(checkboxname);
  if (checkboxboxs!=null)
  {
	  if (checkboxboxs.length==null) {
	  checkboxboxs.checked = false;
	  }
	  for (i=0; i<checkboxboxs.length; i++)
	  {
		  checkboxboxs[i].checked = false;
	  }
  }
}

function sel() {
	var names = getCheckboxValue("names");
	if (names=="") {
		alert("请先选择！");
		return;
	}
	if (!confirm("您确定要选择么？"))
		return;
	window.opener.selPerson(names);
	window.close();
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body {
	margin-right: 0px;
	margin-bottom: 0px;
}
.STYLE2 {color: #000000}
-->
</style>
<body bgcolor="#FFFFFF" leftmargin='0' topmargin='5'>
<%
String groupCode = ParamUtil.get(request, "groupCode");
if (groupCode.equals(""))
	groupCode = UserGroup.EVERYONE;
String name = ParamUtil.get(request, "name");
%>
<TABLE style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="100%" align=center>
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%"><font size="-1"><b><lt:Label res="res.label.forum.admin.forum_user_sel" key="select_user"/></b></font> </TD>
    </TR>
    <TR>
      <TD height="175" align="center" bgcolor="#FFFFFF" style="PADDING-LEFT: 10px">
        <table width="90%" border="0" align="center">
          <form name="form1" method="get" action="?"><tr>
            <td height="25" align="center">
			用户组：
			<select name="groupCode">
			<%
			UserGroup ugroup = new UserGroup();
			Vector result = ugroup.list();
			Iterator irR = result.iterator();
			while (irR.hasNext()) {
				ugroup = (UserGroup)irR.next();
			%>
			<option value="<%=ugroup.getCode()%>"><%=ugroup.getDesc()%></option>
			<%
			}		
			%>
			</select>
			<script>
			form1.groupCode.value = "<%=groupCode%>";
			</script>
              <lt:Label res="res.label.forum.admin.forum_user_sel" key="input_nick"/>：
              <input type="text" name="name" style="height:18px;width:100px" value="<%=name%>">
			  <input name="op" value="search" type="hidden" />
              &nbsp;
              <input type="submit" name="Submit" value="<lt:Label res="res.label.forum.admin.forum_user_sel" key="search"/>">
            </td>
            </tr></form>
        </table>
<%
		String sql;
	  	String op = ParamUtil.get(request, "op");
	  	if (op.equals("search")) {
			if (!groupCode.equals(UserGroup.EVERYONE)) {
				sql = "select u.name from users u, user_of_group g where u.name like " + StrUtil.sqlstr("%" + name + "%");
				sql += " and u.name=g.user_name and g.group_code=" + StrUtil.sqlstr(groupCode);
			}
			else
				sql = "select name from users where name like " + StrUtil.sqlstr("%" + name + "%");
		}
		else {
			if (!groupCode.equals(UserGroup.EVERYONE)) {
				sql = "select u.name from users u, user_of_group g";
				sql += " where u.name=g.user_name and g.group_code=" + StrUtil.sqlstr(groupCode);
			}
			else
				sql = "select name from users";
		}
	  	sql += " order by name";
		
		// out.print(sql);
		
		int pagesize = 10;
		User user = new User();

		Paginator paginator = new Paginator(request);
		int curpage = paginator.getCurPage();
		
        ListResult lr = user.listResult(sql, curpage, pagesize);
	    int total = lr.getTotal();
		Iterator ir = lr.getResult().iterator();

		paginator.init(total, pagesize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0) {
			curpage = 1;
			totalpages = 1;
		}	
			
		int i = 0;
		
%>
        <table width="90%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="right"><span class="title1"><%=paginator.getPageStatics(request)%></span></td>
          </tr>
        </table>
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="1">
          <tr align="center">
            <td width="5%" bgcolor="#EFEBDE"><input type="checkbox" onclick="if (this.checked) selAllCheckBox('names'); else deSelAllCheckBox('names')" /></td>
            <td width="27%" height="24" bgcolor="#EFEBDE" class="stable STYLE2">用户名</td>
            <td width="26%" bgcolor="#EFEBDE" class="stable STYLE2">真实姓名</td>
            <td width="25%" bgcolor="#EFEBDE" class="stable STYLE2">描述</td>
            <td width="15%" bgcolor="#EFEBDE" class="stable STYLE2"><lt:Label key="op"/></td>
          </tr>
        <%
		while (ir.hasNext()) {
			i++;
			user = (User)ir.next();
		%>
          <tr align="left">
            <td align="center" bgcolor="#EEEDF3" class="tabStyle_1 percent98"><input type="checkbox" name="names" value="<%=user.getName()%>" />            </td>
            <td width="27%" height="22" align="center" bgcolor="#EEEDF3" class="stable"><%=user.getName()%></td>
            <td width="26%" align="center" bgcolor="#EEEDF3" class="stable"><%=user.getRealName()%></td>
            <td width="25%" align="center" bgcolor="#EEEDF3" class="stable"><%=user.getDesc()%></td>
            <td width="15%" align="center" bgcolor="#EEEDF3" class="stable"><a href="#" onClick="setPerson('<%=user.getName()%>', '<%=user.getRealName()%>')"><lt:Label res="res.label.forum.admin.forum_user_sel" key="select"/></a></td>
          </tr>
        <%}%>
        </table>
        <br>
        <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr>
            <td width="52%" height="23" align="left">
			<input type="button" value="选择" onclick="sel()" >
			</td>
            <td width="48%" align="right"><%
	String querystr = "op=" + op + "&name=" + StrUtil.UrlEncode(name) + "&groupCode=" + StrUtil.UrlEncode(groupCode);
    out.print(paginator.getCurPageBlock("?"+querystr));
%></td>
          </tr>
        </table>
        <br>
      <p> </TD>
    </TR>
    <!-- Table Body End -->
    <!-- Table Foot -->
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
    </TR>
    <!-- Table Foot -->
  </TBODY>
</TABLE>
</body>
</html>                            
  