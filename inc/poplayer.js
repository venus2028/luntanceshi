document.onmousedown = popLayerMouseDown;
document.onmousemove = popLayerMouseMove;
document.onmouseup = popLayerMouseUp;
var popTime=0;
var popCloseTimeout=5000;
var popLayerTitleTemplate = "<div id=\"popLayerTitle\" class=\"popLayerTitle\" moveable=\"{$move}\"><span><a href=\"#\" onclick=\"hidePopLayer();\">[close]</a></span>{$title}</div><div id=\"popLayerContent\" class=\"popLayerContent\">{$content}</div>";
var notHideSelects="";
function openWinLayer(title, contentObj, moveable, w, h, timeout, notHideSels){
	popTime=0;
	if (timeout)
		popCloseTimeout=timeout;
	if (notHideSels)
		notHideSelects = notHideSels;
	underlayer();
	var node = document.getElementById("popLayer");
	if (!node) {
		node=document.createElement("div");
		node.setAttribute("id", "popLayer");
		node.style.visibility="hidden";
		node.style.top="-9999px";
		node.style.position="absolute";
		if (title!=""){
			var str;
			str = popLayerTitleTemplate.replace("{$title}", title);
			if (moveable)
				str = str.replace("{$move}", "true");
			else
				str = str.replace("{$move}", "false");
			if (typeof(contentObj)=="string")
				node.innerHTML = str.replace("{$content}", contentObj);
			else{
				node.innerHTML = str.replace("{$content}", contentObj.innerHTML);
				contentObj.innerHTML = "";
			}
		}
		else{
			if (typeof(contentObj)=="string")
				node.innerHTML = contentObj;
			else{
				node.innerHTML = contentObj.innerHTML;
				contentObj.innerHTML = "";
			}
		}
		document.body.appendChild(node);
	}
	if (w) {
		 node.style.width = w + "px";
	}
	if (h) {
		 node.style.height = h + "px";
	}
	
	//判断是否有DTD标准声明
	var width=document.compatMode=="CSS1Compat"?document.documentElement.clientWidth : document.body.clientWidth;
	var height=document.compatMode=="CSS1Compat"?document.documentElement.clientHeight : document.body.clientHeight;
	
	node.style.top = Math.floor(document.documentElement.scrollTop+(height-node.offsetHeight)/2)+"px";
	node.style.left = Math.floor(document.documentElement.scrollLeft+(width-node.offsetWidth)/2)+"px";
	node.style.visibility="visible";
	node.style.zIndex = 999;
	if (timeout) {
		if (timeout>0)
			closePopLayer(timeout);
	}
}
function discardAutoClose() {
	popCloseTimeout=-1;
}
function closePopLayer(){
	if (popCloseTimeout<=0)
		return;
	if (popTime>popCloseTimeout){
		hidePopLayer();
		return;
	}
	var span = document.getElementById("secondSpan");
	if (span!=null)
		span.innerHTML=Math.round((popCloseTimeout-popTime)/1000,0);
	popTime+=20;
	setTimeout("closePopLayer()",20);
}
function hidePopLayer(){
	var layerNode = document.getElementById("popLayer");
	var underLayerNode = document.getElementById("popLayerUnderlayer");
	if (layerNode) {
		 layerNode.style.visibility="hidden";
		 layerNode.style.top = "-9999px";
	}
	if (underLayerNode) {
		 underLayerNode.style.visibility="hidden";
		 underLayerNode.style.top = "-9999px";
		 showSelect();
	}
}
function underlayer(){
    hideSelect(); 
	var node = document.getElementById("popLayerUnderlayer");
	if (!node) {
		 node=document.createElement("div");
		 node.setAttribute("id", "popLayerUnderlayer");
		 node.style.visibility="hidden";
		 node.style.height = document.body.clientHeight + "px";
		 node.style.width = document.body.clientWidth + "px";
		 //node.style.background = "#eee";
		 node.style.opacity = "0.5";
		 node.style.filter= "alpha(opacity=60)";
		 node.style.position = "absolute";
		 node.style.top = "-9999px";
		 document.body.appendChild(node);
	}
	node.style.top = "0px";
	node.style.left = "0px";
	node.style.visibility="visible";
	node.style.zIndex = 1;
}
function hideSelect() {
	var ary = new Array();
	if (notHideSelects!="")
		ary = notHideSelects.split(",");
	var sels = document.body.getElementsByTagName("SELECT");
	for (var i=0; i<sels.length; i++){
		var isExcept = false;
		for (var j=0;j<ary.length;j++){
			if (ary[j]==sels[i].getAttribute("id")){
				isExcept = true;
				break;
			}
		}
		if (isExcept) continue;
		if (sels[i].style.display!="none") {
			sels[i].setAttribute("hideAuto", "hideAuto");
			sels[i].style.display="none";
		}
	}
}
function showSelect() {
	var ary = new Array();
	if (notHideSelects!="")
		ary = notHideSelects.split(",");
	var sels = document.body.getElementsByTagName("SELECT");
	for (var i=0; i<sels.length; i++){
		var isExcept = false;
		for (var j=0;j<ary.length;j++){
			if (ary[j]==sels[i].getAttribute("id")){
				isExcept = true;
				break;
			}
		}
		if (isExcept) continue;
		if (sels[i].getAttribute("hideAuto")) {
			sels[i].removeAttribute("hideAuto");
			sels[i].style.display = "";
		}
	}
}
var popLayerTarget;
var popLayerBeginPosX;
var popLayerBeginPosY;
function popLayerMouseMove(ev) {
   ev = ev || window.event;
   if(popLayerTarget) {
		if(popLayerTarget.getAttribute("moveable") == "true") {
			var curTarget = popLayerTarget.parentNode;
			curTarget.style.left = document.body.scrollLeft + ev.clientX - popLayerBeginPosX;
			curTarget.style.top = document.body.scrollTop + ev.clientY - popLayerBeginPosY;
        }
   }
}
function popLayerMouseDown(ev) {
   	ev = ev || window.event;
   	popLayerTarget = ev.target || ev.srcElement;
   	if(popLayerTarget.getAttribute("moveable")!="true"){
		return;	
	}	
   	popLayerBeginPosX = ev.layerX || ev.offsetX;
   	popLayerBeginPosY = ev.layerY || ev.offsetY;
}
function popLayerMouseUp(ev) {
   ev = ev || window.event;
   popLayerTarget = ev.target || ev.srcElement;
   if(popLayerTarget.getAttribute("moveable")) {
        popLayerTarget.setAttribute("moveable", "false");
   }
}