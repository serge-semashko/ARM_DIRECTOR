"use strict";
var tm, atm;
var processActive = false;
var timeStamp = 0;
var url // = "http://127.0.0.1:9090/get_data&callback=?";
var dt;
var mainFont = '28pt Arial';
var smallFont = '7pt Arial';
var dvd = false;
var startTime = new Date();
var ncount = 0;
var ocount = 0;
var newtime = new Date().getTime();
var globalStart = new Date().getTime();
var reqStart = new Date().getTime();
var chupdating = [false, false, false, false, false];
var scrH, scrW;
var cv, ecv, dcv, evCanvas, dvCanvas;
var ProgrammColor = "#494747";
var ProgrammFontColor = "#FFFFFF";

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


function processData(t) {
    if (timeStamp > Number(t.timeStamp)) {
        return -1;
    }
    timeStamp = Number(t.timeStamp);
    setViewport();
    newtime = new Date().getTime();
    //        if ((newtime - starttime) < 30000) return;
    startTime = newtime;
    dcv.lineWidth = 4;
    ecv.lineWidth = 1;
    var ev, dv, as;
    t.dcvW = Number(t.dcvW);
    t.dcvH = Number(t.dcvH);
    t.ecvW = Number(t.ecvW);
    t.ecvH = Number(t.ecvH);
    var newDate = new Date();
    newDate.setDate(newDate.getDate());
    evCanvas.style.visibility = "hidden";
    dvCanvas.style.visibility = "hidden";
    //amchart process
    // evCanvas.width = t.ecvW;
    // evCanvas.height = t.ecvH;
    // dvCanvas.width = t.dcvW;
    // dvCanvas.height = t.dcvH;
    ecv.transform(1, 0, 0, 1, 0, 0);
    dcv.transform(1, 0, 0, 1, 0, 0);
    evCanvas.width = scrW;
    evCanvas.height = scrH * t.ecvH / (t.ecvH + t.dcvH);
    dvCanvas.width = scrW;
    dvCanvas.height = scrH * t.dcvH / (t.ecvH + t.dcvH);

    ecv.clearRect(0, 0, evCanvas.width, evCanvas.height);
    dcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
    ecv.fillStyle = "black";
    dcv.fillStyle = "black";
    ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
    dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
    var kx = scrW / t.ecvW;
    var ky = evCanvas.height / t.ecvH;
    ecv.transform(kx, 0, 0, ky, 0, 0);
    kx = scrW / t.dcvW;
    ky = dvCanvas.height / t.dcvH;

    dcv.transform(kx, 0, 0, ky, 0, 0);
    var events = t.Event;
    var airSecond = t.airSecond;
    var devs = t.Dev;
    //    console.log(argx + ' ');
    //    console.log('\nEvents: ' + JSON.stringify(devs));
    if (typeof (devs) != "undefined") {
        for (var i = 0; i < 200; i++) {
            dv = devs[i];
            if (typeof (dv) != "undefined") {
                //            console.log('\n=' + i + ' ' + JSON.stringify(dv));
                drawDev(dv);
            } else {
                //            console.log('\n=' + i + '  undef');

            }
        }
    }
    if (typeof (airSecond) != "undefined") {
        for (var i = 0; i < 200; i++) {
            as = airSecond[i];
            if (typeof (as) != "undefined") {
                //            console.log('\n=' + i + ' ' + JSON.stringify(dv));
                drawAirSecond(as, i);
            } else {
                //            console.log('\n=' + i + '  undef');

            }
        }
    }

    if (typeof (events) != "undefined") {
        for (var i = 1; i < 200; i++) {
            ev = events[i];
            if (typeof (ev) != "undefined") {
                //            console.log('\n=' + i + ' ' + JSON.stringify(dv));
                drawEvent(ev, i);
            } else {
                //            console.log('\n=' + i + '  undef');

            }
        }
    }
    if (typeof (events[0]) != "undefined") {
        drawEvent(events[0], -1);
    }
    if (t.Regim.length < 6) {
        ecv.fillStyle = "red";

    } else {
        ecv.fillStyle = "white";

    }
    ecv.font = mainFont;
    ecv.textAlign = "right";
    ecv.baseline = "middle";
    ev = events[0];
    if (typeof (ev) != "undefined") {
        ecv.fillText(t.Regim, ev.Right - 100, (Number(ev.Top) + Number(ev.Bottom)) / 2);
    }
    evCanvas.style.visibility = "visible";
    dvCanvas.style.visibility = "visible";

    // document.getElementById("main").style.visibility = true;

    //    console.log('\nEvents:' + JSON.stringify(events));

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
    scrW = window.innerWidth - 25;
    scrH = window.innerHeight - 25;

}
//var a = function () {
//    cv.width = window.innerWidth;
//    cv.height = window.innerHeight;
//
//}
addEventListener("keydown", myKeydown);

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


window.onload = function () {
    tm = document.getElementById("time");
    var dloc = document.location;
    var hostname;
    evCanvas = document.getElementById("evCanvas");

    evCanvas.left = 1;
    evCanvas.height = 599;
    evCanvas.width = 1920;
    ecv = evCanvas.getContext('2d');
    dvCanvas = document.getElementById("dvCanvas");
    dvCanvas.left = 1;
    dvCanvas.height = 139;
    dvCanvas.width = 1920;
    dcv = dvCanvas.getContext('2d');
    //    setViewport();
    //    setViewport();
    console.log(url);
    setViewport();
    evCanvas.width = scrW;
    evCanvas.height = scrH * 0.7;
    dvCanvas.width = scrW;
    dvCanvas.height = scrH * 0.3;

    ecv.clearRect(0, 0, evCanvas.width, evCanvas.height);
    dcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
    ecv.fillStyle = "black";
    dcv.fillStyle = "black";
    var newColor = rgbFromNum(255 * 0x100);
    var newColor1 = rgbFromNum(255);

    dcv.fillStyle = newColor;
    ecv.fillStyle = newColor1;
    dcv.globalAlpha = 0.9;
    ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
    dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
    var ctx = ecv;
    var text = "foo bar foo bar";
    ctx.font = "30pt Arial";
    ecv.fillStyle = "black";
        ctx.fillText(text, 100, 100);

    var width = ctx.measureText(text).width;
    var metrics = ctx.measureText("M");
    var height =   metrics.width; // ширина заглавной М считается равна высоте . Другого способа оценить высоту текста я не нашел
    ctx.save();
        ctx.scale(101/width,40/height);
        ctx.fillText(text, 100, 100);
        ctx.restore();
//    processData(testData);
};
function RGB2HTML(red, green, blue)
{
    var decColor = 0x1000000 + blue + 0x100 * green + 0x10000 * red;
    return '#' + decColor.toString(16).substr(1);
}
function rgbFromNum1(num) {
    var red = num >> 16;
    var green = (num & 0xFF00) >> 8;
    var blue = num & 255;
    var decColor = 0x1000000 + blue + 0x100 * green + 0x10000 * red;
    return '#' + decColor.toString(16).substr(1);
}
function rgbFromNum(num) {
    var red = (num & 0xFF0000) >> 16;
    var green = (num & 0xFF00) >> 8;
    var blue = num & 255;
    var decColor = 0x1000000 + red + 0x100 * green + 0x10000 * blue;
    return '#' + decColor.toString(16).substr(1);
}


// window.addEventListener('resize', setViewport, false);
