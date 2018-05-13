/* 
  * Created by Zavialov on 14.01.2018.
 */
"use strict";

var DeviceCanvasTop;
var TimelineCanvasTop;

function setDefaultValue(value) {
//ShowEvents, ShowDevices, ShowEditor, ShowScaler, ShowTimelines, ShowNameTL,
//ShowAllTimelines, ShowDev1, ShowDev2;  
  ShowEditor = value[2]; 
  ShowScaler = value[3];
  ShowTimelines = value[4];
  ShowAllTimelines = value[6];
  ShowDevices = value[1];
  ShowEvents = value[0];
  ShowNameTL = value[5];
  ShowDev1 = value[7];
  ShowDev2 = value[8];  
    
} //end setDefaultValue;

function SetTypeScreen0() {
  setDefaultValue(DefaultScreen0);
  
  //mnCanvas.style = "display : block;";
  evCanvas.style = "display : block;";
  dvCanvas.style = "display : block;";
  edCanvas.style = "display : block;";
  tvCanvas.style = "display : block;";
  //tmCanvas.style = "display : block;";
  
  
  mnCanvas.style.visibility = "hidden";
  evCanvas.style.visibility = "hidden";
  dvCanvas.style.visibility = "hidden";
  edCanvas.style.visibility = "hidden";
  tvCanvas.style.visibility = "hidden";
  //tmCanvas.style.visibility = "hidden";
  tmCanvas.style = "display : none;";
  
  var steph = scrH / 100;
  var stepw =scrW / 17.5;
  
  LengthNameTL = Math.floor(stepw * 2,5);
  MyCursor = Math.floor(stepw);
  
  var hdev;
  if (scrH<scrW) {
    hdev = ((stepw / 1.75) / 2) * 5;  
  } else {
    hdev = 0.065 * scrH;   
  }
  
  var htmln = (TimeLineHeight / 85 * 100) * (4 + +TLT.length);

  HeightMenu = (scrH / 100) * MenuProcent;
  var prmenu = HeightMenu / scrH;
  
  var prcellar = 0.02;
  
  var halltl = 0;
  var pralltl = 0.02;
  if (ShowAllTimelines) {
    if (TLT.length<=4) {  
      halltl = 8 * TLT.length;  
    } else if (TLT.length>4 && TLT.length<=8) {
      halltl = 6 * TLT.length;  
    } else if (TLT.length>8 && TLT.length<=12) {
      halltl = 5 * TLT.length;  
    } else if (TLT.length>8 && TLT.length<=16) {
      halltl = 4 * TLT.length;  
    }
    pralltl = halltl / scrH;
  }

  
  var prtl = htmln / scrH;
  var prdevices = hdev / scrH;
  var prevents = 1 - prmenu - prdevices - prtl - pralltl;// - prcellar;
  
  var hcell = (scrH * prevents) / (+CountEvents + 1);
  if (hcell >= 1.5 * stepw) { 
    DoubleSize = 1;
  } else {
    DoubleSize = 0; 
  }  
  
  mnCanvas.width = scrW;
  mnCanvas.height = scrH * prmenu;
  if (MenuProcent !== 100) {
//?????????????????????????      
  evCanvas.width = scrW;
  evCanvas.height = scrH * prevents;
  dvCanvas.width = scrW;
  dvCanvas.height = scrH * prdevices;
  edCanvas.width = scrW;
  edCanvas.height = scrH * prtl;
  tvCanvas.width = scrW;
  tvCanvas.height = scrH * pralltl;
  //tmCanvas.width = scrW;
  //tmCanvas.height = scrH * prcellar;
  DeviceCanvasTop = +mnCanvas.height + +evCanvas.height; 
  TimelineCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height; 
    
  mncv.clearRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.clearRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.clearRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.clearRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.clearRect(0, 0, tmCanvas.width, tmCanvas.height);
  mncv.fillStyle = ProgrammColor;//"black";
  ecv.fillStyle = "black";
  dcv.fillStyle = "black";
  edcv.fillStyle = "black";
  tlcv.fillStyle = "black";
  tmcv.fillStyle = "black";
  mncv.fillRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.fillRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.fillRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.fillRect(0, 0, tmCanvas.width, tmCanvas.height);
   
    //mncv.font = "20pt Arial";  
    //mncv.fillStyle = cfont;
    //mncv.textBaseline = "middle"; 
    //mncv.textAlign  = "left";
    //mncv.fillText(DoubleSize+ " - " + hcell + " : " + stepw, 50 , mnCanvas.height/2);  
        
    currtlo = TLO[ActiveTL];
    currtlt = TLT[ActiveTL];
    drawToolBar(mncv,mnCanvas.width, mnCanvas.height);
   
    if (typeof (currtlo) !== "undefined") {
      drawMyDev(dcv,dvCanvas.width,dvCanvas.height,currtlo);  
    }
    
    if (typeof (currtlt) !== "undefined") {
      MyDrawEvents(ecv,evCanvas.width,evCanvas.height, false);
      //MyDrawDevEvents(ecv,evCanvas.width,evCanvas.height,0,false);
    }
      
    if (typeof (currtlt) !== "undefined") {
      DrawTimeLines(edcv,edCanvas.width,edCanvas.height); 
      DrawTimeLineNames(edcv,edCanvas.width,edCanvas.height);  
      DrawAllTimelines(tlcv, tvCanvas.width, tvCanvas.height);  
    }   
    
  mnCanvas.style.visibility = "visible";
  evCanvas.style.visibility = "visible";
  dvCanvas.style.visibility = "visible";
  edCanvas.style.visibility = "visible";
  tvCanvas.style.visibility = "visible";
  //tmCanvas.style.visibility = "visible";
  tmCanvas.style = "display : none;";  
//??????????????????????????????  
  } else {
    evCanvas.height = 0;//scrH * prevents;
    dvCanvas.height = 0;//scrH * prdevices;
    edCanvas.height = 0;//scrH * prtl;
    tvCanvas.height = 0;//scrH * pralltl;
    tmCanvas.height = 0;//scrH * prcellar;  
    mncv.clearRect(0, 0, mnCanvas.width, mnCanvas.height); 
    mncv.fillStyle = ProgrammColor;
    mncv.fillRect(0, 0, mnCanvas.width, mnCanvas.height);
    drawToolBar(mncv,mnCanvas.width, mnCanvas.height);
    mnCanvas.style.visibility = "visible";
  }
} // end SetTypeScreen0 

