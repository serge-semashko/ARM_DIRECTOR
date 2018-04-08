/* 
  * Created by Zavialov on 14.01.2018.
 */

function DrawAllTimelines() {
  var CountTL = TLT.length;
  var wdth = tvCanvas.width;
  var WidthTL = wdth - LengthNameTL;
  var hght = tvCanvas.height;
  var hghtl = hght / CountTL;
  var start = TLP.Preroll;
  var finish = TLP.Finish;
  var duration = TLP.Duration;
  var kfx = WidthTL / (finish - start);
  var top = 0;
  tlcv.fillStyle = rgbFromNum(TLP.BackGround);
  tlcv.fillRect(0, 0, wdth, hght);
  
  var lft, wdt, clr, evstr, evfin, tptl;
  for (var i=0; i<CountTL; i++) {
    tlcv.fillStyle = rgbFromNum(TLP.ForeGround);  
    tlcv.fillRect(LengthNameTL, top+1, wdth, hghtl-1);
    if (finish > duration) {
      wdt = (finish - duration) * kfx;
      lft = duration * kfx;
      tlcv.fillStyle = smoothcolor(TLP.ForeGround,80);
      tlcv.globalAlpha = .25;
      tlcv.fillRect(LengthNameTL + lft, top+1, wdt, hghtl-1);
      tlcv.globalAlpha = 1;
    }
    tptl = Number(TLT[i].TypeTL);
    if (tptl == 0) {
      for (var j=0; j<TLT[i].Count; j++) {
        tlcv.fillStyle = rgbFromNum(TLT[i].Events[j].Color);
        lft = (TLT[i].Events[j].Start - TLP.Preroll) * kfx;
        wdt = (TLT[i].Events[j].Finish - TLT[i].Events[j].Start) * kfx;
        tlcv.fillRect(LengthNameTL + lft, top+2, wdt, hghtl-2);  
      }  
    } else if (tptl == 1) {
      tlcv.fillStyle = rgbFromNum(TLO[i].TextEvent.Color);  
      for (var j=0; j<TLT[i].Count; j++) {
        lft = (TLT[i].Events[j].Start - TLP.Preroll) * kfx;
        wdt = (TLT[i].Events[j].Finish - TLT[i].Events[j].Start) * kfx;
        tlcv.fillRect(LengthNameTL + lft, top+2, wdt, hghtl-2);  
      }  
    } else if (tptl == 2) {
      //for (var j=0; j<TLT[i].Count; j++) {
        tlcv.fillStyle = rgbFromNum(TLO[i].MediaEvent.Color);
        wdt = TLP.Duration * kfx;
        tlcv.fillRect(LengthNameTL, top+2, wdt, hghtl-2); 
      for (var j=0; j<TLT[i].Count; j++) {  
      }  
    }
    top = top + hghtl;
  }
  tlcv.fillStyle = "black";
  tlcv.globalAlpha = .5;
  var pst = (TLP.Position - TLP.Preroll) * kfx;
  var bfr = (MyCursor / FrameSize) * kfx;
  var scrfrm = ((wdth - LengthNameTL) / FrameSize) * kfx; 
  tlcv.fillRect(LengthNameTL + pst-bfr, 0, scrfrm, hght);
  tlcv.globalAlpha = 1;
  tlcv.beginPath();  
  tlcv.moveTo(LengthNameTL + pst, 0);  
  tlcv.lineTo(LengthNameTL + pst, +hght);
  tlcv.lineWidth = 1;
  tlcv.strokeStyle = "white";
  tlcv.stroke();
  tlcv.closePath();
  
  tlcv.fillStyle = rgbFromNum(TLP.ForeGround);  
  tlcv.fillRect(0, 0, LengthNameTL, hght);
    
}

