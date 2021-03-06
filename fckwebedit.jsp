<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.security.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.base.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="cn.js.fan.db.Paginator"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="common.css" rel="stylesheet" type="text/css">
<link href="cms/default.css" rel="stylesheet" type="text/css">
<script src="inc/common.js"></script>
<script>
function checkWebEditInstalled() {
	var bCtlLoaded = false;
	try	{
		if (typeof(addform.webedit.AddField)=="unknown") {
			bCtlLoaded = true;
		}
	}
	catch (ex) {
	}
	if (!bCtlLoaded) {
		if (confirm("您还没有安装WebEdit在线编辑控件，请点击确定按钮下载安装！")) {
			window.open("<%=request.getContextPath()%>/activex/RecordCtl.EXE");
		}
	}	
}
</script>
<script type="text/javascript" src="util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("util/jscalendar/calendar-win2k-2.css"); </style>
<jsp:useBean id="strutil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String dir_code = ParamUtil.get(request, "dir_code");
String dir_name = ParamUtil.get(request, "dir_name");

int id = 0;

Privilege privilege = new Privilege();
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();

String correct_result = SkinUtil.LoadString(request,"info_op_success");
Document doc = null;
Document template = null;
Leaf leaf = dir.getLeaf(dir_code);

String viewPage = "";
Leaf siteLeaf = null;

String strtemplateId = ParamUtil.get(request, "templateId");
int templateId = Document.NOTEMPLATE;
if (!strtemplateId.trim().equals("")) {
	if (StrUtil.isNumeric(strtemplateId))
		templateId = Integer.parseInt(strtemplateId);
}
if (templateId==Document.NOTEMPLATE) {
	templateId = leaf.getTemplateId();
}

