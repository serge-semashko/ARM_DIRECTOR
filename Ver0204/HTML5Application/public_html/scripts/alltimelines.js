/* 
  * Created by Zavialov on 14.01.2018.
 */

var PosTimelines = [];
PosTimelines[0] = {
  top : 0,
  bottom : 0
};
PosTimelines[1] = {
  top : 0,
  bottom : 0
};
PosTimelines[2] = {
  top : 0,
  bottom : 0
};
PosTimelines[3] = {
  top : 0,
  bottom : 0
};
PosTimelines[4] = {
  top : 0,
  bottom : 0
};
PosTimelines[5] = {
  top : 0,
  bottom : 0
};
PosTimelines[6] = {
  top : 0,
  bottom : 0
};
PosTimelines[7] = {
  top : 0,
  bottom : 0
};
PosTimelines[8] = {
  top : 0,
  bottom : 0
};
PosTimelines[9] = {
  top : 0,
  bottom : 0
};
PosTimelines[10] = {
  top : 0,
  bottom : 0
};
PosTimelines[11] = {
  top : 0,
  bottom : 0
};
PosTimelines[12] = {
  top : 0,
  bottom : 0
};
PosTimelines[13] = {
  top : 0,
  bottom : 0
};
PosTimelines[14] = {
  top : 0,
  bottom : 0
};
PosTimelines[15] = {
  top : 0,
  bottom : 0
};

function DrawAllTimelines(cv, Width, Height) {
  var CountTL = TLT.length;
  var wdth = Width;
  var WidthTL = wdth - LengthNameTL;
  var hght = Height;
  var hghtl = hght / CountTL;
  var start = TLP.Preroll;
  var finish = TLP.Finish;
  var duration = TLP.Duration;
  var kfx = WidthTL / (finish - start);
  var top = 0;
  cv.fillStyle = rgbFromNum(TLP.BackGround);
  cv.fillRect(0, 0, wdth, hght);
  
  var lft, wdt, clr, evstr, evfin, tptl;
  for (var i=0; i<CountTL; i++) {
    cv.fillStyle = rgbFromNum(TLP.ForeGround);  
    cv.fillRect(LengthNameTL, top+1, wdth, hghtl-1);
    if (finish > duration) {
      wdt = (finish - duration) * kfx;
      lft = duration * kfx;
      cv.fillStyle = smoothcolor(TLP.ForeGround,80);
      cv.globalAlpha = .25;
      cv.fillRect(LengthNameTL + lft, top+1, wdt, hghtl-1);
      cv.globalAlpha = 1;
    }
    tptl = Number(TLT[i].TypeTL);
    if (tptl == 0) {
      for (var j=0; j<TLT[i].Count; j++) {
        cv.fillStyle = rgbFromNum(TLT[i].Events[j].Color);
        lft = (TLT[i].Events[j].Start - TLP.Preroll) * kfx;
        wdt = (TLT[i].Events[j].Finish - TLT[i].Events[j].Start) * kfx;
        cv.fillRect(LengthNameTL + lft, top+2, wdt, hghtl-2);  
      }  
    } else if (tptl == 1) {
      cv.fillStyle = rgbFromNum(TLO[i].TextEvent.Color);  
      for (var j=0; j<TLT[i].Count; j++) {
        lft = (TLT[i].Events[j].Start - TLP.Preroll) * kfx;
        wdt = (TLT[i].Events[j].Finish - TLT[i].Events[j].Start) * kfx;
        cv.fillRect(LengthNameTL + lft, top+2, wdt, hghtl-2);  
      }  
    } else if (tptl == 2) {
      //for (var j=0; j<TLT[i].Count; j++) {
        cv.fillStyle = rgbFromNum(TLO[i].MediaEvent.Color);
        wdt = TLP.Duration * kfx;
        cv.fillRect(LengthNameTL, top+2, wdt, hghtl-2); 
      for (var j=0; j<TLT[i].Count; j++) {  
      }  
    }
    top = top + hghtl;
  }
  cv.fillStyle = "black";
  cv.globalAlpha = .5;
  var pst = (TLP.Position - TLP.Preroll) * kfx;
  var bfr = (MyCursor / FrameSize) * kfx;
  var scrfrm = ((wdth - LengthNameTL) / FrameSize) * kfx; 
  cv.fillRect(LengthNameTL + pst-bfr, 0, scrfrm, hght);
  cv.globalAlpha = 1;
  cv.beginPath();  
  cv.moveTo(LengthNameTL + pst, 0);  
  cv.lineTo(LengthNameTL + pst, +hght);
  cv.lineWidth = 1;
  cv.strokeStyle = "white";
  cv.stroke();
  cv.closePath();
  
  cv.fillStyle = rgbFromNum(TLP.ForeGround);  
  cv.fillRect(0, 0, LengthNameTL, hght);
    
}

