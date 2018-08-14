<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../../inc/inc.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.ui.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>插件管理</title>
<style>
.btn {
border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;
}
</style>
<script language="JavaScript">
<!--
function openWin(url,width,height)
{
	var newwin = window.open(url,"_blank","scrollbars=yes,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}

function form2_onsubmit() {
	var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
	var htmlcode = oEditor.GetXHTML( true );
	form2.abstract.value = htmlcode;
}

function openWin(url,width,height) {
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,top=50,left=120,width="+width+",height="+height);
}

var curObj;
function openSelRecommandWin() {
	curObj = form1.recommand;
	openWin("document_sel.jsp?action=sel", 800, 600);	
}

function openSelImportWin() {
	curObj = form3.importField;
	openWin("document_sel.jsp?action=sel", 800, 600);	
}

function openSelVideoWin() {
	curObj = form4.videoDocId;
	openWin("document_sel.jsp?action=sel", 800, 600);	
}

function selDoc(ids) {
	// 检查是否已包含了ids中的id，避免重复加入
	var ary = ids.split(",");
	var ntc = curObj.value;
	var ary2 = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		var founded = false;
		for (var j=0; j<ary2.length; j++) {
			if (ary[i]==ary2[j]) {
				founded = true;
				break;
			}
		}
		if (!founded) {
			if (ntc=="")
				ntc += ary[i];
			else
				ntc += "," + ary[i];
		}
	}
	curObj.value = ntc;
}

function delRecommand(id) {
	var ntc = form1.recommand.value;
	var ary = ntc.split(",");
	var ary2 = new Array();
	var k = 0;
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			continue;
		}
		else {
			ary2[k] = ary[i];
			k++;
		}
	}
	ntc = "";
	for (i=0; i<ary2.length; i++) {
		if (ntc=="")
			ntc += ary2[i];
		else
			ntc += "," + ary2[i];
	}
	form1.recommand.value = ntc;
	form1.submit();
}

function up(id) {
	var ntc = form1.recommand.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=0) {
				var tmp = ary[i-1];
				ary[i-1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	form1.recommand.value = ntc;
	form1.submit();
}

function down(id) {
	var ntc = form1.recommand.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=ary.length-1) {
				var tmp = ary[i+1];
				ary[i+1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	form1.recommand.value = ntc;
	form1.submit();
}
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "admin"))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

Home home = Home.getInstance();

String op = ParamUtil.get(request, "op");
if (op.equals("setFocus")) {
	String abstract2 = ParamUtil.get(request, "abstract");
	home.setProperty("focus.abstract", abstract2);
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
	return;
}
else if (op.equals("setRecommand")) {
	String recommand = ParamUtil.get(request, "recommand");
	home.setProperty("recommand", recommand);
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
	return;
}
else if (op.equals("setImport")) {
	String importField = ParamUtil.get(request, "importField");
	if (!importField.equals("")) {
		Document doc = new Document();
		doc = doc.getDocument(StrUtil.toInt(importField, -1));
		if (doc==null || !doc.isLoaded()) {
			out.print(StrUtil.Alert_Back("ID=" + importField + " 的文章不存在！"));
			return;
		}
	}
	home.setProperty("importDocId", importField);
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
	return;
}
else if (op.equals("setVideo")) {
	String videoDocId = ParamUtil.get(request, "videoDocId");
	if (!videoDocId.equals("")) {
		Document doc = new Document();
		doc = doc.getDocument(StrUtil.toInt(videoDocId, -1));
		if (doc==null || !doc.isLoaded()) {
			out.print(StrUtil.Alert_Back("ID=" + videoDocId + " 的文章不存在！"));
			return;
		}
	}
	home.setProperty("videoDocId", videoDocId);
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
	return;
}
%>
<script type="text/javascript" src="../../inc/ajaxtabs/ajaxtabs.jsp"></script>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理首页</td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">管理</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <br>
      <br>
      <table width="81%" align="center" class="frame_gray">
        <form id=form2 name=form2 action="?op=setFocus" method=post onSubmit="return form2_onsubmit()">
          <tr>
            <td height="22" class="thead"><strong><a name="focus">今日焦点
              <input name="abstract" type="hidden" value="">
            </a></strong></td>
          </tr>
          
          <tr>
            <td height="22"><pre id="divAbstract" name="divAbstract" style="display:none">
<%=home.getProperty("focus.abstract")%>
        </pre>
                <script type="text/javascript" src="../FCKeditor/fckeditor.js"></script>
                <script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath = '../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = '100%' ;
oFCKeditor.Height = 150 ;
oFCKeditor.Value = divAbstract.innerHTML;

oFCKeditor.Config["LinkBrowser"]=false;//文件
oFCKeditor.Config["ImageBrowser"]=true;
oFCKeditor.Config["FlashBrowser"]=true;

oFCKeditor.Config["LinkUpload"]=false;
oFCKeditor.Config["ImageUpload"]=false;
oFCKeditor.Config["FlashUpload"]=false;

