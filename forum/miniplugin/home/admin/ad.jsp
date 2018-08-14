<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="../../../inc/inc.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.db.Conn"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.forum.miniplugin.home.*"%>
<%@ page import="com.redmoon.forum.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<html><head>
<meta http-equiv="pragma" content="no-cache">
<LINK href="../../../admin/default.css" type=text/css rel=stylesheet>
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>插件管理</title>
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

function form1_onsubmit() {
	var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
	var htmlcode = oEditor.GetXHTML( true );
	form1.content.value = htmlcode;
}

function form2_onsubmit() {
	var oEditor = FCKeditorAPI.GetInstance('FCKeditor2') ;
	var htmlcode = oEditor.GetXHTML( true );
	form2.content.value = htmlcode;
}

function form3_onsubmit() {
	var oEditor = FCKeditorAPI.GetInstance('FCKeditor3') ;
	var htmlcode = oEditor.GetXHTML( true );
	form3.content.value = htmlcode;
}

function form4_onsubmit() {
	var oEditor = FCKeditorAPI.GetInstance('FCKeditor4') ;
	var htmlcode = oEditor.GetXHTML( true );
	form4.content.value = htmlcode;
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
            <td width="77" align="center"><a href="manager.jsp#hot">热点话题</a></td>
            <td width="77" align="center"><a href="manager.jsp#focus">今日焦点</a></td>
            <td width="77" align="center"><a href="manager.jsp#boards">版块设置</a></td>
            <td width="101" align="center"><a href="manager.jsp#flash">Flash图片设置</a></td>
            <td width="81" align="center"><a href="ad.jsp">广告</a></td>
          </tr>
      </table>
      <br>
      <br>
      <table width="73%" align="center" class="frame_gray">
        <form id=form1 name=form1 action="?op=setAd" method=post onSubmit="return form1_onsubmit()">
          <tr>
            <td height="22" class="thead"><strong><a name="focus">广告位2
                  <input name="id" type="hidden" value="1">
                  <input name="content" type="hidden" value="">
            </a></strong></td>
          </tr>
          <tr>
            <td height="22">摘要：
<pre id="divAd1" name="divAd1" style="display:none">
<%=home.getProperty("ads", "id", "1")%>
</pre>			
<script type="text/javascript" src="../../../../FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath = '../../../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = "100%";
oFCKeditor.Height = 150 ;
oFCKeditor.Value = divAd1.innerHTML;

oFCKeditor.Config["LinkBrowser"]=false;//文件
oFCKeditor.Config["ImageBrowser"]=true;
oFCKeditor.Config["FlashBrowser"]=true;

oFCKeditor.Config["LinkUpload"]=false;
oFCKeditor.Config["ImageUpload"]=false;
oFCKeditor.Config["FlashUpload"]=false;

oFCKeditor.Create() ;
//-->
</script>			</td>
          </tr>
          <tr>
            <td height="22" align="center"><input name="submit2" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
          </tr>
        </form>
      </table>
      <br>
      <br>
      <table width="73%" align="center" class="frame_gray">
        <form id=form2 name=form2 action="?op=setAd" method=post onSubmit="return form2_onsubmit()">
          <tr>
            <td height="22" class="thead"><strong><a name="focus">广告位2
                  <input name="id" type="hidden" value="2">
                  <input name="content" type="hidden" value="">
            </a></strong></td>
          </tr>
          <tr>
            <td height="22">摘要：
<pre id="divAd2" name="divAd2" style="display:none">
<%=home.getProperty("ads", "id", "2")%>
</pre>						
<script type="text/javascript">
<!--
var oFCKeditor2 = new FCKeditor( 'FCKeditor2' ) ;
oFCKeditor2.BasePath = '../../../../FCKeditor/';
oFCKeditor2.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor2.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor2.Width = "100%" ;
oFCKeditor2.Height = 150 ;
oFCKeditor2.Value = divAd2.innerHTML;
oFCKeditor2.Create() ;
//-->
        </script>
            </td>
          </tr>
          <tr>
            <td height="22" align="center"><input name="submit22" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
          </tr>
        </form>
      </table>
      <br>
      <br>
      <table width="73%" align="center" class="frame_gray">
        <form id=form3 name=form3 action="?op=setAd" method=post onSubmit="return form3_onsubmit()">
          <tr>
            <td height="22" class="thead"><strong><a name="focus">广告位3
                  <input name="id" type="hidden" value="3">
                  <input name="content" type="hidden" value="">
            </a></strong></td>
          </tr>
          <tr>
            <td height="22">摘要：
<pre id="divAd3" name="divAd3" style="display:none">
<%=home.getProperty("ads", "id", "3")%>
</pre>									
<script type="text/javascript">
<!--
var oFCKeditor3 = new FCKeditor( 'FCKeditor3' ) ;
oFCKeditor3.BasePath = '../../../../FCKeditor/';
oFCKeditor3.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor3.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor3.Width = "100%" ;
oFCKeditor3.Height = 150 ;
oFCKeditor3.Value = divAd3.innerHTML;
oFCKeditor3.Create() ;
//-->
        </script>
            </td>
          </tr>
          <tr>
            <td height="22" align="center"><input name="submit222" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
          </tr>
        </form>
      </table>
      <br>
      <table width="73%" align="center" class="frame_gray">
        <form id=form4 name=form4 action="?op=setAd" method=post onSubmit="return form4_onsubmit()">
          <tr>
            <td height="22" class="thead"><strong><a name="focus">广告位4
                  <input name="id" type="hidden" value="4">
                  <input name="content" type="hidden" value="">
            </a></strong></td>
          </tr>
          <tr>
            <td height="22">摘要：
<pre id="divAd4" name="divAd4" style="display:none">
<%=home.getProperty("ads", "id", "4")%>
</pre>						
<script type="text/javascript">
<!--
var oFCKeditor4 = new FCKeditor( 'FCKeditor4' ) ;
oFCKeditor4.BasePath = '../../../../FCKeditor/';
oFCKeditor4.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor4.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor4.Width = "100%" ;
oFCKeditor4.Height = 150 ;
oFCKeditor4.Value = divAd4.innerHTML;
oFCKeditor4.Create() ;
//-->
        </script>
            </td>
          </tr>
          <tr>
            <td height="22" align="center"><input name="submit2222" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
          </tr>
        </form>
      </table>
      <br>
      <br>
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
  