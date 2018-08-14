<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%
int docId = ParamUtil.getInt(request, "docId");
String pNum = ParamUtil.get(request, "pageNum");
int pageNum = 1;
if (StrUtil.isNumeric(pNum)) {
	pageNum = Integer.parseInt(pNum);
}
int attachId = ParamUtil.getInt(request, "attachId");
Document doc = new Document();
doc = doc.getDocument(docId);

Attachment am = doc.getAttachment(pageNum, attachId);
if (am==null)
	return;

UserDb user = new UserDb();
String groupCode = UserGroupDb.GUEST;
com.redmoon.forum.Privilege privilege = new com.redmoon.forum.Privilege();
if (privilege.isUserLogin(request)) {
  	user = user.getUser(privilege.getUser(request));
  	UserGroupDb ugd = user.getUserGroupDb();
  	groupCode = ugd.getCode();
}
cn.js.fan.module.cms.ext.UserGroupPrivDb ugp = new cn.js.fan.module.cms.ext.UserGroupPrivDb();
ugp = ugp.getUserGroupPrivDb(groupCode, doc.getDirCode());
String moneyName = "";
int moneySum = 0;

if (ugp!=null) {
  	String moneyCode = StrUtil.getNullString(ugp.getString("money_code"));
	ScoreMgr sm = new ScoreMgr();
	ScoreUnit su = sm.getScoreUnit(moneyCode);
	if (su!=null) {
		moneyName = su.getName(request);
  		moneySum = ugp.getInt("money_sum");
	}
}
%>	
document.write("<%=am.getDownloadCount()%>&nbsp;&nbsp需要点数：<%=moneyName%>&nbsp;&nbsp<%=moneySum%>");