function DrawTimeLineNames(cv, Width, Height) {
  var hght = Height;
  cv.fillStyle = rgbFromNum(TLP.BackGround);
  cv.fillRect(0, 0, LengthNameTL, hght);
  var CountLine = 0;
  if (ShowTimelines) {
    CountLine = CountLine + TLO.length;
  }        
  if (ShowScaler) {
    CountLine = CountLine + 1;  
  }
  if (ShowEditor) {
    CountLine = CountLine + 3;  
  }
  var tmph = hght / CountLine;
  var interval = tmph / 100 * 15;
  tmph = tmph - interval;
 
  var top = 0;
  cv.fillStyle = rgbFromNum(TLP.ForeGround);
  //for (var i=0; i<CountLine; i++) {
  var text, se, sev;
  if (ShowScaler) {
    cv.fillRect(0, top, LengthNameTL, tmph);
    top = top + tmph + interval;
  } 
  if (ShowEditor) {
    top = top + 2 * interval;  
    cv.fillRect(0, top, LengthNameTL, 3 * tmph);
    text = TLO[ActiveTL].Name;
    text = text.replace('#$%#$%', ' ');
    var fs = Math.floor(tmph / 2);
    
    cv.font = fs + "pt Arial";
    cv.fillStyle = cfont;
    cv.strokeStyle = cfont;
    cv.textBaseline = "middle";
    cv.textAlign  = "left";
    
    var lentxt = cv.measureText(text).width;
    if (lentxt < LengthNameTL-20) {
      cv.fillText(text, 10, top+1.5*tmph);  
    } else {
      myTextDraw(cv, text, 0, 10, LengthNameTL-20, top, tmph);
    }

    top = top + 3 * tmph + interval;
  }
  if (ShowTimelines) { 
    for (var i=0; i<TLO.length; i++) {
      cv.fillStyle = rgbFromNum(TLP.ForeGround);  
      cv.fillRect(0, top, LengthNameTL, tmph);
      text = TLO[i].Name;
      var fs = Math.floor(tmph / 2);
      cv.font = fs + "pt Arial";
      cv.fillStyle = cfont;
      cv.textBaseline = "middle";
      cv.textAlign  = "left";
      text = text.replace('#$%#$%', ' ');
      //cv.fillText(text, 10, top+tmph/2);
      lentxt = cv.measureText(text).width;
      if (lentxt < LengthNameTL-20) {
        cv.fillText(text, 10, top+tmph/2);  
      } else {
        myTextDraw(cv, text, 0, 10, LengthNameTL-20, top, tmph);
      }
      top = top + tmph + interval;
    }
  }
}

function MyDrawScaler(cv,Width,Height,hght) {
  var wdth = Width;
  var WidthTL = wdth - LengthNameTL;
  var ScreenFrm = Math.floor(WidthTL / FrameSize);
  var PosZero = TLP.ZeroPoint;
  var CurrFrm = Math.floor(MyCursor / FrameSize);
  var CurrOst = Math.floor(MyCursor % FrameSize);
  var StartFrm = TLP.Position - CurrFrm;
  var DLT, SSec, SOst, SValue, fs, text;
    
  if (StartFrm < PosZero) {
    DLT = StartFrm-PosZero;
    SSec = Math.floor(DLT / 25);
    SOst = Math.floor(DLT % 25);
    SValue = SSec;
  } else {
    DLT = StartFrm - PosZero;
    SSec = Math.floor(DLT / 25);
    SOst = Math.floor(DLT % 25);
    SOst = 25 - SOst;
    SValue = SSec + 1;  
  }
  
  StartFrm = StartFrm-PosZero;
  
  var hfrm = hght / 4;
  var hsec = 2 * hfrm;
  hfrm = hfrm * 3;
  var hh;

  var stp = +LengthNameTL + CurrOst;
  for (var i=0; i<ScreenFrm; i++) {
      
    if ((StartFrm + i) % 25 == 0) {
      hh = hsec;  
    } else {
      if (FrameSize < 3) {
        hh = 0;  
      } else {
        hh = hfrm;
      }
    }
    if (hh !== 0) {
      cv.beginPath();  
      cv.moveTo(stp, hh);  
      cv.lineTo(stp, hght);
      cv.lineWidth = 1;
      cv.strokeStyle = "white";
      cv.stroke();
      cv.closePath(); 
    }   
    
    if (FrameSize == 1) {
      cv.font = Math.floor(hght/5*2) + "pt Arial";  
    } else {
      cv.font = Math.floor(hght/2) + "pt Arial";  
    }
    
    cv.fillStyle = cfont;
    cv.textBaseline = "middle";
    cv.textAlign  = "left";
    
    if (hh == hsec) {
      //text = FramesToShortString(SValue); 
      text = FramesToSecondString(StartFrm + i);
      //fs = Math.floor(hsec / 2);
      
      cv.fillText(text, stp+1, hfrm/2);  
      //SValue = SValue + 1;   
    }
    //StartFrm = StartFrm + 1;
    stp = stp + FrameSize;
  }
 
}

function FindEvent(nomtl, ps) {
  for (var i=0; i<TLT[nomtl].Count; i++) {
    if (+ps >= TLT[nomtl].Events[i].Start && +ps <= TLT[nomtl].Events[i].Finish)
    {
      return i;  
    }
  } 
  return -1;
}

