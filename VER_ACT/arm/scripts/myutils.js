/* 
 * Created by Zavialov on 14.01.2018.
 */


"use strict"

function GetSeconds(ps, fn) {
    var scnd = Math.floor((fn - ps) / 25);
    var ost = (fn - ps) % 25;
    if (ost > 0) {
        scnd = scnd + 1
    }
    return scnd;
}

function GetSecondsPhrase(ps, fn) {
    var scnd = Math.floor((fn - ps) / 25);
    var ost = (fn - ps) % 25;
    if (ost > 12) {
        scnd = scnd + 1;
    } else {
        scnd = 0;
    }
    return scnd;

//  var scnd = fn - ps
//  
//  if (scnd < 15) return 0;
//  if (scnd < 35) return 1;
//  if (scnd < 60) return 2; 
//  if (scnd < 85) return 3;
//  if (scnd < 110) return 4;
//  if (scnd < 135) return 5;
//  return 0;
}

function ClearDevValues() {
    for (var i = 0; i < 32; i++) {
        DevValue[i] = -1;
        ArrDev1[i] = -1;
        ArrDev2[i] = -1;
    }
}

function GetDevValues(ev) {
    var EvCount = TLT[ActiveTL].Count;
    //var Cnt = TLT.length;
    var Position = TLP.Position;
    var dv, cv, cev, scnd, cnt1, cnt2;
    // for (var i=0; i < 32; i++) { 
    //   DevValue[i] = -1; 
    //   ArrDev1[i] = -1;
    //   ArrDev2[i] = -1;
    cnt1 = 0;
    cnt2 = 0;
    // } 

    if (EvCount <= 0)
        return;

    for (var j = +ev; j < +EvCount; j++) {
        dv = TLT[ActiveTL].Events[j].Rows[0].Phrases[0].Data;
        //cev = cv["Phrases0"];
        //dv = cv;
        if (DevValue[dv - 1] == -1) {
            if (+j !== +ev && +j !== +EvCount - 1) {
                DevValue[dv - 1] = GetSeconds(Position, TLT[ActiveTL].Events[j].Start);
            } else {
                DevValue[dv - 1] = GetSeconds(Position, TLT[ActiveTL].Events[j].Finish);
            }
        }
        if (dv == Device1) {
            if (cnt1 < 32) {
                ArrDev1[cnt1] = j;
                cnt1 = +cnt1 + 1;
            }
        }
        if (dv == Device2) {
            if (cnt2 < 32) {
                ArrDev2[cnt2] = j;
                cnt2 = +cnt2 + 1;
            }
        }
    }
}

function GetCurrEvent() {
    if (typeof TLT[ActiveTL] == "undefined") {
        return -1;
    }
    var EvCount = TLT[ActiveTL].Count;
    var Position = TLP.Position;
    var strt, fnsh;
    var cv, cev;
    var tl = Number(TLT[ActiveTL].TypeTL);
    if (tl == 0) {
        ClearDevValues();
        for (var i = 0; i < EvCount; i++) {

            strt = TLT[ActiveTL].Events[i].Start;
            fnsh = TLT[ActiveTL].Events[i].Finish;
            if (+Position >= +strt && +fnsh >= +Position) {
                CurrEvent = i;
                cv = TLT[ActiveTL].Events[i].Rows[0].Phrases[0].Data;
                //cev = cv["Phrases0"];
                CurrDevice = cv;
                if (i == EvCount - 1) {
                    NextDevice = CurrDevice;
                } else {
                    cv = TLT[ActiveTL].Events[i + 1].Rows[0].Phrases[0].Data;
                    //cev = cv["Phrases0"];
                    NextDevice = cv;
                }
                GetDevValues(i);
                break;
            }
        }
    } else if (tl == 1) {

    } else if (tl == 2) {

    }
}

//function GetScreenBorders() {
//setViewport();
//var wdth = evCanvas.width;
//StartScrFrame = Math.floor(MyCursor / FrameSize);
//FinishScrFrame = Math.floor((wdth - LengthNameTL - MyCursor) / FrameSize); 
//}

function TwoDigit(zn) {
    var s = zn;
    if (+zn < 10) {
        s = "0" + s;
    }
    return s;
}

