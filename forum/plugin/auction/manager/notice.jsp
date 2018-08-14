<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="com.redmoon.forum.plugin.info.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>公告管理</title>
<script language="JavaScript">
<!--

//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");
String userName = privilege.getUser(request);

if (op.equals("modify")) {
	int id = ParamUtil.getInt(request, "id");
	String typeCode = ParamUtil.get(request, "typeCode");
	if (typeCode.equals("")) {
		out.print(StrUtil.Alert("请选择信息类型！"));
	}
	else {
		InfoDb infoDb = new InfoDb();
		infoDb = infoDb.getInfoDb(id);
		if (infoDb.isLoaded()) {
			infoDb.setTypeCode(typeCode);
			if (infoDb.save())
				out.print(StrUtil.Alert("修改成功！"));
			else
				out.print(StrUtil.Alert("修改失败！"));
		}
		else {
			out.print(StrUtil.Alert("该信息不存在！"));
		}
	}
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理目录</td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">
	公告信息
	</td>
  </tr>
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

InfoDb infoDb = new InfoDb();

String sql = "select id from " + infoDb.getTableName() + " where userName=" + StrUtil.sqlstr(userName) + " order by addDate desc";

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
      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFBFF" class="tableframe_gray">
      <tr align="center">
        <td width="9%" height="22">编号</td>
      <td width="41%" height="22">标题</td>
        <td width="13%" height="22">类型</td>
      <td width="20%">日期</td>
        <td width="17%">操作</td>
      </tr>
<%
String querystr = "userName=" + StrUtil.UrlEncode(userName);

Vector v = infoDb.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);
Iterator ir = v.iterator();
int i = 0;
MsgDb md = new MsgDb();
while (ir.hasNext()) {
	infoDb = (InfoDb)ir.next();
	md = md.getMsgDb(infoDb.getId());
	i++;
%>
	<form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
      <tr align="center">
        <td height="28"><%=infoDb.getId()%><input type=hidden name="id" value="<%=infoDb.getId()%>">
		</td>
        <td height="28"><%=md.getTitle()%>
		</td>
        <td height="28">
		<select name=typeCode>
		<option value="">请选择类型</option>
		<%
        Leaf lf = new Leaf();
        lf = lf.getLeaf(Leaf.CODE_ROOT);
        DirectoryView dv = new DirectoryView(lf);
        StringBuffer sb = new StringBuffer();
        dv.ShowDirectoryAsOptionsToString(sb, lf, lf.getLayer());
		%>
		<%=sb%>
		</select>
		<script>
		form<%=i%>.typeCode.value = "<%=infoDb.getTypeCode()%>";
		</script>
		</td>
      <td>
	  <%=DateUtil.format(infoDb.getAddDate(), "yy-MM-dd HH:mm:ss")%>
      <input type=hidden name=userName value="<%=userName%>">
</td>
        <td height="28"><input type="submit" name="Submit" value="修改">
&nbsp;<a href="../../../showtopic.jsp?rootid=<%=infoDb.getId()%>" target="_blank">查看</a></td>
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
                               
</body>                                        
</html>                            
  