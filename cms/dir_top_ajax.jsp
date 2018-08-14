<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.db.*" %>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<%
String root_code = ParamUtil.get(request, "root_code");
if (root_code.equals("")) {
	root_code = "root";
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><lt:Label res="res.label.cms.dir" key="content"/></title>
<LINK href="default.css" type=text/css rel=stylesheet>
<style>
a.column:link {
font-weight:bold;
}
a.column:visited {
font-weight:bold;
}
a.subsite:link {
font-weight:bold;
color:#0066FF;
}
a.subsite:visited {
font-weight:bold;
color:#0066FF;
}
a.link:link {
font-weight:bold;
}
a.link:visited {
font-weight:bold;
}
</style>
<script src="../inc/common.js"></script>
<script>
function insertAdjacentHTML(objId,code,isStart){ 
	var obj = document.getElementById(objId);
	if(isIE()) 
		obj.insertAdjacentHTML(isStart ? "afterbegin" : "afterEnd",code); 
	else{
		var range=obj.ownerDocument.createRange(); 
		range.setStartBefore(obj); 
		var fragment = range.createContextualFragment(code); 
		if(isStart) 
			obj.insertBefore(fragment,obj.firstChild); 
		else 
			obj.appendChild(fragment); 
	}
}

function findObj(theObj, theDoc) {
  var p, i, foundObj;
  
  if(!theDoc) theDoc = document;
  if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
  {
    theDoc = parent.frames[theObj.substring(p+1)].document;
    theObj = theObj.substring(0,p);
  }
  if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
  for (i=0; !foundObj && i < theDoc.forms.length; i++) 
    foundObj = theDoc.forms[i][theObj];
  for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++) 
    foundObj = findObj(theObj,theDoc.layers[i].document);
  if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
  
  return foundObj;
}

function ShowChild(imgobj, name) {
	var tableobj = findObj("childof"+name);
	if (tableobj==null) {
		// document.frames.ifrmGetChildren.location.href = "dir_ajax_getchildren.jsp?root_code=" + root_code + "&parentCode=" + name;
		document.getElementById("ifrmGetChildren").src = "dir_ajax_getchildren.jsp?root_code=" + root_code + "&parentCode=" + name;
		if (imgobj.src.indexOf("i_puls-root-1.gif")!=-1)
			imgobj.src = "images/i_puls-root.gif";
		if (imgobj.src.indexOf("i_plus.gif")!=-1) {
			imgobj.src = "images/i_minus.gif";
		}
		else
			imgobj.src = "images/i_plus.gif";
		return;
	}
	if (tableobj.style.display=="none")
	{
		tableobj.style.display = "";
		if (imgobj.src.indexOf("i_puls-root-1.gif")!=-1)
			imgobj.src = "images/i_puls-root.gif";
		if (imgobj.src.indexOf("i_plus.gif")!=-1)
			imgobj.src = "images/i_minus.gif";
		else
			imgobj.src = "images/i_plus.gif";
	}
	else
	{
		tableobj.style.display = "none";
		if (imgobj.src.indexOf("i_plus.gif")!=-1)
			imgobj.src = "images/i_minus.gif";
		else
			imgobj.src = "images/i_plus.gif";
	}
}

// 折叠目录
function shrink() {
   for(var i=0; i<document.images.length; i++) {
		var imgObj = document.images[i];
		try {
			if (imgObj.tableRelate!="") {
				ShowChild(imgObj, imgObj.tableRelate);
			}
		}
		catch (e) {
		}
   }
}

function showModify(obj) {
	var aObj = obj.getElementsByTagName('span');
	if (aObj.length>1) {
		aObj[aObj.length-1].style.display = '';
	}
}
function hiddenModify(obj) {
	var aObj = obj.getElementsByTagName('span');
	if (aObj.length>1) {	
		aObj[aObj.length-1].style.display = 'none';
	}
}

var isSuo = true;
function shensuo() {
	if (isSuo) {
		isSuo = false;
		$("imgShensuo").src = "images/shousuo.gif";
	}
	else {
		isSuo = true;
		$("imgShensuo").src = "images/shenzhan.gif";
	}
	window.parent.shensuo();
}

function onclick(evt){
	evt = (evt) ? evt : ((window.event) ? window.event : "")
	if (evt) {
		var obj = (evt.target) ? evt.target : evt.srcElement
		if(obj.tagName=="A"){
			var tagText = obj.innerHTML;
			if (tagText.indexOf("修改")!=-1 || tagText.indexOf("添")!=-1) {
				if (isSuo) {
					shensuo();
				}
			}
		}		  
	}
}

