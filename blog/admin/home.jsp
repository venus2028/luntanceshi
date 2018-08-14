<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>首页管理</title>
<style>
.btn {
border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;
}
.style1 {font-size: 14px;
	font-weight: bold;
}
</style>
<script language="JavaScript">
<!--
function openWin(url,width,height)
{
	var newwin = window.open(url,"_blank","scrollbars=yes,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}

var curObj;

function openSelFocusTopicWin() {
	curObj = form1.focus;
	openWin("../../forum/topic_m.jsp?action=sel&selboard=cwBlogTopic", 800, 600);	
}

function openSelNoticeTopicWin() {
	curObj = form2.notice;
	openWin("../../forum/topic_m.jsp?action=sel&selboard=cwBlogTopic", 800, 600);	
}

function openSelVerticalScrollerTopicWin() {
	curObj = formV.verticalScroller;
	openWin("../../forum/topic_m.jsp?action=sel&selboard=cwBlogTopic", 800, 600);	
}

function selDocument(ids) {
	// 检查在notices中是否已包含了ids中的id，避免重复加入
	var ary = ids.split(",");
	var ntc = curObj.value;
	var ary2 = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		var founded = false;
		for (var j=0; j<ary2.length; j++) {
			if (ary[i]==ary2[j]) {
				founded = true;
				break;
			}
		}
		if (!founded) {
			if (ntc=="")
				ntc += ary[i];
			else
				ntc += "," + ary[i];
		}
	}
	curObj.value = ntc;
}

function delFocus(id) {
	var ntc = form1.focus.value;
	var ary = ntc.split(",");
	var ary2 = new Array();
	var k = 0;
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			continue;
		}
		else {
			ary2[k] = ary[i];
			k++;
		}
	}
	ntc = "";
	for (i=0; i<ary2.length; i++) {
		if (ntc=="")
			ntc += ary2[i];
		else
			ntc += "," + ary2[i];
	}
	form1.focus.value = ntc;
	form1.submit();
}

function up(id) {
	var ntc = form1.focus.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=0) {
				var tmp = ary[i-1];
				ary[i-1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	form1.focus.value = ntc;
	form1.submit();
}

function down(id) {
	var ntc = form1.focus.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=ary.length-1) {
				var tmp = ary[i+1];
				ary[i+1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	form1.focus.value = ntc;
	form1.submit();
}

function delNotice(id) {
	var ntc = form2.notice.value;
	var ary = ntc.split(",");
	var ary2 = new Array();
	var k = 0;
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			continue;
		}
		else {
			ary2[k] = ary[i];
			k++;
		}
	}
	ntc = "";
	for (i=0; i<ary2.length; i++) {
		if (ntc=="")
			ntc += ary2[i];
		else
			ntc += "," + ary2[i];
	}
	form2.notice.value = ntc;
	form2.submit();
}

function n_up(id) {
	var ntc = form2.notice.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=0) {
				var tmp = ary[i-1];
				ary[i-1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	form2.notice.value = ntc;
	form2.submit();
}

function n_down(id) {
	var ntc = form2.notice.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=ary.length-1) {
				var tmp = ary[i+1];
				ary[i+1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	form2.notice.value = ntc;
	form2.submit();
}


function delVertical(id) {
	var ntc = formV.verticalScroller.value;
	var ary = ntc.split(",");
	var ary2 = new Array();
	var k = 0;
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			continue;
		}
		else {
			ary2[k] = ary[i];
			k++;
		}
	}
	ntc = "";
	for (i=0; i<ary2.length; i++) {
		if (ntc=="")
			ntc += ary2[i];
		else
			ntc += "," + ary2[i];
	}
	formV.verticalScroller.value = ntc;
	formV.submit();
}

