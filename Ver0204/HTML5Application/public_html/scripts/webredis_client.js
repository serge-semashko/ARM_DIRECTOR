/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var socket;
var max_request = 20;
var LST_time = new Date().getTime();
var LST_count = 0;

var LST_req = 0;
var LST_fired = 0;
var LST_ans = 0;

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
    setInterval(async_net_process, 50);

}
var options = {
    hour: 'numeric',
    minute: 'numeric',
    second: 'numeric',
};

function myLog(msg) {
    console.log(new Date().toLocaleString("ru", options) + ' ' + new Date().getMilliseconds() +" "+ msg);

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
            var resp = xhr.responseText;
            resp = resp.substr(1, resp.length - 3);
//            console.log("ajax pure load " + xhr.responseText);
            var retobj = JSON.parse(resp);
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
    var strLST = pako.inflate(data, {to: 'string'});
    return JSON.parse(strLST);
}
function checkObjectOk(obj, lastTime) {
    if (typeof obj === "undefined") {
        return false;
    }

    if (Object.keys(obj).length === 0) {
        return false;
    }
    if (obj.time < lastTime) {
        return false;
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
            for (var i = 0; i <= newTLO.length - 1; i++) {
                addDropdownList("ActiveTL", i, newTLO[i].Name);
            }
        }
    } finally {

    }
    myLog("#AJAX  TLO complete:");
}
function proc_LST(t) {
    if (checkObjectOk(t, lastLSTtime)) {
        LST_OK = true;
        newLST = (t.varValue);
        lastLSTtime = t.time;

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
                    TLP_OK = true;
                } else {
                }
//                    myLog(' need new TLT oldtime=' + lastTLTtime + "newtime=" + TLTtime);
            } else {
                TLP_OK = false;

            }
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
function async_net_process() {
    if ((new Date().getTime() - LST_time) > 1000) {
        LST_time = new Date().getTime();
        myLog("За секунду: ответов webredis= " + LST_count + ", завершено запросов=" + LST_req + " активных запросов=" + LST_req);
        LST_count = 0;
        LST_ans = 0;

    }
    if (LST_req > max_request) {
        return;
    }
    LST_req++;
        $.ajax({
            type: "POST",
            global: false,
            dataType: "json",
            url: url + "LST_" + urlTail,
            data: {
                "get_member": "id"
            },
            success: function (t) {
                LST_count++;
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
                LST_ans++;
                LST_req--;
            },
            error: function (t) {
                myLog("ajax error")
            }

        });
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