if ( window.addEventListener )
	document.addEventListener("onclick",onclick,true)
else
	document.onclick = onclick;

function init() {
	if (window.parent.allFrame.rows==window.parent.shen) {
		isSuo = false;
		shensuo();
	}
}

function doAdd(parentCode, code) {
	// 删除父目录的孩子节点，然后用ajax重新获取
	var ch = $("childof" + parentCode);
	if (ch!=null) {
		// ch.outerHTML = "";
		ch.parentNode.removeChild(ch);
	}
	
	// 取得含有tableRelate属性的图片，将展开标志图象改为加号
	var p = $(parentCode);
	var ary = p.getElementsByTagName("img");
	var isFound = false;
	for (i=0; i<ary.length; i++) {
		if (ary[i].attributes['tableRelate']!=null) {
			ary[i].src = "images/i_plus.gif";
			ShowChild(ary[i], ary[i].attributes['tableRelate'].nodeValue);
			return;
		}
	}
	
	if (!isFound) {
		ary[0].style.width = (parseInt(ary[0].width)-16) + "px";
		var str = "<img style='cursor:pointer' tableRelate='" + parentCode + "' onClick=\"ShowChild(this, '" + parentCode + "')\" src='images/i_plus.gif' align='absmiddle' style='margin-right:3px'>";
		ary[0].insertAdjacentHTML("afterEnd", str);
		
		var ary = p.getElementsByTagName("img");
		for (i=0; i<ary.length; i++) {
			if (ary[i].attributes['tableRelate']!=null) {
				ary[i].src = "images/i_plus.gif";
				ShowChild(ary[i], ary[i].attributes['tableRelate'].nodeValue);
				return;
			}
		}		
	}
}

function doModify(tableId, newName) {
	var tableObj = findObj(tableId);
	var ary = tableObj.getElementsByTagName("A");
	ary[0].innerText = newName;
}

function doDel(tableId) {
	$(tableId).parentNode.removeChild($(tableId));
}

