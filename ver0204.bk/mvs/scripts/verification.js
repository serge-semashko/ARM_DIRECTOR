var tempCode = "FG64d";
var vercode = "";
var statrver = false;
var MVSUID = "";
var MVSNAME = "";
var language = "RUS";

var messageRUS = "";
var messageUK = "";

var winlogintextRUS = "<p>Для завершения введите <big><b>логин</b></big> и <big><b>пароль</b></big>,</br>заданые при регистрации на сайте,"
                    + " а также указанный выше <big><b>код</b></big>,</br> после чего нажмите кнопку <big><b>Подтвердить</b></big>.</p>";
var winlogintextUK  = "<p>For end enter <big><b>the login</b></big> and <big><b>the password</b></big>,</br>set at registration on the website,"
                    + " and also <big><b>the code</b></big> stated above,</br> then press <big><b>the Confirm</b></big> button.</p>";

var textmessageRUS = "Ошибка идентификации пользователя.</br></br>Сообщите в службу поддержки <b>support@mvsgroup.tv</b>";					
var textmessageUK = "Error of identification of the user.</br></br>Report in support service of  <b>support@mvsgroup.tv</b>";

var verexitmessageRUS = "Спасибо, что зарегистрировались на сайте MVSGroup.tv!";
var verexitmessageUK = "Thank you that you are registered on the website MVSGroup.tv!";


function setLanguage () {
    if (language == "RUS") {
		document.getElementById("divflagrus").style.opacity = 1;
	    document.getElementById("divflagrus").style.filter = "alpha(opacity=100)";
	    document.getElementById("divflaguk").style.opacity = 0.4;
	    document.getElementById("divflaguk").style.filter ="alpha(opacity=40)";
	    document.getElementById("divlanguage").innerHTML = "RUS";
		document.getElementById("textheader").innerHTML = "Завершение регистрации";
		document.getElementById("youlogin").innerHTML = "Логин";
		document.getElementById("login").placeholder = "логин или e-mail";
		document.getElementById("youpassword").innerHTML = "Пароль";
		document.getElementById("password").placeholder = "Например 123456";
		document.getElementById("codetext").innerHTML = "Код";
		document.getElementById("btnchange").value = "Изменить";
		document.getElementById("youcodeconfirm").innerHTML = "Введите код";
		document.getElementById("codeconfirm").placeholder = "Например G67fj";
		document.getElementById("btnconfirm").value = "Подтвердить";
		document.getElementById("message").innerHTML = messageRUS;
		document.getElementById("winlogintext").innerHTML = winlogintextRUS;
		document.getElementById("textmessage").innerHTML = textmessageRUS;
		document.getElementById("verexitbtn").value = "Перейти на web-сайт";
	} else {
		document.getElementById("divflagrus").style.opacity = 0.4;
	    document.getElementById("divflagrus").style.filter = "alpha(opacity=40)";
	    document.getElementById("divflaguk").style.opacity = 1;
	    document.getElementById("divflaguk").style.filter="alpha(opacity=100)";
	    document.getElementById("divlanguage").innerHTML = "ENG";
		document.getElementById("textheader").innerHTML = "Completion of registration";
		document.getElementById("youlogin").innerHTML = "Login";
		document.getElementById("login").placeholder = "login or e-mail";
		document.getElementById("youpassword").innerHTML = "Password";
		document.getElementById("password").placeholder = "For example 123456";
		document.getElementById("codetext").innerHTML = "Code";
		document.getElementById("btnchange").value = "Change";
		document.getElementById("youcodeconfirm").innerHTML = "Enter a code";
		document.getElementById("codeconfirm").placeholder = "For example G67fj";
		document.getElementById("btnconfirm").value = "Confirm";
		document.getElementById("message").innerHTML = messageUK;
		document.getElementById("winlogintext").innerHTML = winlogintextUK;
		document.getElementById("textmessage").innerHTML = textmessageUK;
		document.getElementById("verexitbtn").value = "To pass to the website";
	}; 
};

function getRandomInt(min, max) { 
    return Math.floor(Math.random() * (max - min + 1)) + min; 
};

function getRandomCode() {
   strtext = "0123456789aAbBcCdDtEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ";
   var code = "";
   for (var i=0; i<5; i++) {
	   j = getRandomInt(0, 35);
	   code = code + strtext.charAt(j);
   };   
   tempCode = code;
   document.getElementById("codevalue").innerHTML = code;
   document.getElementById("codeconfirm").value = "";
};

