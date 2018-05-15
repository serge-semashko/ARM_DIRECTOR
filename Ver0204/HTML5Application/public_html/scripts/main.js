"use strict";
var tm, atm;
var timeStamp = 0;
var url // = "http://127.0.0.1:9090/get_data&callback=?";
var urlTail;
var LST;
var dt;
var mainFont = '28pt Arial';
var smallFont = '8pt Arial';
var dvd = false;
var startTime = new Date();
var ncount = 0;
var ocount = 0;
var newtime = new Date().getTime();
var globalStart = new Date().getTime();
var reqStart = new Date().getTime();
var chupdating = [false, false, false, false, false];
var scrH, scrW;
var cv, ecv, dcv, edcv, tlcv, evCanvas, dvCanvas, edCanvas, tvCanvas;
var mncv, tmcv, mnCanvas, tmCanvas, tempwidth;
var ProgrammColor = "#494747";
var ProgrammFontColor = "#FFFFFF";
var lastPhrase = "";
var lastTimeToStart = "";
var myInterval;
//Переменные для отображения тайм-линий и событий
var typesrc = "4"; //Вид экрана 0 - All, 1- ev+dv, 2
var currtlo; //текущая опция тайм линий
var currtlt; //события текущей тайм линии
var cfont = ProgrammFontColor;
var DevValue = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]; // секунды до следующего события          
var CurrEvent = 0; //текущее событие;
var CurrDevice = 4; // текущее устройство 
var NextDevice = 9; // следующее устройство

//var EventsBKGN = "black";
//var DevicesBKGN = "black";
var srccolor = 0;
var Background = rgbFromNum(srccolor);
var Foreground = smoothcolor(srccolor, 8);
var Foreground1 = smoothcolor(srccolor, 16);

var FrameSize = 1; //количество пиксилей на один фрейм
//var StartScrFrame = 250; //кадр в начале экрана 
//var FinishScrFrame = 850; //кадр в конце экрана
var LengthNameTL = 200;
var MyCursor = 100;
var CountEvents = 5; //количесто отображаемых событий

var WidthDevice = 80;
var IntervalDevice = 10;
var HeightDevice = 55;
var HOffsetDevice = 5;

var EventOffset = 30;
var ActiveTL = 0; //отображаемая тайм-линия
var ShowEditor = true;
var ShowScaler = true;
var ShowTimelines = true;
var ShowAllTimelines = true;
var ShowDevices = true;
var ShowEvents = true;
var ShowNameTL = true;
var ShowDev1 = true;
var ShowDev2 = true;
//ShowEvents, ShowDevices, ShowEditor, ShowScaler, ShowTimelines, ShowNameTL,
//ShowAllTimelines, ShowDev1, ShowDev2;
var DefaultScreen0 = [true, true, true, true, true, true, true, true, true];
var DefaultScreen1 = [true, true, false, false, false, false, false, false, false];
var DefaultScreen2 = [false, true, true, true, false, false, true, true, true];
var DefaultScreen3 = [true, false, false, false, false, false, true, true, true];
var DefaultScreen4 = [true, true, true, true, true, true, true, true, true];

var MaxFontSize = 40;

var EventsDev1 = 5;
var EventsDev2 = 5;
var Device1 = 14;
var Device2 = 2;
var ArrDev1 = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]; // номера событий устройства 1
var ArrDev2 = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]; // номера событий устройства 2  
var ScreenFields = [0, 1, 4, -1, -1];
//evCanvas, dvCanvas, edCanvas, tvCanvas, tmCanvas 
var UsesCanvas = [false, false, false, false, false];
var TimeLineHeight = 16;
var HeightMenu = 50;
var MenuProcent = 5;
var MenuDown = false;
var DownPosition = -1;
var MousePosition = -1;

var ClipName = "";
var SongName = "";
var SingerName = "";
var TimeToStart = "";

var Phrase = "";
var PhraseFactor = 1;
var StepPhrase = 50;
var PhraseMode = 2; //0 - text[files], 1 - text, 2 - files 
var files = [];
var dirvoice = "Default";

var DoubleSize = 0;

