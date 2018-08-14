<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, SkinUtil.ERR_NOT_LOGIN)));
	return;
}

cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
UserDb ud = new UserDb();
ud = ud.getUser(privilege.getUser(request));
int level = cfg.getIntProperty("cms.site_apply_user_Level");
if (ud.getUserLevelDb().getLevel()<level) {
	UserLevelDb uld = new UserLevelDb();
	uld = uld.getUserLevelDbByLevel(level);
	out.print(SkinUtil.makeErrMsg(request, "等级在“" + uld.getDesc() + "”以上者才能自助建站！"));
	return;
}

SiteDb sd = new SiteDb();
int siteCount = cfg.getIntProperty("cms.site_apply_user_count");
Vector vsite = sd.getSubsitesOfUser(ud.getName());
if (vsite.size()>=siteCount) {
	out.print(SkinUtil.makeErrMsg(request, "自助建站的数量不能超过" + siteCount));
	return;	
}
%>
<%
String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	SiteMgr sm = new SiteMgr();
	boolean re = false;
	String siteCode = "";
	try {
		re = sm.create(application, request);
		siteCode = sm.getFileUpload().getFieldValue("code");
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	if (re) {
        if (cfg.getBooleanProperty("cms.site_apply_need_check")) {
			out.print(StrUtil.Alert_Redirect("操作成功！\\n请等待管理员审核通过您的网站，您可以在用户中心进入管理后台！", "usercenter.jsp"));
        }
		else
			out.print(StrUtil.Alert_Redirect("操作成功！\\n点击确定将跳转至您创建的网站，您可以在用户中心进入管理后台！", "site.jsp?siteCode=" + siteCode));
	}
	else {
		out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));	
	}
	return;
}
%>
<%
String skinPath = com.redmoon.forum.ui.SkinMgr.getSkinPath(request);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>自助建站 - <%=Global.AppName%></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<LINK href="forum/<%=skinPath%>/css.css" type=text/css rel=stylesheet>
</head>
<body>
<div id="wrapper">
<%@ include file="forum/inc/header.jsp"%>
<div id="main">
<form action="site_apply.jsp?op=add" method="post" enctype="multipart/form-data" name="form1" id="form1">
<table width="100%" border="0" align="center" cellpadding="1" cellspacing="0" class="tableCommon80">
    <thead>
      <td height="22" colspan="2" align="left">自助建站</td>
    </thead>
    <tr>
      <td width="21%" height="22" align="left">子域名：</td>
      <td width="79%" height="22"><input name="code" value="" /></td>
    </tr>
    <tr>
      <td height="22" align="left">名&nbsp;&nbsp;&nbsp;&nbsp;称：</td>
      <td height="22"><input name="name" value="" />
      </td>
    </tr>
    <tr>
      <td height="22" align="left">类&nbsp;&nbsp;&nbsp;&nbsp;别：</td>
      <td height="22"><%
        cn.js.fan.module.cms.LeafChildrenCacheMgr lccm = new cn.js.fan.module.cms.LeafChildrenCacheMgr(cn.js.fan.module.cms.Leaf.CODE_SITE);
        Iterator ir = lccm.getDirList().iterator();
		String opts = "";
        while (ir.hasNext()) {
			cn.js.fan.module.cms.Leaf lf = (cn.js.fan.module.cms.Leaf)ir.next();
			opts += "<option value='" + lf.getCode() + "'>" + lf.getName() + "</option>";
			
        	lccm = new cn.js.fan.module.cms.LeafChildrenCacheMgr(lf.getCode());
			Iterator ir2 = lccm.getDirList().iterator();
			while (ir2.hasNext()) {
				lf = (cn.js.fan.module.cms.Leaf)ir2.next();
				opts += "<option value='" + lf.getCode() + "'>├『" + lf.getName() + "』</option>";
			}
		}
%>
          <select name="kind">
            <%=opts%>
          </select>
      </td>
    </tr>
    <tr>
      <td height="22">启用留言簿：</td>
      <td height="22"><select name="is_guestbook_open">
        <option value="1">是</option>
        <option value="0">否</option>
      </select>
      </td>
    </tr>
    <tr>
      <td height="22">模&nbsp;&nbsp;&nbsp;&nbsp;板：</td>
      <td height="22"><%
SiteTemplateDb td = new SiteTemplateDb();
Vector v = td.list();
ir = v.iterator();
String skinoptions = "";
while (ir.hasNext()) {
	td = (SiteTemplateDb) ir.next();
	if (!StrUtil.getNullStr(td.getString("owner")).equals(""))
		continue;	
	skinoptions += "<option value='" + td.getLong("id") + "'>" + td.getString("name") + "</option>";
}
%>
          <select name="skin">
            <%=skinoptions%>
          </select>
      </td>
    </tr>
    <tr align="center">
      <td height="35" colspan="3"><input name="submit" type="submit" value="<lt:Label key="submit"/>" /></td>
    </tr>
</table>
</form>
</div>
<%@ include file="forum/inc/footer.jsp"%>
</div>
</body>
</html>