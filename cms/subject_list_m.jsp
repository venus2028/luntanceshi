<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.cms.doc" key="artical_list"/></title>
<link href="../common.css" rel="stylesheet" type="text/css">
<link href="default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
<style type="text/css">
<!--
.style4 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>
<script src="../inc/calendar.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="sm" scope="page" class="cn.js.fan.module.cms.SubjectMgr"/>
<%
//if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN))
//{
//	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
//	return;
//}
%>
<%
String dir_code = ParamUtil.get(request, "code");
String op = StrUtil.getNullString(request.getParameter("op"));
SubjectDb leaf = sm.getSubjectDb(dir_code);
String dir_name = "";
if (leaf!=null)
	dir_name = leaf.getName();

String sql = "select s.id from cws_cms_subject_doc s, document d where s.doc_id=d.id and s.code=" + StrUtil.sqlstr(dir_code);

String what = "";
String kind = "";
if (op.equals("search")) {
	sql = "select s.id from cws_cms_subject_doc s, document d where s.doc_id=d.id and s.code=" + StrUtil.sqlstr(dir_code);
	kind = ParamUtil.get(request, "kind");
	what = ParamUtil.get(request, "what");
	if (kind.equals("title"))
		sql += " and d.title like "+StrUtil.sqlstr("%"+what+"%");
	// else if (kind.equals("content"))
	// 	sql += " and content like " + StrUtil.sqlstr("%" + what + "%");
	else
		sql += " and d.keywords like " + StrUtil.sqlstr("%" + what + "%");
}

sql += " order by s.doc_level desc, d.examine asc, s.create_date desc";
	
SubjectListDb sld = new SubjectListDb();

if (op.equals("del")) {
	long id = ParamUtil.getLong(request, "id");
	sld = sld.getSubjectListDb(id);
	if (sld.del(new JdbcTemplate()))
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "subject_list_m.jsp?code=" + StrUtil.UrlEncode(dir_code)));
	else 
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
}

