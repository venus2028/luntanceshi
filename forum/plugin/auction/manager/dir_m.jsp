<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../../inc/inc.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>商品目录管理</title>
<script language="JavaScript">
<!--

//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
<body topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="dir" scope="page" class="com.redmoon.forum.plugin.auction.Directory"/>
<%
if (!privilege.isUserLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String userName = ParamUtil.get(request, "userName");
if (userName.equals("")) {
	out.print(StrUtil.Alert("用户名不能为空！"));
	return;
}
String user = privilege.getUser(request);
if (!userName.equals(user)) {
	if (!privilege.isMasterLogin(request)) {
		out.print(StrUtil.Alert("对不起，您无权访问！"));
		return;
	}
}

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	String code = "";
	String dirName = "";
	String catalogCode = "";
	boolean re = false;
	try {
		code = RandomSecquenceCreator.getId(20);
		dirName = ParamUtil.get(request, "dirName");
		catalogCode = ParamUtil.get(request, "catalogCode");
		boolean isValid = true;
		if (dirName.equals("") || catalogCode.equals("") || catalogCode.equals("not")) {
			out.print(StrUtil.Alert_Back("目录名称和所属类别必填！"));
			return;
		}

		if (isValid) {
			AuctionShopDirDb asd = new AuctionShopDirDb();
			asd.setCode(code);
			asd.setDirName(dirName);
			asd.setCatalogCode(catalogCode);
			asd.setUserName(userName);
			re = asd.create();
		}
	}
	catch (ResKeyException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert_Redirect("创建成功！", "dir_m.jsp?userName=" + StrUtil.UrlEncode(userName)));
	}
}

if (op.equals("modify")) {
	String code = "";
	String dirName = "";
	String catalogCode = "";
	boolean re = false;
	try {
		code = ParamUtil.get(request, "code");
		dirName = ParamUtil.get(request, "dirName");
		catalogCode = ParamUtil.get(request, "catalogCode");
		boolean isValid = true;
		if (code.equals("") || dirName.equals("") || catalogCode.equals("")) {
			out.print(StrUtil.Alert("编码和目录名称必填！"));
		}
		if (isValid) {
			AuctionShopDirDb asd = new AuctionShopDirDb();
			asd = asd.getAuctionShopDirDb(privilege.getUser(request), code);
			asd.setCode(code);
			asd.setDirName(dirName);
			asd.setCatalogCode(catalogCode);
			asd.setUserName(userName);
			re = asd.save();
		}
	}
	catch (ResKeyException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert_Redirect("修改成功！", "dir_m.jsp?userName=" + StrUtil.UrlEncode(userName)));
	}
}

if (op.equals("del")) {
	String code = "";
	boolean re = false;
	try {
		code = ParamUtil.get(request, "code");
		boolean isValid = true;
		if (code.equals("")) {
			out.print(StrUtil.Alert("编码和目录名称必填！"));
		}
		if (isValid) {
			AuctionShopDirDb asd = new AuctionShopDirDb();
			asd = asd.getAuctionShopDirDb(privilege.getUser(request), code);
			asd.setCode(code);
			asd.setUserName(userName);
			re = asd.del();
		}
	}
	catch (ResKeyException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert("删除成功！如果该目录下有商品，则已被转至default目录下了！"));
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
    <td height=20 align="left" class="thead">管理商品目录</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <table width="86%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#666666" class="tableframe_gray">
      <tr align="center">
        <td width="22%" height="26" bgcolor="#EDE3EE">目录名称</td>
        <td width="29%" height="26" bgcolor="#EDE3EE">所属类别</td>
      <td width="30%" bgcolor="#EDE3EE">操作</td>
      </tr>
      <tr align="center" bgcolor="#FFFFFF">
        <td width="22%" height="22">系统默认目录</td>
        <td width="29%" height="22">默认</td>
      <td width="30%"><a href="commodity_m.jsp?code=<%=AuctionShopDirDb.DEFAULT%>&userName=<%=StrUtil.UrlEncode(userName)%>">管理</a></td>
      </tr>
<%
AuctionShopDirDb sb1 = new AuctionShopDirDb();
Vector v = sb1.list(userName);
Iterator ir = v.iterator();
int i = 0;
while (ir.hasNext()) {
	AuctionShopDirDb as = (AuctionShopDirDb)ir.next();
	i++;
%>
	<form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
      <tr align="center" bgcolor="#FFFFFF">
        <td height="22"><input type=hidden name=code value="<%=as.getCode()%>">
        <input name=dirName value="<%=as.getDirName()%>" size=8></td>
        <td height="22">
		  <script>
		  var bcode<%=i%> = "<%=as.getCatalogCode()%>";
		  </script>
		  <select name="catalogCode" onChange="if(this.options[this.selectedIndex].value=='not'){alert(this.options[this.selectedIndex].text+' 不能被选择！'); this.value=bcode<%=i%>; return false;}">
             <option value="not" selected>请选择您的目录所属的类别</option>
                <%
				Leaf lf = dir.getLeaf("root");
				DirectoryView dv = new DirectoryView(lf);
				dv.ShowDirectoryAsOptions(out, lf, lf.getLayer());
				%>
            </select>
			<script>
			form<%=i%>.catalogCode.value = "<%=as.getCatalogCode()%>";
			</script>		</td>
      <td height="22"><input type=hidden name="userName" value="<%=userName%>">
      <input type="submit" name="Submit" value="修改">
        <a href="commodity_m.jsp?code=<%=StrUtil.UrlEncode(as.getCode())%>&userName=<%=StrUtil.UrlEncode(userName)%>">管理</a>&nbsp;&nbsp;&nbsp;<a href="?op=del&code=<%=StrUtil.UrlEncode(as.getCode())%>&userName=<%=StrUtil.UrlEncode(userName)%>">删除</a></td>
      </tr></form>
<%}%>	  
    </table>
      <table width="77%"  border="0" align="center" cellpadding="5">
        <tr>
          <td>注意：<span class="style1">删除目录</span>并不会连目录下的商品一起删除，而是将其转移至default目录下了，请手工删除其对应的商品</td>
        </tr>
      </table>
      <br>
      <table width="86%"  border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
	  <form action="?op=add" method=post>
        <tr>
          <td width="178" align="right">
		  <script>
		  var bcode = "not";
		  </script>
		  <select name="catalogCode" onChange="if(this.options[this.selectedIndex].value=='not'){alert(this.options[this.selectedIndex].text+' 不能被选择！'); this.value=bcode; return false;}">
                      <option value="not" selected>请选择您的目录所属的类别</option>
                      <%
				Leaf lf = dir.getLeaf("root");
				DirectoryView dv = new DirectoryView(lf);
				dv.ShowDirectoryAsOptions(out, lf, lf.getLayer());
				%>
            </select></td>
          <td width="371" align="left">
		  &nbsp;目录名称	
<input name=dirName size=8>
<input type="submit" name="Submit" value="添加"><input type=hidden name="userName" value="<%=userName%>"></td>
        </tr>
        <tr>
          <td height="22" colspan="2" align="center">( 目录中蓝色节点是可选的，其它节点不可选 )</td>
          </tr>
	  </form>
      </table>
      <br></td>
  </tr>
</table>
</body>                                        
</html>                            
  