<%@ page contentType="text/html;charset=utf-8" language="java" errorPage="" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%
int id = 0;
try {
	id = ParamUtil.getInt(request, "id");
}
catch (ErrMsgException e) {
	out.print(SkinUtil.makeErrMsg(request, e.getMessage()));
	return;
}

Document doc = null;
DocumentMgr docmgr = new DocumentMgr();
doc = docmgr.getDocument(id);
if (!doc.isLoaded()) {
	out.print(SkinUtil.makeErrMsg(request, "该文章不存在！"));
	return;
}

Leaf lf = new Leaf();
lf = lf.getLeaf(doc.getDirCode());

CommentMgr cm = new CommentMgr();
String op = ParamUtil.get(request, "op");
if (op.equals("addcomment")) {
	try {
		boolean re = cm.create(request);
		if (re) {
			cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
			if (cfg.getBooleanProperty("cms.isCommentNeedCheck")) {
				out.print(StrUtil.Alert_Redirect("请等待审核，点击确定将转至评论页面！", "doc_comment.jsp?id=" + id));
			}
			else
				response.sendRedirect("doc_comment.jsp?id=" + id);
			return;
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=doc.getTitle()%> - <%=Global.AppName%></title>
<link href="template/css.css" type="text/css" rel="stylesheet" />
</head>
<body>
<%@ include file="header.jsp"%>
<TABLE width="760" BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
  <TR valign="top" bgcolor="#FFFFFF">
    <TD width="898" height="260"><table width="100%" border="0" align="center" cellpadding="5" cellspacing="0">
      
      <tr>
        <td height="79" align="center"><table cellSpacing="0" cellPadding="5" width="100%" align="center" border="0">
                <tbody>
                  <tr>
                    <td height="39" align="center">
<%					
                cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
				String href = null;
                boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
				Leaf siteLf = Leaf.getSubsiteOfLeaf(lf.getCode());
				if (siteLf!=null) {
					href = "site_doc.jsp?siteCode=" + siteLf.getCode() + "&docId=" + id;
				}
				else {					
					if (isHtml)
						href = doc.getDocHtmlName(1);
					else
						href = "doc_view.jsp?id=" + id;
				}
%>
                      <a href="<%=href%>"><b><font size="3"><%=doc.getTitle()%></font></b></a>&nbsp; </td>
                  </tr>
                  <tr>
                    <td height="22" align="center" bgcolor="#e4e4e4">以下网友留言只代表网友个人观点，不代表本站观点 <A title="立即发表留言" href="#comment">立即发表留言</A></td>
                  </tr>
                </tbody>
            </table>
          </td>
      </tr>
      <tr>
        <td><br>
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
<%
CommentDb cd = new CommentDb();
String sql = "select id from " + cd.getTableName() + " where doc_id=" + id + " and check_status=" + CommentDb.STATUS_PASS + " order by add_date desc";
long total = cd.getObjectCount(sql, CommentDb.getVisualGroupName(id));
int pagesize = 20;
// out.print(sql);
Paginator paginator = new Paginator(request, total, pagesize);
int curpage = paginator.getCurPage();

ObjectBlockIterator oi = cd.getObjects(sql, CommentDb.getVisualGroupName(id), (curpage - 1) * pagesize, curpage * pagesize);
while (oi.hasNext()) {
	CommentDb cmt = (CommentDb) oi.next();
%>
                      <table width="480" >
                        <tr>
                          <td width="607" height="27"><span class="">评论</span>：</td>
                        </tr>
                      </table>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" >
                        <tr>
                          <td height="43" align="center" class="tableframe_comment"><table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" >
                              <tr>
                                <td height="22" bgcolor="#F2F2F2"><span class=""><a target="_blank" href="<%=cmt.getLink()%>"><%=cmt.getNick()%></a>&nbsp;发表于&nbsp;<%=DateUtil.format(cmt.getAddDate(), "yyyy-MM-dd HH:mm:ss")%> </span></td>
                              </tr>
                              <tr>
                                <td><%=StrUtil.toHtml(cmt.getContent())%></td>
                              </tr>
                          </table></td>
                        </tr>
                    </table>
<%}
String querystr = "id=" + id;
%>
<div align="right">
<%
out.print(paginator.getPageBlock(request, "doc_comment.jsp?" + querystr));
%>
</div>
                      <br>
                      <table width="65%" cellpadding="0" cellspacing="0" class="tableframe_gray" >
                        <tr>
                          <td><table width="100%" >
                              <form name="form1" method="post" action="?op=addcomment">
                                <tr align="left" bgcolor="#CCCCCC">
                                  <td height="24" colspan="2"><span class="">&nbsp;发表评论<a name="comment"></a></span></td>
                                </tr>
                                <tr>
                                  <td width="7%" align="left">姓&nbsp;名</td>
                                  <td width="93%" height="24" align="left"><input type="text" name="nick" size="15">
                                      <input type="hidden" name="doc_id" value="<%=doc.getID()%>">
                                      <input type="hidden" name="id" value="<%=doc.getID()%>">
									<%if (cfg.getBooleanProperty("cms.commentValidateCode")) {%>
									  验证码&nbsp;
									  <input id="validateCode" tabindex="4" size="4" name="validateCode" type="text" />
                                    <img title="点击刷新验证码" id="imgValidateCode" src="validatecode.jsp" width="58" height="20" align="absmiddle" border="0" style="cursor:hand" onClick="this.src='validatecode.jsp?' + 'xxx=' + new Date().getTime();"/>
									<%}%>
									&nbsp;来&nbsp;自
                                    <input name="link" type="text" size="15"></td>
                                </tr>
                                <tr>
                                  <td align="left">内&nbsp;容</td>
                                  <td align="left"><textarea name="content" cols="56" rows="6"></textarea></td>
                                </tr>
                                <tr>
                                  <td align="center">&nbsp;</td>
                                  <td align="center"><input name="Submit" type="submit" class="singleboarder" value="提交">
                                    &nbsp;&nbsp;&nbsp;&nbsp;
                                    <input name="Submit" type="reset" class="singleboarder" value="重置"></td>
                                </tr>
                              </form>
                          </table></td>
                        </tr>
                    </table>                  </td>
                </tr>
            </table></td></tr>
    </table></TD>
  </TR>
</TABLE>
<%@ include file="footer.jsp"%>
</body>
</html>
