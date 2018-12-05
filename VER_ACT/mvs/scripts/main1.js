var MinSize = 850;
var language = "RUS";
var TypeBrowser = "";
var indexMainImage = 1; 
var productInterval = 0;
var productDelay = 3000;
var browserName = "";
var browserVersia = "";
var userregistrated = false;

function initProducts() {
	var nom = 0;
	for (var i=0; i < 4; i++) {
        nom++;	
        var posi = +ProductIndex + +i;
        if (posi > ListProducts.length - 1) {
		    posi = posi - ListProducts.length;
		}
	    document.getElementById("prod"+nom).style.backgroundImage="url(" + ListProducts[posi].image + ")";
		document.getElementById("prod"+nom).style.backgroundRepeat="no-repeat";
		document.getElementById("prod"+nom+"txt").style.color = ListProducts[posi].textcolor;
		if (ListProducts[posi].page !== "") {
		    document.getElementById("prod"+nom+"herf").href = ListProducts[posi].page;
		} else {
			document.getElementById("prod"+nom+"herf").href = "pages/notpage.html";
		};
		if (language == "RUS") {
		   document.getElementById("prod"+nom+"txt").innerHTML = ListProducts[posi].textRUS;
		} else {
           document.getElementById("prod"+nom+"txt").innerHTML = ListProducts[posi].textUK;
        }		
	}
}	

function initServices1() {
	var nom = 0;
	for (var i=0; i < 4; i++) {
        nom++;	
        var posi = +ServicesIndex1 + +i;
        if (posi > ListServices1.length - 1) {
		    posi = posi - ListServices1.length;
		}		
	    document.getElementById("serv1_"+nom).style.backgroundImage="url(" + ListServices1[posi].image + ")";;
		document.getElementById("serv1_"+nom).style.backgroundRepeat="no-repeat";
		document.getElementById("serv1_"+nom+"txt").style.color = ListServices1[posi].textcolor;
		document.getElementById("serv1_"+nom+"herf").href = ListServices1[posi].page;
		if (language == "RUS") {
		   document.getElementById("serv1_"+nom+"txt").innerHTML = ListServices1[posi].textRUS;
		} else {
           document.getElementById("serv1_"+nom+"txt").innerHTML = ListServices1[posi].textUK;
        }
	}
}

function initServices2() {
	var nom = 0;
	for (var i=0; i < 4; i++) {
        nom++;
        var posi = +ServicesIndex2 + +i;
        if (posi > ListServices2.length - 1) {
		    posi = posi - ListServices2.length;
		} 		
	    document.getElementById("serv2_"+nom).style.backgroundImage="url(" + ListServices2[posi].image + ")";;
		document.getElementById("serv2_"+nom).style.backgroundRepeat="no-repeat";
		document.getElementById("serv2_"+nom+"txt").style.color = ListServices2[posi].textcolor;
		document.getElementById("serv2_"+nom+"herf").href = ListServices2[posi].page;
		if (language == "RUS") {
		   document.getElementById("serv2_"+nom+"txt").innerHTML = ListServices2[posi].textRUS;
		} else {
           document.getElementById("serv2_"+nom+"txt").innerHTML = ListServices2[posi].textUK;
        }
	}
}

function InitLastRow() {
	var FRow = document.getElementById("lastrow");
	
	var str1 = "<ul id='tabfooter1'>";
	for (var i = 0; i < ListFooter1.length; i++) {
		str1 = str1 + "<li><a href='" + ListFooter1[i].page + "'>";
        if (language == "RUS") {
			str1 = str1 + ListFooter1[i].RUS + "</a></li>";
		} else {
			str1 = str1 + ListFooter1[i].UK + "</a></li>";
		};		
	};   
    str1 = str1 + "</ul>";
	FRow.cells[1].innerHTML = str1;
	
	var str2 = "<ul id='tabfooter2'>";
	for (var i = 0; i < ListFooter2.length; i++) {
		str2 = str2 + "<li><a href='" + ListFooter2[i].page + "'>";
        if (language == "RUS") {
			str2 = str2 + ListFooter2[i].RUS + "</a></li>";
		} else {
			str2 = str2 + ListFooter2[i].UK + "</a></li>";
		};		
	};   
    str2 = str2 + "</ul>";
	FRow.cells[2].innerHTML = str2;
	
	var str3 = "<ul id='tabfooter3'>";
	for (var i = 0; i < ListFooter3.length; i++) {
		str3 = str3 + "<li><a href='" + ListFooter3[i].page + "'>";
        if (language == "RUS") {
			str3 = str3 + ListFooter3[i].RUS + "</a></li>";
		} else {
			str3 = str3 + ListFooter3[i].UK + "</a></li>";
		};		
	};   
    str3 = str3 + "</ul>";
	FRow.cells[3].innerHTML = str3;
	
	var str4 = "<ul id='tabfooter4'>";
	for (var i = 0; i < ListFooter4.length; i++) {
		str4 = str4 + "<li><a href='" + ListFooter4[i].page + "'>";
        if (language == "RUS") {
			str4 = str4 + ListFooter4[i].RUS + "</a></li>";
		} else {
			str4 = str4 + ListFooter4[i].UK + "</a></li>";
		};		
	};   
    str4 = str4 + "</ul>";
	FRow.cells[4].innerHTML = str4;
};


