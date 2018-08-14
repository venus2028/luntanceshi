<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.template.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin2.*"%>
<%@ page import="com.redmoon.forum.plugin.base.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long rootid = ParamUtil.getLong(request, "rootid");
MsgDb rootMsgDb = new MsgDb();
rootMsgDb = rootMsgDb.getMsgDb(rootid);
String privurl = ParamUtil.get(request, "privurl");
if (!privilege.canUserDo(request, com.redmoon.forum.Leaf.CODE_BLOG, "reply_topic")) {%>
<table width="100%" border="0">
  <tr>
    <td align="right">&gt;&gt;
      <lt:Label res="res.label.forum.showblog" key="please"/>
      <a href="../door.jsp">
      <lt:Label res="res.label.forum.showblog" key="login"/>
      </a>
      <lt:Label res="res.label.forum.showblog" key="msg"/>
      <a href="../regist.jsp">
      <lt:Label res="res.label.forum.showblog" key="reg"/>
    </a>？&nbsp;&nbsp;&nbsp;</td>
  </tr>
</table>
<%} 
if (rootMsgDb.getIsLocked()==1) {
} else{%>
<br>
<a name='form'></a>
<table style="BORDER-COLLAPSE: collapse" bordercolor=#d3d3d3 height=120 cellspacing=0 cellpadding=5 width="87%" align=center border=1>
  <form name="frmAnnounce" onSubmit="return formCheck()" action="../forum/addquickreplytodb.jsp" method=post>
    <tbody>
      <tr>
        <td height=26 colspan="2" align="left" class="td_comment_bar"> &nbsp;
          <lt:Label res="res.label.forum.showblog" key="comment"/></td>
      </tr>
      <tr bgcolor=#ffffff>
        <td width="81" height=20><a name="comment"></a><lt:Label res="res.label.forum.showtopic" key="quick_reply_title"/></td>
        <td width="744" height=20><input name="topic" value="<%="Re："+StrUtil.toHtml(rootMsgDb.getTitle())%>" size="40">
          <input type=hidden name="replyid" value="<%=rootMsgDb.getId()%>">
          <input type=hidden name="boardcode" value="<%=rootMsgDb.getboardcode()%>">
          <input type=hidden name="isWebedit" value="1">
          <input type=hidden name="expression" value="25">
          <input type=hidden name="privurl" value="<%=privurl%>">
<%
com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
if (cfg.getBooleanProperty("forum.addUseValidateCode")) {
%>
          <br>
          <lt:Label res="res.label.forum.showtopic" key="input_validatecode"/>
          <input name="validateCode" type="text" size="1">
          <img src='../validatecode.jsp' border=0 align="absmiddle">
<%}%>
        </td>
      </tr>
      <tr bgcolor=#ffffff>
        <td><lt:Label res="res.label.forum.showblog" key="content"/></td>
        <td valign=top><div align=left>
        <%
		String rpath = request.getContextPath();
		%>
            <textarea id="Content" name="Content" style="display:none"></textarea>
            <link rel="stylesheet" href="<%=rpath%>/editor/edit.css">
            <script src="<%=rpath%>/editor/DhtmlEdit.js"></script>
            <script src="<%=rpath%>/editor/editjs.jsp"></script>
            <script src="<%=rpath%>/editor/editor_s.jsp"></script>
            <br>
            <input tabindex=4 type=submit value="<lt:Label res="res.label.forum.showblog" key="comment"/>" name=submit1>
        </div></td>
      </tr>
  </form>
  </tbody>
</table>
<%}%>
