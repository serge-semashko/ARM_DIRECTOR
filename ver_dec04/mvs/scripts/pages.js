var currencyEURO = -1;
var currencyUSA = -1;
var currcurrency = 0;
var purchase = [];

var moneySeparator = function(str) {
    var parts = (str + '').split('.');
    var main = parts[0];
    var len = main.length;
    var output = '';
    var i = len - 1;
    
    while(i >= 0) {
        output = main.charAt(i) + output;
        if ((len - i) % 3 === 0 && i > 0) {
            output = ' ' + output;
        }
        --i;
    };

    if (parts.length > 1) {
        output += '.' + parts[1];
    };
	
    return output;
};

function combobox1Select() {
	//getCurrecy();
   	currcurrency = document.getElementById("combobox1").options.selectedIndex;
	sessionStorage.setItem('currency', +currcurrency);
    if (+currcurrency == 0) {
	    document.getElementById("rate").innerHTML="";
	} else if (+currcurrency == 1) {
		if (language == "RUS") {
	        document.getElementById("rate").innerHTML="Курс: " + currencyEURO + " р.";
		} else {
			document.getElementById("rate").innerHTML="Rate: " + currencyEURO + " р.";
        }			
	} else if (+currcurrency == 2) {
		if (language == "RUS") {
	        document.getElementById("rate").innerHTML="Курс: " + currencyUSA + " р.";
		} else {
			document.getElementById("rate").innerHTML="Rate: " + currencyUSA + " р.";
		}
	}
	
	var table = document.getElementById("tableproducts");
	var pg = document.title;
	if (pg == "MVSGroup Products") { 
	    updateproducts(table);
	} else if (pg == "MVSGroup Services App") {	
	    updateservices(table);
	}  else if (pg == "MVSGroup Services Video") {	
	    updateservices(table);
	};
	var tryvisible = document.getElementById("tryproducts").style.display;
	if (tryvisible = "block") { 
	    createTableTry();
		resizeTryProducts(); 
	};
}	