function MyDrawEditor(cv, Width, Height, Top, Intrvl, Hght) {
  var wdth = Width;
  var WidthTL = wdth - LengthNameTL;
  var ScreenFrm = Math.floor(WidthTL / FrameSize);
  var CurrFrm = Math.floor(MyCursor / FrameSize);
  var StartFrm = TLP.Position - CurrFrm;
  var FinishFrm = StartFrm + ScreenFrm;
  var sev, fev, evstart, evfinish, strtev, fnshev, wdthev, uptext;
  var evColor, evFontColor, evFontSize, evFontSizeSub, evFontName, evSafeZone; 
  var rowheight, kfh, evtext, evdata ,evmix, evmixdur, evname, evsmoothcolor;
  var evlft, evwdt, evworkdata, evfntsz, evst, evdur;
  var tptl = Number(TLT[ActiveTL].TypeTL);
  
  if (tptl == 0) {
    if (TLT[ActiveTL].Count > 0) {
      if (TLP.Position <= TLT[ActiveTL].Events[0].Start) {
        sev = 0; 
      } else {
        sev = FindEvent(ActiveTL,StartFrm);
        if (sev == -1) {
          sev = 0;  
        }  
      } 
      if (TLP.Position <= TLT[ActiveTL].Events[TLT[ActiveTL].Count-1].Finish) {
        fev = FindEvent(ActiveTL,FinishFrm);
        if (fev == -1) {
          fev = TLT[ActiveTL].Count-1;   
        }
      } else {
        if (StartFrm <= TLT[ActiveTL].Events[TLT[ActiveTL].Count-1].Finish) {
          fev = fev = TLT[ActiveTL].Count-1;   
        } else {
          fev = -1;//FindEvent(ActiveTL,StartFrm);
        }  
      }
    } else {
      sev = 0;
      fev = -1;
    }
    
      for (var i=sev; i<=fev; i++) {
        evColor = rgbFromNum(TLT[ActiveTL].Events[i].Color);
        evsmoothcolor = smoothcolor(TLT[ActiveTL].Events[i].Color, 32);
        evFontColor = rgbFromNum(TLT[ActiveTL].Events[i].FontColor);
        evFontSize = TLT[ActiveTL].Events[i].FontSize;
        evFontSizeSub = TLT[ActiveTL].Events[i].FontSizeSub;
        evFontName = TLT[ActiveTL].Events[i].FontName;
        evSafeZone = TLT[ActiveTL].Events[i].SafeZone;;  
        evstart = TLT[ActiveTL].Events[i].Start;
        evfinish = TLT[ActiveTL].Events[i].Finish;

        evmix = TLT[ActiveTL].Events[i].Rows[1].Phrases[0].Text;
        evmixdur = TLT[ActiveTL].Events[i].Rows[1].Phrases[1].Data;
        if (evmixdur == "") {
          evmixdur = 0;  
        }
        
        strtev = evstart - StartFrm;
        //if (strtev < 0) {
        //  strtev = 0;  
        //}
        fnshev = evfinish - StartFrm;
        if (fnshev < 0) {
          fnshev = 0;  
        }
        strtev = strtev * FrameSize;
        fnshev = fnshev * FrameSize;
        
        wdthev = fnshev - strtev;
        
        evmixdur = evmixdur * FrameSize;
        
        if (wdthev < evmixdur) {
          evmixdur = wdthev;
        }
        
        if (fnshev > WidthTL) {
          fnshev = WidthTL;  
        }
        cv.fillStyle = evColor;
        cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
                  
        if (evmix == "Mix" || evmix == "Wipe") {
          cv.beginPath();  
          cv.moveTo(+LengthNameTL + strtev, Top);  
          cv.lineTo(+LengthNameTL + strtev, Top + Hght);
          cv.lineTo(+LengthNameTL + strtev + evmixdur, Top + Hght);
          cv.lineTo(+LengthNameTL + strtev, Top);
          cv.lineWidth = 1;
          cv.fillStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          cv.strokeStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          cv.stroke();
          //cv.fill;
          cv.closePath(); 
          cv.fill();
          cv.globalAlpha = 1;
        }  
        cv.beginPath();
        cv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        cv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        cv.fillRect(+LengthNameTL + strtev, Top, evSafeZone, Hght)
        cv.stroke();
        cv.closePath();
        cv.globalAlpha = 1;
              
        cv.font = 2*Intrvl + "pt Arial";// smallFont;
        cv.fillStyle = cfont;
        cv.textBaseline = "middle"; 
        cv.textAlign  = "left";
        evst = TLT[ActiveTL].Events[i].Start - TLP.ZeroPoint;
        evdur = TLT[ActiveTL].Events[i].Finish - TLT[ActiveTL].Events[i].Start;
        uptext = FramesToShortString(evst) + " [" + FramesToShortString(evdur) + "]";
        
        cv.fillText(uptext, +LengthNameTL + strtev, Top - Intrvl);
        
        kfh = TLT[ActiveTL].Events[i].Count;
        if (+kfh > 0) {
          rowheight = Hght / (+kfh + 1);
          for (var j=0; j<kfh; j++) {
            for (var ic=0; ic<TLT[ActiveTL].Events[i].Rows[j].Count; ic++) {
              if (TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Visible == "True") { 
                evname = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Name;  
                evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;
                evdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;
                evlft = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Rect.Left;
                evwdt = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Rect.Right - evlft;
                evworkdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].WorkData;
                if (j == 0) {
                  //evfntsz = evFontSize + "pt " + evFontName; 
                  evfntsz = Math.floor((1.5*rowheight)/2+1) + "pt " + evFontName;
                } else {
                  //evfntsz = evFontSizeSub + "pt " + evFontName;
                  evfntsz = Math.floor(rowheight/2+1) + "pt " + evFontName;  
                }
                
                if (evworkdata == "Template") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;  
                } else if (evworkdata == "Text") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;  
                } else if (evworkdata == "Data") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;  
                } else if (evworkdata == "ShortTimeCode") {
                  evdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data; 
                  evtext = FramesToShortString(evdata);
                } else if (evworkdata == "Command") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Command;  
                } else if (evworkdata == "Device") {    
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;
                }  else if (evworkdata == "Tag") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Tag;  
                }
                //if (evtext == "") {
                //  evtext = evdata;  
                // }
                cv.font = evfntsz;//fs + "pt Arial";
                if (evname == "Comment") {
                  if (evtext.charAt(0) == "#") {
                    cv.fillStyle = "yellow";  
                  } else { 
                    cv.fillStyle = evFontColor;//cfont;
                  }
                } else {
                  cv.fillStyle = evFontColor;  
                }
                cv.textBaseline = "bottom";//"middle"; 
                cv.textAlign  = "left";
                evlft = +evlft + +LengthNameTL + +strtev

                if (j == 0) {
                  cv.fillText(evtext, +evlft, Top + 1.5 * rowheight);
                } else {
                  cv.fillText(evtext, +evlft, Top + 1.5 * rowheight + rowheight*j);  
                }               
              }
            }   
          }
        }
        if (+TLP.Position >= +evstart && +TLP.Position <= +evstart + +evSafeZone) {
          cv.fillStyle = "white";
          cv.globalAlpha = .75;
          cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
          cv.globalAlpha = 1;  
        }
      }  
    
  } else if (tptl == 1) {
    if (TLT[ActiveTL].Count > 0) {
      fev = -1;
      sev = 0;
      for (var i=0; i<TLT[ActiveTL].Count-1; i++) {
        if (TLT[ActiveTL].Events[i].Finish > StartFrm){
          sev = i;
          break;
        }  
      }  
      var cnt = TLT[ActiveTL].Count-1;  
      for (var i=0; i<cnt; i++) {
        if (TLT[ActiveTL].Events[cnt-i].Start < FinishFrm){
          fev = cnt-i;
          break; 
        }  
      } 
      
      for (var i=sev; i<=fev; i++) {
        evColor = rgbFromNum(TLT[ActiveTL].Events[i].Color);
        evsmoothcolor = smoothcolor(TLT[ActiveTL].Events[i].Color, 32);
        evFontColor = rgbFromNum(TLT[ActiveTL].Events[i].FontColor);
        evFontSize = TLT[ActiveTL].Events[i].FontSize;
        evFontSizeSub = TLT[ActiveTL].Events[i].FontSizeSub;
        evFontName = TLT[ActiveTL].Events[i].FontName;
        evSafeZone = TLT[ActiveTL].Events[i].SafeZone;;  
        evstart = TLT[ActiveTL].Events[i].Start;
        evfinish = TLT[ActiveTL].Events[i].Finish;

           
        strtev = evstart - StartFrm;
        fnshev = evfinish - StartFrm;
        if (fnshev < 0) {
          fnshev = 0;  
        }
        strtev = strtev * FrameSize;
        fnshev = fnshev * FrameSize;
        
        wdthev = fnshev - strtev;
        
        cv.fillStyle = evColor;
        cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght); 
        
        cv.beginPath();
        cv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        cv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        cv.fillRect(+LengthNameTL + strtev, Top, evSafeZone, Hght)
        cv.stroke();
        cv.closePath();
        cv.globalAlpha = 1;
        
        cv.beginPath();
        cv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        cv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        cv.fillRect(+LengthNameTL + fnshev - evSafeZone, Top, evSafeZone, Hght)
        cv.stroke();
        cv.closePath();
        cv.globalAlpha = 1;
                
        cv.font = 2*Intrvl + "pt Arial";//smallFont;
        cv.fillStyle = cfont;
        cv.textBaseline = "middle"; 
        cv.textAlign  = "left";
        evst = TLT[ActiveTL].Events[i].Start - TLP.ZeroPoint;
        evdur = TLT[ActiveTL].Events[i].Finish - TLT[ActiveTL].Events[i].Start;
        uptext = FramesToShortString(evst) + " [" + FramesToShortString(evdur) + "]";
        
        cv.fillText(uptext, +LengthNameTL + strtev, Top - Intrvl);
        
        kfh = TLT[ActiveTL].Events[i].Count;
        if (+kfh > 0) {
          rowheight = Hght / (+kfh + 1);
          for (var j=0; j<kfh; j++) {
            for (var ic=0; ic<TLT[ActiveTL].Events[i].Rows[j].Count; ic++) {
              if (TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Visible == "True") { 
                evname = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Name;  
                evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;
                evdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;
                evlft = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Rect.Left;
                evwdt = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Rect.Right - evlft;
                evworkdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].WorkData;
                if (j == 0) {
                  evfntsz = evFontSize + "pt " + evFontName; 
                  //evfntsz = Math.floor(rowheight) + "pt " + evFontName;
                } else {
                  evfntsz = evFontSizeSub + "pt " + evFontName;
                  //evfntsz = Math.floor(rowheight - 4) + "pt " + evFontName;  
                }
                
                if (evworkdata == "Template") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;  
                } else if (evworkdata == "Text") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;  
                } else if (evworkdata == "Data") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;  
                } else if (evworkdata == "ShortTimeCode") {
                  evdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data; 
                  evtext = FramesToShortString(evdata);
                } else if (evworkdata == "Command") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Command;  
                } else if (evworkdata == "Device") {    
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;
                }  else if (evworkdata == "Tag") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Tag;  
                }

                cv.font = evfntsz;//fs + "pt Arial";
                if (evname == "Comment") {
                  if (evtext.charAt(0) == "#") {
                    cv.fillStyle = "yellow";  
                  } else { 
                    cv.fillStyle = evFontColor;//cfont;
                  }
                } else {
                  cv.fillStyle = evFontColor;  
                }
                cv.textBaseline = "middle"; 
                cv.textAlign  = "left";
                evlft = +evlft + +LengthNameTL + +strtev

                if (j == 0) {
                  var fnwidth = cv.measureText(evtext).width;
                  var metrics = cv.measureText("M");
                  var fnheight =   metrics.width;  
                  var kx = wdthev/fnwidth;
                  var ky = rowheight/fnheight;
                  cv.save();
                  cv.scale(wdthev/fnwidth, rowheight/fnheight);
                  cv.fillText(evtext, +evlft/kx, (+Top + rowheight)/ky);
                  cv.restore();  
                  cv.scale(1, 1);  
                  //cv.fillText(evtext, +evlft, Top + 1.5 * rowheight);
                } else {
                  cv.fillText(evtext, +evlft, Top + 1.5 * rowheight + rowheight*j);  
                }               
              }
            }   
          }
        }
        if (+TLP.Position >= +evstart && +TLP.Position <= +evstart + +evSafeZone) {
          cv.fillStyle = "white";
          cv.globalAlpha = .75;
          cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
          cv.globalAlpha = 1;  
        }
      }  
      
    }  
  } else if (tptl == 2) {
    evColor = rgbFromNum(TLO[ActiveTL].MediaColor);
    evFontColor = cfont; 
    evstart = TLP.Preroll;//TLT[ActiveTL].Events[i].Start;
    evfinish = TLP.Duration;//TLT[ActiveTL].Events[i].Finish;
    strtev = evstart - StartFrm;
    fnshev = evfinish - StartFrm;
    if (fnshev < 0) {
      fnshev = 0;  
    }
    
    strtev = strtev * FrameSize;
    fnshev = fnshev * FrameSize;
        
    wdthev = fnshev - strtev;  
   
    cv.fillStyle = evColor;
    cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
    
    //evlft = +LengthNameTL + +MyCursor - (TLP.Position-StartFrm) * FrameSize + 2;
    //var CurrOst = Math.floor(MyCursor % FrameSize);
    evlft = +LengthNameTL + +MyCursor;//FrameSize - Math.floor(MyCursor % FrameSize);
    evst = Math.floor(ScreenFrm / 25);
    evwdt = 25 * FrameSize;
    
    for (var i=0; i<=ScreenFrm-CurrFrm; i++) {
      cv.beginPath();  
      cv.moveTo(+evlft, Top);  
      cv.lineTo(+evlft, Top + Hght);
      cv.lineWidth = 1;
      cv.strokeStyle = "white";
      cv.stroke();
      cv.closePath();  
      evlft = evlft + evwdt;
    }
    evlft = +LengthNameTL + +MyCursor;
    for (var i=0; i<=CurrFrm; i++) {
      cv.beginPath();  
      cv.moveTo(+evlft, Top);  
      cv.lineTo(+evlft, Top + Hght);
      cv.lineWidth = 1;
      cv.strokeStyle = "white";
      cv.stroke();
      cv.closePath();  
      evlft = evlft - evwdt;
    }
    
    if (TLT[ActiveTL].Count > 0) {
      fev = -1;
      sev = 0;
      for (var i=0; i<TLT[ActiveTL].Count-1; i++) {
        if (TLT[ActiveTL].Events[i].Finish > StartFrm){
          sev = i;
          break;
        }  
      }  
      var cnt = TLT[ActiveTL].Count-1;  
      for (var i=0; i<cnt; i++) {
        if (TLT[ActiveTL].Events[cnt-i].Start < FinishFrm){
          fev = cnt-i;
          break; 
        }  
      } 
      
      for (var i=sev; i<=fev; i++) {
        evColor = rgbFromNum(TLT[ActiveTL].Events[i].Color);
        evsmoothcolor = smoothcolor(TLT[ActiveTL].Events[i].Color, 32);
        evFontColor = rgbFromNum(TLT[ActiveTL].Events[i].FontColor);
        evFontSize = TLT[ActiveTL].Events[i].FontSize;
        evFontSizeSub = TLT[ActiveTL].Events[i].FontSizeSub;
        evFontName = TLT[ActiveTL].Events[i].FontName;
        evSafeZone = TLT[ActiveTL].Events[i].SafeZone;;  
        evstart = TLT[ActiveTL].Events[i].Start;


           
        strtev = evstart - StartFrm;
        strtev = strtev * FrameSize;
         
        
        cv.fillStyle = evColor;
        
        cv.beginPath();  
        cv.moveTo(+evlft, Top + Hght);  
        cv.lineTo(+evlft, Top);
        cv.lineTo(+evlft + +evSafeZone, Top + +evSafeZone/2);
        cv.lineTo(+evlft, Top + +evSafeZone);
        cv.lineWidth = 1;
        cv.strokeStyle = evColor;
        cv.stroke();
        cv.closePath();
        cv.fill();
        
        cv.font = smallFont;
        cv.fillStyle = cfont;
        cv.textBaseline = "middle"; 
        cv.textAlign  = "left";
        evst = TLT[ActiveTL].Events[i].Start - TLP.ZeroPoint;
        uptext = FramesToShortString(evst);
        
        cv.fillText(uptext, +LengthNameTL + strtev, Top - Intrvl);
        
        kfh = TLT[ActiveTL].Events[i].Count;
        if (+kfh > 0) {
          rowheight = textHeight(cv);//Hght / (+kfh + 1);
          for (var j=0; j<kfh; j++) {
            for (var ic=0; ic<TLT[ActiveTL].Events[i].Rows[j].Count; ic++) {
              if (TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Visible == "True") { 
                evname = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Name;  
                evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;
                evdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;
                evlft = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Rect.Left;
                evwdt = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Rect.Right - evlft;
                evworkdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].WorkData;
                //if (j == 0) {
                //  evfntsz = evFontSize + "pt " + evFontName; 
                //  //evfntsz = Math.floor(rowheight) + "pt " + evFontName;
                //} else {
                //  evfntsz = evFontSizeSub + "pt " + evFontName;
                //  //evfntsz = Math.floor(rowheight - 4) + "pt " + evFontName;  
                //}
                
                if (evworkdata == "Template") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;  
                } else if (evworkdata == "Text") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Text;  
                } else if (evworkdata == "Data") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;  
                } else if (evworkdata == "ShortTimeCode") {
                  evdata = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data; 
                  evtext = FramesToShortString(evdata);
                } else if (evworkdata == "Command") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Command;  
                } else if (evworkdata == "Device") {    
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Data;
                }  else if (evworkdata == "Tag") {
                  evtext = TLT[ActiveTL].Events[i].Rows[j].Phrases[ic].Tag;  
                }

                cv.font = smallFont;//evfntsz;//fs + "pt Arial";
                if (evname == "Comment") {
                  if (evtext.charAt(0) == "#") {
                    cv.fillStyle = "yellow";  
                  } else { 
                    cv.fillStyle = evFontColor;//cfont;
                  }
                } else {
                  cv.fillStyle = evFontColor;  
                }
                cv.textBaseline = "middle"; 
                cv.textAlign  = "left";
                evlft = +evlft + +LengthNameTL + +strtev
                cv.fillText(evtext, +evlft, +Top + rowheight*j);  
              }
            }   
          }
        }
      }  
    }
  }
} 