function v_up(id) {
	var ntc = formV.verticalScroller.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=0) {
				var tmp = ary[i-1];
				ary[i-1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	formV.verticalScroller.value = ntc;
	formV.submit();
}

function v_down(id) {
	var ntc = formV.verticalScroller.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=ary.length-1) {
				var tmp = ary[i+1];
				ary[i+1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	formV.verticalScroller.value = ntc;
	formV.submit();
}

function setPerson(userName, userNick){
	if (formStar.star.value=="")
		formStar.star.value = userNick;
	else
		formStar.star.value += "," + userNick;
}

function setBlog(blogId){
	if (formRmdBlogs.recommandBlogs.value=="")
		formRmdBlogs.recommandBlogs.value = blogId;
	else
		formRmdBlogs.recommandBlogs.value += "," + blogId;
}

function setPhoto(photoId){
	if (formRPhoto.photo.value=="")
		formRPhoto.photo.value = photoId;
	else
		formRPhoto.photo.value += "," + photoId;
}

function setMusic(musicId){
	if (formRMusic.music.value=="")
		formRMusic.music.value = musicId;
	else
		formRMusic.music.value += "," + musicId;
}

function setVideo(videoId){
	if (formRVideo.video.value=="")
		formRVideo.video.value = videoId;
	else
		formRVideo.video.value += "," + videoId;
}

var urlObj;
function SelectImage(urlObject) {
	urlObj = urlObject;
	openWin("../../forum/admin/media_frame.jsp?action=selectImage", 800, 600);
}
function SetUrl(visualPath) {
	urlObj.value = visualPath;
}
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

Home home = Home.getInstance();

BlogDb bd = new BlogDb();
bd = bd.getBlogDb();

String op = ParamUtil.get(request, "op");
if (op.equals("setFocus")) {
	String focus = ParamUtil.get(request, "focus");
	home.setProperty("focus", focus);
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
	return;
}
else if (op.equals("setNotice")) {
	String notice = ParamUtil.get(request, "notice");
	home.setProperty("notice", notice);
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
	return;
}
else if (op.equals("verticalScroller")) {
	String verticalScroller = ParamUtil.get(request, "verticalScroller");
	home.setProperty("verticalScroller", verticalScroller);
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
	return;
}
else if (op.equals("setFlashImages")) {
	for (int i=1; i<=5; i++) {
		String url = ParamUtil.get(request, "url" + i);
		String link = ParamUtil.get(request, "link" + i);
		String text = ParamUtil.get(request, "text" + i);
		home.setProperty("flash", "id", "" + i, "url", url);	
		home.setProperty("flash", "id", "" + i, "link", link);	
		home.setProperty("flash", "id", "" + i, "text", text);	
	}	
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
	return;
}
else if (op.equals("setRecommandBlogs")) {
	String recommandBlogs = ParamUtil.get(request, "recommandBlogs");
	bd.setRecommandBlogs(recommandBlogs);
	if (bd.save()) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
		return;
	}
	else
		out.print(SkinUtil.LoadString(request,"res.common", "info_op_fail"));
}
else if (op.equals("star")) {
	String star = ParamUtil.get(request, "star");
	if (star.equals("")) {
		bd.setStar("");
		bd.save();
		out.println(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
		return;
	}
	else {
		star = star.replaceAll("，", ",");
		String[] stars = StrUtil.split(star, ",");
		for (int i=0; i<stars.length; i++) {
			UserDb ud = new UserDb();
			ud = ud.getUserDbByNick(stars[i]);
			if (ud!=null && ud.isLoaded()) {
				UserConfigDb ucd = new UserConfigDb();
				ucd = ucd.getUserConfigDbByUserName(ud.getName());
				if (ucd!=null && ucd.isLoaded()) {
				}
				else {
					String str = SkinUtil.LoadString(request,"res.label.blog.admin.home", "user_blog_not_open");
					str = StrUtil.format(str, new Object[] {star});
					out.print(StrUtil.Alert_Back(str));
					return;
				}
			}
			else{
				String str = SkinUtil.LoadString(request,"res.label.blog.admin.home", "user_not_have");
				str = StrUtil.format(str, new Object[] {stars[i]});
				out.print(StrUtil.Alert_Back(str));
				return;
			}
		}
		bd.setStar(star);
		if (bd.save()) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "home.jsp"));
			return;
		}		
	}
}
else if (op.equals("setRPhoto")) {
	String p = ParamUtil.get(request, "photo");
	if (p.equals("")) {
		bd.setRecommandPhoto("");
		bd.save();
		out.println(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
		return;
	}
	else {
		if (p!=null && !p.equals("")) {
			PhotoDb pd = new PhotoDb();
			p = p.replaceAll("，", ",");
			String[] ids = p.split("\\,");
			int len = ids.length;
			for (int i = 0; i < len; i++) {
				String id = ids[i].trim();
				pd = pd.getPhotoDb(Long.parseLong(id));
				if (pd == null || !pd.isLoaded()) {
					out.print(StrUtil.Alert_Back("相片文件不存在！"));
					return;
				}
			}
		}
		bd.setRecommandPhoto(p);
		if (bd.save()) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "home.jsp"));
			return;
		}		
	}
}
else if (op.equals("setRMusic")) {
	String m = ParamUtil.get(request, "music");
	if (m.equals("")) {
		bd.setRecommandMusic("");
		bd.save();
		out.println(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
		return;
	}
	else {
		if (m!=null && !m.equals("")) {
			MusicDb md = new MusicDb();
			m = m.replaceAll("，", ",");
			String[] ids = m.split("\\,");
			int len = ids.length;
			for (int i = 0; i < len; i++) {
				String id = ids[i].trim();
				md = (MusicDb)md.getQObjectDb(new Long(Long.parseLong(id)));
				if (md == null || !md.isLoaded()) {
					out.print(StrUtil.Alert_Back("音乐文件不存在！"));
					return;
				}
			}
		}
		bd.setRecommandMusic(m);
		if (bd.save()) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "home.jsp"));
			return;
		}		
	}
}
else if (op.equals("setRVideo")) {
	String video = ParamUtil.get(request, "video");
	if (video.equals("")) {
		bd.setRecommandVideo("");
		bd.save();
		out.println(StrUtil.Alert_Redirect("操作成功！", "home.jsp"));
		return;
	}
	else {
		if (video!=null && !video.equals("")) {
			VideoDb vd = new VideoDb();
			video = video.replaceAll("，", ",");
			String[] ids = video.split("\\,");
			int len = ids.length;
			for (int i = 0; i < len; i++) {
				String id = ids[i].trim();
				vd = (VideoDb)vd.getQObjectDb(new Long(Long.parseLong(id)));
				if (vd == null || !vd.isLoaded()) {
					out.print(StrUtil.Alert_Back("视频文件不存在！"));
					return;
				}
			}
		}
		bd.setRecommandVideo(video);
		if (bd.save()) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "home.jsp"));
			return;
		}		
	}
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理首页</td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">管理</td>
  </tr>
  <tr> 
    <td valign="top">
	<br>
      <table width="490" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td width="77" align="center"><a href="nav_m.jsp">导航条</a> </td>
          <td width="77" align="center"><a href="home.jsp#focus">博客聚焦</a></td>
          <td width="101" align="center"><a href="home.jsp#flash">Flash图片设置</a></td>
          <td width="81" align="center"><a href="ad.jsp">广告</a></td>
          <td width="81" align="center"><a href="home_img.jsp">滚动图片</a></td>
          <td width="81" align="center"><a href="../desktop_edit_template.jsp" target="_blank">编辑模板</a></td>
        </tr>
      </table>
      <br>
      <table width="73%" align="center" class="frame_gray">
      <form id=form1 name=form1 action="?op=setFocus" method=post>
        <tr>
          <td height="22" class="thead"><strong>博客聚焦( 编号之间用，分隔 )</strong></td>
        </tr>
        <tr>
          <td height="22"><input type=text value="<%=StrUtil.getNullString(home.getProperty("focus"))%>" name="focus" size=60>
            <input name="button" type="button" class="btn" onClick="openSelFocusTopicWin()" value="选 择">
            <input type="submit" class="btn" value="确 定">
            <br>
            博客聚焦中的第一篇文章将会显示其摘要。<br>
            提取的模板标签为<span class="middleMain_insideBox_imgContainer_styleOne">{$blog.focus(abstract=60)}&nbsp;            abstract表示提取的摘要为60字(默认为50)</span></td>
          </tr>
        <tr>
          <td height="22">
		  <%
		  					MsgMgr mm = new MsgMgr();
							MsgDb md = null;
							int[] v = home.getFocusIds();
							int focuslen = v.length;
							if (focuslen==0)
								out.print("无热点话题！");
							else {
								for (int k=0; k<focuslen; k++) {
									md = mm.getMsgDb(v[k]);
									if (md.isLoaded()) {
										String color = StrUtil.getNullString(md.getColor());
										if (color.equals("")) {%>
											<%=md.getId()%>&nbsp;<img src="../../images/arrow.gif">&nbsp;<a target="_blank" href="../showblog.jsp?rootid=<%=md.getId()%>"><%=DefaultRender.RenderFullTitle(request, md)%></a>
											<%}else{%>
											<%=md.getId()%>&nbsp;<img src="../../images/arrow.gif">&nbsp;<a target="_blank" href="../showblog.jsp?rootid=<%=md.getId()%>"><font color="<%=color%>"><%=DefaultRender.RenderFullTitle(request, md)%></font></a>
											<%}%>
											&nbsp;&nbsp;[<a href="javascript:delFocus('<%=md.getId()%>')">
											<lt:Label key="op_del"/>
											</a>]
											<%if (k!=0) {%>
											&nbsp;&nbsp;[<a href="javascript:up('<%=md.getId()%>')">
											<lt:Label res="res.label.forum.admin.ad_topic_bottom" key="up"/>
											</a>]
											<%}%>
											<%if (k!=focuslen-1) {%>
											&nbsp;&nbsp;[<a href="javascript:down('<%=md.getId()%>')">
											<lt:Label res="res.label.forum.admin.ad_topic_bottom" key="down"/>
											</a>]
											<%}%>
											<br>
											<%	}
										else {%>
											<%=v[k]%>&nbsp;<font color=red><img src="../../images/arrow.gif">&nbsp;贴子不存在</font> &nbsp;&nbsp;[<a href="javascript:delFocus('<%=v[k]%>')">
											<lt:Label key="op_del"/>
											</a>]<BR>
										<%}
								}
							}%>			</td>
        </tr>
      </form>
