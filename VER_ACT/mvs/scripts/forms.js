function showModalWin(Msg) {
    var darkLayer = document.createElement('div'); // слой затемнения
    darkLayer.id = 'shadow'; // id чтобы подхватить стиль
    document.body.appendChild(darkLayer); // включаем затемнение

    var modalWin = document.getElementById('popupWin'); // находим наше "окно"
    modalWin.style.display = 'block'; 
	
	var TextWin = document.getElementById('textPopupWin');
	if (language == "RUS") {
	    TextWin.innerHTML=ListMessages[Msg].RUS;
	} else {
        TextWin.innerHTML=ListMessages[Msg].UK;
    }	
	var thght = TextWin.offsetHeight;
	
    var thwin = modalWin.offsetHeight;
	
	TextWin.style.marginTop = ((thwin - thght) / 2 - 50) + "px";	
	
	var ButtonPopupWin = document.getElementById('btnPopupWin');

    ButtonPopupWin.onclick = function () { 
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        modalWin.style.width = "300px";
		modalWin.style.height = "200px";
		modalWin.style.display = 'none'; // делаем окно невидимым
        return false;
    };
	
	darkLayer.onclick = function () { 
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        modalWin.style.display = 'none'; // делаем окно невидимым
        return false;
    };
}

function showDialogWin(Text, Msg, Action) {
	
    var darkLayer = document.createElement('div'); // слой затемнения
    darkLayer.id = 'shadow'; // id чтобы подхватить стиль
    document.body.appendChild(darkLayer); // включаем затемнение

    var dialogWin = document.getElementById('dialogWin'); // находим наше "окно"
    dialogWin.style.display = 'block'; 
	
	var TextWin = document.getElementById('textDialogWin');
	if (language == "RUS") {
	    TextWin.innerHTML=Text + " " + ListMessages[Msg].RUS;
	} else {
        TextWin.innerHTML=Text + " " + ListMessages[Msg].UK;
    }	
	var thght = TextWin.offsetHeight;
    TextWin.style.marginTop = ((200 - thght) / 2 - 10) + "px";
	
	var ButtonDialogOK = document.getElementById('btnDialogOK');

    ButtonDialogOK.onclick = function () { 
	    if (Action == "Exit") {
			clearRegistration();
			document.getElementById("imgusers").src = "images/users.png"
			document.getElementById("mode_users").style.color = "white";
			setLanguage();
		}
		if (Action == "REGISTRATION") {
			document.getElementById("imgusers").src = "images/usersgreen.png";
			document.getElementById("mode_users").style.color = "lime";
			userregistrated = true;
		    sessionStorage.setItem('isregistration','Yes');
			sessionStorage.userstatus = "0";
			setLanguage();
		}
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        dialogWin.style.display = 'none'; // делаем окно невидимым
		TextWin.style.color = "white";
        return false;
    };
	
	var ButtonDialogCancel = document.getElementById('btnDialogCancel');

    ButtonDialogCancel.onclick = function () { 
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        dialogWin.style.display = 'none'; // делаем окно невидимым
        TextWin.style.color = "white";
		return false;
    };
	
	//darkLayer.onclick = function () { 
    //    darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
    //    dialogWin.style.display = 'none'; // делаем окно невидимым
    //    return false;
    //};
}

function showMessageWin(Text, Delay) {
 
//    var darkLayer = document.createElement('div'); // слой затемнения
//    darkLayer.id = 'shadow'; // id чтобы подхватить стиль
//    document.body.appendChild(darkLayer); // включаем затемнение

    var messageWin = document.getElementById('messageWin'); // находим наше "окно"
    messageWin.style.display = 'block'; 
	
	var TextWin = document.getElementById('textMessageWin');
	TextWin.innerHTML=Text;
	var thght = TextWin.offsetHeight;
    TextWin.style.marginTop = ((200 - thght) / 2 - 10) + "px";
	
	var login = document.getElementById('login'); // находим наше "окно"
    login.style.display = 'none';
	
	darkLayer = document.getElementById('shadow');
	if (darkLayer !== null) {
	    darkLayer.parentNode.removeChild(darkLayer);
	}	
    tm = setTimeout(function() { clearTimeout(tm);
								 messageWin.style.display = 'none';
							   }, Delay);

}


