function setLanguagePage(initplace) {
	if (language == "RUS") {
	    document.getElementById("divflagrus").style.opacity= 1;
	    document.getElementById("divflagrus").style.filter="alpha(opacity=100)";
	    document.getElementById("divflaguk").style.opacity= 0.6;
	    document.getElementById("divflaguk").style.filter="alpha(opacity=60)";
	    document.getElementById("divlanguage").innerHTML= "RUS";
	} else {
	    document.getElementById("divflagrus").style.opacity= 0.6;
	    document.getElementById("divflagrus").style.filter="alpha(opacity=60)";
	    document.getElementById("divflaguk").style.opacity= 1;
	    document.getElementById("divflaguk").style.filter="alpha(opacity=100)";
	    document.getElementById("divlanguage").innerHTML= "ENG";
    }
	
	var tagList = document.getElementById("navigation");
	for (var i = 0; i < tagList.childElementCount; i++){					
        
	    if (language == "RUS") {
			var txt = "<a href='" + initplace + ListMenus[i].page + "'> " + ListMenus[i].RUS + "</a>";
		    tagList.children[i].innerHTML = txt;
	    } else {
			var txt = "<a href='" + initplace + ListMenus[i].page + "'> " + ListMenus[i].UK + " </a>";
		    tagList.children[i].innerHTML = txt;
        }
	}	
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
	if (language == "RUS") {
	    document.getElementById("myfooter").innerHTML  = whosisDisigner[0].RUS;//"&copy; MVSGroup.tv 2018. Разработчик Завьялов П.А."; 		
	} else {
	    document.getElementById("myfooter").innerHTML  = whosisDisigner[0].UK;//"&copy; MVSGroup.tv 2018. Design of P.Zavialov";		
	}
	
	var pg = document.title;
	if (pg == "MVSGroup Contacts") {
        if (language == "RUS") {
	        document.getElementById("mycontacts").innerHTML  = textContacns[0].RUS;//"&copy; MVSGroup.tv 2018. Разработчик Завьялов П.А."; 		
	    } else {
	        document.getElementById("mycontacts").innerHTML  = textContacns[0].UK;//"&copy; MVSGroup.tv 2018. Design of P.Zavialov";		
	    }  
	} else if (pg == "MVSGroup Supports") {
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
        if (language == "RUS") {
	        document.getElementById("rowservice1").innerHTML  = textServices[0].RUS; 	
            document.getElementById("rowservice2").innerHTML  = textServices[1].RUS;			
	    } else {
	        document.getElementById("rowservice1").innerHTML  = textServices[0].UK;	
            document.getElementById("rowservice2").innerHTML  = textServices[1].UK;			
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
	var hghm = document.getElementById("mainmenu").style.height;
	var hgh0 = hghm.replace("px","");
    var hgh1 = document.getElementById("mainrow1").offsetHeight;
	var hgh2 = document.getElementById("lastrow").offsetHeight;
	var hghf = document.getElementById("myfooter").style.height;
	var hgh3 = hghf.replace("px","");
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - hgh3 - 70;	
    if (height < 0) { height=0; };
    document.getElementById("freerow").style.height = height + "px";
	sizeFooter(width);
	setLanguagePage("../");
}

function myresizesupports() {

    var width = 0.6 * window.innerWidth;
    sizeMainMenu(width);
	
	var fs=(20 / 1000) * width;
	if (fs > 20) { fs = 20; };
	if (fs < 8) { fs = 8; };
	document.getElementById("txtdownload").style.fontSize = fs + "px";
	document.getElementById("txtdocumentations").style.fontSize = fs + "px";
	document.getElementById("txtlibraries").style.fontSize = fs + "px";
	
    var hghm = document.getElementById("mainmenu").style.height;
	var hgh0 = hghm.replace("px","");
    var hgh1 = document.getElementById("rowsupports").offsetHeight;
	var hgh2 = document.getElementById("lastrow").offsetHeight;
	var hghf = document.getElementById("myfooter").style.height;
	var hgh3 = hghf.replace("px","");
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - hgh3;// - 160;	
    if (height < 0) { height=0; };
	document.getElementById("countcols").style.height = (height/2 - 60) + "px";
    document.getElementById("freerow").style.height = height/2 + "px";
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
	document.getElementById("rowservice1").style.fontSize=fs + "px";
	document.getElementById("rowservice2").style.fontSize=fs + "px";
	var hghm = document.getElementById("mainmenu").style.height;
	var hgh0 = hghm.replace("px","");
    var hgh1 = document.getElementById("mainrow1").offsetHeight;
	var hgh2 = document.getElementById("lastrow").offsetHeight;
	var hgh3 = document.getElementById("rowservice1").offsetHeight;
	var hghf = document.getElementById("myfooter").style.height;
	var hgh4 = hghf.replace("px","");
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - hgh3 - hgh4 - 110;	
    if (height < 0) { height=0; };
    document.getElementById("freerow").style.height = height + "px";
	sizeFooter(width);
	setLanguagePage("../");
}

function myresizeproducts() {

    var width = 0.6 * window.innerWidth;
	sizeMainMenu(width);
	
	//document.getElementById("mainrow1").style.height = 0.25 * window.innerWidth + "px";
	
	var fs=(22/ 1000) * width;
	if (fs > 22) { fs = 22; };
	if (fs < 8) { fs = 8; };
	
	var table = document.getElementById("tableproducts");
	var rowcount = table.rows.length;
	for (var i=1; i<rowcount-2; i++) {
		var colcount = table.rows[i].cells.length;
		table.rows[i].height = 0.25 * width + "px";
		table.rows[i].style.height = 0.25 * width + "px";
		table.rows[i].offsetHeight = 0.26 * width + "px";
		//table.rows[i].clientHeight = 0.25 * width + "px";
		for (var j=0; j<length; j++) {
		    table.rows[i].cells[j].style.height=0.25 * width + "px"; 
			table.rows[i].cells[j].height=0.25 * width + "px"; 
			table.rows[i].cells[j].offsetHeight=0.25 * width + "px";
			table.rows[i].children[j].height=0.25 * width + "px";
			//table.rows[i].cells[j].outerHeight=0.26 * width + "px";
			//table.rows[i].cells[j].style.fontSize = fs + "px";
		}
		if (+colcount > 4) {
			table.rows[i].cells[4].innerHTML = "width =" + width + " rowheight =" + table.rows[i].height;
			//table.rows[i].cells[2].style.backgroundSize="100% "+ 0.25 * width + "px";
			if (language == "RUS") {
			    table.rows[i].cells[3].innerHTML = ListProducts[i-1].textRUS;
			} else {
			    table.rows[i].cells[3].innerHTML = ListProducts[i-1].textUK;
			}			
		};
		table.rows[i].style.fontSize = fs + "px";
    }		
	//document.getElementById("rowservice1").style.fontSize=fs + "px";
	//document.getElementById("rowservice2").style.fontSize=fs + "px";
	var hghm = document.getElementById("mainmenu").style.height;
	var hgh0 = hghm.replace("px","");
    //var hgh1 = document.getElementById("mainrow1").offsetHeight;
	var hgh1 = document.getElementById("lastrow").offsetHeight;
	//var hgh3 = document.getElementById("rowservice1").offsetHeight;
	var hghf = document.getElementById("myfooter").style.height;
	var hgh2 = hghf.replace("px","");
    var height =  window.innerHeight - hgh0 - hgh1 - hgh2 - rowcount * 0.25 * width - 110;	
    if (height < 0) { height=0; };
    document.getElementById("freerow").style.height = height + "px";
	sizeFooter(width);
	setLanguagePage("../");
}


