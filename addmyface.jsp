<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<title>Modify my icon</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="common.css" type="text/css">
<script language="JavaScript" type="text/JavaScript">
function findObj(theObj, theDoc) {
  var p, i, foundObj;
  
  if(!theDoc) theDoc = document;
  if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
  {
    theDoc = parent.frames[theObj.substring(p+1)].document;
    theObj = theObj.substring(0,p);
  }
  if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
  for (i=0; !foundObj && i < theDoc.forms.length; i++) 
    foundObj = theDoc.forms[i][theObj];
  for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++) 
    foundObj = findObj(theObj,theDoc.layers[i].document);
  if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
  
  return foundObj;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%
// 安全验证
if (!com.redmoon.forum.Privilege.isUserLogin(request))
{
	out.print(StrUtil.p_center(SkinUtil.LoadString(request, SkinUtil.ERR_NOT_LOGIN)));
	return;
}
%>
<%
com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
int level = StrUtil.toInt(cfg.getProperty("forum.signUserLevel"), 0);
UserDb user = new UserDb();
user = user.getUser(com.redmoon.forum.Privilege.getUser(request));
if (level>0 && user.getUserLevelDb().getLevel()<level) {
	UserLevelDb uld = new UserLevelDb();
	uld = uld.getUserLevelDbByLevel(level);
	out.print("<BR>" + StrUtil.format(SkinUtil.LoadString(request, "res.label.forum.user", "faceUserLevel"), new Object[] {uld.getDesc()}));
	return;
}
%>
<table width="100%" height="73" align="center" class="p9">
  <form name="form2" enctype="MULTIPART/FORM-DATA" action="addmyface_do.jsp" method="post">
    <tr> 
      <td height="46"><lt:Label res="res.label.forum.user" key="user_sel_icon"/> 
        <input name=filename type=file id="filename"> <input type=submit value=<lt:Label key="ok"/>> 
        <br></td>
    </tr>
    <tr>
      <td height="16"><lt:Label res="res.label.forum.user" key="icon_desc"/><lt:Label res="res.label.forum.user" key="icon_width"/>
        <%=cfg.getProperty("forum.faceWidth")%>px &nbsp;
        <lt:Label res="res.label.forum.user" key="icon_height"/>
        <%=cfg.getProperty("forum.faceHeight")%>px</td>
    </tr>
  </form>
</table>
</body>
</html>