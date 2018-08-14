<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>节点管理</title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}

a.column:link {
font-weight:bold;
}
a.column:visited {
font-weight:bold;
}
a.subsite:link {
font-weight:bold;
color:#0066FF;
}
a.subsite:visited {
font-weight:bold;
color:#0066FF;
}
a.link:link {
font-weight:bold;
}
a.link:visited {
font-weight:bold;
}
-->
</style>
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = StrUtil.getNullString(request.getParameter("op"));
String dir_code = ParamUtil.get(request, "dir_code");
Leaf leaf = dir.getLeaf(dir_code);
String dir_name = "";
if (leaf!=null)
	dir_name = leaf.getName();

if (op.equals("createHtml")) {
	try {
		docmanager.createHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "dir_common.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
else if (op.equals("createListHtml")) {
	try {
		docmanager.createListHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "dir_common.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
else if (op.equals("createColumnHtml")) {
	DocumentMgr dm = new DocumentMgr();
	String[] columnCodes = ParamUtil.getParameters(request, "columnCodes");
	int len = 0;
	if (columnCodes!=null)
		len = columnCodes.length;
	for (int i=0; i<len; i++) {
		dm.createColumnPageHtml(request, columnCodes[i]);
	}
	out.print(StrUtil.Alert_Redirect("操作成功!", "dir_common.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><%
	  if (!op.equals("search")) {
	  	if (leaf!=null && leaf.isLoaded()) {
			Leaf lf = leaf;
			String navstr = "";
			String parentcode = lf.getParentCode();
			Leaf plf = new Leaf();
			while (!parentcode.equals("root")) {
				plf = plf.getLeaf(parentcode);
				if (plf==null || !plf.isLoaded())
					break;
				if (plf.getType()==Leaf.TYPE_LIST && plf.getChildCount()!=0)
					navstr = "<a href='dir_frame.jsp?root_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				else if (plf.getType()==Leaf.TYPE_LIST && plf.getChildCount()==0)
					navstr = "<a href='document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				else if (plf.getType()==Leaf.TYPE_NONE) {
					navstr = "<a href='dir_frame.jsp?root_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;				
				}
				else if (plf.getType()==Leaf.TYPE_COLUMN) {
					navstr = "<a href='column.jsp?dir_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;				
				}
				else
					navstr = plf.getName() + "&nbsp;>>&nbsp;" + navstr;
				
				if (plf.getType()==Leaf.TYPE_SUB_SITE) {
					break;
				}
				parentcode = plf.getParentCode();
			}
			out.print(navstr + lf.getName());
		}
		else
			out.print(SkinUtil.LoadString(request, "res.label.cms.doc","artical_list"));
	}
	else
		out.print(SkinUtil.LoadString(request, "res.label.cms.doc","search_result"));

	cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
	boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
	if (!dir_code.equals("") && !dir_code.equals(Leaf.ROOTCODE) && leaf.getType()!=Leaf.TYPE_NONE) {
		if (isHtml) {
			out.print("[<a target=_blank href='" + request.getContextPath() + "/" + leaf.getListHtmlNameByPageNum(request, 1) + "'>预览静态页面</a>]");
		}
		out.print("[<a target=_blank href='" + request.getContextPath() + "/doc_list_view.jsp?dirCode=" + StrUtil.UrlEncode(dir_code) + "'>预览页面</a>]");
	}
	%>&nbsp;┆&nbsp;<a href="dir_frame.jsp?root_code=<%=StrUtil.UrlEncode(dir_code)%>">管理目录</a></td>
    </tr>
  </tbody>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellspacing="1" cellpadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td nowrap class="thead" style="PADDING-LEFT: 10px"><%=dir_name%></td>
    </tr>
    <%
	if (!leaf.getParentCode().equals("-1")) {
	%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td align="left">
	  <div class="subDir">	  
	  <img src="images/parent.gif" />
		 <%
		 Leaf pLeaf = leaf.getLeaf(leaf.getParentCode());
		 if (pLeaf.getCode().equals(Leaf.ROOTCODE) || pLeaf.getType()==Leaf.TYPE_NONE) {%>
			<a href="dir_common.jsp?dir_code=<%=leaf.getParentCode()%>"><%=pLeaf.getName()%></a>
	     <%} else if (pLeaf.getType()==Leaf.TYPE_LIST) {%>
			<a href="document_list_m.jsp?dir_code=<%=leaf.getParentCode()%>"><%=pLeaf.getName()%></a>
	     <%} else if (pLeaf.getType()==Leaf.TYPE_COLUMN) {%>
			<a href="column.jsp?dir_code=<%=leaf.getParentCode()%>"><%=pLeaf.getName()%></a>
	     <%}%>
		 </div>
		 </td>
    </tr>
    <%}%>
    <%
		String userName = privilege.getUser(request);
		Vector chr = leaf.getChildren();
	%>
    <tr class="tbg1">
      <td align="left">
	  <%
		java.util.Iterator irch = chr.iterator();
		while (irch.hasNext()) {
			Leaf clf = (Leaf)irch.next();
			LeafPriv lp = new LeafPriv(clf.getCode());
        	if (!lp.canUserSeeWithAncestorNode(userName))
				continue;
	  %>
	  <div class="subDir">
	  <%
	  if (clf.getChildCount()>0) {%>
	  <img src="../images/add.gif" />
	  <%}else{%>
	  <img src="../images/minus.gif" />
	  <%}%>
	  <!--<img src="images/folder_01.gif" />-->
	  <%
			String url = "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(clf.getCode());
			String className = "";
			if (clf.getType()==Leaf.TYPE_DOCUMENT) {
				url = "../fckwebedit_new.jsp?op=editarticle&dir_code=" + StrUtil.UrlEncode(clf.getCode());
			}
			else if (clf.getType()==Leaf.TYPE_LINK) {
				url = clf.getDescription();
				className = "class='link'";
			}
			else if (clf.getType()==Leaf.TYPE_COLUMN) {
				className = "class='column'";
			}			
			else if (clf.getType()==Leaf.TYPE_SUB_SITE) {
				className="class='subsite'";
			}
	  %>
      <a href="<%=url%>" title="<%=clf.getName()%> (<%=clf.getTypeDesc(request)%>)" <%=clf.getType()==Leaf.TYPE_LINK?"target=_blank":""%> <%=className%>><%=clf.getName()%></a>
	  	<span>
		<%
		if (clf.getType()!=Leaf.TYPE_LINK) {
			if (clf.getType()==Leaf.TYPE_LIST) {%>
			<a href="../<%=DocumentMgr.getWebEditPage()%>?op=add&dir_code=<%=StrUtil.UrlEncode(clf.getCode())%>" title="发布文章"><img border="0" src="../images/modify.gif" /></a>
			<%}else{%>
			<a href="document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(clf.getCode())%>" title="发布文章"><img border="0" src="../images/modify.gif" /></a>
			<%}
		}%>
		</span>	  </div>
    <%}%>	</td>
    </tr>
  </tbody>
</table>
<br>
<%if (isHtml && !dir_code.equals("")) {%>
<table width="98%" border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
  <tr>
    <td class="thead">生成静态页面</td>
  </tr>
  <tr>
  <form action="?op=createHtml" method="post">
    <td>
      文章修改日期从
          <input readonly type="text" id="beginDate" name="beginDate" size="10" this.value=''">
<script type="text/javascript">
    Calendar.setup({
        inputField     :    "beginDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
</script>		  
          至
          <input readonly type="text" id="endDate" name="endDate" size="10" this.value=''">
<script type="text/javascript">
    Calendar.setup({
        inputField     :    "endDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
</script>			  
          <input name="" value="true" type="checkbox" checked disabled>
          <input name="isIncludeChildren" value="true" type="hidden">
包含子文件夹
          &nbsp;
          <input name="button2" type="submit" value="生成文章静态页面">
    	  <input name="dir_code" value="<%=dir_code%>" type="hidden">
   	  日期不填写，表示全部</td>
   </form>
  </tr>
  <tr>
    <form action="?op=createListHtml" method="post">
      <td>列表页的页码从
        <input type="text" id="pageNumBegin" name="pageNumBegin" size="10" value="1">
        至
        <input type="text" id="pageNumEnd" name="pageNumEnd" size="10">
        <input name="" value="true" type="checkbox" checked disabled>
        <input name="isIncludeChildren" value="true" type="hidden">
        包含子文件夹
        &nbsp;
                  <input name="button22" type="submit" value="生成列表静态页面">
                  <input name="dir_code" value="<%=dir_code%>" type="hidden">
      页码不填写，表示全部</td>
    </form>
  </tr>
</table>
<%}%><br>
<%if (isHtml) {%>
<form action="dir_common.jsp?op=createColumnHtml" method="post">
<table width="98%" border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
  <tr>
    <td class="thead">全部栏目</td>
  </tr>
  <tr>
    <td height="22">
<%
Iterator ir = leaf.list("select code from directory where type=" + Leaf.TYPE_COLUMN + " order by orders").iterator();
while (ir.hasNext()) {
	Leaf lf = (Leaf)ir.next();
%>
<input name="columnCodes" type="checkbox" value="<%=lf.getCode()%>"><a href="column.jsp?dir_code=<%=StrUtil.UrlEncode(dir_code)%>"><%=lf.getName()%></a><br>
<%
}
%>
<input name="dir_code" value="<%=dir_code%>" type="hidden">
	</td>
  </tr>
  <tr>
    <td height="22">
	  <input name="button3" type="button" onClick="selAllCheckBox('columnCodes')" value="<lt:Label res="res.label.forum.topic_m" key="sel_all"/>">
	  &nbsp;
<input name="button3" type="button" onClick="clearAllCheckBox('columnCodes')" value="<lt:Label res="res.label.forum.topic_m" key="clear_all"/>">
&nbsp;
<input type="submit" value="生成静态页面">
	</td>
  </tr>
</table>
</form>  
<%}%>
</body>
<script src="../inc/common.js"></script>
<script>
function doDel() {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("请选择文章！");
		return;
	}
	window.location.href = "?op=delBatch&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&ids=" + ids;
}

function passExamineBatch() {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("请选择文章！");
		return;
	}
	window.location.href = "?op=passExamine&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&examine=<%=Document.EXAMINE_PASS%>&ids=" + ids;
}

function selAllCheckBox(checkboxname){
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			checkboxboxs.checked = true;
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			checkboxboxs[i].checked = true;
		}
	}
}

function clearAllCheckBox(checkboxname) {
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			checkboxboxs.checked = false;
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			checkboxboxs[i].checked = false;
		}
	}
}
</script>
</html>