function setLanguagePage(initplace) {
	
	if (language == "RUS") {
	    document.getElementById("divflagrus").style.opacity= 1;
	    document.getElementById("divflagrus").style.filter="alpha(opacity=100)";
	    document.getElementById("divflaguk").style.opacity= 0.4;
	    document.getElementById("divflaguk").style.filter="alpha(opacity=40)";
	    document.getElementById("divlanguage").innerHTML= "RUS";
	} else {
	    document.getElementById("divflagrus").style.opacity= 0.4;
	    document.getElementById("divflagrus").style.filter="alpha(opacity=40)";
	    document.getElementById("divflaguk").style.opacity= 1;
	    document.getElementById("divflaguk").style.filter="alpha(opacity=100)";
	    document.getElementById("divlanguage").innerHTML= "ENG";
    }
	
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
				strsubmenu = "<ul class='submmenu' id='mm" + j + "'>";
				for (var indx = 0; indx < ListMenus[j].submenu.length; indx++) {
					var idsmm = "mm" + j +"s" + indx;
					var txtloc = window.location.href;
					var cpg = ListMenus[j].submenu[indx].page
					var lenloc = txtloc.length;
					var lencpg = cpg.length;
					var loc = txtloc.substring(lenloc - lencpg);
                    //if (loc.toLowerCase() == cpg.toLowerCase()) {
					//	var clr = "aqua";
					//} else {
					//	var clr = "white";
					//}; //color: " + clr + ";					
					var txtlink = "<a id='" + idsmm + "' style='font-size: " + fs + "px;' href='" + initplace + ListMenus[j].submenu[indx].page + "'>";
					if (language == "RUS") {
						strsubmenu = strsubmenu + "<li>" + txtlink + ListMenus[j].submenu[indx].RUS + "</a></li>";
					} else {
						strsubmenu = strsubmenu + "<li>" + txtlink + ListMenus[j].submenu[indx].UK + "</a></li>";
					};
				};
				strsubmenu = strsubmenu + "</ul>";
			}	
	        if (language == "RUS") {
				var txt = "<a href='" + initplace + ListMenus[j].page + "'> " + ListMenus[j].RUS + "</a>" + strsubmenu;
			    tagList.children[i].innerHTML = txt;
	        } else {
				var txt = "<a href='" + initplace + ListMenus[j].page + "'> " + ListMenus[j].UK + "</a>" + strsubmenu;
			    tagList.children[i].innerHTML = txt;
            }
			j++;
		}
	}
	
	var pg = document.title;
	if (pg !== "MVSGroup Browsers") {
    	var foot1List = document.getElementById("tabfooter1");
		for (var i = 0; i < foot1List.childElementCount; i++){					
            foot1List.children[i].style.color = "white";
		    if (language == "RUS") {
				var txt = "<a href='" + initplace + ListFooter1[i].page + "'> " + ListFooter1[i].RUS + "</a>";
			    foot1List.children[i].innerHTML = txt;
		    } else {
				var txt = "<a href='" + initplace + ListFooter1[i].page + "'> " + ListFooter1[i].UK + " </a>";
			    foot1List.children[i].innerHTML = txt;
            }
		}
		
		var foot2List = document.getElementById("tabfooter2");
		for (var i = 0; i < foot2List.childElementCount; i++){					
            foot2List.children[i].style.color = "white";
		    if (language == "RUS") {
				var txt = "<a href='" + initplace + ListFooter2[i].page + "'> " + ListFooter2[i].RUS + "</a>";
			    foot2List.children[i].innerHTML = txt;
		    } else {
				var txt = "<a href='" + initplace + ListFooter2[i].page + "'> " + ListFooter2[i].UK + " </a>";
			    foot2List.children[i].innerHTML = txt;
            }
		}
		
		var foot3List = document.getElementById("tabfooter3");
		for (var i = 0; i < foot3List.childElementCount; i++){					
            foot3List.children[i].style.color = "white";
		    if (language == "RUS") {
				var txt = "<a href='" + initplace + ListFooter3[i].page + "'> " + ListFooter3[i].RUS + "</a>";
			    foot3List.children[i].innerHTML = txt;
		    } else {
				var txt = "<a href='" + initplace + ListFooter3[i].page + "'> " + ListFooter3[i].UK + " </a>";
			    foot3List.children[i].innerHTML = txt;
            }
		}
		
		var foot4List = document.getElementById("tabfooter4");
		for (var i = 0; i < foot4List.childElementCount; i++){					
            foot4List.children[i].style.color = "white";
		    if (language == "RUS") {
				var txt = "<a href='" + initplace + ListFooter4[i].page + "'> " + ListFooter4[i].RUS + "</a>";
			    foot4List.children[i].innerHTML = txt;
		    } else {
				var txt = "<a href='" + initplace + ListFooter4[i].page + "'> " + ListFooter4[i].UK + " </a>";
			    foot4List.children[i].innerHTML = txt;
            }
		}
	};
	
	if (language == "RUS") {
	    document.getElementById("myfooter").innerHTML  = whosisDisigner[0].RUS;//"&copy; MVSGroup.tv 2018. Разработчик Завьялов П.А."; 		
	} else {
	    document.getElementById("myfooter").innerHTML  = whosisDisigner[0].UK;//"&copy; MVSGroup.tv 2018. Design of P.Zavialov";		
	}
	
	var pg = document.title;
	if (pg == "MVSGroup Contacts") {
		$(function () {  
            $('.mmenu a').each(function () { 
                var location = window.location.href; 
                var link = this.href;  
                if(location == link) { 
                    $(this).addClass('active');
                }
            });
        });
        if (language == "RUS") {
	        document.getElementById("mycontacts").innerHTML  = textContacns[0].RUS;//"&copy; MVSGroup.tv 2018. Разработчик Завьялов П.А."; 		
	    } else {
	        document.getElementById("mycontacts").innerHTML  = textContacns[0].UK;//"&copy; MVSGroup.tv 2018. Design of P.Zavialov";		
	    }  
	} else if (pg == "MVSGroup Supports") {
		$(function () {  
            $('.mmenu a').each(function () { 
                var location = window.location.href; 
                var link = this.href;  
                if(location == link) { 
                    $(this).addClass('active');
                }
            });
        });
		if (language == "RUS") {
	        document.getElementById("txtdownload").innerHTML  = "Скачать данные ";
            document.getElementById("txtdocumentations").innerHTML  = "Документация";	
            document.getElementById("txtlibraries").innerHTML  = "Библиотека"; 		
	    } else {
	        document.getElementById("txtdownload").innerHTML  = "Download ";
            document.getElementById("txtdocumentations").innerHTML  = "Documentation";	
            document.getElementById("txtlibraries").innerHTML  = "Library";		
	    }
    } else if (pg == "MVSGroup Not Page") {
        if (language == "RUS") {
	        document.getElementById("mainrow1").innerHTML  = textNotPage[0].RUS;//"&copy; MVSGroup.tv 2018. Разработчик Завьялов П.А."; 		
	    } else {
	        document.getElementById("mainrow1").innerHTML  = textNotPage[0].UK;//"&copy; MVSGroup.tv 2018. Design of P.Zavialov";		
	    } 
	} else if (pg == "MVSGroup Services") {
		$(function () {  
            $('.mmenu a').each(function () { 
                var location = window.location.href; 
                var link = this.href;  
                if(location == link) { 
                    $(this).addClass('active');
                }
            });
        });
        if (language == "RUS") {
	        document.getElementById("rowservice1").innerHTML  = textServices[0].RUS; 	
            document.getElementById("rowservice2").innerHTML  = textServices[1].RUS;			
	    } else {
	        document.getElementById("rowservice1").innerHTML  = textServices[0].UK;	
            document.getElementById("rowservice2").innerHTML  = textServices[1].UK;			
	    } 
	} else if (pg == "MVSGroup Products") {
		$(function () {  
            $('.mmenu a').each(function () { 
                var location = window.location.href; 
                var link = this.href;  
                if(location == link) { 
                    $(this).addClass('active');
                }
            });
        });
		combobox1Select();
        if (language == "RUS") {
	        document.getElementById("valjuta").innerHTML  = "Валюта:"; 	
            //document.getElementById("rate").innerHTML  = "Курс:";			
	    } else {
	        document.getElementById("valjuta").innerHTML  = "Currency:";	
            //document.getElementById("rate").innerHTML  = "Rate:";			
	    } 
	} else if (pg == "MVSGroup Services App") {
		$(function () {  
            $('.mmenu a').each(function () { 
                var location = window.location.href; 
                var link = this.href;  
				link = link.replace(".html","") + "app.html";
                if(location == link) { 
                    $(this).addClass('active');
                }
            });
        });
		combobox1Select();
        if (language == "RUS") {
	        document.getElementById("valjuta").innerHTML  = "Валюта:"; 	
            //document.getElementById("rate").innerHTML  = "Курс:";			
	    } else {
	        document.getElementById("valjuta").innerHTML  = "Currency:";	
            //document.getElementById("rate").innerHTML  = "Rate:";			
	    } 
	} else if (pg == "MVSGroup Services Video") {
		$(function () {  
            $('.mmenu a').each(function () { 
                var location = window.location.href; 
                var link = this.href;  
				link = link.replace(".html","") + "video.html";
                if(location == link) { 
                    $(this).addClass('active');
                }
            });
        });
		combobox1Select();
        if (language == "RUS") {
	        document.getElementById("valjuta").innerHTML  = "Валюта:"; 	
            //document.getElementById("rate").innerHTML  = "Курс:";			
	    } else {
	        document.getElementById("valjuta").innerHTML  = "Currency:";	
            //document.getElementById("rate").innerHTML  = "Rate:";			
	    } 
	}		
}

