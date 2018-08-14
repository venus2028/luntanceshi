<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="org.jdom.Element"%>
<%@ page import ="com.redmoon.forum.*"%>
<%@ page import ="com.redmoon.forum.ui.*"%>
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
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><lt:Label res="res.label.myinfo" key="myinfo"/> - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<script>
function New(para_URL){var URL=new String(para_URL);window.open(URL,'','resizable,scrollbars')}
function CheckRegName(){
	var Name=document.frmAnnounce.RegName.value;
	window.open("checkregname.jsp?RegName="+Name,"","width=200,height=20");
}

function check_checkbox(myitem,myvalue)
{
     var checkboxs = document.all.item(myitem);
     if (checkboxs!=null)
     {
       for (i=0; i<checkboxs.length; i++)
          {
            if (checkboxs[i].type=="checkbox" && checkboxs[i].value==myvalue)
              {
                 checkboxs[i].checked = true
              }
          }
     }
}
</script>
<script src="forum/inc/ubbcode.jsp"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="userservice" scope="page" class="com.redmoon.forum.person.userservice" />
<%
if (!privilege.isUserLogin(request)) {
	response.sendRedirect("../door.jsp?privurl=" + StrUtil.getUrl(request));
	return;
}
com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">我的信息</td>
  </tr>
</table>
<div id="newdiv" name="newdiv">
<%
String privurl = request.getRequestURL()+"?"+request.getQueryString();

String RegName="",Question="",Answer="";
String RealName="",Career="";
String Gender="",Job="";
int BirthYear = 0;
int BirthMonth = 0;
int BirthDay = 0;
Date Birthday = null;
String Phone="",Mobile="";
int Marriage = 0;
String State="",City="",Address="";
String PostCode="",IDCard="",RealPic="",sign="";
String Email="",OICQ="";
String Hobbies="",myface="";

String name = "";
if (privilege.isMasterLogin(request)) {
	name = ParamUtil.get(request, "userName");
}
if (name.equals("")) {
	name = privilege.getUser(request);
}

UserDb user = new UserDb();
user = user.getUser(name);

RegName = user.getNick();
Question = user.getQuestion();
Answer = user.getAnswer();
RealName = user.getRealName();
Career = user.getCareer();
Gender = user.getGender();
Job = user.getJob();
Birthday = user.getBirthday();
if (Birthday!=null) {
	Calendar cld = Calendar.getInstance();
	cld.setTime(Birthday);
	BirthYear = cld.get(Calendar.YEAR);
	BirthMonth = cld.get(Calendar.MONTH)+1;
	BirthDay = cld.get(Calendar.DAY_OF_MONTH);
	
	//BirthYear = Birthday.getYear()+1900;
	//BirthMonth = Birthday.getMonth()+1;
	//BirthDay = Birthday.getDate();
}
Marriage = user.getMarriage();
Phone = user.getPhone();
Mobile = user.getMobile();
State = user.getState();
City = user.getCity();
Address = user.getAddress();
PostCode = user.getPostCode();
IDCard = user.getIDCard();
RealPic = user.getRealPic();
Hobbies = user.getHobbies();
Email = user.getEmail();
OICQ = user.getOicq();
sign = user.getSign();
myface = user.getMyface();
%>
<br>
<table width=98% border=0 align=center cellpadding=0 cellspacing=0 bgcolor="#CCCCCC" >
 <form method="POST" action="myinfo_do.jsp"  name="frmAnnounce" onSubmit="return VerifyInput()">
 <tr>
      <td><table width=100% border=0 cellpadding=3 cellspacing=1>
          <tr>
            <td class="thead" colspan="4" align=center>
