<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String fDirCodeHelper = ParamUtil.get(request, "fDirCodeHelper");
String fDirCode = ParamUtil.get(request, "fDirCode");
if(fDirCode.equals(""))
	fDirCode = "all";
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
-->
</style>
<script src="../inc/calendar.js"></script>
<script src="../inc/common.js"></script>
<script>
var errFunc = function(response) {
    alert('Error ' + response.status + ' - ' + response.statusText);
	alert(response.responseText);
}

function doGetChildren(response) {
	$("secMenu").innerHTML = response.responseText;
}

function dirChange(parentCode) {
	if (parentCode=="all") {
		$("secMenu").innerHTML = "<input name='fDirCode' value='all' type='hidden' />";
		return;
	}
	var str = "op=getChildren&&parentCode=" + parentCode;
	var myAjax = new cwAjax.Request( 
		"tool.jsp", 
		{
			method:"post", 
			parameters:str, 
			onComplete:doGetChildren,
			onError:errFunc
		}
	);
}

function doGetTChildren(response) {
	$("secTMenu").innerHTML = response.responseText;
}

function tDirChange(parentCode) {
	if (parentCode=="not") {
		$("secTMenu").innerHTML = "<input name='tDirCode' value='not' type='hidden' />";
		return;
	}
	var str = "op=getChildren&&parentCode=" + parentCode;
	var myAjax = new cwAjax.Request( 
		"tool.jsp", 
		{
			method:"post", 
			parameters:str, 
			onComplete:doGetTChildren,
			onError:errFunc
		}
	);
}

function window_onload() {
	<%if (!fDirCodeHelper.equals("")) {%>
	$("fDirCodeHelper").value = "<%=fDirCodeHelper%>";
	dirChange("<%=fDirCodeHelper%>");
	<%}%>
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" onLoad="window_onload()">
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String name = "", titleKey = "", sBeginDate = "", sEndDate = "", sql = "", condition = "",querystr = "", strDoOperation = "";

titleKey = ParamUtil.get(request, "titleKey");
name = ParamUtil.get(request, "name");
sBeginDate = ParamUtil.get(request, "beginDate");
sEndDate = ParamUtil.get(request, "endDate");
int pageSize = ParamUtil.getInt(request, "pageSize", 20);

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	try {
		if (docmanager.del(request, id, privilege, true)){
		    String redirectUrl = "document_batch_m.jsp?pageSize=" + pageSize + "&op=search";
			if(!fDirCode.equals("all"))
				redirectUrl = redirectUrl + "&fDirCode=" + fDirCode;
			if(!titleKey.equals(""))
				redirectUrl = redirectUrl + "&titleKey=" + titleKey;
			if(!name.equals(""))
				redirectUrl = redirectUrl + "&name=" + name;
			if(!sBeginDate.equals(""))
				redirectUrl = redirectUrl + "&beginDate=" + sBeginDate;
			if(!sEndDate.equals(""))
				redirectUrl = redirectUrl + "&endDate=" + sEndDate;
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), redirectUrl));
			return;
		}else 
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
			return;
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}

if (op.equals("passExamine")) {
	try {
		int examine = ParamUtil.getInt(request, "examine", Document.EXAMINE_NOT);	
		docmanager.passExamineBatch(request, examine);
		String redirectUrl = "document_batch_m.jsp?pageSize=" + pageSize + "&op=search";
		if(!fDirCode.equals("all"))
			redirectUrl = redirectUrl + "&fDirCode=" + fDirCode;
		if(!titleKey.equals(""))
			redirectUrl = redirectUrl + "&titleKey=" + titleKey;
		if(!name.equals(""))
			redirectUrl = redirectUrl + "&name=" + name;
		if(!sBeginDate.equals(""))
			redirectUrl = redirectUrl + "&beginDate=" + sBeginDate;
		if(!sEndDate.equals(""))
			redirectUrl = redirectUrl + "&endDate=" + sEndDate;
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), redirectUrl));
		return;
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}

