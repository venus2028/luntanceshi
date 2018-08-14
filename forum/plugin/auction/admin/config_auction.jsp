<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import=" com.redmoon.forum.plugin.auction.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="expires" content="wed, 26 Feb 1997 08:21:57 GMT">
<title>拍卖</title>
<%@ include file="../../../inc/nocache.jsp" %>
<LINK href="images/default.css" type=text/css rel=stylesheet>
<link rel="stylesheet" href="../../../admin/default.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style><body  bgcolor="#FFFFFF">
<jsp:useBean id="cfgparser" scope="page" class="cn.js.fan.util.CFGParser"/>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String priv = "admin";
if (!privilege.isUserPrivValid(request,priv)) {
    out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

AuctionConfig ac = new AuctionConfig();
int max = ac.getIntProperty(ac.ExpireDayMax);
String from = ac.getEmailAlias();
String email = ac.getEmail();
int judgeGood = ac.getIntProperty("judge.good");
int judgeCommon = ac.getIntProperty("judge.common");
String judgeBad = ac.getProperty("judge.bad");
String judgeSubject = ac.getProperty("judgeNotice.subject");
String judgeUbbBody = ac.getProperty("judgeNotice.ubbBody");
String orderNoticeSubject = ac.getOrderNoticeSubject();
String orderNoticeBody = ac.getUbbBody();

String op = ParamUtil.get(request, "op");
if(op.equals("edit"))
{
		Enumeration e = request.getParameterNames();
		try{
			while (e.hasMoreElements()) {
					String fieldName = (String)e.nextElement();
					if (!fieldName.equals("edit")) {
						String value = ParamUtil.get(request, fieldName);
						ac.setProperty(fieldName, value);
					}
			}
			out.print(StrUtil.Alert_Redirect("操作成功！", "config_auction.jsp"));
		}catch (Exception ee) {
				out.print(StrUtil.Alert_Back(ee.getMessage()));
				ee.printStackTrace();
		}	
}
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
    <TR>
      <TD class=head>拍卖设置</TD>
    </TR>
  </TBODY>
</TABLE>
<br>
<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0" class="tableframe" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" >
  <tr> 
    <td height="23" colspan="4" class="thead">&nbsp;拍卖</td>
  </tr>
  <tr class=row style="BACKGROUND-COLOR: #fafafa"> 
    <td colspan="4" valign="top" bgcolor="#FFFFFF">
      <br>
      <table width="98%" border="0" align="center" cellpadding="3" cellspacing="1">
        <FORM METHOD=POST id="form1" name="form1" ACTION='config_auction.jsp?op=edit'>
          <tr>
            <td bgcolor=#F6F6F6>拍卖最大天数
          <td width="84%" colspan="2" bgcolor=#F6F6F6><input type="text" value="<%=max%>" name="expireDayMax" />          </tr>		
          <tr>
            <td bgcolor=#F6F6F6>E-mail别名
          <td colspan="2" bgcolor=#F6F6F6><input type="text" value="<%=from%>" name="emailAlias" />          </tr>
          <tr> 
            <td bgcolor=#F6F6F6 width='16%'>E-mail
            <td colspan="2" bgcolor=#F6F6F6>
          <input type="text" value="<%=email%>" name="email" />		  </tr>
          <tr> 
            <td bgcolor=#F6F6F6 width='16%'>好评
            <td colspan="2" bgcolor=#F6F6F6>
          <input type="text" value="<%=judgeGood%>" name="judge.good" />		  </tr>
          <tr> 
            <td bgcolor=#F6F6F6 width='16%'>一般
            <td colspan="2" bgcolor=#F6F6F6>
          <input type="text" value="<%=judgeCommon%>" name="judge.common" />		  </tr>
          <tr> 
            <td bgcolor=#F6F6F6 width='16%'>差评
            <td colspan="2" bgcolor=#F6F6F6>
          <input type="text" value="<%=judgeBad%>" name="judge.bad" />		  </tr>		  		  		  
		  <tr>
            <td bgcolor=#F6F6F6>定单通知          
          <td colspan="2" bgcolor=#F6F6F6><input type="text" value="<%=judgeSubject%>" name="judgeNotice.subject" size="70"/>            </tr>
          <tr>
            <td bgcolor=#F6F6F6>定单内容          
       	  <td colspan="2" bgcolor=#F6F6F6><textarea name="judgeNotice.ubbBody" rows="5" cols="100"><%=judgeUbbBody%></textarea>		  </tr>		  
		  <tr>
            <td bgcolor=#F6F6F6>通知          
          <td colspan="2" bgcolor=#F6F6F6><input type="text" value="<%=orderNoticeSubject%>" name="orderNotice.subject" size="70"/>            </tr>
          <tr>
            <td bgcolor=#F6F6F6>通知内容          
       	  <td colspan="2" bgcolor=#F6F6F6><textarea name="orderNotice.ubbBody" cols="100" rows="5"><%=orderNoticeBody%></textarea>		  </tr>
          <tr>
            <td bgcolor=#F6F6F6>          
            <td colspan="2" bgcolor=#F6F6F6>   <INPUT TYPE=submit name='edit' value='<lt:Label key="op_modify"/>'>       
          </tr>
        </FORM>
      </table><br>
</td>
  </tr>
</table> 
<p><br>
</p>
<p>
</p>
</body>                                        
</html>                            
  