"use strict";

function MyDrawEvents(cv, Width, Height, menu) {

  var LeftTxt = +LengthNameTL + +MyCursor;
  var LeftSec = LeftTxt - WidthDevice - IntervalDevice;
  var LeftDev = LeftSec - WidthDevice;
  if (DoubleSize==1)  {
    LeftDev = 2 * (WidthDevice + 1.5 * IntervalDevice);
    LeftSec = LeftDev + 2 * WidthDevice + IntervalDevice;
    LeftTxt = LeftSec + 2 * (WidthDevice + IntervalDevice);
    if (ShowNameTL) {
      LengthNameTL = LeftSec;
      MyCursor = LeftTxt - LengthNameTL;  
    } else {
      LengthNameTL = 0;
      MyCursor = LeftTxt;
   }  
  } 
  
  
  var ScreenFrm = Math.floor((Width - LeftTxt)/FrameSize);
  var ScreenSec = Math.floor(ScreenFrm / 25);
  var Delta = 50; 
  cv.lineWidth = 1;
  cv.fillStyle = Background;
  cv.fillRect(0,0,Width,Height);
  var tmph;// = Height / (+CountEvents + 1);
  if (menu) {
    tmph = (Height - HeightMenu/3) / (+CountEvents + 1);
  } else {
    tmph = Height / (+CountEvents + 1);  
  }
  
  var interval = (tmph / 100) * 10;
  tmph = tmph - interval;
  var top = interval;
  if (menu) {
    cv.fillStyle = ProgrammColor;
    cv.fillRect(0,0,Width,HeightMenu/3);
    top = top + HeightMenu/3;      
  }
  
  cv.fillStyle = Foreground;
  for (var i=0; i<=CountEvents + 1; i++) {
    cv.fillRect(0,top,Width,tmph);
    top = +top + (+tmph + +interval);
  }
  
  var fs = Math.floor(tmph / 2);
    if (fs>MaxFontSize) {
      fs = MaxFontSize;  
    }
  cv.font = fs + "pt Arial";

//  if (DoubleSize==1)  {
//    LeftDev = 2 * (WidthDevice + 1.5 * IntervalDevice);
//    LeftSec = LeftDev + 2 * WidthDevice + IntervalDevice;
//    LeftTxt = LeftSec + 2 * (WidthDevice + IntervalDevice);
//    LengthNameTL = LeftSec;
//    MyCursor = LeftTxt - LengthNameTL;
//    ScreenFrm = Math.floor((Width - LeftTxt)/FrameSize);
//    ScreenSec = Math.floor(ScreenFrm / 25);  
//  } 
  
  var tptl = TLT[ActiveTL].TypeTL;
  var LastEvent, strtev, fnshev;
  var step = 25 * FrameSize;
  var evColor, evFontName, evSafeZone, evmix, evmixdur, evtext, evdevice;
  var evcomment, wdthev, evdur, tmpdur, phrstr, phrrate, phrdur, phrsec;
          
  if (+tptl == 0) {
    if (TLT[ActiveTL].Count > 0) {
      LastEvent = CurrEvent + CountEvents;
      if (LastEvent > TLT[ActiveTL].Count-1) {
        LastEvent = TLT[ActiveTL].Count-1;  
      }
      top = interval;
      if (menu) {
        top = top + HeightMenu/3;      
      }
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
      
    //  var fs = Math.floor(tmph / 2);
    //  if (fs>MaxFontSize) {
    //    fs = MaxFontSize;  
    //  }
    //  cv.font = fs + "pt Arial";
      
      if (evtext.charAt(0) == "#") {
        cv.fillStyle = "yellow";  
      } else { 
        cv.fillStyle = cfont;
      }
      cv.textBaseline = "middle"; 
      cv.textAlign  = "left";
      
      var lentxt = cv.measureText(evtext).width;
      if (lentxt < Width - LeftTxt) {
        cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 
      } else {
        myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt, top, tmph);
      }
      cv.fillStyle = Foreground1;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.fillStyle = "red";//cfont;
      phrsec = GetSeconds(TLP.Position, TLT[ActiveTL].Events[CurrEvent].Finish);//FramesToShortString(evdur);
      evtext = SecondsToString(phrsec);
      lentxt = cv.measureText(evtext).width;
      if (lentxt < LeftTxt - LeftSec - 10) {
        cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
      } else {
        myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec-10, top, tmph);
      }
//==============================================================================      
       // if (i == CurrEvent+1) {
          //phrsec = Math.floor((TLT[ActiveTL].Events[i].Start - TLP.Position) / 25);
          phrdur = TLT[ActiveTL].Events[CurrEvent].Finish - TLT[ActiveTL].Events[CurrEvent].Start;
          var phrsub = TLT[ActiveTL].Events[CurrEvent].Finish - TLP.Position;
          var kadr = CurrEvent + EventOffset + 2;
          if (CurrEvent < TLT[ActiveTL].Count-1) {
            var kamera = TLT[ActiveTL].Events[CurrEvent+1].Rows[0].Phrases[0].Data;
            if (phrdur<Delta) {
              PhraseFactor = phrdur / Delta;
              Phrase = Phrase = "Кадр " + kadr + " Камера " + kamera + " " + phrsec + " секунд";
            } else {
              PhraseFactor = 1;  
              if (TLP.Position >= TLT[ActiveTL].Events[CurrEvent].Start &&
                  TLP.Position <= TLT[ActiveTL].Events[CurrEvent].Start + evSafeZone) {
                StepPhrase = +TLT[ActiveTL].Events[CurrEvent].Start + 50;
                Phrase = "Кадр " + kadr + " Камера " + kamera + " " + phrsec + " секунд";
              } 
              if (StepPhrase - 25 <= TLP.Position && StepPhrase > TLP.Position) {
                Phrase = "";
              } 
              if ( TLP.Position >= StepPhrase) { 
                    
                if (phrsub > 150 ) {
                  if (phrsub % 125 == 0) {
                    Phrase = "Кадр " + kadr + " Камера " + kamera + " " + phrsec + " секунд"; 
                    StepPhrase = +TLP.Position + 50;
                  }                
                } else {
                  Phrase = phrsec;  
                } 
                  
              }
            }
          }
          if (menu) {
            cv.textAlign  = "left";  
            cv.fillText(Phrase, 50, HeightMenu / 6);
            //cv.fillText(Phrase + "  :" + pss + " == " + psstr, 50, HeightMenu / 2);  
          }
       // }
//==============================================================================      
      cv.fillStyle = evColor;
      rectRound(cv, LeftDev-1, top, LeftSec - LeftDev + 2, +tmph, 5, evColor, evColor);
      //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
      cv.fillStyle = cfont;
      //cv.textAlign  = "center";
      lentxt = cv.measureText(evdevice).width;
      if (lentxt < LeftSec-LeftDev) {
        cv.textAlign  = "center";  
        cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);   
      } else {
        cv.textAlign  = "left";  
        myTextDraw(cv, evdevice, LeftDev+interval, 0, LeftSec-LeftDev, top, tmph);
      }      
      
      //cv.textAlign  = "right";
      var evps = +CurrEvent + +EventOffset + 1;
      lentxt = cv.measureText(evps).width;
      if (lentxt < LeftDev-10) {
        cv.textAlign  = "right";  
        cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);  
      } else {
        cv.textAlign  = "left";  
        myTextDraw(cv, evps, 0, 10, LeftDev-10, top, tmph);
      }
      
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
      cv.fillStyle = Foreground1;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.textAlign  = "left";
      cv.fillStyle = cfont;
      evtext = FramesToShortString(TLP.Position - TLP.Start);
      
      //lentxt = cv.measureText(evtext).width;
      lentxt = cv.measureText("00:00:00").width;
      var offx = Math.floor((LeftTxt-lentxt) / 20) * 10;
      if (lentxt < LeftTxt-20) {
        cv.fillText(evtext, offx , +top + +tmph / 2);  
        //cv.fillText(evtext, (LeftTxt - lentxt-10) / 2, +top + +tmph / 2);
      } else {
        myTextDraw(cv, evtext, 0, 10, LeftTxt-20, top, tmph);
      }
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
        lentxt = cv.measureText(evtext).width;
        if (lentxt <= Width - LeftTxt-10) {
          cv.fillText(evtext, +LeftTxt, +top + +tmph / 2);
        } else {
          myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt-10, top, tmph);
        } 
        cv.fillStyle = Foreground1;
        cv.fillRect(0, +top, +LeftTxt, +tmph);
        cv.fillStyle = cfont;
        //evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[i].Start);
        //evtext = SecondsToString(evtext);
        phrsec = GetSeconds(TLP.Position, TLT[ActiveTL].Events[i].Start);
        evtext = SecondsToString(phrsec);
        //cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
        lentxt = cv.measureText(evtext).width;
        if (lentxt < LeftTxt - LeftSec - 10) {
          cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
        } else {
          myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec-10, top, tmph);
        }
        
        cv.fillStyle = evColor;
        rectRound(cv, LeftDev-1, top, LeftSec - LeftDev + 2, +tmph, 5, evColor, evColor);
        //cv.fillRect(+LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph);
        cv.fillStyle = cfont;
        //cv.textAlign  = "center";
        //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
        lentxt = cv.measureText(evdevice).width;
        if (lentxt < LeftSec-LeftDev) {
          cv.textAlign  = "center";  
          cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);   
        } else {
          cv.textAlign  = "left";  
          myTextDraw(cv, evdevice, LeftDev+interval, 0, LeftSec-LeftDev, top, tmph);
        }
      
        //cv.textAlign  = "right";
        //cv.fillText(i + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
        var evps = i + +EventOffset + 1;
        lentxt = cv.measureText(evps).width;
        if (lentxt < LeftDev-10) {
          cv.textAlign  = "right";  
          cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);  
        } else {
          cv.textAlign  = "left";  
          myTextDraw(cv, evps, 0, 10, LeftDev-10, top, tmph);
        }
        
      
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
      lentxt = cv.measureText(evtext).width;
      if (lentxt <= Width - LeftTxt-10) {
        cv.fillText(evtext, +LeftTxt, +top + +tmph / 2);
      } else {
        myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt, top, tmph);
      }  
      
      cv.fillStyle = Foreground1;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.fillStyle = cfont;
      if ((TLT[ActiveTL].Events[sev].Start <= TLP.Position &&
              +TLT[ActiveTL].Events[sev].Finish >= TLP.Position) ) {
        cv.fillStyle = "red";
        evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev].Finish);
        evtext = SecondsToString(evtext);
      } else {
        if (sev < TLT[ActiveTL].Count) {
          //if (sev == TLT[ActiveTL].Count) {
            evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev].Start);
            evtext = SecondsToString(evtext);  
          //} else {
          //  evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev+1].Start);//FramesToShortString(evdur);
          //  evtext = SecondsToString(evtext);  
          //}  
        } else {
          evtext = ""; 
        }
      }
      
      if (typeof WidthDevice == "undefined") {
        WidthDevice = LeftTxt / 3.5;   
      }
      
      LeftSec = LeftTxt - + WidthDevice - +IntervalDevice;
      LeftDev = LeftSec - + WidthDevice;
      //cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
      
      lentxt = cv.measureText(evtext).width;
      if (lentxt < LeftTxt - LeftSec - 10) {
        cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
      } else {
        myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec-10, top, tmph);
      }
      
      //cv.fillStyle = evColor;
      //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
      //cv.fillStyle = cfont;
      //cv.textAlign  = "center";
      //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
      cv.fillStyle = cfont;
      cv.textAlign  = "right";
      cv.fillText(sev + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
      
      var evps = sev + +EventOffset + 1;
      lentxt = cv.measureText(evps).width;
      if (lentxt < LeftDev-20) {
        cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);  
      } else {
        myTextDraw(cv, evps, 0, 10, LeftDev-20, top, tmph);
      }
      
       
      
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
      cv.fillStyle = Foreground1;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.textAlign  = "left";
      cv.fillStyle = cfont;
      evtext = FramesToShortString(TLP.Position - TLP.Start);
      //cv.fillText(evtext, +LeftDev - 10, +top + +tmph / 2);
      //myTextDraw(cv, evtext, 0, 10, LeftTxt, top, tmph);
      lentxt = cv.measureText(evtext).width;
      var offx = Math.floor((LeftTxt-lentxt) / 20) * 10;
      if (lentxt < LeftTxt-20) {
        cv.fillText(evtext, offx , +top + +tmph / 2);  
        //cv.fillText(evtext, (LeftTxt - lentxt-10) / 2, +top + +tmph / 2);
      } else {
        myTextDraw(cv, evtext, 0, 10, LeftTxt-20, top, tmph);
      }
      
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
      
        cv.fillStyle = Foreground1;
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
        cv.fillText(i + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
            
        top = top + tmph + interval;
 //=============================================================================          
      }
    }  
  } else if (+tptl == 2) {
      
  }
  
} //End function MyDrawEvents