if (op.equals("delBatch")) {
	try {
		sld.delBatch(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "subject_list_m.jsp?code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}	
}

if (op.equals("setOnTop")) {
	try {
		long id = ParamUtil.getLong(request, "id");
		sld = sld.getSubjectListDb(id);
		int level = ParamUtil.getInt(request, "level");
		sld.setLevel(level);
		boolean re = sld.save(new JdbcTemplate());
		if (re)
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "subject_list_m.jsp?code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}	
}

if (op.equals("createHtml")) {
	try {
		docmanager.createSubjectHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "subject_list_m.jsp?code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}

if (op.equals("createListHtml")) {
	try {
		docmanager.createSubjectListHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "subject_list_m.jsp?code=" + StrUtil.UrlEncode(dir_code)));
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
      <td class="head"><%
	  if (!op.equals("search")) {
	  	if (leaf!=null && leaf.isLoaded()) {
			SubjectDb lf = leaf;
			String navstr = "";
			String parentcode = lf.getParentCode();
			SubjectDb plf = new SubjectDb();
			while (!parentcode.equals("root")) {
				plf = plf.getSubjectDb(parentcode);
				if (plf==null || !plf.isLoaded())
					break;

				navstr = "<a href='subject_list_m.jsp?dir_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				
				parentcode = plf.getParentCode();
			}
			out.print(navstr + lf.getName());
		}
		else
			out.print(SkinUtil.LoadString(request, "res.label.cms.doc","artical_list"));
	}
	else
			out.print(SkinUtil.LoadString(request, "res.label.cms.doc","search_result"));
		%>
	<%
	if (!dir_code.equals("")) {
		cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
		boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
		if (isHtml) {
			out.print("[<a target=_blank href='" + request.getContextPath() + "/" + leaf.getListHtmlNameByPageNum(request, 1) + "'>预览首页</a>]");
		}
		else {
			out.print("[<a target=_blank href='" + request.getContextPath() + "/subject_list_view.jsp?dirCode=" + StrUtil.UrlEncode(dir_code) + "'>预览首页</a>]");
		}
	}
	%>		
	  </td>
    </tr>
  </tbody>
</table>
<br>
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" class="p9">
  <form name="form1" action="subject_list_m.jsp?op=search" method="post">
    <tr>
      <td align="center">在专题中搜索
        <lt:Label res="res.label.cms.doc" key="an"/>
          <select name="kind">
            <option value="title">
              <lt:Label res="res.label.cms.doc" key="title"/>
            </option>
            <option value="keywords">
              <lt:Label res="res.label.cms.doc" key="key_words"/>
            </option>
          </select>
        &nbsp;
        <input name=what size=20>
        &nbsp;
        <input name="Submit" type="submit" value=<%=SkinUtil.LoadString(request, "res.label.cms.doc","search")%>>
		<input type="hidden" name="code" value="<%=dir_code%>">
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
PageConn pageconn = new PageConn(Global.defaultDB, Integer.parseInt(strcurpage), pagesize);
ResultIterator ri = pageconn.getResultIterator(sql);
ResultRecord rr = null;

Paginator paginator = new Paginator(request, pageconn.getTotal(), pagesize);
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
      <td width="9%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px">编号</td>
      <td width="46%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px"><lt:Label res="res.label.cms.doc" key="title"/></td>
      <td width="16%" align="center" nowrap class="thead">创建时间</td>
      <td width="9%" align="center" nowrap class="thead"><lt:Label res="res.label.cms.doc" key="check_state"/></td>
      <td width="20%" align="center" nowrap class="thead"><lt:Label res="res.label.cms.doc" key="mgr"/></td>
    </tr>
<%
SubjectListDb sld2 = new SubjectListDb();
DocumentMgr dm = new DocumentMgr();
while (ri.hasNext()) {
 	rr = (ResultRecord)ri.next();
	sld = sld2.getSubjectListDb(rr.getLong(1));
	Document doc = dm.getDocument(sld.getDocId());
	boolean isHome = doc.getIsHome();
	String color = doc.getColor();
	boolean isBold = doc.isBold();
	java.util.Date expireDate = doc.getExpireDate();	
	%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td><input name="ids" type="checkbox" value="<%=sld.getId()%>">
        <%=doc.getId()%>      </td>
      <td style="PADDING-LEFT: 10px">
	  <%
	  if (sld.getLevel()==SubjectListDb.LEVEL_TOP)
	  	out.print("[置顶]&nbsp;");
	  %>
	<%if (DateUtil.compare(new java.util.Date(), doc.getExpireDate())==2) {%>
          <a href="../doc_show.jsp?id=<%=rr.getInt("id")%>" title="<%=doc.getTitle()%>">
          <%
		if (doc.isBold())
			out.print("<B>");
		if (!doc.getColor().equals("")) {
		%>
          <font color="<%=doc.getColor()%>">
          <%}%>
          <%=doc.getTitle()%>
          <%if (!doc.getColor().equals("")) {%>
          </font>
          <%}%>
          <%
		if (doc.isBold())
			out.print("</B>");
		%>
          </a>
          <%}else{%>
			<a target="_blank" href="../doc_view.jsp?id=<%=doc.getId()%>" title="<%=doc.getTitle()%>"><%=doc.getTitle()%></a>
          <%}%>	  
      </td>
      <td align="center">
	  <%=DateUtil.format(doc.getCreateDate(), "yyyy-MM-dd HH:mm")%>
	  </td>
      <td align="center"><%
	  int examine = doc.getExamine();
	  if (examine==0)
	  	out.print("<font color='blue'>" + SkinUtil.LoadString(request, "res.label.cms.doc","no_check") + "</font>");
	  else if (examine==1)
	  	out.print("<font color='red'>" + SkinUtil.LoadString(request, "res.label.cms.doc","no_pass") + "</font>");
	  else if (examine==10)
	  	out.print("<font color='#FFCC00'>" + SkinUtil.LoadString(request, "res.label.webedit","dustbin") + "</font>");
	  else
	  	out.print(SkinUtil.LoadString(request, "res.label.cms.doc","pass"));
	  %></td>
      <td align="center">
	  <a href="../fckwebedit.jsp?op=edit&id=<%=doc.getId()%>&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>">[<lt:Label res="res.label.cms.doc" key="edit"/>]</a> 
	  <a onClick="return confirm('您确定要从专题中删除吗，文章本身并不会被删除？')" href="subject_list_m.jsp?op=del&id=<%=sld.getId()%>&code=<%=StrUtil.UrlEncode(dir_code)%>">[<lt:Label res="res.label.cms.doc" key="del"/>]</a>
	  <%if (sld.getLevel()!=SubjectListDb.LEVEL_TOP) {%>
		  <a onClick="return confirm('您确定要置顶吗？')" href="subject_list_m.jsp?op=setOnTop&level=<%=SubjectListDb.LEVEL_TOP%>&id=<%=sld.getId()%>&code=<%=StrUtil.UrlEncode(dir_code)%>">[置顶]</a>
	  <%}else{%>
		  <a onClick="return confirm('您确定要取消置顶吗？')" href="subject_list_m.jsp?op=setOnTop&level=0&id=<%=sld.getId()%>&code=<%=StrUtil.UrlEncode(dir_code)%>">[取消置顶]</a>
		<%}%>	  </td>
    </tr>
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
      <input name="button3" type="button" onClick="clearAllCheckBox('ids')" value="<lt:Label res="res.label.forum.topic_m" key="clear_all"/>">
      &nbsp;
      <input name="button3" type="button" onClick="doDel()" value="<lt:Label key="op_del"/>">
      &nbsp;</td>
    <td width="58%" align="right"><%
	String querystr = "op=" + op + "&dir_code=" + StrUtil.UrlEncode(dir_code) + "&op=" + op;
    out.print(paginator.getCurPageBlock("document_list_m.jsp?"+querystr));
%></td>
  </tr>
</table>
<br>
<table width="98%" border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
  <tr>
    <td class="thead">生成静态页面</td>
  </tr>
  <tr>
    <form action="?op=createHtml" method="post">
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
        <input name="isIncludeChildren" value="true" type="checkbox">
        包含子文件夹
        &nbsp;
                  <input name="button2" type="submit" value="生成文章静态页面">
                  <input name="code" value="<%=dir_code%>" type="hidden">
        日期不填写，表示全部</td>
    </form>
  </tr>
  <tr>
    <form action="?op=createListHtml" method="post">
      <td>列表页的页码从
        <input type="text" id="pageNumBegin" name="pageNumBegin" size="10" value="1">
        至
        <input type="text" id="pageNumEnd" name="pageNumEnd" size="10">
        <input name="isIncludeChildren" value="true" type="checkbox">
        包含子文件夹
        &nbsp;
                <input name="button22" type="submit" value="生成列表静态页面">
                <input name="code" value="<%=dir_code%>" type="hidden">
        页码不填写，表示全部</td>
    </form>
  </tr>
</table>
</body>
<script src="../inc/common.js"></script>
<script>
function doDel() {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("请选择文章！");
		return;
	}
	window.location.href = "?op=delBatch&code=<%=StrUtil.UrlEncode(dir_code)%>&ids=" + ids;
}

function passExamineBatch() {
	var ids = getCheckboxValue("ids");
	if (ids=="") {
		alert("请选择文章！");
		return;
	}
	window.location.href = "?op=passExamine&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&ids=" + ids;
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