/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var socket;
var max_request = 30;
var LST_time = new Date().getTime();
var LST_count = 0;
var go_time = "";
var url;
// = "http://127.0.0.1:9090/get_data&callback=?";
var urlTail = "";
var lst_active = 0;
var lst_fired = 0;
var lst_succ = 0;
var lst_completed = 0;
var lst_error = 0;
var lst_done = 0;
var send_first = 0;
var send_last = 0;
var rec_first = 0;
var rec_last = 0;

var async_time = new Date().getTime();
var async_req = 0;
var async_ans = 0;
var async_count = 0;

var serial_time = new Date().getTime();
var serial_req = 0;
var serial_ans = 0;
var serial_count = 0;

var dbg = false;
var serverReady = "aquamarine";
var net_active = false;
var firstEnter = true;
var processLST = true;
var processTLT = false;
var processTLO = false;
var TLT_req = false;
var TLO_req = false;
var processTLO = false;
var processTLP = false;
var TLP_OK = false;
var TLT_OK = false;
var TLO_OK = false;
var CTC_OK = true;
var LST_OK = true;
var newTLP;
var newTLT;
var newTLO;
var newCTC;
var TLP_pos;
var lastTLPtime = 0;
var lastTLTtime = 0;
var lastTLOtime = 0;
var lastLSTtime = 0;
var lastCTCtime = 0;
function net_init() {
//    setInterval(serial_net_process, 1);
    var dloc = document.location;
    var hostname;
    if (dloc.hostname.length < 3) {
        hostname = "localhost";
    } else {
        hostname = dloc.hostname;
    }
    url = "http://" + hostname + ":9090/";
    urlTail = "&callback=?";
    setInterval(async_net_process, 60);
}
var options = {
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric',
};

function myLog(msg) {
    console.log(new Date().toLocaleString("ru", options) + ' ' + new Date().getMilliseconds() + " " + msg);

}
function pureAjax() {
    isUp = false;
    isAccepted = false;
    var reqlst = url + "LST_";
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
        console.log("ajax ready state change state=" + xhr.readyState + " status=" + xhr.status + " status=" + xhr.responseText);
        if (xhr.readyState == 4 && xhr.status == 200) {
            var resp = xhr.responseText;
            resp = resp.substr(1, resp.length - 3);
            console.log("ajax pure load " + xhr.responseText);
            var res = JSON.parse(resp);
        }
    }
    xhr.open('GET', reqlst, true); //note non-ssl port
    xhr.onload = function () {
        console.log("ajax pure load");
    };
    xhr.onerror = function () {
        console.log("ajax pure error");
    };
    console.log("ajax pure send");
    xhr.send();
    console.log("ajax exit");
}

function myAjax(url) {
    try {
        var reqlst = url;
        var result = "no";
        var xhr = new XMLHttpRequest();
        xhr.open('GET', reqlst, false); //note non-ssl port
        xhr.send();
        if (xhr.status == 200) {
            result = "#ans:" + xhr.responseText;
            resp = "";
            resp = xhr.responseText.trim();
            var finpos = resp.indexOf(");");
            resp = resp.substr(1, finpos - 1);
            console.log("ajax pure load start " + resp.substr(0, 80));
            console.log("ajax pure final  " + resp.substr(resp.length - 80, resp.length + 10));

            var retobj = JSON.parse(resp.replace('#$%#$%', ' '));
            return  retobj;
        } else
            return "No status 200";
    } finally {

    }
//    console.log("ajax exit res=" + result);
}

