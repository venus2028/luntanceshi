<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.security.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.base.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="cn.js.fan.db.Paginator"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="common.css" rel="stylesheet" type="text/css">
<link href="cms/default.css" rel="stylesheet" type="text/css">
<%@ include file="inc/nocache.jsp"%>
<script type="text/javascript" src="util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("util/jscalendar/calendar-win2k-2.css"); </style>
<jsp:useBean id="strutil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
// 安全验证
if (!privilege.isUserLogin(request)) {
	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.ERR_NOT_LOGIN)));
	return;
}
int id = 0;

String dir_code = ParamUtil.get(request, "dir_code");
if (dir_code.equals(""))
	dir_code = Leaf.ROOTCODE;
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();

String op = ParamUtil.get(request, "op");
op = "add";

if (op.equals("add")) {
	LeafPriv lp = new LeafPriv();
	lp.setDirCode(dir_code);
	/*
	if (!lp.canUserAppend(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	*/
}
%>
<%
String info = ParamUtil.get(request, "info");
if (!info.equals("")) {
	out.print(StrUtil.Alert_Redirect("投稿成功！请等待管理员审核通过！", "index.jsp"));
	return;
}
%>
<title>投稿 - <%=Global.AppName%></title>
<style type="text/css">
<!--
td {  font-family: "Arial", "Helvetica", "sans-serif"; font-size: 14px; font-style: normal; line-height: 150%; font-weight: normal}
.style2 {color: #FF3300}
.STYLE3 {font-weight: bold}
-->
</style>
<script language="JavaScript">
<!--
	function SubmitWithFile(){
		if (document.addform.title.value.length == 0) {
			alert("<lt:Label res="res.label.webedit" key="input_artical_title"/>");
			document.addform.title.focus();			
			return false;
		}
		
		var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
		var htmlcode = oEditor.GetXHTML( true );
		addform.htmlcode.value = htmlcode;
		addform.submit();
	}
	
	function ClearAll() {
		document.addform.title.value=""
		oEdit1.putHTML(" ");
	}
	
// 向编辑器插入指定代码 
function insertHTMLToEditor(codeStr){ 
	var oEditor=FCKeditorAPI.GetInstance( "FCKeditor1"); 
    var win=oEditor.EditorWindow;
    win.focus(); 
    var doc=win.document;
    var rng=doc.selection.createRange(); 
    rng.pasteHTML(codeStr); 
	return;
	  
    var oEditor = FCKeditorAPI.GetInstance("FCKeditor1"); 
    if (oEditor.EditMode==FCK_EDITMODE_WYSIWYG){ 
        oEditor.InsertHtml(codeStr); 
    }else{ 
		alert("请切换编辑器至设计状态！");
        return false; 
    } 
}

function addImg(attchId, imgPath) {
	var img = "<img alt='点击在新窗口中打开' style='cursor:hand' onclick=\"window.open('" + imgPath + "')\" onload=\"if(this.width>screen.width-333)this.width=screen.width-333\" src='" + imgPath + "'>";
	insertHTMLToEditor("<BR>" + img + "<BR>");
	divTmpAttachId.innerHTML += "<input type=hidden name=tmpAttachId value='" + attchId + "'>";
}
//-->
</script>
<script type="text/javascript" src="FCKeditor/fckeditor.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<TABLE width="98%" BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
  <TR valign="top" bgcolor="#FFFFFF">
    <TD width="" height="430" colspan="2" style="background-attachment: fixed; background-image: url(images/bg_bottom.jpg); background-repeat: no-repeat">
          <TABLE cellSpacing=0 cellPadding=0 width="100%">
            <TBODY>
              <TR>
                <TD width="79%" class=head><%
				if (op.equals("add")) {%>
                  &nbsp;
                  我要投稿
                  <%}%>
				</TD>
                <TD width="21%" class=head>&nbsp;</TD>
              </TR>
            </TBODY>
          </TABLE>
	<form name="addform" action="fwebedit_do.jsp?action=post&dir_code=<%=dir_code%>" method="post" enctype="MULTIPART/FORM-DATA">
          <table border="0" cellspacing="1" width="100%" cellpadding="2" align="center">
            <tr>
              <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="unnamed2">
<%
	PluginMgr pm = new PluginMgr();
	PluginUnit pu = pm.getPluginUnitOfDir(dir_code);
	if (pu!=null) {
		IPluginUI ipu = pu.getUI(request);
		IPluginViewAddDocument pv = ipu.getViewAddDocument(dir_code);
		if (!pu.getAddPage().equals("")) {
%>
			<jsp:include page="<%=pu.getAddPage()%>" flush="true"/>
<%		}
		else {		
			out.print(pu.getName(request) + ":&nbsp;" + pv.render(UIAddDocument.POS_TITLE) + "<BR>");
			out.print(pv.render(UIAddDocument.POS_FORM_ELEMENT) + "<BR>");
		}
	}
%>			  </td>
            </tr>
            <tr>
              <td align="left" valign="middle" class="unnamed2"><lt:Label res="res.label.webedit" key="author"/></td>
              <td><input name="author" id="author" type="TEXT" size=30 maxlength=100 style="background-color:ffffff;color:000000;border: 1 double">
			  <input type="hidden" name="docType" value="0">
			  <input type="hidden" name="color" value="">
			  <input type="hidden" name="examine" value="0">
			  <input type="hidden" name="level" value="0">
			  <input type="hidden" name="op" value="contribute">
			  <input type="hidden" name="htmlcode">
			  <input type="hidden" name="pageTemplateId" value=-1>
			  <input type="hidden" name=isuploadfile value="true"></td>
            </tr>
            <tr>
              <td align="left" class="unnamed2" valign="middle"><lt:Label res="res.label.webedit" key="topic"/></td>
              <td width="92%" bgcolor="#FFFFFF">
                  <input name="title" id=me type="TEXT" size=50 maxlength=100 style="background-color:ffffff;color:000000;border: 1 double">			</td>
            </tr>
            <tr>
              <td align="left" class="unnamed2" valign="middle">来源</td>
              <td bgcolor="#FFFFFF"><input name="source" size="30" value="" style="background-color:ffffff;color:000000;border: 1 double"></td>
            </tr>
            <tr>
              <td align="left" class="unnamed2" valign="middle">目&nbsp;录：</td>
              <td bgcolor="#FFFFFF"><span class="unnamed2">
			  <script>
			  var bcode="";
			  </script>
                <select name="dir_code" onChange="if(this.options[this.selectedIndex].value=='not'){alert(this.options[this.selectedIndex].text+' <lt:Label res="res.label.webedit" key="can_not_be_selected"/>'); this.value=bcode; return false;}">
                  <option value="not" selected>
                    <lt:Label res="res.label.webedit" key="select_sort"/>
                  </option>
                  <%
					Leaf lf = dir.getLeaf("root");
					DirectoryView dv = new DirectoryView(lf);
					dv.ShowDirectoryAsOptionsForPost(out, lf, lf.getLayer());
					%>
                </select>
			  <script>
			  bcode=addform.dir_code.value;
			  addform.dir_code.value = "<%=dir_code%>";
			  </script>
              </span></td>
            </tr>
            <tr align="center">
              <td colspan="2" valign="top" bgcolor="#F2F2F2" class="unnamed2">
			  <iframe src="uploadimg.jsp?pageNum=1" width=100% height="28" frameborder="0" scrolling="no"></iframe>
			  <div id="divTmpAttachId" style="display:none"></div>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath = 'FCKeditor/';
// oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.Height = 400 ;

oFCKeditor.Config["LinkBrowser"]=false;//文件
oFCKeditor.Config["ImageBrowser"]=true;
oFCKeditor.Config["FlashBrowser"]=true;

oFCKeditor.Config["LinkUpload"]=false;
oFCKeditor.Config["ImageUpload"]=false;
oFCKeditor.Config["FlashUpload"]=false;

oFCKeditor.Config["SkinPath"] = "skins/<%=cfg.getProperty("cms.fckeditorSkin")%>/";

oFCKeditor.Create() ;
//-->
</script>             </td>
            </tr>
            <tr>
              <td width="8%" align="right" bgcolor="#FFFFFF"><lt:Label res="res.label.webedit" key="notice"/></td>
              <td bgcolor="#FFFFFF">
			  <lt:Label res="res.label.webedit" key="enter_can_use"/>Shift+Enter			  </td>
            </tr>
            <tr>
              <td height="30" colspan=2 align=center bgcolor="#FFFFFF">
			  <%
			  String action = SkinUtil.LoadString(request,"op_add");
			  %>
			  <input name="cmdok" type="button" value=" <%=action%> " onClick="return SubmitWithFile()">
&nbsp;&nbsp;&nbsp;            </tr>
        </table>
    </form></TD>
  </TR>
</TABLE>
<iframe id="hideframe" name="hideframe" src="" width=0 height=0></iframe>
</body>
<script>
function findObj(theObj, theDoc)
{
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
</html>