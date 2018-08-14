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

var curObj;

function openSelHotTopicWin() {
	curObj = form1.hot;
	openWin("../../../topic_m.jsp?action=sel", 800, 600);	
}

function openSelFocusTopicWin() {
	curObj = form2.id;
	openWin("../../../topic_m.jsp?action=sel", 800, 600);	
}

function selTopic(ids) {
	// 检查在notices中是否已包含了ids中的id，避免重复加入
	var ary = ids.split(",");
	var ntc = curObj.value;
	var ary2 = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		var founded = false;
		for (var j=0; j<ary2.length; j++) {
			if (ary[i]==ary2[j]) {
				founded = true;
				break;
			}
		}
		if (!founded) {
			if (ntc=="")
				ntc += ary[i];
			else
				ntc += "," + ary[i];
		}
	}
	curObj.value = ntc;
}

function delHot(id) {
	var ntc = form1.hot.value;
	var ary = ntc.split(",");
	var ary2 = new Array();
	var k = 0;
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			continue;
		}
		else {
			ary2[k] = ary[i];
			k++;
		}
	}
	ntc = "";
	for (i=0; i<ary2.length; i++) {
		if (ntc=="")
			ntc += ary2[i];
		else
			ntc += "," + ary2[i];
	}
	form1.hot.value = ntc;
	form1.submit();
}

