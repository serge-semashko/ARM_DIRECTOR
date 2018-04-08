"use strict";

function MyDrawEvents(cv, Width, Height) {
  var srccolor = 0;  
  var Background = rgbFromNum(srccolor);
  var Foreground = smoothcolor(srccolor,16);
  var LeftTxt = +LengthNameTL + +MyCursor;
  var LeftSec = LeftTxt - WidthDevice - IntervalDevice;
  var LeftDev = LeftSec - WidthDevice;
  //var LeftNum = LeftDev - WidthDevice - IntervalDevice;
  var ScreenFrm = Math.floor((Width - LeftTxt)/FrameSize);
  var ScreenSec = Math.floor(ScreenFrm / 25);
  cv.fillStyle = Background;
  cv.fillRect(0,0,Width,Height);
  var tmph = Height / (+CountEvents + 1);
  var interval = (tmph / 100) * 10;
  tmph = tmph - interval;
  var top = interval;
  cv.fillStyle = Foreground;
  for (var i=0; i<=CountEvents + 1; i++) {
    cv.fillRect(0,top,Width,tmph);
    top = +top + (+tmph + +interval);
  }
  
  var tptl = TLT[ActiveTL].TypeTL;
  var LastEvent, strtev, fnshev;
  var step = 25 * FrameSize;
  var evColor, evFontName, evSafeZone, evmix, evmixdur, evtext, evdevice;
  var evcomment, wdthev, evdur, tmpdur;
          
  if (+tptl == 0) {
    if (TLT[ActiveTL].Count > 0) {
      LastEvent = CurrEvent + CountEvents;
      if (LastEvent > TLT[ActiveTL].Count-1) {
        LastEvent = TLT[ActiveTL].Count-1;  
      }
      top = interval;
      
      evColor = rgbFromNum(TLT[ActiveTL].Events[CurrEvent].Color);
      evFontName = TLT[ActiveTL].Events[CurrEvent].FontName;
      evSafeZone = TLT[ActiveTL].Events[CurrEvent].SafeZone;;  
      evmix = TLT[ActiveTL].Events[CurrEvent].Rows[1].Phrases[0].Text;
      evmixdur = TLT[ActiveTL].Events[CurrEvent].Rows[1].Phrases[1].Data;
      evtext = TLT[ActiveTL].Events[CurrEvent].Rows[0].Phrases[1].Text;
      evdevice = TLT[ActiveTL].Events[CurrEvent].Rows[0].Phrases[0].Data;
      evcomment = TLT[ActiveTL].Events[CurrEvent].Rows[3].Phrases[0].Text;
      if (evcomment.charAt(0) == "#") {
        evtext = evcomment;  
      }
      if (evmixdur == "") {
        evmixdur = 0;  
      }
      strtev = (TLT[ActiveTL].Events[CurrEvent].Start - TLP.Position) * FrameSize;
      evdur = TLT[ActiveTL].Events[CurrEvent].Finish - TLP.Position;
      fnshev = (TLT[ActiveTL].Events[CurrEvent].Finish - TLP.Position) * FrameSize;
       
      wdthev = fnshev - strtev;
       
      evmixdur = evmixdur * FrameSize;
        
      if (wdthev < evmixdur) {
        evmixdur = wdthev;
      }

      cv.fillStyle = smoothcolor(srccolor,80);
      cv.fillRect(LeftTxt + strtev,  top, fnshev-strtev, tmph);
      
      if (evmix == "Mix" || evmix == "Wipe") {
        cv.beginPath();  
        cv.moveTo(+LeftTxt + strtev, top);  
        cv.lineTo(+LeftTxt + strtev, top + tmph);
        cv.lineTo(+LeftTxt + strtev + evmixdur, top + tmph);
        cv.lineTo(+LeftTxt + strtev, top);
        cv.lineWidth = 1;
        cv.fillStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
        cv.strokeStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
        cv.stroke();
        //edcv.fill;
        cv.closePath(); 
        cv.fill();
        cv.globalAlpha = 1;
      }  
      
      var fs = Math.floor(tmph / 2);
      if (fs>MaxFontSize) {
        fs = MaxFontSize;  
      }
      cv.font = fs + "pt Arial";
      
      if (evtext.charAt(0) == "#") {
        cv.fillStyle = "yellow";  
      } else { 
        cv.fillStyle = cfont;
      }
      cv.textBaseline = "middle"; 
      cv.textAlign  = "left";
      cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 
      
      cv.fillStyle = Foreground;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.fillStyle = cfont;
      evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[CurrEvent].Finish);//FramesToShortString(evdur);
      evtext = SecondsToString(evtext);
      cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
      
      cv.fillStyle = evColor;
      cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
      cv.fillStyle = cfont;
      cv.textAlign  = "center";
      cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
      
      cv.textAlign  = "right";
      cv.fillText(CurrEvent + EventOffset, +LeftDev - 10, +top + +tmph / 2);
      
      if (TLT[ActiveTL].Events[CurrEvent].Start <= TLP.Position &&
          +TLT[ActiveTL].Events[CurrEvent].Start + +evSafeZone >= TLP.Position) {
        cv.fillStyle = "rgba(255,255,255,.65)";
        tmpdur = +fnshev - strtev - 1;//LeftTxt + +TLP.Start;
        if (tmpdur < 0) {
          tmpdur = 0;  
        }
        cv.fillRect(+LeftTxt + 1,  top, tmpdur + strtev, tmph);
        cv.globalAlpha = 1;
      }  
      
      top = top + tmph + interval;
      cv.fillStyle = "white";
      cv.fillRect(LeftTxt + strtev,  top+0.5, fnshev-strtev, tmph-1);
      
      if (evmix == "Mix" || evmix == "Wipe") {
        cv.beginPath();  
        cv.moveTo(+LeftTxt + strtev, top + tmph-1);  
        cv.lineTo(+LeftTxt + strtev, top+0.5);
        cv.lineTo(+LeftTxt + strtev + evmixdur, top+0.5);
        cv.lineTo(+LeftTxt + strtev, top + tmph-1);
        cv.lineWidth = 1;
        cv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        cv.strokeStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        cv.stroke();
        //edcv.fill;
        cv.closePath(); 
        cv.fill();
        cv.globalAlpha = 1;
      }
      
      cv.fillStyle = Foreground;
      for (var ic=0; ic<=ScreenSec; ic++) {
        cv.beginPath();  
        cv.moveTo(+LeftTxt + ic * step, +top);  
        cv.lineTo(+LeftTxt + ic * step, +top + +tmph);
        cv.lineWidth = 1;
        cv.strokeStyle = Foreground;
        cv.stroke();
        cv.closePath();  
      }
      cv.fillStyle = Foreground;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.textAlign  = "left";
      cv.fillStyle = cfont;
      evtext = FramesToShortString(TLP.Position - TLP.Start);
      cv.fillText(evtext, +LeftDev - 10, +top + +tmph / 2);
      
      top = top + tmph + interval;
      
      for (var i=CurrEvent + 1; i<=LastEvent; i++) {
//==============================================================================          
        evColor = rgbFromNum(TLT[ActiveTL].Events[i].Color);
        evFontName = TLT[ActiveTL].Events[i].FontName;
        evSafeZone = TLT[ActiveTL].Events[i].SafeZone;;  
        evmix = TLT[ActiveTL].Events[i].Rows[1].Phrases[0].Text;
        evmixdur = TLT[ActiveTL].Events[i].Rows[1].Phrases[1].Data;
        evtext = TLT[ActiveTL].Events[i].Rows[0].Phrases[1].Text;
        evdevice = TLT[ActiveTL].Events[i].Rows[0].Phrases[0].Data;
        evcomment = TLT[ActiveTL].Events[i].Rows[3].Phrases[0].Text;
        if (evcomment.charAt(0) == "#") {
          evtext = evcomment;  
        }
        if (evmixdur == "") {
          evmixdur = 0;  
        }
        strtev = (TLT[ActiveTL].Events[i].Start - TLP.Position) * FrameSize;
        evdur = TLT[ActiveTL].Events[i].Finish - TLP.Position;
        fnshev = (TLT[ActiveTL].Events[i].Finish - TLP.Position) * FrameSize;
       
        wdthev = fnshev - strtev;
       
        evmixdur = evmixdur * FrameSize;
        
        if (wdthev < evmixdur) {
          evmixdur = wdthev;
        }

        cv.fillStyle = smoothcolor(srccolor,80);
        cv.fillRect(LeftTxt + strtev,  top, fnshev-strtev, tmph);
      
        if (evmix == "Mix" || evmix == "Wipe") {
          cv.beginPath();  
          cv.moveTo(+LeftTxt + strtev, top + tmph);  
          cv.lineTo(+LeftTxt + strtev, top);
          cv.lineTo(+LeftTxt + strtev + evmixdur, top);
          cv.lineTo(+LeftTxt + strtev, top + tmph);
          cv.lineWidth = 1;
          cv.fillStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          cv.strokeStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          cv.stroke();
          //edcv.fill;
          cv.closePath(); 
          cv.fill();
          cv.globalAlpha = 1;
        }  
      
        var fs = Math.floor(tmph / 2);
        if (fs>MaxFontSize) {
          fs = MaxFontSize;  
        }
        cv.font = fs + "pt Arial";
        
        if (evtext.charAt(0) == "#") {
          cv.fillStyle = "yellow";  
        } else { 
          cv.fillStyle = cfont;
        }
        cv.textBaseline = "middle"; 
        cv.textAlign  = "left";
        cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 
      
        cv.fillStyle = Foreground;
        cv.fillRect(0, +top, +LeftTxt, +tmph);
        cv.fillStyle = cfont;
        evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[i].Finish);
        evtext = SecondsToString(evtext);
        cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
      
        cv.fillStyle = evColor;
        cv.fillRect(+LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph);
        cv.fillStyle = cfont;
        cv.textAlign  = "center";
        cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
      
        cv.textAlign  = "right";
        cv.fillText(i + EventOffset, +LeftDev - 10, +top + +tmph / 2);
      
//        if (TLT[ActiveTL].Events[i].Start <= TLP.Position &&
//            +TLT[ActiveTL].Events[i].Start + +evSafeZone >= TLP.Position) {
//          cv.fillStyle = "rgba(255,255,255,.65)";
//          cv.fillRect(LeftTxt + strtev,  top, fnshev-strtev, tmph);
//          cv.globalAlpha = 1;
//        }  
      
        top = top - tmph - interval;
              
        if (evmix == "Mix" || evmix == "Wipe") {
          cv.beginPath();  
          cv.moveTo(+LeftTxt + strtev, top);  
          cv.lineTo(+LeftTxt + strtev, top + tmph);
          cv.lineTo(+LeftTxt + strtev + evmixdur, top + tmph);
          cv.lineTo(+LeftTxt + strtev, top);
          cv.lineWidth = 1;
          cv.fillStyle = "rgba(255,255,255,.65)";//evsmoothcolor;
          cv.strokeStyle = "rgba(255,255,255,.65)";//evsmoothcolor;
          cv.stroke();
          //edcv.fill;
          cv.closePath(); 
          cv.fill();
          cv.globalAlpha = 1;
        }
        if (i == CurrEvent+1) { 
          cv.fillStyle = Foreground;
          for (var ic=0; ic<=ScreenSec; ic++) {
            cv.beginPath();  
            cv.moveTo(+LeftTxt + ic * step, +top);  
            cv.lineTo(+LeftTxt + ic * step, +top + +tmph);
            cv.lineWidth = 1;
            cv.strokeStyle = Foreground;
            cv.stroke();
            cv.closePath();  
          }
        }

        top = top + 2*(tmph + interval);
//==============================================================================                
      }
    }     
  } else if (+tptl == 1) {
    var FinishFrm = TLP.Position + ScreenFrm;  
    var fev, sev;
    if (TLT[ActiveTL].Count > 0) {
      fev = -1;
      sev = 0;
      for (var i=0; i<TLT[ActiveTL].Count-1; i++) {
        if (TLT[ActiveTL].Events[i].Finish > TLP.Position){
          sev = i;
          break;
        }  
      }  
      fev = sev + CountEvents;
      if (fev > TLT[ActiveTL].Count-1) {
        fev = TLT[ActiveTL].Count-1  
      }
            
      top = interval;
//=============================================================================      
      evColor = rgbFromNum(TLT[ActiveTL].Events[sev].Color);
      evFontName = TLT[ActiveTL].Events[sev].FontName;
      evSafeZone = TLT[ActiveTL].Events[sev].SafeZone;;  

      evtext = TLT[ActiveTL].Events[sev].Rows[0].Phrases[0].Text;
      evdevice = TLT[ActiveTL].Events[sev].Rows[0].Phrases[0].Data;
      evcomment = TLT[ActiveTL].Events[sev].Rows[2].Phrases[0].Text;
      if (evcomment.charAt(0) == "#") {
        evtext = evcomment;  
      }

      strtev = (TLT[ActiveTL].Events[sev].Start - TLP.Position) * FrameSize;
      evdur = TLT[ActiveTL].Events[sev].Finish - TLP.Position;
      fnshev = (TLT[ActiveTL].Events[sev].Finish - TLP.Position) * FrameSize;
       
      wdthev = fnshev - strtev;

      cv.fillStyle = smoothcolor(srccolor,80);
      cv.fillRect(LeftTxt + strtev,  top, fnshev-strtev, tmph);
 
      var fs = Math.floor(tmph / 2);
      if (fs>MaxFontSize) {
        fs = MaxFontSize;  
      }
      cv.font = fs + "pt Arial";
      
      if (evtext.charAt(0) == "#") {
        cv.fillStyle = "yellow";  
      } else { 
        cv.fillStyle = cfont;
      }
      cv.textBaseline = "middle"; 
      cv.textAlign  = "left";
      cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 
      
      cv.fillStyle = Foreground;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.fillStyle = cfont;
      if ((TLT[ActiveTL].Events[sev].Start <= TLP.Position &&
              +TLT[ActiveTL].Events[sev].Finish >= TLP.Position) ) {
        evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev].Finish);
        evtext = SecondsToString(evtext);
      } else {
        if (sev < TLT[ActiveTL].Count) {
          if (sev == TLT[ActiveTL].Count1) {
            evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev].Start);
            evtext = SecondsToString(evtext);  
          } else {
            evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev+1].Start);//FramesToShortString(evdur);
            evtext = SecondsToString(evtext);  
          }  
        } else {
          evtext = ""; 
        }
      }
      
      if (typeof WidthDevice == "undefined") {
        WidthDevice = LeftTxt / 3.5;   
      }
      
      LeftSec = LeftTxt - + WidthDevice - +IntervalDevice;
      LeftDev = LeftSec - + WidthDevice;
      cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
      
      //cv.fillStyle = evColor;
      //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
      //cv.fillStyle = cfont;
      //cv.textAlign  = "center";
      //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
      
      cv.textAlign  = "right";
      cv.fillText(sev + EventOffset, +LeftDev - 10, +top + +tmph / 2);
      
      if (TLT[ActiveTL].Events[sev].Start <= TLP.Position &&
          +TLT[ActiveTL].Events[sev].Start + +evSafeZone >= TLP.Position) {
        cv.fillStyle = "rgba(255,255,255,.65)";
        tmpdur = +fnshev - strtev - 1;//LeftTxt + +TLP.Start;
        if (tmpdur < 0) {
          tmpdur = 0;  
        }
        cv.fillRect(+LeftTxt + 1,  top, tmpdur + strtev, tmph);
        cv.globalAlpha = 1;
      }  
      
      top = top + tmph + interval;
      cv.fillStyle = "white";
      cv.fillRect(LeftTxt + strtev,  top+0.5, fnshev-strtev, tmph-1);
         
      cv.fillStyle = Foreground;
      for (var ic=0; ic<=ScreenSec; ic++) {
        cv.beginPath();  
        cv.moveTo(+LeftTxt + ic * step, +top);  
        cv.lineTo(+LeftTxt + ic * step, +top + +tmph);
        cv.lineWidth = 1;
        cv.strokeStyle = Foreground;
        cv.stroke();
        cv.closePath();  
      }
      cv.fillStyle = Foreground;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.textAlign  = "left";
      cv.fillStyle = cfont;
      evtext = FramesToShortString(TLP.Position - TLP.Start);
      cv.fillText(evtext, +LeftDev - 10, +top + +tmph / 2);
      
      top = top + tmph + interval;
 //=============================================================================
      
      for (var i=sev+1; i<=fev; i++) {
//=============================================================================      
        evColor = rgbFromNum(TLT[ActiveTL].Events[i].Color);
        evFontName = TLT[ActiveTL].Events[i].FontName;
        evSafeZone = TLT[ActiveTL].Events[i].SafeZone;;  

        evtext = TLT[ActiveTL].Events[i].Rows[0].Phrases[0].Text;
        evdevice = TLT[ActiveTL].Events[i].Rows[0].Phrases[0].Data;
        evcomment = TLT[ActiveTL].Events[i].Rows[2].Phrases[0].Text;
        if (evcomment.charAt(0) == "#") {
          evtext = evcomment;  
        }
 
        strtev = (TLT[ActiveTL].Events[i].Start - TLP.Position) * FrameSize;
        evdur = TLT[ActiveTL].Events[i].Finish - TLP.Position;
        fnshev = (TLT[ActiveTL].Events[i].Finish - TLP.Position) * FrameSize;
       
        wdthev = fnshev - strtev;

        cv.fillStyle = smoothcolor(srccolor,80);
        cv.fillRect(LeftTxt + strtev,  top, fnshev-strtev, tmph);
 
        var fs = Math.floor(tmph / 2);
        if (fs>MaxFontSize) {
          fs = MaxFontSize;  
        }
        cv.font = fs + "pt Arial";
      
        if (evtext.charAt(0) == "#") {
          cv.fillStyle = "yellow";  
        } else { 
          cv.fillStyle = cfont;
        }
        cv.textBaseline = "middle"; 
        cv.textAlign  = "left";
        cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 
      
        cv.fillStyle = Foreground;
        cv.fillRect(0, +top, +LeftTxt, +tmph);
        cv.fillStyle = cfont;
        if ((TLT[ActiveTL].Events[i].Start <= TLP.Position &&
                +TLT[ActiveTL].Events[i].Finish >= TLP.Position) ) {
          evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[i].Finish);
          evtext = SecondsToString(evtext);
        } else {
          if (i < TLT[ActiveTL].Count) {
            if (i == TLT[ActiveTL].Count1) {
              evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[i].Start);
              evtext = SecondsToString(evtext);  
            } else {
              evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[i].Start);//FramesToShortString(evdur);
              evtext = SecondsToString(evtext);  
            }  
          } else {
            evtext = ""; 
          }
        }
      
        if (typeof WidthDevice == "undefined") {
          WidthDevice = LeftTxt / 3.5;   
        }
      
        LeftSec = LeftTxt - + WidthDevice - +IntervalDevice;
        LeftDev = LeftSec - + WidthDevice;
        cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
      
        cv.textAlign  = "right";
        cv.fillText(i + EventOffset, +LeftDev - 10, +top + +tmph / 2);
            
        top = top + tmph + interval;
 //=============================================================================          
      }
      
    }  
  } else if (+tptl == 2) {
      
  }
  
}
