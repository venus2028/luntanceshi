function $(s){return document.getElementById(s);}
function $$(s){return document.frames?document.frames[s]:$(s).contentWindow;}
function $c(s){return document.createElement(s);}
function exist(s){return $(s)!=null;}
function dw(s){document.write(s);}
function hide(s){$(s).style.display=$(s).style.display=="none"?"":"none";}
function isNull(_sVal){return (_sVal == "" || _sVal == null || _sVal == "undefined");}

function detectBrowser(){
	var sUA = navigator.userAgent.toLowerCase();
	var sIE = sUA.indexOf("msie");
	var sOpera = sUA.indexOf("opera");
	var sMoz = sUA.indexOf("gecko");
	if (sOpera != -1) return "opera";
	if (sIE != -1){
		nIeVer = parseFloat(sUA.substr(sIE + 5));
		if (nIeVer >= 6) return "ie6";
		else if (nIeVer >= 5.5) return "ie55";
		else if (nIeVer >= 5 ) return "ie5";
	}
	if (sMoz != -1)	return "moz";
	return "other";
}

function isIE() {
	return detectBrowser().indexOf("ie")>-1;
}

function getRadioValue(radionname) {
	var radioboxs = document.all.item(radionname);
	if (radioboxs!=null)
	{
		for (i=0; i<radioboxs.length; i++)
		{
			if (radioboxs[i].type=="radio" && radioboxs[i].checked)
			{ 
				return radioboxs[i].value;
			}
		}
		return radioboxs.value
	}
	return "";
}

function setRadioValue(myitem, v)
{
     var radioboxs = document.all.item(myitem);
     if (radioboxs!=null)
     {
       for (i=0; i<radioboxs.length; i++)
          {
            if (radioboxs[i].type=="radio")
              {
                 if (radioboxs[i].value==v)
				 	radioboxs[i].checked = true;
              }
          }
     }
}

function getCheckboxValue(checkboxname){
	var checkboxboxs = document.all.item(checkboxname);
	var CheckboxValue = '';
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			if (checkboxboxs.checked) {
				return checkboxboxs.value;
			}
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			if (checkboxboxs[i].type=="checkbox" && checkboxboxs[i].checked)
			{
				if (CheckboxValue==''){
					CheckboxValue += checkboxboxs[i].value;
				}
				else{
					CheckboxValue += ","+ checkboxboxs[i].value;
				}
			}
		}
	}
	return CheckboxValue;
}

function setCheckboxChecked(checkboxname, v) {
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			if (checkboxboxs.value == v) {
				checkboxboxs.checked = true;
			}
		}
		for (i=0; i<checkboxboxs.length; i++)
		{
			if (checkboxboxs[i].type=="checkbox" && checkboxboxs[i].value == v)
			{
				checkboxboxs[i].checked = true;
			}
		}
	}
}

/*置多个checkbox，参数v如果有多个值，则通过,号分隔*/
function setMultiCheckboxChecked(checkboxname, v) {
	var checkboxboxs = document.all.item(checkboxname);
	if (checkboxboxs!=null)
	{
		// 如果只有一个元素
		if (checkboxboxs.length==null) {
			if (checkboxboxs.value == v) {
				checkboxboxs.checked = true;
			}
		}
		var ary = v.split(",");
		for (i=0; i<checkboxboxs.length; i++)
		{
			if (checkboxboxs[i].type=="checkbox")
			{
				for (j=0; j<ary.length; j++) {
					if (checkboxboxs[i].value == ary[j]) {
						
						checkboxboxs[i].checked = true;
					}
				}
			}
		}
	}
}

function isNumeric(str) {
	if (str==null || str=="")
		return false;
	return !isNaN(str);
}

function isNotCn(str) {
	if (/[^\x00-\xff]/g.test(str))
		return false;
	else
		return true;
}

String.prototype.trim= function() {  
    return this.replace(/(^\s*)|(\s*$)/g, "");  
}

var cwAjax = {xmlhttp:function(){ 
		try{ 
			return new ActiveXObject('Msxml2.XMLHTTP'); 
		}catch(e){ 
			try{ 
				return new ActiveXObject('Microsoft.XMLHTTP'); 
			}catch(e){ 
				return new XMLHttpRequest(); 
			} 
		} 
	} 
}; 