if (templateId!=Document.NOTEMPLATE) {
	template = docmanager.getDocument(templateId);
}
String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	LeafPriv lp = new LeafPriv();
	lp.setDirCode(dir_code);
	if (!lp.canUserAppend(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}

	String action = ParamUtil.get(request, "action");
	if (action.equals("selTemplate")){
		int tid = ParamUtil.getInt(request, "templateId");
		template = docmanager.getDocument(tid);
	}
	dir_name = leaf.getName();	
}
if (op.equals("edit")) {
	String action = ParamUtil.get(request, "action");
	try {
		id = ParamUtil.getInt(request, "id");
		doc = docmanager.getDocument(id);
		dir_code = doc.getDirCode();

		LeafPriv lp = new LeafPriv(doc.getDirCode());
		if (!lp.canUserModifyDoc(doc, privilege.getUser(request))) {
			out.print(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
			return;
		}
		
		if (action.equals("selTemplate")) {
			int tid = ParamUtil.getInt(request, "templateId");
			doc.setTemplateId(tid);
			doc.updateTemplateId();
		}
	} catch (ErrMsgException e) {
		out.print(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
		return;
	}
	
	if (action.equals("changeAttachOrders")) {
		int attachId = ParamUtil.getInt(request, "attachId");
		String direction = ParamUtil.get(request, "direction");
		// 取得第一页的内容
		DocContent dc = new DocContent();
		dc = dc.getDocContent(id, 1);
		dc.moveAttachment(attachId, direction);		
	}
	
	PluginMgr pm = new PluginMgr();
	PluginUnit pu = pm.getPluginUnitOfDir(dir_code);
	if (pu!=null) {
		IPluginUI ipu = pu.getUI(request);
		viewPage = ipu.getViewPage();
	}
	siteLeaf = Leaf.getSubsiteOfLeaf(doc.getDirCode());			
	if (viewPage.equals("")) {
		if (siteLeaf==null)
			viewPage = "doc_view.jsp?id=" + id;
		else {
			SiteDb sd = new SiteDb();
			sd = sd.getSiteDb(siteLeaf.getCode());
			if (sd.getInt("is_customize")==1)
				viewPage = "site_doc.jsp?docId=" + doc.getId() + "&siteCode=" + StrUtil.UrlEncode(siteLeaf.getCode());
			else
				viewPage = siteLeaf.getCode() + "_doc.jsp?docId=" + doc.getId();
		}
	}	
}
if (op.equals("editarticle")) {
	op = "edit";
	try {
		doc = docmanager.getDocumentByCode(request, dir_code, privilege);
		dir_code = doc.getDirCode();

		LeafPriv lp = new LeafPriv();
		lp.setDirCode(doc.getDirCode());
		if (!lp.canUserModify(privilege.getUser(request))) {
			out.print(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
			return;
		}
		
	} catch (ErrMsgException e) {
		out.print(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
		return;
	}
}

if (doc!=null) {
	id = doc.getID();
	Leaf lfn = new Leaf();
	lfn = lfn.getLeaf(doc.getDirCode());
	dir_name = lfn.getName();
}

request.setAttribute("docId", new Integer(id));
%>
<title><%=doc!=null?doc.getTitle():""%></title>
<style type="text/css">
<!--
td {  font-family: "Arial", "Helvetica", "sans-serif"; font-size: 14px; font-style: normal; line-height: 150%; font-weight: normal}
.style2 {color: #FF3300}
.STYLE3 {font-weight: bold}
-->
</style>
<script language=JavaScript src='FCKeditor/formpost.js'></script>
<script language="JavaScript">
<!--
<%
if (doc!=null) {
	out.println("var id=" + doc.getID() + ";");
}
%>
	var op = "<%=op%>";

	function SubmitWithFileDdxc() {
		addform.webedit.isDdxc = 1;
		if (document.addform.title.value.length == 0) {
			alert("<lt:Label res="res.label.webedit" key="input_artical_title"/>");
			document.addform.title.focus();			
			return false;
		}
		loadDataToWebeditCtrl(addform, addform.webedit);
		addform.webedit.MTUpload();
		// 因为Upload()中启用了线程的，所以函数在执行后，会立即反回，使得下句中得不到ReturnMessage的值
		// 原因是此时服务器的返回信息还没收到
		// alert("ReturnMessage=" + addform.webedit.ReturnMessage);
	}

	function SubmitWithFileThread() {
		if (document.addform.title.value.length == 0) {
			alert("<lt:Label res="res.label.webedit" key="input_artical_title"/>");
			document.addform.title.focus();			
			return false;
		}
		loadDataToWebeditCtrl(addform, addform.webedit);
		addform.webedit.Upload();
		// 因为Upload()中启用了线程的，所以函数在执行后，会立即反回，使得下句中得不到ReturnMessage的值
		// 原因是此时服务器的返回信息还没收到
		// alert("ReturnMessage=" + addform.webedit.ReturnMessage);
	}

	function SubmitWithFile(){
		if (document.addform.title.value.length == 0) {
			alert("<lt:Label res="res.label.webedit" key="input_artical_title"/>");
			document.addform.title.focus();			
			return false;
		}
		loadDataToWebeditCtrl(addform, addform.webedit);
		addform.webedit.UploadArticle();
		if (addform.webedit.ReturnMessage == "<%=correct_result%>")
			doAfter(true);
		else
			doAfter(false);
	}
	
	function SubmitWithoutFile() {
		if (document.addform.title.value.length == 0) {
			alert("<lt:Label res="res.label.webedit" key="input_artical_title"/>");
			document.addform.title.focus();	
			return false;
		}

		addform.isuploadfile.value = "false";
		loadDataToWebeditCtrl(addform, addform.webedit);
		addform.webedit.UploadMode = 0;
		addform.webedit.UploadArticle();
		addform.isuploadfile.value = "true";
		if (addform.webedit.ReturnMessage == "<%=correct_result%>")
			doAfter(true);
		else
			doAfter(false);		
	}

	function ClearAll() {
		document.addform.title.value=""
		oEdit1.putHTML(" ");
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
				if (confirm("<%=correct_result%> 点击确定将转至列表，点击取消继续添加！")) {
					window.location.href = "cms/document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(dir_code)%>";
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
	if (addform.isvote.checked)	{
		divVote.style.display = "";
		addform.docType.value = "<%=Document.TYPE_VOTE%>";
	}
	else {
		divVote.style.display = "none";
		addform.docType.value = "<%=Document.TYPE_DOC%>";
	}
}

function selTemplate(id)
{
	if (addform.templateId.value!=id) {
		addform.templateId.value = id;
		// 此处注意当模式对话框的路径在admin下时，退出后本页路径好象被改为admin了
<%if (doc!=null) {%>
		window.location.href="../fckwebedit.jsp?op=edit&action=selTemplate&id=<%=id%>&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>&templateId=" + id;
<%}else{%>
		if (id!=-1)
			window.location.href="../fckwebedit.jsp?op=add&action=selTemplate&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>&templateId=" + id;		
<%}%>
	}
}

// 编辑文件
function editdoc(doc_id, file_id)
{
	addform.redmoonoffice.AddField("doc_id", doc_id);
	addform.redmoonoffice.AddField("file_id", file_id);
	addform.redmoonoffice.Open("http://<%=Global.server%>:<%=Global.port%>/<%=Global.virtualPath%>/word_get.jsp?doc_id=" + doc_id + "&file_id=" + file_id);
}

// 控件完成上传后，调用Operate()
function OfficeOperate() {
	// alert(addform.redmoonoffice.ReturnMessage);
}

function selectNode(code, name) {
	addform.dir_code.value = code;
	$("dirNameSpan").innerHTML = name;
}
//-->
</script>
<script type="text/javascript" src="FCKeditor/fckeditor.js"></script>
</head>
<body text="#000000" onLoad="checkWebEditInstalled()">
<TABLE cellSpacing=0 cellPadding=0 width="100%">
            <TBODY>
              <TR>
                <TD width="79%" class=head><%
			Leaf lf = leaf;
			String navstr = "";
			String parentcode = lf.getParentCode();
			Leaf plf = new Leaf();
			while (!parentcode.equals("root")) {
				plf = plf.getLeaf(parentcode);
				if (plf==null || !plf.isLoaded())
					break;
				if (plf.getType()==Leaf.TYPE_LIST && plf.getChildCount()!=0)
					navstr = "<a href='cms/dir_frame.jsp?root_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				else if (plf.getType()==Leaf.TYPE_LIST && plf.getChildCount()==0)
					navstr = "<a href='cms/document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				else if (plf.getType()==Leaf.TYPE_NONE) {
					navstr = "<a href='cms/dir_frame.jsp?root_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;				
				}
				else
					navstr = "<a href='cms/document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				if (plf.getType()==Leaf.TYPE_SUB_SITE) {
					break;
				}				
				parentcode = plf.getParentCode();
			}
			out.print(navstr);
				
				if (op.equals("add")) {%>
                  <a href="cms/document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>"><%=dir_name%></a>&nbsp;
                  <%}else{%>
                  <%
					Leaf dlf = new Leaf();
					if (doc!=null) {
						dlf = dlf.getLeaf(doc.getDirCode());
					}
					if (doc!=null && dlf.getType()==2) {%>
                  <a href="cms/document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>"><%=dlf.getName()%></a>
                  <%}else{%>
                  <%=dir_name%>
                  <%}%>
                <%}%></TD>
              </TR>
            </TBODY>
          </TABLE>
		  <br>
	  <table width="98%" align="center" class="p9">
        <tr>
          <td>
		<a href="fckwebedit_new.jsp?op=<%=op%>&id=<%=id%>&dir_code=<%=StrUtil.UrlEncode(dir_code)%>">普通方式</a>	
		<%if (op.equals("edit")) {%>
		  ┆	
		  <a href="cms/comment_m.jsp?doc_id=<%=doc.getID()%>"><lt:Label res="res.label.webedit" key="mgr_comment"/></a>
		  ┆	
		  <a href="doc_fck_abstract_new.jsp?id=<%=doc.getID()%>"><%=SkinUtil.LoadString(request,"res.label.webedit","abstract")%></a>
		  ┆		  
		  <a href="<%=viewPage%>" target="_blank"><%=SkinUtil.LoadString(request,"res.label.webedit","browse")%></a>
	  	<%}%>
		  </td>
        </tr>
      </table>		  
		<form name="addform" action="/admin/fwebedit_do.jsp" method="post">
          <table class="eTab" border="0" cellspacing="1" width="100%" cellpadding="2" align="center">
            <thead>
			<tr align="center">
              <td height="20" colspan=2 align=center><b><%=doc!=null?doc.getTitle():""%>&nbsp;<input type="hidden" name=isuploadfile value="true">
			  <input type="hidden" name=id value="<%=doc!=null?""+doc.getID():""%>">
			<%=doc!=null?"(id:"+doc.getID()+")":""%>
			  <%if (op.equals("add")) {%>
			  <lt:Label res="res.label.webedit" key="add_content_to"/>
			  <%}%></b>			
			</td>
			</tr>
			</thead>
            <tr>
              <td colspan="2" align="left" valign="middle" class="unnamed2">
<%
// 如果是加入新文章
if (doc==null) {			  
	PluginMgr pm = new PluginMgr();
	PluginUnit pu = pm.getPluginUnitOfDir(dir_code);
	if (pu!=null) {
		IPluginUI ipu = pu.getUI(request);
		IPluginViewAddDocument pv = ipu.getViewAddDocument(dir_code);
		if (!pu.getAddPage().equals("")) {
%>
			<jsp:include page="<%=pu.getAddPage()%>" flush="true">
			<jsp:param name="dir" value="<%=dir_code%>" />
			</jsp:include>
<%		}
		else {		
			out.print(pu.getName(request) + ":&nbsp;" + pv.render(UIAddDocument.POS_TITLE) + "<BR>");
			out.print(pv.render(UIAddDocument.POS_FORM_ELEMENT) + "<BR>");
		}
	}
}
else {
	PluginMgr pm = new PluginMgr();
	PluginUnit pu = pm.getPluginUnitOfDir(dir_code);
	if (pu!=null) {
		IPluginUI ipu = pu.getUI(request);
		IPluginViewEditDocument pv = ipu.getViewEditDocument(doc);
		if (!pu.getEditPage().equals("")) {
%>
			<jsp:include page="<%=pu.getEditPage()%>" flush="true">
			<jsp:param name="dir" value="<%=doc.getDirCode()%>" />
			</jsp:include>
<%		}
		else {		
			out.print(pu.getName(request) + ":&nbsp;" + pv.render(UIAddDocument.POS_TITLE) + "<BR>");
			out.print(pv.render(UIAddDocument.POS_FORM_ELEMENT) + "<BR>");
		}
	}
}
%>			  </td>
            </tr>
            <tr>
              <td align="left" valign="middle" class="unnamed2"><lt:Label res="res.label.webedit" key="author"/></td>
              <td><input name="author" id="author" type="TEXT" size=30 maxlength=100 value="<%=doc!=null?doc.getAuthor():privilege.getUser(request)%>">
			  <input type="hidden" name="op" value="<%=op%>">
			  &nbsp;<span class="unnamed2">类型：
              <select name="docType">
                <option value="0">文章</option>
                <option value="1">投票</option>
                <option value="2">链接</option>
              </select>
              <%if (doc!=null) {%>
              <script>
				addform.docType.value = "<%=doc.getType()%>";
				</script>
              <%}%>
			  </span>&nbsp;<span class="unnamed2">
			  <lt:Label res="res.label.webedit" key="source"/>
              <input name="source" value="<%=StrUtil.getNullStr(doc==null?"":doc.getSource())%>">
              (类型为链接，则填写链接地址)</span></td>
            </tr>
            <tr>
              <td align="left" class="unnamed2" valign="middle"><lt:Label res="res.label.webedit" key="topic"/></td>
              <td width="92%">
                  <input name="title" id=me type="TEXT" size=50 maxlength=100 value="<%=doc!=null?StrUtil.toHtml(doc.getTitle()):""%>">                  
                  <span class="unnamed2"><font color="#FF0000">＊</font></span>			  <select name="color">
                    <option value="" style="COLOR: black" selected>显示颜色</option>
                    <option style="BACKGROUND: #000088" value="#000088"></option>
                    <option style="BACKGROUND: #0000ff" value="#0000ff"></option>
                    <option style="BACKGROUND: #008800" value="#008800"></option>
                    <option style="BACKGROUND: #008888" value="#008888"></option>
                    <option style="BACKGROUND: #0088ff" value="#0088ff"></option>
                    <option style="BACKGROUND: #00a010" value="#00a010"></option>
                    <option style="BACKGROUND: #1100ff" value="#1100ff"></option>
                    <option style="BACKGROUND: #111111" value="#111111"></option>
                    <option style="BACKGROUND: #333333" value="#333333"></option>
                    <option style="BACKGROUND: #50b000" value="#50b000"></option>
                    <option style="BACKGROUND: #880000" value="#880000"></option>
                    <option style="BACKGROUND: #8800ff" value="#8800ff"></option>
                    <option style="BACKGROUND: #888800" value="#888800"></option>
                    <option style="BACKGROUND: #888888" value="#888888"></option>
                    <option style="BACKGROUND: #8888ff" value="#8888ff"></option>
                    <option style="BACKGROUND: #aa00cc" value="#aa00cc"></option>
                    <option style="BACKGROUND: #aaaa00" value="#aaaa00"></option>
                    <option style="BACKGROUND: #ccaa00" value="#ccaa00"></option>
                    <option style="BACKGROUND: #ff0000" value="#ff0000"></option>
                    <option style="BACKGROUND: #ff0088" value="#ff0088"></option>
                    <option style="BACKGROUND: #ff00ff" value="#ff00ff"></option>
                    <option style="BACKGROUND: #ff8800" value="#ff8800"></option>
                    <option style="BACKGROUND: #ff0005" value="#ff0005"></option>
                    <option style="BACKGROUND: #ff88ff" value="#ff88ff"></option>
                    <option style="BACKGROUND: #ee0005" value="#ee0005"></option>
                    <option style="BACKGROUND: #ee01ff" value="#ee01ff"></option>
                    <option style="BACKGROUND: #3388aa" value="#3388aa"></option>
                    <option style="BACKGROUND: #000000" value="#000000"></option>
                  </select>
                  <%if (doc!=null) {%>
                  <script>
				addform.color.value = "<%=StrUtil.getNullStr(doc.getColor())%>";
				  </script>
                  <%}%>
                  <%
				  String strExpireDate = "";
				  if (doc!=null) {
				  	strExpireDate = DateUtil.format(doc.getExpireDate(), "yyyy-MM-dd");
				  %>
                  <input type="checkbox" name="isBold" value="true" <%=doc.isBold()?"checked":""%> >
                  <%}else{%>
                  <input type="checkbox" name="isBold" value="true" >
                  <%}%>
标题加粗 
                  到期时间：
					<input type="text" id="expireDate" name="expireDate" size="10" value="<%=strExpireDate%>">
<script type="text/javascript">
    Calendar.setup({
        inputField     :    "expireDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
</script>				</td>
            </tr>
            <tr>
              <td align="left" class="unnamed2" valign="middle">副标题：</td>
              <td><input name="subtitle" id=subtitle type="TEXT" size=50 maxlength=100 value="<%=doc!=null?StrUtil.toHtml(doc.getSubtitle()):""%>"></td>
            </tr>
            <tr>
              <td align="left" valign="middle" class="unnamed2"><lt:Label res="res.label.webedit" key="key_words"/></td>
              <td><input name="keywords" id=keywords type="TEXT" size=30 maxlength=100 value="<%=StrUtil.getNullStr(doc==null?dir_code:doc.getKeywords())%>">
                <lt:Label res="res.label.webedit" key="divide"/>
                <span class="unnamed2">
                <%
			String strRelateChecked = "";
			if (doc!=null && doc.getIsRelateShow())
				strRelateChecked = "checked";
			%>
&nbsp;&nbsp;<lt:Label res="res.label.webedit" key="relative_artical"/>
<input type="checkbox" name="isRelateShow" value="1" <%=strRelateChecked%>>
<lt:Label res="res.label.webedit" key="display"/></span></td>
            </tr>
            <tr align="left">
              <td align="left" valign="middle" class="unnamed2"><lt:Label res="res.label.webedit" key="comments"/></td>
            <td valign="middle" class="unnamed2"><%
			String strChecked = "";
			if (doc!=null) {
				if (doc.getCanComment())
					strChecked = "checked";
			}
			else
				strChecked = "checked";
			%>
              <input type="checkbox" name="canComment" value="1" <%=strChecked%>>
<lt:Label res="res.label.webedit" key="enable"/>
<input type="hidden" name="isHome" value="false">
&nbsp;&nbsp;<span class="style2">
<lt:Label res="res.label.webedit" key="check"/></span>
<%
LeafPriv lp = new LeafPriv(dir_code);
if (lp.canUserExamine(privilege.getUser(request))) {
%>
	<select name="examine">
	  <option value="0"><lt:Label res="res.label.webedit" key="has_not_checked"/></option>
	  <option value="1"><lt:Label res="res.label.webedit" key="has_not_passed"/></option>
	  <option value="2" selected><lt:Label res="res.label.webedit" key="has_passed"/></option>
	  <option value="<%=Document.EXAMINE_DRAFT%>">草稿</option>	  
	</select>
<%}else{
	if (op.equals("edit")) {
		if (doc.getExamine()==Document.EXAMINE_PASS) {
%>
			<select name="examine">
			  <option value="2" selected><lt:Label res="res.label.webedit" key="has_passed"/></option>
			  <option value="<%=Document.EXAMINE_DRAFT%>">草稿</option>	  
			</select>
<%		}
		else {%>
			<select name="examine">
			  <option value="0"><lt:Label res="res.label.webedit" key="has_not_checked"/></option>
			  <option value="1"><lt:Label res="res.label.webedit" key="has_not_passed"/></option>
			  <option value="<%=Document.EXAMINE_DRAFT%>">草稿</option>	  
			</select>
		<%}
	}
	else {%>
	<select name="examine">
	  <option value="0"><lt:Label res="res.label.webedit" key="has_not_checked"/></option>
	  <option value="<%=Document.EXAMINE_DRAFT%>">草稿</option>	  
	</select>
	<%}
}
%>
<%if (doc!=null) {%>
	<script>
	addform.examine.value = "<%=doc.getExamine()%>";
	</script>
<%}%>
<%
String checknew = "";
if (doc!=null && doc.getIsNew()==1)
	checknew = "checked";
%>
<input type="checkbox" name="isNew" value="1" <%=checknew%>>
<img src="images/i_new.gif" width="18" height="7">
<select name="pageType">
<option value="<%=Document.PAGE_TYPE_MANUAL%>">手工分页</option>
<option value="<%=Document.PAGE_TYPE_TAG%>">按标签分页</option>
</select>
<%if (doc!=null) {%>
		<script>
		addform.pageType.value = "<%=doc.getPageType()%>";
		</script>
	<%}%>
排序号：
<input name="level" size=2 value="<%=(doc!=null)?doc.getLevel():0%>"></td>
            </tr>
            <tr align="left">
              <td colspan="2" valign="middle" class="unnamed2">
			  <lt:Label res="res.label.webedit" key="sort"/>
			  <%if (doc!=null) {%>		
					<span id="dirNameSpan"><%=leaf.getName()%></span>&nbsp;[<a href="javascript:openWin('cms/dir_sel.jsp?dirCode=<%=lf.getCode()%>', 480, 360)">选择</a>]
					<input name="dir_code" type="hidden" value="<%=lf.getCode()%>">						
				<%}else{%>
					<span id="dirNameSpan"><%=leaf.getName()%></span>&nbsp;[<a href="javascript:openWin('cms/dir_sel.jsp', 480, 360)">选择</a>]				
					<input type=hidden name="dir_code" value="<%=dir_code%>">
				<%}%>
  			    <input name="pageTemplateId" type="hidden" value="<%=doc==null?"":"" + doc.getPageTemplateId()%>">
  			    发布时间：
				<input name="createDate" value="<%=doc==null?"":DateUtil.format(doc.getCreateDate(), "yyyy-MM-dd HH:mm:ss")%>">
<script type="text/javascript">
    Calendar.setup({
        inputField     :    "createDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d %H:%M:00",       // format of the input field
        showsTime      :    true,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
</script>						
				<%if (doc==null) {%>(为空表示当前时间)<%}%></td>
            </tr>
            <tr align="left">
              <td colspan="2" valign="middle" class="unnamed2">
              <%
			  String subjects = "", subjectNames = "";
			  if (doc!=null) {
			  	SubjectMgr sm = new SubjectMgr();
				SubjectListDb sld = new SubjectListDb();
				String[] subjectAry = sld.getSubjectsOfDoc(doc.getId());
				if (subjectAry!=null) {
					int sublen = subjectAry.length;
					for (int m=0; m<sublen; m++) {
					  	SubjectDb sd = sm.getSubjectDb(subjectAry[m]);
						if (subjects.equals("")) {
							subjects = sd.getCode();
							subjectNames = sd.getName();
						}
						else {
							subjects += "," + sd.getCode();
							subjectNames += "," + sd.getName();
						}
					}
				}
			  }
			  %>
			  <%//if (!Leaf.isLeafOfSubsite(dir_code)) {%>
			  所属专题：<span class="TableData">
                <input name="subjectNames" size="50" readonly id="subjectNames" value="<%=subjectNames%>" />
                <input title="添加" onClick="openWinSubjects()" type="button" value="添 加" name="button2">
              </span>
			  <%//}%>
                <input type="hidden" name="subjects" value="<%=subjects%>">
                <input type="hidden" name="editFlag" value="redmoon">
			  </td>
            </tr>
            <tr>
              <td align="right" valign="middle" class="unnamed2">
		<%
		String display="none",ischecked="false", isreadonly = "";
		if (doc!=null) {
			// if (doc.getType()==1) {
				display = "none";
				ischecked = "checked disabled";
				isreadonly = "readonly";
			// }
		}%>
					  <input type="checkbox" name="isvote" value="1" onClick="showvote()" <%=ischecked%>>
              <lt:Label res="res.label.webedit" key="vote"/></td>
              <td valign="middle">
			  <div id="divVote" style="display:<%=display%>">
                <lt:Label res="res.label.forum.addtopic" key="vote_expire"/>
                <input name="expire_date">
                <script type="text/javascript">
    Calendar.setup({
        inputField     :    "expire_date",      // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
                </script>
                <lt:Label res="res.label.forum.addtopic" key="vote_max_choice"/>
                <input name="max_choice" size=1 value="1">
                <lt:Label res="res.label.forum.addtopic" key="vote_item"/>
                <br>
              <textarea <%=isreadonly%> cols="60" name="vote" rows="8" wrap="VIRTUAL" title="<%=SkinUtil.LoadString(request,"res.label.webedit","input_vote_choose")%>"></textarea>
              <lt:Label res="res.label.webedit" key="per_choose"/>&nbsp;&nbsp;<lt:Label res="res.label.webedit" key="editing_can_not_be_vote"/>
			  </div>			  </td>
            </tr>
            <tr align="center">
              <td colspan="2" valign="top" class="unnamed2">
<pre id="idTemporary" name="idTemporary" style="display:none">
<%
if (!op.equals("add")) {
%>
<%=strutil.getNullString(doc.getDocContent(1).getContent())%>
<%}%>
</pre>

<pre id="divTemplate" name="divTemplate" style="display:none">
<%if (template!=null) {%>
	<%=template.getContent(1)%>
<%}%>
</pre>

<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath = 'FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_cms.jsp?dir=' + '<%=StrUtil.UrlEncode(dir_code)%>' ;
<%if (templateId!=-1 && doc==null) {%>	
	oFCKeditor.Value = document.getElementById("divTemplate").innerHTML;
<%}else{%>
	oFCKeditor.Value = document.getElementById("idTemporary").innerHTML;
<%}%>
oFCKeditor.Height = 400 ;

oFCKeditor.Config["LinkBrowser"]=false;//文件
oFCKeditor.Config["ImageBrowser"]=true;
oFCKeditor.Config["FlashBrowser"]=true;

oFCKeditor.Config["LinkUpload"]=false;
oFCKeditor.Config["ImageUpload"]=false;
oFCKeditor.Config["FlashUpload"]=false;

oFCKeditor.Config["MediaBrowser"]=true;//文件

oFCKeditor.Config["SkinPath"] = "skins/<%=cfg.getProperty("cms.fckeditorSkin")%>/";

oFCKeditor.Create() ;
//-->
</script>             </td>
            </tr>
            <tr>
              <td width="8%" align="right"><lt:Label res="res.label.webedit" key="notice"/></td>
              <td>
			  <lt:Label res="res.label.webedit" key="enter_can_use"/>Shift+Enter</td>
            </tr>
			  <%
			  if (doc!=null) {
				  Vector attachments = doc.getAttachments(1);
				  Iterator ir = attachments.iterator();
				  while (ir.hasNext()) {
				  	Attachment am = (Attachment) ir.next(); %>
                      <tr>
                        <td align="center"><img src=images/attach.gif width="17" height="17"></td>
                        <td>&nbsp;
                          <input name="attach_name<%=am.getId()%>" value="<%=am.getName()%>" size="30">
						&nbsp;<a href="javascript:changeAttachName('<%=am.getId()%>', '<%=doc.getID()%>', '<%="attach_name"+am.getId()%>')"><lt:Label res="res.label.webedit" key="modify"/></a>                        &nbsp;<a href="javascript:delAttach('<%=am.getId()%>', '<%=doc.getID()%>')"><%=SkinUtil.LoadString(request,"op_del")%></a>&nbsp;&nbsp;<a target=_blank href="<%=am.getVisualPath() + "/" + am.getDiskName()%>"><lt:Label res="res.label.webedit" key="view"/></a>&nbsp;&nbsp;&nbsp;<a href="?op=edit&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>&id=<%=doc.getID()%>&action=changeAttachOrders&direction=up&attachId=<%=am.getId()%>"><img src="images/arrow_up.gif" alt="往上" width="16" height="20" border="0" align="absmiddle"></a>&nbsp;<a href="?op=edit&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>&id=<%=doc.getID()%>&action=changeAttachOrders&direction=down&attachId=<%=am.getId()%>"><img src="images/arrow_down.gif" alt="<lt:Label res="res.label.webedit" key="down"/>" width="16" height="20" border="0" align="absmiddle"></a></td>
                      </tr>
			  <%}
			  }
			  %>
            <tr>
              <td height="153" colspan=2 align=center>
			  <table  border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
                <tr>
                  <td><%
Calendar cal = Calendar.getInstance();
String year = "" + (cal.get(cal.YEAR));
String month = "" + (cal.get(cal.MONTH) + 1);
String filepath = cfg.getProperty("cms.file_webedit") + "/" + year + "/" + month;
String isRelatePath = cfg.getProperty("cms.isRelatePath");
if (isRelatePath.equals("1"))
	isRelatePath = "2";
	
boolean isWebEditShowHighOption = cfg.getBooleanProperty("cms.isWebEditShowHighOption");
int height = 280;
if (!isWebEditShowHighOption)
	height = 173;
%>

<object classid="CLSID:DE757F80-F499-48D5-BF39-90BC8BA54D8C" codebase="<%=request.getContextPath()%>/activex/webedit.cab#version=6,0,2,1" width=400 height=<%=height%> align="middle" id="webedit">
                      <param name="Encode" value="utf-8">
					  <param name="MaxSize" value="<%=Global.MaxSize%>"> <!--上传字节-->
                      <param name="ForeColor" value="(255,255,255)">
                      <param name="BgColor" value="(107,154,206)">
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
                      <param name="PostScript" value="<%=Global.virtualPath%>/fwebedit_do.jsp">
                      <param name="PostScriptDdxc" value="<%=Global.virtualPath%>/ddxc.jsp">
                      <param name="SegmentLen" value="204800">
					  <param name="InternetFlag" value="<%=Global.internetFlag%>">
                    </object></td>
                </tr>
              </table>			  </td>
            </tr>
            <tr>
              <td height="30" colspan=2 align=center>
			  <%
			  String action = "";
			  if (op.equals("add"))
			  	action = SkinUtil.LoadString(request,"op_add");
			  else
			  	action = SkinUtil.LoadString(request,"op_modify");
			  %>
			  <%if (isWebEditShowHighOption) {%>
              <input name="cmdok2" type="button" value="<%=action%>(<%=SkinUtil.LoadString(request,"res.label.webedit","duan_dian_upload")%>)" onClick="return SubmitWithFileDdxc()">
              <input name="cmdok3" type="button" value="<%=action%>(<%=SkinUtil.LoadString(request,"res.label.webedit","per_thread")%>)" onClick="return SubmitWithFileThread()">
              <input name="remsg2" type="button" onClick='alert(webedit.ReturnMessage)' value="<%=SkinUtil.LoadString(request,"res.label.webedit","return_info")%>">
			  <%}%>
			  <input name="cmdok" type="button" value=" <%=action%> " onClick="return SubmitWithFile()">
			  <input name="notuploadfile" type="button" value="<%=action%>(<%=SkinUtil.LoadString(request,"res.label.webedit","not_upload_file")%>)" onClick="return SubmitWithoutFile()">
			&nbsp;&nbsp;
      <%if (op.equals("edit")) {
			boolean isHtml = cfg.getBooleanProperty("cms.html_doc");				  
	  %>
			<input name="remsg" type="button" onClick='window.open("<%=viewPage%>")' value="<%=SkinUtil.LoadString(request,"res.label.webedit","browse")%>">
			<%if (isHtml && siteLeaf==null) {%>			
			&nbsp;&nbsp;
			<input name="button2" type="button" onClick='window.open("doc_view_create.jsp?id=<%=id%>&isCreateHtml=true")' value="预览并生成静态页面">
			<%}%>
	<%}%>
			</td>
            </tr>
        </table>
    </form>
<table width="100%"  border="0">
          <tr>
            <td align="center">
			<%if (doc!=null && doc.getPageType()==Document.PAGE_TYPE_MANUAL) {
				int pageNum = 1;
			%>
			<lt:Label res="res.label.webedit" key="artical_sum"/><%=doc.getPageCount()%><lt:Label res="res.label.webedit" key="pages"/>&nbsp;&nbsp;<lt:Label res="res.label.webedit" key="page"/>
            <%
					int pagesize = 1;
					int total = doc.getPageCount();
					int curpage,totalpages;
					Paginator paginator = new Paginator(request, total, pagesize);
					// 设置当前页数和总页数
					totalpages = paginator.getTotalPages();
					curpage	= paginator.getCurrentPage();
					if (totalpages==0)
					{
						curpage = 1;
						totalpages = 1;
					}
					
					String querystr = "op=edit&doc_id=" + id;
					out.print(paginator.getCurPageBlock("doc_fck_editpage.jsp?"+querystr));
					%>
            <%if (op.equals("edit")) {
						if (doc.getPageCount()!=pageNum) {					
					%>
&nbsp;<a href="doc_fck_editpage.jsp?op=add&action=insertafter&doc_id=<%=doc.getID()%>&afterpage=<%=pageNum%>"><lt:Label res="res.label.webedit" key="insert_after_current_page"/></a>
<%	}
					}%>
&nbsp;<a href="doc_fck_editpage.jsp?op=add&doc_id=<%=doc.getID()%>"><lt:Label res="res.label.webedit" key="add_page"/></a>
<%}%>		
			</td>
          </tr>
          <tr>
            <form name="form3" action="?" method="post"><td align="center">
			<input name="newname" type="hidden">
			</td></form>
          </tr>
</table>
		
		
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
	// document.frames.hideframe.location.href = "fwebedit_do.jsp?op=changeattachname&page_num=1&doc_id=" + doc_id + "&attach_id=" + attach_id + "&newname=" + obj.value
	form3.action = "fwebedit_do.jsp?op=changeattachname&page_num=1&doc_id=" + doc_id + "&attach_id=" + attach_id;
	form3.newname.value = obj.value;
	form3.submit();
}

function delAttach(attach_id, doc_id) {
	if (!window.confirm("<lt:Label res="res.label.webedit" key="del_confirm"/>")) {
		return;
	}
	document.frames.hideframe.location.href = "fwebedit_do.jsp?op=delAttach&page_num=1&doc_id=" + doc_id + "&attach_id=" + attach_id
}

function openWinSubjects() {
	var ret = showModalDialog('cms/subject_multi_sel.jsp',window.self,'dialogWidth:480px;dialogHeight:320px;status:no;help:no;')
	if (ret==null)
		return;
	addform.subjectNames.value = "";
	addform.subjects.value = "";
	for (var i=0; i<ret.length; i++) {
		if (addform.subjectNames.value=="") {
			addform.subjects.value += ret[i][0];
			addform.subjectNames.value += ret[i][1];
		}
		else {
			addform.subjects.value += "," + ret[i][0];
			addform.subjectNames.value += "," + ret[i][1];
		}
	}
	if (addform.subjects.value.indexOf("<%=SubjectDb.ROOTCODE%>")!=-1) {
		addform.subjects.value = "<%=SubjectDb.ROOTCODE%>";
		addform.subjectNames.value = "全部";
	}
}

function getSubjects() {
	return addform.subjects.value;
}
</script>
</html>