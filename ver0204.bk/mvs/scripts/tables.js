var listCurrency = [];
var IntervalShow = 0;
var PositionShow = 0;
var lastUpdate = 0;

function createTable(tableId,List,colCount) {
	var width = 0.6 * window.innerWidth;
	var height = width / 4;
    var table=document.getElementById(tableId);
	var currRows = table.rows.length;
    var listRows = List.length;	
	
	if (currRows < +listRows + 2) {
		for (var i=1; i <= +listRows; i++) {
		     var newRow = document.getElementById(tableId).insertRow(i);
			 var MyColumns = [];
			 for (var j=0; j<colCount-3; j++) {
                 MyColumns[j] = newRow.insertCell(j);
             } 	
			 MyColumns[2].colSpan = 2;
			 MyColumns[3].colSpan = 2;
			 MyColumns[4].colSpan = 2;
        }
	} else if (+currRows > +listRows + 2) {
         for (var i=currRows - 1; i >= listRows + 2; i--) {
            document.getElementById(tableId).deleteRow(i+1); 
		 }			 
    }	
	
	//for (var i=1; i<=listRows; i++) {
	//	table.rows[i].cells[2].style.backgroundImage="url(../" + List[i-1].image + ")";
	//	table.rows[i].cells[2].style.backgroundSize="100% 100%";
	//}	
};

function createTableTry() {
	//var title=document.getElementById("idtrybodyhead");
	var table=document.getElementById("idtrybodybody");
	var currRows = table.rows.length / 2;
    var listRows = purchase.length;	
	
	if (+currRows < +listRows) {
		for (var i=currRows+1; i <= +listRows; i++) {
		    
			var newRow2 = document.getElementById("idtrybodybody").insertRow(2*i-2); 
			var MyColumns2 = [];
            for (var j=0; j<3; j++) {
                MyColumns2[j] = newRow2.insertCell(j);
            }
			MyColumns2[0].colSpan = 2;
			MyColumns2[2].colSpan = 2;
			
			var newRow1 = document.getElementById("idtrybodybody").insertRow(2*i-2);
			var MyColumns1 = [];
			for (var j=0; j<3; j++) {
                MyColumns1[j] = newRow1.insertCell(j);
            } 
			MyColumns1[1].colSpan = 3;
			
        }
	} else if (+currRows > +listRows) {
         for (var i=currRows; i >=listRows + 1; i--) {
            document.getElementById("idtrybodybody").deleteRow(2*i-1); 
			document.getElementById("idtrybodybody").deleteRow(2*i-2);
		 }			 
    }
	 
	if (+listRows > 0) {
        for (var i=0; i< listRows; i++) {
			var tprice = +purchase[i].price;
			var tsumma = tprice * purchase[i].amount;;
			if (currcurrency == 0) {
				tsumma = moneySeparator(+tsumma.toFixed(2)) + " р.";
				tprice = moneySeparator(+tprice.toFixed(2)) + " р.";
			} else if (currcurrency == 1) {
				if (currencyEURO > 0) {
					tsumma = tsumma / currencyEURO;
					tsumma = moneySeparator(+tsumma.toFixed(2));
					tsumma = "€ " + tsumma;
					tprice = tprice / currencyEURO;
					tprice = moneySeparator(+tprice.toFixed(2));
					tprice = "€ " + tprice;
				} else {
					tsumma = moneySeparator(+tsumma.toFixed(2)) + " р.";
				    tprice = moneySeparator(+tprice.toFixed(2)) + " р.";
				};
			} else if (currcurrency == 2) {
				if (currencyUSA > 0) {
					tsumma = tsumma / currencyUSA;
					tsumma = moneySeparator(+tsumma.toFixed(2));
					tsumma = "$ " + tsumma;
					tprice = tprice / currencyUSA;
					tprice = moneySeparator(+tprice.toFixed(2));
					tprice = "$ " + tprice;
				} else {
					tsumma = moneySeparator(+tsumma.toFixed(2)) + " р.";
				    tprice = moneySeparator(+tprice.toFixed(2)) + " р.";
				};
			};
		    table.rows[2*i].cells[0].innerHTML = i + 1;
			table.rows[2*i].cells[0].style = "width: 10%; border-bottom: 1px solid; border-right: 1px solid; border-collapse: collapse;";
			var pname = "";
			var sht = " шт"
			if (language == "RUS") {
				pname = purchase[i].nameRUS;
			} else {
                pname = purchase[i].nameUK;
				sht = "pcs";
			};
			
		    table.rows[2*i].cells[1].innerHTML = pname.replace("</br>", " ");
			table.rows[2*i].cells[1].style = "width: 85%; border-bottom: 1px solid; border-collapse: collapse; text-align: left;";
			table.rows[2*i].cells[2].innerHTML = "<input id='iddelproduct" + i + "' type='button' value='X' style='width: 100%' onClick='deleteOneProduct(" + i + ")'/>";
			table.rows[2*i].cells[2].style = "width: 5%; border-bottom: 1px solid; border-collapse: collapse;";
			table.rows[2*i + 1].cells[0].innerHTML = tprice;
			table.rows[2*i + 1].cells[0].style = "width: 40%; border-bottom: 2px solid; border-right: 1px solid; border-collapse: collapse;";
		    table.rows[2*i + 1].cells[1].innerHTML = purchase[i].amount + sht;
			table.rows[2*i + 1].cells[1].style = "width: 20%; border-bottom: 2px solid; border-right: 1px solid; border-collapse: collapse;";
			table.rows[2*i + 1].cells[2].innerHTML = tsumma;
			table.rows[2*i + 1].cells[2].style = "border-bottom: 2px solid; border-collapse: collapse;";
        }		
	}
};