cwAjax.Request = function(){ 
	if (arguments.length<2) return; 
	var _p = {asynchronous:true,method:"GET",parameters:""}; 
	for (var key in arguments[1]){
		_p[key] = arguments[1][key]; 
	} 
	var _x = cwAjax.xmlhttp();
	var _url = arguments[0];
	if(_p["parameters"].length>0) _p["parameters"] += '&_='; 
	if(_p["method"].toUpperCase()=="GET")_url += (_url.match(/\?/) ? '&' : '?') + _p["parameters"]; 
	_x.open(_p["method"],_url,_p["asynchronous"]); 
	_x.onreadystatechange = function(){ 
	if (_x.readyState==4){ 
	if(_x.status==200){ 
		_p["onComplete"]?_p["onComplete"](_x):""; 
	}else{ 
		_p["onError"]?_p["onError"](_x):""; 
	} 
	} 
	} 
	if(_p["method"].toUpperCase()=="POST")_x.setRequestHeader("Content-Type","application/x-www-form-urlencoded"); 
	_x.send(_p["method"].toUpperCase()=="POST" ? _p["parameters"] : null); 
}
function openWin(url,width,height,scrollbars) {
	if (arguments.length==3)
		window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,top=50,left=120,width="+width+",height="+height);
	else
		window.open(url,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars="+scrollbars+",resizable=no,top=50,left=120,width="+width+",height="+height);
}
function get_cookie(Name) {
	var search = Name + "="
	var returnvalue = "";
	if (document.cookie.length > 0) {
		offset = document.cookie.indexOf(search)
		// if cookie exists
		if (offset != -1) { 
			offset += search.length
			// set index of beginning of value
			end = document.cookie.indexOf(";", offset);
			// set index of end of cookie value
			if (end == -1) end = document.cookie.length;
			returnvalue=unescape(document.cookie.substring(offset, end))
		}
	}
	return returnvalue;
}
function set_cookie(name, value, expires, path, domain, secure){
	var argv=set_cookie.arguments;
	var argc=set_cookie.arguments.length;
	var expires=(2<argc)?argv[2]:null;
	var path=(3<argc)?argv[3]:null;
	var domain=(4<argc)?argv[4]:null;
	var secure=(5<argc)?argv[5]:false;
	document.cookie=name+"="+escape(value)+((expires==null)?"":("; expires="+expires.toGMTString()))+((path==null)?"":("; path="+path))+((domain==null)?"":("; domain="+domain))+((secure==true)?"; secure":"");
}


if(window.HTMLElement) { 
HTMLElement.prototype.__defineSetter__("outerHTML",function(sHTML){ 
var r=this.ownerDocument.createRange(); 
r.setStartBefore(this); 
var df=r.createContextualFragment(sHTML); 
this.parentNode.replaceChild(df,this); 
return sHTML; 
}); 
HTMLElement.prototype.__defineGetter__("outerHTML",function(){ 
var attr; 
var attrs=this.attributes; 
var str="<"+this.tagName.toLowerCase(); 
for(var i=0;i<attrs.length;i++){ 
attr=attrs[i]; 
if(attr.specified) 
str+=" "+attr.name+'="'+attr.value+'"'; 
} 
if(!this.canHaveChildren) 
return str+">"; 
return str+">"+this.innerHTML+"</"+this.tagName.toLowerCase()+">"; 
}); 
HTMLElement.prototype.__defineGetter__("canHaveChildren",function(){ 
switch(this.tagName.toLowerCase()){ 
case "area": 
case "base": 
case "basefont": 
case "col": 
case "frame": 
case "hr": 
case "img": 
case "br": 
case "input": 
case "isindex": 
case "link": 
case "meta": 
case "param": 
return false; 
} 
return true; 
}); 
}

if(typeof HTMLElement!="undefined" && !HTMLElement.prototype.insertAdjacentElement)
{
     HTMLElement.prototype.insertAdjacentElement = function(where,parsedNode)
     {
        switch (where)
        {
            case 'beforeBegin':
                this.parentNode.insertBefore(parsedNode,this)
                break;
            case 'afterBegin':
                this.insertBefore(parsedNode,this.firstChild);
                break;
            case 'beforeEnd':
                this.appendChild(parsedNode);
                break;
            case 'afterEnd':
                if (this.nextSibling) this.parentNode.insertBefore(parsedNode,this.nextSibling);
                    else this.parentNode.appendChild(parsedNode);
                break;
         }
     }

     HTMLElement.prototype.insertAdjacentHTML = function (where,htmlStr)
     {
         var r = this.ownerDocument.createRange();
         r.setStartBefore(this);
         var parsedHTML = r.createContextualFragment(htmlStr);
         this.insertAdjacentElement(where,parsedHTML)
     }

     HTMLElement.prototype.insertAdjacentText = function (where,txtStr)
     {
         var parsedText = document.createTextNode(txtStr)
         this.insertAdjacentElement(where,parsedText)
     }
}