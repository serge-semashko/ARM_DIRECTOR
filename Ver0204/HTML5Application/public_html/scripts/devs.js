/* global dcv */

function drawMyDev(currtl) {
    
    dcv.lineWidth = 4;
    dcv.textBaseline = "top";
    dcv.textAlign  = "left";
  var cntw1, cntw2, cnth, offsetw, offseth, interval;
  var wdth, hght, rtwidth, rtheight, rtleft, rttop;
  var tmph, tmpw, tmpw1;  
    
    hght = Number(dvCanvas.height);
    wdth = Number(dvCanvas.width);
    dcv.fillStyle = DevicesBKGN;
    dcv.fillRect(0,0,wdth,hght);
    
    WidthDevice = 80;
    IntervalDevice = 10;
    if (currtl.TypeTL == "0") {
        
      currtl.CountDev = Number(currtl.CountDev);
      tmph = (hght / 5) * 2;
      tmpw = tmph * 1.5;
      tmph = tmph.toFixed();
      tmpw = tmpw.toFixed();
      tmpw1 = tmpw * 19;
      if (tmpw1 > wdth) {
        tmpw = wdth / 19;
        tmph = tmpw / 1.5;
        tmph = tmph.toFixed();
        tmpw = tmpw.toFixed();
      }
      cntw1 = wdth / tmpw;
      cntw1 = cntw1.toFixed() - 3;
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
    interval = 10;
    offsetw = +LengthNameTL + +MyCursor - 2 * tmpw - interval;
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
      
      dcv.strokeStyle = cpen;
      dcv.fillStyle = ProgrammColor;
      if (i == CurrDevice-1) {
       dcv.fillStyle = "#FF0000";//ClrCurrEvent;   
      } //else {
      if (i == NextDevice-1) {
       dcv.fillStyle = "lime";//"#00FF00";  
      } 
      dcv.strokeRect(+rtleft, +rttop, +tmpw, +tmph);
      dcv.fillRect(+rtleft + +2, +rttop + +2, +tmpw - +4, +tmph - +4);
      
      dcv.font = smallFont;
      dcv.fillStyle = cpen;
      dcv.fillRect(+rtleft + +1, +rttop + +1, textWidth('00', dcv) + 5, textHeight(dcv) + 5);
      var message = (i+1).toString();
      //var ttop = rttop + textHeight(dcv);
      dcv.fillStyle = cfont;
      dcv.textBaseline = "middle";
      dcv.textAlign  = "center";
      dcv.fillText(message, +rtleft+1+(textWidth('00', dcv) + 5)/2, +rttop+1 + (textHeight(dcv) + 5)/2);
      
      var val1 = DevValue[i];
      if (val1 > -1) {
        //dcv.font = mainFont;
        var fs = Math.floor(tmph / 2);
        dcv.font = fs + "pt Arial";
        dcv.fillStyle = cfont;
        dcv.textBaseline = "middle";
        dcv.textAlign  = "center";
        dcv.fillText(val1.toString(), +rtleft+tmpw/2, +rttop+tmph/2);  
      }
      rtleft = +rtleft + +tmpw + +interval;        
    }
    
    
    if (cntw2 > 0) {
      rttop = +rttop + +interval + +tmph;
      rtleft = offsetw;
      for (var i = 0; i < cntw2; i++) {
        
        cpen = rgbFromNum(currtl.DevEvents[16+i].Color);
        
        cfont = ProgrammFontColor;
        dcv.strokeStyle = cpen;
        dcv.fillStyle = ProgrammColor;
        if (16 + i == CurrDevice-1) {
          dcv.fillStyle = "#FF0000";//ClrCurrEvent;   
        } //else {
        if (16 + i == NextDevice-1) {
          dcv.fillStyle = "lime";//"#00FF00";
        }
        dcv.strokeRect(+rtleft, +rttop, +tmpw, +tmph);
        dcv.fillRect(+rtleft + +2, +rttop + +2, +tmpw - +4, +tmph - +4);
      
        dcv.font = smallFont;
        dcv.fillStyle = cpen;
        dcv.fillRect(+rtleft + +1, +rttop + +1, textWidth('00', dcv) + 5, textHeight(dcv) + 5);
      //var 
        message = (17+i).toString();
      //var ttop = rttop + textHeight(dcv);
        dcv.fillStyle = cfont;
        dcv.textBaseline = "middle";
        dcv.textAlign  = "center";
        dcv.fillText(message, +rtleft+1+(textWidth('00', dcv) + 5)/2, +rttop+1 + (textHeight(dcv) + 5)/2);
        var val1 = DevValue[16+i];
        if (val1 > -1) {
          //dcv.font = mainFont;
          var fs = Math.floor(tmph / 2);
          dcv.font = fs + "pt Arial";
          dcv.fillStyle = cfont;
          dcv.textBaseline = "middle";
          dcv.textAlign  = "center";
          dcv.fillText(val1.toString(), +rtleft+tmpw/2, +rttop+tmph/2);  
        }
        rtleft = +rtleft + +tmpw + +interval;
      }    
    } 
    
    dcv.font = mainFont;

}
