function createTable(tableId,List,colCount) {
	var width = 0.6 * window.innerWidth;
	var height = width / 4;
    var table=document.getElementById(tableId);
	var currRows = table.rows.length;
    var listRows = List.length;	
	
	if (currRows < +listRows + 2) {
		for (var i=1; i <= +listRows; i++) {
		     var newRow = document.getElementById(tableId).insertRow(i);
             //var Col1=newRow.insertCell(0);
             //var Col2=newRow.insertCell(1);
			 newRow.height = height + "px";
			 var MyColumns = [];
			 for (var j=0; j<colCount-3; j++) {
                 MyColumns[j] = newRow.insertCell(j);
                // MyColumns[j].innerHTML="Row="+i+" Col="+j; 
				 MyColumns[j].height = height + "px";
				 //MyColumns[j].backgroundImage=List[j].image;
             } 	
			 MyColumns[2].colSpan = 2;
			 //MyColumns[2].style.backgroundImage="url(../" + List[i].image + ")";
			 MyColumns[3].colSpan = 2;
			 MyColumns[4].colSpan = 2;
			 //Col1.innerHTML="NEW CELL1";
             //Col2.innerHTML="NEW CELL2";
        }
	} else if (+currRows > +listRows + 2) {
         for (var i=currRows - 1; i >= listRows + 2; i--) {
            document.getElementById(tableId).deleteRow(i+1); 
		 }			 
    }	
	
	for (var i=1; i<=listRows; i++) {
		table.rows[i].cells[2].style.backgroundImage="url(../" + List[i-1].image + ")";
		table.rows[i].cells[2].style.backgroundSize="100% 100%";
	    // MyColumns[2].style.backgroundImage="url(../" + List[i].image + ")";
	}	
}

//var table=document.getElement........//получаем элемент таблицы
//table.rows.length;//количество строк
//function deleteRow(row)
//{
//    var i=row.parentNode.parentNode.rowIndex;
//    document.getElementById('POITable').deleteRow(i);
//}


//function insRow()
//{
//    var x=document.getElementById('POITable').insertRow(1);
//    var c1=x.insertCell(0);
//    var c2=x.insertCell(1);
//    c1.innerHTML="NEW CELL1";
//    c2.innerHTML="NEW CELL2";
//}