function DrawTimeLineNames() {
  var hght = edCanvas.height;
  edcv.fillStyle = rgbFromNum(TLP.BackGround);
  edcv.fillRect(0, 0, LengthNameTL, hght);
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
  edcv.fillStyle = rgbFromNum(TLP.ForeGround);
  //for (var i=0; i<CountLine; i++) {
  var text, se, sev;
  if (ShowScaler) {
    edcv.fillRect(0, top, LengthNameTL, tmph);
    top = top + tmph + interval;
  } 
  if (ShowEditor) {
    top = top + 2 * interval;  
    edcv.fillRect(0, top, LengthNameTL, 3 * tmph);
    text = TLO[ActiveTL].Name;
    text = text.replace('#$%#$%', ' ');
    var fs = Math.floor(tmph / 2);
    
    edcv.font = fs + "pt Arial";
    edcv.fillStyle = cfont;
    edcv.strokeStyle = cfont;
    edcv.textBaseline = "middle";
    edcv.textAlign  = "left";
    edcv.fillText(text, 10, top+1.5*tmph);
    
    top = top + 3 * tmph + interval;
  }
  if (ShowTimelines) { 
    for (var i=0; i<TLO.length; i++) {
      edcv.fillStyle = rgbFromNum(TLP.ForeGround);  
      edcv.fillRect(0, top, LengthNameTL, tmph);
      text = TLO[i].Name;
      var fs = Math.floor(tmph / 2);
      edcv.font = fs + "pt Arial";
      edcv.fillStyle = cfont;
      edcv.textBaseline = "middle";
      edcv.textAlign  = "left";
      text = text.replace('#$%#$%', ' ');
      edcv.fillText(text, 10, top+tmph/2);
      top = top + tmph + interval;
    }
  }
}

