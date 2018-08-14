<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.doc" key="artical_list"/></title>
<link href="../../common.css" rel="stylesheet" type="text/css">
<link href="../default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<script src="../../inc/calendar.js"></script>
<script src="../../inc/common.js"></script>
</head>
<body>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String name = "", titleKey = "", sBeginDate = "", sEndDate = "", fDirCode = "", sql = "", condition = "",querystr = "", strDoOperation = "";
fDirCode = ParamUtil.get(request, "fDirCode");
if(fDirCode.equals("") || fDirCode.equals("not"))
	fDirCode = siteCode;
titleKey = ParamUtil.get(request, "titleKey");
name = ParamUtil.get(request, "name");
sBeginDate = ParamUtil.get(request, "beginDate");
sEndDate = ParamUtil.get(request, "endDate");
int pageSize = ParamUtil.getInt(request, "pageSize", 20);

String op = ParamUtil.get(request, "op");
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">选择文章</td>
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
		<select name="fDirCode">
		<%
		Leaf lf = dir.getLeaf(siteCode);
		DirectoryView dv = new DirectoryView(lf);
		dv.ShowDirectoryAsOptions(out, lf, lf.getLayer());
		%>
		</select>
		<script>
		<%if (!fDirCode.equals(siteCode)) {%>
		form1.fDirCode.value = '<%=fDirCode%>'
		<%}%>
		</script>
		</td>
	  </tr>  
	  <tr>
        <td width="45%" class="tbg1">&nbsp;文章作者(多用户名中间请用半角逗号 "," 分割)</td>
        <td width="55%" class="tbg1" style="height:28px">&nbsp;&nbsp;<input type="text" name="name" value="<%=name%>" />
		<input name="siteCode" value="<%=siteCode%>" type="hidden">
		</td>
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
<%
int id = -1, docLevel = -1, docType = -1, examine = -1;
boolean isHome = false, isBold = false;
String color = "", title = "", class1 = "";
java.util.Date expireDate = null;
java.util.Date modifiedDate = null; 

	sql = "select id from document";
	
	if(!fDirCode.equals(siteCode)){
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
	else {
		Vector v = new Vector();
		lf.getAllChild(v, lf);
		Iterator ir = v.iterator();
		String dirCodes = "";
		while (ir.hasNext()) {
			lf = (Leaf)ir.next();
			if (dirCodes.equals(""))
				dirCodes = StrUtil.sqlstr(lf.getCode());
			else
				dirCodes += "," + StrUtil.sqlstr(lf.getCode());
		}
		condition = "class1 in (" + dirCodes + ")";
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
			querystr = querystr + "&sBeginDate=" + StrUtil.UrlEncode(sBeginDate) + "&sEndDate=" + StrUtil.UrlEncode(sEndDate);
		else
			querystr = "sBeginDate=" + StrUtil.UrlEncode(sBeginDate) + "&sEndDate=" + StrUtil.UrlEncode(sEndDate);
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
		sql += " and examine=" + Document.EXAMINE_PASS;
	}
	else
		sql += " where examine=" + Document.EXAMINE_PASS;
	
	String orderby = " ORDER BY createDate desc";
	sql = sql + orderby;
	
	Paginator paginator = new Paginator(request);
	int curpage = paginator.getCurPage();
	PageConn pageconn = new PageConn(Global.defaultDB, curpage, pageSize);
	ResultIterator ri = pageconn.getResultIterator(sql);
	paginator.init(pageconn.getTotal(), pageSize);
	
	ResultRecord rr = null;
	
	// 设置当前页数和总页数
	int totalpages = paginator.getTotalPages();
	if (totalpages==0) {
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
	  %>      </td>
      <td align="center"><%
	  if (docType == 0)
	  	out.print("文章");
	  else if (docType == 1)
	  	out.print("投票");
	  else
	  	out.print("链接");
	  %>      </td>
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
      <input name="button3" type="button" onClick="sel()" value="<lt:Label key="ok"/>">
      &nbsp;
    </td>
    <td width="58%" align="right">
<%
	strDoOperation = querystr;
	if(!querystr.equals(""))
		querystr = querystr + "&op=" + op;
	else
		querystr = "op=" + op;
    out.print(paginator.getCurPageBlock("document_sel.jsp?pageSize="+ pageSize + "&" + querystr));
%>
</td>
  </tr>
</table>
</body>
<script>
function sel() {
	var ids = getCheckboxValue("ids");
	window.opener.selDoc(ids);
	window.close();
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