function SecondsToString(scnd) {
    var HH = Math.floor(scnd / 3600);
    var MM = Math.floor(scnd % 3600);
    var SS = Math.floor(MM % 60);
    var MM = Math.floor(MM / 60);
    var s = "";
    if (HH !== 0) {
        s = HH;
    }
    if (MM !== 0) {
        if (s !== "") {
            s = s + ":" + TwoDigit(MM);
        } else {
            s = MM;
        }
    }
    //if (SS !== 0) {
    if (s !== "") {
        s = s + ":" + TwoDigit(SS);
    } else {
        s = ":" + TwoDigit(SS);
    }
    //}
    return s;
}

function FramesToShortString(frm) {
    var HH, MM, SS, FF, dlt, fr;
    var st;
    if (frm < 0) {
        st = '-';
        fr = -1 * frm;
    } else {
        st = '';
        fr = frm;
    }
    dlt = Math.floor(fr / 25);
    FF = Math.floor(fr % 25);
    HH = Math.floor(dlt / 3600);
    MM = Math.floor(dlt % 3600);
    SS = Math.floor(MM % 60);
    MM = Math.floor(MM / 60);
    if (HH !== 0) {
        st = st + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) +
                ':' + TwoDigit(FF);
        return st.toString();
    }
    if (MM !== 0) {
        st = st + TwoDigit(MM) + ':' + TwoDigit(SS) + ':' + TwoDigit(FF);
        return st.toString();
    }
    st = st + TwoDigit(SS) + ':' + TwoDigit(FF);
    return st.toString();
}

function FramesToSecondString(frm) {
    var HH, MM, SS, FF, dlt, fr;
    var st;
    if (frm < 0) {
        st = '-';
        fr = -1 * frm;
    } else {
        st = '';
        fr = frm;
    }
    dlt = Math.floor(fr / 25);
    FF = Math.floor(fr % 25);
    HH = Math.floor(dlt / 3600);
    MM = Math.floor(dlt % 3600);
    SS = Math.floor(MM % 60);
    MM = Math.floor(MM / 60);
    if (HH !== 0) {
        st = st + HH + ':' + TwoDigit(MM) + ':' + TwoDigit(SS);
        return st.toString();
    }
    if (MM !== 0) {
        st = st + MM + ':' + TwoDigit(SS);
        return st.toString();
    }
    st = st + "0:" + TwoDigit(SS);
    return st.toString();
}


function FramesToStr(frm) {
    var ZN, HH, MM, SS, FF, dlt;
    var znak;

    ZN = frm;
    znak = "";
    if (frm < 0) {
        znak = "-";
        ZN = -1 * ZN;
    }
    dlt = Math.floor(ZN / 25);
    FF = Math.floor(ZN % 25);
    HH = Math.floor(dlt / 3600);
    MM = Math.floor(dlt % 3600);
    SS = Math.floor(MM % 60);
    MM = Math.floor(MM / 60);
    var result = znak + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) +
            ':' + TwoDigit(FF);
    return result;
}

//function zpad(tt) {
//    var str = tt.toString();
//    while (str.length < 2) {
//        str = '0' + str;
//    }
//    return str;
//}

//function SecondToShortStr(frm) {
//    var fr, st;
//    if (frm < 0) {
//        st = '-';
//        fr = -1 * frm;
//    } else {
//        st = '';
//        fr = frm;
//    }

//    var h = parseInt(fr / 3600);
//    var m = parseInt((fr - h * 3600) / 60);
//    var s = parseInt(fr - h * 3600 - m * 60);
//  if (h!=0) {
//    return  st + zpad(h)+':'+zpad(m)+':'+zpad(s);
//  }
//  if (m!=0) {
//    return  st + ':'+zpad(m)+':'+zpad(s);
//  }
//    return  st + ':'+zpad(s);
//
//}