function MyDrawTimeline(cv, Width, Height, PosTL, Top, Hght) {
  var wdth = Width;
  var WidthTL = wdth - LengthNameTL;
  var ScreenFrm = Math.floor(WidthTL / FrameSize);
  var CurrFrm = Math.floor(MyCursor / FrameSize);
  var StartFrm = TLP.Position - CurrFrm;
  var FinishFrm = StartFrm + ScreenFrm;
  var sev, fev, evstart, evfinish, strtev, fnshev, wdthev, uptext;
  var evColor, evFontColor, evFontSize, evFontSizeSub, evFontName, evSafeZone; 
  var evtext, evdata ,evmix, evmixdur, evname, evsmoothcolor;
  var evlft, evwdt, evworkdata, evfntsz, evst, evdur;
  
  var tptl = +TLT[PosTL].TypeTL;
  
  if (tptl == 0) {
    if (TLT[PosTL].Count > 0) {
      if (TLP.Position <= TLT[PosTL].Events[0].Start) {
        sev = 0; 
      } else {
        sev = FindEvent(PosTL,StartFrm);
        if (sev == -1) {
          sev = 0;  
        }  
      } 
      if (TLP.Position <= TLT[PosTL].Events[TLT[PosTL].Count-1].Finish) {
        fev = FindEvent(PosTL,FinishFrm);
        if (fev == -1) {
          fev = TLT[PosTL].Count-1;   
        }
      } else {
        if (StartFrm <= TLT[PosTL].Events[TLT[PosTL].Count-1].Finish) {
          fev = fev = TLT[PosTL].Count-1;   
        } else {
          fev = -1;//FindEvent(PosTL,StartFrm);
        }  
      }
    } else {
      sev = 0;
      fev = -1;
    }
    
      for (var i=sev; i<=fev; i++) {
        evColor = rgbFromNum(TLT[PosTL].Events[i].Color);
        evsmoothcolor = smoothcolor(TLT[PosTL].Events[i].Color, 32);
        evFontColor = rgbFromNum(TLT[PosTL].Events[i].FontColor);
        evFontSize = TLT[PosTL].Events[i].FontSize;
        //evFontSizeSub = TLT[PosTL].Events[i].FontSizeSub;
        evFontName = TLT[PosTL].Events[i].FontName;
        evSafeZone = TLT[PosTL].Events[i].SafeZone;;  
        evstart = TLT[PosTL].Events[i].Start;
        evfinish = TLT[PosTL].Events[i].Finish;

        evmix = TLT[PosTL].Events[i].Rows[1].Phrases[0].Text;
        evmixdur = TLT[PosTL].Events[i].Rows[1].Phrases[1].Data;
        if (evmixdur == "") {
          evmixdur = 0;  
        }
        
        strtev = evstart - StartFrm;
        //if (strtev < 0) {
        //  strtev = 0;  
        //}
        fnshev = evfinish - StartFrm;
        if (fnshev < 0) {
          fnshev = 0;  
        }
        strtev = strtev * FrameSize;
        fnshev = fnshev * FrameSize;
        
        wdthev = fnshev - strtev;
        
        evmixdur = evmixdur * FrameSize;
        
        if (wdthev < evmixdur) {
          evmixdur = wdthev;
        }
        
        if (fnshev > WidthTL) {
          fnshev = WidthTL;  
        }
        cv.fillStyle = evColor;
        cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
        
        if (evmix == "Mix" || evmix == "Wipe") {
          cv.beginPath();  
          cv.moveTo(+LengthNameTL + strtev, Top);  
          cv.lineTo(+LengthNameTL + strtev, Top + Hght);
          cv.lineTo(+LengthNameTL + strtev + evmixdur, Top + Hght);
          cv.lineTo(+LengthNameTL + strtev, Top);
          cv.lineWidth = 1;
          cv.fillStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          cv.strokeStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          cv.stroke();
          //cv.fill;
          cv.closePath(); 
          cv.fill();
          cv.globalAlpha = 1;
        }  
        cv.beginPath();
        cv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        cv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        cv.fillRect(+LengthNameTL + strtev, Top, evSafeZone, Hght)
        cv.stroke();
        cv.closePath();
        cv.globalAlpha = 1;
               
//=========================              
        for (var ic=0; ic<TLT[PosTL].Events[i].Rows[0].Count; ic++) {
          if (TLT[PosTL].Events[i].Rows[0].Phrases[ic].Visible == "True") { 
            evname = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Name;  
            evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Text;
            evdata = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Data;
            evlft = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Rect.Left;
            evwdt = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Rect.Right - evlft;
            evworkdata = TLT[PosTL].Events[i].Rows[0].Phrases[ic].WorkData;
            evfntsz = Hght/2 + "pt " + evFontName;
            //evfntsz = evFontSize + "pt " + evFontName; 
                                
            if (evworkdata == "Template") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Text;  
            } else if (evworkdata == "Text") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Text;  
            } else if (evworkdata == "Data") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Data;  
            } else if (evworkdata == "ShortTimeCode") {
              evdata = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Data; 
              evtext = FramesToShortString(evdata);
            } else if (evworkdata == "Command") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Command;  
            } else if (evworkdata == "Device") {    
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Data;
            } else if (evworkdata == "Tag") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Tag;  
            }
                //if (evtext == "") {
                //  evtext = evdata;  
                // }
            cv.font = evfntsz;//fs + "pt Arial";
            if (evname == "Comment") {
              if (evtext.charAt(0) == "#") {
                cv.fillStyle = "yellow";  
              } else { 
                cv.fillStyle = evFontColor;//cfont;
              }
            } else {
              cv.fillStyle = evFontColor;  
            }
            cv.textBaseline = "middle"; 
            cv.textAlign  = "left";
            evlft = +evlft + +LengthNameTL + +strtev

            cv.fillText(evtext, +evlft, Top + Hght/2);
                           
          }
        }  
