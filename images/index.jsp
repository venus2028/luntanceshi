<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import ="com.redmoon.forum.*"%>
<%@ page import ="com.redmoon.forum.ui.*"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "java.io.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html><head><title><lt:Label res="res.label.forum.user" key="emot_list"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<div align="center"><center>
<br>
<script language=javascript>
<!--
function changeface(face)
{
	window.opener.document.frmAnnounce.RealPic.value = face;
	window.opener.showimage();
	window.close();
}
//-->
</script>
<%
String path = Global.getRootPath() + "/forum/images/face/";
FileViewer fileViewer = new FileViewer(cn.js.fan.web.Global.realPath + "/forum/images/face/");
fileViewer.init();
%>
<table border="1" width=80% cellpadding="1" cellspacing="1" bordercolorlight=#333333 bordercolordark=#f8f8f8>
<tr>
  <td align=center><lt:Label res="res.label.forum.user" key="bbs_emot_list"/></td>
<tr><td valign="center">
<table border="1" width="100%" cellspacing="1" cellpadding="1" bordercolorlight=#999999 bordercolordark=#f8f8f8>
<tbody>
<%
int k=0;
while(fileViewer.nextFile()){
  if (fileViewer.getFileName().lastIndexOf("gif") != -1 || fileViewer.getFileName().lastIndexOf("jpg") != -1 || fileViewer.getFileName().lastIndexOf("png") != -1 || fileViewer.getFileName().lastIndexOf("bmp") != -1 && fileViewer.getFileName().indexOf("face") != -1) {
	if (k==0)
		out.print("<tr align=center>");
	String fileName = fileViewer.getFileName();
%>
	<td>&nbsp;<img style='cursor:hand' onClick="changeface('<%=fileName%>')" alt='<lt:Label res="res.label.forum.user" key="check_selected"/>' src="../forum/images/face/<%=fileViewer.getFileName()%>" width="32" height="32" border="0"/></td>		
<%
	k++;	
	if (k==10)
		out.write("</tr>");
	if (k==10) k=0;
 }
}%>
</tbody>
</table>
</table></center>
<p align=center><lt:Label res="res.label.forum.user" key="check_selected"/></p>
</div></body>
</html>