function smoothcolor(Clr, step) {

    var result;
    var r = (Clr & 0xFF0000) >> 16;
    var g = (Clr & 0xFF00) >> 8;
    var b = Clr & 255;

    if (r >= g && r >= b) {
        if (r + step <= 255) {
            r = r + step;
            g = g + step;
            b = b + step;
        } else {
            if (r - step > 0) {
                r = r - step;
            } else {
                r = 0;
            }
            if (g - step > 0) {
                g = g - step;
            } else {
                g = 0;
            }
            if (b - step > 0) {
                b = b - step;
            } else {
                b = 0;
            }
        }
        result = 0x1000000 + r + 0x100 * g + 0x10000 * b;
        return '#' + result.toString(16).substr(1);
    }

    if (g >= r && g >= b) {
        if (g + step <= 255) {
            r = r + step;
            g = g + step;
            b = b + step;
        } else {
            if (r - step > 0) {
                r = r - step;
            } else {
                r = 0;
            }
            if (g - step > 0) {
                g = g - step;
            } else {
                g = 0;
            }
            if (b - step > 0) {
                b = b - step;
            } else {
                b = 0;
            }
        }
        result = 0x1000000 + r + 0x100 * g + 0x10000 * b;
        return '#' + result.toString(16).substr(1);
    }

    if (b >= r && b >= g) {
        if (b + step <= 255) {
            r = r + step;
            g = g + step;
            b = b + step;
        } else {
            if (r - step > 0) {
                r = r - step;
            } else {
                r = 0;
            }
            if (g - step > 0) {
                g = g - step;
            } else {
                g = 0;
            }
            if (b - step > 0) {
                b = b - step;
            } else {
                b = 0;
            }
            result = 0x1000000 + r + 0x100 * g + 0x10000 * b;
            return '#' + result.toString(16).substr(1);
        }
    }
}

//Определение координат элемента на страницы
function getElementPosition(elemId) {
    var elem = typeof elemId == 'object' ? elemId : document.getElementById(elemId);

    var w = elem.offsetWidth;
    var h = elem.offsetHeight;

    var l = 0;
    var t = 0;

    while (elem)
    {
        l += elem.offsetLeft;
        t += elem.offsetTop;
        elem = elem.offsetParent;
    }

    return {"left": l, "top": t, "width": w, "height": h};
}

//Определение текущих координат указателя мыши
function mousePageXY(e) {
    var x = 0, y = 0;

    if (!e)
        e = window.event;

    if (e.pageX || e.pageY) {
        x = e.pageX;
        y = e.pageY;
    } else if (e.clientX || e.clientY) {
        x = e.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)
                - document.documentElement.clientLeft;
        y = e.clientY + (document.documentElement.scrollTop || document.body.scrollTop)
                - document.documentElement.clientTop;
    }

    return {"left": x, "top": y};
}

function myTextDraw(cv, Text, Left, OffsetX, Width, Top, Height) {
    var lentext = cv.measureText(Text).width;//textWidth(Text, cv) + 2 * OffsetX;
    var fnwidth = cv.measureText(Text).width;
    var fnheight = Height;//metrics.width; 
    //var delx = 1;
    //if (OffsetX !== 0) { delx = OffsetX; } 
    var XLeft = Math.floor(OffsetX / 10) * 10;
    var kx = (Width - 2 * XLeft) / fnwidth;
    var ky = Height / fnheight;
    cv.save();
    cv.scale((Width - 2 * XLeft) / fnwidth, Height / fnheight);
    cv.fillText(Text, (+Left + +OffsetX) / kx, (+Top + Height / 2) / ky);
    cv.restore();
    cv.scale(1, 1);
}

function rectRound(cv, x, y, wdt, hgh, rds, color1, color2) {
    cv.beginPath();
    cv.fillStyle = color1;
    cv.strokeStyle = color2;
    cv.moveTo(x + rds, y);
    cv.lineTo(x + wdt - rds, y);
    cv.quadraticCurveTo(x + wdt, y, x + wdt, y + rds);
    cv.lineTo(x + wdt, y + hgh - rds);
    cv.quadraticCurveTo(x + wdt, y + hgh, x + wdt - rds, y + hgh);
    cv.lineTo(x + rds, y + hgh);
    cv.quadraticCurveTo(x, y + hgh, x, y + hgh - rds);
    cv.lineTo(x, y + rds);
    cv.quadraticCurveTo(x, y, x + rds, y);
    cv.stroke();
    cv.closePath();
    cv.fill();
}

function rectHalfRound(cv, x, y, wdt, hgh, rds, color1, color2) {
    cv.beginPath();
    cv.fillStyle = color1;
    cv.strokeStyle = color2;
    cv.moveTo(x + rds, y);
    cv.lineTo(x + wdt, y);
    cv.lineTo(x + wdt, y + hgh);
    cv.lineTo(x + rds, y + hgh);
    cv.quadraticCurveTo(x, y + hgh, x, y + hgh - rds);
    cv.lineTo(x, y + rds);
    cv.quadraticCurveTo(x, y, x + rds, y);
    cv.stroke();
    cv.closePath();
    cv.fill();
}

