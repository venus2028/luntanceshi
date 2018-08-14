<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.module.cms.*"%>
<%@ page import="cn.js.fan.module.cms.template.*"%>
<%@ page import="cn.js.fan.module.cms.util.*"%>
<%@ page import="cn.js.fan.module.cms.ad.*"%>
<%@ page import="cn.js.fan.module.cms.site.*"%>
<%@ page import="cn.js.fan.module.cms.ui.*"%>
<%@ page import="com.redmoon.forum.OnlineUserDb"%>
<%
/*
使用方法：
1、显示文章从第start条至第end条，当start>=0时，显示文章的列表
	例：显示目录编码为notice的文章列表，从0至第9条（不包括第10条），标题长度为10
	<script src="js.jsp?dircode=notice&start=0&end=10&len=20"></script>
	相关参数：
	isdate=y，显示日期
	dateformat=yyyy-MM-dd，日期格式
	ishot=y，最热文章
	dirCode，文章目录编码
	isimg=y，显示文章中的第一幅图片
2、显示文章目录的LOGO
	<script src="js.jsp?dirCode=notice&logo=y"></script>
3、显示Flash广告，var=flashImg，id=55(id为Flash广告的编号)
	提取后台管理时创建的ID为55的Flash广告，标题长度为30个字符：<script src="js.jsp?var=flashImg&id=55&len=30&showPage=doc_show.jsp"></script>
	提取某个目录下面的文章的图片组成Flash广告<script src="js.jsp?var=flashImg&dirCode=***&showPage=doc_show.jsp"></script>
	提取某个子站点下面的文章的图片组成Flash广告<script src="js.jsp?var=flashImg&siteCode=***&showPage=doc_show.jsp"></script> (siteCode=root表示主站)
	showPage表示用来显示文章的页面的名称，默认为doc_show.jsp
4、显示广告
	例：显示头部广告
	<script src="js.jsp?var=ad&type=header"></script>
5、显示滚动图片，var=scrollImg
	提取10个某子站点的滚动图片：<script src="js.jsp?var=scrollImg&siteCode=***&count=10&showPage=doc_show.jsp"></script>，主站首页滚动图片siteCode参数不用填
	提取10个某个目录下面的文章的图片组成滚动图片：<script src="js.jsp?var=scrollImg&dirCode=***&count=10&showPage=doc_show.jsp"></script>
6、显示首页广告，var=homeAd，id=20(id为首页广告的编号)
	<script src="js.jsp?var=homeAd&id=20"></script>
7、显示子目录，var=dir
	例：提取编码为first的目录的子目录，提取10行，listView表示列表型节点显示页(默认为doc_list.jsp)，docView表示文章型节点显示页(默认为doc_show.jsp)
	<script src="js.jsp?var=dir&dirCode=first&listView=doc_list&docView=doc_show&row=10"></script>
8、显示目录中的第一篇文章或者给定ID的文章
	显示编码为news的目录中的第一篇文章<script src="/cwbbs/js.jsp?var=doc&isShowTitle=y&dir=news">
	显示ID为85的文章<script src="/cwbbs/js.jsp?var=doc&id=85&isShowTitle=y">
9、文章统计，<script src="/cwbbs/js.jsp?var=stat"></script>
	type="year" 当年
	type="month" 当月
	type="day" 当天
	type="yestoday" 昨天
	type="beforeyestoday" 前天
	type="allonline" 全部在线数
	type="memberonline" 会员在线数
10、排行，<script src="/cwbbs/js.jsp?var=rank"></script>
	type="user" 用户登录数、文章数排行
	type="group" 用户组登录数、文章数排行
*/
String logo = ParamUtil.get(request, "logo");
if (logo.equals("y")) {
	String dirCode = ParamUtil.get(request, "dircode");
	Leaf lf = new Leaf();
	lf = lf.getLeaf(dirCode);
	if (lf==null) {
	%>
	document.write('目录<%=dirCode%>不存在');	
	<%
		return;
	}
	
    cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
    boolean isHtml = cfg.getBooleanProperty("cms.html_doc");	
	
	String url = "";
    if (lf.getType() == Leaf.TYPE_LIST) {
        if (isHtml) {
            url = lf.getListHtmlNameByPageNum(request, 1);
        }
        else {
            url = "doc_list_view.jsp?dirCode=" + StrUtil.UrlEncode(lf.getCode());
        }
    }
    else if (lf.getType() == Leaf.TYPE_NONE) {
        url = lf.getName();
    } else if (lf.getType() == Leaf.TYPE_COLUMN || lf.getType()==Leaf.TYPE_SUB_SITE) {
        if (isHtml) {
            url = lf.getListHtmlPath() + "/index." + cfg.getProperty("cms.html_ext");
        }
        else {
            url = "doc_column_view.jsp?dirCode=" + StrUtil.UrlEncode(lf.getCode());
       }
    } else
        url = lf.getName();
%>
	document.write('<a href="<%=url%>"><img border=0 src="<%=request.getContextPath() + "/" + lf.getLogo()%>" /></a>');
<%	return;
}

