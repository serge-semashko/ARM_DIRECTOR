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
    var argx = newDate.format("H:i:s");
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

function getAllData() {

    //console.log("\n###Agetson nucloweb start");
    ncount++;
    dt = new Date().getTime() - globalStart;

    atm.html(" nc=" + ncount + " oc=" + ocount + " " + dt);

    $.ajax({
        type: "POST",
        dataType: "json",
        url: url,
        data: {
            "get_member": "id"
        },
        success: function (t) {
            {
                var tm = $("#time");
                tm.html(parseInt(ncount * 1000 / dt) + " " + parseInt(ocount * 1000 / dt) + " req=" + ncount + " answer=" + ocount + " dt=" + dt);
                globalStart = new Date().getTime();
//                ocount = 0;
//                ncount = 0;
            }
            if (processActive) {
                return -1;
            }
            processActive = true;
            processData(t);
            processActive = false;
            ocount++;
        },
        error: function (error) {
            console.log("\n####AJAX  error:" + JSON.stringify(error));

        }
    })

    //                        //console.log('\n step chart 4 1\n');


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


    console.log(text + " " + JSON.stringify(e));


}
document.onclick = function (eeer) {
    tm = document.getElementById("time");
    if (tm.style.display == "none") {
        tm.style.display = "block"
    } else {
        tm.style.display = "none"
    }
    tm = document.getElementById("atime");
    if (tm.style.display == "none") {
        tm.style.display = "block"
    } else {
        tm.style.display = "none"
    }
}


var lastTime = Date.now();

function handle(e) {
    if (form.elements[e.type + 'Ignore'].checked) return;

    lastTime = Date.now();

    area.value += text;

}


window.onload = function () {
    tm = document.getElementById("time");
    atm = $("#atime");
    var dloc = document.location;
    var hostname;
    if (dloc.hostname.length < 3) {
        hostname = "localhost";
    } else {
        hostname = dloc.hostname;
    }
    console.log(hostname + " ");
    url = "http://" + hostname + ":9090/get_data&callback=?";
    //    getAllData();
    console.log(url);
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
    ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
    dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);

    setInterval(getAllData, 100);
};
// window.addEventListener('resize', setViewport, false);


function getDate() {
    //    var e = new Date,
    //        r = e.getFullYear(),
    //        o = e.getMonth() + 1,
    //        t = e.getDate(),
    //        a = e.getHours(),
    //        i = e.getMinutes(),
    //        d = e.getSeconds();
    //    d < 10 && (d = "0" + d), i < 10 && (i = "0" + i), r < 10 && (r = "0" + r), o < 10 && (o = "0" + o), t < 10 && (t = "0" + t), document.getElementById("timedisplay").innerHTML = t + "." + o + "." + r + "\t" + a + ":" + i + ":" + d
}
//setInterval(getDate, 1000);
Date.prototype.format = function (format) {
    var returnStr = '';
    var replace = Date.replaceChars;
    for (var i = 0; i < format.length; i++) {
        var curChar = format.charAt(i);
        if (i - 1 >= 0 && format.charAt(i - 1) == "\\") {
            returnStr += curChar;
        } else if (replace[curChar]) {
            returnStr += replace[curChar].call(this);
        } else if (curChar != "\\") {
            returnStr += curChar;
        }
    }
    return returnStr;
};

