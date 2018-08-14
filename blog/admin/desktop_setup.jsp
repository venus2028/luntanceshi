<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="org.jdom.*" %>
<%@ page import="com.redmoon.blog.Home" %>
<%@ page import="com.cloudwebsoft.framework.template.TemplateLoader" %>
<%@ page import="cn.js.fan.util.file.FileUtil" %>
<%@ page import="cn.js.fan.web.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="cn.js.fan.module.cms.ui.*" %>
<%@ page import="cn.js.fan.module.cms.ui.desktop.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="default.css" rel="stylesheet" type="text/css">
<title>桌面设置</title>
<script language=javascript>
<!--

//-->
</script>
<style type="text/css">
<!--
.STYLE1 {
	color: #FFFFFF;
	font-weight: bold;
}
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style>
</head>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
String priv="read";
if (!privilege.isUserPrivValid(request,priv))
{
	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String systemCode = DesktopItemDb.SYSTEM_CODE_BLOG;

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	String moduleCode = ParamUtil.get(request, "moduleCode");
	String moduleItem = ParamUtil.get(request, "moduleItem");
	String title = ParamUtil.get(request, "title");
	String pos = ParamUtil.get(request, "position");
	int count = ParamUtil.getInt(request, "count", 10);
	int titleLen = ParamUtil.getInt(request, "titleLen", 30);
	String properties = ParamUtil.get(request, "properties");
	
	DesktopItemDb di = new DesktopItemDb();
	di.setTitle(title);
	di.setSystemCode(systemCode);
	di.setModuleCode(moduleCode);
	di.setModuleItem(moduleItem);
	di.setPosition(pos);
	di.setCount(count);
	di.setTitleLen(titleLen);
	di.setProperties(properties);
	boolean re = di.create();
	if (re) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "desktop_setup.jsp"));
		return;
	}
	else {
		out.print(StrUtil.Alert_Back("操作失败！"));
	}
}

if (op.equals("edit")) {
	int id = ParamUtil.getInt(request, "id");
	String title = ParamUtil.get(request, "title");
	String pos = ParamUtil.get(request, "position");
	int count = ParamUtil.getInt(request, "count", 10);
	int titleLen = ParamUtil.getInt(request, "titleLen", 30);
	String properties = ParamUtil.get(request, "properties");
	String moduleItem = ParamUtil.get(request, "moduleItem");
			
	DesktopItemDb di = new DesktopItemDb();
	di = di.getDesktopItemDb(id);
	di.setTitle(title);
	di.setCount(count);
	di.setPosition(pos);
	di.setTitleLen(titleLen);
	di.setProperties(properties);
	di.setModuleItem(moduleItem);
	boolean re = di.save();
	if (re) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "desktop_setup.jsp"));
		return;
	}
	else {
		out.print(StrUtil.Alert_Back("操作失败！"));
	}
}

if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	DesktopItemDb di = new DesktopItemDb();
	di = di.getDesktopItemDb(id);
	boolean re = di.del();
	if (re) {
		out.print(StrUtil.Alert_Redirect("操作成功！", "desktop_setup.jsp"));
		return;
	}
	else {
		out.print(StrUtil.Alert_Back("操作失败！"));
	}
}

if (op.equals("createHtml")) {
	String filePath = cn.js.fan.web.Global.realPath + "/blog/template/index.htm";
	TemplateLoader tl = new TemplateLoader(request, filePath);
    FileUtil fu = new FileUtil();
    fu.WriteFile(Global.getRealPath() +
                  "blog/index.htm",
                 tl.toString(), "UTF-8");
	out.print(StrUtil.Alert_Redirect("操作成功！", "desktop_setup.jsp"));				 
}

DesktopItemDb di = new DesktopItemDb();
String sql = "select id from " + di.getTableName() + " where SYSTEM_CODE=" + StrUtil.sqlstr(systemCode) + " order by position";
Vector v = di.list(sql);
Iterator ir = v.iterator();
DesktopMgr dm = new DesktopMgr();
%>
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">管理首页</td>
    </tr>
  </tbody>
</table>
<br>
<table width="80%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center"><a href="../desktop_view.jsp?item=blog" target="_blank">预览首页</a></td>
    <td align="center"><a href="desktop_setup.jsp?op=createHtml">生成首页</a></td>
    <td align="center"><a href="../index.htm" target="_blank">查看首页</a></td>
    <td align="center"><a href="../desktop_edit_template.jsp" target="_blank">编辑模板</a></td>
  </tr>
</table>
<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid">
<tr>
  <td class="thead">模块标题</td>
  <td class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">位置编码</td>
  <td class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">行数</td>
  <td class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">标题长度</td>
  <td class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">参数</td>
  <td class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">属性</td>
  <td class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
