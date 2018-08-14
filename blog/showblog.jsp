<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.template.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin2.*"%>
<%@ page import="com.redmoon.forum.plugin.base.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long rootid;
try {
	rootid = ParamUtil.getLong(request, "rootid");
}
catch (Exception e) {
	out.println(StrUtil.Alert(SkinUtil.LoadString(request, SkinUtil.ERR_ID)));
	return;
}

MsgDb rootMsgDb = new MsgDb();
rootMsgDb = rootMsgDb.getMsgDb(rootid);

if (!rootMsgDb.isLoaded()) {
	out.print(cn.js.fan.web.SkinUtil.makeInfo(request, SkinUtil.LoadString(request, "res.label.forum.showtopic", "topic_lost"))); // "该贴已不存在！"));
	return;
}
String boardcode = rootMsgDb.getboardcode();
String userName = rootMsgDb.getName();

// 检查是否可以进入版块
try {
	privilege.checkCanEnterBoard(request, boardcode);
}
catch (ErrMsgException e) {
	response.sendRedirect(request.getContextPath() + "/info.jsp?info=" + StrUtil.UrlEncode(e.getMessage()));
	return;
}

com.redmoon.forum.Leaf msgLeaf = new com.redmoon.forum.Leaf();
msgLeaf = msgLeaf.getLeaf(boardcode);
String boardname = msgLeaf.getName();

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(rootMsgDb.getBlogId());
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.forum.showblog","has_not_active_blog")));
	return;	
}

TemplateDb td = new TemplateDb();
td = td.getTemplateDb(StrUtil.toInt(ucd.getSkin()));
if (td==null) {
	td = new TemplateDb();
	td = td.getDefaultTemplateDb();
}

request.setAttribute("UserConfigDb", ucd);
request.setAttribute("template", td);
request.setAttribute("pageName", "showblog");
request.setAttribute("rootMsgDb", rootMsgDb);

com.redmoon.forum.Config cfg1 = com.redmoon.forum.Config.getInstance();
int msgTitleLengthMin = cfg1.getIntProperty("forum.msgTitleLengthMin");
int msgTitleLengthMax = cfg1.getIntProperty("forum.msgTitleLengthMax");
int msgLengthMin = cfg1.getIntProperty("forum.msgLengthMin");
int msgLengthMax = cfg1.getIntProperty("forum.msgLengthMax");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<TITLE><%=StrUtil.toHtml(rootMsgDb.getTitle())%> - <%=Global.AppName%></TITLE>
<META http-equiv=Content-Type content=text/html; charset=utf-8>
<SCRIPT language=JavaScript src="../forum/inc/showtopic.js"></SCRIPT>
<script tyle="text/javascript" language="javascript" src="../spwhitepad/createShapes.js"></script>
<SCRIPT language=JavaScript src="../blog/images/nereidFade.js"></SCRIPT>
<SCRIPT>
var i=0;
function formCheck()
{
	i++;
	document.frmAnnounce.Content.value = getHtml();
	
	if (document.frmAnnounce.topic.value.length<<%=msgTitleLengthMin%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_short_title"/><%=msgTitleLengthMin%>");
		return false;
	}
	if (document.frmAnnounce.topic.value.length><%=msgTitleLengthMax%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_large_title"/><%=msgTitleLengthMax%>");
		return false;
	}	
	if (document.frmAnnounce.Content.value.length<<%=msgLengthMin%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_short_content"/><%=msgLengthMin%>");
		return false;
	}
	if (document.frmAnnounce.Content.value.length><%=msgLengthMax%>)
	{
		alert("<lt:Label res="res.forum.MsgDb" key="err_too_large_content"/><%=msgLengthMax%>");
		return false;
	}	
	
	if (i>1) 
	{
		document.frmAnnounce.submit1.disabled = true;
	}
	return true;
}

function presskey(eventobject)
{
	if(event.ctrlKey && window.event.keyCode==13)
	{
		i++;
		if (i>1) 
		{
			alert('<lt:Label res="res.label.forum.showtopic" key="wait"/>');
			return false;
		}
		this.document.form.submit();
	}
}
</SCRIPT>
<META content="MSHTML 6.00.2800.1126" name=GENERATOR>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="<%=ucd.getCSS(request)%>" type=text/css rel=stylesheet>
</HEAD>
<BODY>
<%@ include file="header.jsp"%>
<%
TemplateLoader tl = new TemplateLoader(request, td.getCacheKey(TemplateDb.TEMPL_TYPE_MAIN), td.getString("main_content"));
out.print(tl.toString());
%>
<%@ include file="footer.jsp"%>
<%@ include file="../inc/topic_hit_count.jsp"%>
</BODY>
</HTML>
