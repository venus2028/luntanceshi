<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();
%>
<script>
function hopenWin(url,width,height) {
  var newwin = window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}
</script>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.canUserDo(request, "", "view_userinfo")) {
	response.sendRedirect("info.jsp?info=" + StrUtil.UrlEncode(SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
String username = ParamUtil.get(request, "username");
if (username==null) {
	out.print(StrUtil.makeErrMsg(SkinUtil.LoadString(request,"res.label.userinfo","user_name_can_not_be_null")));
	return;
}

com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();

String name = privilege.getUser(request);
UserDb user = new UserDb();
user = user.getUser(username);
if (!user.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.userinfo","user_not_exsist")));
	return;
}
%>
<%
String RegName="",Question="",Answer="";
String RealName="",Career="";
String Gender="",Job="";
int BirthYear = 0;
int BirthMonth = 0;
int BirthDay = 0;
Date Birthday = null;
String Marriage="",Phone="",Mobile="";
String State="",City="",Address="";
String PostCode="",IDCard="",RealPic="";
String Email="",OICQ="";
String Hobbies="",myface="";
String RegDate = "";

		RegName = user.getName();
		Question = user.getQuestion();
		Answer = user.getAnswer();
		RealName = user.getRealName();
		Career = user.getCareer();
		Gender = user.getGender();
		if (Gender.equals("M"))
			Gender = SkinUtil.LoadString(request, "res.label.forum.showtopic", "sex_man"); // "男";
		else if (Gender.equals("F"))
			Gender = SkinUtil.LoadString(request, "res.label.forum.showtopic", "sex_woman"); // "女";
		else
			Gender = SkinUtil.LoadString(request, "res.label.forum.showtopic", "sex_none"); // "不详";
		
		Job = user.getJob();
		Birthday = user.getBirthday();
		if (Birthday!=null) {
			Calendar cld = Calendar.getInstance();
			cld.setTime(Birthday);
			BirthYear = cld.get(Calendar.YEAR);
			BirthMonth = cld.get(Calendar.MONTH)+1;
			BirthDay = cld.get(Calendar.DAY_OF_MONTH);			
		}
		int mar = user.getMarriage();
		if (mar==1)
			Marriage = SkinUtil.LoadString(request,"res.label.userinfo","married");
		else if (mar==0)
			Marriage = SkinUtil.LoadString(request,"res.label.userinfo","not_married");
		else
			Marriage = SkinUtil.LoadString(request,"res.label.userinfo","married_none");
		Phone = user.getPhone();
		Mobile = user.getMobile();
		State = user.getState();
		City = user.getCity();
		Address = user.getAddress();
		PostCode = user.getPostCode();
		IDCard = user.getIDCard();
		RealPic = user.getRealPic();
		RegDate = com.redmoon.forum.ForumSkin.formatDateTime(request, user.getRegDate());

		Hobbies = user.getHobbies();
		Email = user.getEmail();
		OICQ = user.getOicq();
		myface = user.getMyface();
%>
<br>
<br>
<table width=100% height="308" border=0 align="center" cellpadding=5 cellspacing=1 class="tableframe_gray">
  <tr align="center" valign="middle">
    <td height="25" colspan="5" background="forum/<%=skinPath%>/images/bg1.gif" bgcolor="#EFEFEF"><b>
    <lt:Label res="res.label.userinfo" key="user_info"/></b></td>
  </tr>
  <tr valign="middle">
    <td width=31% rowspan="9" align=left bgcolor="#FBFBFB"><table cellspacing=0 cellpadding=3 width="90%" align=center 
border=0>
      <tbody>
        <tr>
          <td align=left><table style="FILTER: glow(color=a4b6d7)">
              <caption>
              <b><font style="FONT-SIZE: 10pt" 
                    color=#ffffff><%=user.getNick()%></font></b>
              </caption>
          </table>
              <%
				  UserGroupDb ugd = user.getUserGroupDb();
				  if (!ugd.getCode().equals(UserGroupDb.EVERYONE)) {
				  	out.print("<table><tr><td>" + ugd.getDesc() + "</td></tr></table>");
				  }
				%>          </td>
        </tr>
        <tr>
          <td align=left height=42><%if (myface.equals("")) {%>
              <img src="<%=request.getContextPath()%>/forum/images/face/<%=RealPic%>">
              <%}else{%>
              <img src="<%=request.getContextPath()%>/<%=user.getMyfaceUrl(request)%>">
              <%}%>          </td>
        </tr>
        <tr>
          <td align=left height=17><img src="<%=request.getContextPath()%>/forum/images/<%=user.getLevelPic()%>"> <%=Gender%></td>
        </tr>
        <tr>
          <td align=left height=54><lt:Label res="res.label.forum.showtopic" key="rank"/>
            <%=user.getLevelDesc()%><br>
            <lt:Label res="res.label.forum.showtopic" key="topic_count"/>
            <%=user.getAddCount()%><br>
            <lt:Label res="res.label.forum.showtopic" key="reg_date"/>
            <%=RegDate%><br>
            <lt:Label res="res.label.forum.showtopic" key="online_status"/>
            <%
						OnlineUserDb ou = new OnlineUserDb();
						ou = ou.getOnlineUserDb(user.getName());
						if (ou.isLoaded())
							out.print(SkinUtil.LoadString(request, "res.label.forum.showtopic", "online_status_yes")); // "在线");
						else
							out.print(SkinUtil.LoadString(request, "res.label.forum.showtopic", "online_status_no")); // "离线");
						%>
              <%if (cfg.getBooleanProperty("forum.isOnlineTimeRecord")) {%>
              <BR>
            <lt:Label res="res.label.forum.showtopic" key="online_time"/>
            <%=(int)user.getOnlineTime()%>
            <lt:Label res="res.label.forum.showtopic" key="hour"/>
              <%}%>

              <%						
			if (cfg.getBooleanProperty("forum.showFlowerEgg")) {
					UserPropDb up = new UserPropDb();
					up = up.getUserPropDb(user.getName());
			%>
              <div style="padding-top:5px"><img src="<%=request.getContextPath()%>/images/flower.gif">&nbsp;(<%=up.getInt("flower_count")%>)&nbsp;&nbsp;&nbsp; <img src="<%=request.getContextPath()%>/images/egg.gif">&nbsp;(<%=up.getInt("egg_count")%>)</div>
            <%}
						%></td>
        </tr>
      </tbody>
    </table></td> 
    <td width=14% height="25" align=left bgcolor="#EFEFEF"><lt:Label res="res.label.forum.user" key="Gender"/></td>
    <td width="18%" height="25" bgcolor="#FBFBFB"> 
    <% if (Gender.equals("M"))
						out.println(SkinUtil.LoadString(request,"res.label.prision","man"));
					else if (Gender.equals("F"))
						out.println(SkinUtil.LoadString(request,"res.label.prision","woman"));
					else
						out.println(SkinUtil.LoadString(request,"res.label.prision","not_in_detail"));
				  %></td>
    <td width=13% height="25" align="left" bgcolor="#EFEFEF"> <lt:Label res="res.label.forum.user" key="Career"/></td>
    <td width="24%" height="25" bgcolor="#FBFBFB" class=l15> <%=StrUtil.toHtml(Career)%> </td>
  </tr>
  <tr valign="middle">
    <td width=14% height="25" align=left bgcolor="#EFEFEF">E-mail</td>
    <td height="25" bgcolor="#FBFBFB"><%if (!user.isSecret()) {%>
      <%=StrUtil.toHtml(Email)%>
      <%}else{%>
<lt:Label res="res.label.userinfo" key="secret"/>
<%}%></td>
    <td width=13% height="25" align="left" bgcolor="#EFEFEF"> <lt:Label res="res.label.forum.user" key="Job"/></td>
    <td height="25" bgcolor="#FBFBFB" class=l15> <%=Job%></td>
  </tr>
  <tr valign="middle">
    <td width=14% height="28" align=left bgcolor="#EFEFEF">QQ</td>
    <td height="28" bgcolor="#FBFBFB"><%if (!user.isSecret()) {%>
      <%=OICQ%>
      <%}else{%>
      <lt:Label res="res.label.userinfo" key="secret"/>
<%}%></td>
    <td width=13% height="28" align="left" bgcolor="#EFEFEF">MSN</td>
    <td height="28" bgcolor="#FBFBFB" class=l15><%if (!user.isSecret()) {%>
<%=user.getMsn()%>
<%}else{%>
<lt:Label res="res.label.userinfo" key="secret"/>
<%}%></td>
  </tr>
  <tr valign="middle">
    <td width=14% height="27" align=left bgcolor="#EFEFEF"><lt:Label res="res.label.forum.user" key="State"/></td>
    <td height="27" bgcolor="#FBFBFB"> <%=StrUtil.toHtml(State)%></td>
    <td align="left" bgcolor="#EFEFEF"><lt:Label res="res.label.forum.user" key="City"/></td>
    <td bgcolor="#FBFBFB"><%=City%></td>
  </tr>
  <tr valign="middle">
    <td width=14% height="25" align=left bgcolor="#EFEFEF"><lt:Label res="res.label.forum.user" key="PostCode"/></td>
    <td height="25" bgcolor="#FBFBFB"><%=StrUtil.toHtml(PostCode)%></td>
    <td align="left" bgcolor="#EFEFEF"><lt:Label res="res.label.forum.user" key="Hobbies"/></td>
    <td bgcolor="#FBFBFB"><%=Hobbies%></td>
  </tr>
  
  <tr valign="middle">
    <td height="29" align=left bgcolor="#EFEFEF"><lt:Label res="res.label.forum.user" key="home"/></td>
    <td bgcolor="#FBFBFB"><a href="<%=StrUtil.toHtml(user.getHome())%>" target="_blank"><%=StrUtil.toHtml(user.getHome())%></a></td>
    <td align="left" bgcolor="#EFEFEF"><lt:Label res="res.label.forum.user" key="marry_status"/></td>
    <td bgcolor="#FBFBFB"><span class="l15">
      <%if (!user.isSecret()) {%>
      <%=StrUtil.toHtml(Marriage)%>
      <%}else{%>
      <lt:Label res="res.label.userinfo" key="secret"/>
      <%}%>
    </span></td>
  </tr>
  <tr valign="middle">
    <td height="29" colspan="4" align=left bgcolor="#FBFBFB"><a href="<%=request.getContextPath()%>/forum/addfriend.jsp?friend=<%=StrUtil.UrlEncode(user.getName())%>">
      <lt:Label res="res.label.forum.showtopic" key="add_friend"/></a>&nbsp;&nbsp;
    <%if (cfg.getBooleanProperty("forum.isOrderMusic")) {%>
    <a href="forum/music_order.jsp?userName=<%=StrUtil.UrlEncode(username)%>">
    <lt:Label res="res.label.userinfo" key="order_music"/>
    </a>
    <%}%></td>
  </tr>
  <tr valign="middle">
    <td height="29" colspan="4" align=left bgcolor="#FBFBFB">
	<a href="#" onClick="hopenWin('../message/send.jsp?receiver=<%=StrUtil.UrlEncode(user.getNick())%>', 320, 260)"><lt:Label res="res.label.userinfo" key="send_message"/>
    </a>&nbsp;&nbsp;
    <%if (com.redmoon.blog.Config.getInstance().isBlogOpen) {
	  	UserConfigDb ucd = new UserConfigDb();
		ucd = ucd.getUserConfigDbByUserName(user.getName());
		if (ucd!=null) {
	  %>
      <a target="_blank" title="<lt:Label res="res.label.forum.showtopic" key="blog"/>" href="myblog.jsp?blogId=<%=ucd.getId()%>">
      <lt:Label res="res.label.forum.showtopic" key="blog"/>
      </a>
	  <%}
		if (ucd==null)
			ucd = new UserConfigDb();
		cn.js.fan.base.ObjectBlockIterator oi = ucd.getGroupBlogsOwnedByUser(user.getName());
		while (oi.hasNext()) {
			ucd = (UserConfigDb)oi.next();
			out.print("&nbsp;<a target=_blank href='myblog.jsp?blogId=" + ucd.getId() + "'>" + StrUtil.toHtml(ucd.getTitle()) + "</a>");		
		}	  
		BlogGroupUserDb bgu = new BlogGroupUserDb();
		Iterator qoi = bgu.getBlogGroupUserAttend(user.getName());
		UserConfigDb gucd = new UserConfigDb();
		while (qoi.hasNext()) {
			bgu = (BlogGroupUserDb)qoi.next();
			ucd = gucd.getUserConfigDb(bgu.getLong("blog_id"));
			if (ucd.isLoaded())
				out.print("&nbsp;<a target=_blank href='myblog.jsp?blogId=" + ucd.getId() + "'>" + StrUtil.toHtml(ucd.getTitle()) + "</a>");
		}	  
	  }%></td>
  </tr>
  <tr valign="middle">
    <td colspan="4" align=left bgcolor="#FBFBFB">
<%
PluginMgr pm = new PluginMgr();
Vector vplugin = pm.getAllPlugin();
if (vplugin.size()>0) {
	Iterator irplugin = vplugin.iterator();
	while (irplugin.hasNext()) {
		PluginUnit pu = (PluginUnit)irplugin.next();
		if (!pu.getUserInfoPage().equals("")) {
%>
			<jsp:include page="<%=pu.getUserInfoPage()%>" flush="true"/>
<%		}
	}
}%>	
<div>
<%
if (privilege.isMasterLogin(request)) {
%>
<a href="forum/admin/user_modify.jsp?op=deluser&username=<%=StrUtil.UrlEncode(user.getName())%>" target="_blank">
<lt:Label res="res.label.forum.admin.user_m" key="del_user_and_topic"/>
</a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="forum/admin/user_modify.jsp?op=delmsg&username=<%=StrUtil.UrlEncode(username)%>" target="_blank">
<lt:Label res="res.label.forum.admin.user_m" key="del_user_topic"/>
</a>
<%
}
%>
</div>
</td>
  </tr>
</table>