</tr>
<%
int k = 0;
while (ir.hasNext()) {
	k ++;
	di = (DesktopItemDb) ir.next();
	DesktopUnit du = dm.getDesktopUnit(di.getModuleCode());
%>
<form name="form<%=k%>" action="?op=edit" method=post>
<tr><td width="27%" bgcolor="#FFFFFF"><input name="title" value="<%=di.getTitle()%>" size="35">
	<input name="id" value="<%=di.getId()%>" type="hidden">
</td>
  <td width="11%" bgcolor="#FFFFFF"><input name="position" value="<%=di.getPosition()%>" size=5></td>
  <td width="9%" bgcolor="#FFFFFF">
  <%if (du!=null && du.getType().equals(DesktopUnit.TYPE_LIST)) {%>
  <input name=count value="<%=di.getCount()%>" size=2>
  <%}%>	</td>
  <td width="10%" bgcolor="#FFFFFF"><input name=titleLen value="<%=di.getTitleLen()%>" size=2></td>
  <td width="15%" bgcolor="#FFFFFF"><%if (di.getModuleItem().startsWith("ad_")) {%>
			  <select name="moduleItem">
			  <%
			  Home home = Home.getInstance();
			  Element root = home.getRoot();
			  List list = root.getChild("ads").getChildren();
			  if (list!=null) {
			  	Iterator ir2 = list.iterator();
				while (ir2.hasNext()) {
					Element e = (Element)ir2.next();
					%>
					<option value="ad_<%=e.getAttributeValue("id")%>">广告<%=e.getAttributeValue("id")%></option>
					<%
				}
			  }
			  %>
			  </select>
  <%}else{%>
    <select name="moduleItem" onChange="if(this.options[this.selectedIndex].value=='not'){alert(this.options[this.selectedIndex].text+' 不能被选择！'); return false;}">
      <option value="not" selected>
      请选择类别
      </option>
      <option value="cws_newBlogTopic">----博客新文章----</option>
      <option value="cws_blogFocus">----博客聚焦----</option>
      <option value="cws_blogNotice">----博客公告----</option>
      <option value="cws_newAddBlog">----最新注册博客----</option>
      <option value="cws_newUpdateBlog">----最近更新博客----</option>
      <option value="cws_recommandBlog">----推荐博客----</option>
      <option value="cws_postRank">----发表排行----</option>
      <option value="cws_replyRank">----评论排行----</option>
      <option value="cws_newPhotos">----最新相册图片----</option>
      <option value="cws_blogStars">----博客之星----</option>
      <option value="cws_verticalScroller">----单行滚动屏----</option>
      <option value="cws_verticalScroller">----单行滚动屏----</option>
      <option value="cws_flashImages">----Flash图片----</option>
      <%
				com.redmoon.blog.Directory directory = new com.redmoon.blog.Directory();
				com.redmoon.blog.Leaf blf = directory.getLeaf("root");
				com.redmoon.blog.DirectoryView bdv = new com.redmoon.blog.DirectoryView(blf);
				bdv.ShowDirectoryAsOptions(out, blf, blf.getLayer());
				%>
    </select>
	<%}%>
	<script>
	form<%=k%>.moduleItem.value = "<%=di.getModuleItem()%>";
	</script>
	</td>
  <td width="16%" bgcolor="#FFFFFF"><input name="properties" value="<%=di.getProperties()%>"></td>
  <td width="12%" bgcolor="#FFFFFF"><input type="submit" value="修改"/>
  <input value="删除" type="button" onClick="window.location.href='?op=del&id=<%=di.getId()%>'"></td>
</tr></form>
<%}%>
</table>
	<br>
	<table width="98%" border="0" align="center" cellpadding="0" cellspacing="1">
      
      <tr>
        <td width="51%"><table width="100%" border="0" align="center" cellspacing="1" bgcolor="#D9DCE1" class="frame_gray">
          <form name="formBlog" action="?op=add" method="post">
            <tr>
              <td colspan="6" align="center" class="thead">博客新贴</td>
            </tr>
            <tr>
              <td width="18%" align="center" bgcolor="#FFFFFF">标题</td>
              <td colspan="5" align="left" bgcolor="#FFFFFF"><input name="title" value="博客文章">
                  <input type=hidden name="moduleCode" value="blog">              </td>
            </tr>
            <tr>
              <td align="center" bgcolor="#FFFFFF">项目</td>
              <td colspan="5" align="left" bgcolor="#FFFFFF">
			  <select name="moduleItem" onChange="if(this.options[this.selectedIndex].value=='not'){alert(this.options[this.selectedIndex].text+' 不能被选择！'); return false;} formBlog.title.value=this.options[this.selectedIndex].text">
                <option value="not" selected>
      			请选择类别
                </option>
				<option value="cws_newBlogTopic">----博客新文章----</option>				
				<option value="cws_blogFocus">----博客聚焦----</option>				
				<option value="cws_blogNotice">----博客公告----</option>				
				<option value="cws_newAddBlog">----最新注册博客----</option>
				<option value="cws_newUpdateBlog">----最近更新博客----</option>
				<option value="cws_recommandBlog">----推荐博客----</option>				
				<option value="cws_postRank">----发表排行----</option>				
				<option value="cws_replyRank">----评论排行----</option>				
				<option value="cws_newPhotos">----最新相册图片----</option>				
				<option value="cws_blogStars">----博客之星----</option>				
				<option value="cws_verticalScroller">----单行滚动屏----</option>				
				<option value="cws_verticalScroller">----单行滚动屏----</option>				
				<option value="cws_flashImages">----Flash图片----</option>	
				<option value="cws_blogScrollImages">----滚动图片----</option>							
                <%
				com.redmoon.blog.Directory directory = new com.redmoon.blog.Directory();
				com.redmoon.blog.Leaf blf = directory.getLeaf("root");
				com.redmoon.blog.DirectoryView bdv = new com.redmoon.blog.DirectoryView(blf);
				bdv.ShowDirectoryAsOptions(out, blf, blf.getLayer());
				%>
              </select></td>
            </tr>
			<tr>