//============================== 
        if (PosTL == ActiveTL) {
          if (+TLP.Position >= +evstart && +TLP.Position <= +evstart + +evSafeZone) {
            cv.fillStyle = "white";
            cv.globalAlpha = .75;
            cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
            cv.globalAlpha = 1;  
          } 
        }
      }  
    
  } else if (tptl == 1) {
    if (TLT[PosTL].Count > 0) {
      fev = -1;
      sev = 0;
      for (var i=0; i<TLT[PosTL].Count-1; i++) {
        if (TLT[PosTL].Events[i].Finish > StartFrm){
          sev = i;
          break;
        }  
      }  
      var cnt = TLT[PosTL].Count-1;  
      for (var i=0; i<cnt; i++) {
        if (TLT[PosTL].Events[cnt-i].Start < FinishFrm){
          fev = cnt-i;
          break; 
        }  
      } 
      
      for (var i=sev; i<=fev; i++) {
        evColor = rgbFromNum(TLT[PosTL].Events[i].Color);
        evsmoothcolor = smoothcolor(TLT[PosTL].Events[i].Color, 32);
        evFontColor = rgbFromNum(TLT[PosTL].Events[i].FontColor);
        evFontSize = TLT[PosTL].Events[i].FontSize;
        evFontSizeSub = TLT[PosTL].Events[i].FontSizeSub;
        evFontName = TLT[PosTL].Events[i].FontName;
        evSafeZone = TLT[PosTL].Events[i].SafeZone;;  
        evstart = TLT[PosTL].Events[i].Start;
        evfinish = TLT[PosTL].Events[i].Finish;

           
        strtev = evstart - StartFrm;
        fnshev = evfinish - StartFrm;
        if (fnshev < 0) {
          fnshev = 0;  
        }
        strtev = strtev * FrameSize;
        fnshev = fnshev * FrameSize;
        
        wdthev = fnshev - strtev;
        
        cv.fillStyle = evColor;
        cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght); 
        cv.beginPath();
        cv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        cv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        cv.fillRect(+LengthNameTL + strtev, Top, evSafeZone, Hght);
        cv.stroke();
        cv.closePath();
        cv.globalAlpha = 1;
        
        cv.beginPath();
        cv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        cv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        cv.fillRect(+LengthNameTL + fnshev - evSafeZone, Top, evSafeZone, Hght);
        cv.stroke();
        cv.closePath();
        cv.globalAlpha = 1;
        
//================================              
        for (var ic=0; ic<TLT[PosTL].Events[i].Rows[0].Count; ic++) {
          if (TLT[PosTL].Events[i].Rows[0].Phrases[ic].Visible == "True") { 
            evname = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Name;  
            evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Text;
            evdata = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Data;
            evlft = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Rect.Left;
            evwdt = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Rect.Right - evlft;
            evworkdata = TLT[PosTL].Events[i].Rows[0].Phrases[ic].WorkData;
            evfntsz = evFontSize + "pt " + evFontName; 

            if (evworkdata == "Template") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Text;  
            } else if (evworkdata == "Text") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Text;  
            } else if (evworkdata == "Data") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Data;  
            } else if (evworkdata == "ShortTimeCode") {
              evdata = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Data; 
              evtext = FramesToShortString(evdata);
            } else if (evworkdata == "Command") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Command;  
            } else if (evworkdata == "Device") {    
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Data;
            } else if (evworkdata == "Tag") {
              evtext = TLT[PosTL].Events[i].Rows[0].Phrases[ic].Tag;  
            }

            cv.font = evfntsz;//fs + "pt Arial";
            if (evname == "Comment") {
              if (evtext.charAt(0) == "#") {
                cv.fillStyle = "yellow";  
              } else { 
                cv.fillStyle = evFontColor;//cfont;
              }
            } else {
              cv.fillStyle = evFontColor;  
            }
            cv.textBaseline = "middle"; 
            cv.textAlign  = "left";
            evlft = +evlft + +LengthNameTL + +strtev;

                
            var fnwidth = cv.measureText(evtext).width;
            var metrics = cv.measureText("M");
            var fnheight =   metrics.width;  
            var kx = wdthev/fnwidth;
            var ky = (Hght/2)/fnheight;
            cv.save();
            cv.scale(wdthev/fnwidth, (Hght/2)/fnheight);
            cv.fillText(evtext, +evlft/kx, (+Top + Hght/2)/ky);
            cv.restore();  
            cv.scale(1, 1);  
          }
        }   