function MyDrawScaler(hght) {
  var wdth = evCanvas.width;
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
      edcv.beginPath();  
      edcv.moveTo(stp, hh);  
      edcv.lineTo(stp, hght);
      edcv.lineWidth = 1;
      edcv.strokeStyle = "white";
      edcv.stroke();
      edcv.closePath(); 
    }   
    
    if (hh == hsec) {
      //text = FramesToShortString(SValue); 
      text = FramesToSecondString(StartFrm + i);
      //fs = Math.floor(hsec / 2);
      edcv.font = smallFont;//fs + "pt Arial";
      edcv.fillStyle = cfont;
      edcv.textBaseline = "middle";
      edcv.textAlign  = "left";
      edcv.fillText(text, stp+1, hfrm/2);  
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

function MyDrawEditor(Top, Intrvl, Hght) {
  var wdth = evCanvas.width;
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
        edcv.fillStyle = evColor;
        edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
                  
        if (evmix == "Mix" || evmix == "Wipe") {
          edcv.beginPath();  
          edcv.moveTo(+LengthNameTL + strtev, Top);  
          edcv.lineTo(+LengthNameTL + strtev, Top + Hght);
          edcv.lineTo(+LengthNameTL + strtev + evmixdur, Top + Hght);
          edcv.lineTo(+LengthNameTL + strtev, Top);
          edcv.lineWidth = 1;
          edcv.fillStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          edcv.strokeStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          edcv.stroke();
          //edcv.fill;
          edcv.closePath(); 
          edcv.fill();
          edcv.globalAlpha = 1;
        }  
        edcv.beginPath();
        edcv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        edcv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        edcv.fillRect(+LengthNameTL + strtev, Top, evSafeZone, Hght)
        edcv.stroke();
        edcv.closePath();
        edcv.globalAlpha = 1;
              
        edcv.font = smallFont;
        edcv.fillStyle = cfont;
        edcv.textBaseline = "middle"; 
        edcv.textAlign  = "left";
        evst = TLT[ActiveTL].Events[i].Start - TLP.ZeroPoint;
        evdur = TLT[ActiveTL].Events[i].Finish - TLT[ActiveTL].Events[i].Start;
        uptext = FramesToShortString(evst) + " [" + FramesToShortString(evdur) + "]";
        
        edcv.fillText(uptext, +LengthNameTL + strtev, Top - Intrvl);
        
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
                //if (evtext == "") {
                //  evtext = evdata;  
                // }
                edcv.font = evfntsz;//fs + "pt Arial";
                if (evname == "Comment") {
                  if (evtext.charAt(0) == "#") {
                    edcv.fillStyle = "yellow";  
                  } else { 
                    edcv.fillStyle = evFontColor;//cfont;
                  }
                } else {
                  edcv.fillStyle = evFontColor;  
                }
                edcv.textBaseline = "bottom";//"middle"; 
                edcv.textAlign  = "left";
                evlft = +evlft + +LengthNameTL + +strtev

                if (j == 0) {
                  edcv.fillText(evtext, +evlft, Top + 1.5 * rowheight);
                } else {
                  edcv.fillText(evtext, +evlft, Top + 1.5 * rowheight + rowheight*j);  
                }               
              }
            }   
          }
        }
        if (+TLP.Position >= +evstart && +TLP.Position <= +evstart + +evSafeZone) {
          edcv.fillStyle = "white";
          edcv.globalAlpha = .75;
          edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
          edcv.globalAlpha = 1;  
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
        
        edcv.fillStyle = evColor;
        edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght); 
        
        edcv.beginPath();
        edcv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        edcv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        edcv.fillRect(+LengthNameTL + strtev, Top, evSafeZone, Hght)
        edcv.stroke();
        edcv.closePath();
        edcv.globalAlpha = 1;
        
        edcv.beginPath();
        edcv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        edcv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        edcv.fillRect(+LengthNameTL + fnshev - evSafeZone, Top, evSafeZone, Hght)
        edcv.stroke();
        edcv.closePath();
        edcv.globalAlpha = 1;
                
        edcv.font = smallFont;
        edcv.fillStyle = cfont;
        edcv.textBaseline = "middle"; 
        edcv.textAlign  = "left";
        evst = TLT[ActiveTL].Events[i].Start - TLP.ZeroPoint;
        evdur = TLT[ActiveTL].Events[i].Finish - TLT[ActiveTL].Events[i].Start;
        uptext = FramesToShortString(evst) + " [" + FramesToShortString(evdur) + "]";
        
        edcv.fillText(uptext, +LengthNameTL + strtev, Top - Intrvl);
        
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

                edcv.font = evfntsz;//fs + "pt Arial";
                if (evname == "Comment") {
                  if (evtext.charAt(0) == "#") {
                    edcv.fillStyle = "yellow";  
                  } else { 
                    edcv.fillStyle = evFontColor;//cfont;
                  }
                } else {
                  edcv.fillStyle = evFontColor;  
                }
                edcv.textBaseline = "middle"; 
                edcv.textAlign  = "left";
                evlft = +evlft + +LengthNameTL + +strtev

                if (j == 0) {
                  var fnwidth = edcv.measureText(evtext).width;
                  var metrics = edcv.measureText("M");
                  var fnheight =   metrics.width;  
                  var kx = wdthev/fnwidth;
                  var ky = rowheight/fnheight;
                  edcv.save();
                  edcv.scale(wdthev/fnwidth, rowheight/fnheight);
                  edcv.fillText(evtext, +evlft/kx, (+Top + rowheight)/ky);
                  edcv.restore();  
                  edcv.scale(1, 1);  
                  //edcv.fillText(evtext, +evlft, Top + 1.5 * rowheight);
                } else {
                  edcv.fillText(evtext, +evlft, Top + 1.5 * rowheight + rowheight*j);  
                }               
              }
            }   
          }
        }
        if (+TLP.Position >= +evstart && +TLP.Position <= +evstart + +evSafeZone) {
          edcv.fillStyle = "white";
          edcv.globalAlpha = .75;
          edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
          edcv.globalAlpha = 1;  
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
   
    edcv.fillStyle = evColor;
    edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
    
    //evlft = +LengthNameTL + +MyCursor - (TLP.Position-StartFrm) * FrameSize + 2;
    //var CurrOst = Math.floor(MyCursor % FrameSize);
    evlft = +LengthNameTL + +MyCursor;//FrameSize - Math.floor(MyCursor % FrameSize);
    evst = Math.floor(ScreenFrm / 25);
    evwdt = 25 * FrameSize;
    
    for (var i=0; i<=ScreenFrm-CurrFrm; i++) {
      edcv.beginPath();  
      edcv.moveTo(+evlft, Top);  
      edcv.lineTo(+evlft, Top + Hght);
      edcv.lineWidth = 1;
      edcv.strokeStyle = "white";
      edcv.stroke();
      edcv.closePath();  
      evlft = evlft + evwdt;
    }
    evlft = +LengthNameTL + +MyCursor;
    for (var i=0; i<=CurrFrm; i++) {
      edcv.beginPath();  
      edcv.moveTo(+evlft, Top);  
      edcv.lineTo(+evlft, Top + Hght);
      edcv.lineWidth = 1;
      edcv.strokeStyle = "white";
      edcv.stroke();
      edcv.closePath();  
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
         
        
        edcv.fillStyle = evColor;
        
        edcv.beginPath();  
        edcv.moveTo(+evlft, Top + Hght);  
        edcv.lineTo(+evlft, Top);
        edcv.lineTo(+evlft + +SafeZone, Top + +SafeZone/2);
        edcv.lineTo(+evlft, Top + +SafeZone);
        edcv.lineWidth = 1;
        edcv.strokeStyle = evColor;
        edcv.stroke();
        edcv.closePath();
        edcv.fill();
        
        edcv.font = smallFont;
        edcv.fillStyle = cfont;
        edcv.textBaseline = "middle"; 
        edcv.textAlign  = "left";
        evst = TLT[ActiveTL].Events[i].Start - TLP.ZeroPoint;
        uptext = FramesToShortString(evst);
        
        edcv.fillText(uptext, +LengthNameTL + strtev, Top - Intrvl);
        
        kfh = TLT[ActiveTL].Events[i].Count;
        if (+kfh > 0) {
          rowheight = textHeight(edcv);//Hght / (+kfh + 1);
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

                edcv.font = smallFont;//evfntsz;//fs + "pt Arial";
                if (evname == "Comment") {
                  if (evtext.charAt(0) == "#") {
                    edcv.fillStyle = "yellow";  
                  } else { 
                    edcv.fillStyle = evFontColor;//cfont;
                  }
                } else {
                  edcv.fillStyle = evFontColor;  
                }
                edcv.textBaseline = "middle"; 
                edcv.textAlign  = "left";
                evlft = +evlft + +LengthNameTL + +strtev
                edcv.fillText(evtext, +evlft, +Top + rowheight*j);  
              }
            }   
          }
        }
      }  
    }
  }
} 

