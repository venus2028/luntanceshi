<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.db.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="com.redmoon.forum.plugin.info.*" %>
<%@ page import="cn.js.fan.module.pvg.*" %>
<%@ page import="cn.js.fan.web.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<LINK href="../../common.css" type=text/css rel=stylesheet>
<LINK href="default.css" type=text/css rel=stylesheet>
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
	if (confirm("<lt:Label res="res.label.blog.admin.dir" key="confirm"/>")) {
		form1.seltype.disabled = false;
	}
}
</script>
</head>
<body>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
%>
<%
String parent_code = ParamUtil.get(request, "parent_code");
if (parent_code.equals(""))
	parent_code = "root";
String parent_name = ParamUtil.get(request, "parent_name");
String code = ParamUtil.get(request, "code");
String name = ParamUtil.get(request, "name");
String description = ParamUtil.get(request, "description");
String op = ParamUtil.get(request, "op");
boolean isHome = false;
int type = 0;
if (op.equals(""))
	op = "AddChild";

Leaf leaf = null;
if (op.equals("modify")) {
	Directory dir = new Directory();
	leaf = dir.getLeaf(code);
	name = leaf.getName();
	description = leaf.getDescription();
	type = leaf.getType();
	isHome = leaf.getIsHome();
}
%>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%"><lt:Label res="res.label.blog.admin.dir" key="list_add_and_modify"/></TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD align="center" style="PADDING-LEFT: 10px"><table class="frame_gray" width="415" border="0" cellpadding="0" cellspacing="1">
        <tr>
          <td width="411" align="center"><table width="98%">
            <form name="form1" method="post" action="dir_top.jsp?op=<%=op%>" target="dirmainFrame" onClick="return form1_onsubmit()">
              <tr>
                <td width="78" rowspan="7" align="left" valign="top"><br>
                  <lt:Label res="res.label.blog.admin.dir" key="current_node"/><br>
                    <font color=blue><%=parent_name.equals("")?SkinUtil.LoadString(request,"res.label.blog.admin.dir", "root_node"):parent_name%></font>					</td>
                <td width="312" align="left"><lt:Label res="res.label.blog.admin.dir" key="code"/>
                    <input name="code" value="<%=code%>" <%=op.equals("modify")?"readonly":""%>>                </td>
              </tr>
              <tr>
                <td align="left"><lt:Label res="res.label.blog.admin.dir" key="name"/>
                    <input name="name" value="<%=name%>"></td>
              </tr>
              <tr>
                <td align="left"><lt:Label res="res.label.blog.admin.dir" key="description"/>
                    <input name="description" value="<%=description%>">
                    <input type=hidden name=parent_code value="<%=parent_code%>">                    </td>
              </tr>
              <tr>
                <td align="left">
				<%
				String disabled = "";
				if (op.equals("modify") && leaf.getType()>=1)
					disabled = "true";
				%>
				<lt:Label res="res.label.blog.admin.dir" key="type"/>
                  <select name="seltype">
                    <option value="<%=Leaf.TYPE_NONE%>"><lt:Label res="res.label.blog.admin.dir" key="class"/></option>
                    <option value="<%=Leaf.TYPE_LIST%>" <%=op.equals("AddChild")?"selected":""%>><lt:Label res="res.label.blog.admin.dir" key="list"/></option>
                  </select>
				  <script>
				  <%if (op.equals("modify")) {%>
					  form1.seltype.value = "<%=type%>"
				  <%}%>
				  form1.seltype.disabled = "<%=disabled%>"
				  </script>
				  <input type=hidden name=root_code value="">
				  <input type=hidden name="type" value="<%=type%>">
                  <input type=hidden name="templateId" class="singleboarder" value="<%=op.equals("modify")?""+leaf.getTemplateId():"-1"%>" size=3 readonly>
&nbsp; </td>
              </tr>
              <tr>
                <td align="left"><span class="unnamed2">
                  <%if (op.equals("modify")) {%>
                  <script>
			  var bcode = "<%=leaf.getCode()%>";
			      </script>
&nbsp;<lt:Label res="res.label.blog.admin.dir" key="parent_node"/>	
<select name="parentCode">
<%
				Leaf rootlf = leaf.getLeaf("root");
				DirectoryView dv = new DirectoryView(rootlf);
				dv.ShowDirectoryAsOptionsWithCode(out, rootlf, rootlf.getLayer());
%>
</select>
<script>
form1.parentCode.value = "<%=leaf.getParentCode()%>";
</script>
<%}%>
                <input type="hidden" name="pluginCode" value="default">
                </span></td>
              </tr>
              <tr>
                <td align="left">&nbsp;</td>
              </tr>
              <tr>
                <td align="center"><input name="Submit" type="submit" class="singleboarder" value="<lt:Label res="res.label.blog.admin.dir" key="submit"/>">
                  &nbsp;&nbsp;&nbsp;
                  <input name="Submit" type="reset" class="singleboarder" value="<lt:Label res="res.label.blog.admin.dir" key="reset"/>">
                  &nbsp;&nbsp;&nbsp;
                  <input type="button" class="singleboarder" value="<lt:Label res="res.label.blog.admin.dir" key="coerce_type_modify"/>" onClick="enableSelType()"></td>
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
