<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="org.jdom.Element"%>
<%@ page import="cn.js.fan.cache.jcs.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="expires" content="wed, 26 Feb 1997 08:21:57 GMT">
<title><lt:Label res="res.label.cms.config" key="config_mgr"/></title>
<%@ include file="../inc/nocache.jsp" %>
<LINK href="default.css" type=text/css rel=stylesheet>
<script>
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
</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
.STYLE1 {color: #FF0000}
-->
</style>
<body bgcolor="#FFFFFF">
<jsp:useBean id="cfgparser" scope="page" class="cn.js.fan.util.CFGParser"/>
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
      <TD class=head><lt:Label res="res.label.cms.config" key="config_mgr"/></TD>
    </TR>
  </TBODY>
</TABLE>
<br>
<table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" class="tableframe" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" >
  <tr> 
    <td width="100%" height="23" class="thead"><lt:Label res="res.label.cms.config" key="config_mgr"/></td>
  </tr>
  <tr class=row style="BACKGROUND-COLOR: #fafafa"> 
    <td valign="top" bgcolor="#FFFFFF">
<%
XMLConfig cfg = new XMLConfig("config_cws.xml", false, "utf-8");
String op = ParamUtil.get(request, "op");
if (op.equals("setup")) {
	Enumeration e = request.getParameterNames();
	while (e.hasMoreElements()) {
		String fieldName = (String)e.nextElement();
		if (fieldName.startsWith("Application") || fieldName.startsWith("i18n")) {
			String value = ParamUtil.get(request, fieldName);
			cfg.set(fieldName, value);
		}
		if (fieldName.equals("locale")) {
			String value = ParamUtil.get(request, fieldName);
			String[] ary = StrUtil.split(value, "_");
			if (ary!=null) {
				cfg.set("i18n.lang", ary[0]);
				cfg.set("i18n.country", ary[1]);
			}
		}
	}
	cfg.writemodify();
	Global.init();
	RMCache.getInstance().setCanCache(Global.useCache);
	out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"info_op_success"), "config_m.jsp"));
	return;
}
%>
<table cellpadding="6" cellspacing="0" border="0" width="100%">
<tr>
<td width="1%" valign="top"></td>
<td width="100%" align="center"><table width="100%" border="0" cellpadding="0" cellspacing="0">
	<form name=form1 action="?op=setup" method=post>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="server"/></td>
        <td align="left"><input name="Application.server" value="<%=Global.server%>"/></td>
      </tr>
      
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="port"/></td>
        <td align="left"><input name="Application.port" value="<%=Global.port%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="app_name"/></td>
        <td align="left">
          <input type="text" name="Application.name" value="<%=Global.AppRealName%>"/>&nbsp;</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="title"/></td>
        <td align="left"><input type="text" name="Application.title" value="<%=Global.title%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="desc"/></td>
        <td align="left"><input type="text" name="Application.desc" value="<%=Global.desc%>"/>
          ( <lt:Label res="res.label.cms.config" key="desc_rss"/> )</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="virtual_path"/></td>
        <td align="left"><input type="text" name="Application.virtualPath" value="<%=Global.virtualPath%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="real_Path"/></td>
        <td align="left"><input type="text" name="Application.realPath" value="<%=Global.getRealPath()%>"/>
        ( <lt:Label res="res.label.cms.config" key="use_character"/> )</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="contact"/></td>
        <td align="left"><input type="text" name="Application.contact" value="<%=StrUtil.toHtml(Global.contact)%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="bak_path"/></td>
        <td align="left"><input type="text" name="Application.bak_path" value="<%=cfg.get("Application.bak_path")%>"/>&nbsp;( 
          <lt:Label res="res.label.cms.config" key="relative_contents"/>
)</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="fileSize"/></td>
        <td align="left"><input type="text" name="Application.FileSize" value="<%=Global.FileSize%>"/> 
          ( <lt:Label res="res.label.cms.config" key="unit"/> ) </td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="WebEdit_maxSize"/></td>
        <td align="left"><input type="text" name="Application.WebEdit.MaxSize" value="<%=cfg.get("Application.WebEdit.MaxSize")%>"/>
          ( <lt:Label res="res.label.cms.config" key="unit_byte_html_attatch_count"/> )</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="max_uploading_file_count"/></td>
        <td align="left"><input type="text" name="Application.WebEdit.maxUploadingFileCount" value="<%=cfg.get("Application.WebEdit.maxUploadingFileCount")%>"/>
          ( <lt:Label res="res.label.cms.config" key="webedit_uploading"/> )</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="App_if_chinese"/></td>
        <td align="left"><select name="Application.isRequestSupportCN">
            <option value="true"><lt:Label res="res.label.cms.config" key="yes"/></option>
            <option value="false" selected="selected"><lt:Label res="res.label.cms.config" key="no"/></option>
          </select>
            <script>
		var supobj = findObj("Application.isRequestSupportCN");
		supobj.value = "<%=Global.requestSupportCN%>";
		    </script>