if (op.equals("delBatch")) {
	try {
		docmanager.delBatch(request, true);
		String redirectUrl = "document_batch_m.jsp?pageSize=" + pageSize + "&op=search";
		if(!fDirCode.equals("all"))
			redirectUrl = redirectUrl + "&fDirCode=" + fDirCode;
		if(!titleKey.equals(""))
			redirectUrl = redirectUrl + "&titleKey=" + titleKey;
		if(!name.equals(""))
			redirectUrl = redirectUrl + "&name=" + name;
		if(!sBeginDate.equals(""))
			redirectUrl = redirectUrl + "&beginDate=" + sBeginDate;
		if(!sEndDate.equals(""))
			redirectUrl = redirectUrl + "&endDate=" + sEndDate;
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), redirectUrl));
		return;
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}

if (op.equals("setOnTop")) {
	try {
		int id = ParamUtil.getInt(request, "id");
		Document doc = docmanager.getDocument(id);
		int level = ParamUtil.getInt(request, "level");
		doc.setLevel(level);
		boolean re = doc.UpdateLevel();
		if (re){
			String redirectUrl = "document_batch_m.jsp?pageSize=" + pageSize + "&op=search";
			if(!fDirCode.equals("all"))
				redirectUrl = redirectUrl + "&fDirCode=" + fDirCode;
			if(!titleKey.equals(""))
				redirectUrl = redirectUrl + "&titleKey=" + titleKey;
			if(!name.equals(""))
				redirectUrl = redirectUrl + "&name=" + name;
			if(!sBeginDate.equals(""))
				redirectUrl = redirectUrl + "&beginDate=" + sBeginDate;
			if(!sEndDate.equals(""))
				redirectUrl = redirectUrl + "&endDate=" + sEndDate;
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), redirectUrl));
			return;
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}	
}

if (op.equals("moveBoard")) {
	String strIds = ParamUtil.get(request, "ids");
	String tDirCode = ParamUtil.get(request, "tDirCode");
	String[] idsary = StrUtil.split(strIds, ",");
	
	DocumentMgr dm = new DocumentMgr();
	if (idsary!=null) {
		int len = idsary.length;
		for (int i=0; i<len; i++) {
			try {
				dm.ChangeDir(request, Integer.parseInt(idsary[i]), tDirCode);
			}
			catch (ErrMsgException e) {
				out.print(StrUtil.Alert_Back(e.getMessage()));
				return;
			}
		}
	}
	
	String redirectUrl = "document_batch_m.jsp?pageSize=" + pageSize + "&op=search";
	if(!fDirCode.equals("all"))
		redirectUrl = redirectUrl + "&fDirCode=" + fDirCode;
	if(!titleKey.equals(""))
		redirectUrl = redirectUrl + "&titleKey=" + titleKey;
	if(!name.equals(""))
		redirectUrl = redirectUrl + "&name=" + name;
	if(!sBeginDate.equals(""))
		redirectUrl = redirectUrl + "&beginDate=" + sBeginDate;
	if(!sEndDate.equals(""))
		redirectUrl = redirectUrl + "&endDate=" + sEndDate;
	out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), redirectUrl));
	return;
}
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">文章批量管理</td>
    </tr>
  </tbody>