function setLanguage() {
	
	if (language == "RUS") {
	    document.getElementById("divflagrus").style.opacity = 1;
	    document.getElementById("divflagrus").style.filter = "alpha(opacity=100)";
	    document.getElementById("divflaguk").style.opacity = 0.4;
	    document.getElementById("divflaguk").style.filter ="alpha(opacity=40)";
	    document.getElementById("divlanguage").innerHTML = "RUS";
		if (userregistrated) {
			document.getElementById("mode_users").innerHTML= "Выход";
			document.getElementById("mode_users").style.marginLeft = "10%";
		} else {
		    document.getElementById("mode_users").innerHTML= "Вход";
			document.getElementById("mode_users").style.marginLeft = "15%";
		};
		document.getElementById("iddivintext").innerHTML = "Вход";
		document.getElementById("iduname").innerHTML = "Логин или e-mail";
		document.getElementById("username").placeholder = "логин или e-mail";
		document.getElementById("idyoupasswd").innerHTML = "Пароль";
		document.getElementById("password").placeholder = "например 123456";
		document.getElementById("idloginkeeping").innerHTML = "Запомнить меня";
		document.getElementById("btnexecute").value = "Войти";
		document.getElementById("idregister").innerHTML = "Зарегистрироваться";
		
		document.getElementById("idregdivintext").innerHTML = "Регистрация";
		document.getElementById("idlbregname").innerHTML = "Имя";
		document.getElementById("namesignup").placeholder = "Пётр";
		document.getElementById("idlbregsubname").innerHTML = "Фамилия";
		document.getElementById("subnamesignup").placeholder = "Иванов";
		document.getElementById("idlbreglogin").innerHTML = "Логин";
		document.getElementById("usernamesignup").placeholder = "myname1";
		document.getElementById("idlbregmail").innerHTML = "E-mail";
		document.getElementById("emailsignup").placeholder = "sitehere@my.com";
		document.getElementById("idlbregpassword").innerHTML = "Пароль";
		document.getElementById("passwordsignup").placeholder = "123456";
		document.getElementById("idlbregconfirm").innerHTML = "Подтвердите пароль";
		document.getElementById("passwordsignup_confirm").placeholder = "123456";
		document.getElementById("btnconfirm").value = "Зарегистрировать";
		document.getElementById("idlogin").innerHTML = "Войти на сайт";
		document.getElementById("btnDialogOK").value = "Да";
		document.getElementById("btnDialogCancel").value = "Нет";
	} else {
	    document.getElementById("divflagrus").style.opacity = 0.4;
	    document.getElementById("divflagrus").style.filter = "alpha(opacity=40)";
	    document.getElementById("divflaguk").style.opacity = 1;
	    document.getElementById("divflaguk").style.filter="alpha(opacity=100)";
	    document.getElementById("divlanguage").innerHTML = "ENG";
		if (userregistrated) {
			document.getElementById("mode_users").innerHTML= "Exit";
			document.getElementById("mode_users").style.marginLeft = "15%";
		} else {
		    document.getElementById("mode_users").innerHTML= "Entrance";
			document.getElementById("mode_users").style.marginLeft = "1%";
		};
		document.getElementById("iddivintext").innerHTML = "Entrance";
		document.getElementById("iduname").innerHTML = "Login or e-mail";
		document.getElementById("username").placeholder = "login or e-mail";
		document.getElementById("idyoupasswd").innerHTML = "Password";
		document.getElementById("password").placeholder = "sample 123456";
		document.getElementById("idloginkeeping").innerHTML = "Remember me";
		document.getElementById("btnexecute").value = "Enter";
		document.getElementById("idregister").innerHTML = "Register";
		
		document.getElementById("idregdivintext").innerHTML = "Registration";
		document.getElementById("idlbregname").innerHTML = "Name";
		document.getElementById("namesignup").placeholder = "Peter";
		document.getElementById("idlbregsubname").innerHTML = "Subname";
		document.getElementById("subnamesignup").placeholder = "Smith";
		document.getElementById("idlbreglogin").innerHTML = "Login";
		document.getElementById("usernamesignup").placeholder = "myname1";
		document.getElementById("idlbregmail").innerHTML = "E-mail";
		document.getElementById("emailsignup").placeholder = "sitehere@my.com";
		document.getElementById("idlbregpassword").innerHTML = "Password";
		document.getElementById("passwordsignup").placeholder = "123456";
		document.getElementById("idlbregconfirm").innerHTML = "Confirm password";
		document.getElementById("passwordsignup_confirm").placeholder = "123456";
		document.getElementById("btnconfirm").value = "Register";
		document.getElementById("idlogin").innerHTML = "To enter on the website";
		document.getElementById("btnDialogOK").value = "Yes";
		document.getElementById("btnDialogCancel").value = "No";
    };
	

	var tagList = document.getElementById("navigation");
	fnt = tagList.style.fontSize;
	fnt = fnt.replace("px","");
	var fs= (fnt - 4).toFixed(0);
	if (fs < 7) { fs = 7; };
	
	var j = 0;
	for (var i = 0; i < tagList.childElementCount; i++){
        var tn = tagList.children[i].tagName;
        var nn = tagList.children[i].nodeName;		
        if (tagList.children[i].tagName == "LI") { 
		    var strsubmenu = "";
			if (ListMenus[j].submenu.length > 0) {
				strsubmenu = "<ul id='mm" + j + "' style='font-size: " + fs + "px;'>";
				for (var indx = 0; indx < ListMenus[j].submenu.length; indx++) {
					var idsmm = "mm" + j +"s" + indx;
					var txtloc = window.location.href;
					var cpg = ListMenus[j].submenu[indx].page
					var lenloc = txtloc.length;
					var lencpg = cpg.length;
					var loc = txtloc.substring(lenloc - lencpg);
					if (loc.toLowerCase() == cpg.toLowerCase()) {
						var clr = "aqua";
					//} else {
					//	var clr = "white";
					};
					var txtlink = "<a id='" + idsmm + "' style='font-size: " + fs + "px; color: " + clr + ";' href='" + ListMenus[j].submenu[indx].page + "'>";
					if (language == "RUS") {
						strsubmenu = strsubmenu + "<li>" + txtlink + ListMenus[j].submenu[indx].RUS + "</a></li>";
					} else {
						strsubmenu = strsubmenu + "<li>" + txtlink + ListMenus[j].submenu[indx].UK + "</a></li>";
					};
				};
				strsubmenu = strsubmenu + "</ul>";
			}	
	        if (language == "RUS") {
				var txt = "<a href='" + ListMenus[j].page + "'> " + ListMenus[j].RUS + "</a>" + strsubmenu;
			    tagList.children[i].innerHTML = txt;
	        } else {
				var txt = "<a href='" + ListMenus[j].page + "'> " + ListMenus[j].UK + "</a>" + strsubmenu;
			    tagList.children[i].innerHTML = txt;
            }
			j++;
		}
	}
	

	if (indexMainImage == null) { indexMainImage = 0 }; 
	
	if (language == "RUS") {
	    document.getElementById("textup").innerHTML = ListTitles[indexMainImage].textRUS;
		document.getElementById("ttlproducts").innerHTML  = ListSections[0].RUS;
		document.getElementById("ttlservices1").innerHTML = ListSections[1].RUS;
		document.getElementById("ttlservices2").innerHTML = ListSections[2].RUS;
		document.getElementById("ttlsupports").innerHTML  = ListSections[3].RUS;
        document.getElementById("txtdownload").innerHTML  = "Скачать данные ";
        document.getElementById("txtdocumentations").innerHTML  = "Документация";	
        document.getElementById("txtlibraries").innerHTML  = "Библиотека";
        document.getElementById("txtcontacts").innerHTML  = "Контакты"; 
        document.getElementById("myfooter").innerHTML  = whosisDisigner[0].RUS;//"&copy; MVSGroup.tv 2018. Разработчик Завьялов П.А."; 		
	} else {
	    document.getElementById("textup").innerHTML = ListTitles[indexMainImage].textUK;
		document.getElementById("ttlproducts").innerHTML  = ListSections[0].UK;
		document.getElementById("ttlservices1").innerHTML = ListSections[1].UK;
		document.getElementById("ttlservices2").innerHTML = ListSections[2].UK;
		document.getElementById("ttlsupports").innerHTML  = ListSections[3].UK;
		document.getElementById("txtdownload").innerHTML  = "Download ";
        document.getElementById("txtdocumentations").innerHTML  = "Documentation";	
        document.getElementById("txtlibraries").innerHTML  = "Library";
        document.getElementById("txtcontacts").innerHTML  = "Contacts";
        document.getElementById("myfooter").innerHTML  = whosisDisigner[0].UK;//"&copy; MVSGroup.tv 2018. Design of P.Zavialov";		
	}
	
	initProducts();
	initServices1();
	initServices2();
	
	var foot1List = document.getElementById("tabfooter1");
	for (var i = 0; i < foot1List.childElementCount; i++){					
        foot1List.children[i].style.color = "white";
	    if (language == "RUS") {
			var txt = "<a href='" + ListFooter1[i].page + "'> " + ListFooter1[i].RUS + "</a>";
		    foot1List.children[i].innerHTML = txt;
	    } else {
			var txt = "<a href='" + ListFooter1[i].page + "'> " + ListFooter1[i].UK + " </a>";
		    foot1List.children[i].innerHTML = txt;
        }
	}
	
	var foot2List = document.getElementById("tabfooter2");
	for (var i = 0; i < foot2List.childElementCount; i++){					
        foot2List.children[i].style.color = "white";
	    if (language == "RUS") {
			var txt = "<a href='" + ListFooter2[i].page + "'> " + ListFooter2[i].RUS + "</a>";
		    foot2List.children[i].innerHTML = txt;
	    } else {
			var txt = "<a href='" + ListFooter2[i].page + "'> " + ListFooter2[i].UK + " </a>";
		    foot2List.children[i].innerHTML = txt;
        }
	}
	
	var foot3List = document.getElementById("tabfooter3");
	for (var i = 0; i < foot3List.childElementCount; i++){					
        foot3List.children[i].style.color = "white";
	    if (language == "RUS") {
			var txt = "<a href='" + ListFooter3[i].page + "'> " + ListFooter3[i].RUS + "</a>";
		    foot3List.children[i].innerHTML = txt;
	    } else {
			var txt = "<a href='" + ListFooter3[i].page + "'> " + ListFooter3[i].UK + " </a>";
		    foot3List.children[i].innerHTML = txt;
        }
	}
	
	var foot4List = document.getElementById("tabfooter4");
	for (var i = 0; i < foot4List.childElementCount; i++){					
        foot4List.children[i].style.color = "white";
	    if (language == "RUS") {
			var txt = "<a href='" + ListFooter4[i].page + "'> " + ListFooter4[i].RUS + "</a>";
		    foot4List.children[i].innerHTML = txt;
	    } else {
			var txt = "<a href='" + ListFooter4[i].page + "'> " + ListFooter4[i].UK + " </a>";
		    foot4List.children[i].innerHTML = txt;
        }
	}
}

