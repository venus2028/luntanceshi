<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%
String siteCode = ParamUtil.get(request, "siteCode");
String style = ParamUtil.get(request, "style");
if (style.equals("")) {
	style = "default";
}
String isAutoStart = ParamUtil.get(request, "isAutoStart");
String w;
String h;
BgMusicStyleConfig bsc = BgMusicStyleConfig.getInstance();
w = bsc.getStyleWidth(style);
if (w==null)
	w = "296px";

h = bsc.getStyleHeight(style);
if (h==null)
	h = "21px";	
%>
document.write("<iframe frameborder='0' scrolling='no' width='<%=w%>' height='<%=h%>' src='<%=request.getContextPath()%>/cms/site/site_bk_music.jsp?siteCode=<%=siteCode%>&style=<%=style%>&isAutoStart=<%=isAutoStart%>'></iframe>");