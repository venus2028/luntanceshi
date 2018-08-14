<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.cloudwebsoft.framework.template.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %><%
int id = ParamUtil.getInt(request, "id", -1);
if (id==-1) {
	String dirCode = ParamUtil.get(request, "dirCode");
	Leaf lf = new Leaf();
	if (!dirCode.equals("")) {
		lf = lf.getLeaf(dirCode);
		if (lf!=null) {
			if (lf.getType()==Leaf.TYPE_DOCUMENT) {
				id = lf.getDocID();
			}
		}
	}
}
if (id==-1) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "err_id")));
	return;
}
Document doc = new Document();
doc = doc.getDocument(id);

cn.js.fan.module.cms.ext.Privilege privilege = new cn.js.fan.module.cms.ext.Privilege();
if (!privilege.canUserDo(request, doc.getDirCode(), "view_doc")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

request.setAttribute("id", "" + doc.getId());

TemplateDb td = doc.getTemplateDb();
if (td==null) {
	out.print(SkinUtil.makeErrMsg(request, "模板不存在！"));
	return;
}

String filePath = td.getString("path");

// System.out.println(getClass() + " " + doc.getTitle() + " filePath=" + filePath);

filePath = cn.js.fan.web.Global.realPath + filePath;
TemplateLoader tl = new TemplateLoader(request, filePath);
out.print(tl.toString());
%>