function compareData() {
    var code = document.getElementById("codeconfirm").value;
	if (code == tempCode) {
	    //document.getElementById("verexit").style.display = "block"; 
	    //document.getElementById("verlogin").style.display = "none";
		return true;
	} else {
		messageRUS = "Коды не совпали. Повторите попытку.";
        messageUK = "Codes haven't coincided. Repeat attempt.";
		if (language == "RUS") {
		    document.getElementById("message").innerHTML = messageRUS;
		} else {
			document.getElementById("message").innerHTML = messageUK;
		};	
		getRandomCode();
		document.getElementById("codeconfirm").value = "";
		return false;
	};
};

function setRegistration() {
	var nm = document.getElementById("login").value;
	var psw = document.getElementById("password").value;
	var code = document.getElementById("codeconfirm").value;
	if (nm == "") {
		messageRUS = "Не задан логин";
        messageUK = "The login isn't set";
		if (language == "RUS") {
		    document.getElementById("message").innerHTML = messageRUS;
		} else {
			document.getElementById("message").innerHTML = messageUK;
		};
		$("#login").focus();
		return false;
	};	 
	if (psw == "") {
		messageRUS = "Не задан пароль";
        messageUK = "The password isn't set";
		if (language == "RUS") {
		    document.getElementById("message").innerHTML = messageRUS;
		} else {
			document.getElementById("message").innerHTML = messageUK;
		};
		$("#password").focus();
		return false;
	};
	if (code == "") {
		messageRUS = "Не заполнено поле Код";
        messageUK = "The field Code isn't filled";
		if (language == "RUS") {
		    document.getElementById("message").innerHTML = messageRUS;
		} else {
			document.getElementById("message").innerHTML = messageUK;
		};
		$("#codeconfirm").focus();
		return false;
	};
	var res = compareData();
	if (res) { setDBRegistration(); };
};

function getCodeVerification() {
	var turl = document.location.href;
	var ext = document.location.search;
	var path = document.location.pathname;
	var ext1 = document.location.hash;
	if (ext1 == "#RUS") {language = "RUS"};
	if (ext1 == "#ENG") {language = "ENG"};
	setLanguage();
	if (ext == "") {
		document.getElementById('vermessage').style.display = "block";
	    document.getElementById('verlogin').style.display = "none"; 
	    document.getElementById('verexit').style.display = "none";
		return;
	};
	
	if (ext.charAt(0) == "?") {
		vercode = ext.substr(1,ext.length-1); 
	} else {
	    vercode = ext;	
	};
	
	ob = { 'codever': vercode};

	var tmpurl = turl.substr(0, turl.length - ext.length - ext1.length);
	var turl = getUrlPathV(tmpurl) + "php/verification.php";
	$.ajax({
        type:'POST',
        url:turl,
        dataType:'json',
        data: 'param=' + JSON.stringify(ob),
        success:function(json) {
			if (json.verification == "yes") {
				if (json.registration == "1") {
					textmessageRUS = "<b>" + json.name + "</b>, </br>аккаунт с таким идентификационным кодом уже был зарегистрирован на сайте.</br></br> "
					               + "Если у вас возникли проблемы с регистрацией, сообщите об этом в службу поддержки <b>support@mvsgroup.tv</b>";
					textmessageUK = "<b>" + json.name + "</b>, </br>the account with such identification code has been already registered on the website.</br></br> "
					               + "If you had had problems with registration, report about it in support service <b>support@mvsgroup.tv</b>";	
 								   
					if (language == "RUS") {
					    document.getElementById("textmessage").innerHTML = textmessageRUS;
					} else {
						document.getElementById("textmessage").innerHTML = textmessageUK;
					};	
																	 
					document.getElementById('vermessage').style.display = "block";
	                document.getElementById('verlogin').style.display = "none"; 
	                document.getElementById('verexit').style.display = "none";												 
					return;
				};
				winlogintextRUS = "<p>" + json.name + ", для завершения регистрации введите свои <big><b>логин</b></big> и" 
					              + "<big><b> пароль</b></big>,</br> которые Вы указали при регистрации на сайте, а также указанный " 
					              + "<big><b>код</b></big>,</br> после чего нажмите кнопку <big><b>Подтвердить</b></big>.</p>";
				winlogintextUK  = "<p>" + json.name + ", for end enter <big><b>the login</b></big> and" 
					              + "<big><b> the password</b></big>,</br> set at registration on the website, and also " 
					              + "<big><b>the code</b></big> stated above,</br> then press <big><b>the Confirm</b></big> button.</p>";	
 				if (language == "RUS") {
				    document.getElementById("winlogintext").innerHTML = winlogintextRUS;
				} else {
					document.getElementById("winlogintext").innerHTML = winlogintextUK;
				};
				
				document.getElementById('vermessage').style.display = "none";
	            document.getElementById('verlogin').style.display = "block"; 
	            document.getElementById('verexit').style.display = "none";
				return;
			} else {
				document.getElementById('vermessage').style.display = "block";
	            document.getElementById('verlogin').style.display = "none"; 
	            document.getElementById('verexit').style.display = "none";
			};	
		},
		error: function (xhr, ajaxOptions, thrownError) {
            document.getElementById('vermessage').style.display = "block";
	        document.getElementById('verlogin').style.display = "none"; 
	        document.getElementById('verexit').style.display = "none";
        }
    }); 		
//    document.getElementById('vermessage').style.display = "block";
//	document.getElementById('verlogin').style.display = "none"; 
//	document.getElementById('verexit').style.display = "none";	
};

