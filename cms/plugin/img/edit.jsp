<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.img.*"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
int imgMaxCount = cfg.getIntProperty("cms.imgMaxCount");	  
int imgDefaultCount = cfg.getIntProperty("cms.imgDefaultCount");
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
ImgDocumentDb idd = new ImgDocumentDb();
idd = idd.getImgDocumentDb(id);
String[][] imgAry = idd.getImageAry();
int len = 0;
if (imgAry!=null)
	len = imgAry.length;
String dir = ParamUtil.get(request, "dir");
%>
<script>
function openWin(url,width,height) {
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,top=50,left=120,width="+width+",height="+height);
}

var imgCount = <%=len%>

function regenerateForm(count) {
	if (count > <%=imgMaxCount%>) {
		count = <%=imgMaxCount%>;
	}
	var dlt = count - imgCount;
	for (var i=0; i<dlt; i++) {
		imgDiv.innerHTML += "<div>图片" + (imgCount+1) + "：<input onmouseover='showImg(this.value)' name='imgUrl" + imgCount + "'/><input onclick=\"SelectImage(addform.imgUrl" + imgCount + ")\" type=\"button\" value=\"选取\"/>	简介：<input name=\"imgDesc" + imgCount + "\"/></div>";
		imgCount++;
	}
}

var urlObj;
function SelectImage(urlObject) {
	urlObj = urlObject;
	openWin("cms/img_frame.jsp?action=selectImage&dir=<%=StrUtil.UrlEncode(dir)%>", 800, 600);
}

function setImgUrl(visualPath) {
	urlObj.value = visualPath;
	showImg(visualPath);
}

function showImg(visualPath) {
	if (visualPath!="")
		imgViewDiv.innerHTML = "<img src='" + visualPath + "' width=200 height=180>";
}
</script>
<table width="100%" border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#E2E6E9" class="9black">
  <tr>
    <td width="73%" height="27" valign="top">缩略图    
    <input name="smallImg" onmouseover='showImg(this.value)' type="text" style="width:154" value="<%=idd.getSmallImg()%>"/>
    <input type="button" name="Submit" value="选择" onclick="SelectImage(addform.smallImg);" /></td>
    <td width="27%" rowspan="4" valign="top" bgcolor="#E7E7EF">
	<div id="imgViewDiv"></div>
	</td>
  </tr>
  <tr>
    <td height="27" valign="top"><input name="imgPageType" type="radio" value="<%=ImgDocumentDb.PAGE_TYPE_SINGLE%>" <%=idd.getPageType()==ImgDocumentDb.PAGE_TYPE_SINGLE?"checked":""%>/>
      单页显示
      <input name="imgPageType" type="radio" value="<%=ImgDocumentDb.PAGE_TYPE_MULTI%>" <%=idd.getPageType()==ImgDocumentDb.PAGE_TYPE_MULTI?"checked":""%>/>
      分多页显示</td>
  </tr>
  <tr>
    <td height="27" valign="top">图片
      <input name="imgNum" type="text" size="8" value="10" />
      <input type='button' value='重新生成表单' onclick="regenerateForm(addform.imgNum.value);" />
		注：最大<%=imgMaxCount%>幅，图片链接允许填写远程网址</td>
  </tr>
  <tr>
    <td height="27" valign="top">
	<div id=imgDiv>
	<%
	for (int i=0; i<len; i++) {
		out.print("<div>图片" + (i+1) + "：<input onmouseover='showImg(this.value)' name='imgUrl" + i + "' value='" + imgAry[i][0] + "'/><input onclick=\"SelectImage(addform.imgUrl" + i + ")\" type=\"button\" value=\"选取\"/>	简介：<input name=\"imgDesc" + i + "\" value='" + imgAry[i][1] + "'/></div>");
	}
	%>
	</div></td>
  </tr>
</table>
<script>
regenerateForm(<%=imgDefaultCount%>);
</script>
