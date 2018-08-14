<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<LINK href="../common.css" type=text/css rel=stylesheet>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<html>
<head>
<title><lt:Label res="res.label.message.message" key="write_group_new_msg"/></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script language=javascript>
<!--
function form1_onsubmit()
{
	errmsg = "";
	if (!form1.isToAll.checked)
		if (form1.receiver.value=="")
		 errmsg += "<lt:Label res="res.label.message.message" key="write_recevier"/>" + "\n"
	if (form1.title.value=="")
		errmsg += "<lt:Label res="res.label.message.message" key="write_title"/>" + "\n"
	if (form1.content.value=="")
		errmsg += "<lt:Label res="res.label.message.message" key="write_content"/>" + "\n"
	if (errmsg!="")
	{
		alert(errmsg);
		return false;
	}
}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="320" border="0" cellspacing="1" cellpadding="3" align="center" bgcolor="#99CCFF" class="9black" height="260">
  <form name="form1" method="post" action="send_do.jsp" onSubmit="return form1_onsubmit()">
  <tr> 
    <td bgcolor="#CEE7FF" height="23">
        <div align="center"> <b><lt:Label res="res.label.message.message" key="write_group_new_msg"/></b></div>
    </td>
  </tr>
  <tr> 
    <td bgcolor="#FFFFFF" height="50"> 
        <table width="300" border="0" cellspacing="0" cellpadding="0" align="center">
          <tr> 
            <td width="75"> 
              <div align="center"><a href="message.jsp?page=1"><img src="images/m_inbox.gif" width="40" border="0" alt="<lt:Label res="res.label.message.message" key="recever_mail"/>">
			  <br /><lt:Label res="res.label.message.message" key="recever_mail"/>
			  </a></div>
            </td>
            <td width="75"> 
              <div align="center"><a href="mysend.jsp"><img src="images/m_outbox.gif" alt="<lt:Label res="res.label.message.message" key="send_mail"/>" width="40" border="0">
			  <br /><lt:Label res="res.label.message.message" key="send_mail"/>
			  </a></div>
            </td>
            <td width="75"> 
              <div align="center"><img src="images/newpm.gif" width="40" border="0" alt="<lt:Label res="res.label.message.message" key="write_mail"/>">
			  <br /><lt:Label res="res.label.message.message" key="write_mail"/>
			  </div>
            </td>
            <td width="75"> 
              <div align="center"> <img src="images/m_delete.gif" width="40" alt="<lt:Label res="res.label.message.message" key="del_mail"/>">
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
            <td width="68" height="27"> 
              <div align="center"><lt:Label res="res.label.message.message" key="recevier"/></div>
            </td>
            <td width="217" height="27">
              <input type="text" name="receiver" class="input1" size="20" maxlength="20">
			  <%
			  com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
			  String sender = cfg.getProperty("forum.message_sender");
			  %>
			  <input type="hidden" name="sender" value="<%=sender%>">
			  <input name="type" type="hidden" value="<%=com.redmoon.forum.message.MessageDb.TYPE_SYSTEM%>">
			  <input name="isToAll" type="checkbox" value="true"><lt:Label res="res.label.message.message" key="group"/>
            </td>
          </tr>
          <tr> 
            <td width="68" height="26"> 
              <div align="center"><lt:Label res="res.label.message.message" key="msg_title"/></div>
            </td>
            <td width="217" height="26">
              <input type="text" name="title" class="input1" size="30" maxlength="30">
            </td>
          </tr>
          <tr> 
            <td width="68" height="26"> 
              <div align="center"><lt:Label res="res.label.message.message" key="msg_content"/></div>
            </td>
            <td width="217" height="26"> 
              <textarea name="content" cols="28" rows="3"></textarea>
            </td>
          </tr>
          <tr> 
            <td colspan="2" height="26"> 
              <div align="center">
                <input type="submit" name="Submit" value="<lt:Label res="res.label.message.message" key="send_msg"/>" class="button1">
                &nbsp; 
                <input type="reset" name="Submit2" value="<lt:Label res="res.label.message.message" key="rewrite"/>" class="button1">
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
