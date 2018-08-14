<%@ page contentType="text/html;charset=utf-8"%><%@ page import="cn.js.fan.module.cms.*"%><%@ page import="cn.js.fan.module.cms.template.*"%><%@ page import="cn.js.fan.util.*"%><%
int pageNo = ParamUtil.getInt(request, "pageNo", 1);
Config cfg = new Config();
int pageSize = cfg.getIntProperty("cms.listPageSize");
String dirCode = ParamUtil.get(request, "dirCode");

Document doc = new Document();
String sql = SQLBuilder.getDirDocListSql(dirCode);
Leaf lf = new Leaf();
lf = lf.getLeaf(dirCode);
int total = doc.getDocCount(sql);

ListDocPagniator paginator = new ListDocPagniator(request, total, pageSize);
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