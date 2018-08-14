<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.cms.ui.*"%>
<%@ page import="com.cloudwebsoft.framework.base.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<%
String siteCode = ParamUtil.get(request, "siteCode");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="../default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>滚动图片管理</title>
<style>
.btn {
border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;
}
</style>
<style type="text/css">
/*Tooltips*/
.tooltips{
position:relative; /*这个是关键*/
z-index:2;
}
.tooltips:hover{
z-index:3;
background:none; /*没有这个在IE中不可用*/
}
.tooltips span{
display: none;
}
.tooltips:hover span{ /*span 标签仅在 :hover 状态时显示*/
display:block;
position:absolute;
top:21px;
left:9px;
width:5px;
border:0px solid black;
background-color: #FFFFFF;
padding: 3px;
color:black;
}
</style>
<script src="../../inc/common.js"></script>
<script language="JavaScript">
<!--
function openWin(url,width,height) {
  var newwin=window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,top=50,left=120,width="+width+",height="+height);
}
var urlObj;
function SelectImage(urlObject) {
	urlObj = urlObject;
	openWin("../img_frame.jsp?action=selectImage&dir=<%=StrUtil.UrlEncode(siteCode)%>", 800, 600);
}
function setImgUrl(visualPath) {
	urlObj.value = visualPath;
}
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserLogin(request)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

SiteDb sd = new SiteDb();
sd = sd.getSiteDb(siteCode);
if (!SitePrivilege.canManage(request, sd)) {
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

String kind = ParamUtil.get(request, "kind");
if (kind.equals(""))
	kind = SiteScrollImgDb.KIND_SCROLL;

String op = ParamUtil.get(request, "op");
if (op.equals("del")) {
	int id = ParamUtil.getInt(request, "id");
	SiteScrollImgDb ld = new SiteScrollImgDb();
    ld = (SiteScrollImgDb)ld.getQObjectDb(new Long(id));
    boolean re = ld.del();
	if (re)
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_success"), "site_scroll_img_list.jsp?siteCode=" + siteCode + "&kind=" + kind));
	else
		out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request,"res.common", "info_op_fail"), "site_scroll_img_list.jsp?siteCode=" + siteCode + "&kind=" + kind));
	return;
}

if (op.equals("add")) {
	QObjectMgr qom = new QObjectMgr();
	SiteScrollImgDb sad = new SiteScrollImgDb();
	try {
		if (qom.create(request, sad, "site_scroll_img_create")) {
			out.print(StrUtil.Alert_Redirect(SkinUtil.LoadString(request, "info_op_success"), "site_scroll_img_list.jsp?siteCode=" + siteCode + "&kind=" + kind));
		}
		else {
			out.print(StrUtil.Alert_Back(SkinUtil.LoadString(request, "info_op_fail")));
		}
	}
	catch (ErrMsgException e) {
		out.print(StrUtil.Alert_Back(e.getMessage()));
	}
	return;
}
%>
<DIV id="tabBar">
  <div class="tabs">
    <ul>
      <li id="menu1"><a href="<%=request.getContextPath()%>/cms/site/site_scroll_img_list.jsp?siteCode=<%=siteCode%>&kind=<%=SiteScrollImgDb.KIND_SCROLL%>">滚动</a></li>
      <li id="menu2"><a href="<%=request.getContextPath()%>/cms/site/site_scroll_img_list.jsp?siteCode=<%=siteCode%>&kind=<%=SiteScrollImgDb.KIND_SWITCH%>">变换</a></li>
    </ul>
  </div>
</DIV>
<script>
<%if (kind.equals(SiteScrollImgDb.KIND_SCROLL)) {%>
$("menu1").className="active"; 
<%}else{%>
$("menu2").className="active"; 
<%}%>
</script>
<br>
<%
int pagesize = 20;

SiteScrollImgDb pd = new SiteScrollImgDb();

String sql = "select id from " + pd.getTable().getName() + " where site_code=" + StrUtil.sqlstr(siteCode) + " and kind=" + StrUtil.sqlstr(kind) + " order by orders desc";
%>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">管理</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <br>
<%
int curpage = ParamUtil.getInt(request, "CPages", 1);
ListResult lr = pd.listResult(sql, curpage, pagesize);
int total = lr.getTotal();
	