function forminput() {
	document.getElementById("login").style.display = "block";
	//document.getElementById("container").style.display = "block";
}

function forminputexit() {
	//document.getElementById("container").style.display = "none";
	document.getElementById("login").style.display = "none";
	document.getElementById("register").style.display = "none";
}

function fshowregistration() {
   	document.getElementById("login").style.display = "none";
	document.getElementById("register").style.display = "block";
	document.getElementById("register").style.top = "80px";
}

function TopScreen() {
	window.scrollTo(0,0);
}

//$.get(url)
//    .done(function() { 
//        // exists code 
//    }).fail(function() { 
//        // not exists code
//    })

function userRegistration() {

    var ob = {
		name: "",
		subname: "",
		username: "",
        emailsignup: "",
        psw_signup: "",
        psw_confirm: ""		
	};
	
	ob.name = document.getElementById("namesignup").value;
	ob.subname = document.getElementById("subnamesignup").value;
	ob.username = document.getElementById("usernamesignup").value;
	ob.emailsignup = document.getElementById("emailsignup").value;
	ob.psw_signup = document.getElementById("passwordsignup").value;
	ob.psw_confirm = document.getElementById("passwordsignup_confirm").value;
	
	
	if (ob.name === "") {
		if (language == "RUS") {
		    document.getElementById("registrmess").innerHTML="Не задано имя пользователя.";
		} else {
			document.getElementById("registrmess").innerHTML="The user name isn't set";
		}
		$("#namesignup").focus();
		return false
	}
	
	if (ob.subname == "") {
		if (language == "RUS") {
		    document.getElementById("registrmess").innerHTML="Не задана фамилия пользователя.";
		} else {
			document.getElementById("registrmess").innerHTML="The user subname isn't set.";
		};
		$("#subnamesignup").focus();
		return false;
	};
	
	if (ob.username == "") {
		if (language == "RUS") {
		    document.getElementById("registrmess").innerHTML="Не задан логин пользователя.";
		} else {
			document.getElementById("registrmess").innerHTML="The login isn't set.";
		};
		$("#usernamesignup").focus();
		return false;
	};
	
	if (ob.emailsignup == "") {
		if (language == "RUS") {
		    document.getElementById("registrmess").innerHTML="Не задан E-mail пользователя.";
		} else {
			document.getElementById("registrmess").innerHTML="The E-mail isn't set.";
		};
		$("#emailsignup").focus();
		return false;
	} else {
		var test_str = /^[\w-\.]+@[\w-]+\.[a-z]{2,4}$/i;
        var valid = test_str.test(ob.emailsignup);
        if (!valid) {
			if (language == "RUS") {
		        document.getElementById("registrmess").innerHTML="E-mail задан неправильно.";
	      	} else {
			    document.getElementById("registrmess").innerHTML="E-mail is set incorrectly.";
		    };
		    $("#emailsignup").focus();
		    return false;
		}
	};
	
	if (ob.psw_signup == "") {
		if (language == "RUS") {
		    document.getElementById("registrmess").innerHTML="Не задан пароль пользователя.";
		} else {
			document.getElementById("registrmess").innerHTML="The password isn't set.";
		};
		$("#passwordsignup").focus();
		return false;
	};
	
	if (ob.psw_confirm == "") {
		if (language == "RUS") {
		    document.getElementById("registrmess").innerHTML="Пароль пользователя не поддтвержден.";
		} else {
			document.getElementById("registrmess").innerHTML="The user's password isn't confirmed.";
		};
		$("#passwordsignup_confirm").focus();
		return false;
	};
	
	if (ob.psw_confirm !== ob.psw_signup) {
		if (language == "RUS") {
		    document.getElementById("registrmess").innerHTML="Пароль и поддтверждение отличаются.";
		} else {
			document.getElementById("registrmess").innerHTML="The password and the confirm is different.";
		};
		$("#passwordsignup_confirm").focus();
		return false;
	};
	
	//var turl = document.location.href;
	var turl = getUrlPath() + "php/db_registr.php";

	var tmp;
		
        $.ajax({
            type:'POST',
            url:turl,
            dataType:'json',
            data: 'param=' + JSON.stringify(ob),
            success:function(json) {
				//console.log(json);
				tmp = json;
                var regs = tmp.regresult;

				if (regs=="user_OK") {
					
					if (tmp.code !== null && tmp.code !== "") { sendVerification(tmp.name,tmp.subname,tmp.emailsignup, tmp.code,language); };
					
				} else if (regs=="user_exist") {
					if (language == "RUS") {
		                document.getElementById("registrmess").innerHTML="Пользователь с таким логином существует.";
		            } else {
		            	document.getElementById("registrmess").innerHTML="The user with such login exist.";
		            };
					$("#usernamesignup").select();
					$("#usernamesignup").focus();
				} else if (regs=="email_exist") {
					if (language == "RUS") {
		                document.getElementById("registrmess").innerHTML="Пользователь с таким E-mail существует.";
		            } else {
		            	document.getElementById("registrmess").innerHTML="The user with such E-mail exist.";
		            };
					$("#emailsignup").select();
					$("#emailsignup").focus();
				} else if (regs=="user_error") {
					if (language == "RUS") {
		                document.getElementById("registrmess").innerHTML="Неправильно заданы данные.";
		            } else {
		            	document.getElementById("registrmess").innerHTML="Data are set incorrectly.";
		            };
					$("#usernamesignup").focus();
				};
            },
			error: function (xhr, ajaxOptions, thrownError) {
				if (language == "RUS") {
		            document.getElementById("registrmess").innerHTML="Ошибка доступа. Попытайтесь связаться позже.";
		        } else {
		        	document.getElementById("registrmess").innerHTML="Error of access. Try to connect later.";
		        };
		        var arrr = JSON.parse(xhr.responseText);
				sendSupport(ob.emailsignup,"regs00001",xhr.responseText);
            }
        })
}