//================================  
        if (PosTL == ActiveTL) {
          if (+TLP.Position >= +evstart && +TLP.Position <= +evstart + +evSafeZone) {
            cv.fillStyle = "white";
            cv.globalAlpha = .75;
            cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
            cv.globalAlpha = 1;  
          }
        }
      }  
      
    }  
  } else if (tptl == 2) {
    evColor = rgbFromNum(TLO[PosTL].MediaColor);
    evFontColor = cfont; 
    evstart = TLP.Preroll;//TLT[PosTL].Events[i].Start;
    evfinish = TLP.Duration;//TLT[PosTL].Events[i].Finish;
    strtev = evstart - StartFrm;
    fnshev = evfinish - StartFrm;
    if (fnshev < 0) {
      fnshev = 0;  
    }
    
    strtev = strtev * FrameSize;
    fnshev = fnshev * FrameSize;
        
    wdthev = fnshev - strtev;  
   
    cv.fillStyle = evColor;
    cv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
    
    if (TLT[PosTL].Count > 0) {
      fev = -1;
      sev = 0;
      for (var i=0; i<TLT[PosTL].Count-1; i++) {
        if (TLT[PosTL].Events[i].Finish > StartFrm){
          sev = i;
          break;
        }  
      }  
      var cnt = TLT[PosTL].Count-1;  
      for (var i=0; i<cnt; i++) {
        if (TLT[PosTL].Events[cnt-i].Start < FinishFrm){
          fev = cnt-i;
          break; 
        }  
      } 
      
      for (var i=sev; i<=fev; i++) {
        evColor = rgbFromNum(TLT[PosTL].Events[i].Color);
        evsmoothcolor = smoothcolor(TLT[PosTL].Events[i].Color, 32);
        evFontColor = rgbFromNum(TLT[PosTL].Events[i].FontColor);
        evFontSize = TLT[PosTL].Events[i].FontSize;
        evFontSizeSub = TLT[PosTL].Events[i].FontSizeSub;
        evFontName = TLT[PosTL].Events[i].FontName;
        evSafeZone = TLT[PosTL].Events[i].SafeZone;;  
        evstart = TLT[PosTL].Events[i].Start;


           
        strtev = evstart - StartFrm;
        strtev = strtev * FrameSize;
         
        
        cv.fillStyle = evColor;
        
        cv.beginPath();  
        cv.moveTo(+evlft, Top + Hght);  
        cv.lineTo(+evlft, Top);
        cv.lineTo(+evlft + +evSafeZone/2, Top + +evSafeZone/4);
        cv.lineTo(+evlft, Top + +evSafeZone/2);
        cv.lineWidth = 1;
        cv.strokeStyle = evColor;
        cv.stroke();
        cv.closePath();
        cv.fill();
            
      }  
    }
  }
} 

