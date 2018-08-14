<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.software.*"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
int softwareMaxCount = cfg.getIntProperty("cms.softwareMaxCount");	  
int softwareDefaultCount = cfg.getIntProperty("cms.softwareDefaultCount");
	
int id = ParamUtil.getInt(request, "id", -1);
if (id==-1) {
	Integer idObj = (Integer)request.getAttribute("docId");
	if (idObj==null) {
		out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "err_id")));
		return;
	}
	else {
		id = idObj.intValue();
	}
}

SoftwareDocumentDb sdd = new SoftwareDocumentDb();
sdd = sdd.getSoftwareDocumentDb(id);
String[] urlAry = sdd.getUrlAry();
int len = 0;
if (urlAry!=null)
	len = urlAry.length;
%>
<script>
function openWin(url,width,height) {
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,top=50,left=120,width="+width+",height="+height);
}

var urlCount = <%=len%>

function regenerateForm(count) {
	if (count > <%=softwareMaxCount%>) {
		count = <%=softwareMaxCount%>;
	}
	var dlt = count - urlCount;
	
	for (var i=0; i<dlt; i++) {
		urlDiv.innerHTML += "<div>地址" + (urlCount+1) + "：<input name='softUrl" + urlCount + "'/><input onclick=\"SelectSoftware(addform.softUrl" + urlCount + ")\" type=\"button\" value=\"选择\"/></div>";
		urlCount++;
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
    <input name="smallImg" onmouseover='showImg(this.value)' type="text" style="width:154" value="<%=sdd.getSmallImg()%>"/>
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
    </select>
	<script>addform.fileType.value="<%=sdd.getFileType()%>"</script>
	</td>
    <td width="11%" valign="top">界面语言：</td>
    <td width="31%" valign="top"><select name="lang">
      <%=bdm.getOptionsStr("lang")%>
    </select>
	<script>addform.lang.value="<%=sdd.getLang()%>"</script>	
	</td>
  </tr>
  <tr>
    <td height="27" valign="top">软件类型：</td>
    <td valign="top">
	<select name="softType"><%=bdm.getOptionsStr("softType")%></select>
	<script>addform.softType.value="<%=sdd.getSoftType()%>"</script>			
	</td>
    <td valign="top">授权方式：</td>
    <td valign="top"><select id="accredit" name="accredit">
        <%=bdm.getOptionsStr("accredit")%></select>
	<script>addform.accredit.value="<%=sdd.getAccredit()%>"</script>		
		</td>
  </tr>
  <tr>
    <td height="27" valign="top">运行环境：</td>
    <td valign="top"><input value="<%=sdd.getOs()%>" name="os" /></td>
    <td valign="top">软件等级：</td>
    <td valign="top"><select name="softRank">
      <%=bdm.getOptionsStr("softRank")%>
    </select>
	<script>addform.softRank.value="<%=sdd.getSoftRank()%>"</script>			
	</td>
  </tr>
  <tr>
    <td height="27" valign="top">官方网址：</td>
    <td valign="top"><input value="<%=sdd.getOfficalUrl()%>" name="officalUrl" /></td>
    <td valign="top">程序演示：</td>
    <td valign="top"><input name="officalDemo" value="<%=sdd.getOfficalDemo()%>"/></td>
  </tr>
  <tr>
    <td height="27" valign="top">软件大小：</td>
    <td colspan="3" valign="top"><input id="fileSize" name="fileSize" value="<%=sdd.getFileSize()%>"/>
      <select id="unit" name="unit">
        <option value="MB" selected="selected">MB</option>
        <option value="KB">KB</option>
        <option value="GB">GB</option>
      </select>
	<script>addform.unit.value="<%=sdd.getUnit()%>"</script>				  
	  </td>
  </tr>
  <tr>
    <td height="27" colspan="4" valign="top">下载地址：
      <input name="softwareNum" type="text" size="8" value="10" />
      <input type='button' value='重新生成表单' onclick="regenerateForm(addform.softwareNum.value);" />
注：最大<%=softwareMaxCount%>个</td>
  </tr>
  <tr>
    <td height="27" colspan="4" valign="top">
	<div id=urlDiv>
	<%
	for (int i=0; i<len; i++) {
		out.print("<div>地址" + (i+1) + "：<input name='softUrl" + i + "' value='" + urlAry[i] + "'/><input onclick=\"SelectSoftware(addform.softUrl" + i + ")\" type=\"button\" value=\"选取\"/></div>");
	}
	%>
	</div></td>
  </tr>
</table>
<script>
regenerateForm(<%=softwareDefaultCount%>);
</script>