</table>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
 <form name="form1" method="post" action="?op=search">
  <tr> 
    <td height=20 align="left" class="thead">搜索符合条件文章</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <table width="86%"  border="0" align="center" cellpadding="3" cellspacing="1" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">  
	  <tr>
	    <td colspan="2" align="left" class="thead">搜索条件</td>
	    </tr>
	  <tr>
        <td width="45%" class="tbg1">&nbsp;所在栏目</td>
        <td width="55%" class="tbg1" style="height:28px">&nbsp;
		<select name="fDirCodeHelper" onChange="dirChange(this.value)">
	    <option value="all" selected>全部目录</option>
        <%
		Leaf lf = dir.getLeaf("root");
		java.util.Iterator ir = lf.getChildren().iterator();
		while(ir.hasNext()){
			lf = (Leaf)ir.next();
			
			LeafPriv lp = new LeafPriv(lf.getCode());
            if (lp.canUserSeeWithAncestorNode(privilege.getUser(request))) {			
			%>
          	<option value="<%=lf.getCode()%>"><%=lf.getName()%></option>
        <%	}
		}
	%>
        </select>
		<span id="secMenu">
		<input name="fDirCode" value="<%=fDirCode%>" type="hidden" />
		</span>
		</td>
	  </tr>  
	  <tr>
        <td width="45%" class="tbg1">&nbsp;文章作者(多用户名中间请用半角逗号 "," 分割)</td>
        <td width="55%" class="tbg1" style="height:28px">&nbsp;&nbsp;<input type="text" name="name" value="<%=name%>" /></td>
	  </tr> 
	  <tr>
        <td width="45%" class="tbg1">&nbsp;文章标题关键字</td>
        <td width="55%" class="tbg1" style="height:28px">&nbsp;&nbsp;<input type="text" name="titleKey" value="<%=titleKey%>"/></td>
	  </tr>   
	  <tr>
        <td width="45%" class="tbg1">&nbsp;文章发表时间范围(格式 yyyy-mm-dd，不限制为空)</td>
        <td width="55%" class="tbg1" style="height:28px">&nbsp;&nbsp;从&nbsp;<input name="beginDate" value="<%=sBeginDate%>" onclick="showcalendar(event, this)" readonly>&nbsp;到&nbsp;<input name="endDate" value="<%=sEndDate%>" onclick="showcalendar(event, this)" readonly></td>
	  </tr>
	  <tr>
	    <td class="tbg1">&nbsp;搜索结果每页显示行数</td>
	    <td class="tbg1" style="height:28px">&nbsp;
	      <input type="text" name="pageSize" value="<%=pageSize%>"/></td>
	    </tr>     
    </table>
      <br>
      <table width="86%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td align="center"><INPUT type=submit value="开始搜索"></td>
        </tr>
      </table>
      <br></td>
  </tr>
  </form>
</table>
<br>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">文章批量操作</td>
  </tr>
  <tr> 
    <td valign="top"><br><table width="86%" border="0" align="center" cellpadding="3" cellspacing="1" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
      <tr>
        <td colspan="2" class="thead">相关操作</td>
      </tr>  
      <tr>
        <td width="36%" class="tbg1">&nbsp;批量移动到栏目</td>
        <td width="64%" class="tbg1" style="height:28px">&nbsp;
		<select name="tDirCodeHelper" onChange="tDirChange(this.value)">
	    <option value="not" selected><lt:Label res="res.label.webedit" key="select_sort"/></option>
        <%
		lf = dir.getLeaf(Leaf.ROOTCODE);
		ir = lf.getChildren().iterator();
		while(ir.hasNext()){
			lf = (Leaf)ir.next();
			LeafPriv lp = new LeafPriv(lf.getCode());
            if (lp.canUserSeeWithAncestorNode(privilege.getUser(request))) {			
			%>
          	<option value="<%=lf.getCode()%>"><%=lf.getName()%></option>
        <%	}
		}
	%>
        </select>
		<span id="secTMenu">
		<input name="tDirCode" value="not" type="hidden" />
		</span></td>
      </tr>        
    </table>
	<br>
	<div align="center"><INPUT type=button onclick="doOperation()" value=<lt:Label key="ok"/>></div>
	<br>
   </td>
  </tr>
</table>
<br>
<br>
<%
int id = -1, docLevel = -1, docType = -1, examine = -1;
boolean isHome = false, isBold = false;
String color = "", title = "", class1 = "";
java.util.Date expireDate = null;
java.util.Date modifiedDate = null; 