function getRadioButton1() {
	var currRadio = document.querySelector('input[name="radiobutton1"]:checked').value;
	if (currRadio == "0") {
		document.getElementById('winproducts').style.display = "block";
		document.getElementById('winstatuscode').style.display = "none";
	} else {
		document.getElementById('winstatuscode').style.display = "block";
		document.getElementById('winproducts').style.display = "none";
	};
	
};

function gotoWebsite() {
	sessionStorage.isregistration = "Yes";
    sessionStorage.userstatus = "0";
	sessionStorage.MVSUID = MVSUID;
	sessionStorage.name = MVSNAME;
	if (language == "RUS") {
		window.location.href="../index.html#RUS";
	} else {
		window.location.href="../index.html#ENG";
	};
};

function getUrlPathV(texthref) {
	var ext = texthref.substr(texthref.length-3,3);
	ext = ext.toLowerCase();
    var outtext = texthref;
	if (ext == "tml" || ext == "htm" || ext == "php") {
	    for (var i=texthref.length-1; i>=0; i--) {
			var ch = texthref.charAt(i);
			if (ch == "\\" || ch == "/") {
				outtext = texthref.substr(0, i+1);
				break;
			};
		};	
	};
	var pgs = outtext.substr(outtext.length - 6,6);
	pgs = pgs.toLowerCase();
	if (pgs == "pages\\" || pgs == "pages/") {
		outtext = outtext.substr(0, outtext.length-6);
	};
	return outtext;
};

function setDBRegistration() {
	var turl = document.location.href;
	var ext = document.location.search;
	var ext1 = document.location.hash;
	var nm = document.getElementById("login").value;
	var psw = document.getElementById("password").value;
	ob = { 'codever': vercode,
	       'login': nm,
		   'pswrd': psw
		 };
	var tmpurl = turl.substr(0, turl.length - ext.length-ext1.length);
	var turl = getUrlPathV(tmpurl) + "php/setregistration.php";
	$.ajax({
        type:'POST',
        url:turl,
        dataType:'json',
        data: 'param=' + JSON.stringify(ob),
        success:function(json) {
			if (json.value == "yes") { 
			    verexitmessageRUS = "<b>" + json.name + "</b>, поздравляем Вас с успешной регистрациий на сайте MVSGroup.tv";
                verexitmessageUK = "<b>" + json.name + "</b>, we congratulate you on successful registration on the website MVSGroup.tv";
				if (language == "RUS") {
				    document.getElementById("verexitmessage").innerHTML = verexitmessageRUS;
				} else {
					document.getElementById("verexitmessage").innerHTML = verexitmessageUK;
				};
			    document.getElementById("verexit").style.display = "block"; 
	            document.getElementById("verlogin").style.display = "none";
				document.getElementById('vermessage').style.display = "none";
				MVSUID = json.mvsuid;
				MVSNAME = json.name;
			} else if (json.value == "user_error") {
				messageRUS = "Не правильно указаны логин и/или пароль";
                messageUK = "The login and/or the password aren't correctly specified";
				if (language == "RUS") {
				    document.getElementById("message").innerHTML = messageRUS;
				} else {
					document.getElementById("message").innerHTML = messageUK;
				};
		        $("#login").focus();
				document.getElementById("verexit").style.display = "none"; 
	            document.getElementById("verlogin").style.display = "block";
				document.getElementById('vermessage').style.display = "none";
			} else {
				document.getElementById('vermessage').style.display = "block";
	            document.getElementById('verlogin').style.display = "none"; 
	            document.getElementById('verexit').style.display = "none";
			};	
		},
		error: function (xhr, ajaxOptions, thrownError) {
            document.getElementById('vermessage').style.display = "block";
	        document.getElementById('verlogin').style.display = "none"; 
	        document.getElementById('verexit').style.display = "none";
        }
    });
};

function setLanguageRUS() {
	language = "RUS";
	setLanguage(); 
	sessionStorage.setItem('lang', 'RUS');
};

function setLanguageUK() {
	language = "ENG";
    setLanguage(); 
	sessionStorage.setItem('lang', 'ENG');
};