function isShowTimelines() {
    var res = false;
    if (+typesrc == 0) {
        res = DefaultScreen0[2] || DefaultScreen0[3] || DefaultScreen0[4];
    } else if (+typesrc == 1) {
        res = DefaultScreen1[2] || DefaultScreen1[3] || DefaultScreen1[4];
    } else if (+typesrc == 4) {
        for (var i = 0; i < 5; i++) {
            if (+ScreenFields[i] == 2) {
                res = true;
                break;
            }
        }
        ;
        //res = DefaultScreen4[2] || DefaultScreen4[3] || DefaultScreen4[4];  
    }
	if (res) {
		if (language == "RUS") {
		    $("#txtimgtlsize").text("Размер тайм-линии");	
		} else {
			$("#txtimgtlsize").text("Size of timeline");
		}
		$("#imgdowntlsize").css("visibility","visible");
		$("#imguptlsize").css("visibility","visible");
		$("#txttlsize").text(TimeLineHeight + "px");
	} else {
		$("#txtimgtlsize").text("");	
		$("#imgdowntlsize").css("visibility","hidden");
		$("#imguptlsize").css("visibility","hidden");
		$("#txttlsize").text("");
	}

}

function drawToolBar(cv, Width, Height) {
    var MyHeight = ((window.innerHeight - 10) / 100) * 5;
    var MColor = ProgrammColor;
    var SColor = smoothcolor(ProgrammColor, 128);
    var lwdt = cv.lineWidth;
    var font0 = Math.floor((MyHeight - 8) / 2) + "pt Arial";
    var font1 = Math.floor(MyHeight / 2) + "pt Arial";
    var font2 = Math.floor(MyHeight / 5 * 2) + "pt Arial";

    var stepw = MyHeight;

    if (Width < 24 * MyHeight + 40) {
        stepw = (Width - 40) / 22;
    }

    cv.font = font0;//Math.floor((Height-8) / 2) +  "pt Arial";

    var loffset = 0.5 * stepw;
    cv.lineWidth = 4;

    cv.textBaseline = "middle";
    cv.textAlign = "center";
    cv.fillStyle = "white";
    cv.font = font2;//Math.floor(Height/2) +  "pt Arial";

    //var text = "00000";
    var otstup = 20 + +stepw + 1 * stepw;//cv.measureText(text).width;
    cv.textAlign = "left";
    var text = "Размер кадра:";
    var len = cv.measureText(text).width;
    if (len < 4.5 * stepw - 5) {
        cv.fillText(text, otstup, 3 + (MyHeight - 10) / 2);
    } else {
        myTextDraw(cv, text, otstup, 0, 4.5 * stepw - 5, 3, MyHeight - 10);
    }
    //cv.fillText(text, otstup + MyHeight/2, 3 + (MyHeight-10) / 2);

   //========================================
//  var dlty = (MyHeight-10) / 5;
    //cv.fillText("+", otstup + MyHeight/2, 3 + (MyHeight-10) / 2);

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
    if (isShowTimelines()) {
        otstup = +otstup + +stepw + 1 * stepw;//cv.measureText("00000").width;
        cv.font = font2;
        cv.textAlign = "left";
        text = "Высота тайм-линии:";
        var len = cv.measureText(text).width;
        if (len < 6 * stepw - 5) {
            cv.fillText(text, otstup, 3 + (MyHeight - 10) / 2);
        } else {
            myTextDraw(cv, text, otstup, 0, 6 * stepw - 5, 3, MyHeight - 10);
        }
        otstup = +otstup + 5.6 * stepw + 15;

        cv.font = font1;
        cv.textAlign = "center";

        RectDown[0] = otstup - 5;
        RectDown[1] = 3;
        RectDown[2] = +otstup + +stepw + 10;
        RectDown[3] = MyHeight - 10;

        if (mnDownSelect) {
            rectRound(cv, otstup - 5, 3, +stepw + 10, MyHeight - 10, (MyHeight - 10) / 2, SColor, SColor);
        } else {
            //rectRound(cv, otstup, 3, MyHeight, MyHeight-10, (MyHeight-10)/2, MColor, "white");
        }

        //========================================
        //var dlty = (MyHeight-10) / 5;
        //var dltx = MyHeight / 5;
        cv.lineWidth = 1;
        cv.beginPath();
        cv.strokeStyle = "white";
        cv.fillStyle = "white";
        cv.moveTo(+otstup + dltx, 2 * dlty);
        cv.lineTo(+otstup + 4 * dltx, 2 * dlty);
        cv.lineTo(+otstup + 2.5 * dltx, 4 * dlty);
        cv.lineTo(+otstup + dltx, 2 * dlty);
        cv.stroke();
        cv.closePath();
        cv.fill();
//========================================
        //rectRound(cv, otstup, 3, MyHeight, MyHeight-10, (MyHeight-10)/2, ProgrammColor, "white");
        //cv.fillStyle = "white";
        //cv.fillText("-", otstup + MyHeight/2, 2 + (MyHeight-10) / 2);

        cv.font = font2;
        otstup = otstup + stepw;

        var text = TimeLineHeight + "px";
        var len = cv.measureText(text).width;
        if (len < 1.5 * stepw - 4) {
            cv.fillText(text, +otstup + 0.75 * stepw, 3 + (MyHeight - 10) / 2);
        } else {
            cv.textAlign = "left";
            myTextDraw(cv, text, otstup, 2, 1.5 * stepw - 4, 3, MyHeight - 10);
        }

        cv.font = font2;
        otstup = +otstup + 1.5 * stepw;

        RectUp[0] = otstup - 5;
        RectUp[1] = 3;
        RectUp[2] = +otstup + +stepw + 10;
        RectUp[3] = MyHeight - 10;

        if (mnUpSelect) {
            rectRound(cv, otstup - 5, 3, +stepw + 10, MyHeight - 10, (MyHeight - 10) / 2, SColor, SColor);
        } else {
            //rectRound(cv, otstup, 3, MyHeight, MyHeight-10, (MyHeight-10)/2, MColor, "white");
        }
//========================================
//  var dlty = (MyHeight-10) / 5;
//  var dltx = MyHeight / 5;
        cv.lineWidth = 1;
        cv.beginPath();
        cv.strokeStyle = "white";
        cv.fillStyle = "white";
        cv.moveTo(+otstup + dltx, 4 * dlty);
        cv.lineTo(+otstup + 4 * dltx, 4 * dlty);
        cv.lineTo(+otstup + 2.5 * dltx, 2 * dlty);
        cv.lineTo(+otstup + dltx, 4 * dlty);
        cv.stroke();
        cv.closePath();
        cv.fill();

    }
}

