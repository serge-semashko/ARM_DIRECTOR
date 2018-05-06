/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var dbg = false;
var firstEnter = true;
var processLST = false;
var processTLT = false;
var processTLO = false;
var TLT_req = false;
var TLO_req = false;
var processTLO = false;
var processTLP = false;
var TLP_OK = false;
var TLT_OK = false;
var TLO_OK = false;
var CTC_OK = false;
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
    if (!processTLP) {
        return;
    }
    if (processTLT || processTLO) {
        return;
    }
//     console.log("!!!!req TLP");

    $.ajax({
        type: "POST",
        dataType: "json",
//        url: url + "GET_TLP" + urlTail,
        url: url + "GET_TLP" + urlTail,
        data: {
            "get_member": "id"
        },
        success: function (t) {
            if (checkObjectOk(t, lastTLPtime)) {
                newTLP = t.varValue;
                lastTLPTime = +t.time;
//                console.log("TLP OK");

            }
        },
        error: function (error) {
//     console.log("\n####AJAX  TLP error:" + JSON.stringify(error));
        },
        complete: function (error) {
//            console.log("\n####AJAX  TLP error:" + JSON.stringify(error));
        }
    })
}
function getTLT() {
    if (!processTLT) {
        return;
    }
    if (TLT_req) {
        return;
    }
//     console.log("request TLT " + processTLT);
    TLT_req = true;
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url + "GET_TLT" + urlTail,
        data: {
            "get_member": "id"
        },
        success: function (t) {
//     console.log("GOT  TLT data");
            TLT_req = false;
            if (checkObjectOk(t, lastTLTtime)) {
//     console.log("GOT  TLT success");
                newTLT = t.varValue;
                lastTLTtime = +t.time;
                processTLT = false;
                TLT_OK = true;
            }
        },
        error: function (error) {
            TLT_req = false;
//     console.log("\n####AJAX  TLT error:" + JSON.stringify(error));
        },
        complete: function () {
            TLT_req = false;
//     console.log("\n####AJAX  TLT complete:");
        }

    })

}
function getTLO() {
    if (!processTLO) {
        return;
    }
    if (TLO_req) {
        return;
    }
    TLO_req = true;

    $.ajax({
        type: "POST",
        dataType: "json",
        url: url + "GET_TLO" + urlTail,
        data: {
            "get_member": "id"
        },
        success: function (t) {
            if (checkObjectOk(t, lastTLOtime)) {
//     console.log("GOT  TLO success");
                TLO_OK = true;
                newTLO = t.varValue;
                lastTLOtime = +t.time;
                processTLO = false;
                var select = document.getElementById("ActiveTL");
//                select.options.length = 0;
                

                for (var i = 0; i <= newTLO.length - 1; i++) {
                    addDropdownList("ActiveTL", i, newTLO[i].Name);
                }

            }
            TLO_req = false;
        },
        error: function (error) {
//     console.log("\n####AJAX  TLO error:" + JSON.stringify(error));
            TLO_req = false;
        },
        complete: function () {
            TLO_req = false;
//     console.log("\n####AJAX  TLO complete:");
        }

    });
}

function getCTC() {
    if (processCTC) {
        return;
    }
    processCTC = true;
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url + "GET_CTC" + urlTail,
        data: {
            "get_member": "id"
        },
        success: function (t) {
            if (checkObjectOk(t, lastCTCtime)) {
                newCTC = t.varValue;
                lastCTCTtime = t.time;
            }
            processCTC = false;
        },
        error: function (error) {
//     console.log("\n####AJAX  CTC error:" + JSON.stringify(error));
            processCTC = false;
        }
    });
}
function getLST() {
//console.log("\n###Agetson nucloweb start");
//    dt = new Date().getTime() - globalStart;
//    atm.html(" nc=" + ncount + " oc=" + ocount + " " + dt);
//    if (processLST) {
//        return;
//    }
    if (processTLT || processTLO) {
        return;
    }
    processLST = true;
    var aj = $.ajax({
        type: "POST",
        dataType: "json",
        url: url + "LST_" + urlTail,
        data: {
            "get_member": "id"
        },
        success: function (t) {
//     console.log("\n####AJAX  ok:");
            processLST = false;
            if (checkObjectOk(t, lastLSTtime)) {
                $("#serverStatus").css("color", "blue");
                newLST = t.varValue;
                lastLSTtime = t.time;
                if (newLST.TLO != undefined) {
                    TLOtime = +newLST.TLO
                    if ((TLOtime != lastTLOtime) && (TLOtime != -1)) {
//     console.log(' need new TLT');
                        processTLO = true;
                        TLO_OK = false;
                    } else {

                        processTLO = false;
                    }
                }
                if (newLST.TLT != undefined) {
                    TLTtime = +newLST.TLT;
                    if ((TLTtime != lastTLTtime) && (TLTtime != -1)) {
//     console.log(' need new TLT');
                        processTLT = true;
                        TLT_OK = false;
                    } else {
                        processTLT = false;
                    }
                }
                if (newLST.TLP != undefined) {
                    TLPtime = +newLST.TLP
                    if ((TLPtime != lastTLPtime) && (TLPtime != -1)) {
                        if (TLO_OK && TLT_OK) {
                            $("#armStatus").css("color", "blue");
                            if (firstEnter) {
                                firstEnter = false;
                                hidePage();
                            }
                            processTLP = true;
                        } else {
                            processTLP = false;
                        }
                    } else {
                        processTLP = false;
                    }
                }
                if (newLST.CTC != undefined) {
                    CTCtime = +newLST.CTC
                }
//                console.log(' TLO TLT TLP CTC=' + TLOtime + ' ' + TLTtime + ' ' + TLPtime + ' ' + CTCtime + ' ');
//                console.log(' LST=' + lastLSTtime + ' ' + JSON.stringify(newLST));

            }
        },
        error: function (error) {
//     console.log("\n####AJAX  LST error:" + JSON.stringify(error));
            processLST = false;
        },
        complete: function () {
            processLST = false;
//     console.log("\n####AJAX  LST complete:");
        },
        done: function () {
            processLST = false;
//     console.log("\n####AJAX  LST done:");
        },
        abort: function () {
            processLST = false;
//     console.log("\n####AJAX  LST abort:");
        },
        always: function () {
            processLST = false;
//     console.log("\n####AJAX  LST always:");
        },
        fail: function () {
            processLST = false;
//     console.log("\n####AJAX  LST fail:");
        },
        state: function () {
            processLST = false;
//     console.log("\n####AJAX  LST state:");
        },
        statusCode: function () {
            processLST = false;
//     console.log("\n####AJAX  LST statusCode:");
        },
        progress: function () {
            processLST = false;
//     console.log("\n####AJAX  LST progress");
        },
        promise: function () {
            processLST = false;
//     console.log("\n####AJAX  LST promise");
        }
    });
//     console.log("ajax " + JSON.stringify(aj));


}
