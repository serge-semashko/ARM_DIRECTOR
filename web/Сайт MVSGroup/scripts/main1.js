var MinSize = 850;
var language = "RUS";
var TypeBrowser = "";
var indexMainImage = 1; 

function setFont(element,New)
{
    step = parseInt(step,10);
    var el = document.getElementById(element);
    var curFont = parseInt(el.style.fontSize,10);
    el.style.fontSize = (curFont+step) + 'px';
}

function initProducts() {
	var nom = 0;
	for (var i=ProductIndex; i < ProductIndex + 4; i++) {
        nom++;		  
	    document.getElementById("prod"+nom).style.backgroundImage=ListProducts[i].image;
		document.getElementById("prod"+nom).style.backgroundRepeat="no-repeat";
		document.getElementById("prod"+nom+"txt").style.color = ListProducts[i].textcolor;
		document.getElementById("prod"+nom+"herf").href = ListProducts[i].page;
		if (language == "RUS") {
		   document.getElementById("prod"+nom+"txt").innerHTML = ListProducts[i].textRUS;
		} else {
           document.getElementById("prod"+nom+"txt").innerHTML = ListProducts[i].textUK;
        }		
	}
}	

function initServices1() {
	var nom = 0;
	for (var i=ServicesIndex1; i < ServicesIndex1 + 4; i++) {
        nom++;		  
	    document.getElementById("serv1_"+nom).style.backgroundImage=ListServices1[i].image;
		document.getElementById("serv1_"+nom).style.backgroundRepeat="no-repeat";
		document.getElementById("serv1_"+nom+"txt").style.color = ListServices1[i].textcolor;
		document.getElementById("serv1_"+nom+"herf").href = ListServices1[i].page;
		if (language == "RUS") {
		   document.getElementById("serv1_"+nom+"txt").innerHTML = ListServices1[i].textRUS;
		} else {
           document.getElementById("serv1_"+nom+"txt").innerHTML = ListServices1[i].textUK;
        }
	}
}

function initServices2() {
	var nom = 0;
	for (var i=ServicesIndex2; i < ServicesIndex2 + 4; i++) {
        nom++;		  
	    document.getElementById("serv2_"+nom).style.backgroundImage=ListServices2[i].image;
		document.getElementById("serv2_"+nom).style.backgroundRepeat="no-repeat";
		document.getElementById("serv2_"+nom+"txt").style.color = ListServices2[i].textcolor;
		document.getElementById("serv2_"+nom+"herf").href = ListServices2[i].page;
		if (language == "RUS") {
		   document.getElementById("serv2_"+nom+"txt").innerHTML = ListServices2[i].textRUS;
		} else {
           document.getElementById("serv2_"+nom+"txt").innerHTML = ListServices2[i].textUK;
        }
	}
}

function setLanguage() {
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
			var txt = "<a href='" + ListMenus[i].page + "'> " + ListMenus[i].RUS + "</a>";
		    tagList.children[i].innerHTML = txt;
	    } else {
			var txt = "<a href='" + ListMenus[i].page + "'> " + ListMenus[i].UK + " </a>";
		    tagList.children[i].innerHTML = txt;
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
	var hght = (wdth / 200) * 45;
	
	var logo = document.getElementById("mylogo");
	var dlogo = document.getElementById("divmylogo");
	logo.style.width=wdth + "px";
	logo.style.height=0.9 * hght + "px";
	
	dlogo.style.width=wdth + "px";
	dlogo.style.height=hght + "px";//"50px";
	
	if (window.innerWidth >= 1500) {
	    document.getElementById("mainmenu").style.height = "80px";	
	} else {
	    var mhght = (window.innerWidth / 1500) * 80;
       	if (mhght < 60) { mhght = 60; };   
	    document.getElementById("mainmenu").style.height = mhght + "px";	
	}
	
		
	logo.style.marginTop=(75 - hght) / 2.75 + "px";
	
	var tagList = document.getElementById("navigation");
	var fsli = 22;
	
	if ((Width-wdth) < +MinSize) {
		var fsli = ((Width-wdth) / MinSize) * 22;
		if (fsli < 8) { fsli = 8 }; 
        for (var i = 0; i < tagList.childElementCount; i++){					
            tagList.children[i].style.width = "14%";
			tagList.children[i].style.color = "white";
            //tagList.children[i].style.height = mhght / 3;			
		}		
	} else {
        var szz = ((Width-wdth) / MinSize) * 14;
  		if (szz > 20) { szz = 20; };
        var sztxt = szz + "%";		
        for (var i = 0; i < tagList.childElementCount; i++) {
            tagList.children[i].style.width = sztxt;
			tagList.children[i].style.color = "white";
            //tagList.children[i].style.height = mhght / 3;			
		}
	};
	
	tagList.style.fontSize=fsli + "px";
	tagList.style.marginTop= (50 - hght) / 2;
	//tagList.style.height = mhght / 3;
	
	document.getElementById("idregistration").style.fontSize = fsli + "px";
	
	var imghght = 0.5 * mhght;
	
	document.getElementById("divusers").style.height = imghght + "px";
	document.getElementById("divusers").style.width = imghght + "px";
	document.getElementById("divusers").style.marginTop = (mhght - imghght) /2 + "px";
	document.getElementById("divflaguk").style.marginTop = (mhght - 15) /2 + "px";
	document.getElementById("divflagrus").style.marginTop = (mhght - 15) /2 + "px";
	document.getElementById("divlanguage").style.marginTop = (mhght - fsli) /2 + "px";
	
}	

