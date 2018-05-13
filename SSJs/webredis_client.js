/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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
function myLog(msg) {
    console.log(new Date + ' ' + msg);
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

function getLST() {
    var t = myAjax(url + "LST_");
    if ("object" == typeof t) {
//            myLog("#AJAX  LST success" + JSON.stringify(t));
    } else {
        myLog("#AJAX  LST error:  " + t);
        return false;
        ;
    }
    if (checkObjectOk(t, lastLSTtime)) {
        LST_OK = true;
        newLST = (t.varValue);
        lastLSTtime = t.time;

        if (newLST.TLO != undefined) {
            TLOtime = +newLST.TLO
            if ((TLOtime != lastTLOtime) && (TLOtime != -1)) {
//                    myLog(' need new TLO oldtime=' + lastTLOtime + "newtime=" + TLOtime);

                TLO_OK = false;
                getTLO();
            }
        }
        if (newLST.TLT != undefined) {
            TLTtime = +newLST.TLT;
            if ((TLTtime != lastTLTtime) && (TLTtime != -1)) {
                TLT_OK = false;
                getTLT();
//                    myLog(' need new TLT oldtime=' + lastTLTtime + "newtime=" + TLTtime);
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

        return true;
    } else {
        return false;
    }
}



function net_process() {
    myLog(" net_process 0 " + net_active);

    if (net_active) {
        return;
    }
    net_active = true;
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
        net_active = false;
    }

}