function objFromRedis(instr) {
    var pako = window.pako;
    var data = new Uint8Array(instr.length / 2);
    var b;
    for (var i = 0; i < instr.length; i++) {
        var b = parseInt(instr[2 * i] + instr[2 * i + 1], 16);
        data[i] = b;
    }
    var strLST = pako.inflate(data, {to: 'string'}).replace('#$%#$%', ' ');
    console.log("\n!!inflate start " + strLST.substr(0, 80));
    console.log("\n!!inflate final " + strLST.substr(strLST.length - 80, strLST.length + 10));

    try {
        return JSON.parse(strLST);

    } finally {
        console.log("\n!!!!!!!!!!!!!!!!!!!!!!!\n");
        console.log("\n!!inflate error= " + strLST.substr(761900, 762000) + "\"");
    }
    throw "ERR inflate";



}
function checkObjectOk(obj, lastTime) {
    if (typeof obj === "undefined") {
        return false;
    }

    if (Object.keys(obj).length === 0) {
        return false;
    }
    if (obj.time < lastTime) {
        //return false;
    }
    return true;
}
function getTLP() {
    if (checkObjectOk(t, lastTLPtime)) {
        TLP_OK = true;
        newTLP = (t.varValue);
        lastTLPTime = +t.time;
    }
//    myLog("#AJAX  TLP final");
}
function getTLT() {
    myLog("#AJAX  TLT start");
    try {
        t = myAjax(url + "ARR_TLT");
        if ("object" == typeof t) {
            myLog("#AJAX  TLT success");
        } else {
            myLog("#AJAX  TLT error:  " + t);
            throw "#AJAX  TLT error:  " + t;
        }
        myLog("#AJAX TLT success");
        if (checkObjectOk(t, lastTLTtime)) {
            myLog("GOT  TLT success time=" + t.time);

            newTLT = objFromRedis(t.varValue);
            TLT_OK = true;
            lastTLTtime = +t.time;
            processTLT = false;
            TLT_OK = true;
        }
    } finally {
    }
    myLog("#AJAX  TLT final");
}
function getTLO() {
    myLog("#AJAX  TLO start:");
    try {
        t = myAjax(url + "ARR_TLO");
        if ("object" == typeof t) {
            myLog("#AJAX  TLO success");
        } else {
            myLog("#AJAX  TLO error:  " + t);
            throw "#AJAX  TLO error:  " + t;
        }

        if (checkObjectOk(t, lastTLOtime)) {
            myLog("GOT  TLO success t=" + t.time);
            TLO_OK = true;
            newTLO = objFromRedis(t.varValue);
            lastTLOtime = +t.time;
            processTLO = false;
            var select = document.getElementById("ActiveTL");
            select.options.length = 0;
            for (var i = 0; i <= newTLO.length - 1; i++) {
                addDropdownList("ActiveTL", i, newTLO[i].Name);
            }
            if (select.options.length < ActiveTL - 1) {
                ActiveTL = 0;
            }
            select.options.selectedIndex = ActiveTL;
        }
    } finally {

    }
    myLog("#AJAX  TLO complete:");
}
function proc_LST(t) {

    LST_OK = true;
    newLST = (t.varValue);
    lastLSTtime = t.time;
    var d1Time = new Date().getTime() - (+t.sent)
//    console.log('req = '+JSON.stringify(t));
    if(t.reqInfo !=undefined) {
//        console.log('reqInfo='+JSON.stringify(t.reqInfo));
        var reqInfo = t.reqInfo;
        reqInfo.Ts.push(t.sent-reqInfo.tStart);
        reqInfo.Tp2.push(new Date().getTime()-reqInfo.tStart);
        
        if (reqInfo.Tp1.length >10){
            var spr = "";
            for (var i = 0;i<reqInfo.Tp1.length;i++) {
                spr +="Tp1: "+ (reqInfo.Tp1[i]-reqInfo.Tp1[i])+" Ts: "+(reqInfo.Ts[i]-reqInfo.Tp1[i])+" Tp2: "+ (reqInfo.Tp2[i]-reqInfo.Tp1[i])+" "+(reqInfo.Tp2[i]-reqInfo.Ts[i])+" "+"\n";
//                spr +="Tp1: "+ reqInfo.Tp1[i]+" Ts: "+reqInfo.Ts[i]+" Tp2: "+ reqInfo.Tp2[i]+"\n";
            }
            console.log(spr);
        } else {
           reqInfo.Tp1.push(new Date().getTime()-reqInfo.tStart);
            sendLST(JSON.stringify(reqInfo));
        }
            
    };
    
    if (newLST.TLO != undefined) {
        TLOtime = +newLST.TLO;
        var TLO1time = +newLST["TLO[1]"];
        if (TLO1time == -1) {
            TLO_OK = true;
            newTLO = [];
        } else {
            if ((TLOtime != lastTLOtime) && (TLOtime != -1)) {
//                    myLog(' need new TLO oldtime=' + lastTLOtime + "newtime=" + TLOtime);

                TLO_OK = false;
                getTLO();
            }
        }

    }
    if (newLST.TLT != undefined) {
        TLTtime = +newLST.TLT;
        var TLT1time = +newLST["TLT[0]"];
        if (TLT1time == -1) {
            TLT_OK = true;
            newTLT = [];
        } else {
            if ((TLTtime != lastTLTtime) && (TLTtime != -1)) {
                TLT_OK = false;
                getTLT();
//                    myLog(' need new TLT oldtime=' + lastTLTtime + "newtime=" + TLTtime);
            }
        }
    }
    if (newLST.TLP_value != undefined) {
        var obj = newLST.TLP_value;
        if (!(typeof obj === "undefined")) {
            if (!(Object.keys(obj).length === 0)) {
                newTLP = newLST.TLP_value;
                newTLP.ClipName = newTLP.ClipName.replace('#$%#$%', ' ')
                TLP_OK = true;
            } else {
            }
//                    myLog(' need new TLT oldtime=' + lastTLTtime + "newtime=" + TLTtime);
        } else {
            TLP_OK = false;

        }
    }


}



