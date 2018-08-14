<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.db.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="cn.js.fan.module.cms.plugin.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.println(SkinUtil.makeErrMsg(request, Privilege.MSG_INVALID));
	return;
}
%>
<%
String parent_code = ParamUtil.get(request, "parent_code");
if (parent_code.equals(""))
	parent_code = "root";
String parent_name = ParamUtil.get(request, "parent_name");
Leaf plf = new Leaf();
plf = plf.getLeaf(parent_code);
parent_name = plf.getName();

String curDir = parent_code;

String code = ParamUtil.get(request, "code");
String name = ParamUtil.get(request, "name");
String description = ParamUtil.get(request, "description");
String className = "";
String op = ParamUtil.get(request, "op");
boolean isHome = false;
int type = 0;
String opRaw = op;
if (op.equals(""))
	op = "AddChild";
if (op.equals("AddChild")) {
	LeafPriv lp = new LeafPriv();
	lp.setDirCode(parent_code);
	if (!lp.canUserAppend(privilege.getUser(request))) {
		out.print("<LINK href=\"default.css\" type=text/css rel=stylesheet>");
		if (opRaw.equals("")) {
			out.print(StrUtil.p_center("<BR><BR><BR>目录属性编辑区域"));
		}
		else
			out.println(SkinUtil.makeErrMsg(request, Privilege.MSG_INVALID));
		return;
	}
}

