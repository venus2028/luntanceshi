<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="org.jdom.*"%>
<%@ page import="org.jdom.output.*"%>
<%@ page import="org.jdom.input.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.plugin.answer.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="topic" scope="page" class="com.redmoon.forum.MsgMgr" />
<%
	String querystring = StrUtil.getNullString(request.getQueryString());
	String privurl = ParamUtil.get(request, "privurl");
	
	String op = ParamUtil.get(request, "op");
	long msgId = ParamUtil.getLong(request, "msgId");

	if (op.equals("add")) {
		boolean re = false;
		try {
			AnswerMsgAction rma = new AnswerMsgAction();
			re = rma.answer(request);
			if (re) {
				out.println(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_operate_success"), privurl));
			}
			else {
				out.println(StrUtil.Alert_Back(SkinUtil.LoadString(request,"info_operate_fail")));
			}
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert_Back(e.getMessage()));
		}
		%>
		<script>
		window.opener.location.reload();
		window.close();
		</script>
		<%
		return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD><TITLE>答复贴子 - <%=Global.AppName%></TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<link href="../../<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
<script>
function form1_onsubmit() {
	document.form1.content.value = getHtml();
}
</script>
</HEAD>
<BODY>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<%@ include file="../../inc/position.jsp"%>
<br>
<FORM action="answer_add.jsp?op=add" method="post" name="form1" onSubmit="return form1_onsubmit()">
<TABLE width="61%" height=144 align="center" cellPadding=3 cellSpacing=0 class="tableCommon60">
	<thead>
        <TR>
          <TD height=22 colSpan=2 align="center">版主答复</TD>
        </TR>
	</thead>
      <TBODY>
        <TR bgColor=#f5f5f5 align="center">
          <TD height=22 align="left"><lt:Label res="res.label.forum.manager" key="topic"/></TD>
          <TD height=22 align="left">
            <%
		MsgMgr mm = new MsgMgr();
		MsgDb md = mm.getMsgDb(msgId);
		%>
        <a href="<%=request.getContextPath()%>/forum/showtopic_tree.jsp?showid=<%=md.getRootid()%>"><%=StrUtil.toHtml(md.getTitle())%></a><BR>
		<input type=hidden name=msgId value="<%=msgId%>">
		<input type=hidden name=privurl value="<%=privurl%>"></TD>
        </TR>
        <TR bgColor=#f5f5f5 align="center">
          <TD width="20%" height=22 align="left">回复</TD>
          <TD width="80%" height=22 align="left">
		  <%
			String rpath = request.getContextPath();
			AnswerDb rd = new AnswerDb();
			rd = (AnswerDb)rd.getQObjectDb(new Long(msgId));
			String content = "";
			if (rd!=null) {
				content = StrUtil.getNullStr(rd.getString("content")).replaceAll("\"","'");		
			}
			%>
		    <input name="content" type="hidden" value="<%=content%>">
            <link rel="stylesheet" href="<%=rpath%>/editor/edit.css">
            <script src="<%=rpath%>/editor/DhtmlEdit.js"></script>
            <script src="<%=rpath%>/editor/editjs.jsp"></script>
            <script src="<%=rpath%>/editor/editor_s.jsp"></script></TD>
			<%if (rd!=null) {%>
				<script>
				setHtml(form1.content);
				</script>
			<%}%>			
        </TR>
        <TR bgColor=#f5f5f5 align="center">
          <TD colSpan=2 height=32><input type="submit" name="Submit2" value="<%=SkinUtil.LoadString(request,"ok")%>"></TD>
        </TR>
      </TBODY>
</TABLE>
</FORM>
<br>
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>
</BODY></HTML>
