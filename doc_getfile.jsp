<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %><%@page import="cn.js.fan.util.*"%><%@page import="cn.js.fan.web.*"%><%@page import="cn.js.fan.module.cms.*"%><%@page import="java.util.*"%><%@page import="com.redmoon.forum.plugin.*"%><%@page import="com.redmoon.forum.plugin.base.*"%><%@page import="java.io.*"%><%@page import="java.net.*"%><%
  int id = ParamUtil.getInt(request, "id");
  int attId = ParamUtil.getInt(request, "attachId");

  Document mmd = new Document();
  mmd = mmd.getDocument(id);
  
  int pageNum = 1;
  String pn = ParamUtil.get(request, "pageNum");
  if (StrUtil.isNumeric(pn)) {
  	pageNum = Integer.parseInt(pn);
  }

cn.js.fan.module.cms.ext.Privilege pvg = new cn.js.fan.module.cms.ext.Privilege();
if (!pvg.canUserDo(request, mmd.getDirCode(), "download_attach")) {
	response.sendRedirect("info.jsp?info=" + StrUtil.UrlEncode(SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}
// 检查该附件下载是否需付费
com.redmoon.forum.Privilege privilege = new com.redmoon.forum.Privilege();
String groupCode = "";
if (privilege.isUserLogin(request)) {
   com.redmoon.forum.person.UserDb ud = new com.redmoon.forum.person.UserDb();
   ud = ud.getUser(privilege.getUser(request));
   groupCode = ud.getGroupCode();
   // 取得用户所在组
   if (groupCode.equals(""))
   		groupCode = com.redmoon.forum.person.UserGroupDb.EVERYONE;
}
else {
	groupCode = com.redmoon.forum.person.UserGroupDb.GUEST;
}

// 检查用户在此版块下载是否需付费
cn.js.fan.module.cms.ext.UserGroupPrivDb ugpd = new cn.js.fan.module.cms.ext.UserGroupPrivDb();
ugpd = ugpd.getUserGroupPrivDb(groupCode, mmd.getDirCode());
String moneyCode = StrUtil.getNullStr(ugpd.getString("money_code"));
if (!moneyCode.equals("")) {
	int sum = ugpd.getInt("money_sum");
	if (sum>0) {
		// 检查用户的金额是否足够
		ScoreMgr sm = new ScoreMgr();
		ScoreUnit su = sm.getScoreUnit(moneyCode);
		IPluginScore isc = su.getScore();
		if (isc != null) {
		   try {
			   isc.pay(privilege.getUser(request), isc.SELLER_SYSTEM, sum);
		   } catch (ResKeyException e) {
				out.print(SkinUtil.makeErrMsg(request, e.getMessage(request)));
				return;
		   }
		}
	}
}
  
  Attachment att = mmd.getAttachment(pageNum, attId);
  
  String s = Global.getRealPath() + att.getVisualPath() + "/" + att.getDiskName();
  java.io.File f = new java.io.File(s);
  java.io.FileInputStream fis = new java.io.FileInputStream(f);

  response.reset();
  //Accept-Ranges: bytes
  response.setHeader("Accept-Ranges", "bytes");

  long p = 0;
  long l = 0;
  l = f.length();

  if (request.getHeader("Range") != null){
	  //HTTP/1.1 206 Partial Content
	  response.setStatus(javax.servlet.http.HttpServletResponse.SC_PARTIAL_CONTENT);//206
	
	  p = Long.parseLong(request.getHeader("Range").replaceAll("bytes=","").replaceAll("-",""));
  }

  response.setHeader("Content-Length", new Long(l - p).toString()); 

  if (p != 0)
  {
   response.setHeader("Content-Range","bytes " + new Long(p).toString() + "-" + new Long(l -1).toString() + "/" + new Long(l).toString());
  }
  //Content-Type: application/octet-stream
  response.setContentType("application/octet-stream");
  response.setHeader("Content-Disposition", "attachment;filename=\"" + StrUtil.GBToUnicode(att.getName()) + "\"");

  //raf.seek(p);
  fis.skip(p);

  byte[] b = new byte[1024]; 
  int i;
  while ( (i = fis.read(b)) != -1 )
  {
   response.getOutputStream().write(b,0,i);
  }
  fis.close();
  
  att.setDownloadCount(att.getDownloadCount() + 1);
  att.save();  
%>