function myresizecontacts() {

    var width = 0.6 * window.innerWidth;
    sizeMainMenu(width);
	var fs=(24/ 1000) * width;
	if (fs > 24) { fs = 24; };
	if (fs < 11) { fs = 11; };
	document.getElementById("mainrow1").style.fontSize=fs + "px";
	var hgh0 = document.getElementById("mainmenu").offsetHeight;
    var hgh1 = document.getElementById("mainrow1").offsetHeight;
	var hgh2 = document.getElementById("lastrow").offsetHeight;
	var hgh3 = document.getElementById("myfooter").offsetHeight;
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - hgh3 - 40;	
    if (height < 0) { height=0; };
    document.getElementById("freerow").style.height = height + "px";
	sizeFooter(width);
	setLanguagePage("../");
}

function myresizebrowsers() {
	var mrbr = document.getElementById("mainrowbr");
	
 	mrbr.innerHTML = "Иcпользуемая версия Internet Explorer " + browserVersia + "</br> не поддерживает работу с содержимым сайта.</br>" +
					"<span style='color: aqua'>(The used Internet Explorer version" + browserVersia + "</br>doesn't support work with website contents.)</span></br>" +
					"</br> Обновите Ваш браузер до версии 11,</br>или используйте программное обеспечение</br>другого производителя.</br>" +
					"<span style='color: aqua'>(Update your browser to version 11,</br> or use the software of other producers.)</span>"; 
	var hgh1 = mrbr.offsetHeight;
	var hgh2 = document.getElementById("rowbrowsers").offsetHeight;
	var hgh3 = document.getElementById("brmyfooter").offsetHeight;
	//var hgh4 = document.getElementById("brcount").offsetHeight;
	
	var thgh = document.body.parentNode.clientHeight;
    var height =  thgh - hgh1 - hgh2 - hgh3 - 20;
    if (height < 0) { height=0; };
	height = height / 3;
	var brcn = document.getElementById("brcount");
	brcn.style.height = height + "px";
    var brfr = document.getElementById("brfreerow");
	brfr.style.height = 2 * height + "px";
};

function myresizesupports() {

    var width = 0.6 * window.innerWidth;
    sizeMainMenu(width);
	
	var fs=(20 / 1000) * width;
	if (fs > 20) { fs = 20; };
	if (fs < 8) { fs = 8; };
	document.getElementById("txtdownload").style.fontSize = fs + "px";
	document.getElementById("txtdocumentations").style.fontSize = fs + "px";
	document.getElementById("txtlibraries").style.fontSize = fs + "px";
	
    var hgh0 = document.getElementById("mainmenu").offsetHeight;
    var hgh1 = document.getElementById("rowsupports").offsetHeight;
	var hgh2 = document.getElementById("lastrow").offsetHeight;
	var hgh3 = document.getElementById("myfooter").offsetHeight;
	var hgh4 = document.getElementById("countcols").offsetHeight;
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - hgh3 - hgh4 - 30;	
    if (height < 0) { height=0; };
    document.getElementById("freerow").style.height = height + "px";
	sizeFooter(width);
	setLanguagePage("../");
}

function myresizeservices() {

    var width = 0.6 * window.innerWidth;
	sizeMainMenu(width);
	
	document.getElementById("mainrow1").style.height = 0.25 * window.innerWidth + "px";
	
	var fs=(28/ 1000) * width;
	if (fs > 28) { fs = 28; };
	if (fs < 11) { fs = 11; };
	
	document.getElementById("rowselectservices").style.height = 0.12 * window.innerWidth + "px";
	
	sizeFooter(width);
	
	document.getElementById("rowservice1").style.fontSize=fs + "px";
	document.getElementById("rowservice2").style.fontSize=fs + "px";
	var hgh0 = document.getElementById("mainmenu").offsetHeight;
    var hgh1 = document.getElementById("mainrow1").offsetHeight;
	var hgh2 = document.getElementById("countcols").offsetHeight;
	var hgh3 = document.getElementById("lastrow").offsetHeight;
	var hgh4 = document.getElementById("rowselectservices").offsetHeight;
	var hgh5 = document.getElementById("myfooter").offsetHeight;
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - hgh3 - hgh4 - hgh5 - 30;	
    if (height < 0) { height=0; };
    document.getElementById("freerow").style.height = height + "px";
	
	setLanguagePage("../");
}