</table>
      <br>
      <table width="73%" align="center" class="frame_gray">
        <form id=form2 name=form2 action="?op=setNotice" method=post>
          <tr>
            <td height="22" class="thead"><strong>博客公告( 编号之间用，分隔 )</strong></td>
          </tr>
          <tr>
            <td height="22"><input type=text value="<%=StrUtil.getNullString(home.getProperty("notice"))%>" name="notice" size=60>
                <input name="button2" type="button" class="btn" onClick="openSelNoticeTopicWin()" value="选 择">
                <input name="submit2" type="submit" class="btn" value="确 定"></td>
          </tr>
          <tr>
            <td height="22"><%
							v = home.getNoticeIds();
							int noticelen = v.length;
							if (noticelen==0)
								out.print("无");
							else {
								for (int k=0; k<noticelen; k++) {
									md = mm.getMsgDb(v[k]);
									if (md.isLoaded()) {
										String color = StrUtil.getNullString(md.getColor());
										if (color.equals("")) {%>
                <%=md.getId()%>&nbsp;<img src="../../images/arrow.gif">&nbsp;<a target="_blank" href="../showblog.jsp?rootid=<%=md.getId()%>"><%=DefaultRender.RenderFullTitle(request, md)%></a>
                <%}else{%>
                <%=md.getId()%>&nbsp;<img src="../../images/arrow.gif">&nbsp;<a target="_blank" href="../showblog.jsp?rootid=<%=md.getId()%>"><font color="<%=color%>"><%=DefaultRender.RenderFullTitle(request, md)%></font></a>
                <%}%>
              &nbsp;&nbsp;[<a href="javascript:delNotice('<%=md.getId()%>')">
                <lt:Label key="op_del"/>
                </a>]
              <%if (k!=0) {%>
              &nbsp;&nbsp;[<a href="javascript:n_up('<%=md.getId()%>')">
                <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="up"/>
                </a>]
              <%}%>
              <%if (k!=noticelen-1) {%>
              &nbsp;&nbsp;[<a href="javascript:n_down('<%=md.getId()%>')">
                <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="down"/>
                </a>]
              <%}%>
              <br>
              <%	}
										else {%>
              <%=v[k]%>&nbsp;<font color=red><img src="../../images/arrow.gif">&nbsp;贴子不存在</font> &nbsp;&nbsp;[<a href="javascript:delNotice('<%=v[k]%>')">
                <lt:Label key="op_del"/>
                </a>]<BR>
              <%}
								}
							}%>
            </td>
          </tr>
        </form>
      </table>
      <table width="73%" align="center" class="frame_gray" style="display:none">
        <form id=formV name=formV action="?op=verticalScroller" method=post>
          <tr>
            <td height="22" class="thead"><strong>单行滚动屏</strong></td>
          </tr>
          <tr>
            <td height="22"><input type=text value="<%=StrUtil.getNullString(home.getProperty("verticalScroller"))%>" name="verticalScroller" size=60>
                <input name="button22" type="button" class="btn" onClick="openSelVerticalScrollerTopicWin()" value="选 择">
                <input name="submit23" type="submit" class="btn" value="确 定"></td>
          </tr>
          <tr>
            <td height="22"><%
							v = home.getVerticalScrollerIds();
							int vlen = v.length;
							if (vlen==0)
								out.print("无热点话题！");
							else {
								for (int k=0; k<vlen; k++) {
									md = mm.getMsgDb(v[k]);
									if (md.isLoaded()) {
										String color = StrUtil.getNullString(md.getColor());
										if (color.equals("")) {%>
                <%=md.getId()%>&nbsp;<img src="../../images/arrow.gif">&nbsp;<a target="_blank" href="../showblog.jsp?rootid=<%=md.getId()%>"><%=DefaultRender.RenderFullTitle(request, md)%></a>
                <%}else{%>
                <%=md.getId()%>&nbsp;<img src="../../images/arrow.gif">&nbsp;<a target="_blank" href="../showblog.jsp?rootid=<%=md.getId()%>"><font color="<%=color%>"><%=DefaultRender.RenderFullTitle(request, md)%></font></a>
                <%}%>
              &nbsp;&nbsp;[<a href="javascript:delVertical('<%=md.getId()%>')">
                <lt:Label key="op_del"/>
                </a>]
              <%if (k!=0) {%>
              &nbsp;&nbsp;[<a href="javascript:v_up('<%=md.getId()%>')">
                <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="up"/>
                </a>]
              <%}%>
              <%if (k!=noticelen-1) {%>
              &nbsp;&nbsp;[<a href="javascript:v_down('<%=md.getId()%>')">
                <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="down"/>
                </a>]
              <%}%>
              <br>
              <%	}
										else {%>
              <%=v[k]%>&nbsp;<font color=red><img src="../../images/arrow.gif">&nbsp;贴子不存在</font> &nbsp;&nbsp;[<a href="javascript:delVertical('<%=v[k]%>')">
                <lt:Label key="op_del"/>
                </a>]<BR>
              <%}
								}
							}%>
            </td>
          </tr>
        </form>
      </table>
      <br>
      <table width="73%" border='0' align="center" cellpadding='5' cellspacing='0' class="frame_gray">
        <tr>
          <td height=20 align="center" class="thead style1"><lt:Label res="res.label.blog.admin.home" key="blog_star"/></td>
        </tr>
        <tr>
          <td valign="top"><%
	String star = StrUtil.getNullString(bd.getStar());
	UserDb user = new UserDb();
	if (!star.equals("")) {
		// start 中存储的是用户的name
		String[] stars = StrUtil.split(star, ",");
		for (int i=0; i<stars.length; i++) { 
			user = user.getUserDbByNick(stars[i]);
			if (user!=null) {
				UserConfigDb ucd = new UserConfigDb();
				ucd = ucd.getUserConfigDbByUserName(user.getName());
				if (ucd!=null) {
			%>
				  <table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
					  <td><font color="#FF0000">
				<%
				String myface = user.getMyface();
				String RealPic = user.getRealPic(); 
				if (myface.equals("")) {%>
						<img src="../../forum/images/face/<%=RealPic%>"/>
						<%}else{%>
						<img src="<%=user.getMyfaceUrl(request)%>" name="tus" id="tus" />
						<%}%>
					  </font></td>
					</tr>
					<tr>
					  <td><a href="../myblog.jsp?userName=<%=StrUtil.UrlEncode(star)%>" target="_blank"><%=ucd.getTitle()%></a></td>
					</tr>
					<tr>
					  <td><%=ucd.getSubtitle()%></td>
					</tr>
				  </table>
				<%}
			}
		}
	}
	%>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <form name="formStar" action="?op=star" method="post">
                  <tr>
                    <td><input type="text" name="star" value="<%=star%>">
                        <a href="javascript:openWin('blog_user_sel.jsp', 800, 600)"><lt:Label res="res.label.forum.admin.manager_list" key="select"/></a>
                        <input name="submit" type="submit" value="<lt:Label res="res.label.blog.admin.home" key="set_blog_star"/>">
                    <lt:Label res="res.label.blog.admin.home" key="desc_star"/></td>
                  </tr>
                </form>
            </table></td>
        </tr>
      </table>
      <br>
      <table width="73%" height="135" border='0' align="center" cellpadding='5' cellspacing='0' class="frame_gray">
        <tr>
          <td height=20 align="center" class="thead style1"><lt:Label res="res.label.blog.admin.home" key="commend_blog"/></td>
        </tr>
        <tr>
          <td height="105" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
              <form name="formRmdBlogs" action="?op=setRecommandBlogs" method="post">
                <tr>
                  <td><input name="recommandBlogs" type="text" value="<%=StrUtil.getNullString(bd.getRecommandBlogs())%>" size="50">
                      <a href="javascript:openWin('blog_sel.jsp', 800, 600)"><lt:Label res="res.label.forum.admin.manager_list" key="select"/></a>
                      <input name="submit22" type="submit" value="<lt:Label res="res.label.blog.admin.home" key="commend"/>">
                      <br>
                      <lt:Label res="res.label.blog.admin.home" key="comment_description"/></td>
                </tr>
                <tr>
                  <td><%
			Vector vBlogRecommanded = bd.getAllRecommandBlogs();
			int nsize = vBlogRecommanded.size();
			if (nsize==0)
				out.print(SkinUtil.LoadString(request,"res.label.blog.admin.home", "not_commend_blog"));
			else {
				Iterator ir = vBlogRecommanded.iterator();
				while (ir.hasNext()) {
					UserConfigDb ucd = (UserConfigDb)ir.next();
			%>
                      <table width="100%">
                        <tr>
                          <td><li><a href="../myblog.jsp?blogId=<%=ucd.getId()%>" target="_blank"><%=ucd.getTitle()%></a></li></td>
                        </tr>
                      </table>
                    <%
				}
			}
		  %>
                  </td>
                </tr>
              </form>
          </table></td>
        </tr>
      </table>
      <br>

