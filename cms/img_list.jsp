﻿<%@ page contentType="text/html; charset=utf-8"%><%@ page import="cn.js.fan.util.*"%><%@ page import="cn.js.fan.db.*"%><%@ page import="cn.js.fan.web.*"%><%@ page import="com.cloudwebsoft.framework.db.*"%><%@ page import="cn.js.fan.module.cms.*"%><%@ page import="cn.js.fan.module.pvg.*"%><%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %><%
String op = StrUtil.getNullString(request.getParameter("op"));
if (op.equals("uploadWebedit")) {
	ImgStoreFileMgr isfm = new ImgStoreFileMgr();
	boolean re = false;
	try {
		re = isfm.create(application, request);
		if (re)
			out.print("操作成功，请刷新页面！");	
		else
			out.print("操作失败！");		
	}
	catch (ErrMsgException e) {
		out.print(e.getMessage());	

	}
	return;
}
%>
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

.noborder
{
    BORDER-BOTTOM: 0px solid;
    BORDER-LEFT: 0px solid;
    BORDER-RIGHT: 0px solid;
    BORDER-TOP: 0px solid;
    FONT-SIZE: 9pt
}
-->
</style>
<style type="text/css">
/*Tooltips*/
.tooltips{
position:relative; /*这个是关键*/
z-index:2;
}
.tooltips:hover{
z-index:3;
background:none; /*没有这个在IE中不可用*/
}
.tooltips span{
display: none;
}
.tooltips:hover span img {
max-width:300px;
width:expression(this.width>300?"300px":this.width);
}
.tooltips:hover span{ /*span 标签仅在 :hover 状态时显示*/
display:block;
position:absolute;
top:21px;
left:9px;
width:5px;
border:0px solid black;
background-color: #FFFFFF;
padding: 3px;
color:black;
}
</style>
<script>
var attachCount = 0;

function AddAttach() {
	updiv.insertAdjacentHTML("BeforeEnd", "<table width=100%><tr>文件&nbsp;<input type='file' name='filename" + attachCount + "' size=10><td></td></tr></table>");
	attachCount += 1;
}

function selectImage(visualPath) {
	window.top.opener.setImgUrl(visualPath);
	window.top.close();
}

var basePath = "";
<%if (!Global.virtualPath.equals("")) {%>
basePath = "/<%=Global.virtualPath%>";
<%}%>

function selectImageForEditor(visualPath) {
	window.parent.Add(basePath + "/" + visualPath);
}

function formSubDir_onsubmit() {
	window.location.reload();
}
</script>
<script language=JavaScript src='../FCKeditor/formpost.js'></script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="sm" scope="page" class="cn.js.fan.module.cms.ImgStoreDirMgr"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String action = ParamUtil.get(request, "action");

// dir是编辑器传过来的参数，为当前编辑的文章所属的目录节点的编码
String dir = ParamUtil.get(request, "dir");
if (op.equals("delDir")) {
	String dirCode = ParamUtil.get(request, "dirCode");
	ImgStoreDirDb leaf = sm.getImgStoreDirDb(dirCode);
	leaf.del();
	
	out.print(SkinUtil.makeInfo(request, "删除成功！"));
%>
<script>
window.parent.leftFileFrame.location="img_left.jsp?action=<%=action%>&dir=<%=StrUtil.UrlEncode(dir)%>";;
</script>
<%	
	return;
}
%>
<%
String dirCode = ParamUtil.get(request, "dirCode");
if (dirCode.equals("")) {
	dirCode = ImgStoreDirDb.ROOTCODE;
}

// 如果dir不为空，则说明从编辑器或者左侧框架中传入了正在编辑文章内容的目录节点编码，根据此编码
ImgStoreDirMgr dm = new ImgStoreDirMgr();
String isFromLeftFrame = ParamUtil.get(request, "isFromLeftFrame");
// 不是从框架页的左侧传过来的dir参数
if (!isFromLeftFrame.equals("true") && !dir.equals("")) {
	Leaf lf = new Leaf();
	lf = lf.getLeaf(dir);
	if (lf.getType()==Leaf.TYPE_SUB_SITE) {
        dirCode = dm.getImgStoreDirDb(lf.getCode()).getCode();
	}
	else {
        String parentcode = lf.getParentCode();

        Leaf plf = new Leaf();
        while (!parentcode.equals("root")) {
            plf = plf.getLeaf(parentcode);
			if (plf.getType()==Leaf.TYPE_SUB_SITE) {
				dirCode = dm.getImgStoreDirDb(plf.getCode()).getCode();
				break;
			}
            parentcode = plf.getParentCode();
       }
	}
}