function doMove(tableId, tableId2) {
	var t = $(tableId);
	var t2 = $(tableId2);
	
	if (t==null || t2==null)
		return;
	
	var tn = $(tableId).cloneNode(true);
	var tn2 = $(tableId2).cloneNode(true);

	var tch = $("childof"+tableId);
	var tch2 = $("childof"+tableId2);
	
	var tchn = null;
	if (tch!=null)
		tchn = tch.cloneNode(true);
	var tchn2 = null;
	if (tch2!=null)
		tchn2 = tch2.cloneNode(true);

	var p = t.parentNode;

	if (tch==null && tch2==null) {
		p.replaceChild(tn2, t);
		p.replaceChild(tn, t2);
	}
	else if (tch==null && tch2!=null) {
		p.replaceChild(tn2, t);
		p.replaceChild(tchn2, t2);
		p.replaceChild(tn, tch2);
	}
	else if (tch!=null && tch2==null) {
		p.replaceChild(tn2, t);
		p.replaceChild(tn, tch);
		p.replaceChild(tchn, t2);
	}
	else {
		p.replaceChild(tn2, t);
		p.replaceChild(tn, t2);
		
		p.replaceChild(tchn2, tch);
		p.replaceChild(tchn, tch2);
	}		
}
</script>
</head>
<body onLoad="init()">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String op = ParamUtil.get(request, "op");
%>
<jsp:useBean id="leafPriv" scope="page" class="cn.js.fan.module.cms.LeafPriv"/>
<%
LeafPriv lp = new LeafPriv();
lp.setDirCode(root_code);
/*
if (!lp.canUserSee(privilege.getUser(request))) {
	out.print(SkinUtil.makeErrMsg(request, privilege.MSG_INVALID));
	// return;
}
*/
%>
<Script>
var root_code = "<%=root_code%>";
// 使框架的bottom能得到此root_code
function getRootCode() {
	return root_code;
}
</Script>
<%
if (op.equals("AddChild")) {
    String parent_code = ParamUtil.get(request, "parent_code").trim();
	lp.setDirCode(parent_code);
	if (!lp.canUserExamine(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	boolean re = false;
	try {
		re = dir.AddChild(request);
		if (!re) {
			out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","add_msg")));
		}	
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
else if (op.equals("move")) {
	String code = ParamUtil.get(request, "code");
	lp.setDirCode(code);
	if (!lp.canUserExamine(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	boolean re = false;
	try {
		re = dir.move(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert("操作成功！"));
	}
}
Leaf leaf = dir.getLeaf(root_code);
if (op.equals("repair")) {
	dir.repairTree(leaf);
	out.print(StrUtil.Alert_Redirect("操作成功！", "dir_top_ajax.jsp?root_code=" + StrUtil.UrlEncode(root_code)));
	return;
}

if (leaf==null || !leaf.isLoaded()) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, "res.label.cms.dir","node") + root_code + SkinUtil.LoadString(request, "res.label.cms.dir","not_exsist")));
	return;
}
String root_name = leaf.getName();
int root_layer = leaf.getLayer();
String root_description = leaf.getDescription();
boolean isHome = false;
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td width="87%" class="head"><lt:Label res="res.label.cms.dir" key="mgr"/>&nbsp;<%=root_name%>&nbsp;&nbsp;（点击目录节点可以发布文章）</td>
    <td width="13%" align="right" class="head">
	<img id="imgShensuo" onClick="shensuo()" src="images/shenzhan.gif" style="cursor:pointer" border="0" />&nbsp;	</td>
  </tr>
</table>
<br>
<TABLE class="frame_gray"  
cellSpacing=0 cellPadding=0 width="95%" align=center>
  <TBODY>
    <TR>
      <TD height=200 valign="top" bgcolor="#FFFBFF">
<table class="tbg1" cellspacing=0 cellpadding=0 width="100%" align=center onMouseOver="this.className='tbg1sel'" onMouseOut="this.className='tbg1'" 
border=0>
          <tbody>
            <tr>
              <td width="66%" height="22" align=left nowrap>
			  &nbsp;
			  <%if (!leaf.getParentCode().equals("-1")) {
			   boolean canUp = true;
			   if (leaf.getType()==Leaf.TYPE_SUB_SITE) {
			   		if (!privilege.isUserPrivValid(request, "admin")) {
						canUp = false;
					}
			   }
			   if (canUp) {
			  	Leaf parLeaf = leaf.getLeaf(leaf.getParentCode());
			  %>
			  >>&nbsp;上级目录：<a href="dir_top_ajax.jsp?root_code=<%=StrUtil.UrlEncode(parLeaf.getCode())%>"><%=parLeaf.getName()%></a>
			  <%}
			  }%>
			  </td>
            <td width="34%" align=right nowrap>>>&nbsp;<a href="dir_top_ajax.jsp?op=repair&root_code=<%=root_code%>">
              修复
            </a>&nbsp;<%=root_name%>&nbsp;<a target="_parent" href="document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(root_code)%>&dir_name=<%=StrUtil.UrlEncode(root_name)%>"></a>
			<%
			if (!Leaf.isLeafOfSubsite(root_code)) {
				lp = new LeafPriv(root_code);
				if (lp.canUserExamine(privilege.getUser(request))) {
			%>
				<a href="dir_priv_m.jsp?dirCode=<%=StrUtil.UrlEncode(root_code)%>" target="_parent"><lt:Label res="res.label.cms.dir" key="pvg"/></a>&nbsp;
				<a target=dirbottomFrame href="dir_bottom.jsp?parent_code=<%=StrUtil.UrlEncode(root_code, "utf-8")%>&parent_name=<%=StrUtil.UrlEncode(root_name, "utf-8")%>&op=AddChild"><lt:Label res="res.label.cms.dir" key="add_content"/></a>&nbsp;
				<a target="dirbottomFrame" href="dir_bottom.jsp?op=modify&code=<%=StrUtil.UrlEncode(root_code, "utf-8")%>&name=<%=StrUtil.UrlEncode(root_name,"utf-8")%>&description=<%=StrUtil.UrlEncode(root_description,"utf-8")%>">
				<lt:Label res="res.label.cms.dir" key="modify"/></a>&nbsp; 
				<!--<a target=_self href="#" onClick="if (window.confirm('您确定要删除<%=root_name%>吗?')) window.location.href='dir_top_ajax?op=del&delcode=<%=root_code%>'">删除</a>-->
			<%	}
			}%>
			  </td>
            </tr>
          </tbody>
        </table>
<%
DirectoryView tv = new DirectoryView(request, leaf);
tv.listAjax(request, out, true);
%>
	</TD>
    </TR>
  </TBODY>
</TABLE>
<iframe id="ifrmGetChildren" style="display:none" src="" width="100%" height="200"></iframe>
</body>
</html>