function sizeMainMenu(Width) {
    var wdth = 0.25 * Width;
	if (wdth > 200) { wdth = 200; };
	if (wdth < 100) {wdth = 100; };
	var hght = (wdth / 200) * 40;
	
	var logo = document.getElementById("mylogo");
	var dlogo = document.getElementById("divmylogo");
	logo.style.width=wdth + "px";
	logo.style.height=hght + "px";
	
	dlogo.style.width=wdth + "px";
	dlogo.style.height=hght + "px";//"50px";
	
	var mhght = 80;
	if (window.innerWidth < 1500) {
	    mhght = (window.innerWidth / 1500) * 80;
       	if (mhght < 40) { mhght = 40; };   	
	}
	document.getElementById("mainmenu").style.height = mhght + "px";
		
	dlogo.style.marginTop=(mhght - hght) / 2 + "px";
	
	var tagList = document.getElementById("navigation");
	
	var fsli = 22;
	if ((Width-wdth) < +MinSize) {
		var fsli = ((Width-wdth) / MinSize) * 22;
		if (fsli < 8) { fsli = 8 }; 
        for (var i = 0; i < tagList.childElementCount; i++){			
            tagList.children[i].style.width = "14%";
			tagList.children[i].style.color = "white";	
		}		
	} else {
        var szz = ((Width-wdth) / MinSize) * 14;
  		if (szz > 20) { szz = 20; };
        var sztxt = szz + "%";		
        for (var i = 0; i < tagList.childElementCount; i++) {
	    	tagList.children[i].style.width = sztxt;
		    tagList.children[i].style.color = "white";
		};
	};
	
	tagList.style.fontSize=fsli + "px";
	tagList.style.marginTop= (mhght - fsli) / 2 + "px";
	
	var fsout = fsli;
	
	fsli = fsli - 6;
	if (+fsli < 6) {fsli = 6};
	
	var idreg = document.getElementById("idregistration");
	
	idreg.style.fontSize = fsli + "px";
	document.getElementById("divlanguage").style.fontSize=fsli + "px";
	document.getElementById("divlanguage").style.marginTop = (mhght - fsli) /2 + "px";
	
	var fsu=(11/ 1000) * Width;
	if (fsu > 11) { fsu = 11; };
	if (fsu < 5) { fsu = 6; };
	document.getElementById("mode_users").style.fontSize=fsu + "px";

	var imghght = 0.45 * mhght;
	
	document.getElementById("divusers").style.height = imghght + "px";
	document.getElementById("divusers").style.width = imghght + "px";
	document.getElementById("imgusers").style.height = imghght + "px";
	document.getElementById("imgusers").style.width = imghght + "px";
	document.getElementById("divusers").style.marginTop = (mhght - imghght) /2 + "px";
	
	imghght = 0.25 * mhght;
	
	document.getElementById("divflaguk").style.height = imghght + "px";
	document.getElementById("divflaguk").style.width = 1.2 * imghght + "px";
	document.getElementById("imgflaguk").style.height = imghght + "px";
	document.getElementById("imgflaguk").style.width = 1.2 * imghght + "px";
	document.getElementById("divflaguk").style.marginTop = (mhght - imghght) /2 + "px";
	
	document.getElementById("divflagrus").style.height = imghght + "px";
	document.getElementById("divflagrus").style.width = 1.2 * imghght + "px";
	document.getElementById("imgflagrus").style.height = imghght + "px";
	document.getElementById("imgflagrus").style.width = 1.2 * imghght + "px";
	document.getElementById("divflagrus").style.marginTop = (mhght - imghght) /2 + "px";
};	