function round_mod(value, precision)
{
    // спецчисло для округления
    var precision_number = Math.pow(10, precision);

    // округляем
    return Math.round(value * precision_number) / precision_number;
}

function getCurrecy () {
    $( document ).ready(function() {
	    $.getJSON('https://www.cbr-xml-daily.ru/daily_json.js', function ( data, textStatus, jqXHR ) { // указываем url и функцию обратного вызова
		    currencyEURO = data.Valute.EUR.Value.toFixed(2);
			currencyUSA = data.Valute.USD.Value.toFixed(2);
	    })
	    .done(function() {
            console.log( "second success" );
            combobox1Select();
		})
        .fail(function() {
			currencyEURO = -1;
			currencyUSA = -1;
            console.log( "error" );
        })
        .always(function() {
            console.log( "complete" );
        });	
	});
};

function getPriceProduct(Row) {
	
	var cprice = -2;
	var chref = "contacts.html";
	var pg = document.title;
	if (pg == "MVSGroup Products") { 
	    cprice = ListProducts[Row-1].price;
		chref = ListProducts[Row-1].infopage;
	} else if (pg == "MVSGroup Services App") {	
	    cprice = ListServices1[Row-1].price;
		chref = ListServices1[Row-1].infopage;
	} else if (pg == "MVSGroup Services Video") {	
	    cprice = ListServices2[Row-1].price;
		chref = ListServices2[Row-1].infopage;
	};
	
	if (cprice == "-1") { 
	    window.location.href = "../" + chref;//replace("contacts.html");
	} else if (cprice == "-2") {
        window.location.href = "contacts.html";//replace("payment.html");
	} else {
        productSelect(Row-1);
    };
};

function prodMouseOver(nom) {
	var List;
	var pg = document.title;
	if (pg == "MVSGroup Products") { 
	    List = ListProducts;
	} else if (pg == "MVSGroup Services App") {	
	     List = ListServices1;
	}  else if (pg == "MVSGroup Services Video") {	
	     List = ListServices2;
	};
	var width = 0.6 * window.innerWidth;
	var ipos = 0;
	var cimage = document.getElementById("imageprod" + nom);
	var typeshow = List[nom].typeshow;
	if (+typeshow == 2) {
		IntervalShow = setInterval(function () {
			cimage.src="../" + List[nom].listimg[ipos].image;
			cimage.height=width / 4;
			ipos++;
			if (ipos >= List[nom].listimg.length) { ipos=0 };
		}, 1000);
	} else if (+typeshow == 1) {
		cimage.src="../" + List[nom].listimg[0].image;
		cimage.height=width / 4;
	};
};

