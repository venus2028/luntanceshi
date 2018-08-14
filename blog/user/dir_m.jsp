<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<link href="../../cms/default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><lt:Label res="res.label.blog.user.dir" key="title"/></title>
<script language="JavaScript">
<!--
function form1_onsubmit() {
}
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #FF0000}
.STYLE2 {color: #FFFFFF}
-->
</style>
<body topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<jsp:useBean id="dir" scope="page" class="com.redmoon.blog.UserDirDb"/>
<%
long blogId = ParamUtil.getLong(request, "blogId", UserConfigDb.NO_BLOG);
// 检查用户权限
if (!com.redmoon.blog.Privilege.canUserDo(request, blogId, "priv_dir")) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

UserConfigDb ucd = new UserConfigDb();
ucd = ucd.getUserConfigDb(blogId);
if (!ucd.isLoaded()) {
	out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request,"res.label.blog.list","activate_blog_fail")));
	return;	
}

String user = privilege.getUser(request);

// 检查用户权限
// if (!BlogGroupUserDb.canUserDo(request, blogId, "enter")) {
//	out.print(SkinUtil.makeErrMsg(request, SkinUtil.LoadString(request, SkinUtil.PVG_INVALID)));
//	return;
// }

String op = ParamUtil.get(request, "op");
if (op.equals("add")) {
	String code = "";
	String dirName = "";
	boolean re = false;
	try {
		code = ParamUtil.get(request, "code");
		dirName = ParamUtil.get(request, "dirName");
		boolean isValid = true;
		if (code.equals("") || dirName.equals("")) {
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.label.blog.user.dir", "code_name_alert")));
			isValid = false;
		}
		if (isValid) {
			UserDirDb udd = new UserDirDb();
			udd.setCode(code);
			udd.setDirName(dirName);
			udd.setBlogId(ucd.getId());
			re = udd.create();
		}
	}
	catch (ResKeyException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "dir_m.jsp?blogId=" + blogId));
	}
}
else if (op.equals("modify")) {
	String code = "";
	String dirName = "";
	boolean re = false;
	try {
		code = ParamUtil.get(request, "code");
		dirName = ParamUtil.get(request, "dirName");
		boolean isValid = true;
		if (code.equals("") || dirName.equals("")) {
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.label.blog.user.dir", "code_name_alert")));
		}
		if (isValid) {
			UserDirDb udd = new UserDirDb();
			udd = udd.getUserDirDb(blogId, code);
			udd.setCode(code);
			udd.setDirName(dirName);
			udd.setBlogId(ucd.getId());
			re = udd.save();
		}
	}
	catch (ResKeyException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "info_op_success")));
	}
}
else if (op.equals("del")) {
	String code = "";
	boolean re = false;
	try {
		code = ParamUtil.get(request, "code");
		boolean isValid = true;
		if (code.equals("")) {
			out.print(StrUtil.Alert(SkinUtil.LoadString(request,"res.label.blog.user.dir", "code_name_alert")));
		}
		if (isValid) {
			UserDirDb udd = new UserDirDb();
			udd = udd.getUserDirDb(blogId, code);
			int count = udd.getMsgCountOfDir(blogId, code);
			if (count>0) {
				String str = SkinUtil.LoadString(request,"res.label.blog.user.dir", "del_alert");
				str = StrUtil.format(str, new Object[] {Global.AppName});
				out.print(StrUtil.Alert(str));
			}
			else {
				udd.setCode(code);
				udd.setBlogId(blogId);
				re = udd.del();
			}
		}
	}
	catch (ResKeyException e) {
		out.print(StrUtil.Alert(e.getMessage()));
	}
	if (re) {
		out.print(StrUtil.Alert(SkinUtil.LoadString(request, "info_op_success")));
	}
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head"><lt:Label res="res.label.blog.user.frame" key="manage"/></td>
  </tr>
</table>
<br>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
                               
<table width="86%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#666666" class="tableframe_gray">
   <tr align="center">
     <td width="22%" height="26" class="thead"><lt:Label res="res.label.blog.user.dir" key="list_name"/></td>
     <td width="30%" class="thead"><lt:Label res="res.label.blog.user.dir" key="operate"/></td>
   </tr>
   <tr align="center" bgcolor="#FFFFFF">
     <td width="22%" height="22"><lt:Label res="res.label.blog.user.dir" key="my_article"/></td>
     <td width="30%"><a href="listtopic.jsp?blogUserDir=<%=UserDirDb.DEFAULT%>&blogId=<%=blogId%>">
       <lt:Label res="res.label.blog.user.dir" key="manage"/>
       </a>&nbsp;<a href="../../forum/addtopic_new.jsp?addFlag=blog&boardcode=<%=com.redmoon.forum.Leaf.CODE_BLOG%>&blogId=<%=blogId%>&blogUserDir=<%=UserDirDb.DEFAULT%>">
         <lt:Label res="res.label.blog.user.dir" key="issue_article"/>
       </a></td>
   </tr>
   <%
UserDirDb sb1 = new UserDirDb();
Vector v = sb1.list(blogId);
Iterator ir = v.iterator();
int i = 2;
while (ir.hasNext()) {
	UserDirDb as = (UserDirDb)ir.next();
	i++;
%>
   <form id="form<%=i%>" name="form<%=i%>" action="?op=modify" method="post">
     <tr align="center" bgcolor="#FFFFFF">
       <td height="22"><input type=hidden name=code value="<%=as.getCode()%>">
           <input name=dirName value="<%=as.getDirName()%>" size=22></td>
       <td height="22"><input type=hidden name="blogId" value="<%=blogId%>">
           <input type="submit" name="Submit" value="<lt:Label key="op_modify"/>">
           <a href="listtopic.jsp?blogId=<%=blogId%>&blogUserDir=<%=StrUtil.UrlEncode(as.getCode())%>"><lt:Label res="res.label.blog.user.dir" key="manage"/></a>
		   &nbsp;&nbsp;<a href="#" onClick="if (confirm('<lt:Label key="confirm_del"/>')) window.location.href='dir_m.jsp?op=del&code=<%=StrUtil.UrlEncode(as.getCode())%>&blogId=<%=blogId%>'">
               <lt:Label key="op_del"/>
               </a>&nbsp;&nbsp;<a href="../../forum/addtopic_new.jsp?addFlag=blog&boardcode=<%=com.redmoon.forum.Leaf.CODE_BLOG%>&blogId=<%=blogId%>&blogUserDir=<%=StrUtil.UrlEncode(as.getCode())%>">
                 <lt:Label res="res.label.blog.user.dir" key="issue_article"/>
               </a></td>
     </tr>
   </form>
   <%}%>
 </table>
 <br>
 <table width="86%"  border="0" align="center" cellpadding="3" cellspacing="0" class="frame_gray">
   <form action="?op=add&blogId=<%=blogId%>" method=post id=form1 name=form1 onSubmit="return form1_onsubmit()">
     <tr>
       <td width="192" align="right">&nbsp;</td>
       <td width="636" align="left">&nbsp;
           <input name=code type="hidden" size=4 value="<%=cn.js.fan.util.RandomSecquenceCreator.getId(20)%>">
         &nbsp;
         <lt:Label res="res.label.blog.user.dir" key="list_name"/>
         <input name=dirName size=8>
         <input type="submit" name="Submit" value="<lt:Label key="op_add"/>">
         <input type=hidden name="blogId" value="<%=blogId%>"></td>
     </tr>
     <tr>
       <td height="22" colspan="2" align="center">(
           <lt:Label res="res.label.blog.user.dir" key="explain"/>
         )</td>
     </tr>
   </form>
 </table>
</body>                                        
</html>                            
  