oFCKeditor.Create() ;
//-->
        </script>            </td>
          </tr>
          <tr>
            <td height="22" align="center"><input name="submit2" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
          </tr>
        </form>
      </table>
      <br>
    <br>
    <br>
    <table width="81%" align="center" cellspacing="0" class="frame_gray">
      <form id=form1 name=form1 action="?op=setRecommand" method=post>
        <tr>
          <td height="22" class="thead"><strong><a name="recommand">推荐文章</a></strong>&nbsp;( 编号之间用，分隔 )</td>
        </tr>
        <tr>
          <td height="22"><input type=text value="<%=StrUtil.getNullString(home.getProperty("recommand"))%>" name="recommand" size=60>
              <input name="button" type="button" class="btn" onClick="openSelRecommandWin()" value="选 择">
              <input type="submit" class="btn" value="确 定"></td>
        </tr>
        <tr>
          <td height="22"><%
		  					DocumentMgr dm = new DocumentMgr();
							Document doc = null;
							int[] v = home.getRecommandIds();
							int len = v.length;
							if (len==0)
								out.print("无推荐文章！");
							else {
								for (int k=0; k<len; k++) {
									doc = dm.getDocument(v[k]);
									if (doc!=null && doc.isLoaded()) {
										String color = StrUtil.getNullString(doc.getColor());
										if (color.equals("")) {%>
              <%=doc.getId()%>&nbsp;<img src="images/arrow.gif">&nbsp;<a target="_blank" href="../doc_view.jsp?id=<%=doc.getId()%>"><%=doc.getTitle()%></a>
              <%}else{%>
              <%=doc.getId()%>&nbsp;<img src="images/arrow.gif">&nbsp;<a target="_blank" href="../doc_view.jsp?id=<%=doc.getId()%>"><font color="<%=color%>"><%=doc.getTitle()%></font></a>
              <%}%>
            &nbsp;&nbsp;[<a href="javascript:delRecommand('<%=doc.getId()%>')">
              <lt:Label key="op_del"/>
              </a>]
            <%if (k!=0) {%>
            &nbsp;&nbsp;[<a href="javascript:up('<%=doc.getId()%>')">
              <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="up"/>
              </a>]
            <%}%>
            <%if (k!=len-1) {%>
            &nbsp;&nbsp;[<a href="javascript:down('<%=doc.getId()%>')">
              <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="down"/>
              </a>]
            <%}%>
            <br>
            <%}
			else {%>
            <%=v[k]%>&nbsp;<font color=red><img src="images/arrow.gif">&nbsp;文章不存在</font> &nbsp;&nbsp;[<a href="javascript:delRecommand('<%=v[k]%>')">
              <lt:Label key="op_del"/>
              </a>]<BR>
            <%}
								}
							}%>
          </td>
        </tr>
      </form>
    </table>
    <br>
    <br>
    <table width="81%" align="center" cellspacing="0" class="frame_gray">
      <form id=form3 name=form3 action="home.jsp?op=setImport" method=post>
        <tr>
          <td height="22" class="thead"><strong><a name="import">标题新闻(显示文章的主标题与副标题)</a></strong></td>
        </tr>
        <tr>
          <td height="22"><input type=text value="<%=StrUtil.getNullString(home.getProperty("importDocId"))%>" name="importField" size=60>
              <input name="button2" type="button" class="btn" onClick="openSelImportWin()" value="选 择">
              <input name="submit" type="submit" class="btn" value="确 定"></td>
        </tr>
        <tr>
          <td height="22"><%
							int importId = StrUtil.toInt(home.getProperty("importDocId"), -1);
							if (importId==-1)
								out.print("无！");
							else {
									doc = dm.getDocument(importId);
									if (doc!=null && doc.isLoaded()) {
										String color = StrUtil.getNullString(doc.getColor());
										if (color.equals("")) {%>
              <%=doc.getId()%>&nbsp;<img src="images/arrow.gif">&nbsp;<a target="_blank" href="../doc_view.jsp?id=<%=doc.getId()%>"><%=doc.getTitle()%></a>
              <%}else{%>
              <%=doc.getId()%>&nbsp;<img src="images/arrow.gif">&nbsp;<a target="_blank" href="../doc_view.jsp?id=<%=doc.getId()%>"><font color="<%=color%>"><%=doc.getTitle()%></font></a>
              <%}%>
            &nbsp;<br>
            <%}
			else {%>
            <%=importId%>&nbsp;<font color=red><img src="images/arrow.gif">&nbsp;文章不存在</font> &nbsp;<BR>
            <%}
							}%>
          </td>
        </tr>
      </form>
    </table>
    <br>
    <br>
    <table width="81%" align="center" cellspacing="0" class="frame_gray">
      <form id=form4 name=form4 action="home.jsp?op=setVideo" method=post>
        <tr>
          <td height="22" class="thead"><strong><a name="import">视频</a></strong></td>
        </tr>
        <tr>
          <td height="22"><input type=text value="<%=StrUtil.getNullString(home.getProperty("videoDocId"))%>" name="videoDocId" size=60>
              <input name="button22" type="button" class="btn" onClick="openSelVideoWin()" value="选 择">
              <input name="submit3" type="submit" class="btn" value="确 定"></td>
        </tr>
        <tr>
          <td height="22"><%
							int videoDocId = StrUtil.toInt(home.getProperty("videoDocId"), -1);
							if (videoDocId==-1)
								out.print("无！");
							else {
									doc = dm.getDocument(videoDocId);
									if (doc!=null && doc.isLoaded()) {
										String color = StrUtil.getNullString(doc.getColor());
										if (color.equals("")) {%>
              <%=doc.getId()%>&nbsp;<img src="images/arrow.gif">&nbsp;<a target="_blank" href="../doc_view.jsp?id=<%=doc.getId()%>"><%=doc.getTitle()%></a>
              <%}else{%>
              <%=doc.getId()%>&nbsp;<img src="images/arrow.gif">&nbsp;<a target="_blank" href="../doc_view.jsp?id=<%=doc.getId()%>"><font color="<%=color%>"><%=doc.getTitle()%></font></a>
              <%}%>
            &nbsp;<br>
            <%}
			else {%>
            <%=importId%>&nbsp;<font color=red><img src="images/arrow.gif">&nbsp;文章不存在</font> &nbsp;<BR>
            <%}
							}%>
          </td>
        </tr>
      </form>
    </table>
    <br>
    <br></td>
  </tr>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</body>                                        
</html>                            
  