function MyDrawDevEvents(cv, Width, Height, device, menu) {

  var LeftTxt = +LengthNameTL + +MyCursor;
  var LeftSec = LeftTxt - WidthDevice - IntervalDevice;
  var LeftDev = LeftSec - WidthDevice;
  if (DoubleSize==1)  {
    LeftDev = 2 * (WidthDevice + 1.5 * IntervalDevice);
    LeftSec = LeftDev + 2 * WidthDevice + IntervalDevice;
    LeftTxt = LeftSec + 2 * (WidthDevice + IntervalDevice);
    if (ShowNameTL) {
      LengthNameTL = LeftSec;
      MyCursor = LeftTxt - LengthNameTL;  
    } else {
      LengthNameTL = 0;
      MyCursor = LeftTxt;
   }  
  } 
  
  
  var ScreenFrm = Math.floor((Width - LeftTxt)/FrameSize);
  var ScreenSec = Math.floor(ScreenFrm / 25);
  var Position = TLP.Position;
  cv.fillStyle = Background;
  cv.fillRect(0,0,Width,Height);
  
  var CNTEvents, DEVNumber, FirstEvent, IndexEvent;
  if (device == 0) {
    CNTEvents = EventsDev1;
    DEVNumber = Device1;
    FirstEvent = ArrDev1[0];
  } else {
    CNTEvents = EventsDev2;
    DEVNumber = Device2;
    FirstEvent = ArrDev2[0]
  }
  
  var tmph;
  if (menu) {
    tmph = (Height - HeightMenu/3) / (+CNTEvents + 1);
  } else {
    tmph = Height / (+CNTEvents + 1);  
  }
  
  var interval = (tmph / 100) * 10;
  tmph = tmph - interval;
  var top = interval;
  if (menu) {
    cv.fillStyle = ProgrammColor;
    cv.fillRect(0,0,Width,HeightMenu/3);
    top = top + HeightMenu/3;      
  }
  
  
  cv.fillStyle = Foreground;
  for (var i=0; i<=CNTEvents + 1; i++) {
    cv.fillRect(0,top,Width,tmph);
    top = +top + (+tmph + +interval);
  }  
  var tptl = TLT[ActiveTL].TypeTL;
  var LastEvent, strtev, fnshev;
  var step = 25 * FrameSize;
  var evColor, evFontName, evSafeZone, evmix, evmixdur, evtext, evdevice;
  var evcomment, wdthev, evdur, tmpdur, Start, Finish;
          
  if (+tptl == 0) {
    if (FirstEvent !== -1) {
      //LastEvent = FirstEvent + CNTEvents;
      //if (LastEvent > TLT[ActiveTL].Count-1) {
      //  LastEvent = TLT[ActiveTL].Count-1;  
      //}
      top = interval;
      if (menu) {
        top = top + HeightMenu/3;      
      }
      
      evColor = rgbFromNum(TLT[ActiveTL].Events[FirstEvent].Color);
      evFontName = TLT[ActiveTL].Events[FirstEvent].FontName;
      evSafeZone = TLT[ActiveTL].Events[FirstEvent].SafeZone;;  
      evmix = TLT[ActiveTL].Events[FirstEvent].Rows[1].Phrases[0].Text;
      evmixdur = TLT[ActiveTL].Events[FirstEvent].Rows[1].Phrases[1].Data;
      evtext = TLT[ActiveTL].Events[FirstEvent].Rows[0].Phrases[1].Text;
      evdevice = TLT[ActiveTL].Events[FirstEvent].Rows[0].Phrases[0].Data;
      evcomment = TLT[ActiveTL].Events[FirstEvent].Rows[3].Phrases[0].Text;
      Start = TLT[ActiveTL].Events[FirstEvent].Start;
      Finish = TLT[ActiveTL].Events[FirstEvent].Finish;
      if (evcomment.charAt(0) == "#") {
        evtext = evcomment;  
      }
      if (evmixdur == "") {
        evmixdur = 0;  
      }
      strtev = (TLT[ActiveTL].Events[FirstEvent].Start - TLP.Position) * FrameSize;
      evdur = TLT[ActiveTL].Events[FirstEvent].Finish - TLP.Position;
      fnshev = (TLT[ActiveTL].Events[FirstEvent].Finish - TLP.Position) * FrameSize;
      
      var fs = Math.floor(tmph / 2);
      if (fs>MaxFontSize) {
        fs = MaxFontSize;  
      }        
      cv.font = fs + "pt Arial";
            
      if (+LeftTxt + strtev <= Width) {
      
         
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
      
        //var fs = Math.floor(tmph / 2);
        //if (fs>MaxFontSize) {
        //  fs = MaxFontSize;  
        //}        
        //cv.font = fs + "pt Arial";
        
        if (evtext.charAt(0) == "#") {
          cv.fillStyle = "yellow";  
        } else { 
          cv.fillStyle = cfont;
        }
        cv.textBaseline = "middle"; 
        cv.textAlign  = "left";
        //cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 
        var lentxt = cv.measureText(evtext).width;
        if (lentxt < Width - LeftTxt) {
          cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 
        } else {
          myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt, top, tmph);
        }
      }
        cv.textBaseline = "middle";
        cv.fillStyle = Foreground1;
        cv.fillRect(0, +top, +LeftTxt, +tmph);
        cv.fillStyle = cfont;
        if (Start<=Position && Finish>=Position) {
          cv.fillStyle = "red"; 
          evtext = GetSeconds(Position, Finish);//FramesToShortString(evdur);
          evtext = SecondsToString(evtext);
        } else {
          evtext = GetSeconds(Position, Start);//FramesToShortString(evdur);
          evtext = SecondsToString(evtext);
        }
        //evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[FirstEvent].Finish);//FramesToShortString(evdur);
        //evtext = SecondsToString(evtext);
        //cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
        lentxt = cv.measureText(evtext).width;
        if (lentxt < LeftTxt - LeftSec - 10) {
          cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
        } else {
          myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec-10, top, tmph);
        }
        
      
        cv.fillStyle = evColor;
        rectRound(cv, LeftDev-1, top, LeftSec - LeftDev + 2, +tmph, 5, evColor, evColor);
        //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
        cv.fillStyle = cfont;
        cv.textAlign  = "center";
        //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
        lentxt = cv.measureText(evdevice).width;
        if (lentxt < LeftSec-LeftDev) {
          cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);   
        } else {
          myTextDraw(cv, evdevice, LeftDev+interval, 0, LeftSec-LeftDev, top, tmph);
        } 
            
            
        cv.textAlign  = "right";
        //cv.fillText(FirstEvent + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
        var evps = +CurrEvent + +EventOffset + 1;
        lentxt = cv.measureText(evps).width;
        if (lentxt < LeftDev-10) {
          cv.textAlign  = "right";  
          cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);  
        } else {
          cv.textAlign  = "left";  
          myTextDraw(cv, evps, 0, 10, LeftDev-20, top, tmph);
        }     
      
      
        if (Start <= Position && +Start + +evSafeZone >=Position) {
          cv.fillStyle = "rgba(255,255,255,.65)";
          tmpdur = +fnshev - strtev - 1;//LeftTxt + +TLP.Start;
          if (tmpdur < 0) {
            tmpdur = 0;  
          }
          cv.fillRect(+LeftTxt + 1,  top, tmpdur + strtev, tmph);
          cv.globalAlpha = 1;
        }  
      top = top + tmph + interval;  
      if (+LeftTxt + strtev <= Width) {
        //top = top + tmph + interval;
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
      }  
        cv.fillStyle = Foreground1;
        cv.fillRect(0, +top, +LeftTxt, +tmph);
        cv.textAlign  = "left";
        cv.fillStyle = cfont;
        evtext = FramesToShortString(TLP.Position - TLP.Start);
        //cv.fillText(evtext, +LeftDev - 10, +top + +tmph / 2);
        //myTextDraw(cv, evtext, 0, 10, LeftTxt, top, tmph);
        
        //var lentxt = cv.measureText(evtext).width;
        var lentxt = cv.measureText("00:00:00").width;
        var offx = Math.floor((LeftTxt-lentxt) / 20) * 10;
        if (lentxt < LeftTxt-10) {
          cv.fillText(evtext, offx , +top + +tmph / 2);  
          //cv.fillText(evtext, (LeftTxt - lentxt-10) / 2, +top + +tmph / 2);
        } else {
          myTextDraw(cv, evtext, 0, 10, LeftTxt-10, top, tmph);
        }
        
      top = top + tmph + interval;
      
      for (var i=1; i<CNTEvents; i++) {
//==============================================================================
        if (device == 0) {
          IndexEvent = ArrDev1[i];  
        } else {
          IndexEvent = ArrDev2[i];  
        }
        if (IndexEvent !== -1) {
          evColor = rgbFromNum(TLT[ActiveTL].Events[IndexEvent].Color);
          evFontName = TLT[ActiveTL].Events[IndexEvent].FontName;
          evSafeZone = TLT[ActiveTL].Events[IndexEvent].SafeZone;;  
          evmix = TLT[ActiveTL].Events[IndexEvent].Rows[1].Phrases[0].Text;
          evmixdur = TLT[ActiveTL].Events[IndexEvent].Rows[1].Phrases[1].Data;
          evtext = TLT[ActiveTL].Events[IndexEvent].Rows[0].Phrases[1].Text;
          evdevice = TLT[ActiveTL].Events[IndexEvent].Rows[0].Phrases[0].Data;
          evcomment = TLT[ActiveTL].Events[IndexEvent].Rows[3].Phrases[0].Text;
          Start = TLT[ActiveTL].Events[IndexEvent].Start;
          Finish = TLT[ActiveTL].Events[IndexEvent].Finish;
          Position = TLP.Position;
          if (evcomment.charAt(0) == "#") {
            evtext = evcomment;  
          }
          if (evmixdur == "") {
            evmixdur = 0;  
          }
          strtev = (Start - Position) * FrameSize;
          evdur = Finish - Position;
          fnshev = (Finish - Position) * FrameSize;
         
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
          lentxt = cv.measureText(evtext).width;
          if (lentxt < Width - LeftTxt) {
            cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 
          } else {
            myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt, top, tmph);
          }
        
          cv.fillStyle = Foreground1;
          cv.fillRect(0, +top, +LeftTxt, +tmph);
          cv.fillStyle = cfont;
          evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[IndexEvent].Start);
          evtext = SecondsToString(evtext);
          //cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
          lentxt = cv.measureText(evtext).width;
          if (lentxt < LeftTxt - LeftSec - 10) {
            cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
          } else {
            myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec-10, top, tmph);
          }
      
          cv.fillStyle = evColor;
          rectRound(cv, LeftDev-1, top, LeftSec - LeftDev + 2, +tmph, 5, evColor, evColor);
          //cv.fillRect(+LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph);
          cv.fillStyle = cfont;
          cv.textAlign  = "center";
          //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
          lentxt = cv.measureText(evdevice).width;
          if (lentxt < LeftSec-LeftDev) {
            cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);   
          } else {
            myTextDraw(cv, evdevice, LeftDev+interval, 0, LeftSec-LeftDev, top, tmph);
          } 
          
          
          cv.textAlign  = "right";
          //cv.fillText(IndexEvent + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
          var evps = +CurrEvent + +EventOffset + i+1;
          lentxt = cv.measureText(evps).width;
          if (lentxt < LeftDev-10) {
            cv.textAlign  = "right";  
            cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);  
          } else {
            cv.textAlign  = "left";  
            myTextDraw(cv, evps, 0, 10, LeftDev-20, top, tmph);
          }  
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
          if (i == 1) { 
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
        
        
        }