int start = ParamUtil.getInt(request, "start", -1);
if (start>=0) {
	Document doc = new Document();
	int len = ParamUtil.getInt(request, "len", 20);
	String dirCode = ParamUtil.get(request, "dircode");
	int end = ParamUtil.getInt(request, "end", 10);
	String sql = SQLBuilder.getJSSql(request);

	cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
	boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
	String strIsDate = ParamUtil.get(request, "isdate");
	String strIsImg = ParamUtil.get(request, "isimg");
	boolean isdate = strIsDate.equals("true") || strIsDate.equals("y");
	boolean isimg = strIsImg.equals("true") || strIsImg.equals("y");
	String dateformat = ParamUtil.get(request, "dateformat");
	if (dateformat.equals(""))
		dateformat = "yyyy-MM-dd";

    String groupKey = dirCode;
	if (dirCode.equals(""))
		groupKey = DocCacheMgr.ALL;
				
   	Iterator ir = doc.getDocuments(sql, groupKey, start, end);
	out.println("document.write('<ul>');");	
	while (ir.hasNext()) {
		doc = (Document)ir.next();
		String t = StrUtil.getLeft(StrUtil.toHtml(doc.getTitle()), len);
        boolean isDateValid = DateUtil.compare(new java.util.Date(), doc.getExpireDate())==2;
        if (isDateValid) {
			if (doc.isBold())
				t = "<B>" + t + "</B>";
			if (!doc.getColor().equals("")) {
				t = "<font color=" + doc.getColor() + ">" + t +	"</font>";
			}
        }
		
        if (isDateValid && doc.getIsNew() == 1) {
	        t += "&nbsp;<img border=0 src=images/i_new.gif width=18 height=7>";
        }
		out.println("document.write('<li>');");
		if (isimg) {
			String imgPath  = doc.getFirstImagePathOfDoc();
			if (!imgPath.equals("")) {
				out.println("document.write(\"<img src='" + request.getContextPath() + "/" + imgPath + "' />\")");
			}
		}
		if (isdate) {%>
			document.write("<span style='float:right'><%=DateUtil.format(doc.getCreateDate(), dateformat)%>&nbsp;</span>");
		<%}
		if (!isHtml) {
	%>
			document.write('<a href="<%=Global.getRootPath()%>/doc_view.jsp?id=<%=doc.getId()%>" title="<%=StrUtil.toHtml(doc.getTitle())%>"><%=t%></a>');
	<%	}
		else {%>
			document.write('<a href="<%=Global.getRootPath()%>/<%=doc.getDocHtmlName(1)%>" title="<%=StrUtil.toHtml(doc.getTitle())%>"><%=t%></a>');
		<%}
		out.println("document.write('</li>');");
	}
	out.println("document.write('</ul>');");
	
}

