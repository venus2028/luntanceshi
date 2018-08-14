<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.db.*" %>
<%@ page import="cn.js.fan.web.*" %>
<%@ page import="cn.js.fan.module.cms.ad.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Advertisement Manage</title>
<LINK href="default.css" type=text/css rel=stylesheet>
<LINK href="../common.css" type=text/css rel=stylesheet>
<script src="../inc/common.js"></script>
<script src="../inc/calendar.js"></script>
<script>
function ad_kind_onchange() {
	var kinds, key;
	kinds = new Array('0','1','2','3');
	for(key in kinds) {
		var obj=$('kind_'+kinds[key]);
		var isShow = kinds[key]==form1.ad_kind.value;
		if (isShow)
			$("kind").innerHTML = obj.innerHTML;
	}
}

function getBoards() {
	return form1.boardcodes.value;
}

function openWinBoards() {
	var ret = showModalDialog('dir_sel_multi.jsp',window.self,'dialogWidth:520px;dialogHeight:350px;status:no;help:no;')
	if (ret==null)
		return;
	form1.boardNames.value = "";
	form1.boardcodes.value = "";
	for (var i=0; i<ret.length; i++) {
		if (form1.boardNames.value=="") {
			form1.boardcodes.value += ret[i][0];
			form1.boardNames.value += ret[i][1];
		}
		else {
			form1.boardcodes.value += "," + ret[i][0];
			form1.boardNames.value += "," + ret[i][1];
		}
	}
}

function window_onload() {
  ad_kind_onchange();
}
</script>
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style></head>
<body onload="window_onload()">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "admin")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

int id = ParamUtil.getInt(request, "id");

AdDb ad = new AdDb();
ad = (AdDb)ad.getQObjectDb(new Integer(id));
int ad_type = ad.getInt("ad_type");
int ad_kind = ad.getInt("ad_kind");

String op = ParamUtil.get(request, "op");
if (op.equals("edit")) {
	QObjectMgr qom = new QObjectMgr();
	try {
		if (qom.save(request, ad, "cms_ad_save"))
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "ad_edit.jsp?id=" + id));
		else
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));	
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}

String[] types = new String[] {"头部横幅", "底部横幅", "漂浮广告", "门联广告左", "门联广告右", "文章内广告", "文章底部广告"};
%>
<table width='100%' cellpadding='0' cellspacing='0'>
  <tr>
    <td class="head"><a href="ad_list.jsp">广告管理</a> -
    <lt:Label res="res.label.forum.admin.ad_list" key="edit"/>&nbsp;</td>
  </tr>
