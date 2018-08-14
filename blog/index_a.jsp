<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.redmoon.blog.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.cloudwebsoft.framework.web.*"%>
<%@ page import="cn.js.fan.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>博客 - 云网论坛 - Powered by CWBBS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="template/css.css" type="text/css" rel="stylesheet" />
<script>
function formSearch_onSubmit() {
	if (formSearch.searchType.value=="msgAuthor" || formSearch.searchType.value=="msgBlogUser") {
		formSearch.action="listbloguser.jsp";
	}
}
</script>
</head>
<body>
<div class="content">
    <div class="top">
		<div class="top_logo"><img src="template/images/logo.gif" / ></div>
		<div class="Top_nav">
			<ul>
				<li><a href="index.jsp"><div class="linkStyle">首页</div></a></li>
				<li><a href="../forum/index.jsp"><div class="linkStyle">社区</div></a></li>
				<li><a href="../forum/plugin/group/group_list.jsp"><div class="linkStyle">圈子</div></a></li>
				<li><a href="listblogphoto.jsp"><div class="linkStyle">相册</div></a></li>
				<li><a href="listblog.jsp"><div class="linkStyle">博客</div></a></li>
				<li><a href="listmsg.jsp"><div class="linkStyle">日志</div></a></li>
			</ul>
		</div>
		<div class="top_right"><img src="template/images/image_03.png" />&nbsp;&nbsp;&nbsp;&nbsp;<a href=# onClick="this.style.behavior='url(#default#homepage)';this.setHomePage('http://localhost:8080/cwbbs/blog');">设为首页</a>&nbsp;&nbsp;&nbsp;&nbsp;<a target=_top href=javascript:window.external.AddFavorite('http://localhost:8080/cwbbs/blog','云网博客')>加入收藏</a></div>
		<div class="top_search">
		<form name="formSearch" method="post" action="listmsg.jsp" style="margin:0px; padding:0px;" onSubmit="return formSearch_onSubmit()">
			<div><img src="template/images/magnifier.gif" /></div>
			<div style="margin-top:8px;">
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		        <select id="searchType" name="searchType">
                <option value="msgTitle" selected="selected">标题</option>
                <option value="msgContent">内容</option>
				<option value="userNick">搜索博主</option>							
                </select>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input name="keyword" />
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			</div>
			<div style="margin-top:8px;"><input type="image" src="/cwbbs/blog/template/images/search_all_site.gif" /></div>
		</form>
	  	</div>
	</div>
	<div class="middle">
        <div class="middleAd"><img src="template/images/middleAd.png" /></div>
		<div class="middleMain">
			<div class="middleMain_outsideBox_styleOne">
				<div class="middleMain_insideBox_imgContainer_styleOne"><script src="js.jsp?var=flashImage"></script></div>
			 	<div class="middleMain_insideBox_content_styleOne"><script src="js.jsp?var=focus"></script></div>
			</div>
			<div class="middleMain_outsideBox_styleTwo">
				<div class="middleMain_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_boke.png)"><div class="more"><a href="#">更多</a></div></div>
				<div class="middleMain_insideBox_styleLeft">
					<div class="middleMain_insideBox_top_styleOne"><img src="template/images/top_newBlog.png" /></div>
					<div class="middleMain_insideBox_imgContainer_styleTwo"><img src="template/images/top_newBlog_img.png" /></div>
					<div class="middleMain_insideBox_content_styleTwo"><script src="js.jsp?var=newupdateblog"></script></div>
				</div>
				<div class="middleMain_insideBox_styleLine"></div>
				<div class="middleMain_insideBox_styleRight">
					<div class="middleMain_insideBox_top_styleOne"><img src="template/images/top_newReg.png" /></div>
					<div class="middleMain_insideBox_imgContainer_styleTwo"><img src="template/images/top_newReg_img.png" /></div>
					<div class="middleMain_insideBox_content_styleTwo"><script src="js.jsp?var=newblog"></script></div>
				</div>
			</div>
			<div class="middleMain_outsideBox_styleTwo">
				<div class="middleMain_outsideBox_top_styleOne"><img src="template/images/top_bowen.png" /></div>
				<div class="middleMain_insideBox_styleLeft">
					<div class="middleMain_insideBox_top_styleOne"><img src="template/images/top_newArticle.png" /></div>
					<div class="middleMain_insideBox_content_styleThree"><script src="js.jsp?var=listVideo&order=add_date&len=1"></script></div>
				</div>
				<div class="middleMain_insideBox_styleLine"></div>
				<div class="middleMain_insideBox_styleRight">
					<div class="middleMain_insideBox_top_styleOne"><img src="template/images/top_replyRank.png" /></div>
					<div class="middleMain_insideBox_content_styleThree"><script src="js.jsp?var=replyrank"></script></div>
				</div>
			</div>
			<div class="middleMain_ad"><img src="template/images/middle_main_ad.png" /></div>
			<div class="middleMain_outsideBox_styleTwo">
				<div class="middleMain_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_rizhi.png)"><div class="more"><a href="listblog.jsp">更多</a></div></div>
				<div class="middleMain_insideBox_top_styleTwo"><img src="template/images/middleMain_insideBox_top_styleTwo_bg_01.png" /></div>
				<div class="middleMain_insideBox_styleLeftTwo"><script src="js.jsp?var=recommandblog&start=0&end=5"></script></div>
				<div class="middleMain_insideBox_styleLineTwo"></div>
				<div class="middleMain_insideBox_styleRightTwo"><script src="js.jsp?var=recommandblog&start=6&end=10"></script></div>
			</div>
			<div class="middleMain_outsideBox_styleTwo">
				<div class="middleMain_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_xiangce.png)"><div class="more"><a href="listblogphoto.jsp">更多</a></div></div>
              <div class="middleMain_insideBox_content_styleFour">
			  <script src="js.jsp?var=listPhoto"></script>
			  </div>	
			</div>		
			<div class="middleMain_outsideBox_styleTwo">
				<div class="middleMain_outsideBox_top_styleOne"><img src="template/images/top_youqinglianjie.png" /></div>
				<div class="middleMain_insideBox_top_styleTwo"><img src="template/images/middleMain_insideBox_top_styleTwo_bg_02.png" /></div>
                <div class="middleMain_insideBox_content_styleFive">
					<div class="middleMain_insideBox_imgContainer_styleThree"><img src="template/images/image_02.png"/ ></div>
					<div class="middleMain_insideBox_content_styleSix">
					  <%
	com.redmoon.blog.LeafChildrenCacheMgr dlcm = new com.redmoon.blog.LeafChildrenCacheMgr("root");
	java.util.Vector vt = dlcm.getDirList();
	Iterator irv = vt.iterator();
	while (irv.hasNext()) {
		Leaf leaf = (Leaf) irv.next();
		String parentCode = leaf.getCode();
	%>
        <li><a href="listblog.jsp?kind=<%=leaf.getCode()%>"><b><%=leaf.getName()%></b></a>
		<%
		dlcm = new com.redmoon.blog.LeafChildrenCacheMgr(leaf.getCode());
		Iterator ir2 = dlcm.getDirList().iterator();
		while (ir2.hasNext()) {
			Leaf lf = (Leaf)ir2.next();
			%>
			<a href="listmsg.jsp?dirCode=<%%>"><%=lf.getName()%></a>&nbsp;
		<%}%>
		</li>
	<%}%>
                    </div>
				</div>
			</div>
		</div>
		<div class="middleSideBar">
			<div class="middleSideBar_outsideBox_styleOne"><iframe width="260" height="232" hspace=0 vspace=0 frameborder=0 marginwidth="0" marginheight="0" scrolling="no" src="iframe_login.jsp"></iframe></div>
			<div class="middleSideBar_outsideBox_styleTwo"><script src="js.jsp?var=notice"></script></div>
			<div class="middleSideBar_outsideBox_styleThree">
				<div class="middleSideBar_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_boyou.png)"></div>
				<div class="boyou_content">
				<form action="../listmember.jsp" method="post">
					<ul>
						<li>行业：
						  <select name=career size=1>
                            <option value="" selected>请选...</option>
                            <option value="政府机关/干部">政府机关/干部</option>
                            <option value="学生">学生</option>
                            <option value="邮电通信">邮电通信</option>
                            <option value="计算机">计算机</option>
                            <option value="互联网">互联网</option>
                            <option value="商业/贸易">商业/贸易</option>
                            <option value="银行/金融/证券/保险/投资">银行/金融/证券/保险</option>
                            <option value="税务">税务</option>
                            <option value="咨询">咨询</option>
                            <option value="社会服务">社会服务</option>
                            <option value="旅游/饭店">旅游/饭店</option>
                            <option value="健康/医疗服务">健康/医疗服务</option>
                            <option value="房地产">房地产</option>
                            <option value="交通运输">交通运输</option>
                            <option value="法律/司法">法律/司法</option>
                            <option value="文化/娱乐/体育">文化/娱乐/体育</option>
                            <option value="媒介/广告">媒介/广告</option>
                            <option value="科研/教育">科研/教育</option>
                            <option value="农业">农业</option>
                            <option value="矿业/制造业">矿业/制造业</option>
                            <option value="自由职业">自由职业</option>
                            <option value="其它">其它</option>
                          </select>
						  <input name="op" value="search" type="hidden">
						</li>
						<li>年龄范围：<select name="ageBegin">
						<option value="-1">无</option>
						<option value="15">15</option>
						<option value="20">20</option>
						<option value="25" selected>25</option>
						<option value="30">30</option>
						<option value="35">35</option>
						<option value="40">40</option>
						<option value="45">45</option>
						<option value="50">50</option>
						<option value="55">55</option>
						<option value="60">60</option>
						<option value="65">65</option>
						<option value="70">70</option>
						</select>
						  至
						<select name="ageEnd">
						<option value="-1">无</option>
						<option value="15">15</option>
						<option value="20">20</option>
						<option value="25">25</option>
						<option value="30" selected>30</option>
						<option value="35">35</option>
						<option value="40">40</option>
						<option value="45">45</option>
						<option value="50">50</option>
						<option value="55">55</option>
						<option value="60">60</option>
						<option value="65">65</option>
						<option value="70">70</option>
                        </select>
						</li>
						<li>性别：<input type="radio" name="gender" value="M">男<input type="radio" name="gender" value="F" checked>女<input type="radio" name="gender" value="">不限</li>
						<li><input type="image" style="margin-left:50px" src="/cwbbs/blog/template/images/search_button.png" /></li>
					</ul>
				</form>
				</div>
		  </div>
			<div class="middleSideBar_outsideBox_styleThree">
				<div class="middleSideBar_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_boxing.png)"><div class="more_side"><a href="#">更多</a></div></div>
				<div class="middleSideBar_outsideBox_content_styleOne"><script src="js.jsp?var=renderstar"></script></div>
			</div>
			<div class="middleSideBar_outsideBox_styleThree">
				<div class="middleSideBar_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_quanzi.png)"><div class="more_side"><a href="#">更多</a></div></div>
				<div class="middleSideBar_outsideBox_content_styleOne"><script src="js.jsp?var=listgroup"></script></div>
			</div>
			<div class="middleSideBar_outsideBox_styleThree">
				<div class="middleSideBar_outsideBox_top_styleOne" style="background-image:url(/cwbbs/blog/template/images/top_bokemoban.png)"><div class="more_side"><a href="#">更多</a></div></div>
			    <div class="middleSideBar_outsideBox_content_styleOne"><script src="js.jsp?var=postrank"></script></div>
			</div>
	</div>
	</div>
	<div class="bottom"></div>
</div>
</body>
</html>