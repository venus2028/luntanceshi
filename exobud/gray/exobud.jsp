<%@ page contentType="text/html;charset=utf-8"%>
<%
String exobudRootPath = request.getContextPath();
String exobudStyle = (String)request.getAttribute("style");
if (exobudStyle==null)
	exobudStyle = "default";
%>
<style>
body {
margin:0px;
padding:0px;
background-image:url(<%=exobudRootPath%>/exobud/gray/img/bbbb.gif);
}
</style>
<link rel="stylesheet" type="text/css" href="<%=exobudRootPath%>/exobud/default/exobud.css">
<script language="JavaScript" src="<%=exobudRootPath%>/exobud/exobud_js.jsp"></script>
<script language="JavaScript" src="<%=exobudRootPath%>/exobud/exobudset.js"></script>
<script language="JavaScript" src="<%=exobudRootPath%>/exobud/exobudpl.js"></script>
<script language="JScript" for="Exobud" event="openStateChange(sf)">evtOSChg(sf);</script>
<script language="JScript" for="Exobud" event="playStateChange(ns)">evtPSChg(ns);</script>
<script language="JScript" for="Exobud" event="error()">evtWmpError();</script>
<script language="JScript" for="Exobud" event="Buffering(bf)">evtWmpBuff(bf);</script>
<script language="JavaScript" src="<%=exobudRootPath%>/exobud/imgchg.jsp?style=<%=exobudStyle%>"></script>

