<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.Paginator"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.security.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%
String dir_code = ParamUtil.get(request, "dirCode");
if (dir_code.equals("")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, "类别编码不能为空！"));
	return;
}
cn.js.fan.module.cms.Leaf lf = new cn.js.fan.module.cms.Leaf();
lf = lf.getLeaf(dir_code);
if (lf==null || !lf.isLoaded()) {
	out.print(SkinUtil.makeErrMsg(request, "节点 " + dir_code + " 不存在！"));
	return;
}
Document document = new Document();
%>             
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><%=lf.getName()%> - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="template/css.css" type="text/css" rel="stylesheet" />
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<div class="content">
<%@ include file="header.jsp"%>
  <div class="notice"> <span class="notice_title">网站公告：</span>
    <marquee class="notice_content" scrolldelay="20" direction="left" scrollamount="2">
    <a href='/cwbbs/forum/showtopic.jsp?rootid=3322' target='_blank'>见识了北京公交的震撼 [2007-07-01]</a>&nbsp;&nbsp;&nbsp;<a href='/cwbbs/forum/showtopic.jsp?rootid=3488' target='_blank'>寻狗启示 [2007-06-10]</a>&nbsp;&nbsp;&nbsp;
    </marquee>
    <span class="notice_search">
	<form action="search_full_text_do.jsp" method="post">	
    <input class="notice_search_input" name="queryString">
    <input type="hidden" name="fieldName" value="content" />
    <input type="image" src="/cwbbs/template/images/btn_search.gif" align="middle" width="74" height="19">
    </form></span></div>
  <div class="middle">
    <div class="main">
     <div class="docBorder list">
<div style="font-family:'宋体'">当前位置： <a href="index.jsp" class="mainA">首页</a> >>
  <%
		String navstr = "";
		String parentcode = lf.getParentCode();
		cn.js.fan.module.cms.Leaf plf = new cn.js.fan.module.cms.Leaf();
		while (!parentcode.equals("root")) {
			plf = plf.getLeaf(parentcode);
			if (plf.getType()==cn.js.fan.module.cms.Leaf.TYPE_LIST)
				navstr = "<a href='doc_list.jsp?op=list&dirCode=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
			else
				navstr = plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
			
			parentcode = plf.getParentCode();
			// System.out.println(parentcode + ":" + plf.getName() + " leaf name=" + lf.getName());
		}
		out.print(navstr + lf.getName());
		%>
</div>	 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <FORM name=searchform action="search_full_text_do.jsp" method=post>
          <tr>
            <td height="22" align="center"><span class="STYLE1">搜索：</span>
                <input name=queryString2 class="singleborder" size=15>
              &nbsp;
              <select size=1 name=select>
                <option value="content" selected>内容</option>
                <option value="title">标题</option>
              </select>
              &nbsp;
              <input name="image" type=image src="images/search.gif" align="middle" width="33" height="20"></td>
          </tr>
        </form>
      </table>
      <%
		String sql="select id from document where class1=" + StrUtil.sqlstr(dir_code) + " and examine=" + Document.EXAMINE_PASS;
		
		if (!SecurityUtil.isValidSql(sql)) {
			out.print(fchar.p_center("标识非法！"));
			return;
		}
		
		int pagesize = 20;
		
	    int total = document.getDocCount(sql);

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
      <table width="99%"  border="0" align="center" cellpadding="1" cellspacing="1">
        <tr>
          <td width="71%" height="21" align="center" bgcolor="#F3F7FA" class="line6">标&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 题</td>
          <td width="19%" align="center" bgcolor="#F3F7FA" class="line6">日 期</td>
          <td width="10%" align="center" bgcolor="#F3F7FA" class="line6">点击率</td>
        </tr>
      </table>
      <table width=99% height="28" border=0 align="center" cellpadding="0" cellspacing="1" class="p9">
        <%@ taglib uri="/WEB-INF/tlds/DocListTag.tld" prefix="dl" %>
        <%
		int i = 0;		
		%>
        <dl:DocListTag action="list" query="" dirCode="<%=dir_code%>" start="<%=(curpage-1)*pagesize%>" end="<%=curpage*pagesize%>">
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
                  <a href="doc_show.jsp?id=$id" title="@title">$title</a>
              </td>
              <td width="19%" align="center" bgcolor="<%=bgcolor%>">[$modifiedDate]</td>
              <td width="10%" align="center" bgcolor="<%=bgcolor%>">$hit</td>
            </tr>
          </dl:DocListItemTag>
        </dl:DocListTag>
      </table>
      <table width="96%"  border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="26" align="right"><%
	String querystr = "dirCode=" + StrUtil.UrlEncode(dir_code);
    out.print(paginator.getCurPageBlock("doc_list.jsp?"+querystr));
%>
          </td>
        </tr>
      </table>
     </div>
    </div>
    <div class="right">
	<%@ include file="left.jsp"%>
    </div>
  </div>
  <div class="bottom"><script src='/cwbbs/js.jsp?var=ad&dirCode=first&type=footer'></script><script src='/cwbbs/js.jsp?var=ad&dirCode=first&type=couple'></script> <script src='/cwbbs/js.jsp?var=ad&dirCode=first&type=float'></script></div>
</div>
<table width="98%" border="0" align="center">
  <tr>
    <td valign="bottom"><HR style="height:1px" color="#CCCCCC">
    </td>
  </tr>
  <tr>
    <td align="center" valign="bottom" style="font-size: 11px; font-family: Tahoma, Arial; line-height:180%"> Powered by <b>CWBBS</b> <b style="COLOR: #ff9900">2.3RC1</b>&nbsp;    ? 2005-2007&nbsp;<a href="http://www.cloudwebsoft.com" style="font-size: 11px; font-family: Tahoma, Arial" target="_blank">Cloud Web Soft</a>&nbsp;&nbsp;Gzip enabled&nbsp;&nbsp;<a href="/forum/wap/index.jsp">wap2.0</a> <br>
      QQ：51066962&nbsp;&nbsp;Email:<a href="mailto:fgf163@pub.zj.jsinfo.net">fgf163@pub.zj.jsinfo.net</a><BR />
      <a href="http://www.miibeian.gov.cn">苏ICP备55555555</a><br /></td>
  </tr>
</table>

<%@ include file="footer.jsp"%>
</body>
</html>