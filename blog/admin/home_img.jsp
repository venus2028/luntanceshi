<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="org.jdom.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
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
//-->
</script>
<body bgcolor="#FFFFFF" topmargin='0' leftmargin='0'>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request))
{
	out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

Home home = Home.getInstance();
Element root = home.getRoot();
String op = ParamUtil.get(request, "op");

if (op.equals("setImg")) {
	String id = ParamUtil.get(request, "id");
	String url = ParamUtil.get(request, "url");
	String link = ParamUtil.get(request, "link");
	String text = ParamUtil.get(request, "text");
	String order = ParamUtil.get(request, "order");
	if (!StrUtil.isNumeric(order)) {
		out.print(StrUtil.Alert_Back("序号必须为数字！"));
		return;
	}
	
	System.out.println(getClass() + " id=" + id);
	home.setProperty("images", "id", id, "url", url);
	home.setProperty("images", "id", id, "link", link);
	home.setProperty("images", "id", id, "text", text);
	home.setProperty("images", "id", id, "order", order);
	home.sortScrollImages();
	out.print(StrUtil.Alert_Redirect("操作成功！", "home_img.jsp"));
}

if (op.equals("addImg")) {
	String id = ParamUtil.get(request, "id");
	String url = ParamUtil.get(request, "url");
	String link = ParamUtil.get(request, "link");
	String text = ParamUtil.get(request, "text");
	String order = ParamUtil.get(request, "order");
	if (!StrUtil.isNumeric(order)) {
		out.print(StrUtil.Alert_Back("序号必须为数字！"));
		return;
	}	
    Element image = new Element("img");
    image.setAttribute(new Attribute("id", id));
    Element eUrl = new Element("url");
    eUrl.setText(url);
    image.addContent(eUrl);
    Element eLink = new Element("link");
    eLink.setText(link);
    image.addContent(eLink);
    Element eText = new Element("text");
    eText.setText(text);
    image.addContent(eText);
    Element eOrder = new Element("order");
    eOrder.setText(order);
    image.addContent(eOrder);

    root.getChild("images").addContent(image);
	home.writemodify();
	
	home.sortScrollImages();
	
	out.print(StrUtil.Alert_Redirect("操作成功！", "home_img.jsp"));
}

if (op.equals("del")) {
	String id = ParamUtil.get(request, "id");
	home.delImgFromImageScroll(id);
	out.print(StrUtil.Alert_Redirect("操作成功！", "home_img.jsp"));
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
          <td width="77" align="center"><a href="home.jsp#focus">热点话题</a></td>
          <td width="101" align="center"><a href="home.jsp#flash">Flash图片设置</a></td>
          <td width="81" align="center"><a href="ad.jsp">广告</a></td>
          <td width="81" align="center"><a href="home_img.jsp">滚动图片</a></td>
        </tr>
      </table>
      <br>
      <br>
<%
List list = null;
Element images = root.getChild("images");
if (images!=null)
	list = images.getChildren();
if (list!=null) {
Iterator ir = list.iterator();
int k = 1;
while (ir.hasNext()) {
	Element e = (Element)ir.next();
%>	  
      <table width="73%" align="center" class="frame_gray">
        <form id=form<%=k%> name=form<%=k%> action="?op=setImg" method=post>
          <tr>
            <td height="22" colspan="4" class="thead"><strong><a name="focus">图片<%=k%>
                  <input name="id" value="<%=e.getAttribute("id").getValue()%>" type="hidden">
            </a></strong></td>
          </tr>
          <tr>
            <td width="9%" height="22">序号：</td>
            <td width="31%">
             <input name="order" value="<%=e.getChild("order").getText()%>">			</td>
            <td width="11%">地址：</td>
            <td width="49%"><input name="url" value="<%=e.getChild("url").getText()%>"></td>
          </tr>
          <tr>
            <td height="22">链接：</td>
            <td><input name="link" value="<%=e.getChild("link").getText()%>"></td>
            <td>文字：</td>
            <td><input name="text" value="<%=e.getChild("text").getText()%>"></td>
          </tr>
          
          <tr>
            <td height="22" colspan="4" align="center"><input name="submit2" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定">
            &nbsp;&nbsp;
            <input name="submit23" type="button" onClick="if (confirm('您确定要删除吗？')) window.location.href='home_img.jsp?op=del&id=<%=e.getAttribute("id").getValue()%>'" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="删 除"></td>
          </tr>
        </form>
      </table>
      <BR>
<%
	k++;
}
}%>
<table width="73%" align="center" class="frame_gray">
  <form id=formAdd name=formAdd action="?op=addImg" method=post>
    <tr>
      <td height="22" colspan="4" class="thead"><strong><a name="focus">添加图片
            <input name="id" value="<%=RandomSecquenceCreator.getId(20)%>" type="hidden">
      </a></strong></td>
    </tr>
    <tr>
      <td width="9%" height="22">序号：</td>
      <td width="31%"><input name="order" value="">      </td>
      <td width="11%">地址：</td>
      <td width="49%"><input name="url"></td>
    </tr>
    
    <tr>
      <td height="22">链接：</td>
      <td><input name="link"></td>
      <td>文字：</td>
      <td><input name="text"></td>
    </tr>
    
    <tr>
      <td height="22" colspan="4" align="center"><input name="submit22" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value="确 定"></td>
    </tr>
  </form>
</table>
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
  