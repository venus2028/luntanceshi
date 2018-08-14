<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="../manager/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>我的订单列表</title>
<body topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="com.redmoon.forum.plugin.auction.Directory"/>
<%
if (!privilege.isUserPrivValid(request, "auction"))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	int orderId = ParamUtil.getInt(request, "orderId");
	
	AuctionOrderDb aod = new AuctionOrderDb();
	aod = aod.getAuctionOrderDb(orderId);
	if (aod.del()) {
		out.print(StrUtil.Alert_Redirect("操作成功", "order.jsp"));
	}
	else {
		out.print(StrUtil.Alert_Back("操作失败！"));
	}
	return;
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">
	查看订单</td>
  </tr>
</table>
<br>
<%
int pagesize = 10;
Paginator paginator = new Paginator(request);

AuctionOrderDb ao1 = new AuctionOrderDb();
String sql = "select id from " + ao1.getTableName() + " order by orderDate desc";	
String type = ParamUtil.get(request, "type");
if (op.equals("search")) {
	if (type.equals("orderId")) {
		int orderId = 0;
		boolean re = false;
		try {
			orderId = ParamUtil.getInt(request, "what");
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert("请输入正确的流水号！"));
		}
		if (re)
			sql = "select id from " + ao1.getTableName() + " where id=" + orderId + " order by orderDate desc";	
	}
	if (type.equals("seller")) {
		String seller = ParamUtil.get(request, "what");
		sql = "select id from " + ao1.getTableName() + " where seller like " + StrUtil.sqlstr("%" + seller + "%") + " order by orderDate desc";	
	}
	if (type.equals("buyer")) {
		String buyer = ParamUtil.get(request, "what");
		sql = "select id from " + ao1.getTableName() + " where buyer like " + StrUtil.sqlstr("%" + buyer + "%") + " order by orderDate desc";	
	}
}

int total = ao1.getObjectCount(sql);
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
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">查看订单明细</td>
  </tr>
  <tr> 
    <td valign="top"><table width="86%"  border="0" align="center">
      <tr>
        <td align="center"> <form name="form1" method="post" action="?op=search">
          按
              <select name="type">
			  <option value=orderId selected>按流水号</option>
			  <option value=seller>按卖家</option>
			  <option value=buyer>按买家</option>
              </select>
              <input name=what size=12>
          &nbsp;
          <input type="submit" name="Submit" value=" 搜 索 ">
        </form></td>
      </tr>
    </table>
      <br>      <table width="86%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td align="right"><div>找到符合条件的记录 <b><%=paginator.getTotal() %></b> 条　每页显示 <b><%=paginator.getPageSize() %></b> 条　页次 <b><%=paginator.getCurrentPage() %>/<%=paginator.getTotalPages() %></b></div></td>
      </tr>
    </table>
          <table width="86%"  border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#666666" class="tableframe_gray">
        <tr align="center" bgcolor="#F1EDF3">
          <td width="19%" height="22">流水号</td>
          <td width="22%" height="22">商品名称</td>
          <td width="29%" height="22">订单生成时间</td>
          <td width="30%">操作</td>
        </tr>
<%
Vector v = ao1.list(sql, (curpage-1)*pagesize, curpage*pagesize-1);

Iterator ir = v.iterator();
int i = 0;
while (ir.hasNext()) {
	AuctionOrderDb ao = (AuctionOrderDb)ir.next();
	i++;
%>
        <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
          <tr align="center">
            <td height="22" bgcolor="#FFFFFF">
                <%=ao.getId()%>            </td>
            <td height="22" bgcolor="#FFFFFF"><%=ao.getCommodityName()%></td>
            <td height="22" bgcolor="#FFFFFF"><%=DateUtil.format(ao.getOrderDate(), "yy-MM-dd HH:mm:ss")%>
            </td>
            <td height="22" bgcolor="#FFFFFF">
			<a href="../showorder.jsp?orderId=<%=ao.getId()%>">查看明细</a> &nbsp;&nbsp;<a href="javascript:if (confirm('您确定要删除吗？')) window.location.href='order.jsp?op=del&orderId=<%=ao.getId()%>'">删除</a></td>
          </tr>
        </form>
        <%}%>
      </table>
          <table width="86%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
            <tr>
              <td height="23"><div align="right">
<%
	String querystr = "op=" + op + "&type=" + StrUtil.UrlEncode(type);
    out.print(paginator.getCurPageBlock("?"+querystr));
%>
              </div></td>
            </tr>
    </table></td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
                               
</body>                                        
</html>                            
  