<lt:Label res="res.label.regist" key="nick_pwd"/>			
			</td>
          </tr>
          <tr bgcolor="#CCCCCC">
            <td width="16%" height="28" align="left" bgcolor="#FFFFFF" >&nbsp;
              <lt:Label res="res.label.forum.user" key="RegName"/></td>
            <td width="84%" height="28" colspan="3" align="left" valign="middle" bgcolor="#FFFFFF"><%if (user.isCanRename()) {%>
              <input name="nick" value="<%=StrUtil.toHtml(RegName)%>">
              <%}else{%>
			<%=RegName%>
			<input name="nick" value="<%=StrUtil.toHtml(RegName)%>" type="hidden">
			<%}%>
            <input type="hidden" name="RegName" size="20" value="<%=name%>" /></td>
          </tr>
          <tr bgcolor="#CCCCCC">
            <td height="28" align="left" bgcolor="#FFFFFF">&nbsp;
              <lt:Label res="res.label.forum.user" key="Password"/></td>
            <td height="28" colspan="3" align="left" bgcolor="#FFFFFF"><input name="Password" type="password"  size="20" maxlength="20" />
                <font color="#FF0000">*</font>
                <lt:Label res="res.label.forum.user" key="Password2"/>
                &nbsp;
              <input name="Password2" type="password"  size="20" maxlength="20" />
                <font color="#FF0000"> *&nbsp;</font><font color=red><lt:Label res="res.label.myinfo" key="not_fill_not_change_pwd"/></font></td>
          </tr>
          <tr bgcolor="#CCCCCC">
            <td height="28" align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;
            <lt:Label res="res.label.forum.user" key="Gender"/></td>
            <td height="28" colspan="3" align="left" valign="middle" bgcolor="#FFFFFF"><input type=radio name=Gender value=M <%=Gender.equals("M")?"checked":""%>>
              <lt:Label res="res.label.forum.user" key="man"/>
              <input type=radio name=Gender value=F <%=Gender.equals("F")?"checked":""%>>
              <lt:Label res="res.label.forum.user" key="woman"/></td>
          </tr>
          <tr bgcolor="#CCCCCC">
            <td height="28" align="left" valign="middle" bgcolor="#FFFFFF">&nbsp;&nbsp;Email</td>
            <td height="28" colspan="3" align="left" valign="middle" bgcolor="#FFFFFF"><input name="Email" type="text"  value="<%=Email%>" size="20" maxlength="50" />
                <font color="#FF0000">*</font> </td>
          </tr> 
          <tr bgcolor="#CCCCCC">
            <td height="28" align="left" bgcolor="#FFFFFF" >&nbsp;
            <lt:Label res="res.label.forum.user" key="Question"/></td>
            <td height="28" colspan="3" align="left" bgcolor="#FFFFFF" ><input name="Question" type="text"  value="<%=Question%>" size="20" maxlength="50" />
              <lt:Label res="res.label.forum.user" key="Answer"/>                &nbsp;&nbsp;
                <input name="Answer" type="text"  value="<%=Answer%>" size="20" maxlength="50" />
            <%
			UserPropDb upd = new UserPropDb();
			upd = upd.getUserPropDb(user.getName());				
			%>
                <input name="is_music_autostart" type="hidden" value="<%=upd.getInt("is_music_autostart")%>">
			</td>
          </tr>
