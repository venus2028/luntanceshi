<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<link href="common.css" rel="stylesheet" type="text/css">
<table width="1004"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="6" bgcolor="#5C8098"></td>
  </tr>
</table>
<table width="1004"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="6" bgcolor="#FFFFFF"><table width="892" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td rowspan="2" valign="bottom"><img src="images/PIC1.jpg" width="288" height="50" /></td>
        <form>
          <td height="35" align="right"><table width="84%"  border="0" cellspacing="0" cellpadding="0">
            <tr  align="center">
              <td width="9%" title="<lt:Label res="res.label.blog.frame" key="set_first_page"/>"><a href="#" onclick="this.style.behavior='url(#default#homepage)';this.setHomePage('http://<%=Global.server%>:<%=Global.port%>/blog/index.jsp');"><img src="images/ico_001.gif" width="15" height="14" border="0" /></a></td>
<%
String str = SkinUtil.LoadString(request,"res.label.blog.frame", "blog_title");
str = StrUtil.format(str, new Object[] {Global.AppName});
%>             
			  <td  width="10%" title="<lt:Label res="res.label.blog.frame" key="collection"/>"><a href="javascript:window.external.addFavorite('http://<%=Global.server%>:<%=Global.port%>/blog/index.jsp','<%=str%>');"><img src="images/add.gif" width="15" height="13" border="0" /></a></td>
              <td width="9%" title="<lt:Label res="res.label.blog.frame" key="link_m"/>"><a href="mailto:<%=Global.email%>"><img src="images/pinned_topic_icon.gif" width="18" height="12" border="0" /></a></td>
            </tr>
          </table></td>
        </form>
      </tr>
      <tr>
        <td height="25" align="right">&nbsp;</td>
        <div style=" text-align:center;display:none;border:1px; width:54px; solid #000000;background-color:#FFFFCC;font-size:12px;position:absolute;padding:2;" id="altlayer"></div>
      </tr>
    </table></td>
  </tr>
</table>
<!-- 导航条 -->
<table width="1004"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr >
    <td height="30" valign="top" bgcolor="#FFFFFF"><table width="892" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td height="24">&nbsp;</td>
        <td style="PADDING-top: 4px;CURSOR: hand" width="80" align="center" class="line4" onmouseover="this.style.backgroundColor='E1E7C7'" onmouseout="this.style.backgroundColor=''"><a href="index.jsp"><lt:Label res="res.label.blog.frame" key="first_page"/><a></td>
        <td width="1" align="center"></td>
        <td style="PADDING-top: 4px;CURSOR: hand" width="80" align="center" class="line4" onmouseover="this.style.backgroundColor='E1E7C7'" onmouseout="this.style.backgroundColor=''"><a href="../forum/index.jsp"><lt:Label res="res.label.blog.frame" key="forum"/><a></td>
        <td width="1" align="center"></td>
        <td style="PADDING-top: 4px;CURSOR: hand" width="80" align="center" class="line4" onmouseover="this.style.backgroundColor='#C7E5CC'" onmouseout="this.style.backgroundColor=''"><a href="listmsg.jsp"><lt:Label res="res.label.blog.frame" key="log"/></a></td>
        <td width="1" align="center"></td> 
		<td style="PADDING-top: 4px;CURSOR: hand" width="80" align="center" class="line4" onmouseover="this.style.backgroundColor='#C7E5CC'" onmouseout="this.style.backgroundColor=''"><a href="user/userconfig_add.jsp?blogType=<%=com.redmoon.blog.UserConfigDb.TYPE_GROUP%>"><lt:Label res="res.label.blog.admin.blog" key="team"/></a></td>
        <td width="1" align="center"></td>
        <td style="PADDING-top: 4px;CURSOR: hand" width="80" align="center" class="line4" onmouseover="this.style.backgroundColor='#E7CBE5'" onmouseout="this.style.backgroundColor=''"><a href="listblogphoto.jsp"><lt:Label res="res.label.blog.frame" key="album"/></a></td>
        <td width="1" align="center"></td>
        <td style="PADDING-top: 4px;CURSOR: hand" width="79" align="center" class="line4" onmouseover="this.style.backgroundColor='#CBE7E5'" onmouseout="this.style.backgroundColor=''" ><a href="listblog.jsp"><lt:Label res="res.label.blog.frame" key="blog"/></a></td>
        <td width="1" align="center"></td>
        <td style="PADDING-top: 4px;CURSOR: hand" width="96" align="center" class="line4" onmouseover="this.style.backgroundColor='#D6D6EE'" onmouseout="this.style.backgroundColor=''" ><a href="<%=Global.getRootPath()%>"><%=Global.AppName%></a> </td>
      </tr>
    </table></td>
  </tr>
</table>
