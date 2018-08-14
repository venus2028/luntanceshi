<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.cloudwebsoft.framework.db.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.cms.site.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String op = StrUtil.getNullString(request.getParameter("op"));
String dir_code = ParamUtil.get(request, "dir_code");

LeafPriv lp = new LeafPriv(dir_code);
Leaf leaf = dir.getLeaf(dir_code);

if (!dir_code.equals("")) {
	if (leaf==null) {
		out.print(StrUtil.Alert_Back("请选择正确的目录节点！"));
		return;
	}
	if (leaf.getCode().equals(Leaf.ROOTCODE) || leaf.getType()==Leaf.TYPE_NONE) {
		response.sendRedirect("dir_common.jsp?dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
		return;
	}
	else if (leaf.getType()==Leaf.TYPE_COLUMN) {
		response.sendRedirect("column.jsp?dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
		return;
	}
	else if (leaf.getType()==Leaf.TYPE_SUB_SITE) {
		response.sendRedirect("subsite.jsp?dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
		return;
	}
	else if (leaf.getType()==Leaf.TYPE_DOCUMENT) {
		response.sendRedirect("../fckwebedit_new.jsp?op=editarticle&dir_code=" + StrUtil.UrlEncode(leaf.getCode()));
		return;
	}
}

if (!dir_code.equals("")) {
	if (!lp.canUserSee(privilege.getUser(request))) {
		out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
		return;
	}
}

String userName = privilege.getUser(request);	

String orderBy = ParamUtil.get(request, "orderBy");
if (orderBy.equals(""))
	orderBy = "createDate";
String sort = ParamUtil.get(request, "sort");
if (sort.equals(""))
	sort = "desc";
	
String what = ParamUtil.get(request, "what");
String kind = ParamUtil.get(request, "kind");
int myexamine = ParamUtil.getInt(request, "myexamine", -1);
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
.brotherNode {
background-color:#F5F5FA;
}
-->
</style>
<script type="text/javascript" src="../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../util/jscalendar/calendar-win2k-2.css"); </style>
<script>
var curOrderBy = "<%=orderBy%>";
var sort = "<%=sort%>";
function doSort(orderBy) {
	if (orderBy==curOrderBy)
		if (sort=="asc")
			sort = "desc";
		else
			sort = "asc";
	window.location.href = "document_list_m.jsp?op=<%=op%>&dir_code=<%=dir_code%>&kind=<%=kind%>&what=<%=StrUtil.UrlEncode(what)%>&myexamine=<%=myexamine%>&orderBy=" + orderBy + "&sort=" + sort;
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<%
String dir_name = "";
if (leaf!=null)
	dir_name = leaf.getName();
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	try {
		if (docmanager.del(request, id, privilege, true))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
		else 
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	op = "";
}
else if (op.equals("delBatch")) {
	try {
		docmanager.delBatch(request, true);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
else if (op.equals("passExamine")) {
	try {
		int examine = ParamUtil.getInt(request, "examine", Document.EXAMINE_NOT);
		docmanager.passExamineBatch(request, examine);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
else if (op.equals("createHtml")) {
	try {
		docmanager.createHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
else if (op.equals("createListHtml")) {
	try {
		docmanager.createListHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
else if (op.equals("setOnTop")) {
	try {
		int id = ParamUtil.getInt(request, "id");
		Document doc = docmanager.getDocument(id);
        lp = new LeafPriv(doc.getDirCode());
		if (!lp.canUserExamine(privilege.getUser(request))) {
			out.print(StrUtil.Alert_Back(cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
			return;
		}
		int level = ParamUtil.getInt(request, "level");
		doc.setLevel(level);
		boolean re = doc.UpdateLevel();
		
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(dir_code)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	return;
}

cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
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
					navstr = "<a href='document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;				
					// navstr = plf.getName() + "&nbsp;>>&nbsp;" + navstr;
				
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
	%>		
	  </td>
    </tr>
  </tbody>
</table>
<%
String sql = "select id,class1,title,isHome,examine,createDate,color,isbold,expire_date,doc_type,doc_level,hit,author from document where examine<>" + Document.EXAMINE_DUSTBIN;
if (op.equals("search")) {
	if (kind.equals("title"))
		sql += " and title like "+StrUtil.sqlstr("%"+what+"%");
	else if (kind.equals("content")) {
		sql = "select distinct id,class1,title,isHome,examine,createDate,color,isbold,expire_date,doc_type,doc_level,hit from document as d, doc_content as c where d.id=c.doc_id and examine<>" + Document.EXAMINE_DUSTBIN;
	 	sql += " and c.content like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (kind.equals("author")) {
		sql += " and author like " + StrUtil.sqlstr("%" + what + "%");
	}
	else if (kind.equals("id")) {
		sql += " and id=" + what;
	}
	else
		sql += " and keywords like " + StrUtil.sqlstr("%" + what + "%");
	if (!privilege.isUserPrivValid(request, "admin") && !dir_code.equals(""))
		sql += " and class1=" + StrUtil.sqlstr(dir_code);
}
else {
	if (!dir_code.equals(""))
		sql += " and class1=" + StrUtil.sqlstr(dir_code);
}

String waitCheckSql = SQLFilter.getCountSql(sql) + " and examine=" + Document.EXAMINE_NOT;

if (myexamine!=-1) {
	sql += " and examine=" + myexamine;
}

sql += " order by doc_level desc, " + orderBy + " " + sort;

// out.print(sql);

String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
if (strcurpage.equals(""))
	strcurpage = "1";
if (!StrUtil.isNumeric(strcurpage)) {
	out.print(StrUtil.makeErrMsg(StrUtil.Alert_Back(SkinUtil.LoadString(request, "err_id"))));
	return;
}
int pagesize = 20;
int curpage = Integer.parseInt(strcurpage);
JdbcTemplate jt = new JdbcTemplate();
ResultIterator ri = jt.executeQuery(sql, Integer.parseInt(strcurpage), pagesize);
ResultRecord rr = null;

Paginator paginator = new Paginator(request, jt.getTotal(), pagesize);
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>
<br>
<table width="98%" align="center" class="p9">
  <tr><td>
<%
	if (!dir_code.equals("") && leaf.getType()==Leaf.TYPE_LIST) {
		lp = new LeafPriv(dir_code);
		if (lp.canUserAppend(privilege.getUser(request))) {
	%>
	  &nbsp;<a href="#" onClick="javascript:location.href='../<%=DocumentMgr.getWebEditPage()%>?op=add&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name, "utf-8")%>';">添加文章</a>
	<%}
	if (!dir_code.equals("")) {
		if (isHtml) {
			out.print("┆&nbsp;<a target=_blank href='" + request.getContextPath() + "/" + leaf.getListHtmlNameByPageNum(request, 1) + "'>预览静态页面</a>&nbsp;");
		}
		out.print("┆&nbsp;<a target=_blank href='" + request.getContextPath() + "/doc_list_view.jsp?dirCode=" + StrUtil.UrlEncode(dir_code) + "'>预览页面</a>&nbsp;");
		
		// lp.setDirCode(dir_code);
		// if (lp.canUserModify(privilege.getUser(request))) {
		%>      ┆&nbsp;<a href="dir_frame.jsp?root_code=<%=StrUtil.UrlEncode(dir_code)%>">管理目录</a>
        <%
		// }
	}
	if (lp.canUserExamine(privilege.getUser(request))) {
		%>
	  ┆&nbsp;<a href="comment_dir_m.jsp?dirCode=<%=StrUtil.UrlEncode(dir_code)%>">管理评论</a>
	  <%}
	 }%>
	 <%
	 ResultIterator ri2 = jt.executeQuery(waitCheckSql);
	 int waitCheckCount = 0;
	 if (ri2.hasNext()) {
	 	ResultRecord rr2 = (ResultRecord)ri2.next();
		waitCheckCount = rr2.getInt(1);
	 }
	 %>
	 ┆&nbsp;<a href="document_list_m.jsp?op=<%=op%>&dir_code=<%=dir_code%>&kind=<%=kind%>&what=<%=StrUtil.UrlEncode(what)%>&myexamine=<%=Document.EXAMINE_NOT%>&orderBy=<%=orderBy%>&sort=<%=sort%>">待审(<%=waitCheckCount%>)</a>
</td></tr></table>
<table width="98%" border="0" align="center" class="p9">
  <tr>
    <td height="24" align="right"><lt:Label res="res.label.cms.doc" key="found_right_list"/><b><%=paginator.getTotal() %></b><lt:Label res="res.label.cms.doc" key="page_list"/><b><%=paginator.getPageSize() %></b><lt:Label res="res.label.cms.doc" key="page"/><b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="3" cellspacing="1" class="frame_gray">
  <tbody>
    <tr>
      <td width="9%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px">编号</td>
      <td width="27%" align="center" nowrap class="thead" style="PADDING-LEFT: 10px"><lt:Label res="res.label.cms.doc" key="title"/></td>
      <td width="9%" align="center" nowrap class="thead" onClick="doSort('class1')" style="cursor:pointer">目录
		<%if (orderBy.equals("class1")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%></td>
	  <td width="6%" align="center" nowrap class="thead" onClick="doSort('author')" style="cursor:pointer">作者
      <%if (orderBy.equals("author")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%></td>
	  <td width="6%" align="center" nowrap class="thead" onClick="doSort('hit')" style="cursor:pointer">点击
		<%if (orderBy.equals("hit")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%></td>
		<td width="9%" align="center" nowrap class="thead" onClick="doSort('createDate')" style="cursor:pointer">创建日期
	  <%if (orderBy.equals("createDate")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>	  </td>
      <td width="6%" align="center" nowrap class="thead" onClick="doSort('examine')" style="cursor:pointer"><lt:Label res="res.label.cms.doc" key="check_state"/>
		<%if (orderBy.equals("examine")) {
			if (sort.equals("asc")) 
				out.print("<img src='../netdisk/images/arrow_up.gif' width=8px height=7px>");
			else
				out.print("<img src='../netdisk/images/arrow_down.gif' width=8px height=7px>");
		}%>
	  </td>
      <td width="28%" align="center" nowrap class="thead"><lt:Label res="res.label.cms.doc" key="mgr"/></td>
    </tr>
	<%
	if (!dir_code.equals("") && !leaf.getParentCode().equals("-1")) {
		boolean canUp = true;
		if (leaf.getType()==Leaf.TYPE_SUB_SITE) {
			if (!privilege.isUserPrivValid(request, "admin"))
				canUp = false;
		}
		if (canUp) {
	%>
	   <tr class="brotherNode">
	     <td colspan="8" title="与<%=leaf.getName()%>同级的其它目录节点" align="left" style="border-bottom:1px dotted #cccccc;">
		<div class="subDir">
		<span>
		 <%
		 Leaf pLeaf = dir.getLeaf(leaf.getParentCode());
		 %> 
		 <img src="images/parent.gif" />
		 <a href="document_list_m.jsp?dir_code=<%=leaf.getParentCode()%>"><%=pLeaf.getName()%></a>
		 </span>
		<span>
		<%
		if (pLeaf.getType()!=Leaf.TYPE_LINK) {
			if (pLeaf.getType()==Leaf.TYPE_LIST) {%>
			<a href="../<%=DocumentMgr.getWebEditPage()%>?op=add&dir_code=<%=StrUtil.UrlEncode(pLeaf.getCode())%>" title="发布文章"><img border="0" src="../images/modify.gif" /></a>
			<%}else{%>
			<a href="document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(pLeaf.getCode())%>" title="发布文章"><img border="0" src="../images/modify.gif" /></a>
			<%}
		}%>
		</span>		 
		 </div>
		<%
		java.util.Vector vp = pLeaf.getChildren();
		if (false && vp.size()>0) {
		%>
		<div style="clear:both">&nbsp;&nbsp;--同级目录--</div>
		<div style="height:45px;max-height:45px;height:expression(this.height>45?'45px':this.height); overflow:auto">
		<%	
		java.util.Iterator irp = vp.iterator();
		while (irp.hasNext()) {
			Leaf clf = (Leaf)irp.next();
			lp = new LeafPriv(clf.getCode());
        	if (!lp.canUserSeeWithAncestorNode(userName))
				continue;	  
	  	%>
	  <div class="subDir">
		<span>
		  <%if (clf.getChildCount()>0) {%>
		  <img src="../images/add.gif" />
		  <%}else{%>
		  <img src="../images/minus.gif" />
		  <%}%>
		  <!--<img src="images/folder_01.gif" />-->
		  <%
			String url = "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(clf.getCode());
			String className = "";
			if (clf.getType()==Leaf.TYPE_DOCUMENT) {
				url = "../" + DocumentMgr.getWebEditPage() + "?op=editarticle&dir_code=" + StrUtil.UrlEncode(clf.getCode());
			}
			else if (clf.getType()==Leaf.TYPE_LINK) {
				url = clf.getDescription();
				className = "class='link'";
			}
			else if (clf.getType()==Leaf.TYPE_COLUMN) {
				className = "class='column'";
			}			
			%>
      	<a href="<%=url%>" title="<%=clf.getName()%> (<%=clf.getTypeDesc(request)%>)" <%=clf.getType()==Leaf.TYPE_LINK?"target=_blank":""%> <%=className%>><%=clf.getName()%></a>
		</span>
	  	<span>
		<%
		if (clf.getType()!=Leaf.TYPE_LINK && clf.getType()!=Leaf.TYPE_SUB_SITE) {
			if (clf.getType()==Leaf.TYPE_LIST) {%>
			<a href="../<%=DocumentMgr.getWebEditPage()%>?op=add&dir_code=<%=StrUtil.UrlEncode(clf.getCode())%>" title="发布文章"><img border="0" src="../images/modify.gif" /></a>
			<%}else{%>
			<a href="document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(clf.getCode())%>" title="发布文章"><img border="0" src="../images/modify.gif" /></a>
			<%}
		}%>
		</span>
		</div>		
		<%}%>
		</div>
		<%}%>
		 </td>
    </tr>
	<%}
	}%>
	<%
	if (!dir_code.equals("")) {
		java.util.Vector vch = leaf.getChildren();
		if (vch.size()>0) {
	%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td colspan="8" align="left" style="border-bottom:1px dotted #cccccc">
	  <%
		java.util.Iterator irch = vch.iterator();
		while (irch.hasNext()) {
			Leaf clf = (Leaf)irch.next();
			lp = new LeafPriv(clf.getCode());
        	if (!lp.canUserSeeWithAncestorNode(userName))
				continue;	  
	  %>
	  <div class="subDir">
		<span>
		  <%if (clf.getChildCount()>0) {%>
		  <img src="../images/add.gif" />
		  <%}else{%>
		  <img src="../images/minus.gif" />
		  <%}%>
		  <!--<img src="images/folder_01.gif" />-->
		  <%
			String url = "document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(clf.getCode());
			String className = "";
			if (clf.getType()==Leaf.TYPE_DOCUMENT) {
				url = "../" + DocumentMgr.getWebEditPage() + "?op=editarticle&dir_code=" + StrUtil.UrlEncode(clf.getCode());
			}
			else if (clf.getType()==Leaf.TYPE_LINK) {
				url = clf.getDescription();
				className = "class='link'";
			}
			else if (clf.getType()==Leaf.TYPE_COLUMN) {
				className = "class='column'";
			}			
			%>
      	<a href="<%=url%>" title="<%=clf.getName()%> (<%=clf.getTypeDesc(request)%>)" <%=clf.getType()==Leaf.TYPE_LINK?"target=_blank":""%> <%=className%>><%=clf.getName()%></a>
		</span>
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
		<%}%>	  </td>
    </tr>
	<%}
	}%>
<%
Document doc = new Document();
while (ri.hasNext()) {
 	rr = (ResultRecord)ri.next(); 
	boolean isHome = rr.getBoolean("isHome");
	String color = StrUtil.getNullStr(rr.getString("color"));
	boolean isBold = rr.getInt("isBold")==1;
	java.util.Date expireDate = DateUtil.parse(rr.getString("expire_date"));
	doc = doc.getDocument(rr.getInt("id"));
	Leaf lf6 = dir.getLeaf(rr.getString("class1"));
	%>
    <tr onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" class="tbg1">
      <td>
          <input name="ids" type="checkbox" value="<%=rr.getInt("id")%>">
          <%=rr.getInt("id")%></td>
      <td style="PADDING-LEFT: 10px">
	  <%
	  if (rr.getInt("doc_level")>=Document.LEVEL_TOP)
	  	out.print("[置顶]");

	  if (rr.getString("doc_type").equals("1"))
	  	out.print("[投票]");
	  else if (rr.getString("doc_type").equals("2"))
	  	out.print("[链接]");
		String showUrl = "../doc_view.jsp?id=" + rr.getInt("id");
		if (lf6!=null && Leaf.isLeafOfSubsite(rr.getString("class1"))) {
			Leaf siteLeaf = Leaf.getSubsiteOfLeaf(rr.getString("class1"));
			String sCode = siteLeaf.getCode();
			SiteDb sd = new SiteDb();
			sd = sd.getSiteDb(sCode);
			if (sd.getInt("is_customize")==1) {
				showUrl = "../" + sCode + "_doc.jsp?docId=" + rr.getInt("id");
			}
			else
				showUrl = "../site_doc.jsp?siteCode=" + sCode + "&docId=" + rr.getInt("id");
		}
	  %>	  
	  <%if (expireDate==null || DateUtil.compare(new java.util.Date(), expireDate)==2) {
	  %>
          <a target="_blank" href="<%=showUrl%>" title="<%=rr.getString("title")%>">
          <%
		if (isBold)
			out.print("<B>");
		if (!color.equals("")) {
		%>
          <font color="<%=color%>">
          <%}%>
          <%=rr.getString("title")%>
          <%if (!color.equals("")) {%>
          </font>
          <%}%>
          <%
		if (isBold)
			out.print("</B>");
		%>
          </a>
          <%}else{%>
          <a target="_blank" href="<%=showUrl%>" title="<%=rr.getString("title")%>"><%=rr.getString("title")%></a>
          <%}%></td>
      <td align="left"><%
	  if (lf6!=null)
		  out.print("<a href='document_list_m.jsp?dir_code=" + lf6.getCode() + "'>" + lf6.getName() + "</a>");
	  %></td>
      <td align="center"><%=rr.get("author")%></td>
      <td align="center"><%=rr.getInt("hit")%></td>
      <td align="center"><%
	  java.util.Date d = DateUtil.parse(rr.getString("createDate"));
	  if (d!=null)
	  	out.print(DateUtil.format(d, "yy-MM-dd"));
	  %></td>
      <td align="center"><%
	  int examine = rr.getInt("examine");
	  if (examine==0)
	  	out.print("<font color='blue'>" + Document.getExamineDesc(request, examine) + "</font>");
	  else if (examine==1)
	  	out.print("<font color='red'>" + Document.getExamineDesc(request, examine) + "</font>");
	  else if (examine==Document.EXAMINE_DRAFT)
	  	out.print("<font color=''>" + Document.getExamineDesc(request, examine) + "</font>");
	  else if (examine==10)
	  	out.print("<font color='#FFCC00'>" + Document.getExamineDesc(request, examine) + "</font>");
	  else
	  	out.print(Document.getExamineDesc(request, examine));
	  %></td>
      <td align="left">
	  <%
	  lp = new LeafPriv(rr.getString("class1"));
	  if (lp.canUserModifyDoc(doc, privilege.getUser(request))) {
	  	  if (doc.getQuoteId()==Document.QUOTE_NONE) {
	  %>
		  <a href="../<%=DocumentMgr.getWebEditPage()%>?op=edit&id=<%=rr.getInt("id")%>&dir_code=<%=StrUtil.UrlEncode((String)rr.getString("class1"))%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>">[<lt:Label res="res.label.cms.doc" key="edit"/>]</a> 
	  <% } else {
		  	Document quoteDoc = doc.getDocument((int)doc.getQuoteId());
			Leaf quotelf = dir.getLeaf(quoteDoc.getDirCode());
			LeafPriv lpQuote = new LeafPriv(quoteDoc.getDirCode());
	  		if (lpQuote.canUserModifyDoc(quoteDoc, privilege.getUser(request))) {
			%>
			  <a href="../<%=DocumentMgr.getWebEditPage()%>?op=edit&id=<%=quoteDoc.getId()%>&dir_code=<%=StrUtil.UrlEncode(quoteDoc.getDirCode())%>">[<lt:Label res="res.label.cms.doc" key="edit"/>]</a> 
			<%
			}
			else {
		  %>
		  	<font color="#cccccc" title="来自于目录：<%=quotelf.getName()%>">[<lt:Label res="res.label.cms.doc" key="edit"/>]</font>
	  	 <% }
		 }
	  }%>
	  <%
	  if (lp.canUserDel(privilege.getUser(request)) || lp.canUserExamine(privilege.getUser(request))) {
	  %>
		  <a onClick="return confirm('您确定要删除吗？')" href="document_list_m.jsp?op=del&id=<%=rr.getInt(1)%>&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&dir_name=<%=StrUtil.UrlEncode(dir_name)%>">[<lt:Label res="res.label.cms.doc" key="del"/>]</a>
	  <%}%>
	  <%
	  if (lp.canUserExamine(privilege.getUser(request))) {
	  	if (rr.getInt("examine")!=Document.EXAMINE_DRAFT) {
	  %>
		  <%if (rr.getInt("examine")!=Document.EXAMINE_PASS) {%>
		  <a href="document_list_m.jsp?op=passExamine&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&ids=<%=rr.getInt("id")%>&examine=<%=Document.EXAMINE_PASS%>" title="将文章置成通过状态">[通过]</a>
		  <%}else{%>
		  <a href="document_list_m.jsp?op=passExamine&dir_code=<%=StrUtil.UrlEncode(dir_code)%>&ids=<%=rr.getInt("id")%>&examine=<%=Document.EXAMINE_NOT%>" title="将文章置为未审核状态">[未审核]</a>
		  <%}%>
	  <%}
	  }%>
	  <%
	  if (lp.canUserExamine(privilege.getUser(request))) {
	  %>
		  <%if (rr.getInt("doc_level")<Document.LEVEL_TOP) {%>
		  <a onClick="return confirm('您确定要置顶吗？')" href="document_list_m.jsp?op=setOnTop&level=<%=Document.LEVEL_TOP%>&id=<%=rr.getInt("id")%>&dir_code=<%=StrUtil.UrlEncode(dir_code)%>">[置顶]</a>
		  <%}else{%>
		  <a onClick="return confirm('您确定要取消置顶吗？')" href="document_list_m.jsp?op=setOnTop&level=0&id=<%=rr.getInt("id")%>&dir_code=<%=StrUtil.UrlEncode(dir_code)%>">[取消置顶]</a>
		  <%}%>
	  <%}%>	  </td>
    </tr>
    <%}%>
  </tbody>
</table>
<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan="2" align="right">&nbsp;</td>
  </tr>
  <tr>
    <td width="42%" align="left">
	<%
	boolean canPassOrDel = true;
	if (!dir_code.equals("")) {
		lp = new LeafPriv(dir_code);
		if (lp.canUserModify(privilege.getUser(request)) || lp.canUserExamine(privilege.getUser(request)))
			;
		else
			canPassOrDel = false;
	}
	%>
	<%if (canPassOrDel) {%>
	  <input name="button31" type="button" onClick="selAllCheckBox('ids')" value="<lt:Label res="res.label.forum.topic_m" key="sel_all"/>">
      &nbsp;
      <input name="button32" type="button" onClick="clearAllCheckBox('ids')" value="<lt:Label res="res.label.forum.topic_m" key="clear_all"/>">
      &nbsp;
      <input name="button33" type="button" onClick="doDel()" value="<lt:Label key="op_del"/>">
      &nbsp;
      <input name="button34" type="button" onClick="passExamineBatch()" value="通过" title="状态为草稿的文章将被忽略">
	<%}%>
	</td>
    <td width="58%" align="right"><%
	String querystr = "op=" + op + "&dir_code=" + StrUtil.UrlEncode(dir_code) + "&op=" + op + "&kind=" + kind + "&what=" + StrUtil.UrlEncode(what) + "&myexamine=" + myexamine;
    out.print(paginator.getCurPageBlock("document_list_m.jsp?"+querystr));
%></td>
  </tr>
</table>
<table style="margin-top:10px" width="98%"  border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
  <form name="form1" action="document_list_m.jsp" method="get">
    <tr>
      <td align="left">
	  <%=SkinUtil.LoadString(request, "res.label.cms.doc","search")%>&nbsp;<lt:Label res="res.label.cms.doc" key="an"/>
	  <%if (!dir_code.equals("")) {%>
	  <select name="dir_code" onchange="onDirChange(this.value)">
	  <%
	  	LeafChildrenCacheMgr lcm = new LeafChildrenCacheMgr(dir_code);
		if (lcm.getDirList().size()>0) {
			DirectoryView dv = new DirectoryView(leaf);
			dv.ShowDirectoryAsOptions(out, leaf, leaf.getLayer());
		}
		else {
			Leaf siteLeaf = leaf.getSubsiteOfLeaf(dir_code);
			if (siteLeaf==null) {
				Leaf pLeaf = leaf.getLeaf(leaf.getParentCode());
				DirectoryView dv = new DirectoryView(pLeaf);
				dv.ShowDirectoryAsOptions(out, pLeaf, pLeaf.getLayer());
			}
			else {
				DirectoryView dv = new DirectoryView(siteLeaf);
				dv.ShowDirectoryAsOptions(out, siteLeaf, siteLeaf.getLayer());
			}
		}
	  %>
	  </select>
	  <script>
	  form1.dir_code.value = "<%=dir_code%>";
	  </script>
	  <%}%>
        <select name="kind">
          <option value="title"><lt:Label res="res.label.cms.doc" key="title"/></option>
          <option value="content">内容</option>
          <option value="author">作者</option>
          <option value="keywords"><lt:Label res="res.label.cms.doc" key="key_words"/></option>
          <option value="id">文章ID</option>
        </select>
        <select name="myexamine">
          <option value="-1">全部审批状态</option>
          <option value="<%=Document.EXAMINE_NOT%>"><%=SkinUtil.LoadString(request, "res.label.cms.doc","no_check")%></option>
          <option value="<%=Document.EXAMINE_NOTPASS%>"><%=SkinUtil.LoadString(request, "res.label.cms.doc","no_pass")%></option>
          <option value="<%=Document.EXAMINE_PASS%>"><%=SkinUtil.LoadString(request, "res.label.cms.doc","pass")%></option>
        </select>
        <input name=what size=20 value="<%=what%>">
		<input name="Submit1" type="submit" value="确定" title="忽略草稿状态的文章" />
		<input name="op" value="search" type="hidden">
	</td>
    </tr>
  </form>
  <%if (op.equals("search")) {%>
  <script>
  form1.kind.value = "<%=kind%>";
  form1.myexamine.value = "<%=myexamine%>";
  </script>
  <%}%>
</table>
<%
if (isHtml && !dir_code.equals("") && leaf.getType()==Leaf.TYPE_LIST) { // && !Leaf.isLeafOfSubsite(dir_code)) {
	lp = new LeafPriv(dir_code);
	if (lp.canUserExamine(privilege.getUser(request))) {
%>
<table width="98%" border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray" style="margin-top:10px">
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
          <input name="isIncludeChildren" value="true" type="checkbox">
包含子文件夹
          &nbsp;
          <input name="button2" type="submit" value="生成文章静态页面">
    	  <input name="dir_code" value="<%=dir_code%>" type="hidden">
   	  日期不填写，表示全部</td>
   </form>
  </tr>
  <form action="?op=createListHtml" method="post">
  <tr>
      <td>列表页的页码从
        <input type="text" id="pageNumBegin" name="pageNumBegin" size="10" value="1">
        至
        <input type="text" id="pageNumEnd" name="pageNumEnd" size="10">
        <input name="isIncludeChildren" value="true" type="checkbox">
        包含子文件夹
        &nbsp;
        <input name="button22" type="submit" value="生成列表静态页面">
        <input name="dir_code" value="<%=dir_code%>" type="hidden">
      页码不填写，表示全部</td>
	</tr>
  </form>
</table>
<%}
}%>
</body>
<script src="../inc/common.js"></script>
<script>
function doDel() {
	if (!confirm("您确定要删除么？"))
		return;
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

function onDirChange(dirCode) {
	var oldCode = "<%=dir_code%>";
	if (dirCode=="not") {
		alert("该目录节点不是列表型节点，不能被选择！");
		form1.dir_code.value = oldCode;
	}
}
</script>
</html>