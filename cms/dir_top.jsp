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
/**
* 仿windows2000的目录树显示，已暂时放弃不使用该页面
**/
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
</style>
<script>
function findObj(theObj, theDoc)
{
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

function ShowChild(imgobj, name)
{
	var tableobj = findObj("childof"+name);
	if (tableobj.style.display=="none")
	{
		tableobj.style.display = "";
		if (imgobj.src.indexOf("i_puls-root-1.gif")!=-1)
			imgobj.src = "images/i_puls-root.gif";
		if (imgobj.src.indexOf("i_plus-1-1.gif")!=-1)
			imgobj.src = "images/i_plus2-2.gif";
		if (imgobj.src.indexOf("i_plus-1.gif")!=-1)
			imgobj.src = "images/i_plus2-1.gif";
	}
	else
	{
		tableobj.style.display = "none";
		if (imgobj.src.indexOf("i_puls-root.gif")!=-1)
			imgobj.src = "images/i_puls-root-1.gif";
		if (imgobj.src.indexOf("i_plus2-2.gif")!=-1)
			imgobj.src = "images/i_plus-1-1.gif";
		if (imgobj.src.indexOf("i_plus2-1.gif")!=-1)
			imgobj.src = "images/i_plus-1.gif";
	}
}

// 折叠目录
function shrink() {
   return;
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
</script>
</head>
<body onLoad="shrink()">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<jsp:useBean id="dir" scope="page" class="cn.js.fan.module.cms.Directory"/>
<%
String root_code = ParamUtil.get(request, "root_code");
if (root_code.equals("")) {
	root_code = "root";
}
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
String op = ParamUtil.get(request, "op");
if (op.equals("AddRootChild")) {
	if (!lp.canUserModify(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	boolean re = false;
	try {
		re = dir.AddRootChild(request);
		if (!re) {
			out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","add_msg")));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
if (op.equals("AddChild")) {
    String parent_code = ParamUtil.get(request, "parent_code").trim();
	lp.setDirCode(parent_code);
	if (!lp.canUserModify(privilege.getUser(request))) {
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
if (op.equals("del")) {
	String delcode = ParamUtil.get(request, "delcode");
	lp.setDirCode(delcode);
	if (!lp.canUserModify(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	Leaf delleaf = dir.getLeaf(delcode);
	if (delleaf==null) {
	}
	else {
		try {
			dir.del(delcode);
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "res.label.cms.dir","success_del"), "dir_top.jsp?root_code=" + StrUtil.UrlEncode(root_code)));
		}
		catch (ErrMsgException e) {
			out.print(StrUtil.Alert(e.getMessage()));
		}
	}
}
if (op.equals("modify")) {
	String code = ParamUtil.get(request, "code");
	lp.setDirCode(code);
	if (!lp.canUserModify(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	boolean re = true;
	try {
		re = dir.update(request);
		if (re)
			out.print(StrUtil.Alert(SkinUtil.LoadString(request, "res.label.cms.dir","modify_finished")));
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
if (op.equals("move")) {
	String code = ParamUtil.get(request, "code");
	lp.setDirCode(code);
	if (!lp.canUserModify(privilege.getUser(request))) {
		out.print(StrUtil.Alert_Back(privilege.MSG_INVALID));
		return;
	}
	try {
		dir.move(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
}
if (op.equals("removecache")) {
	String curcode = ParamUtil.get(request, "code");
	LeafChildrenCacheMgr.remove(curcode);
	out.print(StrUtil.Alert(curcode + SkinUtil.LoadString(request, "res.label.cms.dir","cache_cleared")));
}

Leaf leaf = dir.getLeaf(root_code);
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
    <td class="head"><lt:Label res="res.label.cms.dir" key="mgr"/>&nbsp;<%=root_name%></td>
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
              <td width="66%" height="13" align=left nowrap>
			  &nbsp;&nbsp;&nbsp;&nbsp;</td>
            <td width="34%" align=right nowrap>>>&nbsp;<%=root_name%>&nbsp;&nbsp;<a target="_parent" href="document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(root_code)%>&dir_name=<%=StrUtil.UrlEncode(root_name)%>"></a><a href="dir_priv_m.jsp?dirCode=<%=StrUtil.UrlEncode(root_code)%>" target="_parent"><lt:Label res="res.label.cms.dir" key="pvg"/></a>&nbsp;&nbsp;<a target=dirbottomFrame href="dir_bottom.jsp?parent_code=<%=StrUtil.UrlEncode(root_code, "utf-8")%>&parent_name=<%=StrUtil.UrlEncode(root_name, "utf-8")%>&op=AddChild"><lt:Label res="res.label.cms.dir" key="add_content"/></a> <a target="dirbottomFrame" href="dir_bottom.jsp?op=modify&code=<%=StrUtil.UrlEncode(root_code, "utf-8")%>&name=<%=StrUtil.UrlEncode(root_name,"utf-8")%>&description=<%=StrUtil.UrlEncode(root_description,"utf-8")%>"><lt:Label res="res.label.cms.dir" key="modify"/></a> <!--<a target=_self href="#" onClick="if (window.confirm('您确定要删除<%=root_name%>吗?')) window.location.href='dir_top.jsp?op=del&delcode=<%=root_code%>'">删除</a>-->
			  </td>
            </tr>
          </tbody>
        </table>
<%
DirectoryView tv = new DirectoryView(request, leaf);
tv.list(request, out);
%></TD>
    </TR>
  </TBODY>
</TABLE>
</body>
</html>
