<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.pvg.Privilege"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="common.css" rel="stylesheet" type="text/css">
<link href="cms/default.css" rel="stylesheet" type="text/css">
<script>
function ClearAll(){
	oFCKeditor.Value = " ";
}
function addform_submit(){
	var htmlcode = FCKeditorAPI.GetInstance('FCKeditor1').GetXHTML( true );
	if (htmlcode=="")
		htmlcode = " ";
	addform.htmlcode.value = htmlcode;
}	
</script>
<jsp:useBean id="docmanager" scope="page" class="cn.js.fan.module.cms.DocumentMgr"/>
<%
cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();

int id = 0;
Document doc = null;
id = ParamUtil.getInt(request, "id");
Privilege privilege = new Privilege();
doc = docmanager.getDocument(request, id, privilege);

LeafPriv lp = new LeafPriv(doc.getDirCode());
if (!lp.canUserModify(privilege.getUser(request))) {
	out.print(SkinUtil.makeErrMsg(request, Privilege.MSG_INVALID));
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
			<a href="cms/document_list_m.jsp?dir_code=<%=StrUtil.UrlEncode(lf.getCode())%>"><%=lf.getName()%></a>
        </TD>
    </TR>
  </TBODY>
</TABLE>
<br>
<form name="addform" action="doc_abstract_do.jsp?action=fckwebedit_new" method="post" onSubmit="return addform_submit()" enctype="MULTIPART/FORM-DATA">
	  <table class="eTab" border="0" cellspacing="1" width="100%" cellpadding="0" align="center">
	  		<thead>
            <tr align="center" bgcolor="#F2F2F2">
              <td width="187%" height="20" colspan=3 align=center>
			  <b>
			  <lt:Label res="res.label.doc_abstract" key="abstract"/>&nbsp;&nbsp;
			  <a href="fckwebedit_new.jsp?op=edit&id=<%=doc.getID()%>&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>"><%=doc.getTitle()%></a></b>&nbsp;
			  <input type="hidden" name=id value="<%=doc.getID()%>">			  <input type="hidden" name="htmlcode"></td>
            </tr>
			</thead>
            <tr align="center">
              <td colspan="3" valign="top" bgcolor="#F2F2F2" class="unnamed2">
			  <textarea id="content" name="content" style="display:none">
			  </textarea>
<pre id="idTemporary" name="idTemporary" style="display:none">
<%=StrUtil.getNullString(doc.getSummary())%>
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
</script>              </td>
            </tr>
            <tr>
              <td height="32" colspan=3 align=center bgcolor="#FFFFFF">
      	<input name="Submit" type="submit" class="singleboarder" value=" <%=SkinUtil.LoadString(request,"commit")%> ">
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input name="Submit2" type="button" class="singleboarder" value=" <lt:Label res="res.label.doc_abstract" key="return"/> " onclick="window.location.href='fckwebedit_new.jsp?op=edit&id=<%=doc.getID()%>&dir_code=<%=StrUtil.UrlEncode(doc.getDirCode())%>'" />
	  </td>
            </tr>
        </table>
</form>
</body>

</html>