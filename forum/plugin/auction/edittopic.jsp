<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.db.*"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.ui.*"%>
<%@ page import="com.redmoon.forum.MsgDb"%>
<%@ page import="com.redmoon.forum.Privilege"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.setup.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.auction.*"%>
<%@ page import="com.redmoon.forum.plugin.score.*"%>
<script src="<%=request.getContextPath()%>/inc/common.js"></script>
<script src="<%=request.getContextPath()%>/forum/plugin/auction/script.js"></script>
<%
		long msgId = ParamUtil.getLong(request, "editid");
        MsgDb md = new MsgDb();
        md = md.getMsgDb(msgId);
        // 如果该贴不是根贴，则写secretLevel修改的表单，根贴默认为公共可见，不可更改
        if (!md.isRootMsg()) {
			return;
		}
        AuctionDb ad = new AuctionDb();
        ad = ad.getAuctionDb(msgId);
					
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
<TABLE width="100%" border=0 align=center cellPadding=2 cellSpacing=1 bgcolor="#CCCCCC">
<TBODY>
      <TR>
        <TD width="20%" align="left" bgcolor="#F9FAF3">商品名称：</TD>
        <TD height=23 align="left" bgcolor="#F9FAF3"><input name="name" size=8 value="<%=ad.getName()%>"/></TD>
      </TR>
      <TR>
        <TD align="left" bgcolor="#F9FAF3">数量：</TD>
        <TD height=23 align="left" bgcolor="#F9FAF3"><input name=count size=1 value="<%=ad.getCount()%>" /></TD>
      </TR>
      
      <TR>
        <TD height="23" colspan="2" align="left" bgcolor="#F9FAF3">
<%
if (ad.getSellType()==ad.SELL_TYPE_AUCTION) {
    AuctionWorthDb aw = new AuctionWorthDb();
    long[] ids = aw.getWorthOfAuction(ad.getMsgRootId());
    int id = (int)ids[0];
    aw = aw.getAuctionWorthDb(id);
%>	
	<span id=div_auction name=div_auction>底价：
	<input name=price size=2 value=<%=StrUtil.FormatPrice(aw.getPrice())%> />
	最小加价：
	<input name=dlt size=2 value=<%=StrUtil.FormatPrice(aw.getDlt())%> />
	参考价：
	<input name=referPrice size=2 value=<%=StrUtil.FormatPrice(aw.getReferPrice())%> />
	使用币种：<%=strOption%> <br />
	<script>
	frmAnnounce.moneyCode.value = "<%=aw.getMoneyCode()%>";
	</script>
	起拍日期：
	<input name=beginDate size=10 readonly value="<%=DateUtil.format(ad.getBeginDate(), "yyyy-MM-dd")%>"/>
	<img src="<%=request.getContextPath()%>/forum/plugin/auction/skin/default/images/calendar.gif" align=absMiddle style="cursor:hand" onclick="SelectDate('beginDate','yyyy-mm-dd')" />&nbsp;截止日期：
	<input name=endDate size=10 readonly value="<%=DateUtil.format(ad.getEndDate(), "yyyy-MM-dd")%>"/>
	<img src="<%=request.getContextPath()%>/forum/plugin/auction/skin/default/images/calendar.gif" align=absMiddle style="cursor:hand" onclick="SelectDate('endDate','yyyy-mm-dd')" />&nbsp;（注意：拍卖最长不超过<%=expireDayMax%>天）</span>
<%}else{
    String formElement = AuctionSkin.LoadString(request, "FORM_EDIT_SELL");
	String checked = "";
    if (ad.isShow())
        checked = "checked";
    formElement = formElement.replaceFirst("\\$checked", checked);

    ir = v.iterator();
    str = "";

    AuctionWorthDb aw = new AuctionWorthDb();
    Vector awv = aw.list(msgId);
    int size = awv.size();

    while (ir.hasNext()) {
        ScoreUnit su = (ScoreUnit) ir.next();
        if (su.isExchange()) {
            boolean isFounded = false;
            for (int i=0; i<size; i++) {
                aw = (AuctionWorthDb) awv.get(i);
                // 如果该类型的币已经在物品的价格列表中
                if (aw.getMoneyCode().equals(su.getCode())) {
                    str += "<input name=moneyType type=checkbox checked value='" + su.getCode() +
                                        "'>" + AuctionSkin.LoadString(request, "use") + su.getName() +
                                        "&nbsp";
                    str += AuctionSkin.LoadString(request, "price") +
                                        "&nbsp;<input name='price_" + su.getCode() +
                                        "' size=2 value='" + aw.getPrice() + "'>&nbsp;";
                    isFounded = true;
                    break;
                 }
            }
            if (!isFounded) {
                 str += "<input name=moneyType type=checkbox value='" +
                                    su.getCode() +
                                    "'>" +
                                    AuctionSkin.LoadString(request, "use") +
                                    su.getName() +
                                    "&nbsp";
                str += AuctionSkin.LoadString(request, "price") +
                                    "&nbsp;<input name='price_" + su.getCode() +
                                    "' size=2>&nbsp;";
             }
      	}
    }
    formElement += str;
	out.print(formElement);
}%>
	<%=auctionDir%><br />
	<script>
	frmAnnounce.shopDir.value = "<%=ad.getShopDir()%>";
	</script>
<%if (!as.isLoaded()) {%>
商品目录：
<select name="catalogCode" onchange="if(this.options[this.selectedIndex].value=='not'){alert(this.options[this.selectedIndex].text+' 不能被选择！'); this.value='not'; return false;}">
  <%=sb.toString()%>
</select>
<script>
frmAnnounce.catalogCode.value = "<%=ad.getCatalogCode()%>";
</script>
<%}%>
</TD>
      </TR>
  </TBODY>
</TABLE>