function ReadVoices() {
//  var fs = require("fs");
//  var fileContent = fs.readFileSync("phrases\voices.txt", "utf8");
//  console.log(fileContent); 
//
//var fname = "voices.txt";
//var fso = new ActiveXObject("Scripting.FileSystemObject");
//if (!fso.FileExists(fname)) return;
//var f = fso.OpenTextFile(fname, 1, "True");
//var i = 0; 
//var s = [];
//while (!f.AtEndOfStream) {
//  s[i] = f.ReadLine();
//  i++;
//}
//f.Close();  
    readTextFile("phrases/voices.txt")
}

function readTextFile(file) {

    var objSel = document.getElementById("voice_0");
    objSel.options.length = 0;

    if (intVoices.length <= 0) {
        dirvoice == "Default";
        objSel.options[objSel.options.length] = new Option("Default", "Default");
        objSel.selectedIndex = 0;
    } else {
        for (var i = 0; i < intVoices.length; i++) {
            objSel.options[objSel.options.length] = new Option(intVoices[i].trim(), intVoices[i].trim());
        }
        if (dirvoice == "") {
            objSel.selectedIndex = 0;
        } else {
            for (var i = 0; i < objSel.options.length; i++) {
                if (objSel.options[i].text == dirvoice) {
                    objSel.selectedIndex = i;
                    break;
                }
            }
        }
    }
}

function msecToTimecode(msec) {
	var tm = new Date(msec);
	var Hour = tm.getHours();
    var Minutes = tm.getMinutes();
    var Seconds = tm.getSeconds();
	var MSeconds = tm.getMilliseconds();
	var MSec = Math.floor(MSeconds / 40);
	return TwoDigit(Hour) + ":" + TwoDigit(Minutes) + ":" + TwoDigit(Seconds) + ":" + TwoDigit(MSec); 
} 

