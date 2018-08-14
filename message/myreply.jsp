<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.message.*"%>
<%@ page import="cn.js.fan.util.ErrMsgException"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<html>
<head>
<title><lt:Label res="res.label.message.message" key="message_center"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="../common.css" type=text/css rel=stylesheet>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{ %>
<table width="320" border="0" cellspacing="0" cellpadding="0" align="center" class="9black">
  <tr> 
    <td><li><%=SkinUtil.LoadString(request,"res.label.message.message","msg")%></td>
  </tr>
</table>
<% } %>
<%
  String title,receiver;
  title = ParamUtil.get(request, "title");	// StrUtil.UnicodeToGB(request.getParameter("title"));
  receiver = ParamUtil.get(request, "receiver");	// StrUtil.UnicodeToGB(request.getParameter("receiver"));
%>
<table width="320" border="0" cellspacing="1" cellpadding="3" align="center" bgcolor="#99CCFF" class="9black" height="260">
  <form name="form1" method="post" action="myreplytodb.jsp">
  <tr> 
    <td bgcolor="#CEE7FF" height="23">
        <div align="center"> <b><lt:Label res="res.label.message.message" key="message_center"/></b></div>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF" height="50"> 
        <table width="300" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td width="75"> 
              <div align="center"><a href="message.jsp?page=1"><img src="images/m_inbox.gif" width="40" border="0" alt="<lt:Label res="res.label.message.message" key="recever_mail"/>">
			  <br><lt:Label res="res.label.message.message" key="recever_mail"/>			  
			  </a></div>
            </td>
            <td width="75"> 
              <div align="center"><a href="mysend.jsp"><img src="images/m_outbox.gif" alt="<lt:Label res="res.label.message.message" key="send_mail"/>" width="40" border="0">
				<br /><lt:Label res="res.label.message.message" key="send_mail"/>			  
			  </a></div>
            </td>
            <td width="75"> 
              <div align="center"><img src="images/newpm.gif" width="40" border="0" alt="<lt:Label res="res.label.message.message" key="write_mail"/>">
			  <br><lt:Label res="res.label.message.message" key="write_mail"/>
			</div>
            </td>
            <td width="75"> 
              <div align="center"><img src="images/m_delete.gif" width="40" alt="<lt:Label res="res.label.message.message" key="del_mail"/>">
			  <br /><lt:Label res="res.label.message.message" key="del_mail"/>
			  </div>
            </td>
          </tr>
        </table>
    </td>
  </tr>
  <tr> 
      <td bgcolor="#FFFFFF" height="152" valign="top">
        <table width="300" border="0" cellspacing="0" cellpadding="0" align="center" class="9black" height="6">
          <tr> 
            <td></td>
          </tr>
        </table>
        <table width="300" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
          <tr> 
            <td width="68" height="26"> 
              <div align="center"><lt:Label res="res.label.message.message" key="msg_title"/></div>
            </td>
            <td width="217" height="26"> 
              <input type="text" name="title" class="input1" size="30" value="<%=StrUtil.toHtml(title)%>">
              <input name="type" type="hidden" value="<%=MessageDb.TYPE_USER%>">            </td>
          </tr>
          <tr> 
            <td width="68" height="26"> 
              <div align="center">
                <lt:Label res="res.label.message.message" key="recevier"/>
              </div>
            </td>
            <td width="217" height="26"> 
              <input type="text" name="receiver" class="input1" size="20" maxlength="20" value="<%=receiver %>">
              <input type=hidden name=receiver value="<%=receiver%>">
              <input type="hidden" name="sender" value="<%=privilege.getUser(request)%>"></td>
          </tr>
          <tr> 
            <td width="68" height="26"> 
              <div align="center">
                <lt:Label res="res.label.message.message" key="msg_content"/>
              </div>
            </td>
            <td width="217" height="26"> 
              <textarea name="content" cols="26" rows="3"></textarea>
            </td>
          </tr>
          <tr> 
            <td colspan="2" height="26"> 
              <div align="center">
                <input type="submit" name="Submit" value="<lt:Label res="res.label.message.message" key="send_msg"/>" >
                &nbsp; 
                <input type="reset" name="Submit2" value="<lt:Label res="res.label.message.message" key="rewrite"/>" >
              </div>
            </td>
          </tr>
        </table>
        <table width="300" border="0" cellspacing="0" cellpadding="0" align="center" class="9black" height="6">
          <tr> 
            <td></td>
          </tr>
        </table>
      </td>
  </tr>
  <tr> 
    <td bgcolor="#CEE7FF" height="6"></td>
  </tr></form>
</table>

</body>
</html>
