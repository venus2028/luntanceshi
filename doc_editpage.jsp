<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="cn.js.fan.db.Paginator"%>
<%@ page import="cn.js.fan.module.cms.plugin.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.base.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="common.css" rel="stylesheet" type="text/css">
<link href="cms/default.css" rel="stylesheet" type="text/css">
<%@ include file="inc/nocache.jsp"%>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
Privilege privilege = new Privilege();
String correct_result = SkinUtil.LoadString(request,"info_op_success");
int id = ParamUtil.getInt(request, "doc_id");
Document doc = docmanager.getDocument(request, id, privilege);

String dir_code = doc.getDirCode();
String dir_name;
Document template = null;
Leaf leaf = dir.getLeaf(dir_code);
dir_name = leaf.getName();
int templateId = leaf.getTemplateId();
if (doc!=null) {
	int templateId1 = doc.getTemplateId();
	dir_code = doc.getDirCode();
	if (templateId1!=-1)
		templateId = templateId1;
}

String op = ParamUtil.get(request, "op");
String action = ParamUtil.get(request, "action");
int afterpage=-1;
if (action.equals("insertafter"))
	afterpage = ParamUtil.getInt(request, "afterpage");
	
int pageNum = 1;
if (op.equals("edit")) {
	pageNum = ParamUtil.getInt(request, "CPages");
	
	if (action.equals("changeAttachOrders")) {
		int attachId = ParamUtil.getInt(request, "attachId");
		String direction = ParamUtil.get(request, "direction");
		// 取得第一页的内容
		DocContent dc = new DocContent();
		dc = dc.getDocContent(id, pageNum);
		dc.moveAttachment(attachId, direction);		
	}
}
if (templateId!=-1) {
	template = doc.getDocument(templateId);
}

if (doc!=null)
	id = doc.getID();