function setLanguage(lang) {
	language = lang;
	$('.idlanguage').text(lang);
	localStorage.setItem("language",lang);
	if (lang == "RUS") {
		$('.rusflag').fadeTo(0, 1);
		$('.engflag').fadeTo(0, 0.4);
		$('.lbserverStatus').text("Cервер:");
		$('#lblocaltime').text("Время устройства");
		$('#lbsystime').text("Время синхронизации системы");
		var str = $('#statussynch').text();
		if (str == "Требуется синхронизация" || str == "Synchronization is required") $('#statussynch').text("Требуется синхронизация"); 
		if (str == "Синхронизация" || str == "Synchronization") $('#statussynch').text("Синхронизация");
		if (str == "Синхронизация проводилась" || str == "Synchronization was carried out") $('#statussynch').text("Синхронизация проводилась");
		if (str == "Синхронизация остановлена" || str == "Synchronization is stopped") $('#statussynch').text("Синхронизация остановлена");
		$('#synchrotime').text("Синхронизировать с сервером");
		$('#inputprog').text("Выйти из режима синхронизации");
		$('#lbsynchvisible').text("Не показывать окно при входе в систему");
		
		$('#opttypescreen').text("Тип экрана");
		$('#txtscreen1').text("Полный экран");
		$('#txtscreen2').text("События, устройства");
		$('#txtscreen3').text("Настраиваемый экран");
		$('#myinfo').html("Для выбора экрана<br>нажмите<br>на его изображение.");
		$('#lboptssetscr').text("Параметры настраевомого экрана");
		$('#txt_scr_1').text("1 Поле");
		$('#txt_scr_2').text("2 Поле");
		$('#txt_scr_3').text("3 Поле");
		$('#txt_scr_4').text("4 Поле");
		$('#txt_scr_5').text("5 Поле");
		$('#optvoices').text("Cинтезатор голоса");
		$('#typevoice0').text("Встроенный");
		$('#typevoice1').text("Внешний");
		$('#opttimelines').text("Тайм-линии");
		$('#tlscaler').text("Шкала времени");
		$('#tlselect').text("Выбранная тайм-линия");
		$('#tllist').text("Список тайм-линий");
		$('#tlnames').text("Название тайм-линий");
		$('#optevents').text("События");
		$('#txtEvCount').text("Кол-во отображаемых событий");
		$('#nmnumber').text("Номер");
		$('#nmamount').text("Кол-во");
		$('#txtdevice1').text("Устройство 1");
		$('#txtdevice2').text("Устройство 2");
		$('#gowinsynch').val("Перейти в окно синхронизации");
		
	} else {
		$('.rusflag').fadeTo(0, 0.4);
		$('.engflag').fadeTo(0, 1);
		$('.lbserverStatus').text("Server:");
		$('#lblocaltime').text("Time of device");
		$('#lbsystime').text("Time of system synchronization");
		var str = $('#statussynch').text();
		if (str == "Требуется синхронизация" || str == "Synchronization is required") $('#statussynch').text("Synchronization is required"); 
		if (str == "Синхронизация" || str == "Synchronization") $('#statussynch').text("Synchronization");
		if (str == "Синхронизация проводилась" || str == "Synchronization was carried out") $('#statussynch').text("Synchronization was carried out");
		if (str == "Синхронизация остановлена" || str == "Synchronization is stopped") $('#statussynch').text("Synchronization is stopped");
		$('#synchrotime').text("To synchronize with the server");
		$('#inputprog').text("To leave the synchronization mode");
		$('#lbsynchvisible').text("Doesn't show the window at login");
		
		$('#opttypescreen').text("Type of the screen");
		$('#txtscreen1').text("Full screen");
		$('#txtscreen2').text("Events, devices");
		$('#txtscreen3').text("The adjusted screen");
		$('#myinfo').html("Click on image<br>of the screen<br>for its choice.");
		$('#lboptssetscr').text("Options of the adjusted screen");
		$('#txt_scr_1').text("1 Field");
		$('#txt_scr_2').text("2 Field");
		$('#txt_scr_3').text("3 Field");
		$('#txt_scr_4').text("4 Field");
		$('#txt_scr_5').text("5 Field");
		$('#optvoices').text("Voice synthesizer");
		$('#typevoice0').text("Built-in");
		$('#typevoice1').text("External");
		$('#opttimelines').text("Timelines");
		$('#tlscaler').text("Time scale");
		$('#tlselect').text("The chosen time line");
		$('#tllist').text("List of timelines");
		$('#tlnames').text("Names of timelines");
		$('#optevents').text("Events");
		$('#txtEvCount').text("The number of the displayed events");
		$('#nmnumber').text("Number");
		$('#nmamount').text("Amount");
		$('#txtdevice1').text("Device 1");
		$('#txtdevice2').text("Device 2");
		$('#gowinsynch').val("Go to the window of synchronization");
	}
	updSelectLanguage("scr_1");
	updSelectLanguage("scr_2");
	updSelectLanguage("scr_3");
	updSelectLanguage("scr_4");
	updSelectLanguage("scr_5");
}