function MyDrawTimeline(PosTL, Top, Hght) {
  var wdth = evCanvas.width;
  var WidthTL = wdth - LengthNameTL;
  var ScreenFrm = Math.floor(WidthTL / FrameSize);
  var CurrFrm = Math.floor(MyCursor / FrameSize);
  var StartFrm = TLP.Position - CurrFrm;
  var FinishFrm = StartFrm + ScreenFrm;
  var sev, fev, evstart, evfinish, strtev, fnshev, wdthev, uptext;
  var evColor, evFontColor, evFontSize, evFontSizeSub, evFontName, evSafeZone; 
  var evtext, evdata ,evmix, evmixdur, evname, evsmoothcolor;
  var evlft, evwdt, evworkdata, evfntsz, evst, evdur;
  var tptl = Number(TLT[PosTL].TypeTL);
  
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
        edcv.fillStyle = evColor;
        edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
        
        if (evmix == "Mix" || evmix == "Wipe") {
          edcv.beginPath();  
          edcv.moveTo(+LengthNameTL + strtev, Top);  
          edcv.lineTo(+LengthNameTL + strtev, Top + Hght);
          edcv.lineTo(+LengthNameTL + strtev + evmixdur, Top + Hght);
          edcv.lineTo(+LengthNameTL + strtev, Top);
          edcv.lineWidth = 1;
          edcv.fillStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          edcv.strokeStyle = "rgba(255,255,255,.15)";//evsmoothcolor;
          edcv.stroke();
          //edcv.fill;
          edcv.closePath(); 
          edcv.fill();
          edcv.globalAlpha = 1;
        }  
        edcv.beginPath();
        edcv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        edcv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        edcv.fillRect(+LengthNameTL + strtev, Top, evSafeZone, Hght)
        edcv.stroke();
        edcv.closePath();
        edcv.globalAlpha = 1;
               
//=========================              
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
                //if (evtext == "") {
                //  evtext = evdata;  
                // }
            edcv.font = evfntsz;//fs + "pt Arial";
            if (evname == "Comment") {
              if (evtext.charAt(0) == "#") {
                edcv.fillStyle = "yellow";  
              } else { 
                edcv.fillStyle = evFontColor;//cfont;
              }
            } else {
              edcv.fillStyle = evFontColor;  
            }
            edcv.textBaseline = "middle"; 
            edcv.textAlign  = "left";
            evlft = +evlft + +LengthNameTL + +strtev

            edcv.fillText(evtext, +evlft, Top + Hght/2);
                           
          }
        }  
//============================== 
        if (PosTL == ActiveTL) {
          if (+TLP.Position >= +evstart && +TLP.Position <= +evstart + +evSafeZone) {
            edcv.fillStyle = "white";
            edcv.globalAlpha = .75;
            edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
            edcv.globalAlpha = 1;  
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
        
        edcv.fillStyle = evColor;
        edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght); 
        edcv.beginPath();
        edcv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        edcv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        edcv.fillRect(+LengthNameTL + strtev, Top, evSafeZone, Hght)
        edcv.stroke();
        edcv.closePath();
        edcv.globalAlpha = 1;
        
        edcv.beginPath();
        edcv.fillStyle = "rgba(0,0,0,.15)";//evsmoothcolor;
        edcv.strokeStyle = "rgba(0,0,0,.75)";//evsmoothcolor;
        edcv.fillRect(+LengthNameTL + fnshev - evSafeZone, Top, evSafeZone, Hght)
        edcv.stroke();
        edcv.closePath();
        edcv.globalAlpha = 1;
        
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

            edcv.font = evfntsz;//fs + "pt Arial";
            if (evname == "Comment") {
              if (evtext.charAt(0) == "#") {
                edcv.fillStyle = "yellow";  
              } else { 
                edcv.fillStyle = evFontColor;//cfont;
              }
            } else {
              edcv.fillStyle = evFontColor;  
            }
            edcv.textBaseline = "middle"; 
            edcv.textAlign  = "left";
            evlft = +evlft + +LengthNameTL + +strtev

                
            var fnwidth = edcv.measureText(evtext).width;
            var metrics = edcv.measureText("M");
            var fnheight =   metrics.width;  
            var kx = wdthev/fnwidth;
            var ky = (Hght/2)/fnheight;
            edcv.save();
            edcv.scale(wdthev/fnwidth, (Hght/2)/fnheight);
            edcv.fillText(evtext, +evlft/kx, (+Top + Hght/2)/ky);
            edcv.restore();  
            edcv.scale(1, 1);  
          }
        }   
