<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="org.jdom.*"%>
<%@ page import="org.jdom.output.*"%>
<%@ page import="org.jdom.input.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="cn.js.fan.web.Global"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="java.util.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
if (!cfg.getBooleanProperty("forum.canScoreExchange")) {
	response.sendRedirect("../info.jsp?info=" + StrUtil.UrlEncode(SkinUtil.LoadString(request, "res.label.forum.score_exchange", "score_exchange_forbided")));
	return;
}
String skinPath = SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><lt:Label res="res.label.forum.score_exchange" key="score_exchange"/> - <%=Global.AppName%></title>
<link href="<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
</head>
<body>
<div id="wrapper">
<%@ include file="inc/header.jsp"%>
<div id="main">
<br>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<%
	String querystring = StrUtil.getNullString(request.getQueryString());
	String privurl=request.getRequestURL()+"?"+StrUtil.UrlEncode(querystring,"utf-8");
	if (!privilege.isUserLogin(request))
	{
		response.sendRedirect("../door.jsp");
		return;
	}

	ScoreExchangeConfig secfg = new ScoreExchangeConfig();
	String tax = secfg.getProperty("tax");
	String exchangeMin = secfg.getProperty("exchangemin");
%>
<FORM name="form1" action="score_do.jsp?op=exchange" method="post">
<TABLE class="tableCommon" width="98%" align="center" cellPadding=3 cellSpacing=0>
	<thead>
      <TR> 
        <TD height=22 colSpan=2><lt:Label res="res.label.forum.score_exchange" key="score_exchange"/></TD>
      </TR>
	</thead>
    <TBODY>
      <TR>
        <TD width="27%" height=24 align="right"><lt:Label res="res.label.forum.score_exchange" key="score_value"/>&nbsp;&nbsp;&nbsp;</TD>
        <TD width="73%" height=24 vAlign=top>&nbsp; 
        <input size=40 name="value"></TD>
      </TR>
      <TR> 
        <TD 
    height=24><P align=right><FONT style="FONT-SIZE: 9pt">
        <lt:Label res="res.label.forum.score_exchange" key="from_score"/></FONT> 
        &nbsp; </P></TD>
        <TD vAlign=top height=24>
		&nbsp;
		<select name="fromScore">
		<%
			String code="", name="";
			boolean exchange = false;
			int ratio = 0, i = 0;
			ScoreMgr sm = new ScoreMgr();
			Vector vt = sm.getAllScore();
			if (vt != null) {
			    int len = vt.size();
				Iterator ir = vt.iterator();
				String arr[][] = new String[len][2];
				while (ir.hasNext()) {
					ScoreUnit su = (ScoreUnit) ir.next();
					code = su.getCode();
					name =  su.getName();
					exchange = su.isExchange();
					ratio =  su.getRatio(); 
					arr[i][0] = code;
                    arr[i][1] = Integer.toString(ratio);
					if(exchange){
					
		%>
			<option value="<%=code%>"><%=name%>(<lt:Label res="res.label.forum.score_exchange" key="ratio"/><%=ratio%>)</option>
		<%
		            }
					i++;
				}				
				out.println("<script language='javascript'>");
				out.println("var fromArr = new Array("+len+");");
				for(int j = 0; j < len; j++){
					out.println("var arr1 = new Array(2);");
					out.println("arr1[0] = '"+ arr[j][0] + "';");
					out.println("arr1[1] = '"+ arr[j][1] + "';");
					out.println("fromArr[" + j + "] = arr1;");
				}
				out.println("</script>");
			}
		%>
		</select>		</TD>
      </TR>
      <TR> 
        <TD 
    height=24> <P align=right><SPAN style="FONT-SIZE: 9pt">&nbsp;&nbsp;&nbsp;&nbsp; 
            <lt:Label res="res.label.forum.score_exchange" key="to_score"/></SPAN>
        &nbsp; </P></TD>
        <TD vAlign=top height=22>&nbsp;
		<select name="toScore">
		<%
		    i = 0;
			if (vt != null) {
			    int len = vt.size();
				Iterator ir = vt.iterator();
				String arr[][] = new String[len][2];
				while (ir.hasNext()) {
					ScoreUnit su = (ScoreUnit) ir.next();
					code = su.getCode();
					name =  su.getName();
					exchange = su.isExchange();
					ratio =  su.getRatio();
					arr[i][0] = code;
                    arr[i][1] = Integer.toString(ratio);
					if(exchange){
		%>
			<option value="<%=code%>"><%=name%>(<lt:Label res="res.label.forum.score_exchange" key="ratio"/><%=ratio%>)</option>
		<%
		            }
					i++;
				}
				out.println("<script language='javascript'>");
				out.println("var toArr = new Array("+len+");");
				for(int j = 0; j < len; j++){
					out.println("var arr2 = new Array(2);");
					out.println("arr2[0] = '"+ arr[j][0] + "';");
					out.println("arr2[1] = '"+ arr[j][1] + "';");
					out.println("toArr[" + j + "] = arr2;");
				}
				out.println("</script>");
			}
		%>
		</select>	    </TD>
      </TR>
      <TR> 
        <TD 
    height=24> <P align=right><FONT style="FONT-SIZE: 9pt" 
      color=#000000>
        <lt:Label res="res.label.forum.score_exchange" key="exchange_min"/>&nbsp;</FONT>&nbsp; </P></TD>
        <TD vAlign=center height=23>&nbsp;
		<%=exchangeMin%>	    </TD>
      </TR>
      <TR> 
        <TD align=right height=24><FONT style="FONT-SIZE: 9pt" color=#000000>
        <lt:Label res="res.label.forum.score_exchange" key="tax"/>&nbsp;&nbsp;</FONT></TD>
        <TD vAlign=center height=26>&nbsp;
        <%=tax%>		</TD>
      </TR>
      <TR align="left">
        <TD colSpan=2 height=24><lt:Label res="res.label.forum.score_exchange" key="instruction"/></TD>
      </TR>
      <TR align="center"> 
        <TD colSpan=2 height=22><INPUT type="button" value="<lt:Label res="res.label.forum.score_exchange" key="count"/>" onClick="count()">&nbsp;<INPUT type="submit" value="<lt:Label res="res.label.forum.score_exchange" key="exchange"/>"></TD>
      </TR>
  </TBODY>
</TABLE>
</FORM>
</div>
<%@ include file="inc/footer.jsp"%>
</div>
</body>
<script>
function count(){
     for(var i = 0; i<fromArr.length; i++){
	 	if(form1.fromScore.value == fromArr[i][0]){
			for(var j = 0; j<toArr.length; j++){
				if(form1.toScore.value == toArr[j][0]){
					alert(Math.floor(form1.value.value * fromArr[i][1] * (1 - <%=tax%>) / toArr[j][1]));
					return;
				}
			}
		}
	 }

}
</script>
</html>
