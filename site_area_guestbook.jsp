<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String siteCode = ParamUtil.get(request, "siteCode");
%>
<form action='site_guestbook.jsp' method='post'>
<table width='100%' height='150' border='0' align='center' cellpadding='1' cellspacing='0' class='guestbook_form_table'>
    <thead>
	<tr>
      <td colspan="3" align='center'>留言</td>
    </tr>
	</thead>
    <tr>
      <td align='center'>用&nbsp;&nbsp;&nbsp;&nbsp;户</td>
      <td width='85%' colspan='2'><input name=username size='15'>
        <input name=siteCode type=hidden value='<%=siteCode%>'>
        &nbsp;
        <input name='isScret' value=1 type=checkbox>
        是否私密 </td>
    </tr>
    <%
        cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
        if (cfg.getBooleanProperty("cms.site_guestbook_validate_code")) {
		%>
    <tr>
      <td align='center'>验证码</td>
      <td colspan='2'><input name="validateCode" type="text" size="1" />
        <img src='<%=request.getContextPath()%>/validatecode.jsp' border=0 align="absmiddle" style="cursor:pointer" onclick="this.src='validatecode.jsp'" alt ="验证码" /> </td>
    </tr>
    <%}%>
    <tr>
      <td width='11%' align='center'>留&nbsp;&nbsp;&nbsp;&nbsp;言</td>
      <td colspan='2'><textarea name='content' cols='41' rows='8'></textarea>      </td>
    </tr>
    <tr>
      <td colspan='3' align='center'><input name='submit' type='submit' value='发送留言'></td>
    </tr>
</table>
</form>