%>
<title></title>
<style type="text/css">
<!--
td {  font-family: "Arial", "Helvetica", "sans-serif"; font-size: 14px; font-style: normal; line-height: 150%; font-weight: normal}
-->
</style>
<script language=JavaScript src='scripts/language/schi/editor_lang.js'></script>
<%
if (request.getHeader("User-Agent").indexOf("MSIE")!=-1){
	out.println("<script language=JavaScript src='scripts/editor.js'></script>");
}
else{
	out.println("<script language=JavaScript src='scripts/moz/editor.js'></script>");
}
%>
<script language="JavaScript">
<!--
<%
if (doc!=null) {
	out.println("var id=" + doc.getID() + ";");
}
%>
	var op = "<%=op%>";

	function SubmitWithFileDdxc() {
		var htmlcode = oEdit1.getHTMLBody();
		if (htmlcode=="")
			htmlcode = " ";
		if (op=="edit") {
			addform.webedit.Clear();
			addform.webedit.AddField("id", id);
			addform.webedit.AddField("op", "<%=op%>");
			addform.webedit.AddField("dir_code", "<%=dir_code%>");
			addform.webedit.AddField("pageNum", <%=pageNum%>);
			addform.webedit.SetHtmlCode(htmlcode);
		}
		if (op=="add") {
			addform.webedit.Clear();
			addform.webedit.AddField("id", id);
			addform.webedit.AddField("op", "<%=op%>");
			addform.webedit.AddField("dir_code", "<%=dir_code%>");
			addform.webedit.AddField("action", "<%=action%>");
			addform.webedit.AddField("afterpage", "<%=afterpage%>");
			addform.webedit.SetHtmlCode(htmlcode);
		}
		addform.webedit.MTUpload();
		// 因为Upload()中启用了线程的，所以函数在执行后，会立即反回，使得下句中得不到ReturnMessage的值
		// 原因是此时服务器的返回信息还没收到
		// alert("ReturnMessage=" + addform.webedit.ReturnMessage);
	}

	function SubmitWithFileThread() {
		var htmlcode = oEdit1.getHTMLBody();
		if (htmlcode=="")
			htmlcode = " ";
		if (op=="edit") {
			addform.webedit.Clear();
			addform.webedit.AddField("id", id);
			addform.webedit.AddField("op", "<%=op%>");
			addform.webedit.AddField("dir_code", "<%=dir_code%>");
			addform.webedit.AddField("pageNum", <%=pageNum%>);
			addform.webedit.SetHtmlCode(htmlcode);
		}
		if (op=="add") {
			addform.webedit.Clear();
			addform.webedit.AddField("id", id);
			addform.webedit.AddField("op", "<%=op%>");
			addform.webedit.AddField("dir_code", "<%=dir_code%>");
			addform.webedit.AddField("action", "<%=action%>");
			addform.webedit.AddField("afterpage", "<%=afterpage%>");
			addform.webedit.SetHtmlCode(htmlcode);
		}
		addform.webedit.Upload();
		// 因为Upload()中启用了线程的，所以函数在执行后，会立即反回，使得下句中得不到ReturnMessage的值
		// 原因是此时服务器的返回信息还没收到
		// alert("ReturnMessage=" + addform.webedit.ReturnMessage);
	}

	function SubmitWithFile(){
		var htmlcode = oEdit1.getHTMLBody();
		if (htmlcode=="")
			htmlcode = " ";
		if (op=="edit") {
			addform.webedit.Clear();
			addform.webedit.AddField("id", id);
			addform.webedit.AddField("op", "<%=op%>");
			addform.webedit.AddField("dir_code", "<%=dir_code%>");
			addform.webedit.AddField("pageNum", <%=pageNum%>);
			addform.webedit.SetHtmlCode(htmlcode);
		}
		if (op=="add") {
			addform.webedit.Clear();
			addform.webedit.AddField("id", id);
			addform.webedit.AddField("op", "<%=op%>");
			addform.webedit.AddField("dir_code", "<%=dir_code%>");
			addform.webedit.AddField("action", "<%=action%>");
			addform.webedit.AddField("afterpage", "<%=afterpage%>");
			addform.webedit.SetHtmlCode(htmlcode);
		}
		addform.webedit.UploadArticle();
		if (addform.webedit.ReturnMessage == "<%=correct_result%>")
			doAfter(true);
		else
			doAfter(false);
	}
	
	function SubmitWithoutFile() {
		var htmlcode = oEdit1.getHTMLBody();
		if (htmlcode=="")
			htmlcode = " ";
	
		addform.webedit.Clear();
		addform.webedit.UploadMode = 0;
		if (op=="edit") {
			addform.webedit.AddField("isuploadfile", "false");
			addform.webedit.AddField("id", id);
			addform.webedit.AddField("dir_code", "<%=dir_code%>");
			addform.webedit.AddField("pageNum", <%=pageNum%>);
			addform.webedit.AddField("op", "<%=op%>");
			addform.webedit.SetHtmlCode(htmlcode);
		}
		if (op=="add") {
			addform.webedit.AddField("isuploadfile", "false");
			addform.webedit.AddField("op", "<%=op%>");
			addform.webedit.AddField("dir_code", "<%=dir_code%>");
			addform.webedit.AddField("id", id);
			addform.webedit.AddField("action", "<%=action%>");			
			addform.webedit.AddField("afterpage", "<%=afterpage%>");
			addform.webedit.SetHtmlCode(htmlcode);
		}
		addform.webedit.UploadArticle();
		if (addform.webedit.ReturnMessage == "<%=correct_result%>")
			doAfter(true);
		else
			doAfter(false);		
	}
	
	function ClearAll(){
		document.addform.title.value=""
		oEdit1.putHTML(' ');			
	}
	
	function doAfter(isSucceed) {
		if (isSucceed) {
			if (op=="edit")
			{
				if (confirm("<%=correct_result%> <lt:Label res="res.label.webedit" key="fckwebedit_msg_resfresh"/>"))
					// 此处一定要reload，否则会导致再点击上传（连同文件）时，因为images已被更改，而content中路径未变，从而下载不到，导到最终会丢失			
					// 以前未注意到此问题，可能是因为再点击上传时，获取的图片在服务器端虽然已丢失，但是缓存中可能还有的原因
					// 也可能是因为在编辑文件时，编辑完了并未重新刷新页面，content中的图片还是来源的位置（来源自别的服务器），所以依然能够上传，但是只要此时再一刷新，再连续上传两次，问题就会出现
					window.location.reload(true); 
			}
			else {
				if (confirm("<%=correct_result%> 点击确定将转至文章首页，点击取消继续添加！")) {
					window.location.href = "fwebedit.jsp?op=edit&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&id=<%=id%>";
				}
				else
					window.location.reload(true);
		    }
		}
		else {
			alert(addform.webedit.ReturnMessage);
		}
	}
	