function getLST() {
    var t = myAjax(url + "LST_");
    if ("object" == typeof t) {
//            myLog("#AJAX  LST success" + JSON.stringify(t));
    } else {
        myLog("#AJAX  LST error:  " + t);
        return false;

    }
    processLST(t);
    return true;
}



function serial_net_process() {
    myLog(" serial net_process");
    try {
        if (!getLST())
            return;
        if (LST_OK) {
            $("#serverStatus").css("color", serverReady);
        }
        if (TLT_OK && TLO_OK && TLP_OK) {
            $("#armStatus").css("color", "aquamarine");
        }
        if (firstEnter) {
            firstEnter = false;
            hidePage();
        }

    } finally {
    }

}
function old_async_net_process() {
    if ((new Date().getTime() - LST_time) > 1000) {
        LST_time = new Date().getTime();
//        myLog("За секунду: webredis= " + lst_succ + ", завершено=" + lst_completed + " активных=" + lst_active + " done=" + lst_done );
        var mess = "За секунду: ok=" + lst_succ + " start=" + lst_fired + " завершено=" + lst_completed + " активных=" + lst_active + " err=" + lst_error;
        mess += " От посылки до приема (мс)=" + go_time;
        $("#stat").html(mess);
        lst_completed = 0;
        lst_fired = 0;
//        lst_error = 0;
        lst_succ = 0;
        lst_done = 0;


    }
    if (lst_active > max_request) {
        return;
    }
    if (lst_active == 0) {
        send_first = new Date().getTime();
    }
    if (lst_active == max_request) {
        send_last = new Date().getTime();
    }
    lst_active++;
    lst_fired++;
    $.ajax({
        type: "POST",
        global: false,
        dataType: "json",
        url: url + "LST_" + new Date().getTime() + urlTail,
        data: {
            "get_member": "id"
        },
        success: function (t) {
            lst_succ++;
            var now = new Date();
            var rtime = now.getHours() * 3600 * 1000 + now.getMinutes() * 60 * 1000 + now.getSeconds() * 1000 + now.getMilliseconds();
            var stime = t.sent;
            go_time = (go_time + " " + (rtime - stime)).trim();
            if (go_time.length > 30) {
                go_time = go_time.substr(go_time.indexOf(" "), go_time.length);
            }

            if (checkObjectOk(t, lastLSTtime)) {
                $("#serverStatus").css("color", "blue");
                proc_LST(t);
                $("#serverStatus").css("color", serverReady);
                if (TLT_OK && TLO_OK && TLP_OK) {
                    $("#armStatus").css("color", "aquamarine");
                    if (firstEnter) {
                        firstEnter = false;
                        hidePage();
                    }

                }

            }

            processLST = false;
        },
        complete: function (t) {
            if (rec_first == 0) {
                rec_first = new Date().getTime();
            }
            rec_last = new Date().getTime();
            lst_completed++;
            lst_active--;
        },
        error: function (t) {
            lst_error++;
        },
        done: function (t) {
            lst_done++;
        }

    });
}