function sizeRowMainImage(Width) {
	var fs=(38/ 1000) * Width;
	if (fs > 38) { fs = 38; };
	document.getElementById("textup").style.fontSize=fs + "px";
	var height = Width / 1.21; 
	document.getElementById("mainrow1").style.height = height - 100 + "px";
    //document.getElementById("mainrow1").style.width = Width - 40 + "px";
	document.getElementById("textup").style.marginTop = 0.5 * (height - 100) + "px";
	document.getElementById("textup").style.paddingTop = 0.2 * (height-100) + "px";
};	

function sizeRowProducts(Width) {
    var fs=(26/ 1000) * Width;
	if (fs > 26) { fs = 26; };
	if (fs < 10) { fs = 10; };
	var ttlp = document.getElementById("ttlproducts"); 
	ttlp.style.fontSize=fs + "px";
	ttlp.style.height=0.075*(Width / 1.21) + "px";
	ttlp.innerHTML = "<a class='titlelink' href='pages/products.html'> Продукты </a>";
	var fs1=(20 / 1000) * Width;
	if (fs1 > 20) { fs1 = 20; };
	if (fs1 < 6) { fs1 = 6; };
	document.getElementById("rowproducts").style.fontSize=fs1 + "px";
	var height = Width / 4;
    document.getElementById("rowproducts").style.height = height + "px";
}	

