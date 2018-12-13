/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var modeChanged = true;
var uarr = new Uint8Array();
var ScreenFields_1 = [0, 0, 0, 0, 0]; //Второе поле
var ScreenFields_2 = [0, 0, 0, 0, 0]; //Третье
var synth = window.speechSynthesis;
var voiceSelect ;
var pitchValue = 1;
var rateValue = 2;
var voices = [];
var voiceok = false;
var intervalBlinkTm = 0;
var intervalBlinkIn = 0;

//var synth;
//
//
//
//
// ПЕРЕНЕСТ�? В MAIN.JS end

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
    ReadVoices();
    //var inp = document.getElementsByName('type01');
    //for (var i = 0; i < inp.length; i++) {
    //    if (inp[i].type == "radio" && (typesrc == +inp[i].value)) {
    //        inp[i].checked = true;
    //    }
    //}
    var inp = document.getElementsByName('voice');
    for (var i = 0; i < inp.length; i++) {
        if (inp[i].type == "radio" && (typeSpeeker == +inp[i].value)) {
            inp[i].checked = true;
        }
    }

    document.getElementById("ActiveTL").options.selectedIndex = +ActiveTL;
    document.getElementById("CountEvents").value = +CountEvents;
    document.getElementById("dev1").value = +Device1;
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

    //$("#main").css("display", "none");
	var progTitle = progName + " v." + progVersia;
	$('#progtitle1').text(progTitle);
	$('#armStatus').text(progTitle);
	
	var lastwin = localStorage.getItem("lastwin");
	var startsynch = localStorage.getItem("startsynch");
	if (startsynch == null) startsynch = "no";
	
	if (!synchYes) {
		$('#statussynch').css('color','red');
		if (language == "RUS") {
		    $('#statussynch').text('Требуется синхронизация');
		} else {
			$('#statussynch').text('Synchronization is required');
		}	
	} else {
		$('#statussynch').css('color','rgb(60,60,60)');
		if (language == "RUS") {
		    $('#statussynch').text('Синхронизация проводилась');
		} else {
			$('#statussynch').text('Synchronization was carried out');
		}	
	}
	
	if (startsynch == "yes") {
		$('#synchvisible').prop("checked","");
		if (!synchYes) {
			$("#startpanel").css("display", "flex");
            $("#select_scr").css("display", "none");
		} else {
			$("#startpanel").css("display", "none");
            $("#select_scr").css("display", "block");
		}
	} else {
		$('#synchvisible').prop("checked","checked");
		$("#startpanel").css("display", "none");
        $("#select_scr").css("display", "block");
	}
    //$("#select_scr").slideToggle("slow");
    $("#main").css("display", "none");
	saveToLocalStorage();
}

function setInfo() {
  //$("#serverStatus").css("color", "limegreen");
    if (language == "RUS") {  
        document.all.myinfo.innerHTML="Для выбора экрана<br>нажмите<br>на его изображение.";
	} else {
		document.all.myinfo.innerHTML="Click on image<br>of the screen<br>for its choice.";
	}  
}

function setActiveScreen(value) {
	switch(+value) {
        case 0:  // if (x === 'value1')
           $('#idtypestreen1').css("color", "lime"); 
	       $('#idtypestreen2').css("color", "white");
	       $('#idtypestreen3').css("color", "white");
        break;
        case 1:  // if (x === 'value2')
			$('#idtypestreen2').css("color", "lime"); 
	       $('#idtypestreen1').css("color", "white");
		   $('#idtypestreen3').css("color", "white");
        break;
        case 4:
            $('#idtypestreen3').css("color", "lime"); 
	       $('#idtypestreen2').css("color", "white");
		   $('#idtypestreen1').css("color", "white");
        break
    }
}

function execMain(value) {
//                speak("Test 0", 1.0, 1.4);
    
    //var value = +$("[name=type01]:checked").val();
    typeSpeeker = +$("[name=voice]:checked").val();
    typesrc = +value;
	setActiveScreen(typesrc);
	
	
    ActiveTL = +document.getElementById("ActiveTL").options.selectedIndex;
    if (ActiveTL == -1) {
        setTimeout(setInfo,1000);
        document.all.myinfo.innerHTML="Нет данных<br>или<br>связи с сервером";
        return;
    } //else {
      //if (TLT[ActiveTL].Count<=0) {
      //  setTimeout(setInfo,1000);
      //  document.all.myinfo.innerHTML="Выбранная тайм-линия не содержит событий";
      //  return;  
      //}
    //}
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
	isShowTimelines();
	saveToLocalStorage()
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
    scrW = window.innerWidth - 2;
    //|| document.documentElement.clientWidth -25
    //|| document.body.clientWidth - 25;
    scrH = window.innerHeight - 2;

}

