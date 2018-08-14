<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<LINK href="../../common.css" type=text/css rel=stylesheet>
<title>tree show</title>
</head>
<body>
<div id="newdiv" name="newdiv">
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<%
long rootid = ParamUtil.getLong(request, "id");
String boardcode = ParamUtil.get(request, "boardcode");

MsgDb md = new MsgDb();
String sql = "select id from sq_message where rootid="+rootid+" ORDER BY orders";
MsgBlockIterator irmsg = md.getMsgs(sql, boardcode, (int)rootid, 0, 3000);

long id;
String name="",lydate="",content="",topic="";
int layer = 1;
int i = 1;
if (irmsg.hasNext()) {
	// 写根贴
	irmsg.next();
}
MsgDb rootmd = new MsgDb();
rootmd = rootmd.getMsgDb((int)rootid);

		// 写跟贴
		while (irmsg.hasNext())
		{
		  i++;
		  md = (MsgDb) irmsg.next();
		  
		  id = md.getId();
		  name = md.getName();
		  layer = md.getLayer();
		  topic = md.getTitle();
		  content = md.getContent();
		  lydate = com.redmoon.forum.ForumSkin.formatDateTime(request, md.getAddDate());
	  %>
<table cellspacing=0 cellpadding=0 width="100%" align=center 
border=0>
  <tbody> 
  <tr> 
    <td noWrap align=left bgcolor=#f8f8f8 height="13"> 
      <%
	int pagesize = 10;
	int CPages = (int)Math.ceil((double)i/pagesize);
	layer = layer-1;
	for (int k=1; k<=layer-1; k++)
	{ %>
      <img src="" width=18 height=1>
      <% }%>
      <img src="../../forum/images/join.gif" width="18" height="16">
	  <a href="../showblog.jsp?rootid=<%=rootid%>&userName=<%=rootmd.getName()%>&CPages=<%=CPages%>#<%=id%>" target="_blank"><%=topic%></a> </td>
  </tr>
  </tbody> 
</table>
<%
}%>
</div>
</body>
<SCRIPT language=javascript>
<!--
function trim(str){
   	var i = 0;
    while ((i < str.length)&&((str.charAt(i) == " ")||(str.charAt(i) == "　"))){i++;}
   	var j = str.length-1;
   	while ((j >= 0)&&((str.charAt(j) == " ")||(str.charAt(j) == "　"))){j--;}
   	if( i > j ) 
   		return "";
   	else
   		return str.substring(i,j+1);
}
if (trim(newdiv.innerHTML)!="")
{
	window.parent.followDIV<%=rootid%>.innerHTML = newdiv.innerHTML;
}
window.parent.followImg<%=rootid%>.loaded = "yes";
//-->
</script>
</html>
