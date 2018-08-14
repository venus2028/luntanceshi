<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,
				 java.text.*,
				 com.cloudwebsoft.framework.base.*,
				 cn.js.fan.db.*,
				 cn.js.fan.module.cms.site.*,
				 cn.js.fan.util.*,
				 com.redmoon.forum.person.UserMgr,
				 com.redmoon.forum.person.UserDb,
				 cn.js.fan.web.*,
				 cn.js.fan.module.pvg.*"
%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<HTML><HEAD><TITLE>子站点广告编辑</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8"><LINK 
href="../images/default.css" type=text/css rel=stylesheet>
<META content="MSHTML 6.00.3790.259" name=GENERATOR>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
</HEAD>
<BODY text=#000000 bgColor=#eeeeee leftMargin=0 topMargin=0>
<%
String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

long id = ParamUtil.getLong(request, "id");
String op = ParamUtil.get(request, "op");
SiteAdDb sad = new SiteAdDb();
sad = (SiteAdDb)sad.getQObjectDb(new Long(id));
if (op.equals("edit")) {
	QObjectMgr qom = new QObjectMgr();
	try {
		if (qom.save(request, sad, "site_ad_save")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_ad_list.jsp?siteCode=" + siteCode));
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
  <TR>
    <TD class=head>管理广告</TD>
  </TR></TBODY></TABLE>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td valign="top"><br>
      <table width="66%" border="0" align="center" cellpadding="3" cellspacing="0" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
        <form action="?op=edit&siteCode=<%=siteCode%>" method="post" name="form1">
          <tr>
            <td height="24" colspan="4" align="center" class="thead">编辑广告</td>
          </tr>
          <tr>
            <td width="8%" height="24">名称</td>
            <td width="22%"><input name=title value="<%=sad.getString("title")%>"></td>
            <td width="9%">序号</td>
            <td width="61%"><input name="orders" size="2" value="<%=sad.getInt("orders")%>">
			<input name="id" value="<%=id%>" type=hidden>
			</td>
          </tr>
          <tr>
            <td height="24">内容</td>
            <td colspan="3">
<textarea id="divAd" name="divAd" style="display:none">
<%=sad.getString("content")%>
</textarea>						
<script type="text/javascript" src="../../FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'content' ) ;
oFCKeditor.BasePath = '../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_cms.jsp?dir=' + '<%=StrUtil.UrlEncode(siteCode)%>' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 250 ;

oFCKeditor.Value = form1.divAd.value;

// oFCKeditor.Config["EnterMode"] = 'br' ;     // p | div | br （回车）
oFCKeditor.Config["ShiftEnterMode"] = 'p' ; // p | div | br（shift+enter)

oFCKeditor.Config["FormatOutput"]=false;
oFCKeditor.Config["FillEmptyBlocks"]=false;
oFCKeditor.Config["FormatIndentator"]=" ";
oFCKeditor.Config["FullPage"]=false;
oFCKeditor.Config["StartupFocus"]=true;
oFCKeditor.Config["EnableXHTML"]=false;
oFCKeditor.Config["FormatSource"]=false;
oFCKeditor.Config["SkinPath"]="skins/office2003/";

oFCKeditor.Create() ;
//-->
</script>			</td>
          </tr>
          <tr>
            <td>&nbsp;</td>
            <td colspan="3"><input name="submit" type=submit value="<lt:Label key="ok"/>" width=80 height=20></td>
          </tr>
        </form>
    </table></td>
  </tr>
</table>
<br>
</BODY></HTML>
