<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.blog.photo.DirDb"%>
<%@ page import="com.redmoon.blog.photo.DirChildrenCache"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.MsgMgr"%>
<%@ page import="com.redmoon.forum.plugin.DefaultRender"%>
<%@ page import="com.redmoon.blog.photo.PhotoDb"%>
<%@ page import="com.cloudwebsoft.framework.util.LogUtil"%>
<%@ page import="cn.js.fan.db.ListResult"%>
<%@ page import="cn.js.fan.db.Paginator"%>
<%@ page import="com.redmoon.forum.MsgUtil"%>
<%@ page import="com.redmoon.forum.plugin.group.GroupSQLBuilder"%>
<%@ page import="com.cloudwebsoft.framework.base.QObjectBlockIterator"%>
<%@ page import="com.redmoon.forum.plugin.group.GroupDb"%>
<%@ page import="com.redmoon.blog.ui.TemplateDb"%>
<%
/*
参数：
var 显示项
len 标题长度
start 开始索引
end 结束索引
row 行数
pageNum 页码

例：
显示Flash图片轮换广告
<script src="blog/js.jsp?var=flashImage"></script>

显示博客聚焦
<script src="blog/js.jsp?var=focus"></script>

显示圈子，显示前10个
<script src="blog/js.jsp?var=listgroup&row=10"></script>

显示博客公告
<script src="blog/js.jsp?var=notice"></script>

显示最新博客文章
<script src="blog/js.jsp?var=newarticle"></script>

显示最新博客
<script src="blog/js.jsp?var=newblog"></script>

显示博客发表排行
<script src="blog/js.jsp?var=postrank"></script>

显示推荐博客
<script src="blog/js.jsp?var=recommandblog"></script>

显示博客列表，按回复数排行
<script src="blog/js.jsp?var=replyrank"></script>

显示博客之星
<script src="blog/js.jsp?var=renderstar"></script>

显示照片，显示第1页，每页10条
<script src="blog/js.jsp?var=listPhoto&pageNum=1&row=10"></script>

*/
VarPart vp = new VarPart();

String var = ParamUtil.get(request, "var");
int row = StrUtil.toInt(ParamUtil.get(request, "row"),10);
int len = StrUtil.toInt(ParamUtil.get(request, "len"),20);
int start = StrUtil.toInt(ParamUtil.get(request, "start"), 0);
int end = StrUtil.toInt(ParamUtil.get(request, "end"), 10);
String order = ParamUtil.get(request, "order");
String dirCode = ParamUtil.get(request, "dir_code");