<table width="149" height="44"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td><TABLE border=0 align="center" cellPadding=0 cellSpacing=0>
      <TBODY>
        <TR>
          <TD width=1 height=1><IMG height=8 src="<%=exobudRootPath%>/exobud/gray/img/play3_fo11.gif" 
            width=5></TD>
          <TD background=<%=exobudRootPath%>/exobud/gray/img/play3_fo1t.gif><IMG height=8 src=""></TD>
          <TD><IMG height=8 src="<%=exobudRootPath%>/exobud/gray/img/play3_fo12.gif" width=5></TD>
        </TR>
        <TR>
          <TD background=<%=exobudRootPath%>/exobud/gray/img/play3_fo1l.gif rowSpan=3><IMG src="" 
            width=5></TD>
          <TD align=middle bgColor=#f5f5f5><TABLE cellSpacing=1 cellPadding=0 width=139 bgColor=#878787 
            border=0>
              <TBODY>
                <TR>
                  <TD><TABLE cellSpacing=0 cellPadding=0 width="100%" 
                  background=<%=exobudRootPath%>/exobud/gray/img/play3_screenbg.gif border=0>
                      <TBODY>
                        <TR>
                          <TD width=2><IMG height=17 
                        src="<%=exobudRootPath%>/exobud/gray/img/play3_screenl.gif" width=2></TD>
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
                              <marquee behavior="scroll" width=53 height=12 scrollamount=2 scrolldelay=70>
                              <span id="disp1" class="title"><font color="#FFFFFF">音乐圣地</font></span>
                              <div id="capText" style="width:100%;height:12;color:white;background-color:#555555;padding-top:3px;padding-left:5px;display:none"
        >音乐圣地</div></marquee>
                          </td>
                          <td class=bg width=68 align=center nowrap onClick="chgTimeFmt()"><span id="disp2" class="time" title="时间长度显示方式 (正常/倒数)"
        style="width:68;cursor:hand;padding-bottom:2px"><font color="#FFFFFF">00:00 | 00:00</font></span> <img name="scope" src="<%=exobudRootPath%>/exobud/gray/img/blank.gif" width=1 height=1
        onClick="vizExobud()" style="cursor:help" title="到访 ExoBUD MP 原作者 Jinwoong Yu 的网站 [韩文]"
    ><img name="vmute" src="<%=exobudRootPath%>/exobud/gray/img/blank.gif" width=1 height=8 border=0 onClick="wmpMute()"
        onMouseOver="imgtog('vmute',2)" onMouseOut="imgtog('vmute',3)" 
     ><img name="vdn"   src="<%=exobudRootPath%>/exobud/gray/img/blank.gif"         width=1 height=1 border=0 onClick="wmpVolDn()"
        onMouseOver="imgtog('vdn',2)"   onMouseOut="imgtog('vdn',3)"  
     ><img name="vup"   src="<%=exobudRootPath%>/exobud/gray/img/blank.gif"         width=1 height=1 border=0 onClick="wmpVolUp()"
        onMouseOver="imgtog('vup',2)"   onMouseOut="imgtog('vup',3)" 
    ><img name="pmode" src="<%=exobudRootPath%>/exobud/gray/img/blank.gif" width=1 height=1 border=0 onClick="chgPMode()"
        onMouseOver="imgtog('pmode',2)" onMouseOut="imgtog('pmode',3)" 
     ><img name="rept"  src="<%=exobudRootPath%>/exobud/gray/img/blank.gif"    width=1 height=1 border=0 onClick="chkRept()"
        onMouseOver="imgtog('rept',2)"  onMouseOut="imgtog('rept',3)"  
    ></td>
                        </TR>
                      </TBODY>
                  </TABLE></TD>
                </TR>
              </TBODY>
          </TABLE></TD>
          <TD background=<%=exobudRootPath%>/exobud/gray/img/play3_fo1r.gif rowSpan=3><IMG src="" 
            width=5></TD>
        </TR>
        <TR>
          <TD bgColor=#f5f5f5 height=6><IMG height=6 src=""></TD>
        </TR>
        <TR>
          <TD><table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
              <tr bgcolor="F5F5F5">
                <td><div align="center"><img name="prevt" src="<%=exobudRootPath%>/exobud/gray/img/btn_prev.gif" border=0 onClick="playPrev()"
        onMouseOver="imgtog('prevt',2)" onMouseOut="imgtog('prevt',3)" style="cursor:hand" title="上一首"
     ></div></td>
                <td><div align="center"><img name="pauzt" src="<%=exobudRootPath%>/exobud/gray/img/btn_pauz.gif" border=0 onClick="wmpPP()"
        onMouseOver="imgtog('pauzt',2)" onMouseOut="imgtog('pauzt',3)" style="cursor:hand" title="暂停．继续"
     ></div></td>
                <td><div align="center"><img name="stopt" src="<%=exobudRootPath%>/exobud/gray/img/btn_stop.gif"        width=18 height=14 border=0 onClick="wmpStop()"
        onMouseOver="imgtog('stopt',2)" onMouseOut="imgtog('stopt',3)" style="cursor:hand" title="停止"
     ></div></td>
                <td><div align="center"><img name="playt" src="<%=exobudRootPath%>/exobud/gray/img/btn_play.gif" border=0 onClick="startExobud()"
        onMouseOver="imgtog('playt',2)" onMouseOut="imgtog('playt',3)" style="cursor:hand" title="播放"
     ></div></td>
                <td><div align="center"><img name="nextt" src="<%=exobudRootPath%>/exobud/gray/img/btn_next.gif" border=0 onClick="playNext()"
        onMouseOver="imgtog('nextt',2)" onMouseOut="imgtog('nextt',3)" style="cursor:hand" title="下一首"
    ></div></td>
                <td><div align="center"><img name="plist" src="<%=exobudRootPath%>/exobud/gray/img/btn_plist.gif" border=0 onClick="openPlist()"
        onMouseOver="imgtog('plist',2)" onMouseOut="imgtog('plist',3)" style="cursor:hand" title="播放清单"></div></td>
                <td><div align="center"><img name="lyric" src="<%=exobudRootPath%>/exobud/gray/img/lyric.gif" border=0 onClick="vizExobud()"
        onMouseOver="imgtog('lyric',2)" onMouseOut="imgtog('lyric',3)" style="cursor:hand" title="歌词"></div></td>
              </tr>
          </table></TD>
        </TR>
        <TR>
          <TD><IMG height=5 src="<%=exobudRootPath%>/exobud/gray/img/play3_fo14.gif" width=5></TD>
          <TD background=<%=exobudRootPath%>/exobud/gray/img/play3_fo1b.gif><IMG height=5 src=""></TD>
          <TD width=1 height=1><IMG height=5 src="<%=exobudRootPath%>/exobud/gray/img/play3_fo13.gif" 
            width=5></TD>
        </TR>
      </TBODY>
    </TABLE></td>
  </tr>
</table>
