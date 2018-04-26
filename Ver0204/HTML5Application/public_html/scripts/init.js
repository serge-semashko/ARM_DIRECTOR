/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

window.onload = function () {
    var dloc = document.location;
    var hostname;
    if (dloc.hostname.length < 3) {
        hostname = "localhost";
    } else {
        hostname = dloc.hostname;
    }
    console.log(hostname + " ");
    url = "http://" + hostname + ":9090/";
    urlTail = "&callback=?";
    setInterval(getLST, 11);
    setInterval(getTLP, 12);
    setInterval(getTLT, 13);
    setInterval(getTLO, 14);
}
function getTLP() {
    if (processTLP) {
        return;
    }
    processTLP = true;
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url + "GET_TLP" + urlTail,
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
//            processData(t);
            if (typeof t == "undefined") {
                console.log("TLP= undef ");

            } else {
                console.log("TLP = ok " + typeof (t));
            }
            processTLP = false;
            ocount++;
        },
        error: function (error) {
            console.log("\n####AJAX  TLP error:" + JSON.stringify(error));
            processTLP = false;

        }
    })
}
function getTLO() {
    if (processTLO) {
        return;
    }
    processTLO = true;
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url + "GET_TLO" + urlTail,
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
//            processData(t);
            if (typeof t == "undefined") {
                console.log("TLO= undef ");

            } else {
                console.log("TLO= ok " + typeof (t) + ' l=' + t.length + ' l[0]=' + t[0].length);
            }
            processTLO = false;
            ocount++;
        },
        error: function (error) {
            console.log("\n####AJAX  TLO error:" + JSON.stringify(error));
            processTLO = false;

        }
    })

}
function getTLT() {
    if (processTLT) {
        return;
    }
    processTLT = true;
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url + "GET_TLT" + urlTail,
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
//            processData(t);
            if (typeof t == "undefined") {
                console.log("TLT= undef ");

            } else {
                console.log("TLT = ok " + typeof (t));
            }
            processTLT = false;
            ocount++;
        },
        error: function (error) {
            console.log("\n####AJAX  TLO error:" + JSON.stringify(error));
            processTLT = false;

        }
    })


}
function getLST() {
    //console.log("\n###Agetson nucloweb start");
    ncount++;
    dt = new Date().getTime() - globalStart;
//    atm.html(" nc=" + ncount + " oc=" + ocount + " " + dt);
    if (processLST) {
        return;
    }
    processLST = true;
    $.ajax({
        type: "POST",
        dataType: "json",
        url: url + "LST_" + urlTail,
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
//            processData(t);
            if (typeof t == "undefined") {
                console.log("LST= undef ");

            } else {
                console.log("LST = ok " + typeof (t));
            }
            processLST = false;
            ocount++;
        },
        error: function (error) {
            console.log("\n####AJAX  LST error:" + JSON.stringify(error));
            processLST = false;

        }
    })

    //                        //console.log('\n step chart 4 1\n');


}

