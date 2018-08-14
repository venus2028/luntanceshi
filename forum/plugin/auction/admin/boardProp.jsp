<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../../inc/inc.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.SkinUtil"%>
<%@ page import="cn.js.fan.web.Global"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.Leaf"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<link rel="stylesheet" href="../../../common.css">
<LINK href="../../../admin/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>插件管理</title>
<script language="JavaScript">
<!--
function form1_onsubmit() {
	form1.auctionRule.value = getHtml();
	if (form1.auctionRule.value.length>3000) {
		alert("您输入的数据太长，不允许超过3000字！");
		return false;
	}
}
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "forum.plugin"))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String boardCode = ParamUtil.get(request, "boardCode");
if (boardCode.equals("")) {
	out.print(SkinUtil.LoadString(request, "want") + "boardCode");
	return;
}
BoardDb sb = new BoardDb();
sb = (BoardDb)sb.getBoardDb(AuctionUnit.code, boardCode);

Leaf leaf = new Leaf();
leaf = leaf.getLeaf(boardCode);

String op = ParamUtil.get(request, "op");
if (op.equals("modify")) {
	AuctionSkin sv = new AuctionSkin();
	String auctionRule = ParamUtil.get(request, "auctionRule");
	sb.setBoardRule(auctionRule);
	if (sb.save())
		out.print(StrUtil.Alert(sv.LoadString(request, "modifySucceed")));
	else
		out.print(StrUtil.Alert(sv.LoadString(request, "modifyFail")));
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理插件-<a href=manager.jsp><%=AuctionSkin.LoadString(request, "name")%></a>的规则</td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">&nbsp;</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFBFF" class="tableframe_gray">
	  <form name=form1 action="?op=modify" method="post" onSubmit="return form1_onsubmit()">
      <tr align="center">
        <td width="25%" height="22">版面编码</td>
      <td width="75%" height="22" align="left"><%=leaf.getCode()%><input type="hidden" name="boardCode" value="<%=boardCode%>"></td>
        </tr>
      <tr align="center">
        <td height="22">版面名称</td>
      <td height="22" align="left"><%=leaf.getName()%></td>
        </tr>
      <tr align="center">
        <td height="22">版面规则</td>
        <td height="22" align="left">
		<%
		String rpath = request.getContextPath();
		%>
<textarea id="auctionRule" name="auctionRule" style="display:none"><%=sb.getBoardRule().replaceAll("\"","'")%></textarea>
<link rel="stylesheet" href="<%=rpath%>/editor/edit.css">
<script src="<%=rpath%>/editor/DhtmlEdit.js"></script>
<script src="<%=rpath%>/editor/editjs.jsp"></script>
<script src="<%=rpath%>/editor/editor_s.jsp"></script>
<script>
setHtml(form1.auctionRule);
</script>
        
		</tr>
      <tr align="center">
        <td height="30" colspan="2"><input type="submit" name="Submit" value="提交">
&nbsp;&nbsp;
          <input type="reset" name="Submit" value="重置"></td>
        </tr></form>
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
  