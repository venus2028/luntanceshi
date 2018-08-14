<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<LINK href="../inc/photoshow/ps.css" type=text/css rel=stylesheet>
<SCRIPT language=javascript src="../inc/common.js"></SCRIPT>
<SCRIPT language=javascript src="../inc/photoshow/ps.js"></SCRIPT>
<%
long blogId = ParamUtil.getLong(request, "blogId", UserConfigDb.NO_BLOG);
UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.blog.list","activate_blog_fail")));
	return;	
}	

PhotoDb pd = new PhotoDb();

String strcurpage = StrUtil.getNullString(request.getParameter("CPages"));
if (strcurpage.equals(""))
	strcurpage = "1";
if (!StrUtil.isNumeric(strcurpage)) {
	out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request, "err_id")));
	return;
}

String sql;
sql = "select id from " + pd.getTableName() + " where blog_id=" + blogId + " ORDER BY addDate desc";

int total = 0;
int pagesize = 6;
int curpage = StrUtil.toInt(strcurpage, 1);

ListResult lr = pd.listResult(sql, curpage, pagesize);
if (lr!=null)
	total = lr.getTotal();

Paginator paginator = new Paginator(request, total, pagesize);
// 设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}

com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
boolean isFtpUsed = cfg.getBooleanProperty("forum.ftpUsed");
		
String photoUrl="", photoDate = "", photoLink = "", photoUrlSmall = "";
Iterator irphoto = null;
Vector v = lr.getResult();
irphoto = v.iterator();
%>
<DIV class=fpic> 
<%
if (v.size()>0) {
	pd = (PhotoDb)v.elementAt(0);
	String attachmentBasePath = request.getContextPath() + "/upfile/" +
								pd.photoBasePath + "/";
	if (pd.isRemote()) {
		if (isFtpUsed) {
			attachmentBasePath = cfg.getProperty("forum.ftpUrl");
			if (attachmentBasePath.lastIndexOf("/") !=
				attachmentBasePath.length() - 1)
				attachmentBasePath += "/";
			attachmentBasePath += pd.photoBasePath + "/";
		}
	}
	photoUrl = attachmentBasePath + pd.getImage();
	photoLink = "showphoto.jsp?photoId=" + pd.getId() + "&blogId=" + blogId;
	photoDate = ForumSkin.formatDate(request, pd.getAddDate());
%>
	<A id=foclnk href="<%=photoLink%>" target=_blank>
	<IMG id=focpic style="FILTER: RevealTrans ( duration = 1,transition=23 ); VISIBILITY: visible; POSITION: absolute" height=300 alt="" src="<%=photoUrl%>" width=400>
	</A>
	<DIV id=fttltxt style="MARGIN-TOP: 305px; FLOAT: left; WIDTH: 400px; TEXT-ALIGN: center">
	<A href="<%=photoLink%>" target=_blank><%=pd.getTitle()%></A>&nbsp;<%=photoDate%>
	</DIV>
<%
}
%>
<DIV style="MARGIN-LEFT: 402px; WIDTH: 65px">
<%
int k = 0;
String str = "<SCRIPT language=javascript type=text/javascript>";
str += "var picarry = {};";
str += "var lnkarry = {};";
str += "var ttlarry = {};";
str += "picLen=" + v.size() + ";";
while (irphoto.hasNext()) {
	pd = (PhotoDb) irphoto.next();
	String attachmentBasePath = request.getContextPath() + "/upfile/" +
								pd.photoBasePath + "/";
	if (pd.isRemote()) {
		if (isFtpUsed) {
			attachmentBasePath = cfg.getProperty("forum.ftpUrl");
			if (attachmentBasePath.lastIndexOf("/") !=
				attachmentBasePath.length() - 1)
				attachmentBasePath += "/";
			attachmentBasePath += pd.photoBasePath + "/";
		}
	}
	photoUrl = attachmentBasePath + pd.getImage();
	photoUrlSmall = attachmentBasePath + pd.getImage();
	photoLink = "showphoto.jsp?photoId=" + pd.getId() + "&blogId=" + blogId;
	photoDate = ForumSkin.formatDate(request, pd.getAddDate());	
	String cls = "";
	if (k==0)
		cls = "thubpiccur";
	else
		cls = "thubpic";
		
	str += "picarry[" + k + "]=\"" + photoUrl + "\";";
	str += "lnkarry[" + k + "]=\"" + photoLink + "\";";
	str += "ttlarry[" + k + "]=\"" + pd.getTitle() + "&nbsp;" + photoDate + "\";";	
%>
    <DIV class=<%=cls%> id=tmb<%=k%> onmouseover=setfoc(<%=k%>); onmouseout=playit();><A href="<%=photoLink%>" target=_blank>
	<IMG src="<%=photoUrlSmall%>" alt="<%=pd.getTitle()%>" width=56 height=42 border="0">
	</A></DIV>
<%
	k++;
}
str += "</script>";
%>
</DIV>
</DIV>
<%=str%>
<div style="text-align:center">
<%if (curpage>1) {%>
<a href="javascript:ajaxpage('<%="listphoto_render.jsp?blogId=" + ucd.getId()%>&CPages=<%=curpage-1%>', 'photoDiv')">上一页</a>&nbsp;&nbsp;
<%}
if (curpage<totalpages) {
%>
<a href="javascript:ajaxpage('<%="listphoto_render.jsp?blogId=" + ucd.getId()%>&CPages=<%=curpage+1%>', 'photoDiv')">下一页</a>
<%}%>
&nbsp;&nbsp;共<%=totalpages%>页
</div>