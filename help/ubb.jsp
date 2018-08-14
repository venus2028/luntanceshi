<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();

String rootPath = request.getContextPath();
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<LINK href="<%=rootPath%>/forum/<%=skinPath%>/skin.css" type=text/css rel=stylesheet>
<title>帮助 - UBB</title>
</head>
<body>
<%@ include file="../forum/inc/header.jsp"%>
<%@ include file="../forum/inc/position.jsp"%>
<table width=98% border="1" align="center" cellpadding="3" cellspacing="0" bordercolor="<%=skin.getTableBorderClr()%>">
  <tr>
    <td class="td_title"><b>UBB语法</b></td>
	<td class="td_title"><b>效   果</b></td>
    <td class="td_title"><b>按   钮</b></td>
    <td class="td_title"><b>说   明</b></td>
  </tr>
  <tr>
    <td>[B]加粗[/B]</td>
	<td><b>加粗</b></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/bold.gif" /></td>
    <td>加粗</td>
  </tr>
  <tr>
    <td>[I]斜体[/I]</td>
	<td><I>斜体</I></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/italicize.gif" /></td>
    <td>斜体</td>
  </tr>
  <tr>
    <td>[U]下划线[/U]</td>
	<td><u>下划线</u></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/underline.gif" /></td>
    <td>下划线</td>
  </tr>
  <tr>
    <td>[center]居中[/center]</td>
	<td><center>居中</center></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/center.gif" /></td>
    <td>居中</td>
  </tr>
  <tr>
    <td>[URL=hhttttpp://连接网址]http://www.baidu.com[/URL]</td>
	<td><a href="http://www.baidu.com">http://www.baidu.com</a></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/url1.gif" /></td>
    <td>超级连接</td>
  </tr>
  <tr>
    <td>[EMAIL]Email地址[/EMAIL]</td>
	<td><a HREF="mailto:welcome@cloudwebsoft.com">welcome@cloudwebsoft.com</a></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/email1.gif" /></td>
    <td>Email连接</td>
  </tr>
  <tr>
    <td>[img]hhttttpp://www.zjrj.cn/forum/images/face/face.gif[/img]</td>
	<td><img src="http://www.zjrj.cn/forum/images/face/face.gif"/></a></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/image.gif"/></td>
    <td>图片</td>
  </tr>
  <tr>
    <td>[flash=高度,宽度]hhttttpp://Flash文件地址[/flash]</td>
	<td>&nbsp;</td>
    <td><img src="<%=rootPath%>/forum/images/UBB/swf.gif" /></td>
    <td>FLASH</td>
  </tr>
  <tr>
    <td>[dir=高度,宽度]视频文件地址[/dir]</td>
	<td>&nbsp; </td>
    <td><img src="<%=rootPath%>/forum/images/UBB/Shockwave.gif" /></td>
    <td>Shockwave</td>
  </tr>
  <tr>
    <td>[rm=高度,宽度]视频文件地址[/rm]</td>
	<td>&nbsp; </td>
    <td><img src="<%=rootPath%>/forum/images/UBB/rm.gif" /></td>
    <td>realplay</td>
  </tr>
  <tr>
    <td>[mp=500,350]视频文件地址[/mp]</td>
	<td>&nbsp; </td>
    <td><img src="<%=rootPath%>/forum/images/UBB/mp.gif" /></td>
    <td>Media Player</td>
  </tr>
  <tr>
    <td>[qt=500,350]视频文件地址[/qt]</td>
	<td>&nbsp; </td>
    <td><img src="<%=rootPath%>/forum/images/UBB/qt.gif" /></td>
    <td>QuickTime</td>
  </tr>
  <tr>
    <td>[QUOTE]文字[/QUOTE]</td>
	<td>&nbsp; </td>
    <td><img src="<%=rootPath%>//forum/images/UBB/quote1.gif" /></td>
    <td>引用</td>
  </tr>
  <tr>
    <td>[fly]文字[/fly]</td>
	<td><marquee width=90% behavior=alternate scrollamount=3>飞</marquee></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/fly.gif" /></td>
    <td>飞</td>
  </tr>
  <tr>
    <td>[move]文字[/move]</td>
	<td><MARQUEE scrollamount=3>移</marquee></td>
    <td><img src="<%=rootPath%>/forum/images/UBB/move.gif" /></td>
    <td>移</td>
  </tr>
  <tr>
    <td>[glow=长度,颜色(英文),边界大小]文字[/glow]</td>
	<td style="filter:glow(color=red, strength=2)">光</td>
    <td><img src="<%=rootPath%>/forum/images/UBB/glow.gif" /></td>
    <td>光</td>
  </tr>
  <tr>
    <td>[SHADOW=长度,颜色(英文),边界大小]文字[/SHADOW]</td>
	<td style="filter:shadow(color=blue, strength=1)">影</td>
    <td><img src="<%=rootPath%>/forum/images/UBB/shadow.gif" /></td>
    <td>阴影字</td>
  </tr>
   <tr>
    <td>[face=隶书]字体[/face]</td>
	<td><span class="STYLE1"><font>字体</font></span></td>
    <td>&nbsp;</td>
    <td>字体</td>
  </tr>
   <tr>
    <td>[size=5]字体大小[/size]</td>
	<td><font size="5">字体大小</font></td>
    <td>&nbsp;</td>
    <td>字体大小</td>
  </tr>
   <tr>
    <td>[color=#00FFFF]颜色[/color]</td>
	<td><font color="#00FFFF">颜色</font></td>
    <td>&nbsp;</td>
    <td>颜色</td>
  </tr>
  <%
		int i;
		for(i=1;i<=73;i++)
		{
			out.println("<tr></td><td>[em"+i+"]</td><td><img src=\"" + rootPath + "/forum/images/emot/em"+i+".gif\"></td><td><img src=\"" + rootPath + "/forum/images/emot/em"+i+".gif\"></img><td>em"+i+".gif</td></tr>");
		}
	%>
</table>
<%@ include file="../forum/inc/footer.jsp"%>
</body>
</html>
