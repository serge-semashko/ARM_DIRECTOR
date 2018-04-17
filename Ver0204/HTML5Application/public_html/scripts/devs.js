/* global dcv */

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
      cv.strokeRect(+rtleft, +rttop, +tmpw, +tmph);
      cv.fillRect(+rtleft + +2, +rttop + +2, +tmpw - +4, +tmph - +4);
      
      cv.font = smallFont;
      cv.fillStyle = cpen;
      cv.fillRect(+rtleft + +1, +rttop + +1, textWidth('00', cv) + 5, textHeight(cv) + 5);
      var message = (i+1).toString();
      //var ttop = rttop + textHeight(cv);
      cv.fillStyle = cfont;
      cv.textBaseline = "middle";
      cv.textAlign  = "center";
      cv.fillText(message, +rtleft+1+(textWidth('00', cv) + 5)/2, +rttop+1 + (textHeight(cv) + 5)/2);
      
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
        cv.strokeRect(+rtleft, +rttop, +tmpw, +tmph);
        cv.fillRect(+rtleft + +2, +rttop + +2, +tmpw - +4, +tmph - +4);
      
        cv.font = smallFont;
        cv.fillStyle = cpen;
        cv.fillRect(+rtleft + +1, +rttop + +1, textWidth('00', cv) + 5, textHeight(cv) + 5);
      //var 
        message = (17+i).toString();
      //var ttop = rttop + textHeight(cv);
        cv.fillStyle = cfont;
        cv.textBaseline = "middle";
        cv.textAlign  = "center";
        cv.fillText(message, +rtleft+1+(textWidth('00', cv) + 5)/2, +rttop+1 + (textHeight(cv) + 5)/2);
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
