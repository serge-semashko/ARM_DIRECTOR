/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var modeChanged = true;
var uarr = new Uint8Array();
var ScreenFields_1 = [0, 0, 0, 0, 0]; //Второе поле
var ScreenFields_2 = [0, 0, 0, 0, 0]; //Третье
//
//
//
//
// ПЕРЕНЕСТИ В MAIN.JS end

function addDropdownList(id, val, text) {
    text = String(text).replace("#$%#$%", " ")
    var select, i, option;

    select = document.getElementById(id);
//    select.clear();
    option = document.createElement('option');
    option.value = val;
    option.text = text;
    select.add(option);
}
;
//            $("#title1").html($(window).width()+"Х"+$(window).height());
function initControls() {

    var inp = document.getElementsByName('type01');
    for (var i = 0; i < inp.length; i++) {
        if (inp[i].type == "radio" && (typesrc == +inp[i].value)) {
            inp[i].checked = true;
        }
    }
    var inp = document.getElementsByName('voice');
    for (var i = 0; i < inp.length; i++) {
        if (inp[i].type == "radio" && (typeSpeeker == +inp[i].value)) {
            inp[i].checked = true;
        }
    }

    document.getElementById("ActiveTL").options.selectedIndex = +ActiveTL;
    document.getElementById("CountEvents").value = +CountEvents;
    document.getElementById("dev1").value = Device1;
    document.getElementById("dev2").value = +Device2;
    document.getElementById("dev1CountEvents").value = +EventsDev1;
    document.getElementById("dev2CountEvents").value = +EventsDev2;


    //ShowEvents, ShowDevices, ShowEditor, ShowScaler, ShowTimelines, ShowNameTL,
    //ShowAllTimelines, ShowDev1, ShowDev2;
    document.getElementById("chk4_1").checked = DefaultScreen4[3];// ShowScaler = document.getElementById("chk4_1").checked;
    document.getElementById("chk4_2").checked = DefaultScreen4[2];//ShowEditor = document.getElementById("chk4_2").checked;
    document.getElementById("chk4_3").checked = DefaultScreen4[4];// ShowTimelines = document.getElementById("chk4_3").checked;
    document.getElementById("chk4_4").checked = DefaultScreen4[5];// ShowTimelines = document.getElementById("chk4_3").checked;

    for (var fn = 1; fn < 6; fn++) {
        fldn = "scr_" + fn;
        var fld = +document.getElementById(fldn).options.selectedIndex - 1;
        document.getElementById(fldn).options.selectedIndex = ScreenFields[fn - 1] + 1;
    }


    $("#select_scr").css("display", "block");
    $("#main").css("display", "none");
}
function execMain() {
//                speak("Test 0", 1.0, 1.4);

    var value = +$("[name=type01]:checked").val();
    typeSpeeker = +$("[name=voice]:checked").val();
    typesrc = +value;
    ActiveTL = +document.getElementById("ActiveTL").options.selectedIndex;
    for (var fn = 1; fn < 6; fn++) {
        fldn = "scr_" + fn;
        var fld = +document.getElementById(fldn).options.selectedIndex - 1;
        ScreenFields[fn - 1] = +document.getElementById(fldn).options.selectedIndex - 1;
//                    ScreenFields_1[fn - 1] = document.getElementById(fldn + "_1").value;
//                    ScreenFields_2[fn - 1] = document.getElementById(fldn + "_2").value;
    }
    CountEvents = +document.getElementById("CountEvents").value;
    Device1 = +document.getElementById("dev1").value;
    Device2 = +document.getElementById("dev2").value;
    EventsDev1 = +document.getElementById("dev1CountEvents").value;
    EventsDev2 = +document.getElementById("dev2CountEvents").value;


    //ShowEvents, ShowDevices, ShowEditor, ShowScaler, ShowTimelines, ShowNameTL,
    //ShowAllTimelines, ShowDev1, ShowDev2;
    DefaultScreen4[3] = document.getElementById("chk4_1").checked;// ShowScaler = document.getElementById("chk4_1").checked;
    DefaultScreen4[2] = document.getElementById("chk4_2").checked;//ShowEditor = document.getElementById("chk4_2").checked;
    DefaultScreen4[4] = document.getElementById("chk4_3").checked;// ShowTimelines = document.getElementById("chk4_3").checked;
    DefaultScreen4[5] = document.getElementById("chk4_4").checked;// ShowTimelines = document.getElementById("chk4_3").checked;
    hidePage();
}