window.onresize = function() {
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
    //var mn = document.getElementById("select_menu");
    document.all.serverStatus.innerHTML=url;//hostname;
	$("#serverStatus1").text(url);
	
	setViewport();
	if (scrH > 1.2*scrW) {
		$('#startpanel').css('fontSize', '1.2em');
		$('#select_scr').css('fontSize', '1.2em'); 
	} else {
		$('#startpanel').css('fontSize', '1em');
		$('#select_scr').css('fontSize', '1em'); 
	}
};

window.onclose = function() {
       clearInterval(myInterval);
};

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
    //var mn = document.getElementById("select_menu");
    document.all.serverStatus.innerHTML=url;//hostname;
	$("#serverStatus1").text(url);
    //$("#sysserver").text(url);
    //initVoice();
    
    $("body").css("font-size", "12px");
    var wdth = 50;
    var fs = Math.floor(scrH / 50);
    var kfc = 1;
    if (scrW<scrH) {
      var fs = Math.floor(scrH / 50);
      kfc = scrH /scrW; 
      if (kfc < 1.3) {
        wdth = 75;  
      } else {
        wdth = 96;
      }
    } else {
      kfc = scrW /scrH;
      if (kfc < 1.2) {
        wdth = 65;  
      } else if (kfc < 1.4) {
        wdth = 50;  
      } else {
        wdth = 40;  
      }
    }
	
	var tmpDate = new Date;
	var currDate = tmpDate.getYear() + tmpDate.getMonth() + tmpDate.getDay();
	var lastDate = localStorage.getItem("lastdate");
	//localStorage.setItem("lastdate", currDate);
	if (currDate == lastDate) {
		synchYes = true;
	} else {
		synchYes = false;
	}
	
    //optionTable(fs,wdth);
    loadFromLocalStorage();   
    initControls();
    net_init();
    initInternalVoice();
    initVoice();
    //showPage();
    window_onload();

//    hidePage();
};
function hidePage() {
	setActiveScreen(typesrc);
    $("#select_scr").css("display", "none");
    $("#main").css("display", "block");
}

function showPage() {
	setActiveScreen(typesrc);
    $("#select_scr").css("display", "flex");
    $("#main").css("display", "hide");
}

function initInternalVoice() {
  var objSel = document.getElementById("voice_0");
  if (objSel.selectedIndex > -1) {
    dirvoice = objSel.options[objSel.selectedIndex].text;  
  } else {
    dirvoice = "Default";    
  }
  
  if (!audio.paused) {
    audio.pause();
    //audio = new Audio();
  } 
}

function initVoice() {
    var synth = window.speechSynthesis;
    voiceSelect = document.querySelector('#voice_1');
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
    var voices = synth.getVoices();
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

function setBlinkStatus() {
	$("#statussynch").hide();
    intervalBlink = setTimeout(function(){$("#statussynch").show(); intervalBlinkIn = setInterval(function(){$("#statussynch").toggle();},500)},1000);
	if (language == "RUS") {
	    $("#statussynch").text("Синхронизация");
	} else {
		$("#statussynch").text("Synchronization");
	}	
}

function clearBlinkStatus() {
	clearInterval(intervalBlinkIn);
	clearTimeout(intervalBlinkTm);
	$("#statussynch").show();
	if (language == "RUS") {
	    $("#statussynch").text("Синхронизация остановлена");
	} else {
		$("#statussynch").text("Synchronization is stopped");
	}
}

function setSynchronization() {
	if (!procSynch) {
		setBlinkStatus();
                deltaSysTime = 999999999999;
		procSynch = true;
		if (language == "RUS") {
		    $('#synchrotime').text('Остановить синхронизацию');
		} else {
			$('#synchrotime').text('To stop synchronization');
		}	
		$('#statussynch').css('color','lime');
	} else {
		clearBlinkStatus();
		procSynch = false;
		if (language == "RUS") {
		    $('#synchrotime').text('Синхронизировать с сервером');
		} else {
		    $('#synchrotime').text('To synchronize with the server');
		}	
		$('#statussynch').css('color','rgb(60,60,60)');
	}
}