function prodMouseOut(nom) {
	var List;
	var pg = document.title;
	if (pg == "MVSGroup Products") { 
	    List = ListProducts;
	} else if (pg == "MVSGroup Services App") {	
	     List = ListServices1;
	}  else if (pg == "MVSGroup Services Video") {	
	     List = ListServices2;
	};
	clearInterval(IntervalShow);
	var cimage = document.getElementById("imageprod" + nom);
    cimage.src="../" + List[nom].image;
};

function ShowArrayUp() { 
    var hmenu = document.getElementById("mainmenu").offsetHeight;
    var currtop = window.scrollY;
	if (+currtop > +hmenu) {
	    document.getElementById("divarrayup").style.display="block";
	} else {
	    document.getElementById("divarrayup").style.display="none";
	};
	var isTry = document.getElementById("tryproducts");
    if (isTry !== null) {	
		if (purchase.length == 0) {
            document.getElementById("tryproducts").style.display="none";
		} else {
			document.getElementById("tryproducts").style.display="block";
		};
		lastupdate = lastupdate + 1;
		if ( +lastupdate > 3600) {
			getCurrecy();
			lastupdate = 0;
			var pg = document.title;
			if (pg == "MVSGroup Products") {
			    myresizeproducts();
			} else if (pg == "MVSGroup Services App") {
				myresizesubservices();
			} else if (pg == "MVSGroup Services Video") {
				myresizesubservices(); 
			};
            		
		};
	};
//	var mode = sessionStorage.getItem('mode');
//	sessionStorage.setItem('mode', '');
    //var userregistrated = '<?php echo $_POST[$registration];?>';
	
//	if (mode == "input") {
//         showModalWin(3);
//	};
	
//	Data = new Date();
//    Hour = Data.getHours();
//    Minutes = Data.getMinutes();
//    Seconds = Data.getSeconds();
	
};

function currentMode() {
	var mode = sessionStorage.getItem('mode');
	sessionStorage.setItem('mode', '');
	var cuser = sessionStorage.getItem('user');
	if (cuser == null) { cuser=""; };
	var cpassword = sessionStorage.getItem('password');
	if (cpassword == null) { cpassword=""; };
	
	if (mode == "input_ok") {
		//document.getElementById("mode_users").innerHTML="Выход";
		//document.getElementById("mode_users").style.marginLeft = "10%";
		userregistrated = true;
		sessionStorage.setItem('isregistration','Yes');
		setLanguage();
		showModalWin(5);
		//showLoginWin();
		 //document.getElementById("login").style.display="block";
	} else if (mode == "password_error") {
		
		if (language == "RUS") {
		    document.getElementById("inputmess").innerHTML="Неправильно заданы пароль или логин";
		} else {
			document.getElementById("inputmess").innerHTML="Password or login is wrong";
		};
		document.getElementById("username").value = cuser;
		document.getElementById("password").value = cpassword;
		showLoginWin();
	} else if (mode == "user_error") {
		if (language == "RUS") {
		    document.getElementById("inputmess").innerHTML="Неправильно заданы логин или пароль";
		} else {
			document.getElementById("inputmess").innerHTML="Login or password is wrong";
		};
		document.getElementById("username").value = cuser;
		document.getElementById("password").value = cpassword;
		showLoginWin();
	} else if (mode == "user_exist_error") {
		showRegisterWin()
	} else if (mode == "data_error") {
		showModalWin(4);
	}else if (mode == "registration_error") {
		showRegisterWin()
	}else if (mode == "registration_ok") {
		showLoginWin();
	};
};

function clearRegistration() {
	sessionStorage.setItem('isregistration', '');
	userregistrated = false;
	sessionStorage.setItem('user', '');
	sessionStorage.setItem('password', '');
	sessionStorage.setItem('name', '');
	sessionStorage.setItem('subname', '');
	sessionStorage.userstatus = "";
	sessionStorage.MVSUID = "";
};
	

