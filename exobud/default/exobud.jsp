<%@ page contentType="text/html;charset=utf-8"%>
<style>
body {
margin:0px;
padding:0px;
}
</style>
<%
String exobudRootRath = request.getContextPath();
%>
<link rel="stylesheet" type="text/css" href="<%=exobudRootRath%>/exobud/default/exobud.css">
<script language="JavaScript" src="<%=exobudRootRath%>/exobud/exobud_js.jsp"></script>
<script language="JavaScript" src="<%=exobudRootRath%>/exobud/exobudset.js"></script>
<script language="JavaScript" src="<%=exobudRootRath%>/exobud/exobudpl.js"></script>
<script language="JScript" for="Exobud" event="openStateChange(sf)">evtOSChg(sf);</script>
<script language="JScript" for="Exobud" event="playStateChange(ns)">evtPSChg(ns);</script>
<script language="JScript" for="Exobud" event="error()">evtWmpError();</script>
<script language="JScript" for="Exobud" event="Buffering(bf)">evtWmpBuff(bf);</script>
<script language="JavaScript" src="<%=exobudRootRath%>/exobud/imgchg.jsp?style=default"></script>

<TABLE width="315" height="20" border=0 align="center" cellPadding=0 cellSpacing=0>
  <TBODY>
    <TR>
      <TD width="177" align=middle><TABLE cellSpacing=1 cellPadding=0 width=177 bgColor=#878787 
            border=0>
          <TBODY>
            <TR>
              <TD><TABLE cellSpacing=0 cellPadding=0 width="100%" 
                  background=<%=exobudRootRath%>/exobud/default/img/play3_screenbg.gif border=0>
                  <TBODY>
                    <TR>
                      <TD width=2><IMG height=17 
                        src="<%=exobudRootRath%>/exobud/default/img/play3_screenl.gif" width=2></TD>
                      <td class=bg width=88><object id="Exobud" classid="CLSID:6BF52A52-394A-11d3-B153-00C04F79FAA6"
  type="application/x-oleobject" width="0" height="0"
  style="position:relative;left:0px;top:0px;width:0px;height:0px;">
                          <param name="autoStart" value="true">
                          <param name="balance" value="0">
                          <param name="currentPosition" value="0">
                          <param name="currentMarker" value="0">
                          <param name="enableContextMenu" value="false">
                          <param name="enableErrorDialogs" value="false">
                          <param name="enabled" value="true">
                          <param name="fullScreen" value="false">
                          <param name="invokeURLs" value="false">
                          <param name="mute" value="false">
                          <param name="playCount" value="1">
                          <param name="rate" value="1">
                          <param name="uiMode" value="none">
                          <param name="volume" value="100">
                        </object>
                        <marquee behavior="scroll" width=90 height=12 scrollamount=2 scrolldelay=70>
                        <span id="disp1" class="title"><font color="#000000">音乐圣地</font></span>
                        <div id="capText" style="width:100%;height:12;color:white;background-color:#555555;padding-top:3px;padding-left:5px;display:none"
        >音乐圣地</div>
                        </marquee>
                      </td>
                      <td width=85 align=center valign="middle" nowrap class=bg onClick="chgTimeFmt()">
					  <span id="disp2" class="time" title="时间长度显示方式 (正常/倒数)" style="width:75;cursor:hand;padding-bottom:2px"><font color="#000000">00:00 | 00:00</font></span>
						<span style="display:none">
						<img name="scope" src="image/blank.gif" width=1 height=1 onClick="vizExobud()" style="cursor:help">
						<img name="vmute" src="image/blank.gif" width=8 height=8 border=0 onClick="wmpMute()">
						<img name="vdn"   src="image/blank.gif" width=1 height=1 border=0 onClick="wmpVolDn()">
						<img name="vup"   src="image/blank.gif"  width=1 height=1 border=0 onClick="wmpVolUp()">
						<img name="pmode" src="image/blank.gif" width=1 height=1 border=0 onClick="chgPMode()">
						<img name="rept"  src="image/blank.gif"    width=1 height=1 border=0 onClick="chkRept()">
						</span>
					  </td>
                    </TR>
                  </TBODY>
                </TABLE></TD>
            </TR>
          </TBODY>
        </TABLE></TD>
      <TD width="27"><table width="481%" height="14"  border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td><div align="center"><img name="prevt" src="<%=exobudRootRath%>/exobud/default/img/btn_prev.gif" width=18 height=14 border=0 onClick="playPrev()"
        style="cursor:hand" title="上一首"
     ></div></td>
            <td><div align="center"><img name="pauzt" src="<%=exobudRootRath%>/exobud/default/img/btn_pauz.gif" width=18 height=14 border=0 onClick="wmpPP()"
        style="cursor:hand" title="暂停．继续"
     ></div></td>
            <td><div align="center"><img name="stopt" src="<%=exobudRootRath%>/exobud/default/img/btn_stop.gif" width=18 height=14 border=0 onClick="wmpStop()"
        style="cursor:hand" title="停止"
     ></div></td>
            <td><div align="center"><img name="playt" src="<%=exobudRootRath%>/exobud/default/img/btn_play.gif" width=18 height=14 border=0 onClick="startExobud()"
         style="cursor:hand" title="播放"
     ></div></td>
            <td><div align="center"><img name="nextt" src="<%=exobudRootRath%>/exobud/default/img/btn_next.gif" width=18 height=14 border=0 onClick="playNext()"
        style="cursor:hand" title="下一首"
    ></div></td>
            <td><div align="center"><img name="plist" src="<%=exobudRootRath%>/exobud/default/img/btn_plist.gif" width=18 height=14 border=0 onClick="openPlist()"
         style="cursor:hand" title="播放清单"></div>
            <td><div align="center"><img src="<%=exobudRootRath%>/exobud/default/img/lyric.gif" width="17" height="14" border=0 style="cursor:hand" title="歌词显示" onClick="lyric()"></div></td>
          </tr>
        </table></TD>
    </TR>
  </TBODY>
</TABLE>