function SetTypeScreen1() {
  setDefaultValue(DefaultScreen1);
  
  //mnCanvas.style = "display : block;";
  evCanvas.style = "display : block;";
  dvCanvas.style = "display : block;";
  //edCanvas.style = "display : block;";
  //tvCanvas.style = "display : block;";
  //tmCanvas.style = "display : block;";
  
  mnCanvas.style.visibility = "hidden";
  evCanvas.style.visibility = "hidden";
  dvCanvas.style.visibility = "hidden";
  //edCanvas.style.visibility = "hidden";
  //tvCanvas.style.visibility = "hidden";
  //tmCanvas.style.visibility = "hidden";
  
  edCanvas.style = "display : none;";
  tvCanvas.style = "display : none;";
  tmCanvas.style = "display : none;";
  
  //var steph = scrH / 100;
  var stepw =scrW / 17.5;
  
  LengthNameTL = 0; //Math.floor(stepw * 2,5);
  MyCursor = Math.floor(stepw * 3);
  
  var hdev;
  if (scrH<scrW) {
    hdev = ((stepw / 1.75) / 2) * 5;  
  } else {
    hdev = 0.065 * scrH;   
  }
  //var htmln = (TimeLineHeight / 85 * 100) * (4 + TLT.length);
  //var halltl = 4 * 16;
  
  var prcellar = 0.02;
  var pralltl = 0.02;
  HeightMenu = scrH / 100 * 5;
  var prmenu = HeightMenu / scrH;
  var prtl = 0.02;
  var prdevices = hdev / scrH;
  var prevents = 1 - prmenu - prdevices;// - prtl - pralltl - prcellar;
  
  var hcell = (scrH * prevents) / (+CountEvents+1);
  if (hcell >= 1.5 * stepw) { 
    DoubleSize = 1;
  } else {
    DoubleSize = 0; 
  }
    
  mnCanvas.width = scrW;
  mnCanvas.height = scrH * prmenu;
  evCanvas.width = scrW;
  evCanvas.height = scrH * prevents;
  dvCanvas.width = scrW;
  dvCanvas.height = scrH * prdevices;
  //edCanvas.width = scrW;
  //edCanvas.height = scrH * prtl;
  //tvCanvas.width = scrW;
  //tvCanvas.height = scrH * pralltl;
  //tmCanvas.width = scrW;
  //tmCanvas.height = scrH * prcellar;
  DeviceCanvasTop = +mnCanvas.height + +evCanvas.height;
  TimelineCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height;
  
  mncv.clearRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.clearRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.clearRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.clearRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.clearRect(0, 0, tmCanvas.width, tmCanvas.height);
  mncv.fillStyle = ProgrammColor;//"black";
  ecv.fillStyle = "black";
  dcv.fillStyle = "black";
  edcv.fillStyle = "black";
  tlcv.fillStyle = "black";
  tmcv.fillStyle = "black";
  mncv.fillRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.fillRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.fillRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.fillRect(0, 0, tmCanvas.width, tmCanvas.height);
   
//    mncv.font = "20pt Arial";  
//    mncv.fillStyle = cfont;
//    mncv.textBaseline = "middle"; 
//    mncv.textAlign  = "left";
//    mncv.fillText(scrW + " x " + scrH + " - " + tempwidth, 50 , mnCanvas.height/2);  
        
    currtlo = TLO[ActiveTL];
    currtlt = TLT[ActiveTL];
    drawToolBar(mncv,mnCanvas.width, mnCanvas.height);
   
    if (typeof (currtlo) !== "undefined") {
      drawMyDev(dcv,dvCanvas.width,dvCanvas.height,currtlo);  
    }
    
    if (typeof (currtlt) !== "undefined") {
      MyDrawEvents(ecv,evCanvas.width,evCanvas.height, false);
      //MyDrawDevEvents(ecv,evCanvas.width,evCanvas.height,0);
    }
      
 //   if (typeof (currtlt) !== "undefined") {
 //     DrawTimeLines(); 
 //     DrawTimeLineNames();  
 //     DrawAllTimelines();  
 //   }   
    
  mnCanvas.style.visibility = "visible";
  evCanvas.style.visibility = "visible";
  dvCanvas.style.visibility = "visible";
  //edCanvas.style.visibility = "visible";
  //tvCanvas.style.visibility = "visible";
  //tmCanvas.style.visibility = "visible";
  
  edCanvas.style = "display : none;";
  tvCanvas.style = "display : none;";
  tmCanvas.style = "display : none;";
  
} // end SetTypeScreen1