function up(id) {
	var ntc = form1.hot.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=0) {
				var tmp = ary[i-1];
				ary[i-1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	form1.hot.value = ntc;
	form1.submit();
}

function down(id) {
	var ntc = form1.hot.value;
	var ary = ntc.split(",");
	for (var i=0; i<ary.length; i++) {
		if (ary[i]==id) {
			// 往上移动的节点不是第一个节点
			if (i!=ary.length-1) {
				var tmp = ary[i+1];
				ary[i+1] = ary[i];
				ary[i] = tmp;
			}
			else
				return;
			break;
		}
	}
	ntc = "";
	for (i=0; i<ary.length; i++) {
		if (ntc=="")
			ntc += ary[i];
		else
			ntc += "," + ary[i];
	}
	form1.hot.value = ntc;
	form1.submit();
}

function form2_onsubmit() {
	var oEditor = FCKeditorAPI.GetInstance('FCKeditor1') ;
	var htmlcode = oEditor.GetXHTML( true );
	form2.abstract.value = htmlcode;
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

String op = ParamUtil.get(request, "op");
if (op.equals("setHot")) {
	String hot = ParamUtil.get(request, "hot");
	home.setProperty("hot", hot);
	out.print(StrUtil.Alert_Redirect("操作成功！", "manager.jsp"));
}

if (op.equals("setFocus")) {
	String id = ParamUtil.get(request, "id");
	String title = ParamUtil.get(request, "title");
	String abstract2 = ParamUtil.get(request, "abstract");
	home.setProperty("focus.id", id);
	home.setProperty("focus.title", title);
	home.setProperty("focus.abstract", abstract2);
	
	out.print(StrUtil.Alert_Redirect("操作成功！", "manager.jsp"));
}

if (op.equals("setBoards")) {
	for (int i=1; i<=8; i++) {
		String boardCode = ParamUtil.get(request, "board" + i);
		home.setProperty("boards", "id", "" + i, boardCode);	
	}	
	out.print(StrUtil.Alert_Redirect("操作成功！", "manager.jsp"));
}

if (op.equals("setFlashImages")) {
	for (int i=1; i<=5; i++) {
		String url = ParamUtil.get(request, "url" + i);
		String link = ParamUtil.get(request, "link" + i);
		String text = ParamUtil.get(request, "text" + i);
		home.setProperty("flash", "id", "" + i, "url", url);	
		home.setProperty("flash", "id", "" + i, "link", link);	
		home.setProperty("flash", "id", "" + i, "text", text);	
	}	
	out.print(StrUtil.Alert_Redirect("操作成功！", "manager.jsp"));
}%>
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
      <table width="73%" align="center" class="frame_gray">
      <form id=form1 name=form1 action="?op=setHot" method=post>
        <tr>
          <td height="22" class="thead"><strong><a name="hot">热点话题</a></strong>&nbsp;( 编号之间用，分隔 )</td>
        </tr>
        <tr>
          <td height="22"><input type=text value="<%=StrUtil.getNullString(home.getProperty("hot"))%>" name="hot" size=60>
            <input name="button" type="button" class="btn" onClick="openSelHotTopicWin()" value="选 择">
            <input type="submit" class="btn" value="确 定"></td>
          </tr>
        <tr>
          <td height="22">
		  <%
		  					MsgMgr mm = new MsgMgr();
							MsgDb md = null;
							int[] v = home.getHotIds();
							int hotlen = v.length;
							if (hotlen==0)
								out.print("无热点话题！");
							else {
								for (int k=0; k<hotlen; k++) {
									md = mm.getMsgDb(v[k]);
									if (md.isLoaded()) {
										String color = StrUtil.getNullString(md.getColor());
										if (color.equals("")) {%>
											<%=md.getId()%>&nbsp;<img src="../../../../images/arrow.gif">&nbsp;<a href="../../../showtopic.jsp?rootid=<%=md.getId()%>"><%=md.getTitle()%></a>
											<%}else{%>
											<%=md.getId()%>&nbsp;<img src="../../../../images/arrow.gif">&nbsp;<a href="../../../showtopic.jsp?rootid=<%=md.getId()%>"><font color="<%=color%>"><%=md.getTitle()%></font></a>
											<%}%>
											&nbsp;&nbsp;[<a href="javascript:delHot('<%=md.getId()%>')">
											<lt:Label key="op_del"/>
											</a>]
											<%if (k!=0) {%>
											&nbsp;&nbsp;[<a href="javascript:up('<%=md.getId()%>')">
											<lt:Label res="res.label.forum.admin.ad_topic_bottom" key="up"/>
											</a>]
											<%}%>
											<%if (k!=hotlen-1) {%>
											&nbsp;&nbsp;[<a href="javascript:down('<%=md.getId()%>')">
											<lt:Label res="res.label.forum.admin.ad_topic_bottom" key="down"/>
											</a>]
											<%}%>
											<br>
											<%	}
										else {%>
											<%=v[k]%>&nbsp;<font color=red><img src="../../../../images/arrow.gif">&nbsp;贴子不存在</font> &nbsp;&nbsp;[<a href="javascript:delHot('<%=v[k]%>')">
											<lt:Label key="op_del"/>
											</a>]<BR>
										<%}
								}
							}%>			</td>
        </tr>
      </form>
</table>
      <br>
      <table width="73%" align="center" class="frame_gray">
        <form id=form2 name=form2 action="?op=setFocus" method=post onSubmit="return form2_onsubmit()">
          <tr>
            <td height="22" class="thead"><strong><a name="focus">今日焦点</a></strong></td>
          </tr>
          
          <tr>
            <td height="22">编号：
              <%
			String focusId = StrUtil.getNullString(home.getProperty("focus.id")).trim();
			if (!focusId.equals("")) {
				long fId = Long.parseLong(focusId);
				md = mm.getMsgDb(fId);
			}
			%>
              <input type=text value="<%=focusId%>" name="id" style='border:1pt solid #636563;font-size:9pt' size=5>
              <input name="abstract" type="hidden" value="">
              <input name="button2" type="button" class="btn" onClick="openSelFocusTopicWin()" value="选 择">
              <a href="../../../showtopic.jsp?rootid=<%=focusId%>" target=_blank><%=md==null?"":md.getTitle()%></a></td>
          </tr>
          <tr>
            <td height="22">标题：            
            <input name="title" size=50 value="<%=home.getProperty("focus.title")%>"></td>
          </tr>
          <tr>
            <td height="22">摘要：
<pre id="divAbstract" name="divAbstract" style="display:none">
<%=home.getProperty("focus.abstract")%>
</pre>
<script type="text/javascript" src="../../../../FCKeditor/fckeditor.js"></script>
<script type="text/javascript">
<!--
var oFCKeditor = new FCKeditor( 'FCKeditor1' ) ;
oFCKeditor.BasePath = '../../../../FCKeditor/';
oFCKeditor.Config['CustomConfigurationsPath'] = '<%=request.getContextPath()%>/FCKeditor/fckconfig_cws_forum.jsp' ;
oFCKeditor.ToolbarSet = 'Simple'; // 'Basic' ;
oFCKeditor.Width = 400 ;
oFCKeditor.Height = 150 ;
oFCKeditor.Value = divAbstract.innerHTML;

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
      <table width="73%" align="center" class="frame_gray">
	  <%
	  com.redmoon.forum.Directory dir = new com.redmoon.forum.Directory();
	  com.redmoon.forum.Leaf leaf;
	  com.redmoon.forum.DirectoryView dv;
	  %>
        <form id=form3 name=form3 action="?op=setBoards" method=post>
          <tr>
            <td height="22" colspan="2" class="thead"><strong><a name="boards">版块设置</a></strong></td>
          </tr>
          <tr>
            <td width="50%" height="22">版块设置1
              <select name="board1" onChange="if(this.options[this.selectedIndex].value=='not'){alert('您选择的是区域，请选择版块！'); this.selectedIndex=0;}">
                <option value="" selected>请选择版块</option>
                <%
				leaf = dir.getLeaf(Leaf.CODE_ROOT);
				dv = new com.redmoon.forum.DirectoryView(leaf);
				dv.ShowDirectoryAsOptions(request, privilege, out, leaf, leaf.getLayer());
			%>
              </select>
			  <script>
			  form3.board1.value = "<%=home.getProperty("boards", "id", "" + 1)%>";
			  </script>
            <br></td>
            <td width="50%" height="22">版块设置2
              <select name="board2" onChange="if(this.options[this.selectedIndex].value=='not'){alert('您选择的是区域，请选择版块！'); this.selectedIndex=0;}">
                  <option value="" selected>请选择版块</option>
                  <%
				leaf = dir.getLeaf(Leaf.CODE_ROOT);
				dv = new com.redmoon.forum.DirectoryView(leaf);
				dv.ShowDirectoryAsOptions(request, privilege, out, leaf, leaf.getLayer());
			%>
              </select>
                <script>
			  form3.board2.value = "<%=home.getProperty("boards", "id", "" + 2)%>";
			  </script></td>
          </tr>
          <tr>
            <td width="50%" height="22">版块设置3
              <select name="board3" onChange="if(this.options[this.selectedIndex].value=='not'){alert('您选择的是区域，请选择版块！'); this.selectedIndex=0;}">
                  <option value="" selected>请选择版块</option>
                  <%
				leaf = dir.getLeaf(Leaf.CODE_ROOT);
				dv = new com.redmoon.forum.DirectoryView(leaf);
				dv.ShowDirectoryAsOptions(request, privilege, out, leaf, leaf.getLayer());
			%>
              </select>
                <script>
			  form3.board3.value = "<%=home.getProperty("boards", "id", "" + 3)%>";
			  </script>
                <br></td>
            <td width="50%" height="22">版块设置4
              <select name="board4" onChange="if(this.options[this.selectedIndex].value=='not'){alert('您选择的是区域，请选择版块！'); this.selectedIndex=0;}">
                  <option value="" selected>请选择版块</option>
                  <%
				leaf = dir.getLeaf(Leaf.CODE_ROOT);
				dv = new com.redmoon.forum.DirectoryView(leaf);
				dv.ShowDirectoryAsOptions(request, privilege, out, leaf, leaf.getLayer());
			%>
              </select>
                <script>
			  form3.board4.value = "<%=home.getProperty("boards", "id", "" + 4)%>";
			  </script></td>
          </tr>
          <tr>
            <td width="50%" height="22">版块设置5
              <select name="board5" onChange="if(this.options[this.selectedIndex].value=='not'){alert('您选择的是区域，请选择版块！'); this.selectedIndex=0;}">
                  <option value="" selected>请选择版块</option>
                  <%
				leaf = dir.getLeaf(Leaf.CODE_ROOT);
				dv = new com.redmoon.forum.DirectoryView(leaf);
				dv.ShowDirectoryAsOptions(request, privilege, out, leaf, leaf.getLayer());
			%>
              </select>
                <script>
			  form3.board5.value = "<%=home.getProperty("boards", "id", "" + 5)%>";
			  </script>
                <br></td>
            <td width="50%" height="22">版块设置6
              <select name="board6" onChange="if(this.options[this.selectedIndex].value=='not'){alert('您选择的是区域，请选择版块！'); this.selectedIndex=0;}">
                  <option value="" selected>请选择版块</option>
                  <%
				leaf = dir.getLeaf(Leaf.CODE_ROOT);
				dv = new com.redmoon.forum.DirectoryView(leaf);
				dv.ShowDirectoryAsOptions(request, privilege, out, leaf, leaf.getLayer());
			%>
              </select>
                <script>
			  form3.board6.value = "<%=home.getProperty("boards", "id", "" + 6)%>";
			  </script></td>
          </tr>
          <tr>
            <td width="50%" height="22">版块设置7
              <select name="board7" onChange="if(this.options[this.selectedIndex].value=='not'){alert('您选择的是区域，请选择版块！'); this.selectedIndex=0;}">
                  <option value="" selected>请选择版块</option>
                  <%
				leaf = dir.getLeaf(Leaf.CODE_ROOT);
				dv = new com.redmoon.forum.DirectoryView(leaf);
				dv.ShowDirectoryAsOptions(request, privilege, out, leaf, leaf.getLayer());
			%>
              </select>
                <script>
			  form3.board7.value = "<%=home.getProperty("boards", "id", "" + 7)%>";
			  </script>
                <br></td>
            <td width="50%" height="22">版块设置8
              <select name="board8" onChange="if(this.options[this.selectedIndex].value=='not'){alert('您选择的是区域，请选择版块！'); this.selectedIndex=0;}">
                  <option value="" selected>请选择版块</option>
                  <%
				leaf = dir.getLeaf(Leaf.CODE_ROOT);
				dv = new com.redmoon.forum.DirectoryView(leaf);
				dv.ShowDirectoryAsOptions(request, privilege, out, leaf, leaf.getLayer());
			%>
              </select>
                <script>
			  form3.board8.value = "<%=home.getProperty("boards", "id", "" + 8)%>";
			  </script></td>
          </tr>
          <tr>
            <td height="22" colspan="2" align="center"><input name="submit3" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value=" 确 定 "></td>
          </tr>
        </form>
      </table>
      <br>
      <table width="73%" align="center" class="frame_gray">
        <form id=form4 name=form4 action="?op=setFlashImages" method=post>
          <tr>
            <td height="22" class="thead"><strong><a name="flash">Flash图片设置</a></strong></td>
            <td height="22" class="thead"><strong>地址</strong></td>
            <td height="22" class="thead"><strong>链接</strong></td>
            <td height="22" class="thead"><strong>文字</strong></td>
          </tr>
          <tr>
            <td height="22">图片1              </td>
            <td><input name="url1" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "1", "url"))%>"></td>
            <td><input name="link1" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "1", "link"))%>"></td>
            <td><input name="text1" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "1", "text"))%>"></td>
          </tr>
          <tr>
            <td height="22">图片2              </td>
            <td><input name="url2" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "2", "url"))%>"></td>
            <td><input name="link2" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "2", "link"))%>"></td>
            <td><input name="text2" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "2", "text"))%>"></td>
          </tr>
          <tr>
            <td height="22">图片3              </td>
            <td><input name="url3" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "3", "url"))%>"></td>
            <td><input name="link3" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "3", "link"))%>"></td>
            <td><input name="text3" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "3", "text"))%>"></td>
          </tr>
          <tr>
            <td height="22">图片4              </td>
            <td><input name="url4" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "4", "url"))%>"></td>
            <td><input name="link4" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "4", "link"))%>"></td>
            <td><input name="text4" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "4", "text"))%>"></td>
          </tr>
          <tr>
            <td width="23%" height="22">图片5  			  </td>
            <td width="26%"><input name="url5" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "5", "url"))%>"></td>
            <td width="28%"><input name="link5" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "5", "link"))%>"></td>
            <td width="23%"><input name="text5" value="<%=StrUtil.getNullStr(home.getProperty("flash", "id", "5", "text"))%>"></td>
          </tr>
          <tr>
            <td height="22" colspan="4" align="center"><input name="submit32" type="submit" style="border:1pt solid #636563;font-size:9pt; LINE-HEIGHT: normal;HEIGHT: 18px;" value=" 确 定 "></td>
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
  