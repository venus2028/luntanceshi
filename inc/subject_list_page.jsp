<%@ page contentType="text/html;charset=utf-8"%><%@ page import="cn.js.fan.module.cms.*"%><%@ page import="cn.js.fan.module.cms.template.*"%><%@ page import="cn.js.fan.util.*"%><%
int pageNo = ParamUtil.getInt(request, "pageNo", 1);
Config cfg = new Config();
int pageSize = cfg.getIntProperty("cms.listPageSize");
String dirCode = ParamUtil.get(request, "dirCode");

SubjectListDb doc = new SubjectListDb();
String sql = SQLBuilder.getSubjectDocListSql(dirCode);
SubjectDb lf = new SubjectDb();
lf = lf.getSubjectDb(dirCode);
int total = doc.getDocCount(sql);

ListSubjectPagniator paginator = new ListSubjectPagniator(request, total, pageSize);
int pageNum = paginator.pageNo2Num(pageNo);

String op = ParamUtil.get(request, "op");
if (op.equals("statics")) {
	paginator.curPage = pageNum;
%>
document.write("<%=paginator.getPageStatics(request)%>");
<%}
else if (op.equals("firstPage")){%>
document.write("<%=request.getContextPath() + "/" + lf.getListHtmlNameByPageNo(paginator.pageNum2No(1))%>");
<%}
else{%>
document.write("<%=paginator.getHtmlCurPageBlock(lf, pageNum)%>");
<%}%>