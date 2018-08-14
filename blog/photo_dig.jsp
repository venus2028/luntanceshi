<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.photo.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.score.*"%>
<%@ page import="org.jdom.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String skincode = UserSet.getSkin(request);
if (skincode.equals(""))
	skincode = UserSet.defaultSkin;
SkinMgr skm = new SkinMgr();
Skin skin = skm.getSkin(skincode);
if (skin==null)
	skin = skm.getSkin(UserSet.defaultSkin);
String skinPath = skin.getPath();

long photoId = ParamUtil.getLong(request, "photoId");

String op = ParamUtil.get(request, "op");
if (op.equals(""))
	op = "good";
com.redmoon.blog.Config cfg = com.redmoon.blog.Config.getInstance();	
boolean isGood = op.equals("good");
String action = ParamUtil.get(request, "action");
if (action.equals("do")) {
	PhotoMgr pm = new PhotoMgr();
	boolean re = false;
	try {
		if(isGood)
			re = pm.dig(request);
		else
			re = pm.undig(request);
		if (re) {
			out.print(StrUtil.Alert("评分成功! 点击确定将关闭本窗口"));
%>
<script>
window.close();
</script>
<%			
			return;
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	catch (ResKeyException e) {
		out.print(StrUtil.Alert_Back(e.getMessage(request)));
		return;
	}
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../forum/<%=skinPath%>/skin.css" rel="stylesheet" type="text/css">
<title>照片评分</title>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style>
<script src="../inc/common.js"></script>
<script>
function form1_onsubmit() {
	if (form1.digValue.value<=0) {
		alert("分值不能小于等于0");
		return false;
	}
	
	var max = <%=isGood?cfg.getIntProperty("digPhotoScoreMax"):cfg.getIntProperty("undigPhotoScoreMax")%>;
	if (form1.digValue.value>max) {
		alert("分值不能大于" + max);
		return false;
	}
	
	var dlt = <%=isGood?cfg.getIntProperty("digPhotoCost"):cfg.getIntProperty("undigPhotoCost")%>;
	if (!confirm("此次评分您将花费金币" + (dlt*form1.digValue.value) + "，您确定要继续吗？"))
		return false;
}
</script>
</head>
<body>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
PhotoDb pd = new PhotoDb();
pd = pd.getPhotoDb(photoId);
if (privilege.isUserLogin(request)) {
/*
	if (!dc.getBooleanProperty("canDigSelf")) {
		if (privilege.getUser(request).equals(md.getName())) {
			out.print(SkinUtil.makeErrMsg(request, "您不能挖掘自己的贴子!"));
			return;
		}
	}
*/	
}
else {
	out.print(SkinUtil.makeErrMsg(request, "请先登录!"));
	return;
}
%>
<TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1 bgcolor="#edeced">
<form name="form1" action="photo_dig.jsp?action=do" method="post" onSubmit="return form1_onsubmit()">
<TBODY>
      <TR bgColor=#f8f8f8> 
        <TD height=23 colspan="2" align="center" class="td_title">请输入您将评的分值</TD>
      </TR>
      <TR bgColor=#f8f8f8>
        <TD height=23 colspan="2" align="center"><table width="100%" cellspacing="0" cellpadding="4">
          <tr>
            <td width="192">&nbsp;</td>
            <td width="201">照片当前积分</td>
            <td width="267">
			<%if (isGood) {%>
			送分
			<%}else{%>
			扣分
			<%}%>
              <input name="photoId" type="hidden" value="<%=photoId%>">
              <input name="op" type="hidden" value="<%=op%>"></td>
            <td width="285">每评一分消耗的金币值</td>
          </tr>
          <tr>
            <td>
			<%if (op.equals("good")) {%>
			好评
			<%}else{%>
			差评
			<%}%>
			</td>
            <td><%=pd.getScore()%></td>
            <td><input name="digValue" value="1"></td>
            <td><span id=feed>
			<%if (isGood) {%>
			<%=cfg.getIntProperty("digPhotoCost")%>
			<%}else{%>
			<%=cfg.getIntProperty("undigPhotoCost")%>
			<%}%>
			</span>
			</td>
          </tr>
        </table></TD>
      </TR>
	<TR bgColor=#f8f8f8>
        <TD height=23 colspan="2" align="center">
		<input type="submit" value="<lt:Label key="ok"/>">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input name="button" type="button" onClick="window.close()" value="<lt:Label key="cancel"/>">
		<%if (isGood) {%>
		一次最多能送<%=cfg.getIntProperty("digPhotoScoreMax")%>分
		<%}else{%>
		一次最多能扣<%=cfg.getIntProperty("undigPhotoScoreMax")%>分
		<%}%>
		</TD>
      </TR></TBODY>
</form>	  
  </TABLE>
</body>
</html>