var RectSound = [0, 0, 0, 0];
var RectUp = [0, 0, 0, 0];
var RectDown = [0, 0, 0, 0];
var RectPlus = [0, 0, 0, 0];
var RectMinus = [0, 0, 0, 0];
var RectHome = [0, 0, 0, 0];
var mnSoundSelect = false;
var mnUpSelect = false;
var mnDownSelect = false;
var mnPlusSelect = false;
var mnMinusSelect = false;
var mnHomeSelect = false;

var AudioOn = false;
var audio = new Audio();
audio.playbackRate = 1.25;
var typeSpeeker = 0; //0 internal, 1 external
var FirstPhrase = false;

function toChart(txtval) {
    txtval = txtval.toString();
    var t6 = Number(txtval.replace(/,/g, "."))
    t6 = Number(t6.toFixed(2));
    return t6;
}

function intToRGB(i) {
    return i;
    //    ((i >> 24) & 0xFF).toString(16) +
    //    return "#" + ((i >> 16) & 0xFF).toString(16) +
    //        ((i >> 8) & 0xFF).toString(16) +
    //        (i & 0xFF).toString(16);
}

function textHeight(cv) {
    var metrics = cv.measureText("M");
    return metrics.width;
}

function textWidth(text, cv) {
    var metrics = cv.measureText(text);
    return metrics.width;
}
//var cfont, dtop, dleft, dh, dw, cpen, cbrush;

function rgbFromNum(num) {
    var red = (num & 0xFF0000) >> 16;
    var green = (num & 0xFF00) >> 8;
    var blue = num & 255;
    var decColor = 0x1000000 + red + 0x100 * green + 0x10000 * blue;
    return '#' + decColor.toString(16).substr(1);
}



function processData(t) {
    if (timeStamp > Number(t.timeStamp)) {
        return -1;
    }
    timeStamp = Number(t.timeStamp);
    setViewport();

    newtime = new Date().getTime();
    startTime = newtime;

    var newDate = new Date();
    newDate.setDate(newDate.getDate());

    if (ActiveTL !== -1) {
        //GetScreenBorders();
        GetCurrEvent();

        if (typesrc == "0") {
            SetTypeScreen0();
        } //end typesrc = 0;

        if (typesrc == "1") {
            SetTypeScreen1();
        } //end typesrc = 1;

        if (typesrc == "2") {
            SetTypeScreen2();
        } //end typesrc = 2;

        if (typesrc == "3") {
            SetTypeScreen3();
        } //end typesrc = 3;

        if (typesrc == "4") {
            SetTypeScreen4();
        } //end typesrc = 4;


    } else {
        screenNotEvents();
    } //end ActiveTL  
}

function objconv(indata) {
    var result = [];
    var sdate = indata[0];
    var ryear = '20' + sdate.substring(0, 2);
    var rmon = sdate.substring(3, 5);
    var rday = sdate.substring(6, 8);
    var rhour = sdate.substring(9, 11);
    var rmin = sdate.substring(12, 14);
    var rsec = sdate.substring(15, 17);
    //    //                        console.log(ryear + '.' + rmon + '.' + rday + '    ' + rhour + ':' + rmin + ':' + rsec);
    var rdate = new Date(Number(ryear), Number(rmon) - 1, rday, rhour, rmin, rsec);
    result[0] = rdate.getTime();
    for (var i = 1; i < indata.length; i++) {
        result[i] = toChart(indata[i]);

    }
    return result;
}

function setViewport() {
    window.fullScreen = true
    scrW = window.innerWidth - 10;
    //|| document.documentElement.clientWidth -25
    //|| document.body.clientWidth - 25;
    scrH = window.innerHeight - 10;

}
//var a = function () {
//    cv.width = window.innerWidth;
//    cv.height = window.innerHeight;
//
//}