function initSYNC() {
    $.ajax({
        type: "POST",
        global: false,
        dataType: "json",
        url: url + 'SYN_{"rTime"=' + new Date().getTime() + '}' + urlTail,
        data: {
            "get_member": "id"
        },
        success: function (t) {
            processRequest(t);
        },
        complete: function (t) {
        },
        error: function (t) {
        },
        done: function (t) {
        }

    });
}


function processRequest(t) {
    lst_succ++;
    var now = new Date();
    var rtime = now.getHours() * 3600 * 1000 + now.getMinutes() * 60 * 1000 + now.getSeconds() * 1000 + now.getMilliseconds();
    var stime = t.sent;
    go_time = (go_time + " " + (rtime - stime)).trim();
    if (go_time.length > 30) {
        go_time = go_time.substr(go_time.indexOf(" "), go_time.length);
    }

    if (checkObjectOk(t, lastLSTtime)) {
        $("#serverStatus").css("color", "blue");
        proc_LST(t);
        $("#serverStatus").css("color", serverReady);
        if (TLT_OK && TLO_OK && TLP_OK) {
            $("#armStatus").css("color", "aquamarine");
            if (firstEnter) {
                firstEnter = false;
                hidePage();
            }

        }

    }

    processLST = false;

}
function sendLST(reqINFO){
    lst_active++;
    lst_fired++;
    reqINFO = reqINFO||"";
    $.ajax({
        type: "POST",
        global: false,
        dataType: "json",
        url: url + "LST_" +reqINFO  + urlTail,
        data: {
            "get_member": "id"
        },
        success: function (t) {
            processRequest(t);
        },
        complete: function (t) {
            if (rec_first == 0) {
                rec_first = new Date().getTime();
            }
            rec_last = new Date().getTime();
            lst_completed++;
            lst_active--;
        },
        error: function (t) {
            lst_error++;
        },
        done: function (t) {
            lst_done++;
        }

    });
    
};
function async_net_process() {
    if ((new Date().getTime() - LST_time) > 1000) {
        LST_time = new Date().getTime();
//        myLog("За секунду: webredis= " + lst_succ + ", завершено=" + lst_completed + " активных=" + lst_active + " done=" + lst_done );
        var mess = "За секунду: ok=" + lst_succ + " start=" + lst_fired + " завершено=" + lst_completed + " активных=" + lst_active + " err=" + lst_error;
        mess += " От посылки до приема (мс)=" + go_time;
        $("#stat").html(mess);
        lst_completed = 0;
        lst_fired = 0;
//        lst_error = 0;
        lst_succ = 0;
        lst_done = 0;


    }
    if (lst_active > max_request) {
        return;
    }
    if (lst_active == 0) {
        send_first = new Date().getTime();
    }
    if (lst_active == max_request) {
        send_last = new Date().getTime();
    }
    var lstParm = {
        Tp1 : [],
        Tp2 : [],
        Ts : [],
        d : [],
        tStart : new Date().getTime()
    };
    lstParm.Tp1.push(new Date().getTime()-lstParm.tStart);
    var lstParms = JSON.stringify(lstParm)
    sendLST(lstParms);
}



function net_sock() {
    socket = new WebSocket("ws://localhost:9095");
//    У объекта socket есть четыре коллбэка: один при получении данных и три – при изменениях в состоянии соединения:
    socket.onopen = function () {
        alert("Соединение установлено.");
        socket.send("/LST_");
    };
    socket.onclose = function (event) {
        if (event.wasClean) {
            alert('Соединение закрыто чисто');
        } else {
            alert('Обрыв соединения'); // например, "убит" процесс сервера
        }
        alert('Код: ' + event.code + ' причина: ' + event.reason);
    };
    socket.onmessage = function (event) {
        alert("Получены данные " + event.data);
    };
    socket.onerror = function (error) {
        alert("Ошибка " + error.message);
    };
}