function SetTypeScreen2() {
  setDefaultValue(DefaultScreen2);  

  mnCanvas.style.visibility = "hidden";
  evCanvas.style.visibility = "hidden";
  dvCanvas.style.visibility = "hidden";
  edCanvas.style.visibility = "hidden";
  tvCanvas.style.visibility = "hidden";
  tmCanvas.style.visibility = "hidden";
  
  var steph = scrH / 100;
  var stepw =scrW / 17.5;
  
  if (ShowNameTL) { 
    LengthNameTL = Math.floor(stepw * 2,5);
    MyCursor = Math.floor(stepw);
  } else {
    LengthNameTL = 0;  
    MyCursor = Math.floor(stepw * 3);
  }    
  var prdevices = 0.02;
  if (ShowDevices) {
    var hdev = ((stepw / 1.75) / 2) * 5;
    prdevices = hdev / scrH;
  }
  
  //var hdev = ((stepw / 1.75) / 2) * 5;
  var counttl = 0;
  if (ShowScaler) { counttl = counttl + 1 }
  if (ShowEditor) { counttl = counttl + 3 }
  if (ShowTimelines) { counttl = counttl + TLT.length }
  
  var htmln = (TimeLineHeight / 85 * 100) * counttl;
  
  var blshowtl = ShowScaler || ShowEditor || ShowTimelines;

  var prtl = 0.02;   
  if (blshowtl) {
    prtl = htmln / scrH;  
  } 
  
  var halltl = 0;
  var pralltl = 0.02;
  if (ShowAllTimelines) {
    if (TLT.length<=4) {  
      halltl = 8 * TLT.length;  
    } else if (TLT.length>4 && TLT.length<=8) {
      halltl = 6 * TLT.length;  
    } else if (TLT.length>8 && TLT.length<=12) {
      halltl = 5 * TLT.length;  
    } else if (TLT.length>8 && TLT.length<=16) {
      halltl = 4 * TLT.length;  
    }
    pralltl = halltl / scrH;
  }
  
  var prcellar = 0.02;
  HeightMenu = scrH / 100 * 5;
  var prmenu = HeightMenu / scrH;
  var prevents = 1 - prmenu - prdevices - prtl - pralltl - prcellar;
  
  var hcell = (scrH * prevents) / (+CountEvents+1);
  if (hcell >= 1.5 * stepw) { 
    DoubleSize = 1;
  } else {
    DoubleSize = 0; 
  } 
    
  mnCanvas.width = scrW;
  mnCanvas.height = scrH * prmenu;
  
  
  
  evCanvas.width = scrW;
  evCanvas.height = scrH * prevents;
  if (ShowDevices) {
    dvCanvas.width = scrW;  
    dvCanvas.height = scrH * prdevices;
  }
  if (blshowtl) {
    edCanvas.width = scrW;
    edCanvas.height = scrH * prtl;
  }
  if (ShowAllTimelines) {
    tvCanvas.width = scrW;
    tvCanvas.height = scrH * pralltl;
  }
  if (! ShowDevices) {
    dvCanvas.width = scrW;  
    dvCanvas.height = 0;//scrH * 0.02;
  }
  if (! blshowtl) {
    edCanvas.width = scrW;
    edCanvas.height = 0;//scrH * 0.02;
  }
  if (! ShowAllTimelines) {
    tvCanvas.width = scrW;
    tvCanvas.height = 0;//scrH * 0.02;
  }
  tmCanvas.width = scrW;
  tmCanvas.height = 0;//scrH * 0.02;
  
  DeviceCanvasTop = +mnCanvas.height + +evCanvas.height;
  TimelineCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height;
  
  mncv.clearRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.clearRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.clearRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.clearRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.clearRect(0, 0, tmCanvas.width, tmCanvas.height);
  mncv.fillStyle = ProgrammColor;//"black";
  ecv.fillStyle = "black";
  dcv.fillStyle = "black";
  edcv.fillStyle = "black";
  tlcv.fillStyle = "black";
  tmcv.fillStyle = "black";
  mncv.fillRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.fillRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.fillRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.fillRect(0, 0, tmCanvas.width, tmCanvas.height);
   
//    mncv.font = "20pt Arial";  
//    mncv.fillStyle = cfont;
//    mncv.textBaseline = "middle"; 
//    mncv.textAlign  = "left";
//    mncv.fillText(scrW + " x " + scrH + " - " + tempwidth, 50 , mnCanvas.height/2);  
    
//    rectRound(mncv, 50, 2, 100, mnCanvas.height-5, 10, "yellow");
    
    currtlo = TLO[ActiveTL];
    currtlt = TLT[ActiveTL];
    drawToolBar(mncv,mnCanvas.width, mnCanvas.height);
    
    if (ShowDevices) {
      if (typeof (currtlo) !== "undefined") {
        drawMyDev(dcv,dvCanvas.width,dvCanvas.height,currtlo);  
      }
    }
    
    if (typeof (currtlt) !== "undefined") {
      if (ShowEvents) {   
        MyDrawEvents(ecv,evCanvas.width,evCanvas.height,false);
      } else {  
        MyDrawDevEvents(ecv,evCanvas.width,evCanvas.height,0,false);
      }  
    }
      
    if (typeof (currtlt) !== "undefined") {
      if (blshowtl) { DrawTimeLines(edcv,edCanvas.width,edCanvas.height); } 
      if (ShowNameTL) { DrawTimeLineNames(edcv,edCanvas.width,edCanvas.height); }  
      if (ShowAllTimelines) { DrawAllTimelines(tlcv, tvCanvas.width, tvCanvas.height); } 
    }   
    
  mnCanvas.style.visibility = "visible";
  evCanvas.style.visibility = "visible";
  dvCanvas.style.visibility = "visible";
  edCanvas.style.visibility = "visible";
  tvCanvas.style.visibility = "visible";
  tmCanvas.style.visibility = "visible";
      
} // end SetTypeScreen2