function myKeydown(e) {
    // switch(e.keyCode){

    //     case 37:  // если нажата клавиша влево
    //         if(left>0)
    //             blueRect.style.marginLeft = left - 10 + "px";
    //         break;
    //     case 38:   // если нажата клавиша вверх
    //         if(top>0)
    //             blueRect.style.marginTop = top - 10 + "px";
    //         break;
    //     case 39:   // если нажата клавиша вправо
    //         if(left < document.documentElement.clientWidth - 100)
    //             blueRect.style.marginLeft = left + 10 + "px";
    //         break;
    //     case 40:   // если нажата клавиша вниз
    //         if(top < document.documentElement.clientHeight - 100)
    //             blueRect.style.marginTop = top + 10 + "px";
    //         break;
    // }
    var text = e.type +
            ' keyCode=' + e.keyCode +
            ' Code=' + e.code +
            ' which=' + e.which +
            ' charCode=' + e.charCode +
            ' char=' + String.fromCharCode(e.keyCode || e.charCode) +
            (e.shiftKey ? ' +shift' : '') +
            (e.ctrlKey ? ' +ctrl' : '') +
            (e.altKey ? ' +alt' : '') +
            (e.metaKey ? ' +meta' : '') + "\n";

//    alert(text + " " + JSON.stringify(e));
    console.log(text + " " + JSON.stringify(e));


}

var lastTime = Date.now();

function handle(e) {
    if (form.elements[e.type + 'Ignore'].checked)
        return;

    lastTime = Date.now();

    area.value += text;

}


var canvasPos = getPosition(mnCanvas);
var mouseX = 0;
var mouseY = 0;


function MyMouseDown(e) {
    mouseX = e.clientX - canvasPos.x;
    mouseY = e.clientY - canvasPos.y;
    DownPosition = mouseY;
    MousePosition = mouseY;
    MenuDown = true;
    if (mouseY < mnCanvas.height) {
        //MenuDown = true;
        //DownPosition = mouseY;  
        if (mouseX > RectSound[0] && mouseX < RectSound[2]) {
            mnSoundSelect = true;
        }
        if (mouseX > RectMinus[0] && mouseX < RectMinus[2]) {
            mnMinusSelect = true;
        }
        if (mouseX > RectPlus[0] && mouseX < RectPlus[2]) {
            mnPlusSelect = true;
        }
        if (mouseX > RectDown[0] && mouseX < RectDown[2]) {
            mnDownSelect = true;
        }
        if (mouseX > RectUp[0] && mouseX < RectUp[2]) {
            mnUpSelect = true;
        }
        if (mouseX > RectHome[0] && mouseX < RectHome[2]) {
            mnHomeSelect = true;
        }
    }
}

function MyMouseUp(e) {
    mouseX = e.clientX - canvasPos.x;
    mouseY = e.clientY - canvasPos.y;
    //var lf = RectSound[0];
    //var rt = RectSound[2];
    if (MenuDown) {
        
        var respos = mouseY - DownPosition;
        if (respos > ((window.innerHeight - 10) / 100) * 5) {
            MenuProcent = 100;
            //function sh() {
              // $("#mymenu").slideToggle("slow");
            //}
        } else {
            MenuProcent = 5;
        }
        ;
    }
    ;
    MenuDown = false;

    if (mouseY < mnCanvas.height) {
        if (mouseX > RectSound[0] && mouseX < RectSound[2]) {
            AudioOn = !AudioOn;
            mnSoundSelect = false;
            //if (AudioOn) {
            //  if (!audio.paused) {
            //    audio = 0;
            //    audio = new Audio();
            //    audio.playbackRate = 1.25;
            //  }  
            //}
        }
        if (mouseX > RectMinus[0] && mouseX < RectMinus[2]) {
            if (FrameSize > 1) {
                FrameSize = FrameSize - 1;
            } else {
                FrameSize = 1;
            }
            mnMinusSelect = false;
        }
        if (mouseX > RectPlus[0] && mouseX < RectPlus[2]) {
            if (FrameSize < 15) {
                FrameSize = FrameSize + 1;
            } else {
                FrameSize = 15;
            }
            mnPlusSelect = false;
        }
        if (mouseX > RectDown[0] && mouseX < RectDown[2]) {
            if (TimeLineHeight > 8) {
                TimeLineHeight = TimeLineHeight - 1;
            } else {
                TimeLineHeight = 8;
            }
            mnDownSelect = false;
        }
        if (mouseX > RectUp[0] && mouseX < RectUp[2]) {
            if (TimeLineHeight < 35) {
                TimeLineHeight = TimeLineHeight + 1;
            } else {
                TimeLineHeight = 35;
            }
            mnUpSelect = false;
        }
        if (mouseX > RectHome[0] && mouseX < RectHome[2]) {
            initControls();
            
//            clearInterval(myInterval)
            mnHomeSelect = false;
        }
    } else {

        var dv = ChoiceDevRect(mouseX, mouseY);
        if (dv !== -1) {
            Device1 = +dv + 1
            setDeviceNumber(Device1)
        }
        ;
        var tl = ChoiceTimelines(mouseY);
        if (tl !== -1) {
            ActiveTL = tl
        }
        ;
    }

}