function setUserStatus() {
	var stat = sessionStorage.userstatus;
	if (stat == null || stat == "") {
		document.getElementById("imgusers").src = "images/users.png";
	    document.getElementById("mode_users").style.color = "white";
		return;
	};
	if (stat == "0") {
	    document.getElementById("imgusers").src = "images/usersgreen.png";
	    document.getElementById("mode_users").style.color = "lime";
		return;
	};
	if (stat == "2") {
	    document.getElementById("imgusers").src = "images/usersgold.png";
	    document.getElementById("mode_users").style.color = "yellow";
		return;
	};
	if (stat == "4") {
	    document.getElementById("imgusers").src = "images/usersaqua.png";
	    document.getElementById("mode_users").style.color = "aqua";
		return;
	};
	if (stat == "6") {
	    document.getElementById("imgusers").src = "images/usersblue.png";
	    document.getElementById("mode_users").style.color = "rgb(224,190,255)";
		return;
	};
	if (stat == "255") {
	    document.getElementById("imgusers").src = "images/usersorange.png";
	    document.getElementById("mode_users").style.color = "orange";
		return;
	}
}


function userIdentification() {

    var ob = {
		login: "",
        passwrd: "" 		
	};
	ob.login = document.getElementById("username").value;
	ob.passwrd = document.getElementById("password").value;
	
	var sv = document.getElementById("loginkeeping").checked;
	if (sv) {
		var sss = localStorage.getItem('MySect');
		var tmp = "tces" + ob.login + "sect";
		var arrtmp=[];// = JSON.parse(sss);
		if (sss !== null) {
			arrtmp = JSON.parse(sss);
		};
		if (arrtmp.length > 0) {
			var a_exist = false;
			for (var i=0; i < arrtmp.length; i++) {
				if (arrtmp[i].u == tmp) {
					a_exist = true;
					arrtmp[i].d = "Df4s" + ob.passwrd + "fF7a";
					break;
				};
			}; 
			if (!a_exist) {
				var rcdone = new Object();
                rcdone.u = tmp;
                rcdone.d = "674s" + ob.passwrd + "f37j"; 
                arrtmp.length = arrtmp.length + 1;
                arrtmp[arrtmp.length-1] = rcdone;
			};
		} else {
		    var rcdone = new Object();
            rcdone.u = tmp;
            rcdone.d = "AD4s" + ob.passwrd + "R57g"; 
            arrtmp.length = 1;
            arrtmp[0] = rcdone; 			
		};
		
		var strJson = JSON.stringify(arrtmp);
		localStorage.MySect = strJson;
		var dd =2;
	};
	
	if (ob.login == "") {
		userregistrated = false;
		sessionStorage.setItem('isregistration','No');
		if (language == "RUS") {
		    document.getElementById("inputmess").innerHTML="Не задан логин.";
		} else {
			document.getElementById("inputmess").innerHTML="The login isn't set.";
		};
		$("#username").focus();
		return false;
	};
	if (ob.passwrd == "") {
		userregistrated = false;
		sessionStorage.setItem('isregistration','No');
		if (language == "RUS") {
		    document.getElementById("inputmess").innerHTML="Не задан пароль.";
		} else {
			document.getElementById("inputmess").innerHTML="The password isn't set.";
		};
		$("#password").focus();
		return false;
	};
	//var param = JSON.stringify(ob);
	var turl = getUrlPath() + "php/db_users.php";
	//var turl = document.location.href;
	//var ext = document.location.search;
	//var path = document.location.pathname;
	//var ext1 = document.location.hash;
	//var len = turl.length - ext1.length - ext.length;
	//turl = turl.substr(0,len) + "php/db_users.php";
	var tmp;
	//$(document).ready(function(){
	var iarr = JSON.stringify(ob);	
        $.ajax({
            type:'POST',
            url:turl,
            dataType:'json',
            data: 'param=' + JSON.stringify(ob),
            success:procSuccess,
			error: procError
        })
}
function procError(xhr, ajaxOptions, thrownError) {
				if (language == "RUS") {
		            document.getElementById("inputmess").innerHTML="Ошибка доступа. Попытайтесь связаться позже.";
		        } else {
		        	document.getElementById("inputmess").innerHTML="Error of access. Try to connect later.";
		        };
		        var earr = iarr;
		        var wrrr = JSON.parse(earr);
		        var sarr = xhr.responseText;
		        sarr = sarr.replace('\ufeff','')
		        var arrr = JSON.parse(sarr);
				var stxt = "User: " + ob.login + "  psw=" + ob.passwrd;
				sendSupport(stxt,"ver00001",xhr.responseText);
            }
