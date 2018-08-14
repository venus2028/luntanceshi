<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.web.*" %>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.cms.ext.*" %>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="com.redmoon.forum.person.UserGroupDb" %>
<%@ page import="com.redmoon.forum.plugin.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<LINK href="../common.css" type=text/css rel=stylesheet>
<LINK href="default.css" type=text/css rel=stylesheet>
<title><lt:Label res="res.label.forum.admin.user_m" key="user_manage"/></title>
<SCRIPT language=javascript>
<!--
function form1_onsubmit() {
	if (form1.pwd.value!=form1.pwd_confirm.value) {
		alert("<lt:Label res="res.label.forum.admin.user_m" key="pwd_not_equal"/>");
		return false;
	}
}

function payForDownloadAtt() {
	var ary = showModalDialog('../point_sel.jsp',window.self,'dialogWidth:526px;dialogHeight:435px;status:no;help:no;');
	if (ary==null)
		return;
	var moneyCode = ary[0];
	var sum = ary[1];
}
//-->
</script></head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="us" scope="page" class="com.redmoon.forum.person.userservice"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="prision" scope="page" class="com.redmoon.forum.life.prision.Prision"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
String op = StrUtil.getNullString(request.getParameter("op"));
String groupCode = ParamUtil.get(request, "group_code");
String dirCode = ParamUtil.get(request, "dir_code");

if (groupCode.equals("")) {
	out.print(SkinUtil.makeInfo(request, "缺少编码"));
	return;
}

Leaf lf = new Leaf();
if (dirCode.equals(""))
	dirCode = Leaf.ROOTCODE;
if (dirCode.equals(Leaf.ROOTCODE))
	dirCode = UserGroupPrivDb.ALLDIR;
	
if (!dirCode.equals("") && !dirCode.equals(UserGroupPrivDb.ALLDIR)) {
	lf = lf.getLeaf(dirCode);
}

UserGroupDb ugd = new UserGroupDb();
ugd = ugd.getUserGroupDb(groupCode);

UserGroupPrivDb upd = new UserGroupPrivDb();
upd = upd.getUserGroupPrivDb(groupCode, dirCode);

if (op.equals("priv")) {
	QObjectMgr qom = new QObjectMgr();
	if (qom.save(request, upd, "cms_forum_user_group_priv_save"))
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "info_op_success")));
	else
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
}

if (op.equals("priv_reset")) {
	upd.del();
	upd.init(groupCode, dirCode);
	upd = upd.getUserGroupPrivDb(groupCode, dirCode);
}
%>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%"><lt:Label res="res.label.forum.admin.user_group_m" key="user_group"/><%=ugd.getDesc()%>
	  &nbsp;&nbsp;目录：
	  <%if (!dirCode.equals(UserGroupPrivDb.ALLDIR)) {%>
	  	<%=lf.getName()%>
	  <%}else{%>
	  	全部
	  <%}%>
	  &nbsp;&nbsp;
	  <lt:Label res="res.label.forum.admin.user_group_m" key="privilege"/></TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD align="center" style="PADDING-LEFT: 10px"><br>