function sizeRowServices1(Width) {
    var fs=(26/ 1000) * Width;
	if (fs > 26) { fs = 26; };
	if (fs < 10) { fs = 10; };
	document.getElementById("ttlservices1").style.fontSize=fs + "px";
	document.getElementById("ttlservices1").style.height=0.075*(Width / 1.21) + "px";
	var fs1=(20 / 1000) * Width;
	if (fs1 > 20) { fs1 = 20; };
	if (fs1 < 6) { fs1 = 6; };
	document.getElementById("rowservices1").style.fontSize=fs1 + "px";
	var height = Width / 4;
    document.getElementById("rowservices1").style.height = height + "px";
}

function sizeRowServices2(Width) {
    var fs=(26/ 1000) * Width;
	if (fs > 26) { fs = 26; };
	if (fs < 10) { fs = 10; };
	document.getElementById("ttlservices2").style.fontSize=fs + "px";
	document.getElementById("ttlservices2").style.height=0.075*(Width / 1.21) + "px";
	var fs1=(20 / 1000) * Width;
	if (fs1 > 20) { fs1 = 20; };
	if (fs1 < 6) { fs1 = 6; };
	document.getElementById("rowservices2").style.fontSize=fs1 + "px";
	var height = Width / 4;
    document.getElementById("rowservices2").style.height = height + "px";
}	

