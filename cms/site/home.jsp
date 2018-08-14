<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<%
String siteCode = ParamUtil.get(request, "siteCode");
SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<LINK href="../../cms/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>首页管理</title>
<style>
.btn {
border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;
}
.style1 {
	font-size: 14px;
	font-weight: bold;
}
</style>
<script src="../../inc/common.js"></script>
<script language="JavaScript">
<!--
function openWin(url,width,height) {
	var newwin = window.open(url,"_blank","scrollbars=yes,resizable=yes,toolbar=no,location=no,directories=no,status=yes,menubar=no,top=50,left=120,width="+width+",height="+height);
}

var curObj;

function openSelRecommandDocWin() {
	curObj = form1.recommand;
	openWin("document_sel.jsp?siteCode=<%=siteCode%>", 800, 600);	
}

function openSelFocusDocWin() {
	curObj = form2.myfocus;
	openWin("document_sel.jsp?siteCode=<%=siteCode%>", 800, 600);	
}

function selDoc(ids) {
	// 检查是否已包含了ids中的id，避免重复加入
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
	if (!confirm("您确定要删除么？"))
		return;
	var ntc = form1.recommand.value;
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
	form1.recommand.value = ntc;
	form1.submit();
}

function up(id) {
	var ntc = form1.recommand.value;
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
	form1.recommand.value = ntc;
	form1.submit();
}

function down(id) {
	var ntc = form1.recommand.value;
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
	form1.recommand.value = ntc;
	form1.submit();
}

function delFocus(id) {
	if (!confirm("您确定要删除么？"))
		return;
	var ntc = form2.myfocus.value;
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
	form2.myfocus.value = ntc;
	form2.submit();
}

function upFocus(id) {
	var ntc = form2.myfocus.value;
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
	form2.myfocus.value = ntc;
	form2.submit();
}

function downFocus(id) {
	var ntc = form2.myfocus.value;
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
	form2.myfocus.value = ntc;
	form2.submit();
}
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理首页</td>
  </tr>
</table>
<%
String op = ParamUtil.get(request, "op");
if (op.equals("setRecommand")) {
	String recommand = ParamUtil.get(request, "recommand");
	sd.set("doc_recommand", recommand);
	sd.save();
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp?siteCode=" + siteCode));
	return;
}
else if (op.equals("setFocus")) {
	String focus = ParamUtil.get(request, "myfocus");
	sd.set("doc_focus", focus);
	sd.save();
	out.print(StrUtil.Alert_Redirect("操作成功！", "home.jsp?siteCode=" + siteCode));
	return;
}
%>
<br>
<table width="73%" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
  <form id=form1 name=form1 action="?op=setRecommand" method=post>
    <tr>
      <td height="22" class="thead"><strong><a name="recommand">推荐文章</a></strong>&nbsp;( 编号之间用，分隔 )</td>
    </tr>
    <tr>
      <td height="22"><input type=text value="<%=StrUtil.getNullString(sd.getString("doc_recommand"))%>" name="recommand" size=60>
          <input name="button" type="button" class="btn" onClick="openSelRecommandDocWin()" value="选 择">
          <input name="submit" type="submit" class="btn" value="确 定">
          <input name="siteCode" value="<%=siteCode%>" type="hidden">
      </td>
    </tr>
    <tr>
      <td height="22"><%
			DocumentMgr dm = new DocumentMgr();
			Document doc = null;
			String[] ids = StrUtil.split(StrUtil.getNullStr(sd.getString("doc_recommand")), ",");
			int len = 0;
			if (ids!=null)
				len = ids.length;
			if (len==0)
				out.print("无推荐文章！");
			else {
				for (int k=0; k<len; k++) {
					doc = dm.getDocument(StrUtil.toInt(ids[k]));
					if (doc.isLoaded()) {
					%>
          <%=doc.getId()%>&nbsp;<img src="../images/arrow.gif">&nbsp;<a target="_blank" href="../../site_doc.jsp?docId=<%=doc.getId()%>"><%=doc.getTitle()%></a> &nbsp;&nbsp;[<a href="javascript:delRecommand('<%=doc.getId()%>')">
          <lt:Label key="op_del"/>
          </a>]
        <%if (k!=0) {%>
        &nbsp;&nbsp;[<a href="javascript:up('<%=doc.getId()%>')">
          <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="up"/>
          </a>]
        <%}%>
        <%if (k!=len-1) {%>
        &nbsp;&nbsp;[<a href="javascript:down('<%=doc.getId()%>')">
          <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="down"/>
          </a>]
        <%}%>
        <br>
        <%}
					else {%>
        <%=doc.getId()%>&nbsp;<font color=red><img src="../images/arrow.gif">&nbsp;文章不存在</font> &nbsp;&nbsp;[<a href="javascript:delRecommand('<%=doc.getId()%>')">
          <lt:Label key="op_del"/>
          </a>]<BR>
        <%}
				}
			}%>
      </td>
    </tr>
  </form>
</table>
<br>
<table width="73%" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
  <form id=form2 name=form2 action="?op=setFocus" method=post>
    <tr>
      <td height="22" class="thead"><strong><a name="recommand">焦点文章</a></strong>&nbsp;( 编号之间用，分隔 )</td>
    </tr>
    <tr>
      <td height="22"><input type=text value="<%=StrUtil.getNullString(sd.getString("doc_focus"))%>" name="myfocus" size=60>
          <input name="button2" type="button" class="btn" onClick="openSelFocusDocWin()" value="选 择">
          <input name="submit22" type="submit" class="btn" value="确 定">
          <input name="siteCode" value="<%=siteCode%>" type="hidden">
      </td>
    </tr>
    <tr>
      <td height="22"><%
			ids = StrUtil.split(StrUtil.getNullStr(sd.getString("doc_focus")), ",");
			len = 0;
			if (ids!=null)
				len = ids.length;
			if (len==0)
				out.print("无焦点文章！");
			else {
				for (int k=0; k<len; k++) {
					doc = dm.getDocument(StrUtil.toInt(ids[k]));
					if (doc.isLoaded()) {
					%>
          <%=doc.getId()%>&nbsp;<img src="../images/arrow.gif">&nbsp;<a target="_blank" href="../../site_doc.jsp?docId=<%=doc.getId()%>"><%=doc.getTitle()%></a> &nbsp;&nbsp;[<a href="javascript:delFocus('<%=doc.getId()%>')">
          <lt:Label key="op_del"/>
          </a>]
        <%if (k!=0) {%>
        &nbsp;&nbsp;[<a href="javascript:upFocus('<%=doc.getId()%>')">
          <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="up"/>
          </a>]
        <%}%>
        <%if (k!=len-1) {%>
        &nbsp;&nbsp;[<a href="javascript:downFocus('<%=doc.getId()%>')">
          <lt:Label res="res.label.forum.admin.ad_topic_bottom" key="down"/>
          </a>]
        <%}%>
        <br>
        <%}
					else {%>
        <%=doc.getId()%>&nbsp;<font color=red><img src="../images/arrow.gif">&nbsp;文章不存在</font> &nbsp;&nbsp;[<a href="javascript:delFocus('<%=doc.getId()%>')">
          <lt:Label key="op_del"/>
          </a>]<BR>
        <%}
				}
			}%>
      </td>
    </tr>
  </form>
</table>
</td>
</tr>
</table>
</td>
</tr>
</table>
</body>                                        
</html>                            
  