</table>
<br>
<TABLE class="frame_gray" cellSpacing=0 cellPadding=5 width="95%" align=center>
    <TR>
      <TD valign="top" bgcolor="#FFFBFF">
	  <form method="post" name="form1" action="?op=edit">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tableborder">
          <tr class="header">
            <td colspan="2"><lt:Label res="res.label.forum.admin.ad_list" key="edit_ad"/> - <%=types[ad_type]%></td>
          </tr>
          <tr>
            <td><strong>用户名</strong>:</td>
            <td><input name="nick" value="<%=StrUtil.getNullString(ad.getString("nick"))%>"></td>
          </tr>
          <tbody style="display: yes">
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="display_style"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="select_display_style"/></span>			  </td>
              <td>
			  <select name="ad_kind" onchange="ad_kind_onchange()">
                <option value="<%=AdDb.KIND_HTML%>" selected><lt:Label res="res.label.forum.admin.ad_list" key="code"/></option>
                <option value="<%=AdDb.KIND_TEXT%>"><lt:Label res="res.label.forum.admin.ad_list" key="word"/></option>
                <option value="<%=AdDb.KIND_IMAGE%>"><lt:Label res="res.label.forum.admin.ad_list" key="pic"/></option>
                <option value="<%=AdDb.KIND_FLASH%>">Flash</option>
              </select>
			  <input name="ad_type" value="<%=ad_type%>" type="hidden">
			  <script>
			  form1.ad_kind.value = "<%=ad.getInt("ad_kind")%>";
			  </script>
			  <input name="id" value="<%=id%>" type="hidden"></td>
            </tr>
            <tr>
              <td width="60%">
			  <b><lt:Label res="res.label.forum.admin.ad_list" key="ad_title"/>:</b><br><span ><lt:Label res="res.label.forum.admin.ad_list" key="notice"/></span>			  </td>
              <td ><input type="text" size="30" name="title" value="<%=ad.getString("title")%>">              </td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="ad_area"/>:</b><br>
              设置本广告投放的页面范围，全部栏目表示首页</td>
              <td><span class="TableData">
			    <input name="boardcodes" type="hidden" value="<%=ad.getString("boardcodes")%>">
				<%
				Directory dir = new Directory();
				String[] ary = StrUtil.split(ad.getString("boardcodes"), ",");
				String boardNames = "";
				if (ary!=null) {
					int arylen = ary.length;
					for (int i=0; i<arylen; i++) {
						Leaf lf = dir.getLeaf(ary[i]);
						if (lf!=null) {
							if (boardNames.equals(""))
								boardNames = lf.getName();
							else
								boardNames += "," + lf.getName();
						}	
					}
				}
				%>
                <textarea name="boardNames" cols="40" rows="5" readOnly wrap="yes" id="boardNames"><%=boardNames%></textarea>
                <br>&nbsp;
				<input class="SmallButton" title="<%=SkinUtil.LoadString(request, "res.label.forum.admin.ad_list", "add_department")%>" onClick="openWinBoards()" type="button" value="<%=SkinUtil.LoadString(request, "res.label.forum.admin.ad_list", "add")%>" name="button">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input class="SmallButton" title="<%=SkinUtil.LoadString(request, "res.label.forum.admin.ad_list", "clear_department")%>" onClick="form1.boardNames.value='';form1.boardcodes.value=''" type="button" value="<%=SkinUtil.LoadString(request, "res.label.forum.admin.ad_list", "clear_all")%>" name="button">
              </span></td>
            </tr>
            <tr>
              <td width="60%"  ><b><lt:Label res="res.label.forum.admin.ad_list" key="ad_begin_date"/>:</b><br>
                  <span ><lt:Label res="res.label.forum.admin.ad_list" key="config_ad_effective_date"/></span></td>
              <td ><input size="30" name="begin_date" onclick="showcalendar(event, this)" value="<%=DateUtil.format(ad.getDate("begin_date"), "yyyy-MM-dd")%>">              </td>
            </tr>
            <tr>
              <td width="60%"  ><b><lt:Label res="res.label.forum.admin.ad_list" key="ad_end_date"/>:</b><br>
                  <span ><lt:Label res="res.label.forum.admin.ad_list" key="config_ad_end_date"/></span></td>
              <td><input size="30" name="end_date" onclick="showcalendar(event, this)" value="<%=DateUtil.format(ad.getDate("end_date"), "yyyy-MM-dd")%>">              </td>
            </tr>
        </table>
		<div id="kind"></div>
        <center>
          <input class="button" type="submit" name="advsubmit" value="<%=SkinUtil.LoadString(request, "res.label.forum.admin.ad_list", "submit")%>">
        </center>
      </form>	 
        <div id="kind_0" style="display:none" >
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tableborder">
            <tr class="header">
              <td colspan="2"><lt:Label res="res.label.forum.admin.ad_list" key="html_code"/></td>
            </tr>
            <tr>
              <td width="60%"  valign="top"><b><lt:Label res="res.label.forum.admin.ad_list" key="ad_html_code"/>:</b><br>
                <lt:Label res="res.label.forum.admin.ad_list" key="input_display_code"/></td>
              <td><textarea rows="5" name="content" id="content" cols="40"><%=ad_kind==AdDb.KIND_HTML?ad.getString("content"):""%></textarea></td>
            </tr>
          </table>
        </div>
        <div id="kind_1" style="display: none" >
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tableborder">
            <tr class="header">
              <td colspan="2"><lt:Label res="res.label.forum.admin.ad_list" key="word_ad"/></td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="words_content"/>:</b><br>
                  <span ><lt:Label res="res.label.forum.admin.ad_list" key="input_words_content"/></span></td>
              <td><input type="text" size="30" name="content" value="<%=ad_kind==AdDb.KIND_TEXT?ad.getString("content"):""%>">
              </td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="words_link"/>:</b><br>
                  <span ><lt:Label res="res.label.forum.admin.ad_list" key="words_link_url"/></span></td>
              <td ><input type="text" size="30" name="url" value="<%=ad.getString("url")%>">
              </td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="words_size"/>:</b><br>
                  <span ><lt:Label res="res.label.forum.admin.ad_list" key="input_words_unit"/></span></td>
              <td ><input type="text" size="30" name="font_size" value="<%=ad.getString("font_size")%>">
              </td>
            </tr>
          </table>
        </div>
        <br>
        <div id="kind_2" style="display: none" >
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tableborder">
            <tr class="header">
              <td colspan="2"><lt:Label res="res.label.forum.admin.ad_list" key="pic_ad"/></td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="pic_http"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="pic_http_src"/></span></td>
              <td ><input type="text" size="30" name="content" value="<%=ad_kind==AdDb.KIND_IMAGE?ad.getString("content"):""%>">
              </td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="pic_link"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="pic_url"/></span></td>
              <td ><input type="text" size="30" name="url" value="<%=ad.getString("url")%>">
              </td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="pic_width"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="pic_ad_width"/></span></td>
              <td ><input type="text" size="30" name="width" value="<%=ad.getInt("width")%>">
              </td>
            </tr>
            <tr>
              <td width="60%"  ><b><lt:Label res="res.label.forum.admin.ad_list" key="pic_height"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="pic_ad_height"/></span></td>
              <td ><input type="text" size="30" name="height" value="<%=ad.getInt("height")%>">
              </td>
            </tr>
            <tr>
              <td width="60%"  ><b><lt:Label res="res.label.forum.admin.ad_list" key="pic_replace_words"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="pic_mouse_info"/></span></td>
              <td ><input type="text" size="30" name="image_alt" value="<%=ad.getString("image_alt")%>">
              </td>
            </tr>
          </table>
        </div>
        <br>
        <div id="kind_3" style="display: none" >
          <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tableborder">
            <tr class="header">
              <td colspan="2"><lt:Label res="res.label.forum.admin.ad_list" key="flash_ad"/></td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="flash_http"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="flash_src"/></span></td>
              <td><input type="text" size="30" name="content" value="<%=ad_kind==AdDb.KIND_FLASH?ad.getString("content"):""%>">
              </td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="flash_width"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="input_flash_width"/></span></td>
              <td><input type="text" size="30" name="width" value="<%=ad.getInt("width")%>">
              </td>
            </tr>
            <tr>
              <td width="60%"><b><lt:Label res="res.label.forum.admin.ad_list" key="flash_height"/>:</b><br>
                  <span><lt:Label res="res.label.forum.admin.ad_list" key="input_flash_height"/></span></td>
              <td ><input type="text" size="30" name="height" value="<%=ad.getInt("height")%>">
              </td>
            </tr>
          </table>
        </div>	  
	   </TD>
    </TR>
  </TBODY>
</TABLE>
<br>
<br>
<br>
</body>
</html>