function goToProgramm() {
	$("#main").css("display", "hide");
	$("#startpanel").css("display", "none");
    $("#select_scr").css("display", "block");
}

function setStartSynch() {
	if ($('#synchvisible').is(':checked')) {
		localStorage.setItem("startsynch","no");
	} else {
		localStorage.setItem("startsynch","yes");
	}
}

function showWinSynch() {
	$("#main").css("display", "hide");
	$("#select_scr").css("display", "none");
	$("#startpanel").css("display", "flex");
    
	//evCanvas.style.visibility = "hidden";
    //dvCanvas.style.visibility = "hidden";
    //edCanvas.style.visibility = "hidden";
    //tvCanvas.style.visibility = "hidden";
    //tmCanvas.style.visibility = "hidden";
	
}

function updSelectLanguage(id) {
	var idtxt = '#' + id;
	var selopt = $(idtxt).val();
	$(idtxt).empty();
	if (language == "RUS") {
		for (var i=0; i<listOptionsRUS.length; i++) {
			var optval = i - 1;
			var str="<option value='" + optval + "'>" + listOptionsRUS[i] + "</option>";
		    $(idtxt).append( $(str));	
		}
	} else {
		for (var i=0; i<listOptionsENG.length; i++) {
			var optval = i - 1;
			var str="<option value='" + optval + "'>" + listOptionsENG[i] + "</option>";
		    $(idtxt).append( $(str));	
		}
	}
	var addopt = idtxt + " option[value='" + selopt + "']";
	$(addopt).attr("selected", "selected");
	var selopt = $(idtxt).val();
}

function saveToLocalStorage() {
	localStorage["TimeLineHeight"] = TimeLineHeight;
	localStorage["FrameSize"] = FrameSize;
	
	localStorage["deltaSysTime"] = deltaSysTime;
	localStorage["typesrc"] = typesrc;
	localStorage["typeSpeeker"] = typeSpeeker;
	localStorage["dirvoice"] = dirvoice;
	//localStorage["indexVoiceExt"] = indexVoiceExt;
	localStorage["CountEvents"] = CountEvents;
	localStorage["EventsDev1"] = EventsDev1;
    localStorage["EventsDev2"] = EventsDev2;
    localStorage["Device1"] = Device1;
    localStorage["Device2"] = Device2;
	var str = JSON.stringify(DefaultScreen4);
	localStorage["DefaultScreen4"] = str;
	var str = JSON.stringify(ScreenFields);
	localStorage["ScreenFields"] = str;
	str =str;
}

