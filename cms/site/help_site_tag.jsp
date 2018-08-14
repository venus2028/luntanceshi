<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/tlds/LabelTag.tld" prefix="lt" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>子站点模板标签说明</title>
<link href="../default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
<!--
body {
	margin-top: 0px;
	margin-left: 0px;
	margin-right: 0px;
}
-->
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<table cellSpacing="0" cellPadding="0" width="100%">
  <tbody>
    <tr>
      <td class="head">模板说明</td>
    </tr>
  </tbody>
</table>
<br>
<table style="BORDER-RIGHT: #a6a398 1px solid; BORDER-TOP: #a6a398 1px solid; BORDER-LEFT: #a6a398 1px solid; BORDER-BOTTOM: #a6a398 1px solid" cellSpacing="0" cellPadding="3" width="95%" align="center">
  <tbody>
  <form name="form1" action="?op=editTemplate" method="post">
    <tr>
      <td colspan="2" align="center" noWrap class="thead" style="PADDING-LEFT: 10px">标签说明</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" colspan="2" style="PADDING-LEFT: 10px">&nbsp;&nbsp;&nbsp;&nbsp;模板由主模板、副模板（首页）、副模板（列表页）、副模板（文章页）组成。主模板由网站的头部(header)和底部(footer)组成，子站点的每个显示页面，由主模板 + 某个副模板 组合而成，如当显示首页的时候，由主模板 + 副模板（首页）组合，组合时，用副模板替换掉主模板中的{$site.man}标签。 图例如下： <br>
      &nbsp;&nbsp;&nbsp;&nbsp;
      <table width="83%" border="1" align="center">
        <tr>
          <td align="center" bgcolor="#EFEBDE">header(头部)</td>
        </tr>
        <tr>
          <td align="center">{$site.main}</td>
        </tr>
        <tr>
          <td align="center" bgcolor="#EFEBDE">footer(底部)</td>
        </tr>
      </table>
      <br>
      <div align=center style="padding-top:5px">图：主模板</div><br>
      <table width="83%" border="1" align="center">
        <tr>
          <td height="37" align="center" bgcolor="#66CC99">首页内容</td>
        </tr>
      </table>
      <br>
      <div align=center style="padding-top:5px">图：副模板-首页</div>
      <br>
      <table width="83%" border="1" align="center">
        <tr>
          <td align="center" bgcolor="#EFEBDE">header(头部)</td>
        </tr>
        <tr>
          <td height="37" align="center" bgcolor="#63CF9C">首页内容</td>
        </tr>
        <tr>
          <td align="center" bgcolor="#EFEBDE">footer(底部)</td>
        </tr>
      </table>
      <br>
      <div align=center style="padding-top:5px">图：子站点首页由主模板 + 副模板（首页）组成 </div></td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px"><strong>标签语法：</strong></td>
      <td style="PADDING-LEFT: 10px">&nbsp;</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td width="13%" height="22" style="PADDING-LEFT: 10px">{$site.name}</td>
      <td width="87%" style="PADDING-LEFT: 10px"> 站点名称</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.nav}</td>
      <td style="PADDING-LEFT: 10px">导航条</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.main}</td>
      <td style="PADDING-LEFT: 10px">主显示区域，用以替换三种副模板</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.dirName(dir=$site_news,link=y)}</td>
      <td style="PADDING-LEFT: 10px">显示目录名称，如果link=y则可以链接至目录编码为$site_news的列表页面，注意$site_在模板解析时将被网站的编码替代，如：网站编码为mysite，则$site_news将被替换为mysite_news，dir也可以不用$site_前缀，如：直接用news，表示提取编码为news的目录名称，有关$site的用法下同。</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.more(dir=$site_news)}</td>
      <td style="PADDING-LEFT: 10px">用于超链接中链接至目录编码为$site_news的列表页面</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.dirLogo(dir=$site_news_img)}</td>
      <td style="PADDING-LEFT: 10px">显示目录$site_news_img的Logo图片，如果目录编码为$site开头，则将用子站点的域名自动替换$site</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.link}</td>
      <td style="PADDING-LEFT: 10px">友情链接</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.subsite}</td>
      <td style="PADDING-LEFT: 10px">挂在本站点下面的子站点</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.listDoc(dir=$site_news,row=10,len=30,date=y,page=true)}</td>
      <td style="PADDING-LEFT: 10px">显示目录为site_news的文章列表，row=10表示每页显示10行记录，len=30表示文章标题显示30个字，date=y表示显示时间，也可以用date=yyy-mm-dd来指定时间的显示格式，也可以不用row，而用start、end来表示取从start至end的文章，page=true表示显示页码</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.listImg(dir=sdz_news_img,row=10,w=50,h=50,small=y)}</td>
      <td style="PADDING-LEFT: 10px">显示图片型文章的列表，显示10个图片，图片的宽度为50，高度为50，small=y表示显示缩略图，small=n表示显示第一幅图片，默认为显示缩略图</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.curPos}</td>
      <td style="PADDING-LEFT: 10px">显示当前页面在站点中所处的位置导航</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docTitle}</td>
      <td style="PADDING-LEFT: 10px">显示文章的标题</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docAbstract(dir=$site_intro,link=y,docId=200)}</td>
      <td style="PADDING-LEFT: 10px">无dir参数时，显示文章的摘要，如果有dir参数，且dir为文章型节点，则显示该文章的摘要，如果link=y则可以链接至其文章显示页面，如果有id参数，则显示编号为200的文章摘要。如果dir与id参数都存在，则优先取dir参数。</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docAuthor}</td>
      <td style="PADDING-LEFT: 10px">显示文章的作者</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docSource}</td>
      <td style="PADDING-LEFT: 10px">显示文章的来源</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docDate(format=yyyy-MM-dd)}</td>
      <td style="PADDING-LEFT: 10px">显示文章的发表时间，显示的格式format默认为显示 年-月-日 小时：分钟：秒，示例中显示 年-月-日 </td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docHit}</td>
      <td style="PADDING-LEFT: 10px">显示文章的点击数</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docContent}<BR></td>
      <td style="PADDING-LEFT: 10px">显示文章的内容</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docRelate}</td>
      <td style="PADDING-LEFT: 10px">显示文章的相关文章</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.docPostComment}</td>
      <td style="PADDING-LEFT: 10px">显示“发表评论”链接</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.ad(id=1)}</td>
      <td style="PADDING-LEFT: 10px">显示编号为1的广告内容</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.flashImage(id=1,w=200,h=150)}</td>
      <td style="PADDING-LEFT: 10px">显示编号为1的Flash图片广告，flash的高度为200，宽度为150，如果不设，则宽度默认为260，高度默认为215</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.listDir(dir=news)}</td>
      <td style="PADDING-LEFT: 10px">显示目录编码为news的子目录，如果不设dirCode，则显示站点下面的全部可显示首页的目录</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.subsite}</td>
      <td style="PADDING-LEFT: 10px">显示子站点</td>
    </tr>
    <tr class="row" style="BACKGROUND-COLOR: #ffffff">
      <td height="22" style="PADDING-LEFT: 10px">{$site.scrollImg(w=121,h=116,speed=30,title=y,len=30,row=10)}</td>
      <td style="PADDING-LEFT: 10px">显示滚动图片，speed表示滚动的速度，w和h分别为每个图片的宽度和高度，title=y表示显示图片的标题，len=30表示标题的长度不超过30个字，row=10表示取10行</td>
    </tr>
  </form>
</table>
</body>
</html>