function showvote(isshow)
{
	if (addform.isvote.checked)
	{
		addform.vote.style.display = "";
	}
	else
	{
		addform.vote.style.display = "none";		
	}
}

function window_onload() {
//如果是新建文档
<%if (templateId!=-1 && op.equals("add")) {%>	
	oEdit1.putHTML(divTemplate.innerHTML);
<%}else if (op.equals("edit")){%>
	oEdit1.putHTML(addform.content.value);
<%}%>
}

function selTemplate(id)
{
	if (addform.templateId.value!=id) {
		addform.templateId.value = id;
<%if (doc!=null) {%>		
		window.location.href="fwebedit.jsp?op=edit&action=selTemplate&id=<%=id%>&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>&templateId=" + id;
<%}else{%>
		if (id!=-1)
			window.location.href="fwebedit.jsp?op=add&action=selTemplate&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>&templateId=" + id;		
<%}%>
	}
}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="window_onload()">
<TABLE width="98%" BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
  <TR valign="top" bgcolor="#FFFFFF">
    <TD height="430" colspan="2" style="background-attachment: fixed; background-image: url(/images/bg_bottom.jpg); background-repeat: no-repeat">
          <TABLE cellSpacing=0 cellPadding=0 width="100%">
            <TBODY>
              <TR>
                <TD class=head>
				<%
				if (op.equals("add")) {%>
					<lt:Label res="res.label.doc_editpage" key="add_content"/>&nbsp;--&nbsp;<a href="fwebedit.jsp?op=edit&dir_code=<%=doc.getDirCode()%>&id=<%=doc.getID()%>"><%=doc.getTitle()%>（<lt:Label res="res.label.doc_editpage" key="return_front_page"/>）</a>
					<lt:Label res="res.label.doc_editpage" key="new_page"/>&nbsp;[
					<%if (action.equals("insertafter")) {
						out.print(afterpage + 1);
					}else{
						out.print(doc.getPageCount() + 1);
					}%>
					]
				    <%}else{%>
					<lt:Label res="res.label.doc_editpage" key="modify_content"/>&nbsp;--&nbsp;<a href="fwebedit.jsp?op=edit&dir_code=<%=doc.getDirCode()%>&id=<%=doc.getID()%>"><%=doc.getTitle()%></a>
				<%}%>
				</TD>
              </TR>
            </TBODY>
          </TABLE>
		<form name="addform" action="/fwebedit_do.jsp" method="post">
          <table border="0" cellspacing="1" width="100%" cellpadding="0" align="center">
            <tr align="center" bgcolor="#F2F2F2">
              <td height="20" colspan=2 align=center><b><%=doc!=null?doc.getTitle():""%></b>&nbsp;<input type="hidden" name=isuploadfile value="false">
			  <input type="hidden" name=id value="<%=doc!=null?""+doc.getID():""%>">
<%=doc!=null?"(id:"+doc.getID()+")":""%>			  </td>
            </tr>