function sizeSupports(Width) {
	var fs=(26/ 1000) * Width;
	if (fs > 26) { fs = 26; };
	if (fs < 10) { fs = 10; };
	document.getElementById("ttlsupports").style.fontSize=fs + "px";
	var fs1=(20 / 1000) * Width;
	if (fs1 > 20) { fs1 = 20; };
	if (fs1 < 6) { fs1 = 6; };
	document.getElementById("txtdownload").style.fontSize = fs1 + "px";
	document.getElementById("txtdocumentations").style.fontSize = fs1 + "px";
	document.getElementById("txtlibraries").style.fontSize = fs1 + "px";
	document.getElementById("txtcontacts").style.fontSize = fs1 + "px";
	
	var height = Width / 6;
	document.getElementById("ttlsupports").style.height=0.075*(Width / 1.21) + "px";
    document.getElementById("rowsupports").style.height = height + "px";
	document.getElementById("imgdownload").style.height = height + "px";
	document.getElementById("imgdocumentations").style.height = height + "px";
	document.getElementById("imglibraries").style.height = height + "px";
	document.getElementById("imgcontacts").style.height = height + "px";
	
}

function sizeFooter(Width) {
	
	InitLastRow();
	
	var fsft=(12/ 1000) * Width;
	if (fsft > 12) { fsft = 12; };
	if (fsft < 7) { fsft = 7; };
    var ft1 = document.getElementById("tabfooter1");
	ft1.style.fontSize=fsft + "px";
    var ft2 = document.getElementById("tabfooter2");
	ft2.style.fontSize=fsft + "px";
    var ft3 = document.getElementById("tabfooter3");
	ft3.style.fontSize=fsft + "px";
    var ft4 = document.getElementById("tabfooter4");
	ft4.style.fontSize=fsft + "px";
	if (ft2.children.length > ListFooter2.length) {
        for (var j= ft2.children.length - 1; j>=ListFooter2.length; j--) {
		    ft2.children.remoteChild[j];
		}	
	}
	
	
	fsft=(14/ 1000) * Width;
	if (fsft > 14) { fsft = 14; };
	if (fsft < 8) { fsft = 8; };
	document.getElementById("myfooter").style.fontSize=fsft + "px";
}	

