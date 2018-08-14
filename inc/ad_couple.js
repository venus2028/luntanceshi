function getScrollXY(){
var x,y;
if(document.body.scrollTop){
  x=document.body.scrollLeft;
  y=document.body.scrollTop;
}
else{
  x=document.documentElement.scrollLeft;
  y=document.documentElement.scrollTop;
}
return {x:x,y:y};
}
function initEcAd() {
if(window.document.body.offsetWidth<=820){
	try {
	  $("AdLayer1").style.visibility = 'hidden';
	}
	catch (e) {}
	try {
	  $("AdLayer2").style.visibility = 'hidden';
	}
	catch (e) {}
	return;
}
try {
$("AdLayer1").style.posTop = -200;
$("AdLayer1").style.visibility = 'visible'
MoveLeftLayer("AdLayer1");
}
catch (e) {}
try {
$("AdLayer2").style.posTop = -200;
$("AdLayer2").style.visibility = 'visible'
MoveRightLayer("AdLayer2");
}
catch (e) {}
}
function MoveLeftLayer(layerName) {
var x = 10;
var y = 130;
var y = getScrollXY().y + y;
$(layerName).style.top = y+"px";
$(layerName).style.left = x+"px";
setTimeout("MoveLeftLayer('" + layerName + "')", 20);
}
function MoveRightLayer(layerName) {
var x = 10;
var y = 130;
$(layerName).style.top = (getScrollXY().y+y) + "px";
var cw=document.documentElement.clientWidth;
$(layerName).style.left = cw-$(layerName).clientWidth-x+"px";
setTimeout("MoveRightLayer('" + layerName + "')", 20);
}
function DobAdv_Show(objName, s){
var v = s?"visible":"hidden";
try {
$(objName).style.visibility = v;
}
catch (e) {}
}
initEcAd();