<table width="73%" height="135" border='0' align="center" cellpadding='5' cellspacing='0' class="frame_gray">
	<tr>
		<td height=20 align="center" class="thead style1">推荐相片</td>
	</tr>
	<tr>
		<td height="105" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<form name="formRPhoto" action="?op=setRPhoto" method="post">
				<tr>
					<td>
						<input name="photo" type="text" value="<%=StrUtil.getNullString(bd.getRecommandPhoto())%>" size="50">
						<a href="javascript:openWin('photo_sel.jsp', 800, 600)"><lt:Label res="res.label.forum.admin.manager_list" key="select"/></a>
						<input name="" type="submit" value="<lt:Label res="res.label.blog.admin.home" key="commend"/>">
                    	 <br>
                    	 ( 推荐相片的编号之间用，分隔) 
					</td>
				</tr>
				<tr>
					<td>
					<%
						Vector vRPhoto = bd.getAllRecommandPhoto();
						if (vRPhoto.size()==0)
							out.print("没有推荐的相片！");
						else {
							Iterator iRPhoto = vRPhoto.iterator();
							while (iRPhoto.hasNext()) {
								PhotoDb photoDb = (PhotoDb)iRPhoto.next();
					%>
						<table width="100%">
							<tr>
								<td><li><a href="../showphoto.jsp?photoId=<%=photoDb.getId()%>" target="_blank"><%=photoDb.getTitle()%></a></li></td>
							</tr>
						</table>
					<%
							}
						}
					%>
					</td>
				</tr>
				</form>
			</table>
		</td>
	</tr>
