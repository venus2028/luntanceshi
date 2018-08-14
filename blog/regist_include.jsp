<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.security.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.Element"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
PassportConfig pc = PassportConfig.getInstance();
if (pc.getBooleanProperty("passport.isUsed")) {
	response.sendRedirect(pc.getProperty("passport.regUrl"));
	return;
}

com.redmoon.forum.RegConfig rcfg = new com.redmoon.forum.RegConfig();
boolean permitRegUser = true,regAdvance = false,regCompact = false;
int IPRegCtrl = 0;
permitRegUser = rcfg.getBooleanProperty("permitRegUser");
regAdvance = rcfg.getBooleanProperty("regAdvance");
regCompact = rcfg.getBooleanProperty("regCompact");
IPRegCtrl = rcfg.getIntProperty("IPRegCtrl");
	
if(!permitRegUser){
	response.sendRedirect("info.jsp?info=" + StrUtil.UrlEncode(SkinUtil.LoadString(request, "res.label.forum.user","nopermitreguser")));
	return;
}
	
if(regCompact){
	String ruleSubmit = ParamUtil.get(request,"ruleSubmit");
	if(!ruleSubmit.equals("true")){
		response.sendRedirect("regist_contract.jsp");
		return;
	}
}
	
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();

//seo
com.redmoon.forum.util.SeoConfig scfg = new com.redmoon.forum.util.SeoConfig();
String seoTitle = scfg.getProperty("seotitle");
String seoKeywords = scfg.getProperty("seokeywords");
String seoDescription = scfg.getProperty("seodescription");
String seoHead = scfg.getProperty("seohead");
%>
<html>
<head>
<title><lt:Label res="res.label.regist" key="regist"/> - <%=Global.AppName%> <%=seoTitle%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%=seoHead%>
<META name="keywords" content="<%=seoKeywords%>">
<META name="description" content="<%=seoDescription%>">
<script src="../inc/common.js"></script>
<script>
function New(para_URL){var URL=new String(para_URL);window.open(URL,'','resizable,scrollbars')}

function findObj(theObj, theDoc)
{
  var p, i, foundObj;
  
  if(!theDoc) theDoc = document;
  if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
  {
    theDoc = parent.frames[theObj.substring(p+1)].document;
    theObj = theObj.substring(0,p);
  }
  if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
  for (i=0; !foundObj && i < theDoc.forms.length; i++) 
    foundObj = theDoc.forms[i][theObj];
  for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++) 
    foundObj = findObj(theObj,theDoc.layers[i].document);
  if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
  
  return foundObj;
}

//-------------check code begin--------------------
function initCheckFrame() {
	var checkFrame = window.frames["checkFrame"];
	checkFrame.document.open();
	checkFrame.document.write("<form name=\"form_param\" method=\"post\">");
	checkFrame.document.write("</form>");
	checkFrame.document.close();
	checkFrame.document.title="Check Param";
	checkFrame.document.charset="UTF-8";
}

function initCheck(formAction) {
	initCheckFrame();
	var checkFrame = window.frames["checkFrame"];
	checkFrame.document.form_param.action = formAction;
	checkFrame.document.form_param.innerHTML = "";
}

function addCheckParam(paramName, paramValue) {
	var inputTxt = "<input name='" + paramName + "' value='" + paramValue + "'>";
	var checkFrame = window.frames["checkFrame"];
	checkFrame.document.form_param.innerHTML += inputTxt;
}

function doCheck() {
	var checkFrame = window.frames["checkFrame"];
	checkFrame.document.form_param.submit();
}

function showCheckResult(spanName, result) {
	var spanObj = findObj(spanName);
	if (spanObj!=null)
		spanObj.innerHTML = result;
}
//-------------check code end--------------------
function CheckRegName(){
	var Name = document.frmAnnounce.RegName.value;
	initCheck("../regist_check.jsp");
	addCheckParam("RegName", Name);
	addCheckParam("op", "chkRegName");
	doCheck();
}