<%
if (cfg.getBooleanProperty("forum.isFactionUsed")) {
%>		  
          
          <tr bgcolor="#CCCCCC">
            <td align=left height="29"  bgcolor="#FFFFFF">&nbsp;
<lt:Label res="res.label.forum.user" key="timeZone"/></td>
            <td height="29" colspan="3" valign="middle" bgcolor="#FFFFFF"><select name="timeZone">
                <option value="GMT-11:00">(GMT-11.00)
                  <lt:Label res="res.label.cms.config" key="GMT-11.00"/>
                </option>
                <option value="GMT-10:00">(GMT-10.00)
                  <lt:Label res="res.label.cms.config" key="GMT-10.00"/>
                </option>
                <option value="GMT-09:00">(GMT-9.00)
                  <lt:Label res="res.label.cms.config" key="GMT-9.00"/>
                </option>
                <option value="GMT-08:00">(GMT-8.00)
                  <lt:Label res="res.label.cms.config" key="GMT-8.00"/>
                </option>
                <option value="GMT-07:00">(GMT-7.00)
                  <lt:Label res="res.label.cms.config" key="GMT-7.00"/>
                </option>
                <option value="GMT-06:00">(GMT-6.00)
                  <lt:Label res="res.label.cms.config" key="GMT-6.00"/>
                </option>
                <option value="GMT-05:00">(GMT-5.00)
                  <lt:Label res="res.label.cms.config" key="GMT-5.00"/>
                </option>
                <option value="GMT-04:00">(GMT-4.00)
                  <lt:Label res="res.label.cms.config" key="GMT-4.00"/>
                </option>
                <option value="GMT-03:00">(GMT-3.00)
                  <lt:Label res="res.label.cms.config" key="GMT-3.00"/>
                </option>
                <option value="GMT-02:00">(GMT-2.00)
                  <lt:Label res="res.label.cms.config" key="GMT-2.00"/>
                </option>
                <option value="GMT-01:00">(GMT-1.00)
                  <lt:Label res="res.label.cms.config" key="GMT-1.00"/>
                </option>
                <option value="GMT">(GMT)
                  <lt:Label res="res.label.cms.config" key="GMT"/>
                </option>
                <option value="GMT+01:00">(GMT+1.00)
                  <lt:Label res="res.label.cms.config" key="GMT+1.00"/>
                </option>
                <option value="GMT+02:00">(GMT+2.00)
                  <lt:Label res="res.label.cms.config" key="GMT+2.00"/>
                </option>
                <option value="GMT+03:00">(GMT+3.00)
                  <lt:Label res="res.label.cms.config" key="GMT+3.00"/>
                </option>
                <option value="GMT+04:00">(GMT+4.00)
                  <lt:Label res="res.label.cms.config" key="GMT+4.00"/>
                </option>
                <option value="GMT+04:30">(GMT+4.30)
                  <lt:Label res="res.label.cms.config" key="GMT+4.30"/>
                </option>
                <option value="GMT+05:00">(GMT+5.00)
                  <lt:Label res="res.label.cms.config" key="GMT+5.00"/>
                </option>
                <option value="GMT+05:30">(GMT+5.30)
                  <lt:Label res="res.label.cms.config" key="GMT+5.30"/>
                </option>
                <option value="GMT+05:45">(GMT+5.45)
                  <lt:Label res="res.label.cms.config" key="GMT+5.45"/>
                </option>
                <option value="GMT+06:00">(GMT+6.00)
                  <lt:Label res="res.label.cms.config" key="GMT+6.00"/>
                </option>
                <option value="GMT+06:30">(GMT+6.30)
                  <lt:Label res="res.label.cms.config" key="GMT+6.30"/>
                </option>
                <option value="GMT+07:00">(GMT+7.00)
                  <lt:Label res="res.label.cms.config" key="GMT+7.00"/>
                </option>
                <option value="GMT+08:00" selected="selected">(GMT+8.00)
                  <lt:Label res="res.label.cms.config" key="GMT+8.00"/>
                </option>
                <option value="GMT+09:00">(GMT+9.00)
                  <lt:Label res="res.label.cms.config" key="GMT+9.00"/>
                </option>
                <option value="GMT+09:30">(GMT+9.30)
                  <lt:Label res="res.label.cms.config" key="GMT+9.30"/>
                </option>
                <option value="GMT+10:00">(GMT+10.00)
                  <lt:Label res="res.label.cms.config" key="GMT+10.00"/>
                </option>
                <option value="GMT+11:00">(GMT+11.00)
                  <lt:Label res="res.label.cms.config" key="GMT+11.00"/>
                </option>
                <option value="GMT+12:00">(GMT+12.00)
                  <lt:Label res="res.label.cms.config" key="GMT+12.00"/>
                </option>
                <option value="GMT+13:00">(GMT+13.00)
                  <lt:Label res="res.label.cms.config" key="GMT+13.00"/>
                </option>
              </select>
                <script>
				frmAnnounce.timeZone.value = "<%=user.getTimeZone().getID()%>";
				</script>
                <input name=RealName type=hidden value="<%=RealName%>" size=12 maxlength=20>
                <input name="Career" value="<%=Career%>" type="hidden">
                <span class="l15">
                <input name=Mobile value="<%=Mobile%>" size=16 maxlength="16" type="hidden">
                </span>
                <input name=Job value="<%=Job%>" size=16 maxlength="16" type="hidden">
                <input name=BirthYear type="hidden" value="<%=BirthYear%>" size=5>
                <input name=BirthMonth type=hidden value="<%=BirthMonth%>" size=2>
                <input name=BirthDay type=hidden value="<%=BirthDay%>" size=2>
                <input name="Marriage" value="<%=Marriage%>" type="hidden">
                <input name=Phone type=hidden value="<%=Phone%>" size=16 maxlength="20">
                <input name=OICQ type=hidden value="<%=OICQ%>" size=16 maxlength="15">
                <input name=State size=10 maxlength="30" value="<%=State%>" type="hidden">
                <input name=City type=hidden value="<%=City%>" size=10>
                <input name=Address type=hidden value="<%=Address%>" size=30 maxlength="100">
                <input name=PostCode type=hidden value="<%=PostCode%>" size=10 maxlength="30">
                <input name=IDCard type=hidden value="<%=IDCard%>" size=21>
                <input name=Hobbies type=hidden value="<%=Hobbies%>" size=30 maxlength="50">
                <span class="text_title">
                <%
				  String checked = "";
				  if (user.isSecret()) {
				  	checked = "checked";
				  }
				  %>
                </span>
                <input name="isSecret" value="true" <%=checked%> type="hidden">            <input name=home type=hidden value="<%=user.getHome()%>" size=30 maxlength="50">
                <input name=msn type=hidden value="<%=user.getMsn()%>" size=30 maxlength="50">
                <input name=fetion type=hidden value="<%=user.getFetion()%>" size=30 maxlength="50">
                <input name="locale" value="<%=user.getLocale()%>" type="hidden">
            <input name="Content" type="hidden" value="<%=sign%>">
            <input name="faction" value="<%=upd.getString("faction")%>" type="hidden"></td>
          </tr>
          
<%}%>		  
          
          
          <tr bgcolor="#CCCCCC">
            <td colspan="4" align=left bgcolor="#FFFFFF"><table width="98%"  border="0">
                <tr>
                  <td align="left"><font color="#FF0000"><b><font color="#000000"></font></b> <img src="../../forum/images/face/<%=RealPic%>" name="tus">&nbsp;
                    <script>function showimage(){document.images.tus.src="<%=Global.getRootPath()%>/forum/images/face/"+document.frmAnnounce.RealPic.options[document.frmAnnounce.RealPic.selectedIndex].value;}</script>
  <%
 String path = Global.getRootPath() + "/forum/images/face/";
 FileViewer fileViewer = new FileViewer(cn.js.fan.web.Global.realPath + "/forum/images/face/");
 fileViewer.init();
 int i = 1;
