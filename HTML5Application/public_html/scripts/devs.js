/* global dcv */

var DevRects = [];
DevRects[0] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[1] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[2] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[3] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[4] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[5] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[6] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[7] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[8] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[9] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[10] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[11] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[12] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[13] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[14] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[15] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[16] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[17] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[18] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[19] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[20] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[21] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[22] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[23] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[24] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[25] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[26] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[27] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[28] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[29] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[30] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
DevRects[31] = {
  left : 0,
  top : 0,
  right : 0,
  bottom : 0
};
  

function drawMyDev(cv,Width,Height,currtl) {
  //var srccolor = 0;  
  //var Background = rgbFromNum(srccolor);
  //var Foreground = smoothcolor(srccolor,8);
  //var Foreground1 = smoothcolor(srccolor,16);  
  cv.lineWidth = 4;
  cv.textBaseline = "top";
  cv.textAlign  = "left";
  var cntw1, cntw2, cnth, offsetw, offseth, interval;
  var wdth, hght, rtwidth, rtheight, rtleft, rttop;
  var tmph, tmpw, tmpw1;  
    
    hght = Height;
    wdth = Width;
    var tmpwdth = wdth - LengthNameTL - MyCursor;
    tempwidth = tmpwdth;
    cv.fillStyle = Foreground1;//DevicesBKGN;
    cv.fillRect(0,0,wdth,hght);
    
    WidthDevice = 80;
    IntervalDevice = 10;
    if (currtl.TypeTL == "0") {
        
      currtl.CountDev = Number(currtl.CountDev);
      tmph = (hght / 5) * 2;
      tmpw = tmph * 1.75;
      tmph = tmph.toFixed();
      tmpw = tmpw.toFixed();
      tmpw1 = tmpw * 14.5;
      if (tmpw1 > tmpwdth) {
        tmpw = tmpwdth / 14.5;
        tmph = tmpw / 1.75;
        tmph = tmph.toFixed();
        tmpw = tmpw.toFixed();
      }
      cntw1 = tmpwdth / tmpw + 2;
      cntw1 = Math.floor(cntw1) - 3;
      if (cntw1>=currtl.CountDev+2) {
        cntw1 = currtl.CountDev;
        cntw2 = 0;
        cnth = 1;
      } else {
         //tmpw = wdth / 19;
         //tmph = tmpw / 1.5;  
         //tmpw = tmpw.toFixed();
         //tmph = tmph.toFixed();
      
         if (currtl.CountDev <=  +16) {
           cntw1 = currtl.CountDev;
           cntw2 = +0;
           cnth = +1;
         } else {
           cntw1 = +16;
           cntw2 = currtl.CountDev - cntw1;
           cnth = +2;
         }
      }   
    }
    interval = tmpw / 100 * 10;
    if (interval<10) { interval = 10 }
    tmpw = tmpw - interval;
    
    if (tmpwdth > 14 * (tmpw + interval)) {
      offsetw = +LengthNameTL + +MyCursor - 2 * tmpw - interval;
    } else {
      offsetw = +LengthNameTL + +MyCursor - 3 * tmpw - 2 * interval;  
    }
    if (cnth !== 2) {
      offseth = (hght - tmph) / 2;
    } else {
      offseth = (hght - 2 * tmph - interval) / 2;  
    }
    offseth = offseth.toFixed();
    
    rtleft = offsetw;
    rttop = offseth;
    
    IntervalDevice = interval;
    WidthDevice = tmpw;
    //var devnm;
    
    for (var i = 0; i < cntw1; i++) {

      var cpen = rgbFromNum(currtl.DevEvents[i].Color);
      
      cv.strokeStyle = cpen;
      cv.fillStyle = Foreground1;//ProgrammColor;
      if (i == CurrDevice-1) {
       cv.fillStyle = "#FF0000";//ClrCurrEvent;   
      } //else {
      if (i == NextDevice-1) {
       cv.fillStyle = "lime";//"#00FF00";  
      } 
      DevRects[i].left = +rtleft;
      DevRects[i].top = +rttop;
      DevRects[i].right = +rtleft + +tmpw;
      DevRects[i].bottom = +rttop + +tmph;
      cv.strokeRect(+rtleft, +rttop, +tmpw, +tmph);
      cv.fillRect(+rtleft + +2, +rttop + +2, +tmpw - +4, +tmph - +4);
      
      cv.font = Math.floor(tmph/5) + "pt Arial";//smallFont;
      cv.fillStyle = cpen;
      cv.fillRect(+rtleft, +rttop, +textWidth('00', cv) + 1, +textHeight(cv) + 1);
      var message = (i+1).toString();
      cv.fillStyle = cfont;
      cv.textBaseline = "middle";
      cv.textAlign  = "center";
      cv.fillText(message, +rtleft + +(textWidth('00', cv))/2, +rttop + +textHeight(cv)/2);
      
      var val1 = DevValue[i];
      if (val1 > -1) {
        //cv.font = mainFont;
        var fs = Math.floor(tmph / 2);
        cv.font = fs + "pt Arial";
        cv.fillStyle = cfont;
        cv.textBaseline = "middle";
        cv.textAlign  = "center";
        cv.fillText(val1.toString(), +rtleft+tmpw/2, +rttop+tmph/2);  
      }
      rtleft = +rtleft + +tmpw + +interval;        
    }
    
    
    if (cntw2 > 0) {
      rttop = +rttop + +interval + +tmph;
      rtleft = offsetw;
      for (var i = 0; i < cntw2; i++) {
        
        cpen = rgbFromNum(currtl.DevEvents[16+i].Color);
        
        cfont = ProgrammFontColor;
        cv.strokeStyle = cpen;
        cv.fillStyle = Foreground1;//ProgrammColor;
        if (16 + i == CurrDevice-1) {
          cv.fillStyle = "#FF0000";//ClrCurrEvent;   
        } //else {
        if (16 + i == NextDevice-1) {
          cv.fillStyle = "lime";//"#00FF00";
        }
        
        DevRects[16+i].left = +rtleft;
        DevRects[16+i].top = +rttop;
        DevRects[16+i].right = +rtleft + +tmpw;
        DevRects[16+i].bottom = +rttop + +tmph;
        cv.strokeRect(+rtleft, +rttop, +tmpw, +tmph);
        cv.fillRect(+rtleft + +2, +rttop + +2, +tmpw - +4, +tmph - +4);
      
        cv.font = Math.floor(tmph/5) + "pt Arial";//smallFont;
        cv.fillStyle = cpen;
        cv.fillRect(+rtleft, +rttop, textWidth('00', cv) + 1, textHeight(cv) + 1);
      //var 
        message = (17+i).toString();
      //var ttop = rttop + textHeight(cv);
        cv.fillStyle = cfont;
        cv.textBaseline = "middle";
        cv.textAlign  = "center";
        cv.fillText(message, +rtleft + +(textWidth('00', cv))/2, +rttop + +textHeight(cv)/2);
        var val1 = DevValue[16+i];
        if (val1 > -1) {
          //cv.font = mainFont;
          var fs = Math.floor(tmph / 2);
          cv.font = fs + "pt Arial";
          cv.fillStyle = cfont;
          cv.textBaseline = "middle";
          cv.textAlign  = "center";
          cv.fillText(val1.toString(), +rtleft+tmpw/2, +rttop+tmph/2);  
        }
        rtleft = +rtleft + +tmpw + +interval;
      }    
    } 
    
    cv.font = mainFont;

}

function ChoiceDevRect(X,Y) {
  var res = -1;  
  var isdev = false;
  if (typesrc < 4) { 
    if (ShowDevices) { isdev = true; };  
  };
  if (typesrc == 4) {
    if (isField(1)) { isdev = true; };  
  }
  if (isdev) {
    if (TLO[ActiveTL].TypeTL !== "0") { return res; };
    for (var i=0; i<TLO[ActiveTL].CountDev; i++) {
      if (X>DevRects[i].left && X < DevRects[i].right
          && Y > +DeviceCanvasTop + + DevRects[i].top 
          && Y < +DeviceCanvasTop + + DevRects[i].bottom) {
         res = i;
         break;
      }  
    }
  }
  return res;
}