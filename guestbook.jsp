<%@ page contentType="text/html;charset=utf-8" language="java" errorPage="" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.module.guestbook.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="msg" scope="page" class="cn.js.fan.module.guestbook.MessageDb"/>
<jsp:useBean id="form" scope="page" class="cn.js.fan.security.Form"/>
<%
String content = ParamUtil.get(request, "content");
String code = ParamUtil.get(request, "code");
if (code.equals("")) {
	//  out.print(SkinUtil.makeErrMsg(request, "编码不能为空！"));
	// return;
	code = "yz_email_box";
}

String who = "院长";
if (!code.equals("yz_email_box")) {
	who = "政委";
	code = "zw_email_box";
}
%>
<%
if (!content.equals(""))
{
	boolean cansubmit = false;
	try {
		cansubmit = form.cansubmit(request,"guestbook");//防止重复刷新	
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	if (cansubmit) {

		String ip = request.getRemoteAddr();
		String username = ParamUtil.get(request, "username");
		if (username.trim().equals(""))
			username = "匿名";
		try {
			// 检查验证码
			cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
			if (cfg.getBooleanProperty("cms.site_guestbook_validate_code")) {
			   cn.js.fan.security.ValidateCodeCreator.validate(request);
			}
			boolean isScret = ParamUtil.getInt(request, "isScret", 0)==1;
			msg.setContent(content);
			msg.setUserName(username);
			msg.setIp(ip);
			msg.setShopCode(code);
			msg.setScret(isScret);
			msg.create();
			out.print(StrUtil.Alert_Redirect("操作成功！", "guestbook.jsp?code=" + code));
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert_Back(e.getMessage()));
			return;
		}
	}
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>信箱 - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body,div,ul,li{ 
padding:0;
font-size:12px;
} 
-->
</style>
<link href="css.css" type="text/css" rel="stylesheet" />
<style type="text/css">
<!--
.style2 {	color: #FFFFFF;
	font-weight: bold;
}
.style4 {color: #000000}
-->
</style>
</head>
<body>
<%@ include file="header_xy.jsp"%>
<table width="978" border="0" align="center" style="" cellpadding="0" cellspacing="0">
  <tr>
    <td height="27" background="images/xy_atfer_nav_bg.jpg"  style="color:#ffffff; font-size:14px; padding-left:30px" align="left"><SCRIPT language=JavaScript>
　var bsYear; 
　var bsDate; 
　var bsWeek; 
　var arrLen=8; //数组长度 
　var sValue=0; //当年的秒数 
　var dayiy=0; //当年第几天 
　var miy=0; //月份的下标 
　var iyear=0; //年份标记 
　var dayim=0; //当月第几天 
　var spd=86400; //每天的秒数 
　var year1999="30;29;29;30;29;29;30;29;30;30;30;29"; //354 
　var year2000="30;30;29;29;30;29;29;30;29;30;30;29"; //354 
　var year2001="30;30;29;30;29;30;29;29;30;29;30;29;30"; //384 
　var year2002="30;30;29;30;29;30;29;29;30;29;30;29"; //354 
　var year2003="30;30;29;30;30;29;30;29;29;30;29;30"; //355 
　var year2004="29;30;29;30;30;29;30;29;30;29;30;29;30"; //384 
　var year2005="29;30;29;30;29;30;30;29;30;29;30;29"; //354 
　var year2006="30;29;30;29;30;29;29;29;30;30;29;29;30"; 
　var month1999="正月;二月;三月;四月;五月;六月;七月;八月;九月;十月;十一月;十二月" 
　var month2001="正月;二月;三月;四月;闰四月;五月;六月;七月;八月;九月;十月;十一月;十二月" 
　var month2004="正月;二月;闰二月;三月;四月;五月;六月;七月;八月;九月;十月;十一月;十二月" 
　var month2006="正月;二月;三月;四月;五月;六月;七月;闰七月;八月;九月;十月;十一月;十二月" 
　var Dn="初一;初二;初三;初四;初五;初六;初七;初八;初九;初十;十一;十二;十三;十四;十五;十六;十七;十八;十九;二十;廿一;廿二;廿三;廿四;廿五;廿六;廿七;廿八;廿九;三十"; 
　var Ys=new Array(arrLen); 
　Ys[0]=919094400;Ys[1]=949680000;Ys[2]=980265600; 
　Ys[3]=1013443200;Ys[4]=1044028800;Ys[5]=1074700800; 
　Ys[6]=1107878400;Ys[7]=1138464000; 
　var Yn=new Array(arrLen); //农历年的名称 
　Yn[0]="己卯年";Yn[1]="农历庚辰年";Yn[2]="农历辛巳年"; 
　Yn[3]="壬午年";Yn[4]="农历癸未年";Yn[5]="农历甲申年"; 
　Yn[6]="乙酉年";Yn[7]="农历丙戌年"; 
　var D=new Date(); 
　var yy=D.getYear(); 
　var mm=D.getMonth()+1; 
　var dd=D.getDate(); 
　var ww=D.getDay(); 
　if (ww==0) ww="<font color=RED>星期日</font>"; 
　if (ww==1) ww="星期一"; 
　if (ww==2) ww="星期二"; 
　if (ww==3) ww="星期三"; 
　if (ww==4) ww="星期四"; 
　if (ww==5) ww="星期五"; 
　if (ww==6) ww="<font color=RED>星期六</font>"; 
　ww=ww; 
　var ss=parseInt(D.getTime() / 1000); 
　if (yy<100) yy="19"+yy; 
　for (i=0;i<arrLen;i++) 
　if (ss>=Ys[i]){ 
　iyear=i; 
　sValue=ss-Ys[i]; //当年的秒数 
　} 
　dayiy=parseInt(sValue/spd)+1; //当年的天数 
　var dpm=year1999; 
　if (iyear==1) dpm=year2000; 
　if (iyear==2) dpm=year2001; 
　if (iyear==3) dpm=year2002; 
　if (iyear==4) dpm=year2003; 
　if (iyear==5) dpm=year2004; 
　if (iyear==6) dpm=year2005; 
　if (iyear==7) dpm=year2006; 
　dpm=dpm.split(";"); 
　var Mn=month1999; 
　if (iyear==2) Mn=month2001; 
　if (iyear==5) Mn=month2004; 
　if (iyear==7) Mn=month2006; 
　Mn=Mn.split(";"); 
　var Dn="初一;初二;初三;初四;初五;初六;初七;初八;初九;初十;十一;十二;十三;十四;十五;十六;十七;十八;十九;二十;廿一;廿二;廿三;廿四;廿五;廿六;廿七;廿八;廿九;三十"; 
　Dn=Dn.split(";"); 
　dayim=dayiy; 
　var total=new Array(13); 
　total[0]=parseInt(dpm[0]); 
　for (i=1;i<dpm.length-1;i++) total[i]=parseInt(dpm[i])+total[i-1]; 
　for (i=dpm.length-1;i>0;i--) 
　if (dayim>total[i-1]){ 
　dayim=dayim-total[i-1]; 
　miy=i; 
　} 
　bsWeek=ww; 
　bsDate=yy+"年"+mm+"月"; 
　bsDate2=dd; 
　bsYear=Yn[iyear]; 
　bsYear2=Mn[miy]+Dn[dayim-1]; 
　if (ss>=Ys[7]||ss<Ys[0]) bsYear=Yn[7];
　if (bsDate<="2004年5月21日"){
　　switch (bsYear2) {
　　　　case "五月初七":
　　　　　 bsYear2 =bsYear2+ '　芒　种'; break;
　　　　case "五月廿三":
　　　　　 bsYear2 =bsYear2+ '　夏　至'; break;
　　　　case "六月初八":
　　　　　 bsYear2 =bsYear2+ '　小　暑'; break;
　　　　case "六月廿四":
　　　　　 bsYear2 =bsYear2+ '　大　暑'; break;
　　　　case "七月十一":
　　　　　 bsYear2 =bsYear2+ '　立　秋'; break;
　　　　case "七月廿六":
　　　　　 bsYear2 =bsYear2+ '　处　暑'; break;
　　　　case "八月十二":
　　　　　 bsYear2 =bsYear2+ '　白　露'; break;
　　　　case "八月廿七":
　　　　　 bsYear2 =bsYear2+ '　秋　分'; break;
　　　　case "九月十四":
　　　　　 bsYear2 =bsYear2+ '　寒　露'; break;
　　　　case "九月廿九":
　　　　　 bsYear2 =bsYear2+ '　霜　降'; break;
　　　　case "十月十五":
　　　　　 bsYear2 =bsYear2+ '　立　冬'; break;
　　　　case "十月三十":
　　　　　 bsYear2 =bsYear2+ '　小　雪'; break;
　　　　case "十一月十四":
　　　　　 bsYear2 =bsYear2+ '　大　雪'; break;
　　　　case "十一月廿九":
　　　　　 bsYear2 =bsYear2+ '　冬　至'; break;
　　　　case "十二月十五":
　　　　　 bsYear2 =bsYear2+ '　小　寒'; break;
　　　　case "十二月三十":
　　　　　 bsYear2 =bsYear2+ '　大　寒'; break;
　　　　case "一月十四":
　　　　　 bsYear2 =bsYear2+ '　立　春'; break;
　　　　case "一月廿九":
　　　　　 bsYear2 =bsYear2+ '　雨　水'; break;
　　　　case "二月十五":
　　　　　 bsYear2 =bsYear2+ '　惊　蛰'; break;
　　　　case "二月三十":
　　　　　 bsYear2 =bsYear2+ '　春　分'; break;
　　　　case "二月十五":
　　　　　 bsYear2 =bsYear2+ '　清　明'; break;
　　　　case "三月初二":
　　　　　 bsYear2 =bsYear2+ '　谷　雨'; break;
　　　　case "三月十七":
　　　　　 bsYear2 =bsYear2+ '　立　夏'; break;
　　　　case "四月初三":
　　　　　 bsYear2 =bsYear2+ '　小　满'; break;
　　　　break;
　　　　default :}};
　if (bsDate>="2004年6月1日" && bsDate<="2005年5月31日"){
　　switch (bsYear2) {
　　　　case "四月十八":
　　　　　 bsYear2 =bsYear2+ '　芒　种'; break;
　　　　case "五月初四":
　　　　　 bsYear2 =bsYear2+ '　夏　至'; break;
　　　　case "五月廿十":
　　　　　 bsYear2 =bsYear2+ '　小　暑'; break;
　　　　case "六月初六":
　　　　　 bsYear2 =bsYear2+ '　大　暑'; break;
　　　　case "六月廿二":
　　　　　 bsYear2 =bsYear2+ '　立　秋'; break;
　　　　case "七月初八":
　　　　　 bsYear2 =bsYear2+ '　处　暑'; break;
　　　　case "七月廿三":
　　　　　 bsYear2 =bsYear2+ '　白　露'; break;
　　　　case "八月初十":
　　　　　 bsYear2 =bsYear2+ '　秋　分'; break;
　　　　case "八月廿五":
　　　　　 bsYear2 =bsYear2+ '　寒　露'; break;
　　　　case "九月初十":
　　　　　 bsYear2 =bsYear2+ '　霜　降'; break;
　　　　case "九月廿五":
　　　　　 bsYear2 =bsYear2+ '　立　冬'; break;
　　　　case "十月十一":
　　　　　 bsYear2 =bsYear2+ '　小　雪'; break;
　　　　case "十月廿六":
　　　　　 bsYear2 =bsYear2+ '　大　雪'; break;
　　　　case "十一月初十":
　　　　　 bsYear2 =bsYear2+ '　冬　至'; break;
　　　　case "十一月廿五":
　　　　　 bsYear2 =bsYear2+ '　小　寒'; break;
　　　　case "十二月十一":
　　　　　 bsYear2 =bsYear2+ '　大　寒'; break;
　　　　case "十二月廿六":
　　　　　 bsYear2 =bsYear2+ '　立　春'; break;
　　　　case "一月初十":
　　　　　 bsYear2 =bsYear2+ '　雨　水'; break;
　　　　case "一月廿五":
　　　　　 bsYear2 =bsYear2+ '　惊　蛰'; break;
　　　　case "二月十一":
　　　　　 bsYear2 =bsYear2+ '　春　分'; break;
　　　　case "二月廿七":
　　　　　 bsYear2 =bsYear2+ '　清　明'; break;
　　　　case "三月十二":　
　　　　　 bsYear2 =bsYear2+ '　谷　雨'; break;
　　　　case "三月廿七":
　　　　　 bsYear2 =bsYear2+ '　立　夏'; break;
　　　　case "四月十四":
　　　　　 bsYear2 =bsYear2+ '　小　满'; break;
　　　　break;
　　　　default :}};
　if (bsDate>="2005年5月31日" && bsDate<="2006年5月31日"){
　　switch (bsYear2) {
　　　　case "四月廿九":
　　　　　 bsYear2 =bsYear2+ '　芒　种'; break;
　　　　case "五月十五":
　　　　　 bsYear2 =bsYear2+ '　夏　至'; break;
　　　　case "六月初二":
　　　　　 bsYear2 =bsYear2+ '　小　暑'; break;
　　　　case "六月十八":
　　　　　 bsYear2 =bsYear2+ '　大　暑'; break;
　　　　case "七月初三":
　　　　　 bsYear2 =bsYear2+ '　立　秋'; break;
　　　　case "七月十九":
　　　　　 bsYear2 =bsYear2+ '　处　暑'; break;
　　　　case "八月初四":
　　　　　 bsYear2 =bsYear2+ '　白　露'; break;
　　　　case "八月二十":
　　　　　 bsYear2 =bsYear2+ '　秋　分'; break;
　　　　case "九月初六":
　　　　　 bsYear2 =bsYear2+ '　寒　露'; break;
　　　　case "九月廿一":
　　　　　 bsYear2 =bsYear2+ '　霜　降'; break;
　　　　case "十月初六":
　　　　　 bsYear2 =bsYear2+ '　立　冬'; break;
　　　　case "十月廿一":
　　　　　 bsYear2 =bsYear2+ '　小　雪'; break;
　　　　case "十一月七":
　　　　　 bsYear2 =bsYear2+ '　大　雪'; break;
　　　　case "十一月廿二":
　　　　　 bsYear2 =bsYear2+ '　冬　至'; break;
　　　　case "十二月初六":
　　　　　 bsYear2 =bsYear2+ '　小　寒'; break;
　　　　case "十二月廿一":
　　　　　 bsYear2 =bsYear2+ '　大　寒'; break;
　　　　case "一月初七":
　　　　　 bsYear2 =bsYear2+ '　立　春'; break;
　　　　case "一月廿二":
　　　　　 bsYear2 =bsYear2+ '　雨　水'; break;
　　　　case "二月初七":
　　　　　 bsYear2 =bsYear2+ '　惊　蛰'; break;
　　　　case "二月廿二":
　　　　　 bsYear2 =bsYear2+ '　春　分'; break;
　　　　case "三月初八":
　　　　　 bsYear2 =bsYear2+ '　清　明'; break;
　　　　case "三月廿三":
　　　　　 bsYear2 =bsYear2+ '　谷　雨'; break;
　　　　case "四月初九":
　　　　　 bsYear2 =bsYear2+ '　立　夏'; break;
　　　　case "四月廿四":
　　　　　 bsYear2 =bsYear2+ '　小　满'; break;
　　　　break;
　　　　default :}};
　if (bsDate>="2006年6月1日" && bsDate<="2007年5月31日"){
　　switch (bsYear2) {
　　　　case "五月十一":
　　　　　 bsYear2 =bsYear2+ '　芒　种'; break;
　　　　case "五月廿六":
　　　　　 bsYear2 =bsYear2+ '　夏　至'; break;
　　　　case "六月十二":
　　　　　 bsYear2 =bsYear2+ '　小　暑'; break;
　　　　case "六月廿八":
　　　　　 bsYear2 =bsYear2+ '　大　暑'; break;
　　　　case "七月十五":
　　　　　 bsYear2 =bsYear2+  '　立秋'; break;
　　　　case "七月三十":
　　　　　 bsYear2 =bsYear2+ '　处　暑'; break;
　　　　case "七月十六":
　　　　　 bsYear2 =bsYear2+ '　白　露'; break;
　　　　case "八月初二":
　　　　　 bsYear2 =bsYear2+  '　秋　分'; break;
　　　　case "八月十七":
　　　　　 bsYear2 =bsYear2+ '　寒　露'; break;
　　　　case "九月初二":
　　　　　 bsYear2 =bsYear2+ '　霜　降'; break;
　　　　case "九月十七":
　　　　　 bsYear2 =bsYear2+ '　立　冬'; break;
　　　　case "十月初二":
　　　　　 bsYear2 =bsYear2+ '　小　雪'; break;
　　　　case "十月十七":
　　　　　 bsYear2 =bsYear2+ '　大　雪'; break;
　　　　case "十一月初三":
　　　　　 bsYear2 =bsYear2+ '　冬　至'; break;
　　　　case "十一月十八":
　　　　　 bsYear2 =bsYear2+ '　小　寒'; break;
　　　　case "十二月初二":
　　　　　 bsYear2 =bsYear2+ '　大　寒'; break;
　　　　case "十二月十七":
　　　　　 bsYear2 =bsYear2+ '　立　春'; break;
　　　　case "一月初二":
　　　　　 bsYear2 =bsYear2+ '　雨　水'; break;
　　　　case "一月十七":
　　　　　 bsYear2 =bsYear2+ '　惊　蛰'; break;
　　　　case "二月初三":
　　　　　 bsYear2 =bsYear2+ '　春　分'; break;
　　　　case "二月十八":
　　　　　 bsYear2 =bsYear2+ '　清　明'; break;
　　　　case "三月初四":
　　　　　 bsYear2 =bsYear2+ '　谷　雨'; break;
　　　　case "三月二十":
　　　　　 bsYear2 =bsYear2+ '　立　夏'; break;
　　　　case "四月初五":
　　　　　 bsYear2 =bsYear2+ '　小　满'; break;
　　　　break;
　　　　default :}};　　　　　　
　document.write ( bsDate );
　document.write ( bsDate2 );
　document.write ('&nbsp;<img src="images/no.gif" width="1" height="8">'+bsWeek );
</SCRIPT>
	<font color="#FAD260" style="font-family:'宋体'">&nbsp;学院快报&nbsp;>></font></td>
  </tr>
</table>
<table width="978" height="14" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td bgcolor="#C7CAD9"></td>
  </tr>
</table>
<table width="978" height="564" border="0" align="center" cellpadding="0" cellspacing="0" id="__01">
  <tr>
    <td width="680" height="32" colspan="41" align="left" bgcolor="F6F6F6">
	<div style="font-family:'宋体'; margin:0px 30px; color:#B60400">&nbsp;<img src="images/ship.jpg" width="70" height="21">&nbsp;&nbsp;&nbsp;当前位置： <a href="index.jsp" class="lm">首页</a> >>&nbsp;信箱</div></td>
  </tr>
  <tr>
    <td height="486" colspan="41" align="left" valign="top" bgcolor="F6F6F6" style="padding:0px 45px;line-height:2;">
      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td width="100%" height="52" align="center"><strong><span class="guestbook_title"><%=who%>信箱</span></strong></td>
        </tr>
        <tr>
          <td valign="top"><%
int pagesize = 10;
Paginator paginator = new Paginator(request);

String sql = "select id from guestbook where shopCode=" + StrUtil.sqlstr(code) + " order by lydate desc";
int total = msg.getObjectCount(sql);
paginator.init(total, pagesize);
int curpage = paginator.getCurPage();
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}

Iterator ri = msg.list(sql, (curpage-1)*pagesize, curpage*pagesize-1).iterator();
String querystr = "code=" + StrUtil.UrlEncode(code);
%>
              <% if(paginator.getTotal()>0){ %>
              <table width="91%" border="0" cellspacing="0" cellpadding="0" align="center" class="p9" height="24">
                <tr>
                  <td width="100%" height="24" valign="bottom"><div align="right">共 <b><%=paginator.getTotal() %></b> 条　每页<b><%=paginator.getPageSize() %></b> 条　<b><%=curpage %>/<%=totalpages %></b>
                          <%
 	  out.print(paginator.getCurPageBlock("?"+querystr));
	  %>
                  </div></td>
                </tr>
              </table>
            <%}%>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr bgcolor="#4A7D00">
                  <td height="4" colspan="2" bgcolor="#5774B0"></td>
                </tr>
                <tr>
                  <td width="153" height="24" background="shopskin/default/images/guestbookbar.gif">&nbsp;&nbsp;<span class="text_white_bold">最新留言</span></td>
                  <td align="right">&nbsp;&nbsp;</td>
                </tr>
              </table>
            <%
while (ri.hasNext()) {
 	MessageDb md = (MessageDb)ri.next(); %>
              <table width="98%" border="0" align="center" cellpadding="5" cellspacing="0" class="tableframe" style="border-bottom:1px dashed #000000">
                <tr>
                  <td width="18%" height="20" valign="bottom" class="stable style4">用户：<%=StrUtil.toHtml(md.getUserName())%>　</td>
                  <td width="82%" height="22" valign="bottom" class="stable style4">留言日期：<%=DateUtil.format(md.getLydate(), "yy-MM-dd HH:mm:ss")%></td>
                </tr>
                <tr valign="top">
                  <td height="83" colspan="2" class="stable">
				  <%if (!md.isScret() || com.redmoon.forum.Privilege.isMasterLogin(request)) {%>
				  <%=StrUtil.toHtml(md.getContent())%><br />
                  <%
				  String reply = StrUtil.getNullString(md.getReply());
				  if (!reply.equals(""))
				  {
				  %>
                      <br />
                      <font color="#F09F6F">回复：</font><%=StrUtil.toHtml(reply)%> <br />
                    日期：<%=DateUtil.format(md.getLydate(), "yy-MM-dd HH:mm:ss")%>
                    <% } %>
				  <%}else{%>
				  **********************私密留言**********************
				  <%}%>
                  </td>
                </tr>
                <tr valign="top">
                  <td height="1" colspan="2"></td>
                </tr>
              </table>
              <%}
%>
              <% if(paginator.getTotal()>0){ %>
              <table width="91%" border="0" cellspacing="0" cellpadding="0" align="center" class="p9" height="24">
                <tr>
                  <td width="100%" height="24" valign="bottom"><div align="right">共 <b><%=paginator.getTotal() %></b> 条　每页<b><%=paginator.getPageSize() %></b> 条　<b><%=curpage %>/<%=totalpages %></b>
                          <%
 	  out.print(paginator.getCurPageBlock("?"+querystr));
	  %>
                  </div></td>
                </tr>
              </table>
            <%}%>
              <br />
              <table width="522" height="150" border="0" align="center" cellpadding="1" cellspacing="0" style="border:1px solid #cccccc">
                <form action="?" method="post">
                  <tr align="center" bgcolor="#4A7D00">
                    <td height="24" colspan="3" bgcolor="#5774B0"><span class="style2">请 您 留 言</span></td>
                  </tr>
                  <tr>
                    <td align="center">用户</td>
                    <td width="463" colspan="2"><input name="username" size="15" />
                        <input name="code" type="hidden" value="<%=code%>" />
                      验证码&nbsp;
                      <%
			cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
			if (cfg.getBooleanProperty("cms.site_guestbook_validate_code")) {
			%>
                      <input name="validateCode" type="text" size="1" />
                      <img src='validatecode.jsp' border="0" align="absmiddle" style="cursor:hand" onclick="this.src='<%=request.getContextPath()%>/validatecode.jsp'" alt="<lt:Label res="res.label.forum.index" key="refresh_validatecode"/>" />
                      <%}%>
					  <input name="isScret" value="1" type=checkbox>是否私密
                    </td>
                  </tr>
                  <tr>
                    <td width="55" align="center">                    内容</td>
                    <td colspan="2"><textarea name="content" cols="45" rows="8"></textarea>
                    </td>
                  </tr>
                  <tr>
                    <td colspan="3" align="center"><div align="left"> </div>
                        <input name="submit" type="submit" class="stable" value="发送留言" /></td>
                  </tr>
                </form>
            </table></td>
        </tr>
        <tr>
          <td height="9">&nbsp;</td>
        </tr>
      </table></td>
  </tr>
  <tr>
    <td height="22" colspan="41" align="left" valign="top" bgcolor="F6F6F6" style="padding:0px 45px;line-height:2;">&nbsp;</td>
  </tr>
</table>
<%@ include file="footer.jsp"%>
</body>
</html>