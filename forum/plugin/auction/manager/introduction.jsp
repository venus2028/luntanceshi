<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<LINK href="default.css" type=text/css rel=stylesheet>
<title>修改简介</title>
<style type="text/css">
<!--
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
.style1 {
	font-size: 10pt;
	font-weight: bold;
}

-->
</style></head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.makeErrMsg("请先登录！"));
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

AuctionShopDb as = new AuctionShopDb();
as = as.getAuctionShopDb(userName);

String op = ParamUtil.get(request, "op");
if (op.equals("modify")) {
	String shopName = ParamUtil.get(request, "shopName");
	String address = ParamUtil.get(request, "address");
	String tel = ParamUtil.get(request, "tel");
	String desc = ParamUtil.get(request, "desc");
	String skinCode = ParamUtil.get(request, "skinCode");
	String contacter = ParamUtil.get(request, "contacter");
    int logoWidth = as.LOGO_NO_WIDTH;
	boolean isValid = true;
	try {
		if (shopName.equals(""))
			throw new ErrMsgException("店名不能为空！");
		if (address.equals(""))
			throw new ErrMsgException("地址不能为空！");
		if (tel.equals(""))
			throw new ErrMsgException("电话不能为空！");
		// if (desc.equals(""))
		//	throw new ErrMsgException("简介不能为空！");
		try {
            logoWidth = ParamUtil.getInt(request, "logoWidth");
        }
		catch (Exception e) {
		}
	}
	catch (ErrMsgException e) {
		isValid = false;
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (isValid) {
		as.setShopName(shopName);
		as.setTel(tel);
		as.setAddress(address);
		as.setDesc(desc);
		as.setLogoWidth(logoWidth);
		as.setSkinCode(skinCode);
		as.setContacter(contacter);
		if (as.save())
			out.print(StrUtil.Alert("修改成功！"));
		else
			out.print(StrUtil.Alert("修改失败！"));
	}
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">修改商铺信息</td>
  </tr>
</table>
<br>
<table width="57%"  border="0" align="center"cellspacing="1" cellpadding="5" bgcolor="#666666">
<form name="form1" method="post" action="?op=modify">
  <tr align="center" bgcolor="#F1EDF3">
    <td width="16%" height="22">店名</td>
    <td width="84%" align="left"><input name=shopName size=16 value="<%=as.getShopName()%>">
      <input type=hidden name=userName value="<%=userName%>">	</td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">模板</td>
    <td height="22" align="left">
	<select name="skinCode">
	<%
	AuctionConfig ac = new AuctionConfig();
	out.print(ac.getSkinOptions());
	%>
	</select>
	<script>
	form1.skinCode.value = "<%=as.getSkinCode()%>";
	</script>	</td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">地址</td>
    <td height="22" align="left"><input name=address size=40 value=<%=as.getAddress()%>></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">电话</td>
    <td height="22" align="left"><input name=tel size=10 value="<%=as.getTel()%>"></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">联系人</td>
    <td height="22" align="left"><input name=contacter size=16 value="<%=as.getContacter()%>"></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">宽度</td>
    <td height="22" align="left"><input name=logoWidth value="<%=as.getLogoWidth()%>" size=2>
像素 ( LOGO的宽度，如果宽度不设或置为0，将采用图片本来的宽度 ) </td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22">简介</td>
    <td height="22" align="left"><textarea name="desc" cols="45" rows="5"><%=as.getDesc()%></textarea></td>
  </tr>
  <tr align="center" bgcolor="#FFFFFF">
    <td height="22" colspan="2"><input type="submit" name="Submit" value="提交">
      &nbsp;&nbsp;&nbsp;&nbsp;
      <input type="reset" name="Submit" value="重置"></td>
  </tr></form>
</table>
<br>
<br>
<table width="57%"  border="0" align="center"cellspacing="1" cellpadding="5" bgcolor="#666666">
  <form name="form2" method="post" action="introduction_logo.jsp" enctype="MULTIPART/FORM-DATA">
    <tr align="center" bgcolor="#F1EDF3">
      <td height="22" colspan="2">修改本店标志图片( LOGO ) </td>
    </tr>
    <tr align="center" bgcolor="#FFFFFF">
      <td width="20%" height="22">选择</td>
      <td width="80%" height="22" align="left"><input type="file" name="filename">
      <input type=hidden name=userName value="<%=userName%>"></td>
    </tr>
    <tr align="center" bgcolor="#FFFFFF">
      <td height="22" colspan="2"><p>
  <input type="submit" name="Submit" value="  修改图片 ">
&nbsp;&nbsp;&nbsp;&nbsp; <br>
  ( 上传空文件将删除LOGO，宽度可以通过上一个编辑框中的LOGO宽度来调整 ) </p>
      <p>
	  <%
	  String img = as.getLogo();
	  if (img!=null && !img.equals("")) {
	  	String w = "";
		if (as.getLogoWidth()>as.LOGO_NO_WIDTH)
			w = "width=" + as.getLogoWidth();
			
		com.redmoon.forum.Config cfg = com.redmoon.forum.Config.getInstance();
        String attachmentBasePath = request.getContextPath() + "/" + cfg.getAttachmentPath() + "/";
        boolean isFtpUsed = cfg.getBooleanProperty("forum.ftpUsed");
        if (isFtpUsed) {
            attachmentBasePath = cfg.getProperty("forum.ftpUrl");
            if (attachmentBasePath.lastIndexOf("/")!=attachmentBasePath.length()-1)
                attachmentBasePath += "/";
        }			
	  %>
	  <img src="<%=attachmentBasePath + img%>" <%=w%>>
	  <%}%>
	  </p></td>
    </tr>
  </form>
</table>
</body>
</html>