function SetTypeScreen3() {
  setDefaultValue(DefaultScreen3);   

  mnCanvas.style.visibility = "hidden";
  evCanvas.style.visibility = "hidden";
  dvCanvas.style.visibility = "hidden";
  edCanvas.style.visibility = "hidden";
  tvCanvas.style.visibility = "hidden";
  tmCanvas.style.visibility = "hidden";
  
  var steph = scrH / 100;
  var stepw =scrW / 17.5;
  
  WidthDevice = 80;
  
  IntervalDevice = stepw / 100 * 10;
  if (IntervalDevice<10) { IntervalDevice = 10 }
  WidthDevice = stepw - IntervalDevice;
  
  if (ShowNameTL) { 
    LengthNameTL = Math.floor(stepw * 2,5);
    MyCursor = Math.floor(stepw);
  } else {
    LengthNameTL = 0;  
    MyCursor = Math.floor(stepw * 3);
  }    
//  var prdevices = 0.02;
//  if (ShowDevices) {
//    var hdev = ((stepw / 1.75) / 2) * 5;
//    prdevices = hdev / scrH;
//  }
  
  //var hdev = ((stepw / 1.75) / 2) * 5;
  var counttl = 0;
  if (ShowScaler) { counttl = counttl + 1 }
  if (ShowEditor) { counttl = counttl + 3 }
  if (ShowTimelines) { counttl = counttl + TLT.length }
  
  var htmln = (TimeLineHeight / 85 * 100) * counttl;
  
  var blshowtl = ShowScaler || ShowEditor || ShowTimelines;

  var prtl = 0.02;   
  if (blshowtl) {
    prtl = htmln / scrH;  
  } 
  
  var halltl = 0;
  var pralltl = 0.02;
  if (ShowAllTimelines) {
    if (TLT.length<=4) {  
      halltl = 8 * TLT.length;  
    } else if (TLT.length>4 && TLT.length<=8) {
      halltl = 6 * TLT.length;  
    } else if (TLT.length>8 && TLT.length<=12) {
      halltl = 5 * TLT.length;  
    } else if (TLT.length>8 && TLT.length<=16) {
      halltl = 4 * TLT.length;  
    }
    pralltl = halltl / scrH;
  }
  
  var cntevents = 0;
  if (ShowEvents) { cntevents = +cntevents + +CountEvents }
  if (ShowDev1) { cntevents = +cntevents + +EventsDev1 }
  if (ShowDev2) { cntevents = +cntevents + +EventsDev2 }
  
  HeightMenu = scrH / 100 * 5;
  var prmenu = HeightMenu / scrH;
  
  var prevents = 1 - prmenu - prtl - pralltl;
  var oneev = prevents / (cntevents + 1);
  var prev1 = 0.02; 
  if (ShowDev1) { prev1 = +EventsDev1 * oneev; }
  var prev2 = 0.02; 
  if (ShowDev2) { prev2 = +EventsDev2 * oneev; } 
  var preva = 0.02;
  if (ShowEvents) { preva = prevents - prev1 - prev2; }

  var hcell = (scrH * prevents) / (+cntevents+1);
  if (hcell >= 1.5 * stepw) { 
    DoubleSize = 1;
  } else {
    DoubleSize = 0; 
  } 
    
  mnCanvas.width = scrW;
  mnCanvas.height = scrH * prmenu;
  if (ShowEvents) {
    evCanvas.width = scrW;
    evCanvas.height = scrH * preva;
  }
  if (ShowDev1) {
    dvCanvas.width = scrW;  
    dvCanvas.height = scrH * prev1;
  }
  if (blshowtl) {
    edCanvas.width = scrW;
    edCanvas.height = scrH * prtl;
  }
  if (ShowAllTimelines) {
    tvCanvas.width = scrW;
    tvCanvas.height = scrH * pralltl;
  }
  if (ShowDev2) {
    tmCanvas.width = scrW;
    tmCanvas.height = scrH * prev2;
  }
  if (! ShowEvents) {
    evCanvas.width = scrW;
    evCanvas.height = 0;//scrH * 0.02;
  }
  if (! ShowDev1) {
    dvCanvas.width = scrW;  
    dvCanvas.height = 0;//scrH * 0.02;
  }
  if (! blshowtl) {
    edCanvas.width = scrW;
    edCanvas.height = 0;//scrH * 0.02;
  }
  if (! ShowAllTimelines) {
    tvCanvas.width = scrW;
    tvCanvas.height = 0;//scrH * 0.02;
  }
  if (! ShowDev2) {
    tmCanvas.width = scrW;
    tmCanvas.height = 0;//scrH * 0.02;
  }  
  
  DeviceCanvasTop = +mnCanvas.height + +evCanvas.height;
  TimelineCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height;
  
  mncv.clearRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.clearRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.clearRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.clearRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.clearRect(0, 0, tmCanvas.width, tmCanvas.height);
  mncv.fillStyle = ProgrammColor;//"black";
  ecv.fillStyle = "black";
  dcv.fillStyle = "black";
  edcv.fillStyle = "black";
  tlcv.fillStyle = "black";
  tmcv.fillStyle = "black";
  mncv.fillRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.fillRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.fillRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.fillRect(0, 0, tmCanvas.width, tmCanvas.height);
   
        
    currtlo = TLO[ActiveTL];
    currtlt = TLT[ActiveTL];
    
    drawToolBar(mncv,mnCanvas.width, mnCanvas.height);
    
//    if (ShowDevices) {
//      if (typeof (currtlo) !== "undefined") {
//        drawMyDev(currtlo);  
//      }
//    }
    
    if (typeof (currtlt) !== "undefined") {
      if (ShowEvents) {   
        MyDrawEvents(ecv,evCanvas.width,evCanvas.height, false);
      } 
      if (ShowDev1) {
        if (ShowEvents) {   
          MyDrawDevEvents(dcv,dvCanvas.width,dvCanvas.height,0,true); 
        } else  {
          MyDrawDevEvents(dcv,dvCanvas.width,dvCanvas.height,0,false);  
        }  
      }
      if (ShowDev2) {
        MyDrawDevEvents(tmcv,tmCanvas.width,tmCanvas.height,1,true);   
      }
    }
      
    if (typeof (currtlt) !== "undefined") {
      if (blshowtl) { DrawTimeLines(edcv,edCanvas.width,edCanvas.height); } 
      if (ShowNameTL) { DrawTimeLineNames(edcv,edCanvas.width,edCanvas.height); }  
      if (ShowAllTimelines) { DrawAllTimelines(tlcv, tvCanvas.width, tvCanvas.height); } 
    }   
    
  mnCanvas.style.visibility = "visible";
  evCanvas.style.visibility = "visible";
  dvCanvas.style.visibility = "visible";
  edCanvas.style.visibility = "visible";
  tvCanvas.style.visibility = "visible";
  tmCanvas.style.visibility = "visible";
       
} // end SetTypeScreen3

