<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<title><lt:Label res="res.label.cms.priv_op" key="msg_login"/></title>
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
</head>
<body bgcolor="#FFFFFF" text="#000000">
<%
String op = ParamUtil.get(request, "op");
PrivDb pvg = null;
boolean isEdit = false;
if (op.equals("edit")) {
	isEdit = true;
	String priv = ParamUtil.get(request, "priv");
	if (priv.equals("")) {
		StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.cms.priv_op","code_can_not_null"));
		return;
	}
	pvg = new PrivDb(priv);
}
if (op.equals("editdo")) {
	isEdit = true;
	PrivMgr privmgr = new PrivMgr();
	try {
		if (privmgr.update(request))
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"info_op_success")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}	
	String priv = ParamUtil.get(request, "priv");
	if (priv.equals("")) {
		StrUtil.Alert_Back(SkinUtil.LoadString(request, "res.label.cms.priv_op","code_can_not_null"));
		return;
	}
	pvg = privmgr.getPrivDb(priv);
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.cms.priv_op" key="msg_priv"/></td>
    </tr>
  </tbody>
</table>
<br>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%">
	  <%if (isEdit) {%>
	  	  <lt:Label res="res.label.cms.priv_op" key="edit_priv"/>
	  	  <%}else{%>
		  <lt:Label res="res.label.cms.priv_op" key="add_priv"/>
		  <%}%>
	  </TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="175" align="center" style="PADDING-LEFT: 10px"><table class="frame_gray" width="53%" border="0" cellpadding="0" cellspacing="1">
          <tr>
            <td align="center"><table width="71%" border="0" cellpadding="0" cellspacing="0">
                <form name="form1" method="post" action="<%=isEdit?"priv_op.jsp?op=editdo":"priv_m.jsp?op=add"%>">
                  <tr>
                    <td width="91" height="31" align="center"><lt:Label res="res.label.cms.priv_op" key="code"/></td>
                  <td align="left"><input name="priv" value="<%=isEdit?pvg.getPriv():""%>" <%=isEdit?"readonly":""%>></td>
                  </tr>
                  <tr>
                    <td height="32" align="center"><lt:Label res="res.label.cms.priv_op" key="desc"/></td>
                  <td align="left"><input name="desc" value="<%=isEdit?pvg.getDesc():""%>"></td>
                  </tr>
                  <tr>
                    <td colspan="2" align="center">
                    </td>
                  </tr>
                  <tr>
                    <td height="43" colspan="2" align="center"><input name="Submit" type="submit" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.priv_op","submit")%>">
&nbsp;&nbsp;&nbsp;
                      <input name="Submit" type="reset" class="singleboarder" value="<%=SkinUtil.LoadString(request, "res.label.cms.priv_op","reset")%>"></td>
                  </tr>
                </form>
            </table></td>
          </tr>
      </table></TD>
    </TR>
    <!-- Table Body End -->
    <!-- Table Foot -->
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
    </TR>
    <!-- Table Foot -->
  </TBODY>
</TABLE>
<br>
<br>
</body>
</html>