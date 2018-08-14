<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.bak" key="mgr_login"/></title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
.style2 {color: #FFFFFF}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="backup" scope="page" class="cn.js.fan.util.Backup"/>
<jsp:useBean id="cfg" scope="page" class="cn.js.fan.web.Config"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "backup"))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><lt:Label res="res.label.cms.bak" key="data_mgr"/></td>
    </tr>
  </tbody>
</table>
<br>
<TABLE style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing=0 cellPadding=3 width="95%" align=center>
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%">&nbsp;</TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD height="175" align="center" style="PADDING-LEFT: 10px"><table width="470" border="0" align="center">
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="center"><p>
    <%
	String op = ParamUtil.get(request, "op");
	String rootpath = request.getContextPath();
	String srcpath = cn.js.fan.web.Global.realPath + "upfile/";
	String bakpath = cfg.getProperty("Application.bak_path");
	if (op.equals("file")) {
		try {
		backup.copyDirectory(cn.js.fan.web.Global.realPath+bakpath+"/file",srcpath);//拷贝至file目录下
		out.print(StrUtil.p_center(SkinUtil.LoadString(request,"res.label.cms.bak","success_copyfile")));
		String zipfilepath =cn.js.fan.web.Global.realPath+bakpath+"/bak_cms_file.zip";
		System.out.println("bak_do.jsp srcpath=" + srcpath + " zipfilepath=" + zipfilepath);

			backup.generateZipFile(srcpath, zipfilepath);
			//out.print(StrUtil.p_center("压缩ZIP文件成功！"));
            out.print(StrUtil.p_center(SkinUtil.LoadString(request,"res.label.cms.bak","success_zipfile")));
		%>
		<a href="<%=rootpath+"/"+bakpath%>/bak_cms_file.zip"><lt:Label res="res.label.cms.bak" key="download_zip"/></a>
	<%	}		
		catch (Exception e) {
			out.print(e.getMessage());
		}
	}%>
               </p>
              </td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td height="37">&nbsp;</td>
          <td align="center">&nbsp;</td>
          <td>&nbsp;</td>
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
</body>
</html>