function procSuccess(json) {
				console.log("phpanswer = "json);
				tmp = json;
                var regs = tmp.isregistration;
				var lg = tmp.login;//['login'];
				var lg1 = tmp.passwrd;
				var nm = tmp.name;
				var snm = tmp.subname;
				var prmsn = tmp.permission;
				var rgstr = tmp.registration;
				var tid = tmp.uid;
				if (rgstr == "0") {
					var modalWin = document.getElementById('popupWin');
					//var widthWin = modalWiv.offsetWidth;
					modalWin.style.width = "480px";
					modalWin.style.height = "300px";
					var s1 = ListMessages[8].RUS;
					var s2 = ListMessages[8].UK;
					if (language == "RUS") {
		                ListMessages[8].RUS = nm + " " + snm + " " + s1;
		            } else {
		            	ListMessages[8].UK = nm + " " + snm + " " + s2;
		            };
					var login = document.getElementById('login'); // находим наше "окно"
                    login.style.display = 'none';
					darkLayer = document.getElementById('shadow');
	                if (darkLayer !== null) { darkLayer.parentNode.removeChild(darkLayer); };
					showModalWin(8);
					ListMessages[8].RUS = s1;
					ListMessages[8].UK = s2;
					sessionStorage.userstatus = "";
					sessionStorage.MVSUID = "";
					userregistrated = false;
		            sessionStorage.setItem('isregistration','');
					setLanguage();
					document.getElementById("username").value = "";
	                document.getElementById("password").value = "";
					return false;
				}; 
				if (regs=="yes") {
					if (language == "RUS") {
		                var Text = "Добро пожаловать " + nm + "!";
		            } else {
		            	var Text = "Welcome " + nm + "!";
		            };
					document.getElementById("inputmess").innerHTML="";
					sessionStorage.userstatus = prmsn;
					setUserStatus();
					showMessageWin(Text, 1000);
					userregistrated = true;
		            sessionStorage.setItem('isregistration','Yes');
					sessionStorage.MVSUID = tid;
					setLanguage();
					document.getElementById("username").value = "";
	                document.getElementById("password").value = "";
					
				} else if (regs=="empty") {
					//userregistrated = false;
		            //sessionStorage.setItem('isregistration','');
					if (language == "RUS") {
		                document.getElementById("inputmess").innerHTML="Неправильно указаны логин или пароль.";
		            } else {
		            	document.getElementById("inputmess").innerHTML="The login or the password are wrong.";
		            };
					//$("#username").select();
					$("#username").focus();
				} else if (regs=="no") {
					//userregistrated = false;
		            //sessionStorage.setItem('isregistration','');
					if (language == "RUS") {
		                document.getElementById("inputmess").innerHTML="Неправильно указаны логин или пароль.";
		            } else {
		            	document.getElementById("inputmess").innerHTML="The login or the password are wrong.";
		            };
					$("#password").focus();
					//$("#password").select();
				} else if (regs=="data_error") {
					//userregistrated = false;
		            //sessionStorage.setItem('isregistration','');
					if (language == "RUS") {
		                document.getElementById("inputmess").innerHTML="Неправильные данные.";
		            } else {
		            	document.getElementById("inputmess").innerHTML="Data is wrong.";
		            };
					//$("#username").focus();
				};
            }