ImgStoreDirDb leaf = sm.getImgStoreDirDb(dirCode);
String dir_name = "";
if (leaf!=null)
	dir_name = leaf.getName();
	
cn.js.fan.module.cms.Leaf cmsleaf = new cn.js.fan.module.cms.Leaf();
cmsleaf = cmsleaf.getLeaf(dirCode);
boolean isSubsite = false;
if (cmsleaf!=null && cmsleaf.getType()==cn.js.fan.module.cms.Leaf.TYPE_SUB_SITE)
	isSubsite = true;

if (op.equals("upload")) {
	ImgStoreFileMgr isfm = new ImgStoreFileMgr();
	boolean re = false;
	try {
		re = isfm.create(application, request);
		if (re)
			out.print(StrUtil.Alert_Redirect("操作成功！", "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));	
		else
			out.print(StrUtil.Alert_Redirect("操作失败！", "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));		
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Redirect(e.getMessage(), "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));	
		return;
	}
}

if (op.equals("del")) {
	long id = ParamUtil.getLong(request, "id");
	try {
		ImgStoreFileMgr isfm = new ImgStoreFileMgr();
		if (isfm.del(request, id))
			out.print(StrUtil.Alert_Redirect("操作成功！", "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));	
		else 
			out.print(StrUtil.Alert_Redirect("操作失败！", "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));		
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Redirect(e.getMessage(), "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));	
		return;
	}
}

if (op.equals("delBatch")) {
	ImgStoreFileMgr isfm = new ImgStoreFileMgr();
	boolean re = false;
	try {
		re = isfm.delBatch(request);
		if (re)
			out.print(StrUtil.Alert_Redirect("操作成功！", "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));	
		else
			out.print(StrUtil.Alert_Redirect("操作失败！", "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));		
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Redirect(e.getMessage(), "img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(dirCode)));	
		return;
	}
}

if (op.equals("rename")) {
	ImgStoreFileMgr isfm = new ImgStoreFileMgr();
	boolean re = false;
	try {
		re = isfm.rename(request);
		if (re)
			out.print(StrUtil.Alert("操作成功！"));	
		else
			out.print(StrUtil.Alert_Redirect("操作失败！", "img_list.jsp?dirCode=" + StrUtil.UrlEncode(dirCode)));		
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Redirect(e.getMessage(), "img_list.jsp?dirCode=" + StrUtil.UrlEncode(dirCode)));	
		return;
	}
}

String orderBy = ParamUtil.get(request, "orderBy");
String sort = ParamUtil.get(request, "sort");
if (orderBy.equals(""))
	orderBy = "upload_date";
if (sort.equals(""))
	sort = "desc";

String sql = "select id from cws_cms_img_store_file where dir_code=" + StrUtil.sqlstr(dirCode);

String what = "";
if (op.equals("search")) {
	what = ParamUtil.get(request, "what");
	sql += " and name like "+StrUtil.sqlstr("%"+what+"%");
}

sql += " order by " + orderBy + " " + sort;
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head"><%
	  if (!op.equals("search")) {
	  	if (leaf!=null && leaf.isLoaded()) {
			ImgStoreDirDb lf = leaf;
			String navstr = "";
			String parentcode = lf.getParentCode();
			ImgStoreDirDb plf = new ImgStoreDirDb();
			while (!parentcode.equals("root")) {
				plf = plf.getImgStoreDirDb(parentcode);
				if (plf==null || !plf.isLoaded())
					break;

				navstr = "<a href='img_list.jsp?action=" + action + "&dirCode=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				parentcode = plf.getParentCode();
			}
			out.print(navstr + lf.getName());
		}
		else
			out.print("文件列表");
	}
	else
			out.print(SkinUtil.LoadString(request, "res.label.cms.doc","search_result"));
		%>
      &nbsp;&nbsp;<a href="img_list_pic.jsp?dirCode=<%=StrUtil.UrlEncode(dirCode)%>&action=<%=action%>&dir=<%=StrUtil.UrlEncode(dir)%>">缩略图</a></td>
    </tr>
  </tbody>
</table>
<br>
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
  <form name="form1" action="img_list.jsp?op=search" method="post">
    <tr>
      <td align="center"><input name=what size=20>
        &nbsp;
        <input name="Submit" type="submit" value=<%=SkinUtil.LoadString(request, "res.label.cms.doc","search")%>>
		<input type="hidden" name="dirCode" value="<%=dirCode%>">
	  </td>
    </tr>
  </form>
</table>
<%
String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
if (strcurpage.equals(""))
	strcurpage = "1";
if (!StrUtil.isNumeric(strcurpage)) {
	out.print(StrUtil.makeErrMsg(StrUtil.Alert_Back(SkinUtil.LoadString(request, "err_id"))));
	return;
}
int pagesize = 15;
int curpage = Integer.parseInt(strcurpage);
JdbcTemplate jt = new JdbcTemplate();
ResultIterator ri = jt.executeQuery(sql, Integer.parseInt(strcurpage), pagesize);
ResultRecord rr = null;

Paginator paginator = new Paginator(request, jt.getTotal(), pagesize);
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0) {
	curpage = 1;
	totalpages = 1;
}
%>
<table width="92%" border="0" align="center" class="p9">
  <tr>
    <td height="24" align="right"><lt:Label res="res.label.cms.doc" key="found_right_list"/><b><%=paginator.getTotal() %></b><lt:Label res="res.label.cms.doc" key="page_list"/><b><%=paginator.getPageSize() %></b><lt:Label res="res.label.cms.doc" key="page"/><b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></td>
  </tr>
</table>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellspacing="1" cellpadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td width="6%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px">编号</td>
      <td width="58%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px;cursor:hand" onClick="doSort('name')">
        名称
        <%if (orderBy.equals("name")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
      </td>
      <td width="16%" align="center" nowrap class="thead" style="cursor:hand" onClick="doSort('upload_date')">
	  上传日期
        <%if (orderBy.equals("upload_date")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
      </td>
      <td width="20%" align="center" nowrap class="thead"><lt:Label res="res.label.cms.doc" key="mgr"/></td>
    </tr>
<%
if(!leaf.getParentCode().equals("-1") && !isSubsite) {
%>
    <tr>
      <td colspan="4" align="left" nowrap class="tbg1" style="PADDING-LEFT: 5px; height:22px"><img src="images/folder_01.gif" width="16" height="12">&nbsp;<a href="img_list.jsp?dirCode=<%=StrUtil.UrlEncode(leaf.getParentCode())%>">..</a></td>
    </tr>	
<%
}
ImgStoreDirChildrenCache isdc = new ImgStoreDirChildrenCache(dirCode);
java.util.Iterator ir = isdc.getList().iterator();
while (ir.hasNext()) {
	ImgStoreDirDb isdd = (ImgStoreDirDb)ir.next();
%>	
    <tr>
      <td colspan="4" align="left" nowrap class="tbg1" style="PADDING-LEFT: 5px; height:22px"><img src="images/folder_01.gif" width="16" height="12">&nbsp;<a href="img_list.jsp?dirCode=<%=StrUtil.UrlEncode(isdd.getCode())%>&action=<%=action%>"><%=isdd.getName()%></a></td>
    </tr>
<%}%>	
<%
ImgStoreFileDb isfd = null;
ImgStoreFileMgr isfm = new ImgStoreFileMgr();
int k = 100;
while (ri.hasNext()) {
 	rr = (ResultRecord)ri.next();
	isfd = isfm.getImgStoreFileDb(rr.getLong(1));
	k++;
	%>
  <form name="form<%=k%>" action="img_list.jsp?op=rename" method="post">
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1" style="padding-left:5px">
      <td><input name="ids" type="checkbox" value="<%=isfd.getId()%>"></td>
      <td style="PADDING-LEFT: 10px">
	  <a class="tooltips" href="#">
		<input name="name" value="<%=isfd.getName()%>" class="noborder" size=30>
		<span><img src="../<%=isfd.getVisualPath() + "/" + isfd.getDiskName()%>"></span></a>
		<input name="dirCode" value="<%=dirCode%>" type=hidden>
		<input name="id" value="<%=isfd.getId()%>" type=hidden>
		<input name="action" value="<%=action%>" type=hidden>
	    <input name="CPages" value="<%=curpage%>" type=hidden></td>
      <td align="center">
	  <%=DateUtil.format(isfd.getUploadDate(), "yy-MM-dd HH:mm")%>	  </td>
      <td align="center"><a href="../<%=isfd.getVisualPath() + "/" + isfd.getDiskName()%>" target="_blank">下载</a>
        <%if (action.equals("selectImage")) {%>
	  <a href="#" onClick="selectImage('<%=isfd.getVisualPath() + "/" + isfd.getDiskName()%>')">选择</a>&nbsp;
	  <%}
	  else if (action.equals("selectImageForEditor")) {%>
	  <a href="#" onClick="selectImageForEditor('<%=isfd.getVisualPath() + "/" + isfd.getDiskName()%>')">选择</a>&nbsp;
	  <%}%>
	  <a href="#" onClick="form<%=k%>.submit()">重命名</a>&nbsp;<a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='img_list.jsp?op=del&id=<%=isfd.getId()%>&dirCode=<%=StrUtil.UrlEncode(dirCode)%>&action=<%=action%>&dir=<%=StrUtil.UrlEncode(dir)%>'">删除</a>
	  </td>
    </tr>
  </form>
    <%}%>
  </tbody>
</table>
<table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="2" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td width="42%" align="left"><input name="button3" type="button" onClick="selAllCheckBox('ids')" value="<lt:Label res="res.label.forum.topic_m" key="sel_all"/>">
      &nbsp;&nbsp;
      <input name="button3" type="button" onClick="clearAllCheckBox('ids')" value="<lt:Label res="res.label.forum.topic_m" key="clear_all"/>">&nbsp;&nbsp;
      <input name="button32" type="button" onClick="doDel()" value="<lt:Label key="op_del"/>"></td>
    <td width="58%" align="right"><%
	String querystr = "op=" + op + "&dirCode=" + StrUtil.UrlEncode(dirCode) + "&action=" + action + "&op=" + op + "&what=" + StrUtil.UrlEncode(what);
    out.print(paginator.getCurPageBlock("img_list.jsp?"+querystr));
%></td>
  </tr>
</table>
<HR noShade SIZE=1>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="57%">&nbsp;</td>
    <td width="43%">&nbsp;</td>
  </tr>
  <tr>
    <td><table width="100%" border=0 cellspacing=0 cellpadding=0 id="uploadTable">
      <form name=form1 action="img_list.jsp?action=<%=action%>&op=upload&dirCode=<%=StrUtil.UrlEncode(dirCode)%>&dir=<%=StrUtil.UrlEncode(dir)%>" method="post" enctype="MULTIPART/FORM-DATA">
        <tr>
          <td class=tablebody1 valign=top> 文件
            <input type="file" name="filename" size=10>
            <input type=button onClick="AddAttach()" value="增加">
            <input name="submit" type=submit value="上传">
            <input name="dirCode" type="hidden" value="<%=dirCode%>">
            <input type="button" value="高级上传" onClick="table_webedit.style.display=''">
			<div id="updiv"></div>
			</td>
        </tr>
      </form>
    </table></td>
    <td valign="top"><table width="100%" border=0 cellspacing=0 cellpadding=0 id="uploadTable">
      <form name=formSubDir target="leftFileFrame" action="img_left.jsp?op=AddChild&action=<%=action%>&dir=<%=StrUtil.UrlEncode(dir)%>" method="post" onSubmit="return formSubDir_onsubmit()">
        <tr>
          <td class=tablebody1 valign=top>
		  <input name="name" size="6">
            <input name="submit2" type=submit value="添子目录"><input name="parent_code" type="hidden" value="<%=dirCode%>"><input name="code" type="hidden" value="<%=cn.js.fan.util.RandomSecquenceCreator.getId(20)%>">
              <input name="type" type="hidden" value="1"><a href="img_dir_modify.jsp?code=<%=StrUtil.UrlEncode(dirCode)%>">修改目录</a>&nbsp;
			  <%if (!dirCode.equals("root")) {%>
			  <a href="javascript:if (confirm('您确定要删除吗？')) window.location.href='img_list.jsp?op=delDir&action=<%=action%>&dirCode=<%=StrUtil.UrlEncode(dirCode)%>&dir=<%=StrUtil.UrlEncode(dir)%>'">删除目录</a>
			  <%}%>
			  <!--<a href="img_left.jsp?op=repair" target="leftFileFrame">修复目录</a>-->
			  </td>
        </tr>
      </form>
    </table></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td align="center">
	<table width="100%" id="table_webedit" style="display:none">
	<form name="formWebedit">
	  <tr><td align="center"><%
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
String isRelatePath = cfg.getProperty("cms.isRelatePath"); 	
	%>
      <object classid="CLSID:DE757F80-F499-48D5-BF39-90BC8BA54D8C" codebase="<%=request.getContextPath()%>/activex/webedit.cab#version=6,0,2,1" width=400 height=170 align="middle" id="webedit">
        <param name="Encode" value="utf-8">
        <param name="MaxSize" value="<%=Global.MaxSize%>">
        <!--上传字节-->
        <param name="ForeColor" value="(255,255,255)">
        <param name="BgColor" value="(107,154,206)">
        <param name="ForeColorBar" value="(255,255,255)">
        <param name="BgColorBar" value="(0,0,255)">
        <param name="ForeColorBarPre" value="(0,0,0)">
        <param name="BgColorBarPre" value="(200,200,200)">
        <param name="FilePath" value="">
        <param name="Relative" value="<%=isRelatePath%>">
        <!--上传后的文件需放在服务器上的路径-->
        <param name="Server" value="<%=request.getServerName()%>">
        <param name="Port" value="<%=request.getServerPort()%>">
        <param name="VirtualPath" value="<%=Global.virtualPath%>">
        <param name="PostScript" value="<%=Global.virtualPath%>/cms/img_list.jsp?op=uploadWebedit">
        <param name="PostScriptDdxc" value="<%=Global.virtualPath%>/ddxc.jsp">
        <param name="SegmentLen" value="204800">
        <param name="InternetFlag" value="<%=Global.internetFlag%>">
      </object>
	  <input name="dirCode" value="<%=dirCode%>" type="hidden">
	  <input name="action" value="<%=action%>" type="hidden">
	  </td>
	  </tr>
	  <tr>
	    <td align="center"><input name="cmdok3" type="button" value="上传大文件" onClick="return SubmitWithFileThread()">
	      &nbsp;&nbsp;&nbsp;
  	    <input name="cmdok" type="button" value="上传 " onClick="return SubmitWithFile()">
		&nbsp;&nbsp;&nbsp;		  
	      <input name="remsg" type="button" onClick='alert(webedit.ReturnMessage)' value="信息"></td>
	    </tr></form>
	</table></td>
    <td align="center">&nbsp;</td>
  </tr>
</table>
</body>
<script src="../inc/common.js"></script>
<script>
function doDel() {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("请选择文件！");
		return;
	}
	window.location.href = "?op=delBatch&dirCode=<%=StrUtil.UrlEncode(dirCode)%>&ids=" + ids;
}

function selAllCheckBox(checkboxname) {
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

function SubmitWithFileThread() {
	loadDataToWebeditCtrl(formWebedit, formWebedit.webedit);
	formWebedit.webedit.Upload();
	// 因为Upload()中启用了线程的，所以函数在执行后，会立即反回，使得下句中得不到ReturnMessage的值
	// 原因是此时服务器的返回信息还没收到
	// alert("ReturnMessage=" + addform.webedit.ReturnMessage);
}

function SubmitWithFile(){
	loadDataToWebeditCtrl(formWebedit, formWebedit.webedit);
	formWebedit.webedit.UploadArticle();
	if (formWebedit.webedit.ReturnMessage.indexOf("成功")!=-1) {
		alert("上传成功！");
		window.location.reload();
	}
	else
		doAfter(formWebedit.webedit.ReturnMessage);
}

var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";	
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
	window.location.href = "img_list.jsp?dirCode=<%=StrUtil.UrlEncode(dirCode)%>&action=<%=action%>&op=<%=op%>&orderBy=" + orderBy + "&sort=" + sort;
}	
</script>
</html>