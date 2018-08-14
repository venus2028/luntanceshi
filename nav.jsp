<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/NavBarTag.tld" prefix="rm" %><link rel="stylesheet" href="index.css" type="text/css">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="100%" colspan="2" bgcolor="#E8F7FD"><table border="0" cellpadding="0" cellspacing="0">
      <tr>
        <rm:NavBarTag type="<%=cn.js.fan.module.nav.Navigation.TYPE_CMS%>">
          <td width="10">&nbsp;</td>
          <td width="84" height="24" align="center"><rm:NavElementTag><a target="_parent" href="$link">$name</a></rm:NavElementTag></td>
        </rm:NavBarTag>
      </tr>
    </table></td>
  </tr>
</table>