Leaf leaf = null;
if (op.equals("modify")) {
	LeafPriv lp = new LeafPriv(code);
	if (!lp.canUserModify(privilege.getUser(request))) {
		out.print("<LINK href=\"default.css\" type=text/css rel=stylesheet>");
		out.print(SkinUtil.makeErrMsg(request, Privilege.MSG_INVALID));
		return;
	}

	Directory dir = new Directory();
	leaf = dir.getLeaf(code);
	name = leaf.getName();
	parent_name = "";
	if (!leaf.getParentCode().equals("-1"))
		parent_name = leaf.getLeaf(leaf.getParentCode()).getName();
	description = leaf.getDescription();
	type = leaf.getType();
	isHome = leaf.getIsHome();
	className = leaf.getClassName();
	
	curDir = code;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<LINK href="default.css" type=text/css rel=stylesheet>
<script src="../inc/common.js"></script>
<script>
function form1_onsubmit() {
	form1.type.value = form1.seltype.value;
	form1.root_code.value = window.parent.dirmainFrame.getRootCode();
}

function selTemplate(id)
{
	if (form1.templateId.value!=id) {
		form1.templateId.value = id;
	}
}

function enableSelType() {
	if (confirm("<lt:Label res="res.label.cms.dir" key="msg"/>")) {
		form1.seltype.disabled = false;
	}
}

function openWin(url,width,height) {
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,top=50,left=120,width="+width+",height="+height);
}

var urlObj;
function SelectImage(urlObject) {
	urlObj = urlObject;
	openWin("img_frame.jsp?action=selectImage&dir=<%=StrUtil.UrlEncode(curDir)%>", 800, 600);
}

function setImgUrl(visualPath) {
	urlObj.value = visualPath;
}

function selectNode(code, name) {
	form1.parentCode.value = code;
	$("parentName").innerHTML = name;
}

var errFunc = function(response) {
    alert('Error ' + response.status + ' - ' + response.statusText);
	alert(response.responseText);
}

function doGetPintYing(response) {
	var items = response.responseXML.getElementsByTagName("pingYin");
	for (var i=0; i<items.length; i++) {
		var item = items[i];
		$("code").value = item.firstChild.data;
		return;
	}
}

function getPingYin(parentCode) {
	if ($("name").value=="") {
		alert("请输入目录名称！");
		return;
	}
	var str = "op=getPingYin&str=" + $("name").value + "&parentCode=" + parentCode;
	var myAjax = new cwAjax.Request( 
		"tool.jsp", 
		{
			method:"post", 
			parameters:str, 
			onComplete:doGetPintYing,
			onError:errFunc
		}
	);
}
</script>
<style type="text/css">
<!--
.STYLE1 {color: #FF0000}
-->
</style>
</head>
<body>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%"><lt:Label res="res.label.cms.dir" key="contents_add_or_modify"/></TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD align="center" style="PADDING-LEFT: 10px"><table class="frame_gray" width="564" border="0" cellpadding="0" cellspacing="1">
        <tr>
          <td align="center"><table width="98%">
            <form name="form1" method="post" action="dir_do.jsp?op=<%=op%>" target="dirhidFrame" onClick="return form1_onsubmit()">
              <tr>
                <td width="78" rowspan="7" align="left" valign="top"><br>
                  <lt:Label res="res.label.cms.dir" key="cur_node"/><br>
                    <font color=blue><%=parent_name.equals("")?SkinUtil.LoadString(request, "res.label.cms.dir","root_node"):parent_name%></font>					</td>

                <td align="left"><lt:Label res="res.label.cms.dir" key="name"/>
                    <input name="name" value="<%=StrUtil.HtmlEncode(name)%>">
                     Logo 
                    <input name="logo" value="<%=op.equals("modify")?leaf.getLogo():""%>">
                    <input name="button" type="button" onClick="SelectImage(form1.logo);" value="选择" /></td>
              </tr>
              <tr>
                <td width="312" align="left"> <lt:Label res="res.label.cms.dir" key="code"/>
                    <input name="code" value="<%=code%>" maxlength="20" <%=op.equals("modify")?"readonly title='编码不能被修改'":""%>>
                    <!--<select name="target">
                      <option value="">默认</option>
                      <option value="_parent">父窗口</option>
                      <option value="_top">顶层窗口</option>
                      <option value="_blank">新窗口</option>
                      <option value="_self">本窗口</option>
                    </select>-->
                    <span class="STYLE1">*</span>
					<%if (!op.equals("modify")) {%>
					[<a href="javascript:getPingYin('<%=parent_code%>')">转换拼音</a>]
					<%}%>
					</td>              </tr>
              <tr>
                <td align="left">
				<lt:Label res="res.label.cms.dir" key="class_name"/>
				<input name="className" value="<%=className%>">
				<lt:Label res="res.label.cms.dir" key="link"/>
                <input name="description" value="<%=description%>">
                <input type=hidden name=parent_code value="<%=parent_code%>"></td>
              </tr>
              <tr>
                <td align="left">
				<%
				String disabled = "";
				if (op.equals("modify") && leaf.getType()>=1)
					disabled = "true";
				%>
				<lt:Label res="res.label.cms.dir" key="type"/>
                  <select name="seltype">
                    <option value="1"><lt:Label res="res.label.cms.dir" key="artical"/></option>
                    <option value="2" <%=op.equals("AddChild")?"selected":""%>><lt:Label res="res.label.cms.dir" key="list"/></option>
                    <option value="3"><lt:Label res="res.label.cms.dir" key="column"/></option>
                    <option value="4"><lt:Label res="res.label.cms.dir" key="sub_site"/></option>
                    <option value="5">链接</option>
                  </select>
				  <script>
				  <%if (op.equals("modify")) {%>
					  form1.seltype.value = "<%=type%>"
				  <%}%>
				  form1.seltype.disabled = "<%=disabled%>"
				  </script>
				  <input type=hidden name=root_code value="">
				  <input type=hidden name="type" value="<%=type%>">
                  <span class="unnamed2">
				  <%if (op.equals("modify")) {
						if (leaf.getType()==Leaf.TYPE_COLUMN || leaf.getType()==Leaf.TYPE_LIST || leaf.getType()==Leaf.TYPE_DOCUMENT) {				  
							String sql = "select code from cms_template_catalog order by orders asc";
							TemplateCatalogDb tcd = new TemplateCatalogDb();
							java.util.Iterator tcir = tcd.list(sql).iterator();
							%>
							模板组&nbsp;<select name="templateCatalog">
							<option value="<%=TemplateCatalogDb.CATALOG_CODE_DEFAULT%>">无</option>
							<%
							while (tcir.hasNext()) {
								tcd = (TemplateCatalogDb)tcir.next();
								out.print("<option value='" + tcd.getString("code") + "'>" + tcd.getString("name") + "</option>");
							}%>
							</select>
						  	<script>
						 	form1.templateCatalog.value = "<%=leaf.getTemplateCatalog()%>";
						 	</script>						
					<%
						}
						else {%>
						<input name="templateCatalog" value="<%=TemplateCatalogDb.CATALOG_CODE_DEFAULT%>" type="hidden">
						<%}
				  }%>
					</span> </td>
              </tr>
              <tr>
                <td align="left"><span class="unnamed2">
<%if (op.equals("modify")) {%>
    <script>
  	var bcode = "<%=leaf.getCode()%>";
    </script>
	<%if (leaf.getCode().equals(Leaf.ROOTCODE)) {%>
		<input name="parentCode" value="-1" type="hidden">
	<%}else{
		Leaf pLeaf = Leaf.getSubsiteOfLeaf(leaf.getCode());
		if (pLeaf==null)
			pLeaf = leaf.getLeaf(Leaf.ROOTCODE);
		else if (pLeaf.getType()==Leaf.TYPE_SUB_SITE) {
			if (privilege.isUserPrivValid(request, "admin"))
				pLeaf = leaf.getLeaf(Leaf.ROOTCODE);
			else
				pLeaf = pLeaf.getLeaf(pLeaf.getParentCode());
		}
		%>
		<lt:Label res="res.label.cms.dir" key="parent_node"/>：<%
		if (pLeaf.getCode().equals(Leaf.ROOTCODE)) {%>
			<span id="parentName"><%=parent_name%></span>&nbsp;[<a href="javascript:openWin('dir_sel.jsp', 480, 360)">选择</a>]
			<input name="parentCode" type="hidden" value="<%=leaf.getParentCode()%>">
		<%}	else {
	%>	  
			<select name="parentCode">
			<%
			DirectoryView dv = new DirectoryView(pLeaf);
			dv.ShowDirectoryAsOptionsWithCode(out, pLeaf, pLeaf.getLayer());
			%>
			</select>
			<script>
			form1.parentCode.value = "<%=leaf.getParentCode()%>";
			</script>
			&nbsp;( <span class="style3">
			<lt:Label res="res.label.cms.dir" key="blue"/></span><lt:Label res="res.label.cms.dir" key="no_content_or_list"/> )
		<%}
	}%>
<%}%>
                </span>
				<%
				boolean isShowKind = false;
				if (op.equals("modify")) {
					if (Leaf.getSubsiteOfLeaf(leaf.getCode())!=null)
						isShowKind = true;
				}
				else {
					if (Leaf.getSubsiteOfLeaf(parent_code)!=null)
						isShowKind = true;
				}
				if (isShowKind) {%>
				列表显示：
				<select name="kind">
				<option value="<%=Leaf.KIND_DOC%>">默认</option>
				<option value="<%=Leaf.KIND_IMG%>">图片</option>
				</select>
				<%if (op.equals("modify")) {%>
				<script>
				form1.kind.value = "<%=leaf.getKind()%>";
				</script>
				<%}%>
				<%}%>
				</td>
              </tr>
              <tr>
                <td align="left">
				<%if (op.equals("modify")) {%>
				<input type="checkbox" name="isHome" value="true" <%=isHome?"checked":""%> >
				<%}else{%>
				<input type="checkbox" name="isHome" value="true" checked>
				<%}%>
<lt:Label res="res.label.cms.dir" key="is_home"/>
<%if (op.equals("modify") && !Leaf.isLeafOfSubsite(leaf.getCode())) {
%>
<a href="dir_priv_m.jsp?dirCode=<%=StrUtil.UrlEncode(leaf.getCode())%>" target="_parent"><lt:Label res="res.label.cms.dir" key="pvg"/></a>
<%}%>  
			<lt:Label res="res.label.cms.dir" key="plugin"/>
			<select name=pluginCode>
			<option value="<%=PluginUnit.DEFAULT%>"><lt:Label res="res.label.cms.dir" key="default"/></option>
<%			
PluginMgr pm = new PluginMgr();
Vector v = pm.getAllPlugin();
Iterator ir = v.iterator();
while (ir.hasNext()) {
	PluginUnit pu = (PluginUnit)ir.next();
	if (pu.getCode().equals(cn.js.fan.module.cms.plugin.software.SoftwareUnit.code)) {
		if (op.equals("modify")) {
			if (Leaf.isLeafOfSubsite(leaf.getCode())) {
				continue;
			}
		}
		else {
			if (Leaf.isLeafOfSubsite(parent_code)) {
				continue;
			}
		}
	}
%>
<option value="<%=pu.getCode()%>"><%=pu.getName(request)%></option>
<%}%>
				<%if (op.equals("modify")) {%>
				<script>
				form1.pluginCode.value = "<%=leaf.getPluginCode()%>";
				</script>
				<%}%>
			</select>
			是否允许投稿
			<select name="isPost">
              <option value="1">是</option>
              <option value="0">否</option>
            </select>
			<%if (op.equals("modify")) {%>
            <script>
			form1.isPost.value = "<%=leaf.isPost()?1:0%>";
            </script>
			<%}%>			</td>
              </tr>
              <tr>
                <td align="center"><input name="Submit" type="submit" value="  <%=SkinUtil.LoadString(request, "res.label.cms.dir","subbmit")%>  ">
                  &nbsp;&nbsp;&nbsp;
                  <input type="button" value="<%=SkinUtil.LoadString(request, "res.label.cms.dir","enable_set_type")%>" onClick="enableSelType()"></td>
              </tr>
            </form>
          </table></td>
        </tr>
      </table>
      </TD>
    </TR>
    <!-- Table Body End -->
    <!-- Table Foot -->
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
    </TR>
    <!-- Table Foot -->
  </TBODY>
</TABLE>
</body>
</html>
