<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.db.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="cn.js.fan.module.cms.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>主题管理</title>
<LINK href="default.css" type=text/css rel=stylesheet>
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
</script>
<style type="text/css">
<!--
body {
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>
<body style="overflow:auto">
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.println(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<jsp:useBean id="dm" scope="page" class="cn.js.fan.module.cms.FlashStoreDirMgr"/>
<%
String root_code = ParamUtil.get(request, "root_code");
if (root_code.equals(""))
{
	root_code = "root";
}
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
String dir = ParamUtil.get(request, "dir");
if (op.equals("AddChild")) {
	boolean re = false;
	try {
		re = dm.AddChild(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	if (re) {
		out.print(StrUtil.Alert("操作成功！"));
	}
}
if (op.equals("del")) {
	String delcode = ParamUtil.get(request, "code");
	try {
		dm.del(delcode);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}
if (op.equals("modify")) {
	boolean re = false;
	try {
		re = dm.update(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
	if (re)
		out.print(StrUtil.Alert("修改完成"));
}
if (op.equals("move")) {
	try {
		dm.move(request);
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
		return;
	}
}

FlashStoreDirDb leaf = dm.getFlashStoreDirDb(root_code);
if (op.equals("repair")) {
	dm.repairTree(leaf);
	leaf = dm.getFlashStoreDirDb(root_code);
}

String root_name = leaf.getName();
int root_layer = leaf.getLayer();
String root_description = leaf.getDescription();
boolean isHome = false;
String action = ParamUtil.get(request, "action");

// 如果dir不为空，则往上遍历，直至找到子站点
if (!dir.equals("")) {
	cn.js.fan.module.cms.Leaf lf = new Leaf();
	lf = lf.getLeaf(dir);
	if (lf.getType()==Leaf.TYPE_SUB_SITE) {
		leaf = dm.getFlashStoreDirDb(lf.getCode());
	}
	else {
        String parentcode = lf.getParentCode();

        Leaf plf = new Leaf();
        while (!parentcode.equals("root")) {
            plf = plf.getLeaf(parentcode);
			if (plf.getType()==Leaf.TYPE_SUB_SITE) {
				leaf = dm.getFlashStoreDirDb(plf.getCode());
				// System.out.println("leaf.code=" + leaf.getCode());
				if (!leaf.isLoaded()) {
					cn.js.fan.module.cms.Directory directory = new cn.js.fan.module.cms.Directory();
					directory.initFlashDirOfSubsite(plf);
					leaf = dm.getFlashStoreDirDb(plf.getCode());
				}
				break;
			}
            parentcode = plf.getParentCode();
       }
	}
}
%>
<TABLE width="100%" height="100%" align=center cellPadding=0 
cellSpacing=0>
  <TBODY>
    <TR>
      <TD height="10" valign="top" bgcolor="#FFFBFF"></TD>
    </TR>
    <TR>
      <TD valign="top" bgcolor="#FFFBFF"><%
FlashStoreDirView dv = new FlashStoreDirView(leaf);
dv.ListSimple(out, "mainFileFrame", "flash_list.jsp?action=" + action + "&isFromLeftFrame=true&dir=" + StrUtil.UrlEncode(dir) + "&dirCode=", "", "" );
%></TD>
    </TR>
  </TBODY>
</TABLE>
</body>
</html>
