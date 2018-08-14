<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="cn.js.fan.db.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="cn.js.fan.module.cms.*" %>
<%@ page import="com.cloudwebsoft.framework.base.*" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>主题信息管理</title>
<LINK href="default.css" type=text/css rel=stylesheet>
<script>
function form1_onsubmit() {
	form1.root_code.value = window.parent.dirmainFrame.getRootCode();
}
</script>
</head>
<body>
<%
String parent_code = ParamUtil.get(request, "parent_code");
if (parent_code.equals(""))
	parent_code = "root";
String parent_name = ParamUtil.get(request, "parent_name");
String code = ParamUtil.get(request, "code");
String name = ParamUtil.get(request, "name");
String description = ParamUtil.get(request, "description");
String op = ParamUtil.get(request, "op");
int pageTemplateId = ParamUtil.getInt(request, "pageTemplateId", SubjectDb.NOTEMPLATE);
boolean isHome = false;
int type = 0;
if (op.equals(""))
	op = "AddChild";
SubjectDb leaf = null;
int templateId = ParamUtil.getInt(request, "pageTemplateId", SubjectDb.NOTEMPLATE);
if (op.equals("modify")) {
	SubjectMgr dir = new SubjectMgr();
	leaf = dir.getSubjectDb(code);
	name = leaf.getName();
	description = leaf.getDescription();
	type = leaf.getType();
	pageTemplateId = leaf.getPageTemplateId();
	templateId = leaf.getTemplateId();
	isHome = leaf.getIsHome();
	
}
%>
<TABLE 
style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" 
cellSpacing=0 cellPadding=3 width="95%" align=center>
  <!-- Table Head Start-->
  <TBODY>
    <TR>
      <TD class=thead style="PADDING-LEFT: 10px" noWrap width="70%">专题增加或修改</TD>
    </TR>
    <TR class=row style="BACKGROUND-COLOR: #fafafa">
      <TD align="center" style="PADDING-LEFT: 10px"><table class="frame_gray" width="61%" border="0" cellpadding="0" cellspacing="1">
        <tr>
          <td align="center"><table width="92%">
            <form name="form1" method="post" action="subject_top.jsp?op=<%=op%>" target="dirmainFrame" onClick="return form1_onsubmit()">
              <tr>
                <td width="104" rowspan="6" align="left" valign="top"><br>
                  当前结点：<br>
                    <font color=blue><%=parent_name.equals("")?"全部门":parent_name%></font>					</td>
                <td align="left"> 编码
                    <input name="code" value="<%=code%>" <%=op.equals("modify")?"readonly":""%>>                </td>
              </tr>
              <tr>
                <td align="left">名称
                    <input name="name" value="<%=name%>"></td>
              </tr>
              <tr>
                <td align="left">描述
                    <input name="description" value="<%=description%>" type="text">
                    <input type=hidden name=parent_code value="<%=parent_code%>">
                    <input type=hidden name=type value=1>
                    <input type=hidden name=root_code value=""></td>
              </tr>
              <tr>
                <td align="left">页面模板
					<%
						int type_code = TemplateDb.TYPE_CODE_SUBJECT_LIST;
						String sql = "select id from cms_template where type_code=" + type_code;
				  %>
                              <select name="templateId">
                                <option value="-1" selected>默认列表页</option>
                                <%
								TemplateDb td = new TemplateDb();
								Iterator tir = td.list(sql).iterator();
								while (tir.hasNext()) {
									td = (TemplateDb)tir.next();
								%>
                                <option value="<%=td.getInt("id")%>"><%=td.getString("name")%></option>
                                <%}%>
                              </select>
							  <%if (op.equals("modify")) {%>
							  <script>
							  form1.templateId.value = "<%=leaf.getTemplateId()%>";
							  </script>
							  <%}%>				
				<select name="pageTemplateId">
				<option value="<%=SubjectDb.NOTEMPLATE%>">无</option>
<%
type_code = TemplateDb.TYPE_CODE_DOC;
sql = "select id from cms_template where type_code=" + type_code;
tir = td.list(sql).iterator();
while (tir.hasNext()) {
 	td = (TemplateDb)tir.next();
%>
<option value="<%=td.getInt("id")%>"><%=td.getString("name")%></option>
<%}%>
</select>
<script>
form1.pageTemplateId.value = "<%=pageTemplateId%>";
</script></td>
              </tr>
              <tr>
                <td align="left"><%if (op.equals("modify")) {%>
                  <script>
				    var bcode = "<%=leaf.getCode()%>";
			        </script>
<%if (code.equals(leaf.ROOTCODE)) {%>
<input type=hidden name="parentCode" value="<%=leaf.getParentCode()%>">
<%}else{%>
父结点
<select name="parentCode">
  <%
									SubjectDb rootlf = leaf.getSubjectDb(SubjectDb.ROOTCODE);
									SubjectView dv = new SubjectView(rootlf);
									dv.ShowDirAsOptions(out, rootlf, rootlf.getLayer());
					%>
</select>
<script>
					form1.parentCode.value = "<%=leaf.getParentCode()%>";
					</script>
<%}%>
<%}%>
				<%if (op.equals("modify")) {%>
				<input type="checkbox" name="isHome" value="true" <%=isHome?"checked":""%> >
				<%}else{%>
				<input type="checkbox" name="isHome" value="true" checked>
				<%}%>
				<lt:Label res="res.label.cms.dir" key="is_home"/>
</td>
              </tr>
              <tr>
                <td align="center"><input name="Submit" type="submit" class="singleboarder" value="提交">
&nbsp;&nbsp;&nbsp;
<input name="Submit" type="reset" class="singleboarder" value="重置"></td>
              </tr>
            </form>
          </table>
            </td>
        </tr>
      </table>
      </TD>
    </TR>
    <TR>
      <TD class=tfoot align=right><DIV align=right> </DIV></TD>
    </TR>
  </TBODY>
</TABLE>
</body>
</html>