function sendSupport(src,codeerr,txt) {
	var uid = sessionStorage.MVSUID;
	if (uid == null || uid == "") {uid = -1; };
	var ob = {
		source: src,
		codeerror: codeerr,
        userid : uid,
        description : txt	
	};
	var turl = getUrlPath() + "php/support.php";
	$.ajax({
        type:'POST',
        url:turl,
        dataType:'json',
        data: 'param=' + JSON.stringify(ob),
        success:function(json) {
			console.log(json);
		},
		error: function (xhr, ajaxOptions, thrownError) {
			console.log('error');
        }
    })
}

function sendVerification(name,subname,adress,strcode,lang) {
	var ob = {
		email: adress,
		code: strcode,
        nm : name,
        snm : subname,	
        language: lang		
	};
	var turl = getUrlPath() + "php/email_verification.php";
	$.ajax({
        type:'POST',
        url:turl,
        dataType:'json',
        data: 'param=' + JSON.stringify(ob),
        success:function(json) {
			console.log(json);
			if (json.result == "yes") {

			    document.getElementById("registrmess").innerHTML="";
				document.getElementById("register").style.display = "none";
				darkLayer = document.getElementById('shadow');
	            if (darkLayer !== null) {
	                 darkLayer.parentNode.removeChild(darkLayer);
	            };

				var modalWin = document.getElementById('popupWin');
				modalWin.style.width = "480px";
				modalWin.style.height = "300px";
				

				sessionStorage.setItem('userstatus','0');
				var srtrus = ListMessages[9].RUS;
				var srteng = ListMessages[9].UK;
				ListMessages[9].RUS = name + srtrus;
				ListMessages[9].UK = name + srteng;
				showModalWin(9);
				ListMessages[9].RUS = srtrus;
				ListMessages[9].UK = srteng;
				//userregistrated = true;
		        //sessionStorage.setItem('isregistration','Yes');
				//setLanguage();
				document.getElementById("namesignup").value = "";
	            document.getElementById("subnamesignup").value = "";
				document.getElementById("usernamesignup").value = "";
	            document.getElementById("emailsignup").value = "";
				document.getElementById("passwordsignup").value = "";
	            document.getElementById("passwordsignup_confirm").value = "";
				
			} else if (json.result == "no") {
				document.getElementById("registrmess").innerHTML="";
				document.getElementById("register").style.display = "none";
				darkLayer = document.getElementById('shadow');
	            if (darkLayer !== null) {
	                 darkLayer.parentNode.removeChild(darkLayer);
	            };

				var modalWin = document.getElementById('popupWin');
				modalWin.style.width = "480px";
				modalWin.style.height = "300px";
				

				sessionStorage.setItem('userstatus',null);
				var srtrus = ListMessages[9].RUS;
				var srteng = ListMessages[9].UK;
				ListMessages[10].RUS = name + srtrus;
				ListMessages[10].UK = name + srteng;
				showModalWin(10);
				ListMessages[10].RUS = srtrus;
				ListMessages[10].UK = srteng;
				
				userregistrated = false;
		        sessionStorage.setItem('isregistration','');
				document.getElementById("namesignup").value = "";
	            document.getElementById("subnamesignup").value = "";
				document.getElementById("usernamesignup").value = "";
	            document.getElementById("emailsignup").value = "";
				document.getElementById("passwordsignup").value = "";
	            document.getElementById("passwordsignup_confirm").value = "";
				sendSupport(ob.email,"mail00001","Почтовый сервер не поставил письмо в очередь.");
			} else {
				document.getElementById("registrmess").innerHTML="";
				document.getElementById("register").style.display = "none";
				darkLayer = document.getElementById('shadow');
	            if (darkLayer !== null) {
	                 darkLayer.parentNode.removeChild(darkLayer);
	            };

				var modalWin = document.getElementById('popupWin');
				modalWin.style.width = "480px";
				modalWin.style.height = "300px";
				

				sessionStorage.setItem('userstatus',null);
				var srtrus = ListMessages[9].RUS;
				var srteng = ListMessages[9].UK;
				ListMessages[10].RUS = name + srtrus;
				ListMessages[10].UK = name + srteng;
				showModalWin(10);
				ListMessages[10].RUS = srtrus;
				ListMessages[10].UK = srteng;
				
				userregistrated = false;
		        sessionStorage.setItem('isregistration','');
				document.getElementById("namesignup").value = "";
	            document.getElementById("subnamesignup").value = "";
				document.getElementById("usernamesignup").value = "";
	            document.getElementById("emailsignup").value = "";
				document.getElementById("passwordsignup").value = "";
	            document.getElementById("passwordsignup_confirm").value = "";
				sendSupport(ob.email,"mail00004","Почтовый сервер не найден.");
			}
        },
		error: function (xhr, ajaxOptions, thrownError) {
			//console.log('error');
			document.getElementById("registrmess").innerHTML="";
			document.getElementById("register").style.display = "none";
			darkLayer = document.getElementById('shadow');
	        if (darkLayer !== null) {
	             darkLayer.parentNode.removeChild(darkLayer);
	        };

			var modalWin = document.getElementById('popupWin');
			modalWin.style.width = "480px";
			modalWin.style.height = "300px";
			

			sessionStorage.setItem('userstatus',null);
			var srtrus = ListMessages[9].RUS;
			var srteng = ListMessages[9].UK;
			ListMessages[10].RUS = name + srtrus;
			ListMessages[10].UK = name + srteng;
			showModalWin(10);
			ListMessages[10].RUS = srtrus;
			ListMessages[10].UK = srteng;
			
			userregistrated = false;
		    sessionStorage.setItem('isregistration','');
			document.getElementById("namesignup").value = "";
	        document.getElementById("subnamesignup").value = "";
			document.getElementById("usernamesignup").value = "";
	        document.getElementById("emailsignup").value = "";
			document.getElementById("passwordsignup").value = "";
	        document.getElementById("passwordsignup_confirm").value = "";
			sendSupport(ob.email,"mail00003",xhr.responseText);
        }
    })
}