function loadFromLocalStorage() {
	var res = localStorage.getItem("TimeLineHeight");
	if (res !== null) TimeLineHeight = +res;
	$('#txttlsize').text(TimeLineHeight + "px");
	var res = localStorage.getItem("FrameSize");
	if (res !== null) FrameSize = +res;
	$('#txtfsize').text(FrameSize + "px");
	var res = localStorage.getItem("deltaSysTime");
	if (res !== null) deltaSysTime = +res;
	var res = localStorage.getItem("typesrc");
    if (res !== null) typesrc = +res;
	setActiveScreen(typesrc);
	isShowTimelines();
	var res = localStorage.getItem("typeSpeeker");
	if (res !== null) typeSpeeker = +res;
	var res = localStorage.getItem("dirvoice");
	if (res !== null) dirvoice = res;
	//var res = localStorage.getItem("indexVoiceExt");
	//if (res !== null) indexVoiceExt = +res;
	var res = localStorage.getItem("CountEvents");
	if (res !== null) CountEvents = +res;
	var res = localStorage.getItem("EventsDev1");
	if (res !== null) EventsDev1 = +res;
    var res = localStorage.getItem("EventsDev2");
	if (res !== null) EventsDev2 = +res;
    var res = localStorage.getItem("Device1");
	if (res !== null) Device1 = +res;
    var res = localStorage.getItem("Device2");
	if (res !== null) Device2 = +res;
	var res = localStorage.getItem("DefaultScreen4")
	if (res !== null) DefaultScreen4 = JSON.parse(res);
	var res = localStorage.getItem("ScreenFields");
	if (res !== null) ScreenFields = JSON.parse(res);
}

function changeOptions(nom) {
	
	switch(+nom) {
        case 0:  
            ScreenFields[0] = +document.getElementById("scr_1").options.selectedIndex - 1;
        break;
        case 1:  // if (x === 'value2')
			ScreenFields[1] = +document.getElementById("scr_2").options.selectedIndex - 1;
        break;
        case 2:
            ScreenFields[2] = +document.getElementById("scr_3").options.selectedIndex - 1;
        break
		case 3:
            ScreenFields[3] = +document.getElementById("scr_4").options.selectedIndex - 1;
        break
		case 4:
            ScreenFields[4] = +document.getElementById("scr_5").options.selectedIndex - 1;
        break
		case 5:
		   //$('input:radio[name=gender]')
           typeSpeeker = $('#extVoice:checked').val();
        break
		case 6:
		    dirvoice = $("#voice_0 option:selected").text();
        break
		case 7:
		    var tmp = $("#voice_1 option:selected").text();//tmp = $('#voice_1').val();
			if (tmp == undefined || tmp == NaN) tmp = "";
            indexVoiceExt = tmp;
        break
		case 8:
            CountEvents = +document.getElementById("CountEvents").value;
        break
		case 9:
            Device1 = +document.getElementById("dev1").value;
        break
		case 10:
            Device2 = +document.getElementById("dev2").value;
        break
		case 11:
            EventsDev1 = +document.getElementById("dev1CountEvents").value;
        break
		case 12:
            EventsDev2 = +document.getElementById("dev2CountEvents").value;
        break
		case 13:
            DefaultScreen4[3] = document.getElementById("chk4_1").checked;
        break
		case 14:
            DefaultScreen4[2] = document.getElementById("chk4_2").checked;
        break
		case 15:
            DefaultScreen4[4] = document.getElementById("chk4_3").checked;
        break
		case 16:
            DefaultScreen4[5] = document.getElementById("chk4_4").checked;
        break
		case 17:
		    var tmp = $('#ActiveTL').val();
			if (tmp == undefined || tmp == NaN) tmp = -1;
            ActiveTL = tmp;
        break
    }
	saveToLocalStorage()
}

function srcImageAudioOnOff() {
	if(AudioOn) {
	    $("#imgaudioonoff").attr('src', 'images/audioon.png'); 	
	} else {
		$("#imgaudioonoff").attr('src', 'images/audiooff.png');
	}
}

function clickAudioOnOff() {
	AudioOn = !AudioOn;
	srcImageAudioOnOff();
}

function clickFrameSizeUp() {
	FrameSize = FrameSize + 1;
	if (FrameSize > 15) FrameSize = 15;
	$('#txtfsize').text(FrameSize + "px");
	saveToLocalStorage()
}

function clickFrameSizeDown() {
	FrameSize = FrameSize - 1;
	if (FrameSize <= 0) FrameSize = 1;
	$('#txtfsize').text(FrameSize + "px");
	saveToLocalStorage()
}

function clickTLSizeUp() {
	TimeLineHeight = TimeLineHeight + 1;
	if (TimeLineHeight > 45) TimeLineHeight = 45;
	$('#txttlsize').text(TimeLineHeight + "px");
	saveToLocalStorage()
}

function clickTLSizeDown() {
	TimeLineHeight = TimeLineHeight - 1;
	if (TimeLineHeight <= 12) TimeLineHeight = 12;
	$('#txttlsize').text(TimeLineHeight + "px");
	saveToLocalStorage()
}