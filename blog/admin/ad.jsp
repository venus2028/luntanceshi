<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="org.jdom.Element"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>首页广告管理</title>
<style>
.btn {
border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;
}
</style>
<script language="JavaScript">
<!--
function openWin(url,width,height)
{
	var newwin = window.open(url,"_blank","scrollbars=yes,resizable=yes,toolbar=no,location=no,directories=no,status=no,menubar=no,top=50,left=120,width="+width+",height="+height);
}

function findObj(theObj, theDoc)
{
  var p, i, foundObj;
  
  if(!theDoc) theDoc = document;
  if( (p = theObj.indexOf("?")) > 0 && parent.frames.length)
  {
    theDoc = parent.frames[theObj.substring(p+1)].document;
    theObj = theObj.substring(0,p);
  }
  if(!(foundObj = theDoc[theObj]) && theDoc.all) foundObj = theDoc.all[theObj];
  for (i=0; !foundObj && i < theDoc.forms.length; i++) 
    foundObj = theDoc.forms[i][theObj];
  for(i=0; !foundObj && theDoc.layers && i < theDoc.layers.length; i++) 
    foundObj = findObj(theObj,theDoc.layers[i].document);
  if(!foundObj && document.getElementById) foundObj = document.getElementById(theObj);
  
  return foundObj;
}

function form_onsubmit(k) {
	var oEditor = FCKeditorAPI.GetInstance('FCKeditor' + k) ;
	var htmlcode = oEditor.GetXHTML( true );
	var form = findObj("form" + k);
	form.content.value = htmlcode;
}
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="cn.js.fan.module.pvg.Privilege"/>
<%
if (!privilege.isUserPrivValid(request, "forum.plugin"))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

Home home = Home.getInstance();

String op = ParamUtil.get(request, "op");

if (op.equals("setAd")) {
	String id = ParamUtil.get(request, "id");
	String content = ParamUtil.get(request, "content");
	home.setProperty("ads", "id", id, content);	
	out.print(StrUtil.Alert_Redirect("操作成功！", "ad.jsp"));
	return;
}
%>
<table width='100%' cellpadding='0' cellspacing='0' >
  <tr>
    <td class="head">管理首页</td>
  </tr>
</table>
<br>
<table width="98%" height="227" border='0' align="center" cellpadding='0' cellspacing='0' class="frame_gray">
  <tr> 
    <td height=20 align="left" class="thead">管理</td>
  </tr>
  <tr> 
    <td valign="top"><br>
      <table width="490" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td width="77" align="center"><a href="nav_m.jsp">导航条</a> </td>
          <td width="77" align="center"><a href="home.jsp#focus">博客聚焦</a></td>
          <td width="101" align="center"><a href="home.jsp#flash">Flash图片设置</a></td>
          <td width="81" align="center"><a href="ad.jsp">广告</a></td>
          <td width="81" align="center"><a href="home_img.jsp">滚动图片</a></td>
          <td width="81" align="center"><a href="../desktop_edit_template.jsp" target="_blank">编辑模板</a></td>
        </tr>
      </table>
      <br>
      <br>
<%
Element root = home.getRoot();
List list = root.getChild("ads").getChildren();
if (list!=null) {
Iterator ir = list.iterator();
int k = 1;
while (ir.hasNext()) {
	Element e = (Element)ir.next();
%>	  
      <table width="73%" align="center" class="frame_gray">
        <form id=form<%=k%> name=form<%=k%> action="?op=setAd" method=post onSubmit="return form_onsubmit('<%=k%>')">
          <tr>
            <td height="22" class="thead">
				<strong><a name="focus">广告位<%=k%><input name="id" type="hidden" value="<%=k%>"><input name="content" type="hidden" value=""></a></strong>
				<% if(k>2) { %>
				<font style="color:#666666; font-size:11px; font-weight:lighter;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;（预留广告位,提取代码为{$blog.ad(id=<%=k%>)}，如需要请在模版中自行添加摆放位置）</font>
				<% } %>
            </td>
          </tr>
          <tr>
            <td height="22">摘要：
<pre id="divAd<%=k%>" name="divAd<%=k%>" style="display:none">
<%=home.getProperty("ads", "id", "" + k)%>
</pre>			
<script type="text/javascript" src="../../FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor<%=k%> = new FCKeditor( 'FCKeditor<%=k%>' ) ;
oFCKeditor<%=k%>.BasePath = '../../FCKeditor/';
oFCKeditor<%=k%>.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor<%=k%>.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor<%=k%>.Width = "100%";
oFCKeditor<%=k%>.Height = 150 ;
oFCKeditor<%=k%>.Value = divAd<%=k%>.innerHTML;

// 解决自动首尾加<p></p>的问题
// oFCKeditor<%=k%>.Config["EnterMode"] = 'br' ;     // p | div | br (回车)
// oFCKeditor<%=k%>.Config["ShiftEnterMode"] = 'p' ; // p | div | br(shift+enter)

oFCKeditor<%=k%>.Config["FormatSource"]=false;

oFCKeditor<%=k%>.Create() ;
//-->
</script>			</td>
          </tr>
          <tr>
            <td height="22" align="center"><input name="submit2" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
          </tr>
        </form>
      </table><BR>
<%
	k++;
}
}%></td>
  </tr>
</table>
</td> </tr>             
      </table>                                        
       </td>                                        
     </tr>                                        
 </table>                                        
</body>                                        
</html>                            
  