<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.security.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.Privilege"%>
<%@ page import="java.util.Calendar" %>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="common.css" rel="stylesheet" type="text/css">
<link href="cms/default.css" rel="stylesheet" type="text/css">
<%
String correct_result = SkinUtil.LoadString(request,"info_op_success");
%>
<script>
	function addform_submit() {
		addform.content.value = oFCKeditor.Value;
	}
	
	function ClearAll(){
		oFCKeditor.Value = " ";
	}
	
	function SubmitWithFile(){
		var htmlcode = FCKeditorAPI.GetInstance('FCKeditor1').GetXHTML( true );
		if (htmlcode=="")
			htmlcode = " ";
		addform.webedit.Clear();
		addform.webedit.AddField("id", addform.id.value);
		addform.webedit.SetHtmlCode(htmlcode);
		addform.webedit.UploadArticle();
		if (addform.webedit.ReturnMessage == "<%=correct_result%>")
			doAfter(true);
		else
			doAfter(false);
	}	
	
	function SubmitWithoutFile(){
		var htmlcode = FCKeditorAPI.GetInstance('FCKeditor1').GetXHTML( true );
		if (htmlcode=="")
			htmlcode = " ";
		addform.webedit.Clear();
		addform.webedit.UploadMode = 0;
		addform.webedit.AddField("isuploadfile", "false");
		addform.webedit.AddField("id", addform.id.value);
		addform.webedit.SetHtmlCode(htmlcode);
		addform.webedit.UploadArticle();
		if (addform.webedit.ReturnMessage == "<%=correct_result%>")
			doAfter(true);
		else
			doAfter(false);
	}	
	
	function doAfter(isSucceed) {
		if (isSucceed) {
			alert("<%=correct_result%>");
    		window.location.reload(true); 
		}
		else {
			alert(addform.webedit.ReturnMessage);
		}
	}	
</script>
<jsp:useBean id="strutil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<%
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();

int id = 0;
Document doc = null;
String op = ParamUtil.get(request, "op");
id = ParamUtil.getInt(request, "id");
Privilege privilege = new Privilege();
doc = docmanager.getDocument(request, id, privilege);

LeafPriv lp = new LeafPriv(doc.getDirCode());
if (!lp.canUserModify(privilege.getUser(request))) {
	out.print(StrUtil.makeErrMsg(privilege.MSG_INVALID));
	return;
}
%>
<title><%=doc.getTitle()%></title>
<style type="text/css">
<!--
td {  font-family: "Arial", "Helvetica", "sans-serif"; font-size: 14px; font-style: normal; line-height: 150%; font-weight: normal}
-->
</style>
<script type="text/javascript" src="FCKeditor/fckeditor.js"></script>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<TABLE cellSpacing=0 cellPadding=0 width="100%">
  <TBODY>
    <TR>
      <TD width="79%" class=head><%
			Leaf lf = new Leaf();
			lf = lf.getLeaf(doc.getDirCode());
			String navstr = "";
			String parentcode = lf.getParentCode();
			Leaf plf = new Leaf();
			while (!parentcode.equals(Leaf.ROOTCODE)) {
				plf = plf.getLeaf(parentcode);
				if (plf==null || !plf.isLoaded())
					break;
				if (plf.getType()==Leaf.TYPE_LIST && plf.getChildCount()!=0)
					navstr = "<a href='cms/dir_frame.jsp?root_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				else if (plf.getType()==Leaf.TYPE_LIST && plf.getChildCount()==0)
					navstr = "<a href='cms/document_list_m.jsp?dir_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;
				else if (plf.getType()==Leaf.TYPE_NONE) {
					navstr = "<a href='cms/dir_frame.jsp?root_code=" + StrUtil.UrlEncode(plf.getCode()) + "'>" + plf.getName() + "</a>&nbsp;>>&nbsp;" + navstr;				
				}
				else
					navstr = plf.getName() + "&nbsp;>>&nbsp;" + navstr;
				if (plf.getType()==Leaf.TYPE_SUB_SITE) {
					break;
				}				
				parentcode = plf.getParentCode();
			}
			out.print(navstr);
			%>
        <a href="cms/document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a> </TD>
    </TR>
  </TBODY>
</TABLE>
<br>
<form name="addform" action="/doc_abstract_do.jsp" method="post" onSubmit="return addform_submit()">
  <table class="eTab" border="0" cellspacing="1" width="98%" cellpadding="0" align="center">
		  <thead>
            <tr align="center" bgcolor="#F2F2F2">
              <td height="20" colspan=3 align=center>
			  <b>
				<lt:Label res="res.label.doc_abstract" key="abstract"/>&nbsp;&nbsp;&nbsp;&nbsp;
			  <a href="fckwebedit.jsp?op=edit&id=<%=doc.getID()%>&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>"><%=doc.getTitle()%></a></b>&nbsp;
			  <input type="hidden" name=id value="<%=doc.getID()%>">
			  </td>
            </tr>
			</thead>
            <tr align="center">
              <td colspan="3" valign="top" bgcolor="#F2F2F2" class="unnamed2">
			  <textarea id="content" name="content" style="display:none">
			  </textarea>