//================================  
        if (PosTL == ActiveTL) {
          if (+TLP.Position >= +evstart && +TLP.Position <= +evstart + +evSafeZone) {
            edcv.fillStyle = "white";
            edcv.globalAlpha = .75;
            edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
            edcv.globalAlpha = 1;  
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
   
    edcv.fillStyle = evColor;
    edcv.fillRect(+LengthNameTL + strtev, Top, wdthev, Hght);
    
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
         
        
        edcv.fillStyle = evColor;
        
        edcv.beginPath();  
        edcv.moveTo(+evlft, Top + Hght);  
        edcv.lineTo(+evlft, Top);
        edcv.lineTo(+evlft + +SafeZone/2, Top + +SafeZone/4);
        edcv.lineTo(+evlft, Top + +SafeZone/2);
        edcv.lineWidth = 1;
        edcv.strokeStyle = evColor;
        edcv.stroke();
        edcv.closePath();
        edcv.fill();
            
      }  
    }
  }
} 

function DrawTimeLines() {
  var hght = edCanvas.height;
  var wdth = edCanvas.width - LengthNameTL;
//===================================
  //var wdth = evCanvas.width;
  //var WidthTL = wdth - LengthNameTL;
  var ScreenFrm = Math.floor(wdth / FrameSize);
  var CurrFrm = Math.floor(MyCursor / FrameSize);
  var StartFrm = TLP.Position - CurrFrm;
  var FinishFrm = StartFrm + ScreenFrm;
//===================================
  //var Frames
  edcv.fillStyle = rgbFromNum(TLP.BackGround);
  edcv.fillRect(LengthNameTL, 0, wdth, hght);
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
  edcv.fillStyle = cbkgnd; //rgbFromNum(TLP.ForeGround);
  //for (var i=0; i<CountLine; i++) {
  var text, se, sev;
  if (ShowScaler) {
    edcv.fillRect(LengthNameTL, top, wdth, tmph);
    MyDrawScaler(tmph);
    top = top + tmph + interval;
  } 
  if (ShowEditor) {
    edcv.fillStyle = cbkgnd;  
    top = top + 2 * interval;  
    edcv.fillRect(LengthNameTL, top, wdth, 3 * tmph);
    MyDrawEditor(top, interval, 3 * tmph);
    top = top + 3 * tmph + interval;
  }
  if (ShowTimelines) {
    for (var i=0; i<TLO.length; i++) {
      edcv.fillStyle = cbkgnd;//smoothcolor(TLP.ForeGround, 8);  
      edcv.fillRect(LengthNameTL, top, wdth, tmph);
      MyDrawTimeline(i, top, tmph)
      top = top + tmph + interval;
    }
  } 
  edcv.beginPath();  
  edcv.moveTo(+LengthNameTL + +MyCursor, tmph);  
  edcv.lineTo(+LengthNameTL + +MyCursor, hght);
  edcv.lineWidth = 1;
  edcv.strokeStyle = "white";
  edcv.stroke();
  edcv.closePath(); 
  
  if (TLP.Start > StartFrm) {
    var strp = (TLP.Start - StartFrm) * FrameSize;
    edcv.fillStyle = "white";
    edcv.globalAlpha = .20;
    edcv.fillRect(LengthNameTL, 0, strp, hght);
    edcv.globalAlpha = 1;
  }
  
  if (TLP.Finish < FinishFrm) {
    var strp = (TLP.Finish - StartFrm) * FrameSize;
    edcv.fillStyle = "white";
    edcv.globalAlpha = .20;
    edcv.fillRect(LengthNameTL + strp, 0, wdth - strp, hght);
    edcv.globalAlpha = 1;
  }
}