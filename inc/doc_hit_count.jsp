<%@ page contentType="text/html;charset=utf-8"%><%@ page import="cn.js.fan.module.cms.util.*"%><%@ page import="com.redmoon.forum.*"%><%@ page import="cn.js.fan.module.cms.*"%><%@ page import="cn.js.fan.util.*"%><%
int id = ParamUtil.getInt(request, "id");
Document doc = new Document();
doc = doc.getDocument(id);
doc.increaseHit();

Privilege pvg = new Privilege();
String userName = pvg.getUser(request);
VisitLogMgr.logDirVisit(request, doc.getDirCode(), userName);
VisitLogMgr.logDocVisit(request, doc, userName);

%>document.write("<%=doc.getHit()%>");