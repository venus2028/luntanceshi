<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import = "cn.js.fan.web.*"%>
<%@ page import = "cn.js.fan.util.*"%>
<%@ page import = "java.io.*"%>
<%@ page import = "cn.js.fan.module.cms.ui.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html><head><title>选择图标</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="images/default.css" rel="stylesheet" type="text/css" />
</head><div align="center"><center>
</center>
<script language=javascript>
<!--
function changeface(face){
	window.opener.selIcon(face);
	window.close();
}
//-->
</script>
<%
com.redmoon.forum.ui.FileViewer fileViewer = new com.redmoon.forum.ui.FileViewer(application.getRealPath("/") + "images/icons/");
fileViewer.init();
%>
<table border="1" width=80% cellpadding="1" cellspacing="1" bordercolorlight=#333333 bordercolordark=#f8f8f8><center>
<tr>
  <td align=center>请点击选择图标</td>
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
	<td>&nbsp;<img style='cursor:hand' onClick="changeface('<%=fileName%>')" alt='<lt:Label res="res.label.forum.user" key="check_selected"/>' src="<%=request.getContextPath()%>/images/icons/<%=fileViewer.getFileName()%>" border="0"/></td>		
<%
	k++;	
	if (k==10)
		out.write("</tr>");
	if (k==10) k=0;
 }
}%>
</tbody>
</table></center>
</table>
</div>
</body>