String var = ParamUtil.get(request, "var");
if (var.equalsIgnoreCase("flashImg")) {
	String strId = ParamUtil.get(request, "id");
	String dirCode = ParamUtil.get(request, "dirCode");
	String siteCode = ParamUtil.get(request, "siteCode");
	int id = StrUtil.toInt(strId, -1);
	if (id == -1 && dirCode.equals("") && siteCode.equals("")) {
		out.print("document.write('The id of AdFlashImage is invalid(id=" + strId + ").');");
		return;
	}
	
	StringBuffer sb = new StringBuffer();
	if (id!=-1) {
		SiteFlashImageDb sfid = new SiteFlashImageDb();
		sfid = (SiteFlashImageDb) sfid.getQObjectDb(new Integer(id));
		if (sfid == null) {
			out.print("document.write('Ad Flash Image is null where id=" + id + ".');");
			return;
		}
		for (int i = 1; i <= 5; i++) {
			sb.append("imgUrl" + i + "=\"" +
					  StrUtil.getNullStr(sfid.getString("url" + i)) +
					  "\";\n");
			sb.append("imgtext" + i + "=\"" +
					  StrUtil.getNullStr(sfid.getString("title" + i)) +
					  "\";\n");
			sb.append("imgLink" + i + "=\"" +
					  StrUtil.getNullStr(sfid.getString("link" + i)) +
					  "\";\n");
		}
	} else if (!dirCode.equals("")) {
		Leaf lf = new Leaf();
		lf = lf.getLeaf(dirCode);
		if (lf==null) {
			out.print("document.write('The leaf " + dirCode + " is not exist.')");
			return;
		}
		
		boolean isAllChild = ParamUtil.get(request, "isAllChild").equals("true");
		// boolean isCache = ParamUtil.get(request, "isCache").equals("true");

		// 取出目录中含有图片的文章中的前五篇文章的图片
		Document doc = new Document();
        String sql = "select id from document where class1=" + StrUtil.sqlstr(dirCode);
		if (isAllChild)
        	sql = "select id from document where parent_code=" + StrUtil.sqlstr(dirCode);
		sql += " order by createDate";
		
		String showPage = ParamUtil.get(request, "showPage");
		if (showPage.equals(""))
			showPage = "doc_show.jsp";
		DocBlockIterator dbi = doc.getDocuments(sql, dirCode, 0, 50);
		int titleLen = ParamUtil.getInt(request, "len", 40);
		int i = 1;
		while (dbi.hasNext()) {
			doc = (Document)dbi.next();
			String imgPath = doc.getFirstImagePathOfDoc();
			if (!imgPath.equals("")) {
				sb.append("imgUrl" + i + "=\"" +
						  request.getContextPath() + "/" + imgPath +
						  "\";\n");
				sb.append("imgtext" + i + "=\"" +
						  StrUtil.getLeft(doc.getTitle(), titleLen) +
						  "\";\n");
				sb.append("imgLink" + i + "=\"" +
						   request.getContextPath() + "/" + showPage + "?id=" + doc.getId() +  
						  "\";\n");
				if (i>=5)
					break;
				i++;
			}
		}
	}
	else if (!siteCode.equals("")) {
		Leaf lf = new Leaf();
		lf = lf.getLeaf(siteCode);
		if (lf==null) {
			out.print("document.write('The leaf " + siteCode + " is not exist.')");
			return;
		}
		
		if (!siteCode.equals(Leaf.ROOTCODE) && lf.getType()!=Leaf.TYPE_SUB_SITE) {
			out.print("document.write('The leaf " + siteCode + " is not a site.')");
			return;
		}
		
		// 取出目录中含有图片的文章中的前五篇文章的图片
		Document doc = new Document();
        String sql = "select id from document where site_code=" + StrUtil.sqlstr(siteCode) + " and examine=" + Document.EXAMINE_PASS;
		sql += " order by createDate desc";
		
		String showPage = ParamUtil.get(request, "showPage");
		if (showPage.equals(""))
			showPage = "doc_show.jsp";
		Iterator ir = doc.list(sql, 50).iterator();
		int titleLen = ParamUtil.getInt(request, "len", 40);
		int i = 1;
		while (ir.hasNext()) {
			doc = (Document)ir.next();
			String imgPath = doc.getFirstImagePathOfDoc();
			if (!imgPath.equals("")) {
				sb.append("imgUrl" + i + "=\"" +
						  request.getContextPath() + "/" + imgPath +
						  "\";\n");
				sb.append("imgtext" + i + "=\"" +
						  StrUtil.getLeft(doc.getTitle(), titleLen) +
						  "\";\n");
				sb.append("imgLink" + i + "=\"" +
						   request.getContextPath() + "/" + showPage + "?id=" + doc.getId() +  
						  "\";\n");
				if (i>=5)
					break;
				i++;
			}
		}	
	}

	String w = ParamUtil.get(request, "w");
	if (w == "")
		w = "249";
	String h = ParamUtil.get(request, "h");
	if (h == "")
		h = "165";
	sb.append("var focus_width=" + w + "\n");
	sb.append("var focus_height=" + h + "\n");
	sb.append("var text_height=18\n");
	sb.append("var swf_height = focus_height+text_height\n");

	sb.append(
			"var pics=imgUrl1+\"|\"+imgUrl2+\"|\"+imgUrl3+\"|\"+imgUrl4+\"|\"+imgUrl5\n");
	sb.append("var links=imgLink1+\"|\"+imgLink2+\"|\"+imgLink3+\"|\"+imgLink4+\"|\"+imgLink5\n");
	sb.append("var texts=imgtext1+\"|\"+imgtext2+\"|\"+imgtext3+\"|\"+imgtext4+\"|\"+imgtext5\n");
	sb.append("document.write('<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0\" width='+ focus_width +' height='+ swf_height +'>');\n");
	sb.append("document.write('<param name=\"allowScriptAccess\" value=\"sameDomain\"><param name=\"movie\" value=\"" +
			  request.getContextPath() + "/images/home/focus.swf\"><param name=\"quality\" value=\"high\"><param name=\"bgcolor\" value=\"#dfdfdf\">');\n");
	sb.append("document.write('<param name=\"menu\" value=\"false\"><param name=wmode value=\"opaque\">');\n");
	sb.append("document.write(\"<param name='FlashVars' value='pics=\"+pics+\"&links=\"+links+\"&texts=\"+texts+\"&borderwidth=\"+focus_width+\"&borderheight=\"+focus_height+\"&textheight=\"+text_height+\"'>\");\n");
	sb.append("document.write(\"<embed src='" + request.getContextPath() + "/images/home/focus.swf' wmode='opaque' FlashVars='pics=\"+pics+\"&links=\"+links+\"&texts=\"+texts+\"&borderwidth=\"+focus_width+\"&borderheight=\"+focus_height+\"&textheight=\"+text_height+\"' menu='false' bgcolor='#dfdfdf' quality='high' width='\"+ focus_width +\"' height='\"+ focus_height +\"' allowScriptAccess='sameDomain' type='application/x-shockwave-flash' pluginspage='http://www.macromedia.com/go/getflashplayer' />\");\n");
	sb.append("document.write('</object>');\n");
	out.print(sb);
}
else if (var.equalsIgnoreCase("scrollImg")) {
	int w = ParamUtil.getInt(request, "w", 121);
	int h = ParamUtil.getInt(request, "h", 116);

	String speed = ParamUtil.get(request, "speed");
	if (speed=="")
		speed = "30";
	boolean isTitle = ParamUtil.get(request, "title").equals("y");

	StringBuffer str = new StringBuffer();
	str.append("<DIV id=demo style='OVERFLOW: hidden; WIDTH: 100%;'>");
	str.append("<TABLE cellSpacing=0 cellPadding=0 align=left border=0 cellspace='0'>");
	str.append("<TBODY>");
	str.append("<TR>");
	str.append("<TD id=demo1 vAlign=top>");
	
	String dirCode = ParamUtil.get(request, "dirCode");
	if (dirCode.equals("")) {
		// 子站点编码
		String siteCode = ParamUtil.get(request, "siteCode");
		if (siteCode.equals(""))
			siteCode = Leaf.ROOTCODE;

		SiteScrollImgDb ssid = new SiteScrollImgDb();
		Vector v = ssid.listOfSite(siteCode, SiteScrollImgDb.KIND_SCROLL);
	
		str.append("<table width='" + (v.size()*w+100) + "' height='" + h + "'  border='0' cellpadding='0' cellspacing='0'>");
		str.append("<tr>");
	
		Iterator ir = v.iterator();
		while (ir.hasNext()) {
			ssid = (SiteScrollImgDb)ir.next();
			str.append("<td width='" + w + "'>");
			str.append("<div style='margin:1px;padding:3px;border:1px #cccccc solid;text-align:center' align='center' width='" + (w+6) + "' height='" + (h+6) + "'><a target=_blank href='" + StrUtil.getNullStr(ssid.getString("link")) + "'><img border=0 width='" + w + "' height='" + h + "' alt='" + ssid.getString("title") + "' src='" + ssid.getString("url") + "'></a>");
			if (isTitle) {
				str.append("<BR>" + StrUtil.getNullStr(ssid.getString("title")));
			}
			str.append("</div>");
			str.append("</td>");
		}
		str.append("</tr></table>");
	}
	else {
		Leaf lf = new Leaf();
		lf = lf.getLeaf(dirCode);
		if (lf==null) {
			out.print("document.write('The leaf " + dirCode + " is not exist.')");
			return;
		}
		
		Leaf siteLeaf = Leaf.getSubsiteOfLeaf(dirCode);

		// 取出目录中含有图片的文章中的前五篇文章的图片
		Document doc = new Document();
        String sql = "select id from document where class1=" + StrUtil.sqlstr(dirCode) + " and examine=" + Document.EXAMINE_PASS + " order by createDate desc";
		String showPage = ParamUtil.get(request, "showPage");
		if (showPage.equals(""))
			showPage = "doc_show.jsp";
		if (siteLeaf!=null)
			showPage = "site_doc.jsp";
		DocBlockIterator dbi = doc.getDocuments(sql, dirCode, 0, 100);
		int titleLen = ParamUtil.getInt(request, "len", 10);
		int i = 0;
		int count = ParamUtil.getInt(request, "count", 10);
		// 取10幅图
		str.append("<table width='" + (count*w+100) + "' height='" + h + "'  border='0' cellpadding='0' cellspacing='0'>");
		str.append("<tr><td>");
		
		while (dbi.hasNext()) {
			doc = (Document)dbi.next();
			String imgPath = doc.getFirstImagePathOfDoc();
			if (!imgPath.equals("")) {
   				if (siteLeaf!=null)
					str.append("<div style='margin:1px;padding:3px;border:0px #cccccc solid;text-align:center;float:left;width:" + (w+6) + "px;height:" + (h+6) + "px;'><a target=_blank href='" + request.getContextPath() + "/" + showPage + "?siteCode=" + StrUtil.UrlEncode(siteLeaf.getCode()) + "&docId=" + doc.getId() + "'><img border=0 width='" + w + "' height='" + h + "' alt='" + doc.getTitle() + "' src='" + request.getContextPath() + "/" + imgPath + "'></a>");
				else
					str.append("<div style='margin:1px;padding:3px;border:0px #cccccc solid;text-align:center;float:left;width:" + (w+6) + "px;height:" + (h+6) + "px;'><a target=_blank href='" + request.getContextPath() + "/" + showPage + "?id=" + doc.getId() + "'><img border=0 width='" + w + "' height='" + h + "' alt='" + doc.getTitle() + "' src='" + request.getContextPath() + "/" + imgPath + "'></a>");
				
				if (isTitle) {
					str.append("<BR>" + StrUtil.getLeft(doc.getTitle(), titleLen));
				}
				str.append("</div>");
			}
			if (i>=count)
				break;
			i++;
		}
		
		str.append("</td></tr></table>");
	}
	
	str.append("</TD><TD id=demo2 vAlign=top>&nbsp;</TD></TR></TBODY></TABLE></DIV>");
	out.print("document.write(\"" + str + "\");\n");
	
	str = new StringBuffer();
	str.append("var speed3=" + speed + ";\n");
	str.append("demo2.innerHTML=demo1.innerHTML;\n");
	str.append("function Marquee(){\n");
	str.append("if(demo2.offsetWidth-demo.scrollLeft<=0)\n");
	str.append("demo.scrollLeft-=demo1.offsetWidth;\n");
	str.append("else{\n");
	str.append("demo.scrollLeft++;\n");
	str.append("}\n");
	str.append("}\n");
	str.append("var MyMar=setInterval(Marquee,speed3);\n");
	str.append("demo.onmouseover=function() {clearInterval(MyMar)}\n");
	str.append("demo.onmouseout=function() {MyMar=setInterval(Marquee,speed3)}\n");
	
	out.print(str);
}
else if (var.equalsIgnoreCase("switchImg")) {
	int w = ParamUtil.getInt(request, "w", 400);
	int h = ParamUtil.getInt(request, "h", 116);
	
	StringBuffer str = new StringBuffer();
	str.append("document.write(\"<div id=cwTransContainer style='FILTER: progid:DXImageTransform.Microsoft.Wipe(GradientSize=1.0,wipeStyle=0, motion=forward);width:" + w + "px;height:" + h + "px'>\")\n");

	int size = 0;
	String dirCode = ParamUtil.get(request, "dirCode");
	if (dirCode.equals("")) {
		// 子站点编码
		String siteCode = ParamUtil.get(request, "siteCode");
		if (siteCode.equals(""))
			siteCode = Leaf.ROOTCODE;
	
		SiteScrollImgDb ssid = new SiteScrollImgDb();
		Vector v = ssid.listOfSite(siteCode, SiteScrollImgDb.KIND_SWITCH);
		size = v.size();
			
		int k = 1;
		Iterator ir = v.iterator();
		while (ir.hasNext()) {
			ssid = (SiteScrollImgDb)ir.next();
			String style = "";
			if (k!=1) {
				style = "display:none";
			}
			str.append("document.write(\"<a href='" + ssid.getString("link") + "' target=_blank title='" + ssid.getString("title") + "'><img id=cwDIV" + k + " style='" + style + "' width=" + w + "px height=" + h + "px src='" + ssid.getString("url") + "' border=0></a>\")\n");
			k++;
		}
	}
	else {
		Leaf lf = new Leaf();
		lf = lf.getLeaf(dirCode);
		if (lf==null) {
			out.print("document.write('The leaf " + dirCode + " is not exist.');");
			return;
		}

		// 取出目录中含有图片的文章中的前五篇文章的图片
		Document doc = new Document();
		String sql = "select id from document where class1=" + StrUtil.sqlstr(dirCode) + " and examine=" + Document.EXAMINE_PASS + " order by createDate desc";

		DocBlockIterator dbi = doc.getDocuments(sql, dirCode, 0, 100);

		String showPage = ParamUtil.get(request, "showPage");
		if (showPage.equals(""))
			showPage = "doc_show.jsp";
		
		int count = ParamUtil.getInt(request, "row", 5);
		
		int k = 1;
		while (dbi.hasNext()) {
			doc = (Document)dbi.next();
			String style = "";
			if (k!=1) {
				style = "display:none";
			}
			String imgPath = doc.getFirstImagePathOfDoc();
			if (!imgPath.equals("")) {
				str.append("document.write(\"<a href='" + showPage + "?id=" + doc.getId() + "' target=_blank title='" + StrUtil.toHtml(doc.getTitle()) + "'><img id=cwDIV" + k + " style='" + style + "' width=" + w + "px height=" + h + "px src='" + imgPath + "' border=0></a>\")\n");
				k++;
				if (k==count+1)
					break;
			}
		}
		size = k-1;
	}
	str.append("document.write(\"</div>\")\n");
	
	str.append("var NowFrame = 1;\n");
	str.append("var MaxFrame = " + size + ";\n");
	str.append("var bStart = 0;\n");
	str.append("function cwToggle(){\n");
	str.append("	var next = NowFrame + 1;\n");
	str.append("	if(next == MaxFrame+1){\n");
	str.append("		NowFrame = MaxFrame;\n");
	str.append("		next = 1;\n");
	str.append("	}\n");
	str.append("	if(bStart == 0){\n");
	str.append("		bStart = 1;\n");
	str.append("		setTimeout('cwToggle()', 2000);\n");
	str.append("		return;\n");
	str.append("	}\n");
	str.append("	else{\n");
	str.append("		if (isIE())\n");
	str.append("			cwTransContainer.filters[0].Apply();\n");
	str.append("		$('cwDIV'+next).style.display = \"\";\n");
	str.append("		$('cwDIV'+NowFrame).style.display = \"none\";\n");
	str.append("		if (isIE())\n");
	str.append("			cwTransContainer.filters[0].Play(duration=2);\n");
	str.append("		if(NowFrame == MaxFrame){\n");
	str.append("			NowFrame = 1;\n");
	str.append("		}else{\n");
	str.append("			NowFrame++;\n");
	str.append("		}\n");
	str.append("	}\n");
	str.append("	setTimeout('cwToggle()', 6000);\n");
	str.append("}\n");
	str.append("cwToggle();\n");
	out.print(str);
}
else if (var.equalsIgnoreCase("homeAd")) {
	int id = ParamUtil.getInt(request, "id", -1);
	if (id == -1)
		out.print("document.write(\"The id of Ad is invalid.\")");
	SiteAdDb sad = new SiteAdDb();
	sad = (SiteAdDb) sad.getQObjectDb(new Integer(id));
	if (sad == null) {
		out.print("document.write(\"Ad is null where id=" + id + "\")");
	}
	out.print("document.write('" + sad.getString("content") + "')");
}
else if (var.equalsIgnoreCase("ad")) {
	String dirCode = ParamUtil.get(request, "dirCode");
	String type = ParamUtil.get(request, "type");
	AdRender ad = new AdRender(dirCode, type);
	String str = ad.render(request);
	out.print("document.write(\"" + str + "\")");
}
else if (var.equalsIgnoreCase("dir")) {
	// 列出目录
	String dirCode = ParamUtil.get(request, "dirCode");
	int row = ParamUtil.getInt(request, "row", 10);
	LeafChildrenCacheMgr childcm = new LeafChildrenCacheMgr(dirCode);
	java.util.Vector vchild = childcm.getDirList();
	Iterator irchild = vchild.iterator();
	out.print("document.write('<ul>');");
	int count = 0;
	while (irchild.hasNext()) {
		Leaf childlf = (Leaf) irchild.next();
		if (!childlf.getIsHome())
			continue;
		if (childlf.getType()==Leaf.TYPE_LIST) {
			String view = ParamUtil.get(request, "listView");
			if (view.equals(""))
				view = "doc_list";
			out.print("document.write('<li><a href=\"" + view + ".jsp?dirCode=" + StrUtil.UrlEncode(childlf.getCode()) + "\">" + StrUtil.toHtml(childlf.getName()) + "</a></li>');");
		}else if (childlf.getType()==Leaf.TYPE_DOCUMENT) {
			String view = ParamUtil.get(request, "docView");
			if (view.equals(""))
				view = "doc_show";
			out.print("document.write('<li><a href=\"" + view + ".jsp?dirCode=" + StrUtil.UrlEncode(childlf.getCode()) + "\">" + StrUtil.toHtml(childlf.getName()) + "</a></li>');");
		}
		count++;
		if (count>=row)
			break;
	}
	out.print("document.write('</ul>');");	
}
else if (var.equalsIgnoreCase("recommand")) {
	Home home = Home.getInstance();
	cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.
									  Config();
	boolean isHtml = cfg.getBooleanProperty("cms.html_doc");

	Document doc = new Document();
	int count = ParamUtil.getInt(request, "row", 10);

	boolean isDateShow = false;
	String dateFormat = "";
	String dt = ParamUtil.get(request, "date");
	if (dt != null) {
		isDateShow = dt.equals("true") || dt.equals("yes") || dt.equals("y");
		dateFormat = ParamUtil.get(request, "dateFormat");
		if (dateFormat == null) {
			dateFormat = "yy-MM-dd";
		}
	}

	boolean isDirNameShow = false;
	String dirNameShow = ParamUtil.get(request, "dirname");
	if (dirNameShow != null) {
		isDirNameShow = dirNameShow.equals("true") ||
						dirNameShow.equals("yes") || dirNameShow.equals("y");
	}

	String url = "";

	String rootPath = Global.getRootPath();
	if (request != null) {
		rootPath = request.getContextPath();
	}

	String target = ParamUtil.get(request, "target");
	if (!target.equals("")) {
		target = "target=\"" + target + "\"";
	}
	
	int titleLen = ParamUtil.getInt(request, "len", -1);

	int[] ids = home.getRecommandIds();
	StringBuffer str = new StringBuffer();
	Directory dir = new Directory();
	Leaf lf = null;
	out.print("document.write(\"<ul>\");");
	int len = ids.length;
	DocumentMgr dm = new DocumentMgr();
	
	for (int i = 0; i < len; i++) {
		doc = dm.getDocument(ids[i]);
		if (doc.getType() == Document.TYPE_LINK) {
			url = doc.getSource();
		} else {
			if (!isHtml) {
				url = "doc_view.jsp?id=" + doc.getId();
			} else {
				url = doc.getDocHtmlName(1);
			}
		}

		out.print("document.write(\"<li>\");");
		if (isDateShow) {
			out.print("document.write(\"<span style='float:right'>" +
					   DateUtil.format(doc.getModifiedDate(),
									   dateFormat) + "</span>&nbsp;\");");
		}

		if (isDirNameShow) {
			lf = dir.getLeaf(doc.getDirCode());
			String dirName = "";
			if (lf != null) {
				dirName = lf.getName();
			}
			out.print("document.write(\"<span class='dirName'>[<a href='\");");

			if (isHtml) {
				if (lf.getType() == Leaf.TYPE_DOCUMENT) {
					if (Global.virtualPath.equals("")) {
						out.print("document.write(\"/" +
								   doc.getDocHtmlName(1)+"\");");
					} else {
						out.print("document.write(\"/" + Global.virtualPath +
								   "/" + doc.getDocHtmlName(1)+"\");");
					}
				} else {
					if (Global.virtualPath.equals("")) {
						out.print("document.write(\"/" +
								   lf.
								   getListHtmlNameByPageNum(request,
								1)+"\");");
					} else {
						out.print("document.write(\"/" + Global.virtualPath +
								   "/" +
								   lf.
								   getListHtmlNameByPageNum(request,
								1)+"\");");
					}
				}
			} else {
				if (lf.getType() == Leaf.TYPE_DOCUMENT) {
					out.print("document.write(\"" + request.getContextPath() +
							   "/doc_view.jsp?dirCode=" +
							   StrUtil.UrlEncode(lf.getCode()) + "\");");
				} else {
					out.print("document.write(\"" + request.getContextPath() +
							   "/doc_list_view.jsp?dirCode=" +
							   StrUtil.UrlEncode(lf.getCode()) + "\");");
				}
			}

			out.print("document.write(\"'>" + dirName + "</a>]</span>\");");
		}

		out.print("document.write(\"<a title='" + StrUtil.toHtml(doc.getTitle()) +
				   "' href='" + url + "' " + target + " >\");");
		int cr = DateUtil.compare(new java.util.Date(),
				doc.getExpireDate());
        boolean isDateValid = cr == 2 || cr==-1;				   
		if (isDateValid && doc.isBold()) {
			out.print("document.write(\"<B>\");");
		}
		if (isDateValid && !doc.getColor().equals("")) {
			out.print("document.write(\"<font color='" + doc.getColor() + "'>\");");
		}
		out.print("document.write(\"" + ((titleLen>0)?StrUtil.getLeft(doc.getTitle(), titleLen):doc.getTitle()) + "\");");
		if (isDateValid && !doc.getColor().equals("")) {
			out.print("document.write(\"</font>\");");
		}
		if (isDateValid && doc.isBold()) {
			out.print("document.write(\"</B>\");");
		}

		str.append("</a>");

		if (isDateValid && doc.getIsNew() == 1) {
			out.print("document.write(\"&nbsp;<img border=0 src='" + rootPath +
					   "/images/i_new.gif'>\");");
		}

		out.print("document.write(\"</li>\");");
		if (i>=count-1)
			break;
	}
	out.print("document.write(\"</ul>\");");	
}
else if (var.equalsIgnoreCase("stat")) {
	// 文章统计
	String type = ParamUtil.get(request, "type");
	Statistic st = new Statistic();
	String str = "";
	if (type.equals("all")) {
		str = "" + st.getAllDocCount();
	}
	else if (type.equals("year")) { // 当年
		str = "" + st.getCounts(new java.util.Date())[0];
	}
	else if (type.equals("month")) { // 当月
		str = "" + st.getCounts(new java.util.Date())[1];
	}
	else if (type.equals("day")) { // 当天
		str = "" + st.getCounts(new java.util.Date())[2];
	}
	else if (type.equals("yestoday")) { // 昨天
		str = "" + st.getCounts(new java.util.Date())[3];
	}
	else if (type.equals("beforeyestoday")) { // 前天
		str = "" + st.getCounts(new java.util.Date())[4];
	}
	else if (type.equals("allonline")) { // 全部在线
		OnlineUserDb oud = new OnlineUserDb();
		str = "" + oud.getAllCount();
	}
	else if (type.equals("memberonline")) { // 会员在线
		OnlineUserDb oud = new OnlineUserDb();
		str = "" + oud.getAllUserCount();            
	}	
	else
		str = type + " is not found";
	out.print("document.write(\"" + str + "\")");
}
else if (var.equalsIgnoreCase("rank")) {
	// 排行
	String type = ParamUtil.get(request, "type");
	int row = ParamUtil.getInt(request, "row", 10);
	CMSTemplateImpl cmti = new CMSTemplateImpl();
	String str = cmti.doRenderRank(request, type, row);
	out.print("document.write(\"" + str + "\")");
}
else if (var.equals("doc")) {
	Document doc = new Document();
	// 取出目录中的第一篇文章
	String dirCode = ParamUtil.get(request, "dir");
	if (!dirCode.equals("")) {
		// 取得目录中的最新文章
		DocBlockIterator dbir = doc.getDocuments(SQLBuilder.getDirDocListSql(dirCode), dirCode, 0, 1);
		if (dbir.hasNext()) {
			doc = (Document)dbir.next();
		}
	}
	else {
		// 取出给定id的文章
		int id = ParamUtil.getInt(request, "id");
		doc = doc.getDocument(id);
	}
	if (!doc.isLoaded()) {%>
		document.write("Document's id is not exist");
	<%}else{
		// 显示图片
		String picw = ParamUtil.get(request, "picw");
		String pich = ParamUtil.get(request, "pich");
		if (picw.equals(""))
			picw = "150";
		if (pich.equals(""))
			pich = "150";
		int w = StrUtil.toInt(picw, -1);
		if (w!=-1) {
			w += 5; // DIV比图片宽5个像素
			picw = "" + w;
		}

		boolean isShowTitle = ParamUtil.get(request, "isShowTitle").equals("y");
		boolean isShowContent = ParamUtil.get(request, "isShowContent").equals("y");
		String pos = ParamUtil.get(request, "pos");
		if (isShowTitle || isShowContent) {
			if (pos.equals(""))
				pos = "bottom";
		}

		String target = ParamUtil.get(request, "target");

		cn.js.fan.module.cms.Config cfg = new cn.js.fan.module.cms.Config();
		boolean isHtml = cfg.getBooleanProperty("cms.html_doc");
		String docUrl = "";
		if (isHtml) {
			if (Global.virtualPath.equals("")) {
				docUrl = request.getContextPath() + "/" + doc.getDocHtmlName(1);
			} else {
				docUrl = request.getContextPath() +
						   "/" + doc.getDocHtmlName(1);
			}
		} else {
			docUrl = request.getContextPath() +
					   "/doc_view.jsp?id=" +
					   doc.getId();
		}
	
		String title = doc.getTitle();
		int titleLen = ParamUtil.getInt(request, "titleLen", -1);	
		if (titleLen>0)
			title = StrUtil.getLeft(title, titleLen);
		String tlink = "<a target='" + target + "' href='" + docUrl + "'>" + title + "</a>";

		String content = doc.getContent(1);
		int contentLen = ParamUtil.getInt(request, "contentLen", -1);
		if (contentLen>0)
			content = StrUtil.getLeft(content, contentLen);
		String clink = "<a target='" + target + "' href='" + docUrl + "'>" + StrUtil.toHtml(content) + "</a>";
		
		out.println("document.write(\"<div style='width:" + picw + "px;height:" + pich + "px'>\");");

		if (isShowTitle) {
			if (pos.equals("top"))
				out.println("document.write(\"" + tlink + "<BR>\");");
			else if (pos.equals("left"))
				out.println("document.write(\"'" + tlink + "\");");
		}
		else if (isShowContent) {
			if (pos.equals("top"))
				out.println("document.write(\"" + clink + "<BR>\");");
			else if (pos.equals("left"));
				out.println("document.write(\"" + clink + "\");");
		}
		String wh = "";
		if (!picw.equals(""))
			wh += "width='" + picw + "'";
		if (!pich.equals(""))
			wh += " height='" + pich + "'";
		String imgPath  = doc.getFirstImagePathOfDoc();
		if (!imgPath.equals(""))
			out.println("document.write(\"<a target='" + target + "' href='" + docUrl + "'><img border=0 src='" + request.getContextPath() + "/" + imgPath + "' " + wh + "></a>\");");
		if (isShowTitle) {
			if (pos.equals("bottom"))
				out.println("document.write(\"<div>" + tlink + "</div>\");");
			else if (pos.equals("right"))
				out.println("document.write(\"" + tlink + "\");");
		}
		else if (isShowContent) {
			if (pos.equals("bottom"))
				out.println("document.write(\"<div>" + clink + "</div>\");");
			else if (pos.equals("right"));
				out.println("document.write(\"'" + clink + "\");");
		}
		out.println("document.write('</div>');");
	}%>
<%}%>