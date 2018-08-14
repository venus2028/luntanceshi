	// 判断浏览器
    isClientIE = (document.all ? true : false);

    // 初始月份及各月份天数数组
    var months = new Array("一　月", "二　月", "三　月", "四　月", "五　月", "六　月", "七　月",
	 "八　月", "九　月", "十　月", "十一月", "十二月");
    var daysInMonth = new Array(31, 28, 31, 30, 31, 30, 31, 31,
            30, 31, 30, 31);
	var displayMonth = new Date().getMonth();
	var displayYear = new Date().getFullYear();
	var displayDivName;
	var displayElement;
	
	var dayCountOfMonth = 0; // 用以记录所显示月中的天数

	function getXBrowserRef(eltname) {
	 return (isClientIE ? document.all[eltname].style : document.layers[eltname]);
	}
	
	function hideElement(eltname) { getXBrowserRef(eltname).visibility = 'hidden'; }
	
    function getDays(month, year) {
    	//测试选择的年份是否是润年？
        if (1 == month)
        	return ((0 == year % 4) && (0 != (year % 100))) ||
                  (0 == year % 400) ? 29 : 28;
        else
            return daysInMonth[month];
    }

    function getToday() {
        // 得到今天的日期
        this.now = new Date();
        this.year = this.now.getFullYear();
        this.month = this.now.getMonth();
        this.day = this.now.getDate();
    }

    // 并显示今天这个月份的日历
    today = new getToday();
	
	// dispMonth以1开始
	function newCalendar(eltName, dispYear, dispMonth) {
		var args = newCalendar.arguments;	
		if (args.length>=2) {
			displayYear = dispYear;
		}
		if (args.length==3) {
			displayMonth = dispMonth - 1;
		}
		
		today = new getToday();
        var parseYear;
		parseYear = parseInt(displayYear + '');
        var newCal = new Date(parseYear,displayMonth,1);
        var day = -1;
        var startDayOfWeek = newCal.getDay();
        if ((today.year == newCal.getFullYear()) &&
           (today.month == newCal.getMonth()))
	    {
        	day = today.day;
        }
        var intDaysInMonth = getDays(newCal.getMonth(), newCal.getFullYear());
        var daysGrid = makeDaysGrid(startDayOfWeek,day,intDaysInMonth,newCal,eltName)
	    if (isClientIE) {
	       var elt = document.all[eltName];
	       elt.innerHTML = daysGrid;
	    } 
		else {
	       var elt = document.layers[eltName].document;
	       elt.open();
	       elt.write(daysGrid);
	       elt.close();
	    }
	 }

	 function incMonth(delta,eltName) {
	   displayMonth += delta;
	   if (displayMonth >= 12) {
	     displayMonth = 0;
	     incYear(1,eltName);
	   } else if (displayMonth <= -1) {
	     displayMonth = 11;
	     incYear(-1,eltName);
	   } else {
	     // newCalendar(eltName);
		 window.location.href = "?blogId=" + blogId + "&year=" + displayYear + "&month=" + (displayMonth+1);
	   }
	 }

	 function incYear(delta,eltName) {
	   displayYear = parseInt(displayYear + '') + delta;
	   // newCalendar(eltName);
	   window.location.href = "?blogId=" + blogId + "&year=" + displayYear + "&month=" + (displayMonth+1);
	 }

	 function makeDaysGrid(startDay,day,intDaysInMonth,newCal,eltName) {
		var daysGrid;
	    var month = newCal.getMonth();
	    var year = newCal.getFullYear();
	    var isThisYear = (year == new Date().getFullYear());
	    var isThisMonth = (day > -1)
	    daysGrid = '<table align=center class="calendar" border=0 cellspacing=0 cellpadding=2 width=100%><tr><td align="center" colspan="7" class="blog_calendar_td_header" nowrap>';
	    daysGrid += '<font face="courier new, courier" size=2>';
	    daysGrid += '&nbsp;';
	    daysGrid += '<a href="javascript:incMonth(-1,\'' + eltName + '\')">&laquo; </a>';

	    daysGrid += '<b>';
		daysGrid += months[month];
	    daysGrid += '</b>';

	    daysGrid += '<a href="javascript:incMonth(1,\'' + eltName + '\')"> &raquo;</a>';
	    daysGrid += '&nbsp;&nbsp;';
	    daysGrid += '<a href="javascript:incYear(-1,\'' + eltName + '\')">&laquo; </a>';

	    daysGrid += '<b>';

		daysGrid += ''+year+'&nbsp;年';

	    daysGrid += '</b>';

	    daysGrid += '<a href="javascript:incYear(1,\'' + eltName + '\')"> &raquo;</a></td></tr>';
	    daysGrid += '<tr><td align="center">日</td><td align="center">一</td><td align="center">二</td><td align="center">三</td><td align="center">四</td><td align="center">五</td><td align="center">六</td></tr>';
	    var dayOfMonthOfFirstSunday = (7 - startDay + 1);
		daysGrid += "<tr>"
		var count = 0;
	    for (var intWeek = 0; intWeek < 6; intWeek++) {
	       var dayOfMonth;
	       for (var intDay = 0; intDay < 7; intDay++) {
	         dayOfMonth = (intWeek * 7) + intDay + dayOfMonthOfFirstSunday - 7;
		   	 if (dayOfMonth <= 0) {
	         	daysGrid += "<td>&nbsp;</td>";
		   	 }
		     else if (dayOfMonth <= intDaysInMonth) {
			   count++;
			   var dayClass = "";
			   if (day > 0 && day == dayOfMonth)
			   		dayClass="curDayCell";
			   daysGrid += '<td align="center" id=day' + count + ' name=day' + count + ' class=' + dayClass + '>';
			   // 将当日以红色显示
			   daysGrid += '<a href="#">';
			   var dayString = dayOfMonth;
			   if (dayString.length == 1)
			   		dayString = '0' + dayString;
			   daysGrid += dayString
			   daysGrid += "</a>";
			   daysGrid += "</td>";
		    }
	  }
      dayCountOfMonth = count;
	  var dayspan = dayOfMonth-count;
	  if (dayOfMonth < intDaysInMonth)
	  	daysGrid += "</tr>"
	  else
	  {
		if (dayspan<7 && dayspan>0){
			for (var k=0; k<dayspan; k++) {
				daysGrid += "<td>&nbsp;</td>"
			}
			daysGrid += "</tr>"
		}
	   }
   }
   return daysGrid + "</table>";
}

function setDay(dayOfMonth) {
}