<%@ page contentType="text/html;charset=utf-8" language="java" errorPage="" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.template.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.security.*"%>
<%
int id = ParamUtil.getInt(request, "id", -1);
String dirCode = ParamUtil.get(request, "dir_code");
boolean isDirArticle = false;
Leaf lf = new Leaf();

if (!dirCode.equals("")) {
	lf = lf.getLeaf(dirCode);
	if (lf!=null) {
		if (lf.getType()==1) {
			id = lf.getDocID();
			isDirArticle = true;
		}
	}
}

if (id==-1) {
	out.print(SkinUtil.makeErrMsg(request, "id格式错误！"));
	return;
}

Document doc = null;
DocumentMgr docmgr = new DocumentMgr();
doc = docmgr.getDocument(id);
if (doc==null || !doc.isLoaded()) {
	out.print(SkinUtil.makeErrMsg(request, "该文章不存在！"));
	return;
}

cn.js.fan.module.cms.ext.Privilege privilege = new cn.js.fan.module.cms.ext.Privilege();
if (!privilege.canUserDo(request, doc.getDirCode(), "view_doc")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

if (!isDirArticle)
	lf = lf.getLeaf(doc.getDirCode());

String CPages = ParamUtil.get(request, "CPages");
int pageNum = 1;
if (StrUtil.isNumeric(CPages))
	pageNum = Integer.parseInt(CPages);

String op = ParamUtil.get(request, "op");
String view = ParamUtil.get(request, "view");
CommentMgr cm = new CommentMgr();
if (op.equals("addcomment")) {
	try {
		cm.create(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}

if (op.equals("vote")) {
	try {
		docmgr.vote(request,id);
		response.sendRedirect("doc_show.jsp?id=" + id);
		return;		
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><%=doc.getTitle()%> - <%=Global.AppName%></title>
<link href="template/css.css" type="text/css" rel="stylesheet" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
.gray { BORDER-RIGHT: #cccccc 1px solid; BORDER-TOP: #cccccc 0px solid; BORDER-LEFT: #cccccc 1px solid; BORDER-BOTTOM: #cccccc 1px solid;}
-->
</style>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div class="content">
<%@ include file="header.jsp"%>
<div align="center" style="text-align:left">
  <table id="__01" width="100%" height="401" border="0" cellpadding="0" cellspacing="0" class="gray">
    <tr>
      <td width="838" height="32" colspan="41" background="images/doc_nav.gif"><div style="font-family:'宋体'">&nbsp;&nbsp;当前位置： <a href="index.jsp" class="mainA">首页</a> >>
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
		if (lf.getType()==cn.js.fan.module.cms.Leaf.TYPE_LIST) {
			out.print(navstr + "<a href='doc_list.jsp?op=list&dirCode=" + StrUtil.UrlEncode(lf.getCode()) + "'>" + lf.getName() + "</a>");
		}
		else
			out.print(navstr + lf.getName());
		%>
      </div></td>
    </tr>
    <tr>
      <td height="317" colspan="41" valign="top" style="padding:5px"><table cellSpacing="0" cellPadding="5" width="100%" align="center" border="0">
        <tbody>
          <tr>
            <td height="39" align="center"><%if (doc.isLoaded()) {%>
                <b><font size="3"> <%=doc.getTitle()%></font></b>&nbsp; </td>
          </tr>
          <tr>
            <td height="22" align="right" bgcolor="#e4e4e4"><%if (!doc.getAuthor().equals("")){%>
              作者：<%=doc.getAuthor()%>&nbsp;
              <%}%>
              &nbsp;&nbsp;日期：<%=cn.js.fan.util.DateUtil.format(doc.getModifiedDate(), "yy-MM-dd")%>&nbsp;&nbsp;访问次数：<%=doc.getHit()%>
              <%}else{%>
              未找到该文章！
              <%}%>
              &nbsp;&nbsp;
			  <%if (doc.isCanComment()) {%>
			  <A href="doc_comment.jsp?id=<%=doc.getId()%>">【发表评论】</A>
			  <%}%>
			  </td>
          </tr>
        </tbody>
      </table>
	  <script src='js.jsp?var=ad&dirCode=<%=doc.getDirCode()%>&type=doc'></script> 
      	<%
		if (doc!=null && pageNum==1) {
			// 使点击量增1
			doc.increaseHit();
		}
		%>
        <%
		if (doc.getType()==Document.TYPE_VOTE) {
			out.print(DocTemplateImpl.getVoteStr(doc));
		}
		if (doc.isLoaded()) {%>
        <%=doc.getContent(pageNum)%>
        <%}%>
        <br>
        <br>
        <%
			  if (doc!=null) {
				  java.util.Vector attachments = doc.getAttachments(pageNum);
				  java.util.Iterator ir = attachments.iterator();
				  while (ir.hasNext()) {
				  	Attachment am = (Attachment) ir.next(); %>
        <table width="569"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="91" height="26" align="right"><img src=images/attach.gif></td>
            <td>&nbsp; <a target=_blank href="doc_getfile.jsp?pageNum=<%=pageNum%>&id=<%=doc.getID()%>&attachId=<%=am.getId()%>"><%=am.getName()%></a> &nbsp;下载次数&nbsp;<%=am.getDownloadCount()%></td>
          </tr>
        </table>
        <%}
			  }
			  %>
        <%
		if (doc.getType()==1 && (op.equals("") || !op.equals("vote"))) {
                DocPollDb mpd = new DocPollDb();
                mpd = (DocPollDb)mpd.getQObjectDb(new Integer(doc.getId()));
                if (mpd!=null) {
                    String ctlType = "radio";
                    if (mpd.getInt("max_choice") > 1)
                        ctlType = "checkbox";
                    java.util.Vector options = mpd.getOptions(doc.getId());
                    int len = options.size();

                    int[] re = new int[len];
                    int[] bfb = new int[len];
                    int total = 0;
                    int k = 0;
                    for (k = 0; k < len; k++) {
                        DocPollOptionDb opt = (DocPollOptionDb) options.
                                              elementAt(k);
                        re[k] = opt.getInt("vote_count");
                        total += re[k];
                    }
                    if (total != 0) {
                        for (k = 0; k < len; k++) {
                            bfb[k] = (int) Math.round((double) re[k] / total *
                                    100);
                        }
                    }

                    String str = "";
                    str += "<table>";
                    str += "<form action='" + request.getContextPath() +
                            "/doc_vote.jsp?op=vote&id=" + doc.getId() +
                            "' name=formvote method='post'>";
                    str += "<tr><td colspan='2'>";
                    java.util.Date epDate = mpd.getDate("expire_date");
                    if (epDate != null) {
                        str += "到期时间：" + DateUtil.format(epDate, "yyyy-MM-dd");
                    }
                    str += "</td><tr>";
                    for (k = 0; k < len; k++) {
                        DocPollOptionDb opt = (DocPollOptionDb) options.
                                              elementAt(k);

                        str += "<tr>";
                        str += "<td width=26>" + (k + 1) + "、</td>";
                        str +=
                                "<td width=720><input class='n' type=" +
                                ctlType + " name=votesel value='" +
                                k + "'>";
                        str += opt.getString("content") + "</td>";
                        str += "</tr>";
                    }
                    str += "<tr>";
                    str +=
                            "<td colspan='2' align=center><input type='submit' value=' 投  票 '>";
                    str += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                    str +=
                            "<input name='btn' type='button' value='查看结果' onClick=\"window.location.href='" +
                            request.getContextPath() + "/doc_vote.jsp?id=" +
                            doc.getId() + "&op=view'\"></td>";
                    str += "</tr>";
                    str += "</form>";
                    str += "</table>";
					out.print(str);
				}
        }%>
        <br>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="24" align="center">文章共<%=doc.getPageCount()%>页&nbsp;&nbsp;页码
              <%
					int pagesize = 1;
					int total = doc.getPageCount();
					int curpage,totalpages;
					Paginator paginator = new Paginator(request, total, pagesize);
					// 设置当前页数和总页数
					totalpages = paginator.getTotalPages();
					curpage	= paginator.getCurrentPage();
					if (totalpages==0)
					{
						curpage = 1;
						totalpages = 1;
					}
					
					String querystr = "op=edit&id=" + id;
					out.print(paginator.getCurPageBlock("doc_show.jsp?"+querystr));
					%></td>
          </tr>
        </table>
        <%
	      cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
    	  boolean isShow = cfg.getBooleanProperty("cms.isRelateShow"); 
		  if (isShow && doc.getIsRelateShow()) {%>
        <table width="568"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td height="26"></td>
            <td>&nbsp;</td>
          </tr>
          <tr>
            <td width="6" height="26"></td>
            <td width="562" background="images/correlation.gif">&nbsp;</td>
          </tr>
          <tr>
            <td></td>
            <td align="left"><table width=100% border=0 align="left" cellpadding="0" cellspacing="0" class="p9">
                <%
	String keywords = StrUtil.getNullStr(doc.getKeywords());
	if (!keywords.equals("")) {
		// String ft_sql = "select id from document WHERE CONTAINS( keywords, " + StrUtil.sqlstr(keys) + " )"; // 用于SQL SERVER全文检索
		String ft_sql = SQLBuilder.getDocRelateSql(keywords);
%>
                <%@ taglib uri="/WEB-INF/tlds/DocListTag.tld" prefix="dl" %>
                <dl:DocListTag action="" query="<%=ft_sql%>" dirCode="<%=DocCacheMgr.FULLTEXT%>" start="0" end="7">
                  <dl:DocListItemTag field="title" mode="detail">
                    <tr>
                      <td height=20 align="left">&nbsp;&nbsp;<a href="doc_show.jsp?id=$id">$title</a>&nbsp;&nbsp;&nbsp;[$modifiedDate]</td>
                    </tr>
                  </dl:DocListItemTag>
                </dl:DocListTag>
                <%}%>
            </table></td>
          </tr>
        </table>
      <%}%>
	  <script src='js.jsp?var=ad&dirCode=<%=doc.getDirCode()%>&type=docBottom'></script>
	  </td>
    </tr>
  </table>
</div>
</div>
<%@ include file="footer.jsp"%>
</body>
</html>