<%if (doc!=null && doc.getTemplateId()!=-1) {%>
            <tr align="left" bgcolor="#F2F2F2">
              <td colspan="2" valign="middle" class="unnamed2">
			  &nbsp;<lt:Label res="res.label.doc_editpage" key="template_ID"/>&nbsp;
			  <%
			  if (doc!=null)
			  	templateId = doc.getTemplateId();
			  %>
                <input name="templateId" value="<%=templateId%>" size=3 readonly>
			&nbsp; <span id=templateInfo>
			<a target=_blank href="/admin/doc_template_show.jsp?id=<%=doc.getTemplateId()%>"><lt:Label res="res.label.doc_editpage" key="view_template"/></a>
			<a href="javascript:oEdit1.putHTML(divTemplate.innerHTML)"><lt:Label res="res.label.doc_editpage" key="renew_apply_template"/></a>
			</span>
			</td>
            </tr>
<%}%>
            <tr align="center">
              <td colspan="2" valign="top" bgcolor="#F2F2F2" class="unnamed2">
			  <textarea id="content" name="content" style="display:none">
			  <%if (op.equals("edit")) {
				  String str = doc.getContent(pageNum);
				  if (str!=null)
				  	out.print(str.replaceAll("\"","'"));
			  }%>
			  </textarea>			  
<pre id="idTemporary" name="idTemporary" style="display:none">
<%
if (op.equals("edit")) {
%>
<%=StrUtil.HTMLEncode(StrUtil.getNullString(doc.getContent(pageNum)))%>
<%}%>
</pre>
 <script>
		var oEdit1 = new InnovaEditor("oEdit1");
		oEdit1.width="100%";
		oEdit1.height="500";

		oEdit1.features=["FullScreen","Preview","Print","Search","SpellCheck",
					"Cut","Copy","Paste","PasteWord","PasteText","|","Undo","Redo","|",
					"ForeColor","BackColor","|","Bookmark","Hyperlink",
					"HTMLFullSource","HTMLSource","XHTMLFullSource",
					"XHTMLSource","BRK","Numbering","Bullets","|","Indent","Outdent","LTR","RTL","|","Image","Flash","Media","|","InternalLink","CustomObject","|",
					"Table","Guidelines","Absolute","|","Characters","Line",
					"Form","Clean","ClearAll","BRK",
					"StyleAndFormatting","TextFormatting","ListFormatting","BoxFormatting",
					"ParagraphFormatting","CssText","Styles","|",
					"Paragraph","FontName","FontSize","|",
					"Bold","Italic",
					"Underline","Strikethrough","|","Superscript","Subscript","|",
					"JustifyLeft","JustifyCenter","JustifyRight","JustifyFull"];

	oEdit1.RENDER(document.getElementById("idTemporary").innerHTML);
</script>

              </td>
            </tr>
            <tr>
              <td width="11%" align="right" bgcolor="#FFFFFF"><lt:Label res="res.label.doc_editpage" key="notice"/></td>
              <td width="89%" bgcolor="#FFFFFF">
			  <lt:Label res="res.label.doc_editpage" key="enter_can_be_used"/>Shift+Enter			  </td>
            </tr>
            <tr>
              <td height="25" colspan=2 align="center" bgcolor="#FFFFFF">
			  <%
			  if (op.equals("edit") && doc!=null) {
				  Vector attachments = doc.getAttachments(pageNum);
				  Iterator ir = attachments.iterator();
				  while (ir.hasNext()) {
				  	Attachment am = (Attachment) ir.next(); %>
					<table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="7%" align="center"><img src=images/attach.gif></td>
                        <td width="93%">&nbsp;
                          <input name="attach_name<%=am.getId()%>" value="<%=am.getName()%>" size="30">
&nbsp;<a href="javascript:changeAttachName('<%=am.getId()%>', '<%=doc.getID()%>', '<%="attach_name"+am.getId()%>')"><lt:Label res="res.label.doc_editpage" key="modify_name"/></a>                        &nbsp;<a href="javascript:delAttach('<%=am.getId()%>', '<%=doc.getID()%>')"><%=SkinUtil.LoadString(request,"op_del")%></a>&nbsp;&nbsp;<a target=_blank href="../<%=am.getVisualPath() + "/" + am.getDiskName()%>"><lt:Label res="res.label.doc_editpage" key="view"/></a>&nbsp;
<a href="?op=edit&doc_id=<%=doc.getID()%>&CPages=<%=pageNum%>&action=changeAttachOrders&direction=up&attachId=<%=am.getId()%>"><img src="images/arrow_up.gif" width="16" height="20" border="0" align="absmiddle"></a>&nbsp;
<a href="?op=edit&doc_id=<%=doc.getID()%>&CPages=<%=pageNum%>&action=changeAttachOrders&direction=down&attachId=<%=am.getId()%>"><img src="images/arrow_down.gif"  width="16" height="20" border="0" align="absmiddle"></a></td>
                      </tr>
                    </table>
				<%}
			  }
			  %>
			  </td>
            </tr>
            <tr>
              <td height="153" colspan=2 align=center bgcolor="#FFFFFF">
			  <table  border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
                <tr>
                  <td bgcolor="#FFFFFF"><%