<td align="center" bgcolor="#FFFFFF">属性</td>
              <td colspan="5" align="left" bgcolor="#FFFFFF"><input name="properties" value=""></td></tr>			
            <tr>
              <td align="center" bgcolor="#FFFFFF">位置</td>
              <td width="12%" align="left" bgcolor="#FFFFFF"><input name="position" value="" size=5></td>
              <td width="11%" align="left" bgcolor="#FFFFFF">行数</td>
              <td width="8%" align="left" bgcolor="#FFFFFF"><input name="count" value="" size=2></td>
              <td width="11%" align="left" bgcolor="#FFFFFF">长度</td>
              <td width="40%" align="left" bgcolor="#FFFFFF"><input name="titleLen" value="" size=2></td>
            </tr>
            <tr>
              <td colspan="7" align="center" bgcolor="#FFFFFF"><input name="submit432" type=submit value="添加"/>
                &nbsp;&nbsp;&nbsp;
                <input type=hidden name="systemCode" value="<%=systemCode%>"></td>
            </tr>
          </form>
        </table></td>
        <td width="49%" valign="top"><table width="100%" border="0" align="center" cellspacing="1" bgcolor="#D9DCE1" class="frame_gray">
          <form name="formAd" action="?op=add" method="post">
            <tr>
              <td colspan="6" align="center" class="thead">博客广告</td>
            </tr>
            <tr>
              <td width="18%" align="center" bgcolor="#FFFFFF">标题</td>
              <td colspan="5" align="left" bgcolor="#FFFFFF"><input name="title" value="博客广告">
                  <input type=hidden name="moduleCode" value="blog">
              </td>
            </tr>
            <tr>
              <td align="center" bgcolor="#FFFFFF">广告位</td>
              <td colspan="5" align="left" bgcolor="#FFFFFF">
			  <select name="moduleItem" onChange="formAd.title.value=this.options[this.selectedIndex].text">
			  <%
			  Home home = Home.getInstance();
			  Element root = home.getRoot();
			  List list = root.getChild("ads").getChildren();			  
			  if (list!=null) {
			  	Iterator ir2 = list.iterator();
				while (ir2.hasNext()) {
					Element e = (Element)ir2.next();
					%>
					<option value="ad_<%=e.getAttributeValue("id")%>">广告<%=e.getAttributeValue("id")%></option>
					<%
				}
			  }
			  %>
			  </select>
			  </td>
            </tr>
            <tr>
              <td align="center" bgcolor="#FFFFFF">位置</td>
              <td width="12%" align="left" bgcolor="#FFFFFF"><input name="position" value="" size=5></td>
              <td width="11%" align="left" bgcolor="#FFFFFF">行数</td>
              <td width="8%" align="left" bgcolor="#FFFFFF"><input name="count" value="" size=2></td>
              <td width="11%" align="left" bgcolor="#FFFFFF">长度</td>
              <td width="40%" align="left" bgcolor="#FFFFFF"><input name="titleLen" value="" size=2></td>
            </tr>
            <tr>
              <td colspan="7" align="center" bgcolor="#FFFFFF"><input name="submit4322" type=submit value="添加"/>
                &nbsp;&nbsp;&nbsp;
                <input type=hidden name="systemCode2" value="<%=systemCode%>"></td>
            </tr>
          </form>
        </table></td>
      </tr>
      
      <tr>
        <td valign="top">&nbsp;</td>
        <td valign="top"></td>
      </tr>
    </table>
<br>
<br>
</body>
<script>
function selTemplate(id)
{
	formDoc.moduleItem.value = id;
}
</script>
</html>