function setMousePosition(e) {
    mouseX = e.clientX - canvasPos.x;
    mouseY = e.clientY - canvasPos.y;

    if (MenuDown) {
        var respos = mouseY - MousePosition;
        //var resstep = respos / 100;
        var dltproc = (respos * 100) / (window.innerHeight - 10);
        MenuProcent = MenuProcent + dltproc;
        if (MenuProcent > 50) {
            MenuProcent = 100;
        }
        ;
        if (MenuProcent < 5) {
            MenuProcent = 5;
        }
        ;
    }
    MousePosition = mouseY;

    if (mouseY < mnCanvas.height) {
        if (mouseX > RectSound[0] && mouseX < RectSound[2]) {
            mnSoundSelect = true;
        } else {
            mnSoundSelect = false;
        }
        if (mouseX > RectMinus[0] && mouseX < RectMinus[2]) {
            mnMinusSelect = true;
        } else {
            mnMinusSelect = false;
        }
        if (mouseX > RectPlus[0] && mouseX < RectPlus[2]) {
            mnPlusSelect = true;
        } else {
            mnPlusSelect = false;
        }
        if (mouseX > RectDown[0] && mouseX < RectDown[2]) {
            mnDownSelect = true;
        } else {
            mnDownSelect = false;
        }
        if (mouseX > RectUp[0] && mouseX < RectUp[2]) {
            mnUpSelect = true;
        } else {
            mnUpSelect = false;
        }
        if (mouseX > RectHome[0] && mouseX < RectHome[2]) {
            mnHomeSelect = true;
        } else {
            mnHomeSelect = false;
        }
    } else {
        mnSoundSelect = false;
        mnUpSelect = false;
        mnDownSelect = false;
        mnPlusSelect = false;
        mnMinusSelect = false;
        mnHomeSelect = false;
    }
}

function getPosition(el) {
    var xPosition = 0;
    var yPosition = 0;

    while (el) {
        xPosition += (el.offsetLeft - el.scrollLeft + el.clientLeft);
        yPosition += (el.offsetTop - el.scrollTop + el.clientTop);
        //xPosition += (el.clientLeft);
        //yPosition += (el.clientTop);
        el = el.offsetParent;
    }
    return {
        x: xPosition,
        y: yPosition
    };
}


function window_onload() {
    addEventListener("keydown", myKeydown);

    addEventListener('mousedown', MyMouseDown, false);
    addEventListener("mousemove", setMousePosition, false);
    addEventListener('mouseup', MyMouseUp, false);

    tm = document.getElementById("time");
    var dloc = document.location;
    var hostname;

    mnCanvas = document.getElementById("mnCanvas");
    mncv = mnCanvas.getContext('2d');

    evCanvas = document.getElementById("evCanvas");
    ecv = evCanvas.getContext('2d');

    dvCanvas = document.getElementById("dvCanvas");
    dcv = dvCanvas.getContext('2d');

    edCanvas = document.getElementById("edCanvas");
    edcv = edCanvas.getContext('2d');

    tvCanvas = document.getElementById("tvCanvas");
    tlcv = tvCanvas.getContext('2d');

    tmCanvas = document.getElementById("tmCanvas");
    tmcv = tmCanvas.getContext('2d');

    //processData(testData);

    myInterval = setInterval(changeTL, 40);

}
;

function changeTL() {
//    if ($("#select_scr").css("display") == "block") {
//        return;
    if (typeof newTLP == "undefined") {
        return;
    }
    if (typeof newTLT == "undefined") {
        return;
    }
    if (typeof newTLO == "undefined") {
        return;
    }
    TLP = newTLP;
    TLT = newTLT;
    TLO = newTLO;
    processData(testData);
    if (+TLP.Position >= +TLP.Finish) {
        TLP.Position = +TLP.Finish;
    }
}

// window.addEventListener('resize', setViewport, false);