Paginator paginator = new Paginator(request, total, pagesize);
// 设置当前页数和总页数
int totalpages = paginator.getTotalPages();
if (totalpages==0) {
	curpage = 1;
	totalpages = 1;
}
%>
      <table width="98%" height="24" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td align="right"><%=paginator.getPageStatics(request)%> </td>
        </tr>
      </table>
      <table width="98%"  border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC">
        <tr align="center" bgcolor="#F1EDF3">
          <td width="9%" class="thead">ID</td>
          <td width="49%" height="24" class="thead"><strong>标题</strong></td>
          <td width="14%" class="thead"><strong>序号</strong></td>
          <td width="13%" class="thead"><strong>
            <lt:Label res="res.label.blog.admin.blog" key="operate"/>
          </strong></td>
        </tr>
        <%
Iterator ir = lr.getResult().iterator();
int i = 0;
Directory dir = new Directory();
while (ir.hasNext()) {
	i ++;
	pd = (SiteScrollImgDb) ir.next();
	Leaf lf = dir.getLeaf(pd.getString("site_code"));
	String siteName = "";
	if (lf!=null)
		siteName = lf.getName();
	else
		siteName = "已删除";
%>
        <form id="frm<%=i%>" name="frm<%=i%>" action="?op=modify" method="post">
          <tr align="center">
            <td align="left" bgcolor="#FFFFFF"><%=pd.getLong("id")%></td>
            <td align="left" bgcolor="#FFFFFF">
			<a class="tooltips" href="<%=request.getContextPath()%>/<%=pd.getString("url")%>" target="_blank">
			<%=pd.getString("title")%>
			<span><img src="<%=request.getContextPath()%>/<%=pd.getString("url")%>"></span>
			</a>			</td>
            <td align="left" bgcolor="#FFFFFF"><%=pd.getInt("orders")%></td>
            <td height="22" bgcolor="#FFFFFF"><a href="site_scroll_img_edit.jsp?siteCode=<%=siteCode%>&id=<%=pd.getLong("id")%>">编辑</a>&nbsp;&nbsp;
			<a href="#" onClick="if (confirm('您确定要删除吗？')) window.location.href='site_scroll_img_list.jsp?op=del&id=<%=pd.getLong("id")%>&siteCode=<%=StrUtil.UrlEncode(siteCode)%>&kind=<%=kind%>&CPages=<%=curpage%>'"><lt:Label res="res.label.blog.admin.blog" key="del"/>
            </a> </td>
          </tr>
        </form>
        <%}%>
      </table>
      <table width="98%" border="0" cellspacing="1" cellpadding="3" align="center" class="9black">
        <tr>
          <td height="23"><div align="right">
              <%
	String querystr = "siteCode=" + StrUtil.UrlEncode(siteCode);
    out.print(paginator.getPageBlock(request, "site_scroll_img_list.jsp?"+querystr));
%>
          </div></td>
        </tr>
      </table>
      <br>
      <br>
      <table width="73%" align="center" class="frame_gray">
        <form id=formAdd name=formAdd action="?op=add&siteCode=<%=siteCode%>" method=post>
          <tr>
            <td height="22" colspan="4" class="thead"><strong><a name="focus">添加图片
                  <input name="site_code" value="<%=siteCode%>" type=hidden>
                  <input name="kind" value="<%=kind%>" type=hidden>
            </a></strong></td>
          </tr>
          <tr>
            <td width="9%" height="22">序号：</td>
            <td width="31%"><input name="orders" value="">
            </td>
            <td width="11%">地址：</td>
            <td width="49%"><input name="url">
            <input name="button" type="button" onclick="SelectImage(formAdd.url)" value="选择" /></td>
          </tr>
          <tr>
            <td height="22">链接：</td>
            <td><input name="link"></td>
            <td>文字：</td>
            <td><input name="title"></td>
          </tr>
          <tr>
            <td height="22" colspan="4" align="center"><input name="submit22" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
          </tr>
        </form>
      </table>
      <br>
    <br>
    <br></td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
</body>                                        
</html>                            
  