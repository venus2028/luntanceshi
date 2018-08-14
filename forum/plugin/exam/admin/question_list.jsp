<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../../inc/inc.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.exam.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" href="../../../common.css">
<LINK href="../../../admin/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>插件管理</title>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String dirCode = ParamUtil.get(request, "dirCode");

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	long id = ParamUtil.getLong(request, "id");
	QuestionMgr qm = new QuestionMgr();
	boolean re = false;
	try {
	re = qm.del(request, id);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "question_list.jsp?dirCode=" + StrUtil.UrlEncode(dirCode)));
	}
	else {
		out.print(StrUtil.Alert_Back("操作失败！"));
	}
	return;
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理题目</td>
  </tr>
</table>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">题目</td>
  </tr>
  <tr>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <td align="center"><a href="question_add.jsp?dirCode=<%=dirCode%>">添加</a></td>
      </tr>
    </table>
<%
		QuestionDb mud = new QuestionDb();
		
		String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
		if (strcurpage.equals(""))
			strcurpage = "1";
		if (!StrUtil.isNumeric(strcurpage)) {
			out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "err_id")));
			return;
		}
		
		String sql = "select id from " + mud.getTable().getName() + " where dir_code=" + StrUtil.sqlstr(dirCode) + " order by add_date desc";

	    long total = mud.getQObjectCount(sql);
		int pagesize = 20;
		int curpage = StrUtil.toInt(strcurpage, 1);
		
		QObjectBlockIterator obi = mud.getQObjects(sql, (curpage-1)*pagesize, curpage*pagesize);
		
		Paginator paginator = new Paginator(request, total, pagesize);
		// 设置当前页数和总页数
		int totalpages = paginator.getTotalPages();
		if (totalpages==0) {
			curpage = 1;
			totalpages = 1;
		}
%>	
      <table width="98%" border="0" align="center" class="p9">
        <tr>
          <td align="right"><%=paginator.getPageStatics(request)%></td>
        </tr>
      </table>
      <table width="98%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#999999" class="tableframe_gray">
      <tr align="center">
        <td width="4%" height="24" bgcolor="#EFEBDE">题号</td>
        <td width="72%" height="22" bgcolor="#EFEBDE">题目</td>
        <td width="12%" bgcolor="#EFEBDE">得分</td>
        <td width="12%" height="22" bgcolor="#EFEBDE">操作</td>
      </tr>
<%
while (obi.hasNext()) {
	QuestionDb qd = (QuestionDb)obi.next();
%>
      <tr align="center">
        <td height="22" bgcolor="#FFFBFF"><%=qd.getLong("id")%></td>
      <td height="22" align="left" bgcolor="#FFFBFF"><%=qd.getString("title")%></td>
        <td align="left" bgcolor="#FFFBFF"><%=qd.getInt("score")%></td>
        <td height="22" bgcolor="#FFFBFF"><a href="question_edit.jsp?id=<%=qd.getLong("id")%>" target="_blank">编辑</a>&nbsp;&nbsp;&nbsp;<a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='question_list.jsp?op=del&dirCode=<%=StrUtil.UrlEncode(dirCode)%>&id=<%=qd.getLong("id")%>'">删除</a></td>
      </tr>
<%}%>
    </table>

      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr>
          <td height="23" align="right"><%
				String querystr = "dirCode=" + StrUtil.UrlEncode(dirCode);
				out.print(paginator.getPageBlock(request,"question_list.jsp?"+querystr));
				%>
            &nbsp;&nbsp;</td>
        </tr>
      </table>
      <br>
    <br></td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
                               
</body>                                        
</html>                            
  