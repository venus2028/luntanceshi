<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.ad.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ page import="com.cloudwebsoft.framework.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<%
String siteCode = ParamUtil.get(request, "siteCode");

String op = ParamUtil.get(request, "op");
if (op.equals("createHtml")) {
	DocumentMgr dm = new DocumentMgr();
	docmanager.createHtmlOfDirecroty(request);
	out.print(StrUtil.Alert_Redirect("操作成功!", "site.jsp?siteCode=" + StrUtil.UrlEncode(siteCode)));
	return;
}
else if (op.equals("createListHtml")) {
	try {
		docmanager.createListHtmlOfDirecroty(request);
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "site.jsp?siteCode=" + StrUtil.UrlEncode(siteCode)));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
else if (op.equals("createHome")) {
	docmanager.createSitePageHtml(request, siteCode);
	out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_operate_success"), "site.jsp?siteCode=" + StrUtil.UrlEncode(siteCode)));
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="../default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="../../util/jscalendar/calendar.js"></script>
<script type="text/javascript" src="../../util/jscalendar/lang/calendar-zh.js"></script>
<script type="text/javascript" src="../../util/jscalendar/calendar-setup.js"></script>
<style type="text/css"> @import url("../../util/jscalendar/calendar-win2k-2.css"); </style>

<title>站点设置</title>
<style>
.btn {
border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;
}
.STYLE1 {	color: #FFFFFF;
	font-weight: bold;
}
</style>
<script language="JavaScript">
<!--
function openWin(url,width,height) {
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,top=50,left=120,width="+width+",height="+height);
}
var urlObj;
function SelectImage(urlObject) {
	urlObj = urlObject;
	openWin("img_frame.jsp?action=selectImage&dir=<%=StrUtil.UrlEncode(siteCode)%>", 800, 600);
}
function setImgUrl(visualPath) {
	urlObj.value = visualPath;
}

var personType;
function setPerson(userName, userNick){
	if (personType=="owner") {
		form1.owner.value = userName;
		form1.nick.value = userNick;
	}else{
		if (form1.managers.value=="") {
			form1.managers.value = userName;
			form1.managerNames.value = userNick;
		}
		else {
			// 检查是否有重复
			var tmp = "," + form1.managers.value + ",";
			if (tmp.indexOf("," + userName + ",")!=-1) {
				alert("用户已被选择！");
				return;
			}
			
			form1.managers.value += "," + userName;
			form1.managerNames.value += "," + userNick;
		}
	}
}
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

if (op.equals("edit")) {
	SiteMgr sm = new SiteMgr();
	try {
		if (sm.save(application, request)) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site.jsp?siteCode=" + siteCode));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
boolean isCustomize = sd.getInt("is_customize")==1;
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">站点设置</td>
  </tr>
</table>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">设置</td>
  </tr>
  <tr>
    <td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><table width="100%" border="0" align="center" cellpadding="5" cellspacing="0" class="tableframe_gray">
          <form id=form1 action="site.jsp?op=edit&siteCode=<%=siteCode%>" method=post enctype="multipart/form-data">
		  <%if (Global.isSubDomainSupported) {%>		  
            <tr>
              <td height="22">域名</td>
              <td height="22"><%=sd.getString("code")%>.<%=DomainDispatcher.getBaseDomain(request)%></td>
            </tr>
		  <%}%>
            <tr>
              <td height="22">名称</td>
              <td height="22">
			  <input name="name" size=40 value="<%=StrUtil.toHtml(sd.getString("name"))%>">			  </td>
            </tr>
			<%if (!isCustomize) {%>
            <tr>
              <td width="19%" height="22">模板</td>
              <td width="81%" height="22"><%
			SiteTemplateDb td = new SiteTemplateDb();
			Vector v = td.list();
			Iterator ir = v.iterator();
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
			<script>
			form1.skin.value = "<%=sd.getInt("skin")%>";
          	</script>		  </td>
            </tr>
            <tr class="p9">
              <td height="22" align="left">类别</td>
              <td height="22">
		<%
        cn.js.fan.module.cms.LeafChildrenCacheMgr lccm = new cn.js.fan.module.cms.LeafChildrenCacheMgr(cn.js.fan.module.cms.Leaf.CODE_SITE);
        ir = lccm.getDirList().iterator();
		String opts = "";
        while (ir.hasNext()) {
			cn.js.fan.module.cms.Leaf lf = (cn.js.fan.module.cms.Leaf)ir.next();
			opts += "<option value='" + lf.getCode() + "'>" + lf.getName() + "</option>";
			
        	LeafChildrenCacheMgr lccm2 = new cn.js.fan.module.cms.LeafChildrenCacheMgr(lf.getCode());
			Iterator ir2 = lccm2.getDirList().iterator();
			while (ir2.hasNext()) {
				lf = (cn.js.fan.module.cms.Leaf)ir2.next();
				opts += "<option value='" + lf.getCode() + "'>	├『" + lf.getName() + "』</option>";
			}			
		}
%>
			<select name="kind">
			<%=opts%>
			</select>
			<script>
			form1.kind.value = "<%=sd.getString("kind")%>";
            </script>			  </td>
            </tr>
            <tr>
              <td height="22">启用自定义模板</td>
              <td height="22">
			  <%if (privilege.isUserPrivValid(request, "admin")) {%>
			  <select name="is_user_css">
                  <option value="1">是</option>
                  <option value="0">否</option>
                </select>
                  <script>
				form1.is_user_css.value = "<%=sd.getInt("is_user_css")%>";
              </script>
			  <%}else{%>
			  <%=sd.getInt("is_user_css")==1?"是":"否"%>
			  <input name="is_user_css" value="<%=sd.getInt("is_user_css")%>" type="hidden">
			  <%}%>			  </td>
            </tr>
            <tr>
              <td height="22">启用留言簿</td>
              <td height="22"><select name="is_guestbook_open">
                <option value="1">是</option>
                <option value="0">否</option>
              </select>
                <script>
				form1.is_guestbook_open.value = "<%=sd.getInt("is_guestbook_open")%>";
                </script></td>
            </tr>
            <tr>
              <td height="22">是否显示计数器</td>
              <td height="22">
			<select name="is_counter_show">
                <option value="1">是</option>
                <option value="0">否</option>
              </select>
                <script>
				form1.is_counter_show.value = "<%=sd.getInt("is_counter_show")%>";
                </script>			  </td>
            </tr>
            <tr>
              <td height="22">计数器样式</td>
              <td height="22">
				<select name="counter_style">
				<option value="">无</option>
				<option value="1" selected>1</option>
				<option value="2">2</option>
				<option value="3">3</option>
				<option value="4">4</option>
				<option value="5">5</option>
				<option value="6">6</option>
				<option value="7">7</option>
				<option value="8">8</option>
				<option value="9">9</option>
				<option value="10">10</option>
				</select>			  
                <script>
				form1.counter_style.value = "<%=StrUtil.getNullStr(sd.getString("counter_style"))%>";
                </script>				</td>
            </tr>
            <tr>
              <td height="22">是否采用多级导航</td>
              <td height="22">
				<select name="is_nav_col_children_show">
				<option value="1" selected>是</option>
				<option value="0">否</option>
				</select>			  
                <script>
				form1.is_nav_col_children_show.value = "<%=sd.getInt("is_nav_col_children_show")%>";
                </script>
				</td>
            </tr>
            <tr style="display:none">
              <td height="22">是否启用背景音乐</td>
              <td height="22">
				<select name="is_bk_music">
				<option value="1" selected>是</option>
				<option value="0">否</option>
				</select>
                <script>
				form1.is_bk_music.value = "<%=sd.getInt("is_bk_music")%>";
                </script>			  
			  </td>
            </tr>
            <tr>
              <td height="22">是否开启</td>
              <td height="22">
			  <%
			  if (sd.getInt("site_status")==SiteDb.STATUS_NOT_CHECKED && !privilege.isUserPrivValid(request, "admin")) {%>
				  	未审核<input type="hidden" name="site_status" value="<%=SiteDb.STATUS_NOT_CHECKED%>">
			  <%} else if (privilege.isUserPrivValid(request, "admin") || sd.getInt("site_status")!=SiteDb.STATUS_FORBID) {%>
					<select name="site_status">
					<option value="1">是</option>
					<option value="0">否</option>
					<%if (privilege.isUserPrivValid(request, "admin")) {%>
					<option value="<%=SiteDb.STATUS_FORBID%>">强制关闭</option>
					<option value="<%=SiteDb.STATUS_NOT_CHECKED%>">未审核</option>
					<%}%>
					</select>
					<script>
					form1.site_status.value = "<%=sd.getInt("site_status")%>";
					</script>			  
			<%}else{%>
				强制关闭<input name="site_status" value="<%=SiteDb.STATUS_FORBID%>" type="hidden">
			<%}%>
			<%if (!privilege.isUserPrivValid(request, "admin")) {%>
			<input name="owner" type="hidden" value="<%=StrUtil.getNullStr(sd.getString("owner"))%>">
			<%}%>			</td>
            </tr>
			<%}%>			
			<%if (privilege.isUserPrivValid(request, "admin")) {%>
            <tr>
              <td height="22">创建者</td>
              <td height="22">
			  <input name="owner" type="hidden" value="<%=StrUtil.getNullStr(sd.getString("owner"))%>">
			  <%
			  String nick = "";
			  UserMgr um = new UserMgr();
			  if (!StrUtil.getNullStr(sd.getString("owner")).equals("")) {
			  	UserDb ud = um.getUser(sd.getString("owner"));
				nick = ud.getNick();
			  }
			  %>
			  <input name="nick" size="6" value="<%=nick%>" readonly>
			  <a href="#" onClick="personType='owner';openWin('../../forum/admin/forum_user_sel.jsp', 480, 420)">
			  <lt:Label res="res.label.forum.admin.manager_list" key="select"/>
			  </a></td>
            </tr>
            <tr>
              <td height="22">管理员</td>
              <td height="22">
			  <%
			  String managers = "", managerNames = "";
			  SiteManagerDb smd = new SiteManagerDb();
			  Iterator ir = smd.getSiteManagerDbs(siteCode).iterator();
			  while (ir.hasNext()) {
			  	smd = (SiteManagerDb)ir.next();
				if (managerNames.equals("")) {
					managers = smd.getString("user_name");
					managerNames = um.getUser(smd.getString("user_name")).getNick();
				}
				else {
					managers += "," + smd.getString("user_name");
					managerNames += "," + um.getUser(smd.getString("user_name")).getNick();
				}
			  }
			  %>
			  <input name="managers" value="<%=managers%>" type="hidden">
			  <input name="managerNames" value="<%=managerNames%>" size=30>
			  <a href="#" onClick="personType='managers';openWin('../../forum/admin/forum_user_sel.jsp', 480, 420)">
			  <lt:Label res="res.label.forum.admin.manager_list" key="select"/>
			  </a> (创建者与管理员都拥有管理权限)			  </td>
            </tr>
            <tr>
              <td height="22">是否为定制站点</td>
              <td height="22" title="定制的子站点将会隐藏一些如留言簿、模板、Flash图片设置、滚动图片设置等管理项">
			  <select name="is_customize">
                <option value="1">是</option>
                <option value="0">否</option>
              </select>
			  <script>
				form1.is_customize.value = "<%=sd.getInt("is_customize")%>";
              </script>
			  (定制站点的前台不使用模板，置为“是”可以简化后台管理)</td>
            </tr>
			<%}else{%>
            <tr>
              <td height="22">创建者</td>
              <td height="22">
			  <%
			  String nick = "";
			  UserMgr um = new UserMgr();
			  if (!StrUtil.getNullStr(sd.getString("owner")).equals("")) {
			  	UserDb ud = um.getUser(sd.getString("owner"));
				nick = ud.getNick();
			  %>
			  <a href="../../userinfo.jsp?username=<%=StrUtil.UrlEncode(ud.getName())%>" target="_blank"><%=nick%></a>
			  <%
			  }
			  %>			  </td>
            </tr>
            <tr>
              <td height="22">管理员</td>
              <td height="22">
			  <%
			  String managerNames = "";
			  SiteManagerDb smd = new SiteManagerDb();
			  Iterator ir = smd.getSiteManagerDbs(siteCode).iterator();
			  while (ir.hasNext()) {
			  	smd = (SiteManagerDb)ir.next();
				if (managerNames.equals("")) {
					managerNames = "<a href='../../userinfo.jsp?username=" + StrUtil.UrlEncode(smd.getString("user_name")) + "' target='_blank'>" + um.getUser(smd.getString("user_name")).getNick() + "</a>";
				}
				else {
					managerNames += "," + "<a href='../../userinfo.jsp?username=" + StrUtil.UrlEncode(smd.getString("user_name")) + "' target='_blank'>" + um.getUser(smd.getString("user_name")).getNick() + "</a>";
				}
			  }
			  %>
			  <%=managerNames%>			  </td>
            </tr>			
			<%}%>
            <tr>
              <td colspan="2" align="center">
			  <%if (isCustomize) {%>
			  <input name="is_user_css" value="<%=sd.getInt("is_user_css")%>" type=hidden>
			  <input name="site_status" value="<%=sd.getInt("site_status")%>" type=hidden>
			  <input name="is_guestbook_open" value="<%=sd.getInt("is_guestbook_open")%>" type=hidden>
			  <input name="is_bk_music" value="<%=sd.getInt("is_bk_music")%>" type=hidden>
			  <input name="kind" value="<%=sd.getString("kind")%>" type=hidden>
			  <input name="skin" value="<%=sd.getInt("skin")%>" type=hidden>
			  <%}%>
			  <%if (!privilege.isUserPrivValid(request, "admin")) {%>
			  <input name="is_customize" value="<%=sd.getInt("is_customize")%>" type=hidden>
			  <%}%>
			  <input name="code" value="<%=siteCode%>" type=hidden>
			  <input name="view_count" value="<%=sd.getInt("view_count")%>" type=hidden>
			  <input name="css_path" value="<%=StrUtil.getNullStr(sd.getString("css_path"))%>" type=hidden>			  
                <input type="submit" name="Submit" value="确定">
                &nbsp;&nbsp;
                <input type="reset" name="Submit2" value="重置">              </td>
            </tr>
          </form>
        </table></td>
      </tr>
    </table></td>
  </tr>
</table>
<br>
<%
LeafPriv lp = new LeafPriv(siteCode);
if (lp.canUserExamine(privilege.getUser(request))) {
%>
<table width="98%" border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray" style="margin-top:10px">
  <tr>
    <td class="thead">生成静态页面</td>
  </tr>
  <tr>
    <td>&gt;&gt;&nbsp;<a href="site.jsp?op=createHome&siteCode=<%=StrUtil.UrlEncode(siteCode)%>&dir_code=<%=StrUtil.UrlEncode(siteCode)%>">生成首页</a></td>
  </tr>
  <tr>
    <form action="?op=createHtml" method="post">
      <td> 文章修改日期从
        <input readonly type="text" id="beginDate" name="beginDate" size="10" this.value=''">
          <script type="text/javascript">
    Calendar.setup({
        inputField     :    "beginDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
  </script>
        至
        <input readonly type="text" id="endDate" name="endDate" size="10" this.value=''">
        <script type="text/javascript">
    Calendar.setup({
        inputField     :    "endDate",      // id of the input field
        ifFormat       :    "%Y-%m-%d",       // format of the input field
        showsTime      :    false,            // will display a time selector
        singleClick    :    false,           // double-click mode
        align          :    "Tl",           // alignment (defaults to "Bl")		
        step           :    1                // show all years in drop-down boxes (instead of every other year as default)
    });
</script>
          <input name="" value="true" type="checkbox" checked disabled>
          <input name="isIncludeChildren" value="true" type="hidden">
        包含子文件夹
        &nbsp;
		<input name="button2" type="submit" value="生成文章静态页面">
		<input name="dir_code" value="<%=siteCode%>" type="hidden">
		<input name="siteCode" value="<%=siteCode%>" type="hidden">				  
        日期不填写，表示全部</td>
    </form>
  </tr>
  <form action="?op=createListHtml" method="post">
    <tr>
      <td>列表页的页码从
        <input type="text" id="pageNumBegin" name="pageNumBegin" size="10" value="1">
        至
        <input type="text" id="pageNumEnd" name="pageNumEnd" size="10">
          <input name="" value="true" type="checkbox" checked disabled>
          <input name="isIncludeChildren" value="true" type="hidden">
        包含子文件夹
        &nbsp;
                <input name="button22" type="submit" value="生成列表静态页面">
                <input name="dir_code" value="<%=siteCode%>" type="hidden">
                <input name="siteCode" value="<%=siteCode%>" type="hidden">				
        页码不填写，表示全部</td>
    </tr>
  </form>
</table>
<%}%>
</body>                                        
</html>                            
  