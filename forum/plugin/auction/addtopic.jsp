<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.Privilege"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.score.*"%>
<script src="<%=request.getContextPath()%>/inc/common.js"></script>
<script src="<%=request.getContextPath()%>/forum/plugin/auction/script.js"></script>
<%
        ScoreMgr sm = new ScoreMgr();
        Vector v = sm.getAllScore();
        Iterator ir = v.iterator();
        String str = "";
        String strOption = "<select name=moneyCode>";
        while (ir.hasNext()) {
            ScoreUnit su = (ScoreUnit) ir.next();
            if (su.isExchange()) {
                str += "<input name=moneyType type=checkbox value='" + su.getCode() + "'>" + AuctionSkin.LoadString(request, "use") + su.getName() +"&nbsp";
                str += AuctionSkin.LoadString(request, "price") + "&nbsp;<input name='price_" + su.getCode() + "' size=2>&nbsp;";
                String checked = "";
                if (su.getCode().equals("rmb"))
                    checked = "selected";
                strOption += "<option value='" + su.getCode() + "' " + checked + ">" + su.getName() + "</option>";
            }
        }
        strOption += "</select>";
		
        AuctionConfig ac = new AuctionConfig();
        int expireDayMax = ac.getIntProperty(ac.ExpireDayMax);
		
        Privilege privilege = new Privilege();
        String userName = privilege.getUser(request);
        AuctionShopDb as = new AuctionShopDb();
        as = as.getAuctionShopDb(userName);
		String auctionDir = "";
        // 如果用户已建立商店
        if (as.isLoaded()) {
            auctionDir = AuctionSkin.LoadString(request, "FORM_MYSHOP_DIR");
            AuctionShopDirDb asd = new AuctionShopDirDb();
            auctionDir = auctionDir.replaceFirst("\\$options", asd.toOptions(userName));
        }
		
            Directory dir = new Directory();
            Leaf lf = dir.getLeaf("root");
            DirectoryView dv = new DirectoryView(lf);
            StringBuffer sb = new StringBuffer();
            try {
                dv.ShowDirectoryAsOptionsToString(sb, lf, lf.getLayer());
            }
            catch (Exception e) {
            }
%>
<TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1>
<TBODY>
      <TR>
        <TD width="18%" align="left">出售方式：</TD>
        <TD height=23 align="left"><input type=radio name=sellType value=0 checked onclick="if (this.checked) { $('div_auction').style.display=''; $('div_sell').style.display='none';}">拍卖 <input type=radio name=sellType value=1  onclick="if (this.checked) { $('div_auction').style.display='none'; $('div_sell').style.display='';}">一口价</TD>
      </TR>
      <TR>
        <TD align="left">商品名称：</TD>
        <TD height=23 align="left"><input name="name" size=8 /></TD>
      </TR>
      <TR>
        <TD align="left">数量：</TD>
        <TD height=23 align="left"><input name=count size=1 value=1 /></TD>
      </TR>
      <TR>
        <TD height="23" colspan="2" align="left"><span id=div_auction name=div_auction>底价：
            <input name=price size=2 value=1.0 />
最小加价：
<input name=dlt size=2 value=10.0 />
参考价：
<input name=referPrice size=2 value=0.0 />
使用币种：<%=strOption%> <br />
起拍日期：
<input name=beginDate size=10 readonly />
<img src="<%=request.getContextPath()%>/forum/plugin/auction/skin/default/images/calendar.gif" align=absMiddle style="cursor:hand" onclick="SelectDate('beginDate','yyyy-mm-dd')" />&nbsp;截止日期：
<input name=endDate size=10 readonly />
<img src="<%=request.getContextPath()%>/forum/plugin/auction/skin/default/images/calendar.gif" align=absMiddle style="cursor:hand" onclick="SelectDate('endDate','yyyy-mm-dd')" />&nbsp;（注意：拍卖最长不超过<%=expireDayMax%>天）</span>
<span id=div_sell name=div_sell style="display:none"><%=str%>&nbsp;&nbsp;<input name=isShow type=checkbox value=true>仅供展示</span>
<%=auctionDir%><br />
<%if (!as.isLoaded()) {%>
商品目录：<select name="catalogCode" onchange="if(this.options[this.selectedIndex].value=='not'){alert(this.options[this.selectedIndex].text+' 不能被选择！'); this.value='not'; return false;}">
  <%=sb.toString()%>
</select>
<%}%>
</TD>
      </TR>
  </TBODY>
</TABLE>