//==============================================================================                
      }
    }     
  } else if (+tptl == 1) {
    var FinishFrm = +Position + ScreenFrm;  
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
      
      cv.fillStyle = Foreground1;
      cv.fillRect(0, +top, +LeftTxt, +tmph);
      cv.fillStyle = cfont;
      if ((TLT[ActiveTL].Events[sev].Start <= TLP.Position &&
              +TLT[ActiveTL].Events[sev].Finish >= TLP.Position) ) {
        cv.fillStyle = "red";
        evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev].Finish);
        evtext = SecondsToString(evtext);
      } else {
        if (sev < TLT[ActiveTL].Count) {
          //if (sev == TLT[ActiveTL].Count) {
            evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev].Start);
            evtext = SecondsToString(evtext);  
          //} else {
          //  evtext = GetSeconds(TLP.Position, TLT[ActiveTL].Events[sev+1].Start);//FramesToShortString(evdur);
          //  evtext = SecondsToString(evtext);  
          //}  
        } else {
          evtext = ""; 
        }
      }
      
     // if (typeof WidthDevice == "undefined") {
     //   WidthDevice = LeftTxt / 3.5;   
     // }
      
     // LeftSec = LeftTxt - + WidthDevice - +IntervalDevice;
     // LeftDev = LeftSec - + WidthDevice;
      cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
      
      //cv.fillStyle = evColor;
      //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
      //cv.fillStyle = cfont;
      //cv.textAlign  = "center";
      //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
      cv.fillStyle = cfont;
      cv.textAlign  = "right";
      cv.fillText(sev + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
      
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
      evtext = FramesToShortString(Position - Start);
      //cv.fillText(evtext, +LeftDev - 10, +top + +tmph / 2);
      //myTextDraw(cv, evtext, 0, 10, LeftTxt, top, tmph);
      lentxt = cv.measureText(evtext).width;
      var offx = Math.floor((LeftTxt-lentxt) / 20) * 10;
      if (lentxt < LeftTxt-20) {
        cv.fillText(evtext, offx , +top + +tmph / 2);  
        //cv.fillText(evtext, (LeftTxt - lentxt-10) / 2, +top + +tmph / 2);
      } else {
        myTextDraw(cv, evtext, 0, 10, LeftTxt-20, top, tmph);
      }
      
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
        cv.fillText(i + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
            
        top = top + tmph + interval;
 //=============================================================================          
      }
    }  
  } else if (+tptl == 2) {
      
  }

  
}