function isField(value) {
  var result = false;
  for (var i=0; i<ScreenFields.length; i++) {
    if (ScreenFields[i] == value) {
      result = true;
      break;
    }   
  } 
  return result;
} //end isField 

function SetDeviceValue() {
  for (var i=0; i<5; i++) {
    if (ScreenFields[i] == 0) {
      CountEvents = +ScreenFields_2[i]; 
    } else if (ScreenFields[i] == 4) {
      Device1 = +ScreenFields_1[i];
      EventsDev1 = +ScreenFields_2[i];
    } else if (ScreenFields[i] == 5) {
      Device2 = +ScreenFields_1[i];
      EventsDev2 = +ScreenFields_2[i];  
    }  
  }  
}

function setDeviceNumber(dev) {
  for (var i=0; i< 5; i++) {
    if (ScreenFields[i] == 4) {
      ScreenFields_1[i] = dev;
      break;
    }  
  }
}

function SetTypeScreen4() {
  setViewport();  
  setDefaultValue(DefaultScreen4);  
  //SetDeviceValue();
  
  mnCanvas.style = "display : block;";
  mnCanvas.style.visibility = "hidden";
  if (ScreenFields[0] == -1) {
    evCanvas.style = "display : none;";  
  } else {
    evCanvas.style = "display : block;"; 
    evCanvas.style.visibility = "hidden";
  }
  
  if (ScreenFields[1] == -1) {
    dvCanvas.style = "display : none;";  
  } else {
    dvCanvas.style = "display : block;"; 
    dvCanvas.style.visibility = "hidden";
  }
  
  if (ScreenFields[2] == -1) {
    edCanvas.style = "display : none;";  
  } else {
    edCanvas.style = "display : block;"; 
    edCanvas.style.visibility = "hidden";
  }
  
  if (ScreenFields[3] == -1) {
    tvCanvas.style = "display : none;";  
  } else {
    tvCanvas.style = "display : block;"; 
    tvCanvas.style.visibility = "hidden";
  }
  
  if (ScreenFields[4] == -1) {
    tmCanvas.style = "display : none;";  
  } else {
    tmCanvas.style = "display : block;"; 
    tmCanvas.style.visibility = "hidden";
  }
  
  var steph = scrH / 100;
  //var stepw =scrW / 17.5;
  
  //IntervalDevice = stepw / 100 * 10;
  //if (IntervalDevice<10) { IntervalDevice = 10 }
  //WidthDevice = stepw - IntervalDevice;
  widthCellDev(scrW);
  var stepw = +WidthDevice;
  
  if (ShowNameTL) { 
    LengthNameTL = Math.floor((scrW / 17.5) * 2,5);
    MyCursor = Math.floor(stepw);
  } else {
    LengthNameTL = 0;  
    MyCursor = Math.floor(stepw * 3);
  }    
  
//==============================================================================  
     
    var prdevices = 0;//0.02; 
    var prtl = 0;//0.02;
    var pralltl = 0;//0.02;
    HeightMenu = scrH / 100 * 5;
    var prmenu = HeightMenu / scrH;
    var prev1 = 0;//0.02;
    var prev2 = 0;//0.02;
    var preva = 0;//0.02;
    
    if (isField(1)) {
      var hdev;
      if (scrH<scrW) {
        hdev = ((stepw / 1.75) / 2) * 5;  
      } else {
        hdev = 0.065 * scrH;   
      }
      prdevices = hdev / scrH;
    }

    if (isField(2)) {
      var counttl = 0;
      if (ShowScaler) { counttl = counttl + 1 }
      if (ShowEditor) { counttl = counttl + 3 }
      if (ShowTimelines) { counttl = counttl + TLT.length }
  
      var htmln = (TimeLineHeight / 85 * 100) * counttl;
  
      var blshowtl = ShowScaler || ShowEditor || ShowTimelines;
     
      if (blshowtl) {
        prtl = htmln / scrH;  
      } 
    }
    
    var halltl = 0;

    if (isField(3)) {
      if (TLT.length<=4) {  
        halltl = 8 * TLT.length;  
      } else if (TLT.length>4 && TLT.length<=8) {
        halltl = 6 * TLT.length;  
      } else if (TLT.length>8 && TLT.length<=12) {
        halltl = 5 * TLT.length;  
      } else if (TLT.length>8 && TLT.length<=16) {
        halltl = 4 * TLT.length;  
      }
      pralltl = halltl / scrH;
    }
        
  var cntevents = 0;
  if (isField(0)) { cntevents = +cntevents + +CountEvents }
  
  var isShowDev1 = isField(4); 
  var isShowDev2 = isField(5);
  
  if (isShowDev1) { cntevents = +cntevents + +EventsDev1 }
  if (isShowDev2) { cntevents = +cntevents + +EventsDev2 }
  
  var prevents = 1 - prmenu - prtl - pralltl - prdevices;
  var oneev = prevents / (+cntevents+1);
  var cnt1 = 0;
  if (isShowDev1) { 
    prev1 = +EventsDev1 * oneev;
    cnt1 = +cnt1 + 1;
  }
  if (isShowDev2) { 
    prev2 = +EventsDev2 * oneev;
    cnt1 = +cnt1 + 1;
  } 
  if (isField(0)) { 
    preva = prevents - prev1 - prev2; 
    cnt1 = +cnt1 + 1;
  }
  
  var hcell = (scrH * prevents) / (+cntevents+1);
  if (hcell >= 1.5 * stepw) { 
    DoubleSize = 1;
  } else {
    DoubleSize = 0; 
  } 
  
  var dlt = 1 - prmenu  - prtl - pralltl - prdevices  - prev1 - prev2 -preva;
  if (dlt > 0) {
    if (cnt1 > 0) {
      dlt = dlt / cnt1;
      if (isShowDev1) { prev1 = +prev1 + +dlt; }
      if (isShowDev2) { prev2 = +prev2 + +dlt; }
      if (isField(0)) { preva = +preva + +dlt; }
    }  
  }
  
//==============================================================================
  DeviceCanvasTop = 0;
  
  mnCanvas.width = scrW;
  mnCanvas.height = scrH * prmenu;
  
  if (ScreenFields[0] !== -1) {
    if (ScreenFields[0] == 0) {
      evCanvas.width = scrW;
      evCanvas.height = scrH * preva;  
    } else if (ScreenFields[0] == 1) {
      evCanvas.width = scrW;
      evCanvas.height = scrH * prdevices; 
      DeviceCanvasTop = mnCanvas.height;
    } else if (ScreenFields[0] == 2) {
      evCanvas.width = scrW;
      evCanvas.height = scrH * prtl;  
      TimelineCanvasTop = +mnCanvas.height;
    } else if (ScreenFields[0] == 3) {
      evCanvas.width = scrW;
      evCanvas.height = scrH * pralltl;  
    } else if (ScreenFields[0] == 4) {
      evCanvas.width = scrW;
      evCanvas.height = scrH * prev1;  
    } else if (ScreenFields[0] == 5) {
      evCanvas.width = scrW;
      evCanvas.height = scrH * prev2  
    }
  } else {
    evCanvas.width = scrW;
    evCanvas.height = 0;//scrH * 0.02;  
  }
  
  if (ScreenFields[1] !== -1) {
    if (ScreenFields[1] == 0) {
      dvCanvas.width = scrW;
      dvCanvas.height = scrH * preva;  
    } else if (ScreenFields[1] == 1) {
      dvCanvas.width = scrW;
      dvCanvas.height = scrH * prdevices;  
      DeviceCanvasTop = +mnCanvas.height + +evCanvas.height;
    } else if (ScreenFields[1] == 2) {
      dvCanvas.width = scrW;
      dvCanvas.height = scrH * prtl; 
      TimelineCanvasTop = +mnCanvas.height + +evCanvas.height;
    } else if (ScreenFields[1] == 3) {
      dvCanvas.width = scrW;
      dvCanvas.height = scrH * pralltl;  
    } else if (ScreenFields[1] == 4) {
      dvCanvas.width = scrW;
      dvCanvas.height = scrH * prev1;  
    } else if (ScreenFields[1] == 5) {
      dvCanvas.width = scrW;
      dvCanvas.height = scrH * prev2  
    }
  } else {
    dvCanvas.width = scrW;
    dvCanvas.height = 0;//scrH * 0.02;  
  }
  
  if (ScreenFields[2] !== -1) {
    if (ScreenFields[2] == 0) {
      edCanvas.width = scrW;
      edCanvas.height = scrH * preva;  
    } else if (ScreenFields[2] == 1) {
      edCanvas.width = scrW;
      edCanvas.height = scrH * prdevices;
      DeviceCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height;
    } else if (ScreenFields[2] == 2) {
      edCanvas.width = scrW;
      edCanvas.height = scrH * prtl; 
      TimelineCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height;
    } else if (ScreenFields[2] == 3) {
      edCanvas.width = scrW;
      edCanvas.height = scrH * pralltl;  
    } else if (ScreenFields[2] == 4) {
      edCanvas.width = scrW;
      edCanvas.height = scrH * prev1;  
    } else if (ScreenFields[2] == 5) {
      edCanvas.width = scrW;
      edCanvas.height = scrH * prev2  
    }
  } else {
    edCanvas.width = scrW;
    edCanvas.height = 0;//scrH * 0.02;  
  }

  if (ScreenFields[3] !== -1) {
    if (ScreenFields[3] == 0) {
      tvCanvas.width = scrW;
      tvCanvas.height = scrH * preva;  
    } else if (ScreenFields[3] == 1) {
      tvCanvas.width = scrW;
      tvCanvas.height = scrH * prdevices;
      DeviceCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height
                        + +edCanvas.height;
    } else if (ScreenFields[3] == 2) {
      tvCanvas.width = scrW;
      tvCanvas.height = scrH * prtl;
      TimelineCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height
                        + +edCanvas.height;
    } else if (ScreenFields[3] == 3) {
      tvCanvas.width = scrW;
      tvCanvas.height = scrH * pralltl;  
    } else if (ScreenFields[3] == 4) {
      tvCanvas.width = scrW;
      tvCanvas.height = scrH * prev1;  
    } else if (ScreenFields[3] == 5) {
      tvCanvas.width = scrW;
      tvCanvas.height = scrH * prev2  
    }
  } else {
    tvCanvas.width = scrW;
    tvCanvas.height = 0;//scrH * 0.02;  
  }
  
  if (ScreenFields[4] !== -1) {
    if (ScreenFields[4] == 0) {
      tmCanvas.width = scrW;
      tmCanvas.height = scrH * preva;  
    } else if (ScreenFields[4] == 1) {
      tmCanvas.width = scrW;
      tmCanvas.height = scrH * prdevices;
      DeviceCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height
                        + +edCanvas.height + tvCanvas.height;
    } else if (ScreenFields[4] == 2) {
      tmCanvas.width = scrW;
      tmCanvas.height = scrH * prtl; 
      TimelineCanvasTop = +mnCanvas.height + +evCanvas.height + +dvCanvas.height
                        + +edCanvas.height + tvCanvas.height;
    } else if (ScreenFields[4] == 3) {
      tmCanvas.width = scrW;
      tmCanvas.height = scrH * pralltl;  
    } else if (ScreenFields[4] == 4) {
      tmCanvas.width = scrW;
      tmCanvas.height = scrH * prev1;  
    } else if (ScreenFields[4] == 5) {
      tmCanvas.width = scrW;
      tmCanvas.height = scrH * prev2  
    }
  } else {
    tmCanvas.width = scrW;
    tmCanvas.height = 0;//scrH * 0.02;  
  }
      
  mncv.clearRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.clearRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.clearRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.clearRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.clearRect(0, 0, tmCanvas.width, tmCanvas.height);
  mncv.fillStyle = ProgrammColor;//"black";
  ecv.fillStyle = "black";
  dcv.fillStyle = "black";
  edcv.fillStyle = "black";
  tlcv.fillStyle = "black";
  tmcv.fillStyle = "black";
  mncv.fillRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
  dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
  edcv.fillRect(0, 0, edCanvas.width, edCanvas.height);
  tlcv.fillRect(0, 0, tvCanvas.width, tvCanvas.height);
  tmcv.fillRect(0, 0, tmCanvas.width, tmCanvas.height);
   
        
  currtlo = TLO[ActiveTL];
  currtlt = TLT[ActiveTL];
  
  drawToolBar(mncv,mnCanvas.width, mnCanvas.height);
 
   if (ScreenFields[0] !== -1) {
    if (ScreenFields[0] == 0) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawEvents(ecv,evCanvas.width,evCanvas.height, false);
      }  
    } else if (ScreenFields[0] == 1) {
      if (typeof (currtlo) !== "undefined") {
        drawMyDev(ecv,evCanvas.width,evCanvas.height,currtlo);  
      }   
    } else if (ScreenFields[0] == 2) {
      if (typeof (currtlt) !== "undefined") {
        if (blshowtl) { DrawTimeLines(ecv,evCanvas.width,evCanvas.height); } 
        if (ShowNameTL) { DrawTimeLineNames(ecv,evCanvas.width,evCanvas.height); }  
      }  
    } else if (ScreenFields[0] == 3) {
      if (typeof (currtlt) !== "undefined") {
        if (ShowAllTimelines) { DrawAllTimelines(ecv, evCanvas.width, evCanvas.height); } 
      }  
    } else if (ScreenFields[0] == 4) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(ecv,evCanvas.width,evCanvas.height,0,false); 
      }   
    } else if (ScreenFields[0] == 5) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(ecv,evCanvas.width,evCanvas.height,1,false);
      }   
    }
  } else {
    ecv.fillStyle = "black";  
    ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);  
  }
  
  if (ScreenFields[1] !== -1) {
    if (ScreenFields[1] == 0) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawEvents(dcv,dvCanvas.width,dvCanvas.height,true);
      }  
    } else if (ScreenFields[1] == 1) {
      if (typeof (currtlo) !== "undefined") {
        drawMyDev(dcv,dvCanvas.width,dvCanvas.height,currtlo);  
      }   
    } else if (ScreenFields[1] == 2) {
      if (typeof (currtlt) !== "undefined") {
        if (blshowtl) { DrawTimeLines(dcv,dvCanvas.width,dvCanvas.height); } 
        if (ShowNameTL) { DrawTimeLineNames(dcv,dvCanvas.width,dvCanvas.height); }  
      }  
    } else if (ScreenFields[1] == 3) {
      if (typeof (currtlt) !== "undefined") {
        if (ShowAllTimelines) { DrawAllTimelines(dcv, dvCanvas.width, dvCanvas.height); } 
      }  
    } else if (ScreenFields[1] == 4) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(dcv,dvCanvas.width,dvCanvas.height,0,true); 
      }   
    } else if (ScreenFields[1] == 5) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(dcv,evCanvas.width,dvCanvas.height,1,true);
      }   
    }
  } else {
    dcv.fillStyle = "black";
    dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);  
  }
 
  if (ScreenFields[2] !== -1) {
    if (ScreenFields[2] == 0) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawEvents(edcv,edCanvas.width,edCanvas.height,true);
      }  
    } else if (ScreenFields[2] == 1) {
      if (typeof (currtlo) !== "undefined") {
        drawMyDev(edcv,edCanvas.width,edCanvas.height,currtlo);  
      }   
    } else if (ScreenFields[2] == 2) {
      if (typeof (currtlt) !== "undefined") {
        if (blshowtl) { DrawTimeLines(edcv,edCanvas.width,edCanvas.height); } 
        if (ShowNameTL) { DrawTimeLineNames(edcv,edCanvas.width,edCanvas.height); }  
      }  
    } else if (ScreenFields[2] == 3) {
      if (typeof (currtlt) !== "undefined") {
        if (ShowAllTimelines) { DrawAllTimelines(edcv, edCanvas.width, edCanvas.height); } 
      }  
    } else if (ScreenFields[2] == 4) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(edcv,edCanvas.width,edCanvas.height,0,true); 
      }   
    } else if (ScreenFields[2] == 5) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(edcv,edCanvas.width,edCanvas.height,1,true);
      }   
    }
  }else {
    edcv.fillStyle = "black";  
    edcv.fillRect(0, 0, edCanvas.width, edCanvas.height);  
  }  
  
  if (ScreenFields[3] !== -1) {
    if (ScreenFields[3] == 0) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawEvents(tlcv,tvCanvas.width,tvCanvas.height,true);
      }  
    } else if (ScreenFields[3] == 1) {
      if (typeof (currtlo) !== "undefined") {
        drawMyDev(tlcv,tvCanvas.width,tvCanvas.height,currtlo);  
      }   
    } else if (ScreenFields[3] == 2) {
      if (typeof (currtlt) !== "undefined") {
        if (blshowtl) { DrawTimeLines(tlcv,tvCanvas.width,tvCanvas.height); } 
        if (ShowNameTL) { DrawTimeLineNames(tlcv,tvCanvas.width,tvCanvas.height); }  
      }  
    } else if (ScreenFields[3] == 3) {
      if (typeof (currtlt) !== "undefined") {
        if (ShowAllTimelines) { DrawAllTimelines(tlcv, tvCanvas.width, tvCanvas.height); } 
      }  
    } else if (ScreenFields[3] == 4) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(tlcv,tvCanvas.width,tvCanvas.height,0,true); 
      }   
    } else if (ScreenFields[3] == 5) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(tlcv,tvCanvas.width,tvCanvas.height,1,true);
      }   
    }
  } else {
    tlcv.fillStyle = "black";  
    tlcv.fillRect(0, 0, tvCanvas.width, tvCanvas.height);  
  } 
  
  if (ScreenFields[4] !== -1) {
    if (ScreenFields[4] == 0) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawEvents(tmcv,tmCanvas.width,tmCanvas.height,true);
      }  
    } else if (ScreenFields[4] == 1) {
      if (typeof (currtlo) !== "undefined") {
        drawMyDev(tmcv,tmCanvas.width,tmCanvas.height,currtlo);  
      }   
    } else if (ScreenFields[4] == 2) {
      if (typeof (currtlt) !== "undefined") {
        if (blshowtl) { DrawTimeLines(tmcv,tmCanvas.width,tmCanvas.height); } 
        if (ShowNameTL) { DrawTimeLineNames(tmcv,tmCanvas.width,tmCanvas.height); }  
      }  
    } else if (ScreenFields[4] == 3) {
      if (typeof (currtlt) !== "undefined") {
        if (ShowAllTimelines) { DrawAllTimelines(tmcv, tmCanvas.width, tmCanvas.height); } 
      }  
    } else if (ScreenFields[4] == 4) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(tmcv,tmCanvas.width,tmCanvas.height,0,true); 
      }   
    } else if (ScreenFields[4] == 5) {
      if (typeof (currtlt) !== "undefined") {
        MyDrawDevEvents(tmcv,tmCanvas.width,tmCanvas.height,1,true);
      }   
    }
  } else {
    tmcv.fillStyle = "black";  
    tmcv.fillRect(0, 0, tmCanvas.width, tmCanvas.height);  
  }
  
  mnCanvas.style.visibility = "visible";
  //evCanvas.style.visibility = "visible"; 
  //dvCanvas.style.visibility = "visible"; 
  //edCanvas.style.visibility = "visible"; 
  //tvCanvas.style.visibility = "visible"; 
  //tmCanvas.style.visibility = "visible"; 
  
  //mnCanvas.style = "display : block;";
  //mnCanvas.style.visibility = "hidden";
  if (ScreenFields[0] == -1) {
    evCanvas.style = "display : none;";  
  } else {
    evCanvas.style = "display : block;"; 
    evCanvas.style.visibility = "visible";
  }
  
  if (ScreenFields[1] == -1) {
    dvCanvas.style = "display : none;";  
  } else {
    dvCanvas.style = "display : block;"; 
    dvCanvas.style.visibility = "visible";
  }
  
  if (ScreenFields[2] == -1) {
    edCanvas.style = "display : none;";  
  } else {
    edCanvas.style = "display : block;"; 
    edCanvas.style.visibility = "visible";
  }
  
  if (ScreenFields[3] == -1) {
    tvCanvas.style = "display : none;";  
  } else {
    tvCanvas.style = "display : block;"; 
    tvCanvas.style.visibility = "visible";
  }
  
  if (ScreenFields[4] == -1) {
    tmCanvas.style = "display : none;";  
  } else {
    tmCanvas.style = "display : block;"; 
    tmCanvas.style.visibility = "visible";
  }
 
      
} // end SetTypeScreen4
  