function DrawTimeLines(cv, Width, Height) {
  var hght = Height;
  var wdth = Width - LengthNameTL;
//===================================
  //var wdth = evCanvas.width;
  //var WidthTL = wdth - LengthNameTL;
  var ScreenFrm = Math.floor(wdth / FrameSize);
  var CurrFrm = Math.floor(MyCursor / FrameSize);
  var StartFrm = TLP.Position - CurrFrm;
  var FinishFrm = StartFrm + ScreenFrm;
//===================================
  //var Frames
  cv.fillStyle = rgbFromNum(TLP.BackGround);
  cv.fillRect(LengthNameTL, 0, wdth, hght);
  var CountLine = 0;
 
  if (ShowTimelines) {
    CountLine = +CountLine + +TLT.length;
  }   
  if (ShowScaler) {
    CountLine = CountLine + 1;  
  }
  if (ShowEditor) {
    CountLine = CountLine + 3;  
  }
  var tmph = hght / CountLine;
  var interval = tmph / 100 * 15;
  tmph = tmph - interval;
 
  var top = 0;
  var cbkgnd = smoothcolor(TLP.ForeGround, 16);
  cv.fillStyle = cbkgnd; //rgbFromNum(TLP.ForeGround);
  //for (var i=0; i<CountLine; i++) {
  var text, se, sev;
  if (ShowScaler) {
    cv.fillRect(LengthNameTL, top, wdth, tmph);
    MyDrawScaler(cv, Width, Height, tmph);
    top = +top + +tmph + +2*interval;
  } 
  if (ShowEditor) {
    cv.fillStyle = cbkgnd;  
    top = top + interval;  
    cv.fillRect(LengthNameTL, top, wdth, 3 * tmph);
    MyDrawEditor(cv, Width, Height, top, interval, 3 * tmph);
    top = +top + 3 * tmph + interval;
  }
  if (ShowTimelines) {
    for (var i=0; i<TLO.length; i++) {
      cv.fillStyle = cbkgnd;//smoothcolor(TLP.ForeGround, 8); 
      PosTimelines[i].top = +top + 3*interval;
      PosTimelines[i].bottom = +top + +tmph + 3*interval;
      cv.fillRect(LengthNameTL, top, wdth, tmph);
      MyDrawTimeline(cv, Width, Height, i, top, tmph)
      top = +top + +tmph + +interval;
    }
  } 
  cv.beginPath();  
  if (ShowScaler) {
    cv.moveTo(+LengthNameTL + +MyCursor, tmph); 
  } else {
    cv.moveTo(+LengthNameTL + +MyCursor, 0);  
  }  
  cv.lineTo(+LengthNameTL + +MyCursor, hght);
  cv.lineWidth = 1;
  cv.strokeStyle = "white";
  cv.stroke();
  cv.closePath(); 
  
  if (TLP.Start > StartFrm) {
    var strp = (TLP.Start - StartFrm) * FrameSize;
    cv.fillStyle = "white";
    cv.globalAlpha = .20;
    cv.fillRect(LengthNameTL, 0, strp, hght);
    cv.globalAlpha = 1;
  }
  
  if (TLP.Finish < FinishFrm) {
    var strp = (TLP.Finish - StartFrm) * FrameSize;
    cv.fillStyle = "white";
    cv.globalAlpha = .20;
    cv.fillRect(LengthNameTL + strp, 0, wdth - strp, hght);
    cv.globalAlpha = 1;
  }
}

function ChoiceTimelines(Y) {
  var res = -1;  
  var istl = false;
  if (typesrc < 4) { 
    if (ShowTimelines) { istl = true; };  
  };
  if (typesrc == 4) {
    if (isField(2)) { istl = true; };  
  }
  if (istl) {
    for (var i=0; i<TLT.length; i++) {
      if (Y > +TimelineCanvasTop + +PosTimelines[i].top 
          && Y < +TimelineCanvasTop + +PosTimelines[i].bottom) {
         res = i;
         break;
      }  
    }
  }
  return res;
}