</table>
<br>

<table width="73%" height="135" border='0' align="center" cellpadding='5' cellspacing='0' class="frame_gray">
	<tr>
		<td height=20 align="center" class="thead style1">推荐音乐</td>
	</tr>
	<tr>
		<td height="105" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<form name="formRMusic" action="?op=setRMusic" method="post">
				<tr>
					<td>
						<input name="music" type="text" value="<%=StrUtil.getNullString(bd.getRecommandMusic())%>" size="50">
						<a href="javascript:openWin('music_sel.jsp', 800, 600)"><lt:Label res="res.label.forum.admin.manager_list" key="select"/></a>
						<input name="" type="submit" value="<lt:Label res="res.label.blog.admin.home" key="commend"/>">
                    	 <br>
                    	 ( 推荐音乐的编号之间用，分隔) 
					</td>
				</tr>
				<tr>
					<td>
					<%
						Vector vRMusic = bd.getAllRecommandMusic();
						if (vRMusic.size()==0)
							out.print("没有推荐的音乐！");
						else {
							Iterator iRMusic = vRMusic.iterator();
							while (iRMusic.hasNext()) {
								MusicDb musicDb = (MusicDb)iRMusic.next();
					%>
						<table width="100%">
							<tr>
								<td><li><a href="../showmusic.jsp?musicId=<%=musicDb.getLong("id")%>" target="_blank"><%=musicDb.getString("title")%></a></li></td>
							</tr>
						</table>
					<%
							}
						}
					%>
					</td>
				</tr>
				</form>
			</table>
		</td>
	</tr>