function inputUserKeyUp() {
    $(document).ready(function() {
        $('#username,#password').keyup(function(event) {
            if(event.keyCode === 13) {
                userIdentification();
			}
        })
	})
}

function inputUserOnChange(event) {
    //var pss = document.getElementById('password').value;
    //if (pss !== "") { return;};	
    if (event.currentTarget.id == "username") {
		var tmpu = event.currentTarget.value;
		if (tmpu !== "") {
			var sss = localStorage.getItem('MySect');
		    var tmppsw = "tces" + tmpu + "sect";
		    var arrtmp=[];// = JSON.parse(sss);
		    if (sss !== null) {
			    arrtmp = JSON.parse(sss);
		    };
			if (arrtmp.length > 0) {
				for (var i=0; i < arrtmp.length; i++) {
					if (arrtmp[i].u == tmppsw) {
						var tmpp = arrtmp[i].d;
						if (tmpp.length > 8) {
						    tmpp = tmpp.substr(4,tmpp.length-8);
						    document.getElementById('password').value = tmpp;
						}
						break;
					}
				} 
		    }
			$("#username").focus();
		}	
	}
}

//function onClickLogin() {
//    var reg = sessionStorage.getItem('isregistration');
//	var name = sessionStorage.getItem('name');
//	if (name == null ) { name = ""; };
//	if (reg == null) {
//	    clearRegistration;
//		showLoginWin();
//	} else {
//	    if (reg == "Yes") {
//		    showDialogWin(name, 6, "Exit");
//	    } else {
//			showLoginWin();
//		}; 	
//	};	
//	setLanguage();
//}

