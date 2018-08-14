<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.plugin.software.*"%>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="../../../../common.css">
<link href="../../../default.css" type=text/css rel=stylesheet>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>软件下载管理</title>
<style type="text/css">
<!--
.btn {border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;
}
-->
</style>
<script src="../../../../inc/common.js"></script>
<script>
function openWin(url,width,height){
	var newwin = window.open(url,"_blank","scrollbars=yes,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}

var curObj;

function openSelRecommandDocWin() {
	curObj = formRcmd.recommand;
	openWin("software_list.jsp?action=sel&selboard=cwBlogTopic", 800, 600);	
}

function selDoc(ids) {
	// 检查在notices中是否已包含了ids中的id，避免重复加入
	var ary = ids.split(",");
	var ntc = curObj.value;
	var ary2 = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		var founded = false;
		for (var j=0; j<ary2.length; j++) {
			if (ary[i]==ary2[j]) {
				founded = true;
				break;
			}
		}
		if (!founded) {
			if (ntc=="")
				ntc += ary[i];
			else
				ntc += "," + ary[i];
		}
	}
	curObj.value = ntc;
}

function delRecommand(id) {
	var ntc = formRcmd.recommand.value;
	var ary = ntc.split(",");
	var ary2 = new Array();
	var k = 0;
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			continue;
		}
		else {
			ary2[k] = ary[i];
			k++;
		}
	}
	ntc = "";
	for (i=0; i<ary2.length; i++) {
		if (ntc=="")
			ntc += ary2[i];
		else
			ntc += "," + ary2[i];
	}
	formRcmd.recommand.value = ntc;
	formRcmd.submit();
}

function up(id) {
	var ntc = formRcmd.recommand.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=0) {
				var tmp = ary[i-1];
				ary[i-1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	formRcmd.recommand.value = ntc;
	formRcmd.submit();
}

function down(id) {
	var ntc = formRcmd.recommand.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=ary.length-1) {
				var tmp = ary[i+1];
				ary[i+1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	formRcmd.recommand.value = ntc;
	formRcmd.submit();
}
</script>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, PrivDb.PRIV_ADMIN)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

cn.js.fan.module.cms.plugin.software.Config cfg = cn.js.fan.module.cms.plugin.software.Config.getInstance();

String op = ParamUtil.get(request, "op");
if (op.equals("setRecommand")) {
	String recommand = ParamUtil.get(request, "recommand");
	cfg.setProperty("recommand", recommand);
	out.print(StrUtil.Alert_Redirect("操作成功！", "manager.jsp"));
	return;	
}
else if (op.equals("setIsNeedLogin")) {
	String isNeedLogin = ParamUtil.get(request, "isNeedLogin");
	cfg.setProperty("isNeedLogin", isNeedLogin);
	out.print(StrUtil.Alert_Redirect("操作成功！", "manager.jsp"));
	return;	
}
%>
<DIV id="tabBar">
  <div class="tabs">
    <ul>
      <li id="menu1"><a href="manager.jsp">配置</a></li>
      <li id="menu2"><a href="software_list.jsp">软件管理</a></li>
      <li id="menu3"><a href="software_statistic_user_list.jsp">发布统计</a></li>
      <li id="menu4"><a href="software_download_rank.jsp">下载排行</a></li>	  
    </ul>
  </div>
</DIV>
<script>
$("menu1").className="active"; 
</script>
<br>
<table width="98%" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr>
    <td height=20 align="left" class="thead">下载配置</td>
  </tr>
  <tr>
    <td valign="top"><br>
      <form id="form2" name="form2" action="manager.jsp?op=setIsNeedLogin" method="post">
        <table width="73%" align="center" class="frame_gray">
          <tr>
            <td height="22" class="thead">配置信息</td>
          </tr>
          <tr>
            <td height="22">是否需登录后才能下载
              <select name="isNeedLogin">
				<option value="true">是</option>
				<option value="false">否</option>
				</select>
				<script>
				form2.isNeedLogin.value = "<%=StrUtil.getNullString(cfg.getProperty("isNeedLogin"))%>";
				</script>
				<input name="submit" type="submit" class="btn" value="确 定"></td>
          </tr>
        </table>
		</form>
        <br>
		<form name="formRcmd" action="manager.jsp?op=setRecommand" method="post">
        <table width="73%" align="center" class="frame_gray">
          <tr>
            <td height="22" class="thead"><strong>推荐软件( 编号之间用，分隔 )</strong></td>
          </tr>
          <tr>
            <td height="22">
			<input value="<%=StrUtil.getNullString(cfg.getProperty("recommand"))%>" name="recommand" size=60>
            <input name="button" type="button" class="btn" onClick="openSelRecommandDocWin()" value="选 择">
            <input type="submit" class="btn" value="确 定"></td>
          </tr>
          <tr>
            <td height="22"><%
				DocumentMgr mm = new DocumentMgr();
				Document md = null;
				int[] v = cfg.getRecommandIds();
				int focuslen = v.length;
				if (focuslen==0)
					out.print("无推荐软件！");
				else {
					for (int k=0; k<focuslen; k++) {
						md = mm.getDocument(v[k]);
						if (md!=null && md.isLoaded()) {
							String color = StrUtil.getNullString(md.getColor());
							if (color.equals("")) {%>
              <%=md.getId()%>&nbsp;<a target="_blank" href="../../../../doc_view.jsp?id=<%=md.getId()%>"><%=md.getTitle()%></a>
              <%}else{%>
              <%=md.getId()%>&nbsp;<a target="_blank" href="../../../../doc_view.jsp?id=<%=md.getId()%>"><font color="<%=color%>"><%=md.getTitle()%></font></a>
              <%}%>              &nbsp;[<a href="javascript:delRecommand('<%=md.getId()%>')">
              <lt:Label key="op_del"/></a>]
              <%if (k!=0) {%>
              [<a href="javascript:up('<%=md.getId()%>')">
              <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="up"/></a>]
              <%}%>
              <%if (k!=focuslen-1) {%>
              &nbsp;[<a href="javascript:down('<%=md.getId()%>')">
              <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="down"/></a>]
              <%}%>
              <br>
              <%}else {%>
              <%=v[k]%>&nbsp;<font color=red>文章不存在</font>&nbsp;[<a href="javascript:delRecommand('<%=v[k]%>')">
              <lt:Label key="op_del"/></a>]<BR>
              <%}
			}
		}%>
            </td>
          </tr>
        </table>
      </form>
      <br>
      <br></td>
  </tr>
</table>
</body>
</html>