</table>
<br>

<table width="73%" height="135" border='0' align="center" cellpadding='5' cellspacing='0' class="frame_gray">
	<tr>
		<td height=20 align="center" class="thead style1">推荐视频</td>
	</tr>
	<tr>
		<td height="105" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<form name="formRVideo" action="?op=setRVideo" method="post">
				<tr>
					<td>
						<input name="video" type="text" value="<%=StrUtil.getNullString(bd.getRecommandVideo())%>" size="50">
						<a href="javascript:openWin('video_sel.jsp', 800, 600)"><lt:Label res="res.label.forum.admin.manager_list" key="select"/></a>
						<input name="" type="submit" value="<lt:Label res="res.label.blog.admin.home" key="commend"/>">
                    	 <br>
                    	 ( 推荐视频的编号之间用，分隔) 
					</td>
				</tr>
				<tr>
					<td>
					<%
						Vector vRVideo = bd.getAllRecommandVideo();
						if (vRVideo.size()==0)
							out.print("没有推荐的视频！");
						else {
							Iterator iRVideo = vRVideo.iterator();
							while (iRVideo.hasNext()) {
								VideoDb videoDb = (VideoDb)iRVideo.next();
					%>
						<table width="100%">
							<tr>
								<td><li><a href="../showvideo.jsp?videoId=<%=videoDb.getLong("id")%>" target="_blank"><%=videoDb.getString("title")%></a></li></td>
							</tr>
						</table>
					<%
							}
						}
					%>
					</td>
				</tr>
				</form>
			</table>
		</td>
	</tr>