function testGZIP() {
    TLTarr = Uint8Array.from("987654321");
    function sum(previous, current, index, array) {
        console.log("p+n  " + previous + ' ' + current);
        return previous + current;
    }
    console.log("sum= " + uarr.reduce(sum));

    console.log(uarr);

}
function setViewport() {
    window.fullScreen = true
    scrW = window.innerWidth - 10;
    //|| document.documentElement.clientWidth -25
    //|| document.body.clientWidth - 25;
    scrH = window.innerHeight - 10;

}

window.onclose = function() {
       clearInterval(myInterval)
}
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
    setViewport();
    var mn = document.getElementById("select_menu");

    $("body").css("font-size", "12px");
    for (var fs = 60; fs > 1; fs--) {
        $("table,button,input,select").css("font-size", fs + "px");
        var hd = mn.clientHeight;
        var wd = mn.clientWidth;
//        if (scrW < scrH) {
        if (wd > scrW *2/ 4) {
            continue;
        }
//        } 
//        else {
//            if (hd > scrH - 30) {
//                continue;
//            }
//        }
        break;
    }

//    setInterval(getLST, 11);
    getTLT();
    getTLO();
    initControls();
    setInterval(getLST, 1131);
    setInterval(getTLP, 21);
    setInterval(getTLT, 4421);
    setInterval(getTLO, 4421);
    showPage();
    window_onload();

//    hidePage();
};
function hidePage() {
    $("#select_scr").css("display", "none");
    $("#main").css("display", "block");

}
function showPage() {
    $("#select_scr").css("display", "block");
    $("#main").css("display", "hide");

}

function initVoice() {
    var synth = window.speechSynthesis;
    var voiceSelect = document.querySelector('#voice_1');
    var pitchValue = 1;
    var rateValue = 2;

    var voices = [];
    var voiceok = false;


    if (speechSynthesis.onvoiceschanged !== undefined) {
        speechSynthesis.onvoiceschanged = populateVoiceList;
    }
    populateVoiceList();
    populateVoiceList();
//    speak("Test  10 9 8 7 6 5 4 3 2 1 0", 1.0, 1.4);



}
function populateVoiceList() {
    voices = synth.getVoices();
    var selectedIndex = voiceSelect.selectedIndex < 0 ? 0 : voiceSelect.selectedIndex;
    voiceSelect.innerHTML = '';
    console.log("voices " + voices.length);
    for (i = 0; i < voices.length; i++) {
        if ((voices[i].lang.indexOf('ru-') < 0)) {
            continue;
        }
        voiceok = true;
        var option = document.createElement('option');
        option.textContent = voices[i].name + ' (' + voices[i].lang + ')';

        if (voices[i].default) {
            option.textContent += ' -- DEFAULT';
        }

        option.setAttribute('data-lang', voices[i].lang);
        option.setAttribute('data-name', voices[i].name);
        voiceSelect.appendChild(option);
    }
    if (!voiceok) {
        var option = document.createElement('option');
        if (voices.length < 1) {
            option.textContent = 'Голоса отсутствуют в системе'
        } else {
            option.textContent = 'Русские голоса отсутствуют в системе'

        }
        ;
        voiceSelect.appendChild(option);

    }
    voiceSelect.selectedIndex = selectedIndex;
}
function speak(stext, rateValue, pitchValue) {
    if (!voiceok) {
        return;
    }
    if (synth.speaking) {
        console.error('speechSynthesis.speaking');
        return;
    }
    rateValue = rateValue || 1;
    pitchValue = rateValue || 1;
    if (stext !== '') {
        var utterThis = new SpeechSynthesisUtterance(stext);
        utterThis.onend = function (event) {
            console.log('SpeechSynthesisUtterance.onend');
        };
        utterThis.onerror = function (event) {
            console.error('SpeechSynthesisUtterance.onerror');
        };
        var selectedOption = voiceSelect.selectedOptions[0].getAttribute('data-name');
        for (i = 0; i < voices.length; i++) {
            if (voices[i].name === selectedOption) {
                utterThis.voice = voices[i];
            }
        }
        utterThis.pitch = pitchValue;
        utterThis.rate = rateValue;
        synth.speak(utterThis);
    }
}
