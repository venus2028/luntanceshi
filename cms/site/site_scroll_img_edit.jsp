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
<%
String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML><HEAD><TITLE>Flash图片管理</TITLE>
<META http-equiv=Content-Type content="text/html; charset=utf-8">
<LINK href="../default.css" type=text/css rel=stylesheet>
<META content="MSHTML 6.00.3790.259" name=GENERATOR>
<style type="text/css">
<!--
.style1 {
	font-size: 14px;
	font-weight: bold;
}
-->
</style>
<script>
function openWin(url,width,height) {
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,top=50,left=120,width="+width+",height="+height);
}

var urlObj;
function SelectImage(urlObject) {
	urlObj = urlObject;
	openWin("../img_frame.jsp?action=selectImage&dir=<%=StrUtil.UrlEncode(siteCode)%>", 800, 600);
}
function setImgUrl(visualPath) {
	urlObj.value = visualPath;
}
</script>
</HEAD>
<BODY text=#000000 bgColor=#eeeeee leftMargin=0 topMargin=0>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

long id = ParamUtil.getLong(request, "id");
String op = ParamUtil.get(request, "op");
SiteScrollImgDb sfd = new SiteScrollImgDb();
sfd = (SiteScrollImgDb)sfd.getQObjectDb(new Long(id));
if (op.equals("edit")) {
	QObjectMgr qom = new QObjectMgr();
	try {
		if (qom.save(request, sfd, "site_scroll_img_save")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_scroll_img_edit.jsp?id=" + id + "&siteCode=" + siteCode + "&kind=" + sfd.getString("kind")));
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
    <TD class=head><a href="site_scroll_img_list.jsp?siteCode=<%=siteCode%>&kind=<%=sfd.getString("kind")%>">滚动图片</a></TD>
  </TR></TBODY></TABLE>
<br>
<table width="73%" align="center" class="frame_gray">
        <form id=form1 name=form1 action="?op=edit&siteCode=<%=siteCode%>" method=post>
          <tr>
            <td height="22" colspan="4" class="thead">图片
              <input name="id" value="<%=id%>" type=hidden>
            </td>
          </tr>
          <tr>
            <td width="9%" height="22">序号：</td>
            <td width="31%"><input name="orders" value="<%=sfd.getInt("orders")%>">
            </td>
            <td width="11%">地址：</td>
            <td width="49%"><input name="url" value="<%=sfd.getString("url")%>">
            <input name="button" type="button" onclick="SelectImage(form1.url)" value="选择" /></td>
          </tr>
          <tr>
            <td height="22">链接：</td>
            <td><input name="link" value="<%=sfd.getString("link")%>"></td>
            <td>文字：</td>
            <td><input name="title" value="<%=sfd.getString("title")%>"></td>
          </tr>
          <tr>
            <td height="22" colspan="4" align="center"><input name="submit2" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
          </tr>
        </form>
      </table>
</BODY></HTML>