function UrlExists(url) {
    var http = new XMLHttpRequest();
    http.open('HEAD', url, false);
    http.send();
    return http.status!=404;
}	

function setListDownloads(inStr, ListElement) {
	var width = 0.6 * window.innerWidth;
	var hgh=(14/ 1000) * width;
	if (hgh > 14) { hgh = 14; };
	if (hgh < 8) { hgh = 8; };
	var wdt = 0.9 * hgh;
	wdt = wdt.toFixed(1);
	
	var textdocs = inStr;
	if (language == "RUS") { 
	    var stext = ListElement.textRUS;
	} else {
		var stext = ListElement.textUK;
	};
	var turl = "../" + ListElement.file;
	
	var fileexists = true;
	if (ListElement.file !== "") {
		//var thisFolder = document.URL.replace(/(\\|\/)[^\\\/]*$/, '/');
		//thisFolder = thisFolder.substring(0,thisFolder.length - 6);
		//var myurl = encodeURIComponent(ListElement.file);
		myurl = "../" + ListElement.file;
		
	    //$.ajax({
        //    url:"../download/1.txt",
		//	dataType:"text",
		//	cache: false,
        //    success:function(){ fileexists = true; },
        //    error:function(){ fileexists = false;  },	
	    //});
	};

	var rgs = isRegistration();
    	
    if (rgs !== "") {
        if (ListElement.payment) {
			stext = stext + "<span style='align-items: center;'> <img src='../images/payment.png' style='width: " + wdt + "px; height: " + hgh + "px; margin-left: 5px'/></span>";
	        textdocs = textdocs + "</br><span class='prodlink' onClick='showModalWin(0)'>" + stext + "</span>";
		} else {
			if (turl !== "") {
                textdocs = textdocs + "</br><span><a class='prodlink' href='../" + turl + "' download=''>" + stext + "</a></span>";
            } else {
                textdocs = textdocs + "</br><span class='prodlink' onClick='showModalWin(1)'>" + stext + "</span>";
            };
		};		
	} else {
		if (ListElement.onlyuser) {
		    stext = stext + "<span style='align-items: center;'> <img src='../images/users.png' style='width: " + wdt + "px; height: " + hgh + "px; margin-left: 5px'/></span>";
	        textdocs = textdocs + "</br><span class='prodlink' onClick='showModalWin(2)'>" + stext + "</span>";
		} else {					
	        if (ListElement.payment) {
				stext = stext + "<span style='align-items: center;'> <img src='../images/payment.png' style='width: " + wdt + "px; height: " + hgh + "px; margin-left: 5px'/></span>";
	            textdocs = textdocs + "</br><span class='prodlink' onClick='showModalWin(0)'>" + stext + "</span>";
			} else {
				if (turl !== "") {
                    textdocs = textdocs + "</br><span><a class='prodlink' href='../" + turl + "' download=''>" + stext + "</a></span>";
                } else {
                    textdocs = textdocs + "</br><span class='prodlink' onClick='showModalWin(1)'>" + stext + "</span>";
                };
			};
		};
	};
		
	return textdocs;
};

function setProductsPrice(Table, Row, Col) {
	
	var currprice = ListProducts[Row-1].price;
	if (currprice !== "-1" && currprice !== "-2") {
		if (currcurrency == 0) {
			currprice = moneySeparator(currprice) + " р.";
		} if (currcurrency == 1) {
			currprice = currprice / currencyEURO;
			currprice = moneySeparator(currprice.toFixed(2));
			currprice = "€" + currprice;
		} if (currcurrency == 2) {
			currprice = currprice / currencyUSA;
			currprice = moneySeparator(currprice.toFixed(2));
			currprice = "$" + currprice;
		}
	if (language == "RUS") {
			currprice = "Цена: " + currprice;
		} else {
			currprice = "Price: " + currprice;
		};
	} else if (currprice == "-1") {
		if (language == "RUS") {
			currprice = "Показать данные";
		} else {
			currprice = "To show data";
		};
	} else {
		if (language == "RUS") {
			currprice = "Свяжитесь с поставщиком";
		} else {
			currprice = "Сontact the supplier";
		};
	};
	
	var textdocs = "";
	for (var k=0; k<ListProducts[Row-1].files.length; k++) {
		if (ListProducts[Row-1].files[k].file !== "") { 
	        textdocs = setListDownloads(textdocs, ListProducts[Row-1].files[k]);
        };		
        //var turl =ListProducts[Row-1].files[k].file;     
        //var uni = encodeURIComponent(turl);
		//var ii = "";
    };
	var tact = "";
	if (language == "RUS") {
		if (ListProducts[Row-1].typeaction == "Купить") {
			tact = "Купить:";
		} else if (ListProducts[Row-1].typeaction == "Аренда") {
			tact = "Аренда:";
		} else {
           	tact = "Информация:";		
		};
		Table.rows[Row].cells[Col].innerHTML = "<span style='font-weight: bolder'>" + tact + "</br></br>" +
	        "<span class='prodprice' onClick='getPriceProduct(" + Row +")'> " + currprice + "</span>" +
			"</br></br>Скачать:</span>" + textdocs;
	} else {
		if (ListProducts[Row-1].typeaction == "Купить") {
			tact = "Buy:";
		} else if (ListProducts[Row-1].typeaction == "Аренда") {	
			tact = "Hire:";
		} else {
			tact = "Information:";
		};
		Table.rows[Row].cells[Col].innerHTML = "<span style='font-weight: bolder'>" + tact + "</br></br>" +
	        "<span class='prodprice'  onClick='getPriceProduct(" + Row +")'> " + currprice + "</span></br></br>Download:</span>" + textdocs;
	}
}