function CheckEmail() {
	var email = document.frmAnnounce.Email.value;
	initCheck("../regist_check.jsp");
	addCheckParam("Email", email);
	addCheckParam("op", "chkEmail");
	doCheck();
}
</script>
<script src="../forum/inc/ubbcode.jsp"></script>
</head>
<body>
<%
    IPMonitor ipmr = new IPMonitor();
	long end = System.currentTimeMillis();
	long begin = 0;
	UserDb ud = new UserDb();
	ud = ud.getUserDbByIP(request.getRemoteAddr());
	if(ipmr.isIPOfRegistSpecialScope(request.getRemoteAddr())){
        if(ud != null){
			begin = ud.getRegDate().getTime();
			if(end - begin < 24 * 60 * 60000)	{
				response.sendRedirect("info.jsp?info=" + StrUtil.UrlEncode(SkinUtil.LoadString(request, "res.label.forum.user", "specialipregctrl")));
				return;
			}
		}
	}
	// IP注册间隔限制(小时)
	if(ud != null && IPRegCtrl != 0){
		begin = ud.getRegDate().getTime();
		if(end - begin < IPRegCtrl * 60 * 60000)	{
			response.sendRedirect("info.jsp?info=" + StrUtil.UrlEncode(SkinUtil.LoadString(request, "res.label.forum.user", "specialipregctrl")));
			return;
		}
	}	
	
%>
 <Form method="POST" action="regist_do.jsp"  name="frmAnnounce" onSubmit="return VerifyInput()"><table width=100% border=0 cellpadding=0 cellspacing=1 bgcolor="#CCCCCC">
                <tr>
                  <td height="28" colspan="2" align=left bgcolor="#FFFFFF"><table border=0 cellpadding=0 cellspacing=0 width=100%>
                    <tr>
                      <td width=31 height=20 background="forum/<%=skinPath%>/images/bg1.gif">&nbsp;</td>
                      <td width=131 background="forum/<%=skinPath%>/images/bg1.gif" class="td_title"><b>　
                        <lt:Label res="res.label.regist" key="nick_pwd"/>
                      </b></td>
                      <td height="26" background="forum/<%=skinPath%>/images/bg1.gif" class="td_title"><lt:Label res="res.label.regist" key="notice"/>
                        &nbsp;&nbsp;&nbsp;&nbsp;
                        <%
		RegConfig rc = new RegConfig();
        int regVerify = rc.getIntProperty("regVerify");
        if (regVerify==rc.REGIST_VERIFY_EMAIL)
			out.print(SkinUtil.LoadString(request, "res.forum.Privilege", "info_need_check_email"));
        else
			out.print(SkinUtil.LoadString(request, "res.forum.Privilege", "info_need_check_manual"));
%>                      </td>
                    </tr>
                  </table></td>
                </tr>
                <tr>
                  <td width="162" height="28" align=left bgcolor="#FFFFFF">&nbsp;
                  <lt:Label res="res.label.forum.user" key="RegName"/></td> 
                  <td width="566" align=left bgcolor="#FFFFFF">
                      &nbsp;
                      <input name=RegName type=text size=20 maxlength="50" onBlur="CheckRegName()">
                  <font color="#FF0000"> * </font><font color="red"><span id="span_RegName"></span></font>                  </td>
                </tr>
                <tr>
                  <td height="28" align=left bgcolor="#FFFFFF">&nbsp;<lt:Label res="res.label.forum.user" key="Password"/></td> 
                  <td align=left valign="top" bgcolor="#FFFFFF"><img src=/images/c.gif width=1 height=5><br>
                      &nbsp; 
                      <input name=Password type=password size=20>
                      <font color="#FF0000">*</font>
                      <lt:Label res="res.label.forum.user" key="Password2"/>
                      <input name=Password2 type=password size=20>
                  <font color="#FF0000"> *</font></td>
                </tr>
              <tr>
                <td height="28" align=left bgcolor="#FFFFFF">&nbsp;<lt:Label res="res.label.forum.user" key="Gender"/></td>
                  <td height="25" align=left valign="middle" bgcolor="#FFFFFF">&nbsp;
                    <input type=radio name=Gender value=M checked onClick="frmAnnounce.RealPic.value='face.gif';showimage()">
                    <lt:Label res="res.label.forum.user" key="man"/>
                    <input type=radio name=Gender value=F onClick="frmAnnounce.RealPic.value='face0.gif';showimage()">
                    <lt:Label res="res.label.forum.user" key="woman"/>                    &nbsp;</td>
                </tr>           <tr>
                  <td height="28" align=left bgcolor="#FFFFFF">&nbsp;Email</td>
                  <td height="25" align=left valign="middle" bgcolor="#FFFFFF">&nbsp;
                    <input name=Email type=text size=20 maxlength="50" onBlur="CheckEmail()">
                  <font color="#FF0000">*&nbsp;<span id="span_email"></span></font></td>
                </tr>
