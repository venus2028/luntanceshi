<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%><%@ page import="cn.js.fan.module.cms.plugin.software.*"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
	cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
	int softwareMaxCount = cfg.getIntProperty("cms.softwareMaxCount");	  
	int softwareDefaultCount = cfg.getIntProperty("cms.softwareDefaultCount");  
%>
<script>
function openWin(url,width,height) {
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,top=50,left=120,width="+width+",height="+height);
}

function regenerateForm(count) {
	urlDiv.innerHTML = "";
	if (count > <%=softwareMaxCount%>) {
		count = <%=softwareMaxCount%>;
	}
	for (var i=0; i<count; i++) {
		urlDiv.innerHTML += "<div>地址" + (i+1) + "：<input name='softUrl" + i + "'/><input onclick=\"SelectSoftware(addform.softUrl" + i + ")\" type=\"button\" value=\"选择\"/></div>";
	}
}

var urlObj;
function SelectImage(urlObject) {
	urlObj = urlObject;
	openWin("cms/img_frame.jsp?action=selectImage", 800, 600);
}

function setImgUrl(visualPath) {
	urlObj.value = visualPath;
	showImg(visualPath);
}

var softwareUrlObj;
function SelectSoftware(urlObject) {
	softwareUrlObj = urlObject;
	openWin("cms/software_frame.jsp?action=selectSoftware", 800, 600);
}

function setSoftwareUrl(visualPath) {
	softwareUrlObj.value = visualPath;
}

function showImg(visualPath) {
	if (visualPath!="")
		imgViewDiv.innerHTML = "<img src='" + visualPath + "' width=200 height=180>";
}
</script>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#E2E6E9" class="9black">
  <tr>
    <td height="27" colspan="4" valign="top">缩略图    
    <input name="smallImg" onmouseover='showImg(this.value)' type="text" style="width:154" />
    <input type="button" name="Submit" value="选择" onclick="SelectImage(addform.smallImg);" /></td>
    <td width="27%" rowspan="8" valign="top" bgcolor="#E7E7EF">
	<div id="imgViewDiv"></div>	</td>
  </tr>
  <tr>
    <td width="10%" height="27" valign="top">文件类型：</td>
    <td width="21%" valign="top">
	<%
	BasicDataMgr bdm = new BasicDataMgr();
	%>
	<select name="fileType">
      <%=bdm.getOptionsStr("fileType")%>
    </select></td>
    <td width="11%" valign="top">界面语言：</td>
    <td width="31%" valign="top"><select name="lang">
      <%=bdm.getOptionsStr("lang")%>
    </select></td>
  </tr>
  <tr>
    <td height="27" valign="top">软件类型：</td>
    <td valign="top"><select name="softType"><%=bdm.getOptionsStr("softType")%></select></td>
    <td valign="top">授权方式：</td>
    <td valign="top"><select id="accredit" name="accredit">
        <%=bdm.getOptionsStr("accredit")%></select></td>
  </tr>
  <tr>
    <td height="27" valign="top">运行环境：</td>
    <td valign="top"><input value="Win2003,WinXP,Win2000,Win9X" name="os" /></td>
    <td valign="top">软件等级：</td>
    <td valign="top"><select name="softRank">
      <%=bdm.getOptionsStr("softrank")%>
    </select></td>
  </tr>
  <tr>
    <td height="27" valign="top">官方网址：</td>
    <td valign="top"><input value="http://" name="officalUrl" /></td>
    <td valign="top">程序演示：</td>
    <td valign="top"><input id="officialDemo" name="officalDemo" /></td>
  </tr>
  <tr>
    <td height="27" valign="top">软件大小：</td>
    <td colspan="3" valign="top"><input id="fileSize" name="fileSize" />
      <select id="unit" name="unit">
        <option value="MB" selected="selected">MB</option>
        <option value="KB">KB</option>
        <option value="GB">GB</option>
      </select></td>
  </tr>
  
  <tr>
    <td height="27" colspan="4" valign="top">下载地址：
      <input name="softwareNum" type="text" size="8" value="10" />
      <input type='button' value='重新生成表单' onclick="regenerateForm(addform.softwareNum.value);" />
注：最大<%=softwareMaxCount%>个</td>
  </tr>
  <tr>
    <td height="27" colspan="4" valign="top">
	<div id=urlDiv>	</div></td>
  </tr>
</table>
<script>
regenerateForm(<%=softwareDefaultCount%>);
</script>