function sizeRowMainImage(Width) {
	var fs=(38/ 1000) * Width;
	if (fs > 38) { fs = 38; };
	document.getElementById("textup").style.fontSize=fs + "px";
	var height = Width / 1.21; 
	document.getElementById("mainrow1").style.height = height - 100 + "px";
    //document.getElementById("mainrow1").style.width = Width - 40 + "px";
	document.getElementById("textup").style.marginTop = 0.5 * (height - 100) + "px";
	document.getElementById("textup").style.paddingTop = 0.2 * (height-100) + "px";
}	

function sizeRowProducts(Width) {
    var fs=(26/ 1000) * Width;
	if (fs > 26) { fs = 26; };
	if (fs < 10) { fs = 10; };
	document.getElementById("ttlproducts").style.fontSize=fs + "px";
	document.getElementById("ttlproducts").style.height=0.075*(Width / 1.21) + "px";
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
	var fsft=(16/ 1000) * Width;
	if (fsft > 16) { fsft = 16; };
	if (fsft < 7) { fsft = 7; };
    document.getElementById("tabfooter1").style.fontSize=fsft + "px";
    document.getElementById("tabfooter2").style.fontSize=fsft + "px";
    document.getElementById("tabfooter3").style.fontSize=fsft + "px";
    document.getElementById("tabfooter4").style.fontSize=fsft + "px";
	fsft++;
	if (fsft < 8) { fsft = 8; };
	document.getElementById("myfooter").style.fontSize=fsft + "px";
	//var height = Width / 1.21; 
    //var height1 = Width / 4;
	//var hhh = +height + 2.5*height1 + 90;
	//if (+hhh >= window.innerHeight) {
    //  hhh = 50;
    //} else { hhh = window.innerHeight - hhh; };  				
	//document.getElementById("myfooter").style.height = hhh + "px";
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
	
	var hghm = document.getElementById("mainmenu").style.height;
	var hgh0 = hghm.replace("px","");
    var hgh1 = document.getElementById("mainrow1").offsetHeight;
	var hgh2 = document.getElementById("rowproducts").offsetHeight;
	var hgh3 = document.getElementById("ttlservices1").offsetHeight;
	var hgh4 = document.getElementById("rowsupports").offsetHeight;
	var hgh5 = document.getElementById("lastrow").offsetHeight;
	var hghf = document.getElementById("myfooter").style.height;
	var hgh6 = hghf.replace("px","");
    var height =  window.innerHeight - hgh0 - hgh1 - 3*hgh2 - 4*hgh3 - hgh4 - hgh5 - hgh6 - 80;	
	if (height < 0) { height=0; };
    document.getElementById("beetwinrow").style.height = height + "px";
	
	
	sizeFooter(width);
	setLanguage();
}


	function productsleft() {
      ProductIndex--;
      if (ProductIndex < 0) { ProductIndex = 0; };
	  initProducts();
	}
	
	function productsright() {
	  ProductIndex++;
      if (ProductIndex > ListProducts.length - 4) { ProductIndex = ListProducts.length - 4; };
	  initProducts();
	}
	
	function serviceleft1() {
      ServicesIndex1--;
      if (ServicesIndex1 < 0) { ServicesIndex1 = 0; };
	  initServices1();
	}
	
	function serviceright1() {
	  ServicesIndex1++;
      if (ServicesIndex1 > ListServices1.length - 4) { ServicesIndex1 = ListServices1.length - 4; };
	  initServices1();
	}
	
	function serviceleft2() {
      ServicesIndex2--;
      if (ServicesIndex2 < 0) { ServicesIndex2 = 0; };
	  initServices2();
	}
	
	function serviceright2() {
	  ServicesIndex2++;
      if (ServicesIndex2 > ListServices2.length - 4) { ServicesIndex2 = ListServices2.length - 4; };
	  initServices2();
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
				
	function forminput() {
		document.getElementById("login").style.display = "block";
		document.getElementById("container").style.display = "block";
	}
	
	function forminputexit() {
		document.getElementById("container").style.display = "none";
		document.getElementById("login").style.display = "none";
		document.getElementById("register").style.display = "none";
	}
	
	function fshowregistration() {
	   	document.getElementById("login").style.display = "none";
		document.getElementById("register").style.display = "block";
		document.getElementById("container").style.top = "80px";
	}