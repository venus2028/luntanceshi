<%@ page contentType="text/html; charset=utf-8" %>
<%
long blogIdNav = ParamUtil.getLong(request, "blogId");
%>
<DIV id="tabBar">
<div class="tabs">
  <ul>
  	<li id="menu1"><a href="photo.jsp?blogId=<%=blogIdNav%>">相册管理</a></li>
    <li id="menu2"><a href="photo_add_iframe.jsp?blogId=<%=blogIdNav%>">添加相片</a></li>
  </ul>
</div>
</DIV>