<%
com.redmoon.forum.RegConfig cfg1 = new com.redmoon.forum.RegConfig();
if (cfg1.getBooleanProperty("registUseValidateCode")) {
	int charNum = cfg1.getIntProperty("registUseValidateCodeLen");
%>				
				<tr>
                  <td height="28" align=left bgcolor="#FFFFFF">&nbsp;<lt:Label res="res.label.forum.user" key="validate_code"/></td>
                  <td height="25" align=left valign="middle" bgcolor="#FFFFFF">&nbsp;
                    <input name="validateCode" size="6">
					<!--xxx 目的是为了兼容刷新firefox-->
                  <a href="#" onClick="$('imgValidateCode').src='<%=request.getContextPath()%>/validatecode.jsp?charNum=<%=charNum%>' + '&xxx=' + new Date().getTime();"><img alt="<lt:Label res="res.label.forum.user" key="click_to_refresh"/>" id="imgValidateCode" src='<%=request.getContextPath()%>/validatecode.jsp?charNum=<%=charNum%>' border=0 align="absmiddle"></a>
                  <lt:Label res="res.label.forum.user" key="click_to_refresh"/></td>
                </tr>
<%}%>                <tr>
                  <td height="28" align=left bgcolor="#FFFFFF">&nbsp;<lt:Label res="res.label.forum.user" key="Question"/></td> 
                  <td height="25" align=left valign="middle" bgcolor="#FFFFFF">&nbsp; 
                    <input name=Question type=text size=20 maxlength=50>
                    <lt:Label res="res.label.forum.user" key="Answer"/>
                      <input name=Answer type=text size=20 maxlength=50>
					  <input name="RealPic" value="face.gif" type="hidden">
					  </td>
                </tr>

<tr>
  <td height="28" align=left bgcolor="#FFFFFF">&nbsp;
    <lt:Label res="res.label.forum.user" key="timeZone"/></td>
  <td height="25" align=left valign="middle" bgcolor="#FFFFFF">&nbsp;
    <select name="timeZone">
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
  </select></td>
</tr>
<tr>
  <td height="28" colspan="2" align=center bgcolor="#FFFFFF"><input name=Write type=submit value="<lt:Label key="ok"/>">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input name=reset type=reset value="<lt:Label key="reset"/>"></td>
  </tr>
              </table>
</form>
<iframe width=0 height=0 src="../regist_check.jsp" name="checkFrame" id="checkFrame"></iframe>
</body>
<SCRIPT>
function VerifyInput()
{
var newDateObj = new Date()
if (document.frmAnnounce.RegName.value == "")
{
alert("<lt:Label res="res.label.forum.user" key="need_regname"/>");
document.frmAnnounce.RegName.focus();
return false;
}

if (document.frmAnnounce.Password.value == "")
{
alert("<lt:Label res="res.label.forum.user" key="need_pwd"/>");
document.frmAnnounce.Password.focus();
return false;
}
if (document.frmAnnounce.Password2.value == "")
{
alert("<lt:Label res="res.label.forum.user" key="need_pwd2"/>");
document.frmAnnounce.Password2.focus();
return false;
}
if (document.frmAnnounce.Password.value != document.frmAnnounce.Password2.value)
{
alert("<lt:Label res="res.label.forum.user" key="pwd_not_equal_pwd2"/>");
document.frmAnnounce.Password.focus();
return false;
}

if (document.frmAnnounce.Email.value == "")
{
alert("<lt:Label res="res.label.forum.user" key="need_email"/>");
document.frmAnnounce.Email.focus();
return false;
}

return true;
}
</SCRIPT>
</html>