function updateproducts(Table) {
	var width = 0.6 * window.innerWidth;
	var fs=(14/ 1000) * width;
	if (fs > 14) { fs = 14; };
	if (fs < 7) { fs = 7; };
	
	var rowcount = Table.rows.length;
    for (var i=1; i<rowcount-2; i++) {
		var colcount = Table.rows[i].cells.length;
		Table.rows[i].style.height = 0.25 * width + "px";
		if (+colcount > 5) {

			//var txt = "<a href='../" + ListProducts[i-1].page + "'><div><img class='imageprod' src='../" + ListProducts[i-1].image + "'  width='100%' height='100%'></div></a>";
			height=0.25 * width + "px";
			var crow = i-1;
			Table.rows[i].cells[2].innerHTML = "<a href='../" + ListProducts[i-1].page + "'><div onMouseOver='prodMouseOver(" + crow + ")' onMouseOut='prodMouseOut(" 
			    + crow+")''><img id='imageprod" + crow + "' src='../" + ListProducts[i-1].image + "'  width='100%' height='" + height + "'></div></a>";
			
			var sht = "шт.";
			if (language == "RUS") {
			    Table.rows[i].cells[3].innerHTML = "<a class='prodtext' href='../" + ListProducts[i-1].page + "'><span style='font-weight: bolder'>" 
				    + ListProducts[i-1].textRUS + "</span></br><p>" + ListProducts[i-1].descriptionRUS + "</p></a>";
			} else {
			    Table.rows[i].cells[3].innerHTML = "<a class='prodtext' href='../" + ListProducts[i-1].page + "'><span style='font-weight: bolder'>" 
				+ ListProducts[i-1].textUK + "</span></br><p>" + ListProducts[i-1].descriptionUK + "</p></a>";
				sht = "pcs.";
			}	
			setProductsPrice(Table,i,4);
			
			var fs1=(12/ 1000) * width;
	        if (fs1 > 12) { fs1 = 12; };
	        if (fs1 < 7) { fs1 = 7; };
			var wh = +fs1 + 8;
			var ml = +fs1 - 2;
			var wdth = 50 - 2 * fs1;
			
			fs1 = +fs1 + 1;
			
			if (ListProducts[i-1].price > 0) { 
			    Table.rows[i].cells[5].innerHTML = "<div id='cellamount" + crow + "' style='display: block'><span style='text-align: left; color: white;'>" +
			                                   "<input id='spinedit" + crow +"' class='spinedit' type='number' value='1' min='1' style='width: " + wdth + "%; font-size:" + fs1 + "px'/>" + 
											   sht + "</span>"  + "<img src='../images/tryprod.png' style='width: " + wh + "px; height: " + wh + "px; margin-left: " + ml + "px; padding-top: 5px;'" +
                                               "onClick='productSelect(" + crow + ")'/></div>";
			} else {
				//Table.rows[i].cells[5].id = 'amountproduct';
				Table.rows[i].cells[5].innerHTML = "<div id='cellamount" + crow + "' style='display: none'><span style='text-align: left'>" +
			                                   "<input id='spinedit" + crow +"' class='spinedit' type='number' value='1' min='1' style='width: " + wdth + "%; font-size:" + fs1 + "px'/>" + 
											   sht + "</span>"  + "<img src='../images/tryprod.png' style='width: " + wh + "px; height: " + wh + "px; margin-left: " + ml + "px; padding-top: 5px'" +
                                               "onClick='productSelect(" + crow + ")'/></div>";
			}	
		};
		Table.rows[i].style.fontSize = fs + "px";
    };
};	

