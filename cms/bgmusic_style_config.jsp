<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<jsp:useBean id="fchar" scope="page" class="cn.js.fan.util.StrUtil"/>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
<meta http-equiv="expires" content="wed, 26 Feb 1997 08:21:57 GMT">
<title></title>
<LINK href="default.css" type=text/css rel=stylesheet>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
}
-->
</style>
</head>
<body  bgcolor="#FFFFFF">
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
if (!privilege.isMasterLogin(request)) {
    out.print(cn.js.fan.web.SkinUtil.makeErrMsg(request, cn.js.fan.web.SkinUtil.LoadString(request, "pvg_invalid")));
	return;
}

BgMusicStyleConfig dc = BgMusicStyleConfig.getInstance();

String op = ParamUtil.get(request, "op");

if (op.equals("edit")) {
	String code = ParamUtil.get(request, "code");
	String name = ParamUtil.get(request, "name");
	String width = ParamUtil.get(request, "width");
	String height = ParamUtil.get(request, "height");
	
	dc.setProperty("style", "code", code, "name", name);
	dc.setProperty("style", "code", code, "width", width);
	dc.setProperty("style", "code", code, "height", height);
	dc.cfg = null;
	out.print(StrUtil.Alert_Redirect("操作成功!", "bgmusic_style_config.jsp"));
	return;
}

if (op.equals("del")) {
	String code = ParamUtil.get(request, "code");
  	Element root = dc.getRoot();
	Iterator ir = root.getChild("style").getChildren().iterator();
	while (ir.hasNext()) {
        Element child = (Element) ir.next();
        String code2 = child.getAttributeValue("code");
        if (code2.equals(code)) {
            root.getChild("style").removeContent(child);
            dc.writemodify();
            break;
        }	
	}
	out.print(StrUtil.Alert_Redirect("操作成功!", "bgmusic_style_config.jsp"));
	return;	
}

if (op.equals("add")) {
	String code = ParamUtil.get(request, "code");
  	Element root = dc.getRoot();	
	Iterator ir = root.getChild("style").getChildren().iterator();
	while (ir.hasNext()) {
        Element child = (Element) ir.next();
        String code2 = child.getAttributeValue("code");
        if (code2.equals(code)) {
            out.print(StrUtil.Alert_Back("该编码已存在!"));
			return;
        }	
	}
	
	String name = ParamUtil.get(request, "name");
	String width = ParamUtil.get(request, "width");
	String height = ParamUtil.get(request, "height");
	
    Element eitem = new Element("item");
    eitem.setAttribute(new Attribute("code", code));
	
    Element ename = new Element("name");
    ename.setText(name);
    eitem.addContent(ename);
    Element ew = new Element("width");
    ew.setText(width);
    eitem.addContent(ew);
    Element eh = new Element("height");
    eh.setText(height);
    eitem.addContent(eh);	

    root.getChild("style").addContent(eitem);
	dc.writemodify();
		
	out.print(StrUtil.Alert_Redirect("操作成功！", "bgmusic_style_config.jsp"));
	return;
}
%>
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
    <TR>
      <TD class=head>背景音乐样式配置</TD>
    </TR>
  </TBODY>
</TABLE>
<br>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" class="tableframe" style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" >
  <tr style="BACKGROUND-COLOR: #fafafa"> 
    <td width="100%" valign="top" bgcolor="#FFFFFF"><table width="100%" border="0" cellpadding="3" cellspacing="0">
          <tr>
            <td width="13%" class="thead">编码&nbsp;</td>
            <td width="25%" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">名称</td>
            <td width="20%" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">宽度</td>
            <td width="21%" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">高度</td>
            <td width="21%" class="thead"><img src="images/tl.gif" align="absMiddle" width="10" height="15">操作</td>
          </tr>
<%	  
  Element root = dc.getRoot();
  Iterator ir = root.getChild("style").getChildren("item").iterator();
  int k = 0;
  while (ir.hasNext()) {
  	Element e = (Element)ir.next();
	String code = e.getAttributeValue("code");
	String name = e.getChildText("name");
	String width = e.getChildText("width");
	String height = e.getChildText("height");
	k++;
%>
	<form name="formDig<%=k%>" action="bgmusic_style_config.jsp?op=edit" method="post">
            <tr><td><input name="code" value="<%=code%>" readonly></td>
            <td><input name="name" value="<%=name%>"></td>
            <td><input name="width" value="<%=width%>" size="10"></td>
            <td><input name="height" value="<%=height%>" size="10"></td>
            <td><input name="submit" type="submit" value="确定">
              <input name="submit3" type="button" value="删除" onClick="if (confirm('您确定要删除么？')) window.location.href='bgmusic_style_config.jsp?op=del&code=<%=code%>'"></td>
            </tr>
	</form>
            <%
  }
%>      
<form name="formDigAdd" action="bgmusic_style_config.jsp?op=add" method="post">
            <tr>
              <td><input name="code"></td>
              <td><input name="name"></td>
              <td><input name="width" size="10"></td>
              <td><input name="height" size="10"></td>
              <td><input name="submit4" type="submit" value="添加"></td>
            </tr>
		</form>
			</table>
    </td>
  </tr>
</table> 
</body>                                        
</html>                            
  