function showDialogExitWin() {
	var name = sessionStorage.getItem('name');
	if (name == null ) { name = ""; };
	showDialogWin(name, 6, "Exit");
}


function showLoginWin() {
    document.getElementById("inputmess").innerHTML="";
    var darkLayer = document.createElement('div'); // слой затемнения
    darkLayer.id = 'shadow'; // id чтобы подхватить стиль
    document.body.appendChild(darkLayer); // включаем затемнение

    var login = document.getElementById('login'); // находим наше "окно"
    login.style.display = 'block'; 
	
	var ButtonExitWin = document.getElementById('exitlogin');

    ButtonExitWin.onclick = function () { 
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        login.style.display = 'none'; // делаем окно невидимым
        return false;
    }
	
	darkLayer.onclick = function () { 
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        login.style.display = 'none'; // делаем окно невидимым
        return false;
    }
	
	var BtnRegister = document.getElementById('idregister');

    BtnRegister.onclick = function () { 
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        login.style.display = 'none'; // делаем окно невидимым
        showRegisterWin();
        return false;
    }
}

function showRegisterWin() {

    var darkLayer = document.createElement('div'); // слой затемнения
    darkLayer.id = 'shadow'; // id чтобы подхватить стиль
    document.body.appendChild(darkLayer); // включаем затемнение

    var register = document.getElementById('register'); // находим наше "окно"
    register.style.display = 'block'; 
		
	var ButtonPopupWin = document.getElementById('exitregister');

    ButtonPopupWin.onclick = function () { 
	    document.getElementById("namesignup").value = "";
	    document.getElementById("subnamesignup").value = "";
		document.getElementById("usernamesignup").value = "";
	    document.getElementById("emailsignup").value = "";
		document.getElementById("passwordsignup").value = "";
	    document.getElementById("passwordsignup_confirm").value = "";
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        register.style.display = 'none'; // делаем окно невидимым
        return false;
    }
	
	darkLayer.onclick = function () { 
	    document.getElementById("namesignup").value = "";
	    document.getElementById("subnamesignup").value = "";
		document.getElementById("usernamesignup").value = "";
	    document.getElementById("emailsignup").value = "";
		document.getElementById("passwordsignup").value = "";
	    document.getElementById("passwordsignup_confirm").value = "";
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        register.style.display = 'none'; // делаем окно невидимым
        return false;
    }
	
	var BtnLogin = document.getElementById('idlogin');

    BtnLogin.onclick = function () { 
	    document.getElementById("namesignup").value = "";
	    document.getElementById("subnamesignup").value = "";
		document.getElementById("usernamesignup").value = "";
	    document.getElementById("emailsignup").value = "";
		document.getElementById("passwordsignup").value = "";
	    document.getElementById("passwordsignup_confirm").value = "";
        darkLayer.parentNode.removeChild(darkLayer); // удаляем затемнение
        register.style.display = 'none'; // делаем окно невидимым
        showLoginWin();
        return false;
    }
}