function myresizeproducts() {

    var width = 0.6 * window.innerWidth;
	sizeMainMenu(width);
	
	var fs1=(12/ 1000) * width;
	if (fs1 > 12) { fs1 = 12; };
	if (fs1 < 7) { fs1 = 7; };
	
	var sel = document.getElementById("combobox1");
	sel.options.selectedIndex = currcurrency;
	
	var table = document.getElementById("tableproducts");
	
	table.rows[0].style.fontSize = fs1 + "px";
	document.getElementById("combobox1").style.fontSize = fs1 + "px";
		
	updateproducts(table);
	
    table.style.borderSpacing="10px";
	
    sizeFooter(width);	
	
	var hghm = document.getElementById("mainmenu").style.height;
	var hgh0 = hghm.replace("px","");
	var hgh2 = document.getElementById("myfooter").offsetHeight;
	var hgh3 = document.getElementById("countcols").offsetHeight;
	var hgh4 = document.getElementById("lastrow").offsetHeight;
	
	var hgh1 = 0;//document.getElementById("lastrow").offsetHeight;
	for (var i=1; i<table.rows.length-2; i++) {
	    //var hhh = table.rows[i]offsetHeight;//.style.height;
        //hhh = hhh.replace("px","");		
    	hgh1=+hgh1 + table.rows[i].offsetHeight + 10; 
	};
	
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - hgh3 - hgh4 - 70;	
    if (height < 0) { height=0; };
    //table.rows[table.rows.length-2].offsetHeight = height;
	document.getElementById("freerow").style.height = height + "px";
	
	var trydisplay = document.getElementById("tryproducts").style.display;
	if (trydisplay == "block") { 
	    createTableTry();
	    resizeTryProducts(); 
	};

	setLanguagePage("../");
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function setServicesPrice(List, Table, Row, Col) {
	
	var currprice = List[Row-1].price;
	if (currprice !== "-1" && currprice !== "-2") {
		if (currcurrency == 0) {
			currprice = moneySeparator(currprice) + " р.";
		} if (currcurrency == 1) {
			currprice = currprice / currencyEURO;
			currprice = moneySeparator(currprice.toFixed(2));
			currprice = "€" + currprice;
		} if (currcurrency == 2) {
			currprice = currprice / currencyUSA;
			currprice = moneySeparator(currprice.toFixed(2));
			currprice = "$" + currprice;
		}
		if (language == "RUS") {
			currprice = "Цена: " + currprice;
		} else {
			currprice = "Price: " + currprice;
		};
	} else if (currprice == "-1") {
		if (language == "RUS") {
			currprice = "Показать данные";
		} else {
			currprice = "To show data";
		};
	} else {
		if (language == "RUS") {
			currprice = "Свяжитесь с поставщиком";
		} else {
			currprice = "Сontact the supplier";
		};
	};
	
	var textdocs = "";
	for (var k=0; k<List[Row-1].files.length; k++) {
		if (List[Row-1].files[k].file !== "") {
	        textdocs = setListDownloads(textdocs, List[Row-1].files[k]);
        }		
    };
	var tact = "";
	if (language == "RUS") {
	    if (List[Row-1].typeaction == "Купить") {
			tact = "Купить:";
		} else if (List[Row-1].typeaction == "Аренда") {
			tact = "Аренда:";
		} else {
           	tact = "Информация:";		
		};
		Table.rows[Row].cells[Col].innerHTML = "<span style='font-weight: bolder; color: white'>" + tact + "</br></br>" +
	        "<span class='prodprice' onClick='getPriceProduct(" + Row +")'> " + currprice + "</span></br></br>Скачать:</span>" +
			"<input='number' value='1' min='1' class='prod_count'>" + textdocs;
	} else {
	    if (List[Row-1].typeaction == "Купить") {
			tact = "Buy:";
		} else if (List[Row-1].typeaction == "Аренда") {	
			tact = "Hire:";
		} else {
			tact = "Information:";
		};
		Table.rows[Row].cells[Col].innerHTML = "<span style='font-weight: bolder; color: white'>" + tact + "</br></br>" +
	        "<span class='prodprice'  onClick='getPriceProduct(" + Row +")'> " + currprice + "</span></br></br>Download:</span>" + textdocs;
	}
}

function updateservices(Table) {
	var List;
	var pg = document.title;
	//if (pg == "MVSGroup Products") { 
	//   List = ListProducts;
	//} else 
	if (pg == "MVSGroup Services App") {	
	     List = ListServices1;
	}  else if (pg == "MVSGroup Services Video") {	
	     List = ListServices2;
	};
	var width = 0.6 * window.innerWidth;
	var fs=(14/ 1000) * width;
	if (fs > 14) { fs = 14; };
	if (fs < 7) { fs = 7; };
	
	var rowcount = Table.rows.length;
    for (var i=1; i<rowcount-2; i++) {
		var colcount = Table.rows[i].cells.length;
		Table.rows[i].style.height = 0.25 * width + "px";
		if (+colcount > 4) {

		height=0.25 * width + "px";
			var crow = i-1;
			Table.rows[i].cells[2].innerHTML = "<a href='../" + List[i-1].page + "'><div onMouseOver='prodMouseOver(" + crow + ")' onMouseOut='prodMouseOut(" 
			    + crow+")''><img id='imageprod" + crow + "' src='../" + List[i-1].image + "'  width='100%' height='" + height + "'></div></a>";
			
			var sht = "шт.";
			if (language == "RUS") {
			    Table.rows[i].cells[3].innerHTML = "<a class='prodtext' href='../" + List[i-1].page + "'><span style='font-weight: bolder'>" 
				    + List[i-1].textRUS + "</span></br><p>" + List[i-1].descriptionRUS + "</p></a>";
			} else {
			    Table.rows[i].cells[3].innerHTML = "<a class='prodtext' href='../" + List[i-1].page + "'><span style='font-weight: bolder'>" 
				+ List[i-1].textUK + "</span></br><p>" + List[i-1].descriptionUK + "</p></a>";
				sht = "pcs.";
			}	
			
			setServicesPrice(List,Table,i,4);
			
			var fs1=(12/ 1000) * width;
	        if (fs1 > 12) { fs1 = 12; };
	        if (fs1 < 7) { fs1 = 7; };
			var wh = +fs1 + 8;
			var ml = +fs1 - 2;
			var wdth = 50 - 2 * fs1;
			
			fs1 = +fs1 + 1;
			
			if (List[i-1].price > 0) { 
			    Table.rows[i].cells[5].innerHTML = "<div id='cellamount" + crow + "' style='display: block'><span style='text-align: left'>" +
			                                   "<input id='spinedit" + crow +"' class='spinedit' type='number' value='1' min='1' style='width: " + wdth 
											   + "%; font-size:" + fs1 + "px'/>" + sht + "</span>"  + "<img src='../images/tryprod.png' style='width: " + wh 
											   + "px; height: " + wh + "px; margin-left: " + ml + "px; padding-top: 5px;'" +
                                               "onClick='productSelect(" + crow + ")'/></div>";
			} else {
				//Table.rows[i].cells[5].id = 'amountproduct';
				Table.rows[i].cells[5].innerHTML = "<div id='cellamount" + crow + "' style='display: none'><span style='text-align: left'>" +
			                                   "<input id='spinedit" + crow +"' class='spinedit' type='number' value='1' min='1' style='width: " + wdth 
											   + "%; font-size:" + fs1 + "px'/>" + sht + "</span>"  + "<img src='../images/tryprod.png' style='width: " + wh 
											   + "px; height: " + wh + "px; margin-left: " + ml + "px; padding-top: 5px'" +
                                               "onClick='productSelect(" + crow + ")'/></div>";
			};
			Table.rows[i].cells[5].style.color = "white";
		};
		
		Table.rows[i].style.fontSize = fs + "px";
    };
};	

function myresizesubservices() {

    var width = 0.6 * window.innerWidth;
	sizeMainMenu(width);
	
	var fs1=(12/ 1000) * width;
	if (fs1 > 12) { fs1 = 12; };
	if (fs1 < 7) { fs1 = 7; };
	
	var sel = document.getElementById("combobox1");
	sel.options.selectedIndex = currcurrency;
	
	var table = document.getElementById("tableproducts");
	
	table.rows[0].style.fontSize = fs1 + "px";
	sel.style.fontSize = fs1 + "px";
	//document.getElementById("combobox1").width = "55%";	
	updateservices(table);
	
    table.style.borderSpacing="10px";
   
    sizeFooter(width);	
	
	var hgh0 = document.getElementById("mainmenu").offsetHeight;
	var hgh2 = document.getElementById("myfooter").offsetHeight;
	var hgh3 = document.getElementById("countcols").offsetHeight;
	var hgh4 = document.getElementById("lastrow").offsetHeight;
	
	var hgh1 = 0;
	for (var i=1; i<table.rows.length-2; i++) {
	    hgh1=+hgh1 + table.rows[i].offsetHeight + 10; 
	};
	
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - hgh3 - hgh4 - 70;	
    if (height < 0) { height=0; };
   	document.getElementById("freerow").style.height = height + "px";
	
	var trydisplay = document.getElementById("tryproducts").style.display;
	if (trydisplay == "block") { 
	    createTableTry();
	    resizeTryProducts(); 
	};
	
	setLanguagePage("../");
}

function resizeTryProducts() {
	var width = 0.6 * window.innerWidth;
	var fs=(12/ 800) * width;
	if (fs > 12) { fs = 12; };
	if (fs < 8) { fs = 8; };
	document.getElementById("tabtrytitletext").style.fontSize = fs + "px";
	document.getElementById("btntrypay").style.fontSize = fs + "px";
	document.getElementById("btntryclear").style.fontSize = fs + "px";
	document.getElementById("r1trytotal").style.fontSize = (fs + 1) + "px";
	document.getElementById("r2trytotal").style.fontSize = fs + "px";
	document.getElementById("idtrybodyhead").style.fontSize = fs + "px";
	document.getElementById("idtrybodybody").style.fontSize = fs + "px";
	var trybody=document.getElementById("idtrybodybody");
	if (trybody.rows.length > 0) {
		for (var i=0; i < purchase.length; i++) { 
		    var iddel = "iddelproduct" + i; 
		    document.getElementById(iddel).style.fontSize = fs + "px";
		};
	}
	var vtext = "";
	var rate = "";
	var pamount = 0;
	var summa = 0;
	for (var i=0; i < purchase.length; i++) {
		pamount = +pamount + +purchase[i].amount;
		summa = +summa + purchase[i].amount * purchase[i].price;
	};	
	var nds = summa / 6;
	if (+currcurrency == 0) {
		if (language == "RUS") {
			vtext = "Валюта: p. (Россия)</br>Количество: " + pamount;
		} else {
		    vtext = "Currency: p. (Россия)</br>Amount: " + pamount;
	    };	
	} else if (+currcurrency == 1) {
		if (currencyEURO > 0) {
			if (language == "RUS") {
	            vtext = "Валюта: € (EURO);</br>Курс: " + currencyEURO + " р.</br>Количество: " + pamount;
			} else {
				vtext = "Currency: € (EURO);</br>Rate: " + currencyEURO + " р.</br>Amount: " + pamount;
            };
		} else {
 		    if (language == "RUS") {
		    	vtext = "Валюта: p. (Россия)</br>Количество: " + pamount;
		    } else {
		        vtext = "Currency: p. (Россия)</br>Amount: " + pamount;
	        };
		};	
	} else if (+currcurrency == 2) {
		if (currencyUSA > 0) {
			if (language == "RUS") {
	            vtext = "Валюта: $ (USA);</br>Курс: " + currencyUSA + " р.</br>Количество: " + pamount;
			} else {
				vtext = "Currency: $ (USA);</br>Rate: " + currencyUSA + " р.</br>Amount: " + pamount;
			};
		} else {
 		    if (language == "RUS") {
		    	vtext = "Валюта: p. (Россия)</br>Количество: " + pamount;
		    } else {
		        vtext = "Currency: p. (Россия)</br>Amount: " + pamount;
	        };
		};	
	};
	
	document.getElementById("tabtrytitletext").innerHTML = vtext;
	
	var tsumma = "";
	var tnds = "";
	
	if (currcurrency == 0) {
		tsumma = moneySeparator(summa.toFixed(2)) + " р.";
		tnds = moneySeparator(nds.toFixed(2)) + " р.";
	} else if (currcurrency == 1) {
		if (currencyEURO > 0) {
			summa = summa / currencyEURO;
			tsumma = moneySeparator(summa.toFixed(2));
			tsumma = "€ " + tsumma;
			nds = nds / currencyEURO;
			nds = Math.round(nds * 100) / 100;
			tnds = moneySeparator(nds);
			tnds = "€ " + tnds;
		} else {
			tsumma = moneySeparator(summa.toFixed(2)) + " р.";
		    tnds = moneySeparator(nds.toFixed(2)) + " р.";
		};	
	} else if (currcurrency == 2) {
		if (currencyUSA > 0) {
			summa = summa / currencyUSA;
			tsumma = moneySeparator(summa.toFixed(2));
			tsumma = "$ " + tsumma;
			nds = nds / currencyUSA;
			nds = Math.round(nds * 100) / 100; 
			tnds = moneySeparator(nds);
			tnds = "$ " + tnds;
		} else {
			tsumma = moneySeparator(summa.toFixed(2)) + " р.";
		    tnds = moneySeparator(nds.toFixed(2)) + " р.";
		};
	};
			
	document.getElementById("trytotalsum").innerHTML = tsumma;
	document.getElementById("trytotalnds").innerHTML = tnds;
	
	if (language == "RUS") {
		document.getElementById("trytotalsumtxt").innerHTML = "Итого:";
	    document.getElementById("trytotalndstxt").innerHTML = "в т.ч. НДС";
	} else {
		document.getElementById("trytotalsumtxt").innerHTML = "Total:";
	    document.getElementById("trytotalndstxt").innerHTML = "including VAT";
	};
	
	if (language == "RUS") {
		document.getElementById("btntrypay").value = "Оплатить";
	    document.getElementById("btntryclear").value = "Очистить";
	} else {
		document.getElementById("btntrypay").value = "Pay";
	    document.getElementById("btntryclear").value = "Clear";
	};
}; 


function productSelect(ARow) {
	
	var pg = document.title;
	if (pg == "MVSGroup Products") { 
	    var List = ListProducts;
	} else if (pg == "MVSGroup Services App") {	
	    var List = ListServices1;
	} else if (pg == "MVSGroup Services Video") {	
	    var List = ListServices2;
	};
		
	purchase.length = purchase.length + 1;
	var objproduct = new Object();
	
	objproduct.nameRUS = List[ARow].textRUS;
	objproduct.nameUK = List[ARow].textUK;
	objproduct.price = List[ARow].price;
	objproduct.id = List[ARow].id;
		
	var id = "spinedit" + ARow;
	var se = document.getElementById(id);
	objproduct.amount = document.getElementById(id).value;
	
	purchase[purchase.length - 1] = objproduct;
	
	createTableTry();

	resizeTryProducts();
	
	var strJSON = JSON.stringify(purchase);
	sessionStorage.setItem('purchaseJSON', strJSON);
};

function deleteOneProduct(ARow) {
	purchase.splice(ARow,1);
	createTableTry();
	resizeTryProducts();
	
	var strJSON = JSON.stringify(purchase);
	sessionStorage.setItem('purchaseJSON', strJSON);
};

function clearTryProduct() {
	purchase.length = 0; 
    var strJSON = JSON.stringify(purchase);
	sessionStorage.setItem('purchaseJSON', strJSON);	
};	

function onPagePayment() {
	window.location.href = "../pages/payment.html";
};

function isRegistration() {
	var reg = sessionStorage.getItem('isregistration');
	if (reg == null) {
	    //clearRegistration;
		return "";
	} else {
	    if (reg == "Yes") {
	        userregistrated = true;
			var stat = sessionStorage.userstatus;
			if (stat == null) { return ""; };
			return stat;
	    } else {
		    userregistrated = false;
			return "";
		};
	}; 
	return "";
};

function showListServices(nom) {
	if (+nom == 1) {
		window.location.href = "../pages/servicesapp.html";
	} else {
		window.location.href = "../pages/servicesvideo.html";
	};
};
