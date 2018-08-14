<%@ page contentType="text/html;charset=utf-8"%>
<%@ page import="cn.js.fan.util.*"%>
<%@ page import="cn.js.fan.web.*"%>
<%@ page import="com.redmoon.forum.person.*"%>
<%@ page import="com.redmoon.forum.plugin.*"%>
<%@ page import="com.redmoon.forum.plugin.base.*"%>
<%@ page import="java.util.*"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%
String boardcode = ParamUtil.get(request, "boardcode");
com.redmoon.forum.Leaf curleaf = new com.redmoon.forum.Leaf();
curleaf = curleaf.getLeaf(boardcode);
if (curleaf==null || !curleaf.isLoaded()) {
	out.print(SkinUtil.makeErrMsg(request, "该版块" + boardcode + "不存在"));
	return;
}

if (!curleaf.isUsePlugin2("alipay")) {
	out.print(SkinUtil.makeErrMsg(request, "该版不能够发起支付宝交易！"));
	return;
}
%>
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1" bgcolor="#CCCCCC">
    <TBODY>
    </TBODY>
    <TBODY>
      <tr>
        <td width="20%" bgcolor="#F0F0E1">支付宝账号</td>
        <td width="80%" bgcolor="#F0F0E1"><input class="input" maxlength="200" size="35" name="alipay_seller">
		<input name="plugin2Code" value="alipay" type="hidden"></td>
      </tr>
      <tr>
        <td bgcolor="#F0F0E1">商品名称</td>
        <td bgcolor="#F0F0E1"><input class="input" maxlength="200" size="25" name="alipay_subject">
          &nbsp;&nbsp;  
      价格
      <input class="input" maxlength="20" size="5" name="alipay_price">
元</td>
      </tr>
      <tr>
        <td bgcolor="#F0F0E1">邮费承担方</td>
        <td bgcolor="#F0F0E1"><input id="alipay_transport" onClick="checkTransport();" type="radio" value="3" name="alipay_transport">
          虚拟物品不需邮递
          <input id="alipay_transport" onClick="checkTransport();" type="radio" checked value="2" name="alipay_transport">
          卖家承担运费
          <input id="alipay_transport" onClick="checkTransport();" type="radio" value="1" name="alipay_transport">
          买家承担运费
          <br>
平邮
<input class="input" disabled maxlength="20" size="5" name="alipay_ordinary">
元&nbsp;&nbsp; 快递
<input class="input" disabled maxlength="20" size="5" name="alipay_express">
元 (不填为平邮)</td>
      </tr>
      <tr>
        <td bgcolor="#F0F0E1">演示网址</td>
        <td bgcolor="#F0F0E1"><input class="input" maxlength="200" size="35" name="alipay_demo">
        商品说明请填写于信息内容中</td>
      </tr>
      <tr>
        <td bgcolor="#F0F0E1">联系方式</td>
        <td bgcolor="#F0F0E1">淘宝旺旺
          <input class="input" maxlength="20" size="10" name="alipay_ww">
腾讯QQ
<input class="input" maxlength="20" size="10" name="alipay_qq">
让买家在线联系您</td>
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
</script>
