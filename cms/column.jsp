<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.doc" key="artical_list"/></title>
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
<script>
function form_onsubmit() {
	var strdt1=document.getElementById("beginDate").value.replace("-","/");
	var strdt2=document.getElementById("endDate").value.replace("-","/");            
	var dt1=new Date(Date.parse(strdt1));
	var dt2=new Date(Date.parse(strdt2));
	if(dt1>dt2) {
		alert("开始日期不能大于结束日期！");
		return false;
	}
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String dirCode = ParamUtil.get(request, "dir_code");
Leaf lf = new Leaf();
lf = lf.getLeaf(dirCode);
if (lf==null) {
	out.print(StrUtil.Alert_Back("栏目不存在!"));
	return;
}

String op = ParamUtil.get(request, "op");
if (op.equals("createColumnHtml")) {
	DocumentMgr dm = new DocumentMgr();
	dm.createColumnPageHtml(request, dirCode);
	out.print(StrUtil.Alert_Redirect("操作成功!", "column.jsp?dir_code=" + StrUtil.UrlEncode(dirCode)));
	return;
}

if (op.equals("createHtml")) {
	try {
		docmanager.createHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "column.jsp?dir_code=" + StrUtil.UrlEncode(dirCode)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}

if (op.equals("createListHtml")) {
	try {
		docmanager.createListHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "column.jsp?dir_code=" + StrUtil.UrlEncode(dirCode)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">栏目管理</td>
    </tr>
  </tbody>
</table>
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="100%" height="22">&nbsp;&nbsp;<a href="dir_frame.jsp?root_code=<%=StrUtil.UrlEncode(dirCode)%>">管理目录</a>&nbsp;┆&nbsp;<a href="../doc_column_view.jsp?dirCode=<%=StrUtil.UrlEncode(dirCode)%>" target="_blank">查看栏目</a></td>
  </tr>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellspacing="1" cellpadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td nowrap class="thead" style="PADDING-LEFT: 10px"><%=lf.getName()%></td>
    </tr>
    <%
	if (!lf.getParentCode().equals("-1")) {
	%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td align="left">
	  <div class="subDir">
	  <img src="images/parent.gif" />
		 <%
		 Leaf pLeaf = lf.getLeaf(lf.getParentCode());
		 %>
	  <a href="document_list_m.jsp?dir_code=<%=lf.getParentCode()%>"><%=pLeaf.getName()%></a>
	  </div>
	  </td>
    </tr>
    <%}%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td align="left">
    <%
	String userName = privilege.getUser(request);
	java.util.Iterator irch = lf.getChildren().iterator();
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
			else if (clf.getType()==Leaf.TYPE_SUB_SITE)
				className="class='subsite'";
			%>
      <a href="<%=url%>" title="<%=clf.getName()%> (<%=clf.getTypeDesc(request)%>)" <%=clf.getType()==Leaf.TYPE_LINK?"target=_blank":""%> <%=className%>><%=clf.getName()%></a> 
	  	<span>
		<%
		if (clf.getType()!=Leaf.TYPE_LINK && clf.getType()!=Leaf.TYPE_SUB_SITE) {
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
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  
  <tr>
    <td width="100%" height="22"><%
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
if (isHtml) {
	String link = lf.getListHtmlPath() + "/index." + cfg.getProperty("cms.html_ext");
%>
      &gt;&gt;&nbsp;<a href="column.jsp?dir_code=<%=StrUtil.UrlEncode(dirCode)%>&op=createColumnHtml">生成栏目首页</a> [<a href="<%=request.getContextPath()%>/<%=link%>" target="_blank">查看</a>]
      链接地址：<span id="linkColumn"><%=request.getContextPath()%>/<%=link%></span>[<a href="#" onClick="doClip('linkColumn')">拷贝链接</a>]
      <%}%>    </td>
  </tr>
</table>
<br>
<%if (isHtml && !dirCode.equals("")) {%>
<table width="98%" border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
  <tr>
    <td class="thead">生成静态页面</td>
  </tr>
  <form action="?op=createHtml" method="post" onSubmit="return form_onsubmit()">
  <tr>
      <td> 文章修改日期从
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
        <input name="isIncludeChildren" value="true" type="checkbox" checked>
        包含子文件夹
        &nbsp;
                  <input name="button2" type="submit" value="生成文章静态页面">
                  <input name="dir_code" value="<%=dirCode%>" type="hidden">
        日期不填写，表示全部</td>
  </tr>
 </form>
 <form action="?op=createListHtml" method="post">
  <tr>
      <td>列表页的页码从
        <input type="text" id="pageNumBegin" name="pageNumBegin" size="10" value="1">
        至
        <input type="text" id="pageNumEnd" name="pageNumEnd" size="10">
        <input name="isIncludeChildren" value="true" type="checkbox" checked>
        包含子文件夹
        &nbsp;
                <input name="button22" type="submit" value="生成列表静态页面">
                <input name="dir_code" value="<%=dirCode%>" type="hidden">
        页码不填写，表示全部</td>
  </tr></form>
</table>
<%}%>
</body>
<script>
function doClip(param){
/*
eval(param).focus();
eval(param).document.execCommand("selectAll");
eval(param).document.execCommand('Copy');
*/
window.clipboardData.setData('Text',document.getElementById(param).innerText);
}
</script>
</html>