function myresize() {
	
	//var lang = sessionStorage.getItem('lang');
	//if (lang !== null) { 
    //    language = lang; 
	//}  else {
	//    language = "RUS"; 
	//};
	
    var width = 0.6 * window.innerWidth;
	var myhght =  0.075 * window.innerHeight;
	//document.getElementById("beetwinrow").style.height = myhght + "px";
 //   if (width > 100) { width = 0.6 * width; };
	//width = 0.6 * width;
    sizeMainMenu(width);
	sizeRowMainImage(width);
	sizeRowProducts(width);
	sizeRowServices1(width);
	sizeRowServices2(width);
    sizeSupports(width);
	sizeFooter(width);
	
	var hgh0 = document.getElementById("mainmenu").offsetHeight;
    var hgh1 = document.getElementById("mainrow1").offsetHeight;
	var hgh2 = document.getElementById("rowproducts").offsetHeight;
	var hgh3 = document.getElementById("ttlservices1").offsetHeight;
	var hgh4 = document.getElementById("rowsupports").offsetHeight;
	var hgh5 = document.getElementById("lastrow").offsetHeight;
	var hgh6 = document.getElementById("myfooter").offsetHeight;

    var height =  window.innerHeight - hgh0 - hgh1 - 3*hgh2 - 4*hgh3 - hgh4 - hgh5 - hgh6 - 80;	
	if (height < 0) { height=0; };
    document.getElementById("beetwinrow").style.height = height + "px";
	
	setLanguage();
	
	//setMainMenuFont(fsmn);
}


	function productsleft() {
        ProductIndex++;
        if (ProductIndex > ListProducts.length - 1) { ProductIndex = 0; };
	    initProducts();
	}
	
	function productsright() {
        ProductIndex--;
        if (ProductIndex < 0) { ProductIndex = ListProducts.length - 1; };
	    initProducts();
	}
	
	function productcycleleft() {
	    productInterval = setInterval(productsleft,productDelay);
	}
	
	function productcycleright() {
	    productInterval = setInterval(productsright,productDelay);
	}
	
	function productend() {
		clearInterval(productInterval);
	}
	
	function serviceleft1() {
		ServicesIndex1++;
        if (ServicesIndex1 > ListServices1.length - 1) { ServicesIndex1 = 0; };
	    initServices1();
	}
	
	function serviceright1() {
	    ServicesIndex1--;
        if (ServicesIndex1 < 0) { ServicesIndex1 = ListServices1.length - 1; };
	    initServices1();
	}
	
	function servicetcycleleft1() {
	    productInterval = setInterval(serviceleft1,productDelay);
	}
	
	function servicecycleright1() {
	    productInterval = setInterval(serviceright1,productDelay);
	}
	
	function serviceleft2() {
        ServicesIndex2++;
        if (ServicesIndex2 > ListServices2.length - 1) { ServicesIndex2 = 0; };
	    initServices2();
	}
	
	function serviceright2() {
	    ServicesIndex2--;
        if (ServicesIndex2 < 0) { ServicesIndex2 = ListServices2.length - 1; };
	    initServices2();
	}
	
	function servicetcycleleft2() {
	    productInterval = setInterval(serviceleft2,productDelay);
	}
	
	function servicecycleright2() {
	    productInterval = setInterval(serviceright2,productDelay);
	}
	
	function setLanguageRUS(page) {
		language = "RUS";
		if (page == "page") {
		    setLanguagePage("../");
		} else {	
		    setLanguage(); 
		};
		sessionStorage.setItem('lang', 'RUS');
	}
	
	function setLanguageUK(page) {
		language = "ENG";
		if (page == "page") {
		    setLanguagePage("../");
		} else {	
		    setLanguage(); 
		};
		sessionStorage.setItem('lang', 'ENG');
	}
	
function ifBrowser() {
    var ua = navigator.userAgent;
    var bName = function () {
        if (ua.search(/MSIE/) > -1) return "ie";
        if (ua.search(/Firefox/) > -1) return "firefox";
        if (ua.search(/Opera/) > -1) return "opera";
        if (ua.search(/Chrome/) > -1) return "chrome";
        if (ua.search(/Safari/) > -1) return "safari";
        if (ua.search(/Konqueror/) > -1) return "konqueror";
        if (ua.search(/Iceweasel/) > -1) return "iceweasel";
        if (ua.search(/SeaMonkey/) > -1) return "seamonkey";}();
        var version = function (bName) {
        switch (bName) {
            case "ie" : return (ua.split("MSIE ")[1]).split(";")[0];break;
            case "firefox" : return ua.split("Firefox/")[1];break;
            case "opera" : return ua.split("Version/")[1];break;
            case "chrome" : return (ua.split("Chrome/")[1]).split(" ")[0];break;
            case "safari" : return (ua.split("Version/")[1]).split(" ")[0];break;
            case "konqueror" : return (ua.split("KHTML/")[1]).split(" ")[0];break;
            case "iceweasel" : return (ua.split("Iceweasel/")[1]).split(" ")[0];break;
            case "seamonkey" : return ua.split("SeaMonkey/")[1];break;
        }
	}(bName);
	browserName = bName;
    browserVersia = version;
    return [bName, version.split(".")[0], version];
};	

function getUrlPath() {
	var turl = document.location.href;
	var srch = document.location.search;
	var ext1 = document.location.hash;
	var texthref = turl.substr(0, turl.length - srch.length-ext1.length);
	
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
	return outtext;
};