</table>
<br />
      <table width="73%" align="center" class="frame_gray">
        <form id=form4 name=form4 action="?op=setFlashImages" method=post>
          <tr>
            <td height="22" class="thead"><strong><a name="flash">Flash图片设置</a></strong></td>
            <td height="22" class="thead"><strong>地址</strong></td>
            <td height="22" class="thead"><strong>链接</strong></td>
            <td height="22" class="thead"><strong>文字</strong></td>
          </tr>
          <tr>
            <td height="22">图片1              </td>
            <td><input name="url1" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "1", "url"))%>">
            <input name="button3" type="button" onclick="SelectImage(form4.url1)" value="选择" /></td>
            <td><input name="link1" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "1", "link"))%>"></td>
            <td><input name="text1" value="<%=StrUtil.toHtml(StrUtil.getNullStr(home.getProperty("flash", "id", "1", "text")))%>"></td>
          </tr>
          <tr>
            <td height="22">图片2              </td>
            <td><input name="url2" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "2", "url"))%>">
            <input name="button32" type="button" onclick="SelectImage(form4.url2)" value="选择" /></td>
            <td><input name="link2" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "2", "link"))%>"></td>
            <td><input name="text2" value="<%=StrUtil.toHtml(StrUtil.getNullStr(home.getProperty("flash", "id", "2", "text")))%>"></td>
          </tr>
          <tr>
            <td height="22">图片3              </td>
            <td><input name="url3" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "3", "url"))%>">
            <input name="button33" type="button" onclick="SelectImage(form4.url3)" value="选择" /></td>
            <td><input name="link3" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "3", "link"))%>"></td>
            <td><input name="text3" value="<%=StrUtil.toHtml(StrUtil.getNullStr(home.getProperty("flash", "id", "3", "text")))%>"></td>
          </tr>
          <tr>
            <td height="22">图片4              </td>
            <td><input name="url4" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "4", "url"))%>">
            <input name="button34" type="button" onclick="SelectImage(form4.url4)" value="选择" /></td>
            <td><input name="link4" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "4", "link"))%>"></td>
            <td><input name="text4" value="<%=StrUtil.toHtml(StrUtil.getNullStr(home.getProperty("flash", "id", "4", "text")))%>"></td>
          </tr>
          <tr>
            <td width="18%" height="22">图片5  			  </td>
            <td width="36%"><input name="url5" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "5", "url"))%>">
            <input name="button35" type="button" onclick="SelectImage(form4.url5)" value="选择" /></td>
            <td width="23%"><input name="link5" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "5", "link"))%>"></td>
            <td width="23%"><input name="text5" value="<%=StrUtil.toHtml(StrUtil.getNullStr(home.getProperty("flash", "id", "5", "text")))%>"></td>
          </tr>
          <tr>
            <td height="22" colspan="4" align="center"><input name="submit32" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value=" 确 定 "></td>
          </tr>
        </form>
      </table>
      <br>
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
  