%>
                    <select name=RealPic size=1 onChange="showimage()">
                      <option value="face.gif"><lt:Label res="res.label.forum.user" key="default_icon"/></option>
                      <% while(fileViewer.nextFile()){
							  if (fileViewer.getFileName().lastIndexOf("gif") != -1 || fileViewer.getFileName().lastIndexOf("jpg") != -1 || fileViewer.getFileName().lastIndexOf("png") != -1 || fileViewer.getFileName().lastIndexOf("bmp") != -1 && fileViewer.getFileName().indexOf("face") != -1) {
							   String fileName = fileViewer.getFileName();
							%>
                      <option value="<%=fileName%>"><%=i++%></option>
                      <% }
							} %>
                    </select>                    <a href="JavaScript:New('../../images/index.jsp')"><lt:Label res="res.label.forum.user" key="view_all_icon"/></a>					</font>
                  <script language="JavaScript">
						  <!--
						  frmAnnounce.RealPic.value = "<%=RealPic%>"
						  //-->
						  </script>					</td>
                  <td width="31%" rowspan="2" valign="top"><font color="#FF0000">
                    <%if (!myface.equals("")) {%>
                    <img src="<%=user.getMyfaceUrl(request)%>">
                    <%}%>
                  </font></td>
                </tr>
                <tr>
                  <td><iframe src="../../addmyface.jsp" width=100% height="95" frameborder="0" scrolling="no"></iframe>                  </td>
                </tr>
              </table></td>
          </tr>
          
          <tr> 
            <td colspan="4" bgcolor="#FFFFFF"> <table border=0 cellpadding=0 cellspacing=0 width=100%>
                <tr valign=bottom> 
                  <td height=41 align="center" valign="middle"> <font color="#FF0000">&nbsp; </font><br>
                    <input name=Write type=submit  value="<lt:Label key="ok"/>">
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <input name=reset type=reset  value="<lt:Label key="reset"/>">
                  <br></td>
                </tr>
              </table></td>
          </tr>
      </table></td>
</tr></form></table>
</body>
<SCRIPT>
function VerifyInput() {
	return true;
}
</SCRIPT>
</html>