<pre id="idTemporary" name="idTemporary" style="display:none">
<%=strutil.getNullString(doc.getSummary())%>
</pre>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath = 'FCKeditor/' ;
oFCKeditor.Value = document.getElementById("idTemporary").innerHTML;
oFCKeditor.Height = 400 ;

oFCKeditor.Config["LinkBrowser"]=false;//文件
oFCKeditor.Config["ImageBrowser"]=true;
oFCKeditor.Config["FlashBrowser"]=true;

oFCKeditor.Config["LinkUpload"]=false;
oFCKeditor.Config["ImageUpload"]=false;
oFCKeditor.Config["FlashUpload"]=false;

oFCKeditor.Config["SkinPath"] = "skins/<%=cfg.getProperty("cms.fckeditorSkin")%>/";

oFCKeditor.Create() ;
//-->
</script>
              </td>
            </tr>
            <tr>
              <td width="13%" align="right" bgcolor="#FFFFFF"><lt:Label res="res.label.doc_abstract" key="notice"/></td>
              <td width="87%" colspan="2" bgcolor="#FFFFFF">
			  <lt:Label res="res.label.doc_abstract" key="enter_can_be_used"/>Shift+Enter			  </td>
            </tr>
            <tr>
              <td height="25" colspan=3 align="center" bgcolor="#FFFFFF"><table  border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
                <tr>
                  <td bgcolor="#FFFFFF"><%
Calendar cal = Calendar.getInstance();
String year = "" + (cal.get(cal.YEAR));
String month = "" + (cal.get(cal.MONTH) + 1);
String filepath = cfg.getProperty("cms.file_webedit") + "/" + year + "/" + month;
String isRelatePath = cfg.getProperty("cms.isRelatePath");
if (isRelatePath.equals("1"))
	isRelatePath = "2";
%>
                      <object classid="CLSID:DE757F80-F499-48D5-BF39-90BC8BA54D8C" codebase="<%=request.getContextPath()%>/activex/webedit.cab#version=4,0,1,1" width=400 height=173 align="middle" id="webedit">
                        <param name="Encode" value="utf-8">
                        <param name="MaxSize" value="<%=Global.MaxSize%>">
                        <!--上传字节-->
                        <param name="ForeColor" value="(0,255,0)">
                        <param name="BgColor" value="(0,0,0)">
                        <param name="ForeColorBar" value="(255,255,255)">
                        <param name="BgColorBar" value="(0,0,255)">
                        <param name="ForeColorBarPre" value="(0,0,0)">
                        <param name="BgColorBarPre" value="(200,200,200)">
                        <param name="FilePath" value="<%=filepath%>">
	                    <param name="Relative" value="<%=isRelatePath%>">						
                        <!--上传后的文件需放在服务器上的路径-->
                        <param name="Server" value="<%=request.getServerName()%>">
                        <param name="Port" value="<%=request.getServerPort()%>">
                        <param name="VirtualPath" value="<%=Global.virtualPath%>">
                        <param name="PostScript" value="<%=Global.virtualPath%>/doc_abstract_do.jsp">
						<param name="InternetFlag" value="<%=Global.internetFlag%>">
                    </object></td>
                </tr>
              </table></td>
            </tr>
            <tr>
              <td height="32" colspan=3 align=center bgcolor="#FFFFFF">
&nbsp;
&nbsp;
<input name="Submit" type="button" class="singleboarder" value=" <%=SkinUtil.LoadString(request,"commit")%> " onClick="return SubmitWithFile()">      &nbsp;&nbsp;&nbsp;
      <input name="Submit" type="button" class="singleboarder" value=" <%=SkinUtil.LoadString(request,"res.label.doc_abstract","submmit_not_upload_file")%> " onClick="return SubmitWithoutFile()">      &nbsp;&nbsp;&nbsp;&nbsp;
      <input name="Submit2" type="button" class="singleboarder" value=" <lt:Label res="res.label.doc_abstract" key="return"/> " onclick="window.location.href='fckwebedit.jsp?op=edit&id=<%=doc.getID()%>&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>'" />      &nbsp;（<%=SkinUtil.LoadString(request,"res.label.doc_abstract","abstract_donot_support_upload_attach")%>）</td>
            </tr>
  </table>
</form>
</body>

</html>