function screenNotEvents() {
    
  mnCanvas.style.visibility = "hidden";
  evCanvas.style.visibility = "hidden";
  dvCanvas.style.visibility = "hidden";
  edCanvas.style.visibility = "hidden";
  tvCanvas.style.visibility = "hidden";
  tmCanvas.style.visibility = "hidden";
    
    HeightMenu = (scrH / 100) * MenuProcent;
    var prmenu = HeightMenu / scrH;
    
    mnCanvas.width = scrW;
    mnCanvas.height = scrH * prmenu;
    evCanvas.width = scrW;
    evCanvas.height = scrH - mnCanvas.height;//* 0.90;
    dvCanvas.width = scrW;
    dvCanvas.height = 0;//scrH * 0.02;
    edCanvas.width = scrW;
    edCanvas.height = 0;//scrH * 0.02;
    tvCanvas.width = scrW;
    tvCanvas.height = 0;//scrH * 0.02;
    tmCanvas.width = scrW;
    tmCanvas.height = 0;//scrH * 0.02;
    
  mncv.clearRect(0, 0, mnCanvas.width, mnCanvas.height);  
  ecv.clearRect(0, 0,  evCanvas.width, evCanvas.height);

  mncv.fillStyle = ProgrammColor;
  ecv.fillStyle = ProgrammColor;

    mncv.fillRect(0, 0, mnCanvas.width, mnCanvas.height);
  ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
  
  drawToolBar(mncv,mnCanvas.width, mnCanvas.height);
  
  ecv.fillStyle = "white";
  ecv.font = mainFont;
  ecv.textAlign = "center";
  ecv.baseline = "middle";
  ecv.fillText("Отсутствуют данные", evCanvas.width / 2, evCanvas.height / 2); 
  
  mnCanvas.style.visibility = "visible";
  evCanvas.style.visibility = "visible";
  dvCanvas.style = "display : none;";
  edCanvas.style = "display : none;";
  tvCanvas.style = "display : none;";
  tmCanvas.style = "display : none;";
  
} //end function clearScreen