( <lt:Label res="res.label.cms.config" key="change_App"/> ) </td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="internet_flag"/></td>
        <td align="left"><select name="Application.internetFlag">
            <option value="secure"><lt:Label res="res.label.cms.config" key="yes"/></option>
            <option value="no"><lt:Label res="res.label.cms.config" key="no"/></option>
          </select>
            <script>
		var obj = findObj("Application.internetFlag");
		obj.value = "<%=Global.internetFlag%>";
		</script> 
            ( 是否采用SSL连接方式 )        </td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="smtp_server"/></td>
        <td align="left"><input type="text" name="Application.smtpServer" value="<%=Global.smtpServer%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="smtp_port"/></td>
        <td align="left"><input type="text" name="Application.smtpPort" value="<%=Global.smtpPort%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="smtp_user"/></td>
        <td align="left"><input type="text" name="Application.smtpUser" value="<%=Global.smtpUser%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="smtp_pwd"/></td>
        <td align="left"><input type="password" name="Application.smtpPwd" value="<%=Global.smtpPwd%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="email"/></td>
        <td align="left"><input type="text" name="Application.email" value="<%=Global.email%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="icp"/></td>
        <td align="left"><input type="text" name="Application.icp" value="<%=Global.icp%>"/></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="timeZone"/></td>
        <td align="left"><select name="i18n.timeZone">
          <option value="GMT-11:00">(GMT-11.00)<lt:Label res="res.label.cms.config" key="GMT-11.00"/></option>
          <option value="GMT-10:00">(GMT-10.00)<lt:Label res="res.label.cms.config" key="GMT-10.00"/></option>
          <option value="GMT-09:00">(GMT-9.00)<lt:Label res="res.label.cms.config" key="GMT-9.00"/></option>
          <option value="GMT-08:00">(GMT-8.00)<lt:Label res="res.label.cms.config" key="GMT-8.00"/></option>
          <option value="GMT-07:00">(GMT-7.00)<lt:Label res="res.label.cms.config" key="GMT-7.00"/></option>
          <option value="GMT-06:00">(GMT-6.00)<lt:Label res="res.label.cms.config" key="GMT-6.00"/></option>
          <option value="GMT-05:00">(GMT-5.00)<lt:Label res="res.label.cms.config" key="GMT-5.00"/></option>
          <option value="GMT-04:00">(GMT-4.00)<lt:Label res="res.label.cms.config" key="GMT-4.00"/></option>
          <option value="GMT-03:00">(GMT-3.00)<lt:Label res="res.label.cms.config" key="GMT-3.00"/></option>
          <option value="GMT-02:00">(GMT-2.00)<lt:Label res="res.label.cms.config" key="GMT-2.00"/></option>
          <option value="GMT-01:00">(GMT-1.00)<lt:Label res="res.label.cms.config" key="GMT-1.00"/></option>
          <option value="GMT">(GMT)<lt:Label res="res.label.cms.config" key="GMT"/></option>
          <option value="GMT+01:00">(GMT+1.00)<lt:Label res="res.label.cms.config" key="GMT+1.00"/></option>
          <option value="GMT+02:00">(GMT+2.00)<lt:Label res="res.label.cms.config" key="GMT+2.00"/></option>
          <option value="GMT+03:00">(GMT+3.00)<lt:Label res="res.label.cms.config" key="GMT+3.00"/></option>
          <option value="GMT+04:00">(GMT+4.00)<lt:Label res="res.label.cms.config" key="GMT+4.00"/></option>
          <option value="GMT+04:30">(GMT+4.30)<lt:Label res="res.label.cms.config" key="GMT+4.30"/></option>
          <option value="GMT+05:00">(GMT+5.00)<lt:Label res="res.label.cms.config" key="GMT+5.00"/></option>
          <option value="GMT+05:30">(GMT+5.30)<lt:Label res="res.label.cms.config" key="GMT+5.30"/></option>
          <option value="GMT+05:45">(GMT+5.45)<lt:Label res="res.label.cms.config" key="GMT+5.45"/></option>
		  <option value="GMT+06:00">(GMT+6.00)<lt:Label res="res.label.cms.config" key="GMT+6.00"/></option>
		  <option value="GMT+06:30">(GMT+6.30)<lt:Label res="res.label.cms.config" key="GMT+6.30"/></option>		  
          <option value="GMT+07:00">(GMT+7.00)<lt:Label res="res.label.cms.config" key="GMT+7.00"/></option>
          <option value="GMT+08:00" selected="selected">(GMT+8.00)<lt:Label res="res.label.cms.config" key="GMT+8.00"/></option>
          <option value="GMT+09:00">(GMT+9.00)<lt:Label res="res.label.cms.config" key="GMT+9.00"/></option>
          <option value="GMT+09:30">(GMT+9.30)<lt:Label res="res.label.cms.config" key="GMT+9.30"/></option>
          <option value="GMT+10:00">(GMT+10.00)<lt:Label res="res.label.cms.config" key="GMT+10.00"/></option>
          <option value="GMT+11:00">(GMT+11.00)<lt:Label res="res.label.cms.config" key="GMT+11.00"/></option>
          <option value="GMT+12:00">(GMT+12.00)<lt:Label res="res.label.cms.config" key="GMT+12.00"/></option>
          <option value="GMT+13:00">(GMT+13.00)<lt:Label res="res.label.cms.config" key="GMT+13.00"/></option>
        </select>
          <script>
			findObj("i18n.timeZone").value = "<%=Global.timeZone.getID()%>";
		</script>		</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="default_lang"/></td>
        <td align="left"><select name=locale size=1>
          <%
            XMLConfig xc = new XMLConfig("config_i18n.xml", false, "utf-8");
            Element root = xc.getRootElement();
            Element child = root.getChild("support");
            List list = child.getChildren();
            if (list != null) {
                Iterator ir = list.iterator();
                while (ir.hasNext()) {
                    Element e = (Element) ir.next();
					String loc = e.getChildText("lang") + "_" + e.getChildText("country");
                    out.print("<option value=" + loc + ">" + SkinUtil.LoadString(request, "res.config.config_i18n", loc) + "</option>");
                }
            }