Calendar cal = Calendar.getInstance();
String year = "" + (cal.get(Calendar.YEAR));
String month = "" + (cal.get(Calendar.MONTH) + 1);
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
String filepath = cfg.getProperty("cms.file_webedit") + "/" + year + "/" + month;
String isRelatePath = cfg.getProperty("cms.isRelatePath");
%><object classid="CLSID:DE757F80-F499-48D5-BF39-90BC8BA54D8C" codebase="<%=request.getContextPath()%>/activex/webedit.cab#version=4,0,1,1" width=400 height=280 align="middle" id="webedit">
                      <param name="Encode" value="utf-8">
					  <param name="MaxSize" value="<%=Global.MaxSize%>"> <!--上传字节-->
                      <param name="ForeColor" value="(0,255,0)">
                      <param name="BgColor" value="(0,0,0)">
                      <param name="ForeColorBar" value="(255,255,255)">
                      <param name="BgColorBar" value="(0,0,255)">
                      <param name="ForeColorBarPre" value="(0,0,0)">
                      <param name="BgColorBarPre" value="(200,200,200)">
                      <param name="FilePath" value="<%=filepath%>">
                      <param name="Relative" value="<%=isRelatePath%>">
                      <!--上传后的文件需放在服务器上的路径-->
                      <param name="Server" value="<%=request.getServerName()%>">
                      <param name="Port" value="<%=request.getServerPort()%>">
                      <param name="VirtualPath" value="<%=Global.virtualPath%>">
                      <param name="PostScript" value="<%=Global.virtualPath%>/doc_editpage_do.jsp">
                      <param name="PostScriptDdxc" value="<%=Global.virtualPath%>/ddxc.jsp">
                      <param name="SegmentLen" value="20480">
					  <param name="InternetFlag" value="<%=Global.internetFlag%>">
                    </object></td>
                </tr>
              </table>
              </td>
            </tr>
            <tr>
              <td height="30" colspan=2 align=center bgcolor="#FFFFFF">
			  <%
			  String actiondo = "";
			  if (op.equals("add"))
			  	actiondo = SkinUtil.LoadString(request,"op_add");
			  else
			  	actiondo = SkinUtil.LoadString(request,"op_modify");
			  %>
			  <%if (templateId==-1) {%>
              <input name="cmdok2" type="button" value="<%=actiondo%>(<%=SkinUtil.LoadString(request,"res.label.doc_editpage","duan_dian_upload")%>)" onClick="return SubmitWithFileDdxc()">
              <%}
			  if (templateId==-1) {%>
              <input name="cmdok3" type="button" value="<%=actiondo%>(<%=SkinUtil.LoadString(request,"res.label.doc_editpage","per_thread")%>)" onClick="return SubmitWithFileThread()">
              <%}
			  if (templateId==-1) {%>
              <input name="cmdok" type="button" value=" <%=actiondo%> " onClick="return SubmitWithFile()">
			  <%}%>
&nbsp;
<input name="notuploadfile" type="button" value="<%=actiondo%>(<%=SkinUtil.LoadString(request,"res.label.doc_editpage","can_not_upload")%>)" onClick="return SubmitWithoutFile()">
&nbsp;
      <input name="cmdcancel" type="button" onClick="ClearAll()" value=" <%=SkinUtil.LoadString(request,"res.label.doc_editpage","clear_all")%> ">
