<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="com.redmoon.blog.*" %>
<%@ page import="com.redmoon.forum.*" %>
<%@ page import="cn.js.fan.util.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin2.alipay.*"%>
<%@ page import="com.redmoon.forum.plugin.base.*"%>
<%@ page import="com.redmoon.forum.person.UserSet"%>
<jsp:useBean id="StrUtil" scope="page" class="cn.js.fan.util.StrUtil"/>
<jsp:useBean id="privilege" scope="page" class="com.redmoon.forum.Privilege"/>
<%
long msgId = ParamUtil.getLong(request, "msgId");
MsgMgr mm = new MsgMgr();
MsgDb Topic = mm.getMsgDb(msgId);
%>
  <table width="100%" border="0" align="center" cellpadding="4" cellspacing="1" bgcolor="#CCCCCC">
    <TBODY>
    </TBODY>
    <TBODY>
			  <tr>
                <td width="20%" bgcolor="#F3EFE2">支付宝账号</td>
			    <td width="80%" bgcolor="#F3EFE2">
				<%
				AlipayDb ad = new AlipayDb();
				ad = ad.getAlipaydDb(Topic.getId());
				%>
				<input class="input" maxlength="200" size="35" name="alipay_seller" value="<%=ad.getSeller()%>">
                    <input name="plugin2Code" value="alipay" type="hidden">                </td>
      </tr>
			  <tr>
                <td bgcolor="#F3EFE2">商品名称</td>
			    <td bgcolor="#F3EFE2"><input class="input" maxlength="200" size="25" name="alipay_subject" value="<%=ad.getSubject()%>">
			      &nbsp;&nbsp;  
			      价格
			      <input class="input" maxlength="20" size="5" name="alipay_price" value="<%=ad.getPrice()%>">
			      元</td>
      </tr>
			  <tr>
                <td bgcolor="#F3EFE2">邮费承担方</td>
			    <td bgcolor="#F3EFE2"><input id="alipay_transport" onClick="checkTransport();" type="radio" value="3" name="alipay_transport" <%=ad.getTransport()==3?"checked":""%>>
虚拟物品不需邮递
  <input id="alipay_transport" onClick="checkTransport();" type="radio" checked value="2" name="alipay_transport" <%=ad.getTransport()==2?"checked":""%>>
卖家承担运费
<input id="alipay_transport" onClick="checkTransport();" type="radio" value="1" name="alipay_transport" <%=ad.getTransport()==1?"checked":""%>>
买家承担运费 
<br>
			      平邮
			      <input class="input" disabled maxlength="20" size="5" name="alipay_ordinary" value="<%=ad.getOrdinary()%>">
			      元&nbsp;&nbsp; 快递
			      <input class="input" disabled maxlength="20" size="5" name="alipay_express" value="<%=ad.getExpress()%>">
		        元 (不填为平邮)</td>
      </tr>
			  <tr>
                <td bgcolor="#F3EFE2">演示网址</td>
			    <td bgcolor="#F3EFE2"><input class="input" maxlength="200" size="35" name="alipay_demo" value="<%=ad.getDemo()%>">
			      商品说明请填写于信息内容中</td>
      </tr>
			  <tr>
                <td bgcolor="#F3EFE2">联系方式</td>
			    <td bgcolor="#F3EFE2">淘宝旺旺
			      <input class="input" maxlength="20" size="10" name="alipay_ww" value="<%=ad.getWw()%>">
			      腾讯QQ
			      <input class="input" maxlength="20" size="10" name="alipay_qq" value="<%=ad.getQq()%>">
			      让买家在线联系您 </td>
      </tr>
    </TBODY>
  </table>
<script>
function getRadioValue(myitem)
{
     var radioboxs = document.all.item(myitem);
     if (radioboxs!=null)
     {
	   //如果只有一个radio
	   if (radioboxs.length==null) {
		if (radioboxs.type=="radio" && radioboxs.checked)
			return radioboxs.value;
		else
			return "";
	   }
	   for (i=0; i<radioboxs.length; i++)
       {
            if (radioboxs[i].type=="radio" && radioboxs[i].checked)
            {
                 return radioboxs[i].value;
            }
       }
     }
	 return "";
}

function checkTransport() {
     if (getRadioValue("alipay_transport")=="1") {
         frmAnnounce.alipay_ordinary.disabled = false;
         frmAnnounce.alipay_express.disabled = false;
     } else {
         frmAnnounce.alipay_ordinary.disabled = true;
         frmAnnounce.alipay_express.disabled = true;
     }	
}

checkTransport();
</script>