<%if (groupCode.equals(UserGroupDb.ALL)) {%>
<table width="550" border="0" align="center" class="frame_gray" style="display:">
          <form name=form_priv action="forum_user_group_priv.jsp?op=priv" method="post">
            <tr>
              <td>&nbsp;</td>
              <td colspan="2" align="left"><p>&nbsp;</p>
              </td>
            </tr>
            <tr>
              <td width="5%">&nbsp;</td>
              <td width="95%" colspan="2" align="left">
			  <input name="view_doc" type="checkbox" value=1 <%=upd.getBoolean("view_doc")?"checked":""%>>查看文章
			  <input name="download_attach" type="checkbox" value=1 <%=upd.getBoolean("download_attach")?"checked":""%>>
下载附件
<input name="group_code" type=hidden value="<%=groupCode%>">
<input name="dir_code" type=hidden value="<%=dirCode%>"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
                <td colspan="2" align="center">
                  <input name="submit23" type=submit value="<lt:Label key="ok"/>">
                  &nbsp;&nbsp;&nbsp;&nbsp;
                  <input name="submit23" type=button value="<lt:Label res="res.label.forum.admin.user_m" key="reset_privilege"/>" onclick="window.location.href='?group_code=<%=StrUtil.UrlEncode(groupCode)%>&dir_code=<%=StrUtil.UrlEncode(dirCode)%>&op=priv_reset'">			  </td>
            </tr>
          </form>
        </table>
<%} else if (groupCode.equals(UserGroupDb.GUEST)) {%>
        <table width="550" border="0" align="center" class="frame_gray">
          <form name=form_priv action="forum_user_group_priv.jsp?op=priv" method="post">
            <tr>
              <td width="5%">&nbsp;</td>
              <td width="95%" colspan="2" align="left"><input name="view_doc" type="checkbox" value=1 <%=upd.getBoolean("view_doc")?"checked":""%>>
                查看文章
                  <input name="download_attach" type="checkbox" value=1 <%=upd.getBoolean("download_attach")?"checked":""%>>
下载附件
<input name="group_code" type=hidden value="<%=groupCode%>">
<input name="dir_code" type=hidden value="<%=dirCode%>"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
                <td colspan="2" align="center">
                  <input name="submit23" type=submit value="<lt:Label key="ok"/>">
                  &nbsp;&nbsp;&nbsp;&nbsp;
                  <input name="submit23" type=button value="<lt:Label res="res.label.forum.admin.user_m" key="reset_privilege"/>" onclick="window.location.href='?group_code=<%=StrUtil.UrlEncode(groupCode)%>&dir_code=<%=StrUtil.UrlEncode(dirCode)%>&op=priv_reset'">			  </td>
            </tr>
          </form>
        </table>
<%} else {%>
        <table width="550" border="0" align="center" class="frame_gray">
          <form name=form_priv action="forum_user_group_priv.jsp?op=priv" method="post">
            <tr>
              <td width="5%">&nbsp;</td>
              <td width="95%" colspan="2" align="left">
                <input name="view_doc" type="checkbox" value=1 <%=upd.getBoolean("view_doc")?"checked":""%>>
                查看文章
                <input name="download_attach" type="checkbox" value=1 <%=upd.getBoolean("download_attach")?"checked":""%>>
下载附件
<input name="group_code" type=hidden value="<%=groupCode%>">
<input name="dir_code" type=hidden value="<%=dirCode%>">
<br>
<lt:Label res="res.forum.person.UserPrivDb" key="attach_pay"/>
<select name="money_code">
<option value=""><lt:Label key="wu"/></option>
<%	  
        ScoreMgr sm = new ScoreMgr();
        Vector v = sm.getAllScore();
        Iterator ir = v.iterator();
        String str = "";
        while (ir.hasNext()) {
            ScoreUnit su = (ScoreUnit) ir.next();
            if (su.isExchange()) {
%>
      <option value="<%=su.getCode()%>"><%=su.getName()%></option>
<%	  
          }
      }
%>
</select>
<script>
form_priv.money_code.value = "<%=StrUtil.getNullString(upd.getString("money_code"))%>";
</script>
<lt:Label res="res.forum.person.UserPrivDb" key="money_sum"/>
<input name="money_sum" size=3 value="<%=upd.get("money_sum")%>"></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
                <td colspan="2" align="center">
                  <input name="submit23" type=submit value="<lt:Label key="ok"/>">
                  &nbsp;&nbsp;&nbsp;&nbsp;
                  <input name="submit23" type=button value="<lt:Label res="res.label.forum.admin.user_m" key="reset_privilege"/>" onclick="window.location.href='?group_code=<%=StrUtil.UrlEncode(groupCode)%>&dir_code=<%=StrUtil.UrlEncode(dirCode)%>&op=priv_reset'">			  </td>
            </tr>
          </form>
        </table>
<%}%>		
          <br>
          <br>
          <table width="98%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td align="left"><p>权限检查规则：<br>
 检查节点上全部用户组是否允许访问<br>
1、如果允许，则检查所属游客型的IP组，是否有访问权限，如果有，则继续检查所属其它组的权限，如果没有访问权限，则不允许访问，如果没有所属的IP组，则继续检查所属其它组的权限；<br>
2、如果全部用户组不允许访问，则检查所属游客型的IP组是否拥有权限，有则继续检查所属其它用户组的权限，所属IP组没有权限则不允许访问，如果没有所属的IP组，则不允许访问。</p>
            </td>
          </tr>
        </table>
        </TD>
    </TR>
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
</body>
</html>