if (op.equals("search")) {
	sql = "select id from document";
	
	if(!fDirCode.equals("all")){
		if(!fDirCode.equals("not")){
			condition += "class1="  + StrUtil.sqlstr(fDirCode);
		}else{
			out.print(StrUtil.Alert_Back("所在栏目不能选择分类类型节点!"));
			return;
		}
		if(!querystr.equals(""))
			querystr = querystr + "&fDirCode=" + StrUtil.UrlEncode(fDirCode);
		else
			querystr = "fDirCode=" + StrUtil.UrlEncode(fDirCode);
	}
	
	if(!name.trim().equals("")){
		if(!condition.equals(""))
			condition += " and ";
		String[] nameAry = StrUtil.split(name, ",");
		String strName = "";
		if (nameAry!=null) {
			int length = nameAry.length;
			for (int j=0; j<length; j++) {
				strName += "'" + nameAry[j] + "'";
				if(j < length - 1 && !nameAry[j].equals(""))
					strName += ",";
			}
		}
		
		condition += "author in (" + strName + ")";
		if(!querystr.equals(""))
			querystr = querystr + "&name=" + StrUtil.UrlEncode(name);
		else
			querystr = "name=" + StrUtil.UrlEncode(name);
	}
	
	if(!titleKey.trim().equals("")){
		if(!condition.equals(""))
			condition += " and ";
		condition += "title like " + StrUtil.sqlstr("%"+titleKey+"%");
		if(!querystr.equals(""))
			querystr = querystr + "&titleKey=" + StrUtil.UrlEncode(titleKey);
		else
			querystr = "titleKey=" + StrUtil.UrlEncode(titleKey);
	}	 
	
	if(!sBeginDate.trim().equals("") && !sEndDate.trim().equals("")){
		if(!condition.equals(""))
			condition += " and ";
		java.util.Date beginDate = DateUtil.parse(sBeginDate, "yyyy-MM-dd");
		java.util.Date endDate = DateUtil.parse(sEndDate, "yyyy-MM-dd");
		long lBeginDate = beginDate.getTime();
		long lEndDate = endDate.getTime() + 24*60*60*1000;
		condition += "createDate>=" + lBeginDate + " and createDate<" + lEndDate;
		if(!querystr.equals(""))
			querystr = querystr + "&beginDate=" + StrUtil.UrlEncode(sBeginDate) + "&endDate=" + StrUtil.UrlEncode(sEndDate);
		else
			querystr = "beginDate=" + StrUtil.UrlEncode(sBeginDate) + "&endDate=" + StrUtil.UrlEncode(sEndDate);
	}else{
		if(!sBeginDate.trim().equals("")){
			if(!condition.equals(""))
				condition += " and ";
			java.util.Date beginDate = DateUtil.parse(sBeginDate, "yyyy-MM-dd");
			long lBeginDate = beginDate.getTime();	
			condition += "createDate>=" + lBeginDate;
			if(!querystr.equals(""))
				querystr = querystr + "&sBeginDate=" + StrUtil.UrlEncode(sBeginDate);
		    else
				querystr = "sBeginDate=" + StrUtil.UrlEncode(sBeginDate);
		}else{
			if(!sEndDate.trim().equals("")){
				if(!condition.equals(""))
					condition += " and ";
				java.util.Date endDate = DateUtil.parse(sEndDate, "yyyy-MM-dd");
				long lEndDate = endDate.getTime() + 24*60*60*1000;
				condition += "createDate<" + lEndDate;
				if(!querystr.equals(""))
					querystr = querystr + "&sEndDate=" + StrUtil.UrlEncode(sEndDate);
				else
					querystr = "sEndDate=" + StrUtil.UrlEncode(sEndDate);
			}			
		}
	}

	if(!condition.equals("")){
		condition = " where " + condition;
		sql = sql + condition;
	}
	
	String orderby = " ORDER BY createDate desc";
	sql = sql + orderby;
	
	Paginator paginator = new Paginator(request);
	int curpage = paginator.getCurPage();
	PageConn pageconn = new PageConn(Global.defaultDB, curpage, pageSize);
	ResultIterator ri = pageconn.getResultIterator(sql);
	paginator.init(pageconn.getTotal(), pageSize);
	
	ResultRecord rr = null;
	
	//设置当前页数和总页数
	int totalpages = paginator.getTotalPages();
	if (totalpages==0)
	{
		curpage = 1;
		totalpages = 1;
	}
%>
<table width="98%" border="0" align="center" class="p9">
  <tr>
    <td height="20" align="right"><lt:Label res="res.label.cms.doc" key="found_right_list"/><b><%=paginator.getTotal() %></b><lt:Label res="res.label.cms.doc" key="page_list"/><b><%=paginator.getPageSize() %></b><lt:Label res="res.label.cms.doc" key="page"/><b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %>&nbsp;</b></td>
  </tr>
</table>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellspacing="1" cellpadding="3" width="98%" align="center">
  <tbody>
    <tr>
      <td width="9%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px">编号</td>
      <td width="31%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px"><lt:Label res="res.label.cms.doc" key="title"/></td>
      <td width="12%" align="center" nowrap class="thead">栏目</td>
      <td width="8%" align="center" nowrap class="thead"><lt:Label res="res.label.cms.doc" key="type"/></td>
      <td width="8%" align="center" nowrap class="thead"><lt:Label res="res.label.cms.doc" key="modify_date"/></td>
      <td width="6%" align="center" nowrap class="thead"><lt:Label res="res.label.cms.doc" key="check_state"/></td>
      <td width="26%" align="center" nowrap class="thead"><lt:Label res="res.label.cms.doc" key="mgr"/></td>
    </tr>
<%
	Document doc = null;
	DocumentMgr dm = new DocumentMgr();

	while (ri.hasNext()) {
		rr = (ResultRecord)ri.next(); 
		id = rr.getInt("id");
		doc =  dm.getDocument(id);
		isHome = doc.getIsHome();
		color = doc.getColor();
		isBold = doc.isBold();
		expireDate = doc.getExpireDate();
		modifiedDate = doc.getModifiedDate();
		docLevel = doc.getLevel();
		title = doc.getTitle();
		class1 = doc.getDirCode();
		docType = doc.getType();
		examine = doc.getExamine();
%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td><input name="ids" type="checkbox" value="<%=id%>"><%=id%></td>
      <td style="PADDING-LEFT: 10px">
<%
	  	if (docLevel == Document.LEVEL_TOP)
	  		out.print("[置顶]&nbsp;");
		if (DateUtil.compare(new java.util.Date(), expireDate)==2) {
%>
          <a target="_blank" href="../doc_view.jsp?id=<%=id%>" title="<%=title%>">
<%
		if (isBold)
			out.print("<B>");
		if (!color.equals("")) {
%>
          <font color="<%=color%>">
<%
		}
%>
          <%=title%>
<%
		if (!color.equals("")) {
%>
          </font>
<%
		}
		if (isBold)
			out.print("</B>");
%>
          </a>
          <%}else{%>
          <a target="_blank" href="../doc_view.jsp?id=<%=id%>" title="<%=title%>"><%=title%></a>
          <%}%></td>
      <td align="center"><%
	  Leaf lf6 = dir.getLeaf(class1);
	  if (lf6!=null)
		  out.print("<a href='document_list_m.jsp?dir_code=" + lf6.getCode() + "'>" + lf6.getName() + "</a>");
	  %>
      </td>
      <td align="center"><%
	  if (docType == 0)
	  	out.print("文章");
	  else if (docType == 1)
	  	out.print("投票");
	  else
	  	out.print("链接");
	  %>
      </td>
      <td align="center"><%
	  if (modifiedDate!=null)
	  	out.print(DateUtil.format(modifiedDate, "yy-MM-dd"));
	  %></td>
      <td align="center"><%
	  if (examine==0)
	  	out.print("<font color='blue'>" + SkinUtil.LoadString(request, "res.label.cms.doc","no_check") + "</font>");
	  else if (examine==1)
	  	out.print("<font color='red'>" + SkinUtil.LoadString(request, "res.label.cms.doc","no_pass") + "</font>");
	  else if (examine==10)
	  	out.print("<font color='#FFCC00'>" + SkinUtil.LoadString(request, "res.label.webedit","dustbin") + "</font>");
	  else
	  	out.print(SkinUtil.LoadString(request, "res.label.cms.doc","pass"));
	  %></td>
      <td align="left">
	  <a href="../fckwebedit.jsp?op=edit&id=<%=id%>&dir_code=<%=StrUtil.UrlEncode(class1)%>">[
	  <lt:Label res="res.label.cms.doc" key="edit"/>]</a> 
	  <a onClick="return confirm('您确定要删除吗？')" href="document_batch_m.jsp?pageSize=<%=pageSize%>&op=del&id=<%=id%><%if(!querystr.equals("")) out.print("&" + querystr);%>">[<lt:Label res="res.label.cms.doc" key="del"/>]</a>&nbsp;
  	  <%if (doc.getExamine()!=Document.EXAMINE_PASS) {%>
	  <a href="document_batch_m.jsp?pageSize=<%=pageSize%>&op=passExamine&examine=<%=Document.EXAMINE_PASS%>&ids=<%=id%><%if(!querystr.equals("")) out.print("&" + querystr);%>">[通过]</a>
	  <%}else{%>
	  <a href="document_batch_m.jsp?pageSize=<%=pageSize%>&op=passExamine&examine=<%=Document.EXAMINE_NOT%>&ids=<%=id%><%if(!querystr.equals("")) out.print("&" + querystr);%>">[未审核]</a>
	  <%}%>  
	  <%if (docLevel != Document.LEVEL_TOP) {%>
      <a onClick="return confirm('您确定要置顶吗？')" href="document_batch_m.jsp?pageSize=<%=pageSize%>&op=setOnTop&level=<%=Document.LEVEL_TOP%>&id=<%=id%><%if(!querystr.equals("")) out.print("&" + querystr);%>">[置顶]</a>
      <%}else{%>
      <a onClick="return confirm('您确定要取消置顶吗？')" href="document_batch_m.jsp?pageSize=<%=pageSize%>&op=setOnTop&level=0&id=<%=id%><%if(!querystr.equals("")) out.print("&" + querystr);%>">[取消置顶]</a>
      <%}%></td>
    </tr>
    <%}%>
  </tbody>
</table>
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="2" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td width="42%" align="left"><input name="button3" type="button" onClick="selAllCheckBox('ids')" value="<lt:Label res="res.label.forum.topic_m" key="sel_all"/>">
      &nbsp;&nbsp;
      <input name="button3" type="button" onClick="clearAllCheckBox('ids')" value="<lt:Label res="res.label.forum.topic_m" key="clear_all"/>">
      &nbsp;
      <input name="button3" type="button" onClick="doDel('<%=querystr%>')" value="<lt:Label key="op_del"/>">
      &nbsp;
      </td>
    <td width="58%" align="right">
<%
	strDoOperation = querystr;
	if(!querystr.equals(""))
		querystr = querystr + "&op=" + op;
	else
		querystr = "op=" + op;
    out.print(paginator.getCurPageBlock("document_batch_m.jsp?pageSize="+ pageSize + "&" + querystr));
%>
</td>
  </tr>
</table>
<%
}
%>

</body>
<script>
function doOperation() {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("<lt:Label res="res.label.forum.topic_m" key="need_id"/>");
		return;
	}

	var tDirValue = tDirCode.value;
	window.location.href = "document_batch_m.jsp?pageSize=" + form1.pageSize.value + "&op=moveBoard&tDirCode=" + tDirValue + "&ids=" + ids + "&<%=strDoOperation%>";

}

function doDel(querystr) {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("请选择文章！");
		return;
	}
	if(querystr != "")
		window.location.href = "document_batch_m.jsp?pageSize=" + form1.pageSize.value + "&op=delBatch&ids=" + ids + "&" + querystr;
	else
		window.location.href = "document_batch_m.jsp?pageSize=" + form1.pageSize.value + "&op=delBatch&ids=" + ids;
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