function showPersonalAccount() {
   document.location.href = "pages/notpage.html";	
}

function showpopUserMenu() {
	var popmenu = document.getElementById("popusermenu");
	
	var fs = document.getElementById("navigation").style.fontSize;
	fs = fs.replace("px","");
	fs = 0.75 * Math.floor(fs);
	//var fs=(22/ 1000) * window.innerWidth;
	//if (fs > 22) { fs = 22; };
	//if (fs < 7) { fs = 7; };
	popmenu.style.fontSize = fs + "px";
	
	$('#boundusermenu .listusermenu li').remove();
	 //$("#myList li").eq(1).remove();
	if (userregistrated) {
		if (language == "RUS") {
		    $('#boundusermenu .listusermenu').append('<li class="cluserli" onclick=showLoginWin()>Сменить пользователя</li>');
		    $('#boundusermenu .listusermenu').append('<li class="cluserli" onclick=showPersonalAccount()>Личный кабинет</li>');
		    $('#boundusermenu .listusermenu').append('<li class="cluserli" onclick=showDialogExitWin()>Выход</li>');
		} else {
			$('#boundusermenu .listusermenu').append('<li class="cluserli" onclick=showLoginWin()>To replace the user</li>');
		    $('#boundusermenu .listusermenu').append('<li class="cluserli" onclick=showPersonalAccount()>Personal account</li>');
		    $('#boundusermenu .listusermenu').append('<li class="cluserli" onclick=showDialogExitWin()>Exit</li>');
		};
		var pnwdth = Math.floor(11.6 * fs);
		popmenu.style.width = pnwdth + "px";
		popmenu.style.height = 5 * fs + "px";
	} else {
		if (language == "RUS") {
			$('#boundusermenu .listusermenu').append('<li class="cluserli" onclick="showLoginWin()">Вход</li>');
		    $('#boundusermenu .listusermenu').append('<li class="cluserli" onclick="showRegisterWin()">Регистрация</li>');
		} else {
	    	$('#boundusermenu .listusermenu').append('<li class="cluserli" onclick="showLoginWin()">Entrance</li>');
		    $('#boundusermenu .listusermenu').append('<li class="cluserli" onclick="showRegisterWin()">Registration</li>');
		};
		var pnwdth = Math.floor(6.6 * fs);
		popmenu.style.width = pnwdth + "px";
		popmenu.style.height = 3 * fs + "px";
	};

    var leftPos  = $("#divusers")[0].getBoundingClientRect().left   + $(window)['scrollLeft']();
    var rightPos = $("#divusers")[0].getBoundingClientRect().right  + $(window)['scrollLeft']();
    var topPos   = $("#divusers")[0].getBoundingClientRect().top    + $(window)['scrollTop']();
    var bottomPos= $("#divusers")[0].getBoundingClientRect().bottom + $(window)['scrollTop']();
    var wdth = document.getElementById("imgusers").offsetWidth;
	popmenu.style.display = "block";
	popmenu.style.left = Math.floor(leftPos - (pnwdth-wdth)/4) + "px";
	popmenu.style.top = bottomPos - 3 + "px";
}

function showpopUserMenu1() {
	var popmenu = document.getElementById("popusermenu");

    //var leftPos  = $("#divusers")[0].getBoundingClientRect().left   + $(window)['scrollLeft']();
    //var rightPos = $("#divusers")[0].getBoundingClientRect().right  + $(window)['scrollLeft']();
    //var topPos   = $("#divusers")[0].getBoundingClientRect().top    + $(window)['scrollTop']();
    //var bottomPos= $("#divusers")[0].getBoundingClientRect().bottom + $(window)['scrollTop']();
    //var wdth = document.getElementById("imgusers").offsetWidth;
	popmenu.style.display = "block";
	//popmenu.style.left = Math.floor(leftPos - (pnwdth-wdth)/4) + "px";
	//popmenu.style.top = bottomPos + "px";
}

function closepopUserMenu() {
	var popmenu = document.getElementById("popusermenu");
	popmenu.style.display = "none";
}