Date.replaceChars = {
    shortMonths: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    longMonths: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    shortDays: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    longDays: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],

    // Day
    d: function () {
        return (this.getDate() < 10 ? '0' : '') + this.getDate();
    },
    D: function () {
        return Date.replaceChars.shortDays[this.getDay()];
    },
    j: function () {
        return this.getDate();
    },
    l: function () {
        return Date.replaceChars.longDays[this.getDay()];
    },
    N: function () {
        return this.getDay() + 1;
    },
    S: function () {
        return (this.getDate() % 10 == 1 && this.getDate() != 11 ? 'st' : (this.getDate() % 10 == 2 && this.getDate() != 12 ? 'nd' : (this.getDate() % 10 == 3 && this.getDate() != 13 ? 'rd' : 'th')));
    },
    w: function () {
        return this.getDay();
    },
    z: function () {
        var d = new Date(this.getFullYear(), 0, 1);
        return Math.ceil((this - d) / 86400000);
    }, // Fixed now
    // Week
    W: function () {
        var d = new Date(this.getFullYear(), 0, 1);
        return Math.ceil((((this - d) / 86400000) + d.getDay() + 1) / 7);
    }, // Fixed now
    // Month
    F: function () {
        return Date.replaceChars.longMonths[this.getMonth()];
    },
    m: function () {
        return (this.getMonth() < 9 ? '0' : '') + (this.getMonth() + 1);
    },
    M: function () {
        return Date.replaceChars.shortMonths[this.getMonth()];
    },
    n: function () {
        return this.getMonth() + 1;
    },
    t: function () {
        var d = new Date();
        return new Date(d.getFullYear(), d.getMonth(), 0).getDate()
    }, // Fixed now, gets #days of date
    // Year
    L: function () {
        var year = this.getFullYear();
        return (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0));
    }, // Fixed now
    o: function () {
        var d = new Date(this.valueOf());
        d.setDate(d.getDate() - ((this.getDay() + 6) % 7) + 3);
        return d.getFullYear();
    }, //Fixed now
    Y: function () {
        return this.getFullYear();
    },
    y: function () {
        return ('' + this.getFullYear()).substr(2);
    },
    // Time
    a: function () {
        return this.getHours() < 12 ? 'am' : 'pm';
    },
    A: function () {
        return this.getHours() < 12 ? 'AM' : 'PM';
    },
    B: function () {
        return Math.floor((((this.getUTCHours() + 1) % 24) + this.getUTCMinutes() / 60 + this.getUTCSeconds() / 3600) * 1000 / 24);
    }, // Fixed now
    g: function () {
        return this.getHours() % 12 || 12;
    },
    G: function () {
        return this.getHours();
    },
    h: function () {
        return ((this.getHours() % 12 || 12) < 10 ? '0' : '') + (this.getHours() % 12 || 12);
    },
    H: function () {
        return (this.getHours() < 10 ? '0' : '') + this.getHours();
    },
    i: function () {
        return (this.getMinutes() < 10 ? '0' : '') + this.getMinutes();
    },
    s: function () {
        return (this.getSeconds() < 10 ? '0' : '') + this.getSeconds();
    },
    u: function () {
        var m = this.getMilliseconds();
        return (m < 10 ? '00' : (m < 100 ?
                '0' : '')) + m;
    },
    // Timezone
    e: function () {
        return "Not Yet Supported";
    },
    I: function () {
        var DST = null;
        for (var i = 0; i < 12; ++i) {
            var d = new Date(this.getFullYear(), i, 1);
            var offset = d.getTimezoneOffset();

            if (DST === null) DST = offset;
            else if (offset < DST) {
                DST = offset;
                break;
            } else if (offset > DST) break;
        }
        return (this.getTimezoneOffset() == DST) | 0;
    },
    O: function () {
        return (-this.getTimezoneOffset() < 0 ? '-' : '+') + (Math.abs(this.getTimezoneOffset() / 60) < 10 ? '0' : '') + (Math.abs(this.getTimezoneOffset() / 60)) + '00';
    },
    P: function () {
        return (-this.getTimezoneOffset() < 0 ? '-' : '+') + (Math.abs(this.getTimezoneOffset() / 60) < 10 ? '0' : '') + (Math.abs(this.getTimezoneOffset() / 60)) + ':00';
    }, // Fixed now
    T: function () {
        var m = this.getMonth();
        this.setMonth(0);
        var result = this.toTimeString().replace(/^.+ \(?([^\)]+)\)?$/, '$1');
        this.setMonth(m);
        return result;
    },
    Z: function () {
        return -this.getTimezoneOffset() * 60;
    },
    // Full Date/Time
    c: function () {
        return this.format("Y-m-d\\TH:i:sP");
    }, // Fixed now
    r: function () {
        return this.toString();
    },
    U: function () {
        return this.getTime() / 1000;
    }
};
