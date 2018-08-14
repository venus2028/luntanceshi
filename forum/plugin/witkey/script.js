var GetDate=""; 
function SelectDate(ObjName,FormatDate){
	var PostAtt = new Array;
	PostAtt[0]= FormatDate;
	PostAtt[1]= findObj(ObjName);

	GetDate = showModalDialog("plugin/witkey/calendar/calendar.htm", PostAtt ,"dialogWidth:286px;dialogHeight:221px;status:no;help:no;");
}
function SetDate()
{ 
	findObj(ObjName).value = GetDate; 
} 

function setShopDir(dir) {
	frmAnnounce.shopDir.value = dir;
}

function setCatalogCode(code) {
	frmAnnounce.catalogCode.value = code;
}

var sStr1="";	// 3|22|33|30
function showSpareTime(s) {
	sStr1 = s;
	Spare_Time();
}

function Spare_Time() {
	TimeString1=sStr1;
	ArrSpareTime1=TimeString1.split("|");
	var spare_day1=ArrSpareTime1[0];
	var spare_hour1=ArrSpareTime1[1];
	var spare_minute1=ArrSpareTime1[2];
	var spare_second1=ArrSpareTime1[3];
	document.all["bidExpire"].innerHTML=spare_day1 + " 天" + spare_hour1 + " 时" + spare_minute1 + " 分" + spare_second1 + " 秒";
	if (spare_day1<0){
		// document.all["bidEnd"].style.display="";
		return;
	}					
	spare_second1 -= 1;
	if (spare_second1 < 0){
		spare_second1 = 59;
		spare_minute1 -= 1;
		if (spare_minute1<0){
			spare_minute1 = 59;
			spare_hour1 -= 1;
			if (spare_hour1 < 0){
				spare_hour1 = 59;
				spare_day -= 1;
			}
		}
	}
	sStr1=spare_day1 + "|" + spare_hour1 + "|" + spare_minute1 + "|" + spare_second1 + "|";			
	setTimeout("Spare_Time()","1000")
}