%>
        </select>
		<script>
		form1.locale.value = "<%=Global.locale.toString().toLowerCase()%>";
		</script>		</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="lang_specified"/></td>
        <td align="left"><select name="i18n.isSpecified">
          <option value="true">
            <lt:Label res="res.label.cms.config" key="yes"/>
            </option>
          <option value="false" selected="selected">
            <lt:Label res="res.label.cms.config" key="no"/>
            </option>
        </select>
        <script>
			findObj("i18n.isSpecified").value = "<%=Global.localeSpecified?"true":"false"%>";
		</script>		</td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="useCache"/></td>
        <td align="left"><select name="Application.useCache">
          <option value="true">
          <lt:Label res="res.label.cms.config" key="yes"/>
          </option>
          <option value="false" selected="selected">
          <lt:Label res="res.label.cms.config" key="no"/>
          </option>
        </select>
		<script>
			findObj("Application.useCache").value = "<%=Global.useCache?"true":"false"%>";
		</script></td>
      </tr>
      <tr>
        <td height="24" align="right"><lt:Label res="res.label.cms.config" key="isSubDomainSupported"/></td>
        <td align="left"><select name="Application.isSubDomainSupported">
          <option value="true">
          <lt:Label res="res.label.cms.config" key="yes"/>
          </option>
          <option value="false" selected="selected">
          <lt:Label res="res.label.cms.config" key="no"/>
          </option>
        </select>
		<script>
			findObj("Application.isSubDomainSupported").value = "<%=Global.isSubDomainSupported?"true":"false"%>";
		</script></td>
		</tr>
		<tr>
		<td height="24" align="right"><lt:Label res="res.label.cms.config" key="isTransactionSupported"/></td>
        <td align="left"><select name="Application.isTransactionSupported">
          <option value="true">
          <lt:Label res="res.label.cms.config" key="yes"/>
          </option>
          <option value="false" selected="selected">
          <lt:Label res="res.label.cms.config" key="no"/>
          </option>
        </select>
		<script>
			findObj("Application.isTransactionSupported").value = "<%=Global.isTransactionSupported?"true":"false"%>";
		</script></td>		
      </tr>
		<tr>
          <td height="24" align="right">GZIP Enabled： </td>
		  <td align="left"><select name="Application.isGZIPEnabled">
              <option value="true">
              <lt:Label res="res.label.cms.config" key="yes"/>
              </option>
              <option value="false" selected="selected">
              <lt:Label res="res.label.cms.config" key="no"/>
              </option>
            </select>
              <script>
			findObj("Application.isGZIPEnabled").value = "<%=Global.isGZIPEnabled?"true":"false"%>";
		  </script></td>
		  </tr>
		<tr>
		  <td height="24" align="right">&nbsp;</td>
		  <td align="left">&nbsp;</td>
		  </tr>
	  </form>
    </table>
    <input type="button" onClick="form1.submit()" value="<%=SkinUtil.LoadString(request, "res.label.cms.config","confirm")%>"></td></tr>
</table>    </td>
  </tr>
  <tr class=row style="BACKGROUND-COLOR: #fafafa">
    <td valign="top" bgcolor="#FFFFFF" class="thead">&nbsp;</td>
  </tr>
</table> 
</body>                                        
</html>                            
  