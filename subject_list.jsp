<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.Paginator"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.security.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<html>
<head>
<title>专题列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="common.css" type="text/css">
<style type="text/css">
<!--
.STYLE2 {color: #FFFFFF}
.STYLE1 {	color: #FF6600;
	font-weight: bold;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<%@ include file="header.jsp"%>
<%
String subjectCode = ParamUtil.get(request, "subjectCode");
if (subjectCode.equals("")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, "类别编码不能为空！"));
	return;
}
SubjectDb lf = new SubjectDb();
lf = lf.getSubjectDb(subjectCode);
if (lf==null || !lf.isLoaded()) {
	out.print(SkinUtil.makeErrMsg(request, "节点 " + subjectCode + " 不存在！"));
	return;
}
SubjectListDb sld = new SubjectListDb();
%>
<table width="760" height="577" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td width="3" valign="top">&nbsp;</td>
    <td valign="top"><table width="100%" border="0" align="center" class=p9>
      <tr>
        <td width="100%" height="24" background="images/bg_middle.gif">&nbsp;当前位置： <a href="index.jsp" class="mainA">首页</a> >> <%
		String navstr = "";
		String parentcode = lf.getParentCode();
		SubjectDb plf = new SubjectDb();
		while (!parentcode.equals("root")) {
			plf = plf.getSubjectDb(parentcode);
			if (plf.getType()==Leaf.TYPE_LIST)
				navstr = "<a href='subject_list.jsp?op=list&subjectCode=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
			else
				navstr = plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
			
			parentcode = plf.getParentCode();
			// System.out.println(parentcode + ":" + plf.getName() + " leaf name=" + lf.getName());
		}
		out.print(navstr + lf.getName());
		%></td>
      </tr>
    </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <FORM name=searchform action="search_full_text_do.jsp" method=post>
          <tr>
            <td height="22" align="center"><span class="STYLE1">搜索：</span>
              <input name=queryString class="singleborder" size=15>
              &nbsp;
              <select size=1 name=fieldName>
                <option value="content" selected>内容</option>
                <option value="title">标题</option>
              </select>
              &nbsp;
              <input name="image" type=image src="images/search.gif" align="middle" width="33" height="20"></td>
          </tr>
        </form>
      </table>
      <%
		String sql = SQLBuilder.getSubjectDocListSql(subjectCode);
		if (!SecurityUtil.isValidSql(sql)) {
			out.print(fchar.p_center("标识非法！"));
			return;
		}
		
		int pagesize = 20;
		
	    int total = sld.getDocCount(sql);

		int curpage,totalpages;
		Paginator paginator = new Paginator(request, total, pagesize);
        //设置当前页数和总页数
	    totalpages = paginator.getTotalPages();
		curpage	= paginator.getCurrentPage();
		if (totalpages==0)
		{
			curpage = 1;
			totalpages = 1;
		}
%>
      <table width="92%" border="0" align="center" class="p9">
        <tr>
          <td height="24" align="right">找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></td>
        </tr>
      </table>
      <table width="98%"  border="0" align="center" cellpadding="1" cellspacing="1">
        <tr>
          <td width="71%" height="21" align="center" bgcolor="#F3F7FA" class="line6">标&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 题</td>
          <td width="19%" align="center" bgcolor="#F3F7FA" class="line6">日 期</td>
          <td width="10%" align="center" bgcolor="#F3F7FA" class="line6">点击率</td>
        </tr>
      </table>
      <table width=98% height="28" border=0 align="center" cellpadding="0" cellspacing="1" class="p9">
        <%@ taglib uri="/WEB-INF/tlds/DocListTag.tld" prefix="dl" %>
		<%
		int i = 0;
		cn.js.fan.module.cms.Config cfg1 = new cn.js.fan.module.cms.Config();
		boolean isHtml = cfg1.getBooleanProperty("cms.html_doc");			
		%>
        <dl:DocListTag action="list" query="" subjectCode="<%=subjectCode%>" start="<%=(curpage-1)*pagesize%>" end="<%=curpage*pagesize%>">
		<%
		String bgcolor = "";
		if (i==1)
			bgcolor = "#F2F2F2";
		if (i==0)
			bgcolor = "";
		i++;
		if (i==2)
			i = 0;
		%>
        <dl:DocListItemTag field="title" mode="detail">
		<tr>
          <td width="71%" height=23 align="left" bgcolor="<%=bgcolor%>">&nbsp;
			<%if (isHtml) {%>
				<a href="$htmlName">$title</a>
			<%}else{%>
				<a href="doc_view.jsp?id=$id">$title</a>
			<%}%>		  </td>
          <td width="19%" align="center" bgcolor="<%=bgcolor%>">[$modifiedDate]</td>
        <td width="10%" align="center" bgcolor="<%=bgcolor%>">$hit</td>
		</tr>
		</dl:DocListItemTag>
        </dl:DocListTag>
      </table>
      <table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="26" align="right">
<%
	String querystr = "subjectCode=" + StrUtil.UrlEncode(subjectCode);
    out.print(paginator.getCurPageBlock("subject_list.jsp?"+querystr));
%>       </td>
        </tr>
    </table></td>
  </tr>
</table>
<%@ include file="forum/inc/footer.jsp"%>
</body>
</html>