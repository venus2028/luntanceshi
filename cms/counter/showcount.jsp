<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="cn.js.fan.db.*" %>
<%@ page import="cn.js.fan.web.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="java.sql.*" %>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/><jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/><%
if (!privilege.isUserPrivValid(request, "forum.bak")){
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String siteCode = ParamUtil.get(request, "siteCode");
if (siteCode.equals(""))
	siteCode = cn.js.fan.module.cms.Leaf.ROOTCODE;
%>
<%!
String connname = Global.defaultDB;
int CountSize = 6;    //计数不足在前面加零
boolean CountView = true;  //计数是否显示在页面上,False/True
boolean CountType = true;  //统计是记时间还是不记.True记，False不记
boolean CountMode = true; //在页面上显示不计时的计数结果，还是显示计时的结果，默认为不计时（计时为：20分钟内不加数)
int Avera,DayMax,AllCount;
 //计算两个日期之间相隔的天数
 public int DateDiff(java.util.Date lowerLimitDate,java.util.Date upperLimitDate){
   if (lowerLimitDate==null || upperLimitDate==null)
   	return 0; 
   long upperTime,lowerTime;
   upperTime=upperLimitDate.getTime();
   lowerTime=lowerLimitDate.getTime();
   if(upperTime<lowerTime)
	return -1;
   Long result=new Long((upperTime-lowerTime)/(1000*60*60*24));
   return result.intValue();   
 }
 
 public String Right(String str ,int n)
 {
 	return str.substring(str.length()-2);
 }
%>
<%
Conn conn = new Conn(connname);
Calendar cal = Calendar.getInstance();
String today = cal.get(cal.YEAR)+"-"+(cal.get(cal.MONTH)+1)+"-"+cal.get(cal.DATE);
//===========================================================================
String NewYear,NewMonth,NewDay;
NewYear = Integer.toString(cal.get(cal.YEAR));
NewMonth = Integer.toString(cal.get(cal.MONTH)+1);
NewDay = Integer.toString(cal.get(cal.DATE));

if (NewYear.length()<=2)	NewYear="20" + NewYear;
if (NewMonth.length()<=1)	NewMonth="0" + NewMonth;
if (Integer.parseInt(NewDay)<=9)				NewDay="0" + NewDay;
//===========================================================================  基本统计数据
int DayTotal = 0;
ResultSet rs = conn.executeQuery("Select count(*) from cms_stat_daycount" + " where site_code=" + StrUtil.sqlstr(siteCode));
if (rs!=null && rs.next())
	DayTotal = rs.getInt(1);                             			//获得统计总天数
else
	DayTotal = 0;
if (rs!=null)	rs.close();
rs = conn.executeQuery("Select * from cms_stat_count" + " where site_code=" + StrUtil.sqlstr(siteCode));
java.util.Date StartDate,LogDate=null;
int ToDay=0,TotalDays=0;
if (rs!=null && rs.next())
{
	StartDate = rs.getDate("StartDate");                                 //开始统计日期
	DayMax    = rs.getInt("DayMax");                                     //最高一天流量
	AllCount  = rs.getInt("AllCount");                                   //统计访问总数(使用的天数)
	ToDay     = rs.getInt("Todaycount");                                 //今天访问流量
	LogDate   = rs.getDate("LogDate");                              	    //统计截止日期
	TotalDays = DateDiff(StartDate,new java.util.Date())+1;         		//统计访问日期数(不管有没有使用，从开始统计算起.)
	Avera     = rs.getInt("AllCount") % TotalDays;                  		//日均访问流量
}
if (rs!=null) rs.close();
if (DateDiff(LogDate,new java.util.Date())>=1) ToDay = 0;

//===========================================================================  预计一天访问量
int intending=(ToDay/(cal.get(cal.HOUR)+1)*(24-cal.get(cal.HOUR)-1)+ToDay);

//===================================================================
String DayID,MonID,YearID;
boolean MyDay;
DayID = request.getParameter("day");
MonID = request.getParameter("mon");

if (DayID==null || !fchar.isNumeric(DayID))
{
     DayID  = NewDay;
     MyDay  = false;
}
else
{
     DayID = DayID.trim();
	 MyDay  = true;
}
if (MonID==null || !fchar.isNumeric(MonID))
{
	MonID = NewYear + NewMonth;
}
else
	MonID = MonID.trim();
YearID = MonID.substring(0,4);
String Mon = MonID.substring(MonID.length()-2);
String dToday = YearID + "-" + Mon;
if (DayID.length()<=1)
	DayID = "0" + DayID;
if (MonID.length()<=1)
	MonID = "0" + MonID;	
%>
<%
//===========================================================================
%>
<html>
<head>
<title>统计系统</title>
<%@ include file="../../inc/nocache.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="../../common.css" type="text/css">
<script language="javascript" src="../../inc/common.js"></script>
<LINK href="../default.css" type=text/css rel=stylesheet>
<style type="text/css">
<!--
BODY {font-size:9pt;font-family:Tahoma,Verdana,MS Sans Serif,Courier New;}
A:link,A:visited{text-decoration:none;}
A:hover {text-decoration:underline;}
A:hover {text-decoration:overline;color:#FFFF00}
TR,TD,P{font-size:9pt}
B{color:#E1005D;}
INPUT.text,INPUT.file,SELECT,TEXTAREA{color:#000000;background-color:#FFFFFF;border:1 solid #220430}
#TITLE{height:20;Filter: shadow(color=#00AAFF,direction=135);}
.notice{position:relative;height:50;overflow:visible;border:0;z-index:2}
FONT.table{color:#000000}
FONT.strong{color:#FFFFEE;font-weight:bold}
.footer{color:#FFFFEE;font-size:8pt}
.info,.title{background-color:#002F90}
.outter{background-color:#350682}
.cell{background-color:#9B9D9A}
FONT.search{color:#FFFFFF}
FONT.notice{color:#FFFFFF}
.retable{background-color:#FFFFFF}
.rcontent{background-color:#F0F0F0}
FONT.small{font-size:7pt}
.style1 {color: #0000FF}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<DIV id="tabBar">
  <div class="tabs">
    <ul>
      <li id="menu1"><a href="<%=request.getContextPath()%>/cms/counter/showcount.jsp">首页访问统计</a></li>
      <li id="menu2"><a href="<%=request.getContextPath()%>/cms/visit_column_statistic.jsp">栏目访问统计</a></li>
      <li id="menu3"><a href="<%=request.getContextPath()%>/cms/visit_dir_statistic.jsp">目录访问统计</a></li>
      <li id="menu4"><a href="<%=request.getContextPath()%>/cms/visit_doc_statistic.jsp">文章访问统计</a></li>
      <li id="menu5"><a href="<%=request.getContextPath()%>/cms/visit_ip_statistic.jsp">来访者位置</a></li>	  
    </ul>
  </div>
</DIV>
<script>
$("menu1").className="active"; 
</script>
<%
//==========================================================================
String CountLink = request.getContextPath()+"/cms/counter/ViewInfo.jsp"; //查看统计结果的连接。
String ImageLink = request.getContextPath()+"/cms/counter";              //图片地址
%>
<table width="600" border="0" cellpadding="0" cellspacing="0" align="center" height="48">
  <tr>
    <td align="center"><font color="#000000">今日: <%=today%>&nbsp;<img src="<%=ImageLink%>/theme/default/vstatb.gif"> &nbsp;全部: <%=AllCount%>&nbsp;<img src="<%=ImageLink%>/theme/default/hstatt.gif"> &nbsp;最高: <%=DayMax%>&nbsp;<img src="<%=ImageLink%>/theme/default/vstatg.gif"> &nbsp;日均: <%=Avera%>
      <%
		String ScriptName = request.getRequestURL().toString();
	 %>
     </font>	 </td>
  </tr>
</table>
<table width="600" border="0" class="p9" align="center" cellpadding="0" cellspacing="0">
  <tr class=info>
    <td align="right"><font class=strong><%=YearID%> 年 <%=Mon%> 月 日统计</font> </td>
  </tr>
</table>
<table cellspacing='0' cellpadding='0' width='600' border='0' class="p9" align="center">
  <tr align=center valign=bottom>
    <%//===========================================================================
		String mondays = ",31,28,31,30,31,30,31,31,30,31,30,31";
		String[] lastday = mondays.split(",");
        if (((Integer.parseInt(YearID) % 4 == 0) && (Integer.parseInt(YearID) % 100 != 0)) || (Integer.parseInt(YearID) % 400 == 0))
			lastday[2] = "29";
		
        String StrSQL="Select * From cms_stat_monthcount Where ID = " + MonID + " and site_code=" + StrUtil.sqlstr(siteCode);
        ResultSet MyCount = conn.executeQuery(StrSQL);

        if (!MyCount.next())
             out.println( "<TD align=center>没有统计数据</TD>");
        else
		{
             String weekstr = "Sun,Mon,Tue,Wed,Thu,Fri,Sat";
			 String[] Wday = weekstr.split(",");
			 int Dmax = 0;
			 Calendar ca =  Calendar.getInstance();
             for (int n = 1; n<=Integer.parseInt(lastday[Integer.parseInt(Mon)]); n++) {
                    if (Dmax<MyCount.getInt(n+1))
						Dmax = MyCount.getInt(n+1);
					ca.set(Integer.parseInt(YearID),Integer.parseInt(Mon)-1,n);
					int intSday = ca.get(Calendar.DAY_OF_WEEK)-1;
					String Sday = "";
                    if (intSday == 0 || intSday == 6)
                          Sday = "<font color=red>" + Wday[intSday] + "</font>";
                    else
                          Sday = ""+Wday[intSday];
                   %>
    				<td width="563" class="rcontent"><nobr><font class=small><%=Sday%></font></td>
    		<%
             }
             %>
  </tr>
  <tr align=center valign=bottom>
    <%
			 String Images = "";
             for (int n = 1;n<=Integer.parseInt(lastday[Integer.parseInt(Mon)]);n++)
			 {
                    int iDay = MyCount.getInt(n+1);
                    %>
    <td width="563" class="rcontent"><font class=small><nobr>
      <%
                    if( iDay>0 )
						out.println(iDay);
                    %>
      </nobr></font><br>
      <%
                    if (iDay == Dmax)
                          Images = "vstath.gif" ;
                    else if (n == Integer.parseInt(NewDay))
                          Images = "vstatd.gif";
                    else if (n == Integer.parseInt(DayID))
                          Images = "vstatp.gif";
                    else
                          Images = "vstatt.gif";
                    int height = (int)iDay*300/Dmax;
                    %>
      <IMG Src="<%=ImageLink%>/theme/default/<%=Images%>" height="<%=height%>" width='10'></TD>
    <%
              }
              %>
  </TR>
  <TR align=center>
    <%
              String strn = "";
              for (int n = 1; n<=Integer.parseInt(lastday[Integer.parseInt(Mon)]); n++)
			  {
					 strn = ""+n;
					 if (n<=9) strn = "" + n;
                     %>
    <TD width="563" class="rcontent"><a href="<%=ScriptName%>?mon=<%=MonID%>&day=<%=strn%>"><%=strn%></a></TD>
    <%
              }
        }
        MyCount.close();
       %>
  </TR>
</table>
<table class="p9" width="600" align="center" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td colspan=2 align=center>点击日期可查看当日时间访问统计.如果没有选择日期.将显示一个月内的所有时间统计</td>
  </tr>
  <tr class=info>
    <td colspan=2 align=right><font class=strong><%=YearID%> 年 <%=Mon%> 月
      <%if (MyDay) out.println(DayID + "日");%>
      时间统计</font></td>
  </tr>
  <%
        StrSQL="Select * From cms_stat_daycount Where";
        if (MyDay)
              StrSQL = StrSQL + " ID = " + MonID + DayID;
        else
              StrSQL = StrSQL + " " + SQLFilter.left("ID", 6) + "=" + MonID;
		StrSQL += " and site_code=" + StrUtil.sqlstr(siteCode);
        MyCount = conn.executeQuery(StrSQL);
        // System.out.println(StrSQL);
        if (conn.getRows()==0)
            out.println("<tr class=rcontent><td colspan=2 align=center>没有统计数据</TD></TR>");
        else
		{
            int d[] = new int[25];
			int dtotal = 0;
			int Tmax = 0;
			int TWidth = 0;
			String Images = "";
            while (MyCount.next())
			{
                for (int i = 1; i<=24; i++)
                    d[i] = MyCount.getInt(i+1) + d[i];
            }
            for (int x = 1; x<=24; x++)
			{
                 dtotal = d[x] + dtotal;
                 if (Tmax < d[x]) 	Tmax=d[x];
            }
			Calendar ca = Calendar.getInstance();

            for (int n = 1; n<=24; n++)
			{
     			  //ca.set(Integer.parseInt(YearID),Integer.parseInt(MonID),Integer.parseInt(DayID));
                  if (n-1 == ca.get(Calendar.HOUR_OF_DAY))
                        Images = "vstatb.gif" ;
                  else if (d[n] == Tmax)
                        Images = "vstatg.gif" ;
                  else
                        Images = "hstatt.gif";
                  TWidth = (int)350 * d[n]/Tmax;
				  %>
  <tr class=rcontent>
    <td align=center><%=Right("0" + (n-1),2)%>:00 ~ <%=Right("0" + n,2)%></TD>
    <TD><IMG src="<%=ImageLink%>/theme/default/<%=Images%>" height='10' width="<%=TWidth%>">
      <%if (d[n]>0) out.println(d[n]);
                  out.println("(" + Percent(d[n],dtotal) + ")");%>
    </TD>
  </TR>
  <%
            }
        }
        MyCount.close();
%>
  <tr class=info>
    <td colspan=2 align=right><font class="strong" color="#FFFFFF"><%=YearID%> 年 月统计</font></td>
  </tr>
  <%
        StrSQL="Select * from cms_stat_yearcount Where ID = " + YearID + " and site_code=" + StrUtil.sqlstr(siteCode);
        MyCount = conn.executeQuery(StrSQL);
		int Mmax = 0;
		int iMon = 0;
        if ( !MyCount.next())
             out.println("<tr class=rcontent><TD colspan=2 align=center>没有统计数据</TD></TR>");
        else
		{
             int mtotal = 0;
			 String Images = "";
			 for (int i=1; i<=12; i++)
			 {
                 mtotal += MyCount.getInt(i+1);
                 if (Mmax < MyCount.getInt(i+1)) 	Mmax=MyCount.getInt(i+1);
             }
             for (int n = 1; n<=12; n++)
			 {
				 iMon = MyCount.getInt(n+1);
                 if (iMon>0)
				 {
                      if (n == Integer.parseInt(NewMonth))
                             Images = "vstatb.gif";
                      else if (n == Integer.parseInt(Mon))
                             Images = "vstatk.gif";
                      else if (iMon == Mmax)
                             Images = "vstatg.gif";
                      else
                             Images = "hstatt.gif";
                      int MWidth = (int)350*iMon/Mmax;
					  %>
  <tr class=rcontent>
    <td align=center><%if (iMon!=0)
                           out.println("<a href='" + ScriptName + "?mon=" + YearID + Right("0" + n,2) + "'>");
                      out.println(YearID + "-" + Right("0" + n,2) +" ~ " +  lastday[n] + "</a>");%>
    </TD>
    <TD><IMG src="<%=ImageLink%>/theme/default/<%=Images%>" height='10' width="<%=MWidth%>">
      <%if (iMon > 0) 	out.println(iMon);%>
      (<%=Percent(iMon,mtotal)%>)</TD>
  </TR>
  <%
                 }
			}
        }
		if (MyCount!=null) {
			MyCount.close();
			MyCount = null;
		}
        conn.close();
%>
</table>
<table width="600" border="0" class="p9" cellpadding="0" align="center">
  <tr>
    <td align="center" height="42"><%!
public String Percent(int St,int Sz)
{
       double Str = (double)St / Sz * 100;
       return cn.js.fan.util.StrUtil.FormatPrice(Str)+"%";
}
%>
      截止日期: <%=LogDate%>, 统计天数: <%=DayTotal%>/<%=TotalDays%> 天, 预计本日访问量: <%=intending%> 人 </td>
  </tr>
</table>
</body>
</html>
