<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
<%@ page import="com.redmoon.blog.template.*"%>
<%@ page import="com.redmoon.blog.ui.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<SCRIPT>
function formCheck(){
	document.frmAnnounce.content.value = getHtml();
}
</script>
<%
long photoId = ParamUtil.getLong(request, "photoId");
PhotoDb pd = new PhotoDb();
pd = pd.getPhotoDb(photoId);
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
if (pd.isLocked()) {
} else{%>
<br /><br />
<a name='form'></a>
<form name="frmAnnounce" action="showphoto.jsp" method=post onsubmit="return formCheck()">
<table style="BORDER-COLLAPSE: collapse; margin-top:10px" bordercolor=#d3d3d3 height=120 cellspacing=0 cellpadding=5 width="87%" align=center border=1>
    <tbody>
      <tr>
        <td height=26 align="left" class="td_comment_bar"> &nbsp;
          <lt:Label res="res.label.forum.showblog" key="comment"/>
          <a name="comment"></a></td>
      </tr>
      <tr bgcolor=#ffffff>
        <td width="744" valign=top><div align=left>
        <%
		String rpath = request.getContextPath();
		%>
            <textarea id="content" name="content" style="display:none"></textarea>
            <link rel="stylesheet" href="<%=rpath%>/editor/edit.css">
            <script src="<%=rpath%>/editor/DhtmlEdit.js"></script>
            <script src="<%=rpath%>/editor/editjs.jsp"></script>
            <script src="<%=rpath%>/editor/editor_s.jsp"></script>
            <br>
            <input name="photoId" value="<%=photoId%>" type="hidden" />
            <input name="photo_id" value="<%=photoId%>" type="hidden" />
            <input name="blog_id" value="<%=pd.getBlogId()%>" type="hidden" />
            <input name="op" value="add" type="hidden" />
            <input name="user_name" value="<%=privilege.getUser(request)%>" type="hidden" />
<%
com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
if (cfg.getBooleanProperty("forum.addUseValidateCode")) {
%>
            <br />
            <lt:Label res="res.label.forum.showtopic" key="input_validatecode"/>
            <input name="validateCode" type="text" size="1" />
            <img src='../validatecode.jsp' border="0" align="absmiddle" />
            <%}%>
		<div style="text-align:center"><input tabindex=4 type=submit value="<lt:Label res="res.label.forum.showblog" key="comment"/>" name=submit1></div>
        </div></td>
      </tr>
  </tbody>
</table>
</form>
<%}%>