if(var.equals("flashImage")) {
	Home home = Home.getInstance();
	StringBuffer str = new StringBuffer();
	for (int i = 1; i <= 5; i++) {
		str.append("imgUrl");
		str.append(i);
		str.append("=\"");
		str.append(StrUtil.getNullStr(home.getProperty("flash", "id", "" + i,"url")));
		str.append("\";\n");
		str.append("imgtext");
		str.append(i);
		str.append("=\"");
		str.append(StrUtil.getNullStr(home.getProperty("flash", "id", "" + i,"text")));
		str.append("\";\n");
		str.append("imgLink");
		str.append(i);
		str.append("=\"");
		str.append(StrUtil.getNullStr(home.getProperty("flash", "id", "" + i,"link")));
		str.append("\";\n");
	}
	String w = (String)vp.props.get("w");
	String h = (String)vp.props.get("h");
	str.append("var focus_width=");
	str.append(StrUtil.toInt(w, 240));
	str.append(";\n");
	str.append("var focus_height=");
	str.append(StrUtil.toInt(h, 190));
	str.append(";\n");
	str.append("var text_height=18;\n");
	str.append("swf_height = focus_height+text_height;\n");
	str.append("var pics=imgUrl1+\"|\"+imgUrl2+\"|\"+imgUrl3+\"|\"+imgUrl4+\"|\"+imgUrl5;\n");
	str.append("var links=imgLink1+\"|\"+imgLink2+\"|\"+imgLink3+\"|\"+imgLink4+\"|\"+imgLink5;\n");
	str.append("var texts=imgtext1+\"|\"+imgtext2+\"|\"+imgtext3+\"|\"+imgtext4+\"|\"+imgtext5;\n");
	out.print(str);
	str.append("document.write('<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width=\"'+ focus_width +'\" height=\"'+ swf_height +'\">');");
	str.append("document.write('<param name=\"allowScriptAccess\" value=\"sameDomain\"><param name=\"movie\" value=\"");
	str.append(Global.getRootPath());
	str.append("/blog/images/home/focus.swf\"><param name=\"quality\" value=\"high\"><param name=\"bgcolor\" value=\"#F0F0F0\">');");
	str.append("document.write('<param name=\"menu\" value=\"false\"><param name=wmode value=\"opaque\">');");
	str.append("document.write('<param name=\"FlashVars\" value=\"pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'\">');");
	str.append("document.write('</object>');");
	out.print(str.toString());
} else if(var.equals("focus")) {
	StringBuffer str = new StringBuffer();
	Home home = Home.getInstance();
	int[] v = home.getFocusIds();
	int hotlen = v.length;
	if (hotlen == 0) {
	}else {
		boolean isDateShow = false;
		String dateFormat = "";
		String dt = (String) vp.props.get("date");
		if (dt != null) {
			isDateShow = dt.equals("true") || dt.equals("yes") || dt.equals("y");
			dateFormat = (String) vp.props.get("dateFormat");
			if (dateFormat == null) {
				dateFormat = "yy-MM-dd";
			}
		}

		MsgDb md = null;
		MsgMgr mm = new MsgMgr();

		int abstractLen = StrUtil.toInt((String)vp.props.get("abstract"), 50);
		md = mm.getMsgDb(v[0]);
		str.append("<div id=\"abstract\"><a href=\"");
		str.append(Global.getRootPath());
		str.append("/blog/showblog.jsp?rootid=");
		str.append(md.getId());
		str.append("\" target=\"_blank\">");
		str.append(MsgUtil.getAbstract(request, md, abstractLen));
		str.append("</a></div>");

		if (hotlen>1) {
			str.append("<ul>");
			for (int k = 1; k < hotlen; k++) {
				md = mm.getMsgDb(v[k]);
				if (md.isLoaded()) {
					String color = StrUtil.getNullString(md.getColor());
					if (color.equals("")) {
						str.append("<li><a href=\"");
						str.append(Global.getRootPath());
						str.append("/blog/showblog.jsp?rootid=");
						str.append(md.getId());
						str.append("\" target=\"_blank\">");
						str.append(vp.format(DefaultRender.RenderFullTitle(request, md),vp.props));
						str.append("</a></li>");
					} else {
						str.append("<li><a href=\"");
						str.append(Global.getRootPath());
						str.append("/blog/showblog.jsp?rootid=");
						str.append(md.getId());
						str.append("\" target=_blank><font color=");
						str.append(color);
						str.append(">");
						str.append(vp.format(DefaultRender.RenderFullTitle(request, md),vp.props));
						str.append("</font></a></li>");
					}
					if (isDateShow) {
						str.append("&nbsp;&nbsp;");
						str.append(DateUtil.format(md.getAddDate(), dateFormat));
					}
				}
			}
			str.append("</ul>");
		}
	}
	out.print("document.write('" + str.toString() + "');");
} else if(var.equals("listgroup")) {
	StringBuffer str = new StringBuffer();
	str.append("<ul>");

	String sql = GroupSQLBuilder.getListGroupSql(request);
	GroupDb gd = new GroupDb();
	QObjectBlockIterator qi = gd.getQObjects(sql, "", 0, row);

	while (qi.hasNext()) {
		gd = (GroupDb)qi.next();
		str.append("<li>");
		String clrName = StrUtil.toHtml(gd.getString("name"));
		String color = StrUtil.getNullStr(gd.getString("color"));
		if (!color.equals(""))
			clrName = "<font color=" + color + ">" + clrName + "</font>";
		if (gd.getInt("is_bold") == 1)
			clrName = "<strong>" + clrName + "</strong>";

		str.append("<a href=\"");
		str.append(Global.getRootPath());
		str.append("/forum/plugin/group/group.jsp?id=");
		str.append(gd.getLong("id"));
		str.append("\">");
		str.append(clrName);
		str.append("</a>");
		str.append("</li>");
	}
	str.append("</ul>");
	out.print("document.write('" + str.toString() + "');");
}else if(var.equals("newarticle")) {
	StringBuffer str = new StringBuffer();
	str.append("<ul>");
	MsgDb msd = null;
	MsgMgr mm = new MsgMgr();
	long[] newMsgs = null;
	BlogDb bd = new BlogDb();
	bd = bd.getBlogDb();
	newMsgs = bd.getNewBlogMsgs(row);
	if (newMsgs == null) {
		out.print("document.write(\"" + "" + "\");\n");
	}
	int newMsgsLen = newMsgs.length;
	if (newMsgsLen > row)
		newMsgsLen = row;
	boolean isDateShow = false;
	String dateFormat = "";
	String dt = (String) vp.props.get("date");
	if (dt != null) {
		isDateShow = dt.equals("true") || dt.equals("yes");
		dateFormat = (String) vp.props.get("dateFormat");
		if (dateFormat == null) {
			dateFormat = "yy-MM-dd";
		}
	}
	for (int i = 0; i < newMsgsLen; i++) {
		msd = mm.getMsgDb((int) newMsgs[i]);
		str.append("<li><a href='showblog.jsp?rootid=");
		str.append(msd.getId());
		str.append("' target='_blank'>");	
		str.append(StrUtil.getLeft(StrUtil.toHtml(msd.getTitle()), len));
		if (isDateShow) {
			str.append("&nbsp;[");
			str.append(DateUtil.format(msd.getAddDate(), dateFormat));
			str.append("]");
		}
		str.append("</a></li>");
	}
	str.append("</ul>");
	out.print("document.write(\"" + str.toString() + "\");\n");
} else if(var.equals("newblog")) {
	StringBuffer str = new StringBuffer();
	str.append("<ul>");
	BlogDb bd = new BlogDb();
	long[] newBlogs = bd.getNewBlogs(row);
	if (newBlogs != null) {
		UserConfigDb ucd = new UserConfigDb();
		int newBlogsLen = newBlogs.length;
		for (int i = 0; i < newBlogsLen; i++) {
			ucd = ucd.getUserConfigDb(newBlogs[i]);
			str.append("<li><a href='myblog.jsp?blogId=");
			str.append(ucd.getId());
			str.append("' title='");
			str.append(StrUtil.toHtml(ucd.getTitle()));
			str.append("'>");
			str.append(vp.format(ucd.getTitle(), vp.props));
			str.append("</a></li>");
		}
	}
	str.append("</ul>");
	out.print("document.write(\"" + str.toString() + "\");\n");
} else if(var.equals("newupdateblog")) {
	StringBuffer str = new StringBuffer();
	str.append("<ul>");
	BlogDb bd = new BlogDb();

	long[] newUpdateBlogs = bd.getNewUpdateBlogs(row);
	if (newUpdateBlogs != null) {
		UserConfigDb ucd = new UserConfigDb();
		int newBlogsLen = newUpdateBlogs.length;
		for (int i = 0; i < newBlogsLen; i++) {
			ucd = ucd.getUserConfigDb(newUpdateBlogs[i]);
			str.append("<li><a href='myblog.jsp?blogId=");
			str.append(ucd.getId());
			str.append("' title='");
			str.append(StrUtil.toHtml(ucd.getTitle()));
			str.append("'>");
			str.append(vp.format(ucd.getTitle(), vp.props));
			str.append("</a></li>");
		}
	}
	str.append("</ul>");
	out.print("document.write(\"" + str.toString() + "\");\n");
} else if(var.equals("notice")) {
	StringBuffer str = new StringBuffer();
	Home home = Home.getInstance();
	int[] v = home.getNoticeIds();
	int noticeLen = v.length;
	if (noticeLen == 0) {
	}else {
		MsgDb md = null;
		MsgMgr mm = new MsgMgr();
		str.append("<ul>");
		for (int k = 0; k < noticeLen; k++) {
			md = mm.getMsgDb(v[k]);
			if (md.isLoaded()) {
				String color = StrUtil.getNullString(md.getColor());
				if (color.equals("")) {
					str.append("<li>");
					str.append(vp.formatDate(md.getAddDate(), vp.props));
					str.append("<a href='");
					str.append(Global.getRootPath());
					str.append("/blog/showblog.jsp?rootid=");
					str.append(md.getId());
					str.append("' target='_blank'>");
					str.append(vp.format(DefaultRender.RenderFullTitle(request, md),vp.props));
					str.append("</a></li>");
				} else {
					str.append("<li>");
					str.append(vp.formatDate(md.getAddDate(), vp.props));
					str.append("<a href='");
					str.append(Global.getRootPath());
					str.append("/blog/showblog.jsp?rootid=");
					str.append(md.getId());
					str.append("' target=_blank><font color=");
					str.append(color);
					str.append(">");
					str.append(vp.format(DefaultRender.RenderFullTitle(request, md),vp.props));
					str.append("</font></a></li>");
				}
			}
		}
		str.append("</ul>");
	}
	out.print("document.write(\"" + str.toString() + "\");\n");
} else if(var.equals("postrank")) {
	BlogDb bd = BlogDb.getInstance();
	long[] ids = bd.getPostRank(row);
	int length = ids.length;
	UserConfigDb ucd2 = new UserConfigDb();
	StringBuffer str = new StringBuffer("<ul>");
	for (int i = 0; i < length; i++) {
		UserConfigDb ucd = ucd2.getUserConfigDb(ids[i]);
		str.append("<li><a href='");
		str.append(Global.getRootPath());
		str.append("/blog/myblog.jsp?blogId=");
		str.append(ucd.getId());
		str.append("' target=_blank>");
		str.append(vp.format(ucd.getTitle(), vp.props));
		str.append("</a></li>");
	}
	str.append("</ul>");
	out.print("document.write(\"" + str.toString() + "\");\n");
} else if(var.equals("recommandblog")) {
	StringBuffer str = new StringBuffer();
	BlogDb bd = BlogDb.getInstance();
	Vector rv = bd.getAllRecommandBlogs();
	int nsize = rv.size();
	if (nsize == 0) {
	}else {
		if (start>=rv.size()){
			out.print("document.write(\"" + "" + "\");\n");
		}
		if (end>=rv.size())
			end = rv.size();
		str.append("<ul>");
		for (int i=start; i<end; i++) {
			UserConfigDb ucd = (UserConfigDb) rv.elementAt(i);
			str.append("<li><a href='myblog.jsp?blogId=");
			str.append(ucd.getId());
			str.append("' target=_blank>");
			str.append(vp.format(ucd.getTitle(), vp.props));
			str.append("</a></li>");
		}
		str.append("</ul>");
	}
	out.print("document.write(\"" + str.toString() + "\");\n");
} else if(var.equals("replyrank")) {
	BlogDb bd = BlogDb.getInstance();
	long[] ids = bd.getReplyRank(row);
	int length = ids.length;
	UserConfigDb ucd2 = new UserConfigDb();
	StringBuffer str = new StringBuffer("<ul>");
	for (int i = 0; i < length; i++) {
		UserConfigDb ucd = ucd2.getUserConfigDb(ids[i]);
		str.append("<li><a href='");
		str.append(Global.getRootPath());
		str.append("/blog/myblog.jsp?blogId=");
		str.append(ucd.getId());
		str.append("' target=_blank>");
		str.append(vp.format(ucd.getTitle(), vp.props));
		str.append("</a></li>");
	}
	str.append("</ul>");
	out.print("document.write(\"" + str.toString() + "\");\n");
} else if(var.equals("renderstar")) {
	BlogDb bd = BlogDb.getInstance();
	String star = bd.getStar();
	if(star.equals("")) {
		out.print("document.write(\"" + "" + "\");\n");
	}
	String[] nicks = StrUtil.split(star, ",");
	int length = nicks.length;
	UserConfigDb ucd = new UserConfigDb();
	UserDb user = new UserDb();
	StringBuffer str = new StringBuffer();
	for(int i = 0; i < length; i++) {
		user = user.getUserDbByNick(nicks[i]);
		if(user == null) {
			user = new UserDb();
			continue;
		}
		ucd = ucd.getUserConfigDbByUserName(user.getName());
		if(ucd != null) {
			str.append("<table width='100%' height='64'><tr>");
			str.append("<td width='64'>");
			str.append("<a target=_blank href='");
			str.append(Global.getRootPath());
			str.append("/blog/myblog.jsp?blogId=");
			str.append(ucd.getId());
			str.append("'>");
			if(user.getMyface().equals("")) {
				str.append("<img border=0 style='border:1px solid #cccccc; padding:2px' src='");
				str.append(Global.getRootPath());
				str.append("/forum/images/face/");
				str.append(user.getRealPic());
				str.append("' width=96 height=96 />");
			}else {
				str.append("<img border=0 style='border:1px solid #cccccc; padding:2px' src='");
				str.append(user.getMyfaceUrl(request));
				str.append("' width=96 height=96 />");
			}
			str.append("</a>");
			str.append("</td>");
			str.append("<td>");
			str.append("<table>");
			str.append("<tr><td><a href='");
			str.append(Global.getRootPath());
			str.append("/userinfo.jsp?username=");
			str.append(user.getName());
			str.append("' class='person1'>");
			str.append(user.getNick());
			str.append("</a></td></tr>");
			str.append("<tr><td><a href='");
			str.append(Global.getRootPath());
			str.append("/userinfo.jsp?username=");
			str.append(StrUtil.UrlEncode(user.getName()));
			str.append("'>");
			str.append(user.getNick());
			str.append("</a></td></tr>");
			str.append("<tr><td><a href='");
			str.append(Global.getRootPath());
			str.append("/blog/myblog.jsp?blogId=");
			str.append(ucd.getId());
			str.append("' class='person1'>");
			str.append(ucd.getSubtitle());
			str.append("</a></td></tr>");
			str.append("<tr><td><img src='");
			str.append(Global.getRootPath());
			str.append("/blog/template/images/addfriend.gif'>&nbsp;<a href='");
			str.append(Global.getRootPath());
			str.append("/forum/addfriend.jsp?friend=");
			str.append(StrUtil.UrlEncode(user.getName()));
			str.append("'>加为好友</a>&nbsp;<img src='");
			str.append(Global.getRootPath());
			str.append("/blog/template/images/sendmsg.gif'>&nbsp;<a href=''>短消息</a></td></tr>");
			str.append("</table>");
			str.append("</td></tr></table>");
		}else {
			ucd = new UserConfigDb();
		}
	}
	out.print("document.write(\"" + str.toString() + "\");\n");
}else if(var.equals("verticalscroller")) {

}else if(var.equals("listPhoto")) {
	int pageNum = ParamUtil.getInt(request, "pageNum", 1);
	
	com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
	
	PhotoDb pd = new PhotoDb();
	ListResult lr = pd.listResult(pd.getListPhotoSql(), pageNum, row);
	
	Iterator ir = lr.getResult().iterator();
	StringBuffer str = new StringBuffer();
	while (ir.hasNext()) {
		pd = (PhotoDb) ir.next();
		String attachmentBasePath = Global.getRootPath() + "/upfile/" +
									pd.photoBasePath + "/";
		if (pd.isRemote()) {
			boolean isFtpUsed = cfg.getBooleanProperty("forum.ftpUsed");
			if (isFtpUsed) {
				attachmentBasePath = cfg.getProperty("forum.ftpUrl");
				if (attachmentBasePath.lastIndexOf("/") !=
					attachmentBasePath.length() - 1)
					attachmentBasePath += "/";
				attachmentBasePath += pd.photoBasePath + "/";
			}
		}
		str.append("<div class=\"index_photo_wrap\"><div class=\"index_photo_box\"><a href=\"showphoto.jsp?blogId=");
		str.append(pd.getBlogId());
		str.append("&id=");
		str.append(pd.getId());
		str.append("\">");
		str.append("<img src=\"");
		str.append(attachmentBasePath);
		str.append(pd.getImage());
		str.append("\" alt=\"");
		str.append(StrUtil.toHtml(pd.getTitle()));
		str.append("\" border=0></a></div>");
		str.append("<a title=\"");
		str.append(StrUtil.toHtml(pd.getTitle()));
		str.append("\" href=\"showphoto.jsp?blogId=");
		str.append(pd.getBlogId());
		str.append("&id=");
		str.append(pd.getId());
		str.append("\">");
		str.append(StrUtil.getLeft(pd.getTitle(), len));
		str.append("</a>");
		str.append("</div>");
	}
	out.print("document.write('" + str.toString() + "');");
} else if(var.equals("listMusic")) {
	String sql = "";
	StringBuffer str = new StringBuffer();
	if(!dirCode.equals("")) {
		sql = "select id from blog_music where dir_code='" + dirCode + "'";
	} else {
		sql = "select id from blog_music";
	}
	if(!order.equals("")) {
		sql += " order by " + order + " desc";
	}
	MusicDb md = new MusicDb();
	Iterator i = md.listResult(sql,1,10).getResult().iterator();
	if(i.hasNext()) {
		str.append("<ul>");
	} else {
		return;
	}
	while(i.hasNext()) {
		md = (MusicDb)i.next();
		str.append("<li>");
		str.append("<a href=\"showmusic.jsp?blogId=");
		str.append(md.getString("blog_id"));
		str.append("&id=");
		str.append(md.getString("id"));
		str.append("\">");
		str.append(StrUtil.getLeft(md.getString("title"),len));
		str.append("</a>");
		str.append("</li>");
	}
	str.append("</ul>");
	out.print("document.write('" + str.toString() + "');");
} else if(var.equals("listVideo")) {
	String sql = "";
	StringBuffer str = new StringBuffer();
	if(!dirCode.equals("")) {
		sql = "select id from blog_video where dir_code='" + dirCode + "'";
	} else {
		sql = "select id from blog_video";
	}
	if(!order.equals("")) {
		sql += " order by " + order + " desc";
	}
	VideoDb vd = new VideoDb();
	Iterator i = vd.listResult(sql,1,10).getResult().iterator();
	if(i.hasNext()) {
		str.append("<ul>");
	} else {
		return;
	}
	while(i.hasNext()) {
		vd = (VideoDb)i.next();
		str.append("<li>");
		str.append("<a href=\"showvideo.jsp?blogId=");
		str.append(vd.getString("blog_id"));
		str.append("&id=");
		str.append(vd.getString("id"));
		str.append("\">");
		str.append(StrUtil.getLeft(vd.getString("title"),len));
		str.append("</a>");
		str.append("</li>");
	}
	str.append("</ul>");
	out.print("document.write('" + str.toString() + "');");
} else {
	out.print("document.write(\"\");\n");
}
%>