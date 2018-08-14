<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ taglib uri="/WEB-INF/tlds/DirListTag.tld" prefix="dirlist" %>
<%@ taglib uri="/WEB-INF/tlds/DocumentTag.tld" prefix="left_doc" %>
<%@ taglib uri="/WEB-INF/tlds/DocListTag.tld" prefix="dl" %>
  <div class="right_box_top"><img src="/cwbbs/template/images/icon_arrow1.gif" width="9" height="5" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;网站登录 </div>
  <div class="right_box_middle">
    <iframe style="margin-left:10px" marginwidth="0" src="/cwbbs/iframe_login.jsp" frameborder="0" width="232" scrolling="No" height="140"></iframe>
  </div>
  <div class="right_box_bottom"></div>
  <div class="right_box_top">
      <li>目录</li>
  </div>
  <div class="right_box_middle">
    <ul>
<%
String left_dir_code = ParamUtil.get(request, "dirCode");
if (left_dir_code.equals("")) {
	left_dir_code = Leaf.ROOTCODE;
}%>
<dirlist:DirListTag parentCode="<%=left_dir_code%>">
<dirlist:DirListItemTag field="name" mode="detail" length="20">
<li><a href="doc_list.jsp?dirCode=@code" title="#name" style="PADDING-LEFT: 5px;PADDING-top: 9px;">$name</a></li>
</dirlist:DirListItemTag>
</dirlist:DirListTag>
    </ul>
  </div>
  <div class="right_box_bottom"></div>
  <div class="right_box_top"> <span>&gt;&gt; <a href="forum/index.jsp">更多</a></span>
      <li>最新贴子</li>
  </div>
  <div class="right_box_middle">
    <ul>
<script src="forum/js.jsp?start=0&end=10"></script>
    </ul>
  </div>
  <div class="right_box_bottom"></div>
  <div class="ad_right_box">
  <script src="js.jsp?var=homeAd&id=81"></script>
  </div>
  <div class="right_box_top"> <span>&gt;&gt; <a href="/cwbbs/listmember.jsp">更多</a></span>
      <li>最新用户</li>
  </div>
  <div class="right_box_middle">
    <ul>
<script src="forum/js.jsp?var=newuser"></script>
    </ul>
  </div>
  <div class="right_box_bottom"></div>