&nbsp;
      <%if (op.equals("edit")) {%>
	  <input name="editbtn" type="button" onClick="location.href='doc_abstract.jsp?id=<%=doc.getID()%>'" value=" <%=SkinUtil.LoadString(request,"res.label.doc_editpage","abstract")%> ">
	  <%
	  		String viewPage = "doc_view.jsp";
			PluginMgr pm = new PluginMgr();
			PluginUnit pu = pm.getPluginUnitOfDir(dir_code);
			if (pu!=null) {
				IPluginUI ipu = pu.getUI(request);
				viewPage = ipu.getViewPage();
			}
	  %>
	&nbsp;
	<input name="remsg" type="button" onClick='window.open("<%=viewPage%>?id=<%=id%>")' value="<%=SkinUtil.LoadString(request,"res.label.doc_editpage","browse")%>">
	  <%}%>
&nbsp;
<!--<input name="remsg" type="button" onClick='alert(webedit.ReturnMessage)' value="<%=SkinUtil.LoadString(request,"res.label.doc_editpage","return_info")%>">
&nbsp;--> 
<%if (pageNum!=1) {%>
<input name="remsg" type="button" onClick="window.location.href='doc_editpage_do.jsp?op=del&docId=<%=id%>&pageNum=<%=pageNum%>'" value="<%=SkinUtil.LoadString(request,"op_del")%>">
<%}%>
&nbsp;&nbsp;
<input name="button" type="button" onClick='window.open("doc_view_create.jsp?id=<%=id%>&isCreateHtml=true&CPages=<%=pageNum%>")' value="预览并生成"></td>
            </tr>
          </table>
        </form>
		<table width="100%"  border="0">
          <tr>
            <td align="center">
			<a href="fwebedit.jsp?op=editarticle&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&id=<%=id%>"><lt:Label res="res.label.doc_editpage" key="artical_info"/></a>
			　<lt:Label res="res.label.doc_editpage" key="artical_count"/><%=doc.getPageCount()%><lt:Label res="res.label.doc_editpage" key="pages"/>&nbsp;&nbsp;<lt:Label res="res.label.doc_editpage" key="page"/>
					<%
					int pagesize = 1;
					int total = doc.getPageCount();
					int totalpages;
					Paginator paginator = new Paginator(request, total, pagesize);
					// 设置当前页数和总页数
					totalpages = paginator.getTotalPages();
					if (totalpages==0) {
						totalpages = 1;
					}
					
					String querystr = "op=edit&doc_id=" + id;
					out.print(paginator.getCurPageBlock("doc_editpage.jsp?"+querystr));
					%>
					<%if (op.equals("edit")) {
						if (doc.getPageCount()!=pageNum) {					
					%>
						&nbsp;<a href="doc_editpage.jsp?op=add&action=insertafter&doc_id=<%=doc.getID()%>&afterpage=<%=pageNum%>"><%=SkinUtil.LoadString(request,"res.label.doc_editpage","current_page_insert")%></a>
					<%	}
					}%>
					&nbsp;<a href="doc_editpage.jsp?op=add&doc_id=<%=doc.getID()%>"><%=SkinUtil.LoadString(request,"res.label.doc_editpage","add_page")%></a>			
			</td>
          </tr>
        </table>
	<br></TD>
  </TR>
</TABLE>
<div id=divTemplate style="display:none">
<%if (template!=null) {%>
	<%=template.getContent(1)%>
<%}%>
</div>
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

function changeAttachName(attach_id, doc_id, nm) {
	var obj = findObj(nm);
	document.frames.hideframe.location.href = "fwebedit_do.jsp?op=changeattachname&page_num=<%=pageNum%>&doc_id=" + doc_id + "&attach_id=" + attach_id + "&newname=" + obj.value
}

function delAttach(attach_id, doc_id) {
	if (!window.confirm("<%=SkinUtil.LoadString(request,"confirm_del")%>")) {
		return;
	}
	document.frames.hideframe.location.href = "fwebedit_do.jsp?op=delAttach&page_num=<%=pageNum%>&doc_id=" + doc_id + "&attach_id=" + attach_id
}
</script>
</html>