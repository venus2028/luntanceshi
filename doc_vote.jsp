<%@ page contentType="text/html;charset=utf-8" language="java" errorPage="" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.*"%>
<%@ page import="cn.js.fan.security.*"%>
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

String op = ParamUtil.get(request, "op");
if (op.equals("vote")) {
	try {
		docmgr.vote(request,id);
		response.sendRedirect("doc_vote.jsp?id=" + id + "&op=view");
		return;		
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=doc.getTitle()%> - <%=Global.AppName%></title>
<link rel="stylesheet" href="template/css.css" type="text/css">
</head>
<body>
<%@ include file="header.jsp"%>
<TABLE width="760" BORDER=0 align="center" CELLPADDING=0 CELLSPACING=0>
  <TR valign="top" bgcolor="#FFFFFF">
    <TD width="898" height="260"><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
      
      <tr>
        <td><table cellSpacing="0" cellPadding="5" width="100%" align="center" border="0">
          <tbody>
            <tr>
              <td height="39" align="center"><b><font size="3"> <%=doc.getTitle()%></font></b>&nbsp; </td>
            </tr>
          </tbody>
        </table>
              <br>
              <%if (op.equals("view")) {
                DocPollDb mpd = new DocPollDb();
                mpd = (DocPollDb)mpd.getQObjectDb(new Integer(doc.getId()));
                java.util.Vector options = mpd.getOptions(doc.getId());
                int len = options.size();

                int[] re = new int[len];
                int[] bfb = new int[len];
                int total = 0;
                int k = 0;
                for (k=0; k<len; k++) {
                        DocPollOptionDb opt = (DocPollOptionDb)options.elementAt(k);					
                        re[k] = opt.getInt("vote_count");
                        total += re[k];
                }
				
					if (total!=0) {
						for (k=0; k<len; k++) {
							bfb[k] = (int)Math.round((double)re[k]/total*100);
						}
					}
		%>
              <table width="84%" height="100" border="0" align="center" cellpadding="3" cellspacing="1" class=p9>
                <tr bgcolor="#FEF2E9">
                  <td height="24" colspan="4" bgcolor="#EFF7FF"><strong>投票结果：</strong></td>
                </tr>
                <% 
				int barId = 0;
				for (k=0; k<len; k++) { %>
                <tr bgcolor="#FEF2E9">
                  <td width="5%" height="24" bgcolor="#F3F3FA"><%=k+1%>、</td>
                  <td width="59%" bgcolor="#F3F3FA">
				  <img src="forum/images/vote/bar<%=barId%>.gif" width=<%=bfb[k]*2%> height=10>				  </td>
                  <td width="17%" align="right" bgcolor="#F3F3FA"><%=re[k]%>人</td>
                  <td width="19%" align="right" bgcolor="#F3F3FA"><%=bfb[k]%>%</td>
                </tr>
                <%
					barId ++;
					if (barId==10)
						barId = 0;				
				}%>
                <tr bgcolor="#FEF2E9">
                  <td colspan="4" align="center" bgcolor="#F3F3FA">共有<%=total%>人参加调查</td>
                </tr>
            </table>
          <%}%></td>
      </tr>
    </table></TD>
  </TR>
</TABLE>
<%@ include file="footer.jsp"%>
</body>
</html>
