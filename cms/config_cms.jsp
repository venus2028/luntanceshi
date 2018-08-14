<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.kernel.*"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="expires" content="wed, 26 Feb 1997 08:21:57 GMT">
<title><lt:Label res="res.label.cms.config" key="config_mgr"/></title>
<%@ include file="../inc/nocache.jsp" %>
<LINK href="images/default.css" type=text/css rel=stylesheet><script language="JavaScript">
<!--
function validate()
{
	if  (document.addform.name.value=="")
	{
		alert("<lt:Label res="res.label.cms.config" key="type_cannot_null"/>");
		document.addform.name.focus();
		return false ;
	}
}

function checkdel(frm)
{
 if(!confirm("<lt:Label res="res.label.cms.config" key="is_confirm_del"/>"))
	 return;
 frm.op.value="del";
 frm.submit();
}
//-->
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style><body bgcolor="#FFFFFF">
<jsp:useBean id="cfgparser" scope="page" class="cn.js.fan.util.CFGParser"/>
<jsp:useBean id="myconfig" scope="page" class="cn.js.fan.module.cms.Config"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String priv = "admin";
if (!privilege.isUserPrivValid(request,priv)) {
    out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
    <TR>
      <TD class=head><lt:Label res="res.label.cms.config" key="cms_mgr"/></TD>
    </TR>
  </TBODY>
</TABLE>
<br>
<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" class="tableframe" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" >
  <tr> 
    <td width="100%" height="23" class="thead">&nbsp;<lt:Label res="res.label.cms.config" key="cms_cfg_mgr"/></td>
  </tr>
  <tr class=row style="BACKGROUND-COLOR: #fafafa"> 
    <td valign="top" bgcolor="#FFFFFF">
      <br>
      <%
Element root = myconfig.getRootElement();

String op = ParamUtil.get(request, "op");

String name="",value = "";
name = request.getParameter("name");
if (name!=null && !name.equals(""))
{
	value = ParamUtil.get(request, "value");
	myconfig.put(name,value);
	if (name.equals("homeCreateHtmlInterval")) {
		int v = StrUtil.toInt(value, 0);
	    SchedulerManager.getInstance().delJob("homeHtml");
		if (v>0) {
            String cron = "0 0/" + v + " * * * ?";
			SchedulerManager.getInstance().scheduleJob("homeHtml",
                        "cn.js.fan.module.cms.job.HomeCreateHtmJob", cron, "");				
		}
	}
	out.println(fchar.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "config_cms.jsp"));
}

int k = 0;
Iterator ir = root.getChild("cms").getChildren().iterator();
String desc = "";
while (ir.hasNext()) {
  Element e = (Element)ir.next();
  desc = e.getAttributeValue("desc");
  name = e.getName();
  value = e.getValue();
%>
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1">
        <FORM METHOD=POST id="form<%=k%>" name="form<%=k%>" ACTION='config_cms.jsp'>
          <tr> 
            <td bgcolor=#F6F6F6 width='32%'> <INPUT TYPE=hidden name=name value="<%=name%>"> 
              &nbsp;<%=myconfig.getDescription(name)%> 
            <td bgcolor=#F6F6F6 width='29%'>
			<%if (value.equals("true") || value.equals("false")) {%>
				<select name="value"><option value="true"><lt:Label res="res.label.cms.config" key="yes"/></option><option value="false"><lt:Label res="res.label.cms.config" key="no"/></option></select>
				<script>
				form<%=k%>.value.value = "<%=value%>";
				</script>
			<%}	else if (name.equals("site_apply_user_Level")) {%>
				<select name="value">
				<%
				UserLevelDb uld = new UserLevelDb();
				java.util.Vector vlevel = uld.getAllLevel();
				Iterator irlevel = vlevel.iterator();
				int i = 0;
				while (irlevel.hasNext()) {
					i ++;
					uld = (UserLevelDb)irlevel.next();
				%>
					<option value="<%=uld.getLevel()%>"><%=uld.getDesc()%></option>
				<%}%>
				</select>	
				<script>
				form<%=k%>.value.value = "<%=uld.getUserLevelDbByLevel(StrUtil.toInt(value, 0)).getLevel()%>";
				</script>
			 <%} else if (name.indexOf("isRelatePath")>=0) {%>
				<select name="value">
				<option value="2">相对WEB应用根的路径</option>
				<option value="0">绝对路径</option>
				<option value="1">相对路径</option>
				</select>
				<script>
				form<%=k%>.value.value = "<%=value%>";				
				</script>
			<%} else if (name.indexOf("html_ext")>=0) {%>
				<select name="value">
				<option value="htm">htm</option>
				<option value="html">html</option>
				<option value="shtml">shtml</option>
				</select>
				<script>
				form<%=k%>.value.value = "<%=value%>";				
				</script>
			<%} else if (name.indexOf("fckeditorSkin")>=0) {%>
				<select name="value">
				<option value="default">default</option>
				<option value="office2003" selected>office2003</option>
				<option value="silver">silver</option>
				</select>
				<script>
				form<%=k%>.value.value = "<%=value%>";				
				</script><br>
			<%} else if (name.indexOf("homeCountStyle")>=0) {%>
				<select name="value">
				<option value="">无</option>
				<option value="1" selected>1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
				</select>
				<script>
				form<%=k%>.value.value = "<%=value%>";				
				</script>
			<%} else if (name.indexOf("navMultiStyle")>=0) {%>
				<select name="value">
				<option value="0">树形</option>
				<option value="1">平板</option>
				</select>
				<script>
				form<%=k%>.value.value = "<%=value%>";				
				</script>
			<%}	else{%>
				<input type=text value="<%=value%>" name="value" style='border:1pt solid #636563;font-size:9pt' size=30>
            <%}%>
			<td width="39%" align=center bgcolor=#F6F6F6> <INPUT TYPE=submit name='edit' value='<lt:Label res="res.label.cms.config" key="modify"/>'>            </td>
          </tr>
        </FORM>
      </table>
<%
  k++;
}
%>
<br></td>
  </tr>
  <tr class=row style="BACKGROUND-COLOR: #fafafa">
    <td valign="top" bgcolor="#FFFFFF" class="thead">&nbsp;</td>
  </tr>
</table> 
</body>                                        
</html>                            
  