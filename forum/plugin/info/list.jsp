<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.redmoon.forum.plugin.info.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.person.UserSet"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skinPath = SkinMgr.getSkinPath(request);
%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="pragma" content="no-cache">
<link href="../../<%=skinPath%>/css.css" rel="stylesheet" type="text/css">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=Global.AppName%> - 信息列表</title>
<body>
<div id="wrapper">
<%@ include file="../../inc/header.jsp"%>
<div id="main">
<%
String code = ParamUtil.get(request, "code");
%>
<table width='98%' height="26" align="center" cellpadding='0' cellspacing='0' class="tableCommon" >
  <tr>
    <td class="head">&nbsp;【
	<%if (code.equals("")) {%>
	<a href='?'><font color=red>全部</font></a>
	<%}else{%>
	<a href='?'>全部</a>
	<%}%>
	】&nbsp;&nbsp;

	</td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="per100">
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

InfoDb infoDb = new InfoDb();

String sql = "";
if (code.equals(""))
	sql = "select id from " + infoDb.getTableName() + " order by addDate desc";
else
	sql = "select id from " + infoDb.getTableName() + " where typeCode=" + StrUtil.sqlstr(code) + " order by addDate desc";

int total = infoDb.getObjectCount(sql);
paginator.init(total, pagesize);
int curpage = paginator.getCurPage();
//设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0)
{
	curpage = 1;
	totalpages = 1;
}
%>  
  <tr> 
    <td valign="top"><br>
      <table width="95%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td align="right"><div>找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></div></td>
        </tr>
      </table>
      <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" class="tableCommon">
	  <thead>
      <tr>
        <td width="9%" height="22">编号</td>
      <td width="41%" height="22">标题</td>
        <td width="13%" height="22">类型</td>
      <td width="20%">日期</td>
        <td width="17%">操作</td>
      </tr>
	  </thead>
<%
String querystr = "code=" + StrUtil.UrlEncode(code);

Vector v = infoDb.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);
Iterator ir = v.iterator();
int i = 0;
MsgDb md = new MsgDb();
while (ir.hasNext()) {
	infoDb = (InfoDb)ir.next();
	md = md.getMsgDb((long)infoDb.getId());
	i++;
%>
	<form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
      <tr align="center">
        <td height="28"><%=infoDb.getId()%><input type=hidden name="id" value="<%=infoDb.getId()%>">
		</td>
        <td height="28"><%=md.getTitle()%>
		</td>
        <td height="28">
		<%=infoDb.getTypeName()%>
		</td>
      <td>
	  <%=DateUtil.format(infoDb.getAddDate(), "yy-MM-dd HH:mm:ss")%>
	  </td>
        <td height="28"><a href="../../showtopic.jsp?rootid=<%=infoDb.getId()%>">查看</a></td>
      </tr></form>
<%}%>	  
    </table>
      <table width="87%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr>
          <td height="23"><div align="right">
              <%
    out.print(paginator.getCurPageBlock("?"+querystr));
%>
          </div></td>
        </tr>
      </table>
      <br>
    </td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
</div>
<%@ include file="../../inc/footer.jsp"%>
</div>                      
</body>                                        
</html>                            
  