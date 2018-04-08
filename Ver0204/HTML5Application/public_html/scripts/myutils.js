/* 
  * Created by Zavialov on 14.01.2018.
 */


"use strict"

function GetSeconds(ps,fn) {
  var scnd = Math.floor((fn - ps) / 25);
  
  var ost = (fn - ps) / 25;
  if (ost > 0) { scnd = scnd + 1}
  return scnd.toFixed();
}

function GetDevValues(ev) {
  var EvCount = TLT[ActiveTL].Count;
  //var Cnt = TLT.length;
  var Position = TLP.Position;
  var dv, cv, cev, scnd;
  for (var i=0; i < 32; i++) { DevValue[i] = -1; } 
  
  for (var j=+ev; j<+EvCount; j++) {
    cv = TLT[ActiveTL].Events[j].Rows[0].Phrases[0].Data;
    //cev = cv["Phrases0"];
    dv = cv;
    if (DevValue[dv-1] == -1) {
      if (+j !== +ev && +j !== +EvCount-1) {
         DevValue[dv-1] = GetSeconds(Position, TLT[ActiveTL].Events[j].Start);  
      } else { 
         DevValue[dv-1] = GetSeconds(Position, TLT[ActiveTL].Events[j].Finish);
      }
    }
  }
}

function GetCurrEvent() {
  var EvCount = TLT[ActiveTL].Count;
  var Position = TLP.Position;
  var strt, fnsh;
  var cv, cev; 
  var tl = Number(TLT[ActiveTL].TypeTL); 
  if (tl == 0) {
    for (var i=0; i<EvCount; i++) {
      strt = TLT[ActiveTL].Events[i].Start;
      fnsh = TLT[ActiveTL].Events[i].Finish;
      if (+Position >= +strt && +fnsh >= +Position) {
        CurrEvent = i;
        cv = TLT[ActiveTL].Events[i].Rows[0].Phrases[0].Data;
        //cev = cv["Phrases0"];
        CurrDevice = cv;
        if (i == EvCount-1) {
          NextDevice = CurrDevice;  
        } else {
          cv = TLT[ActiveTL].Events[i+1].Rows[0].Phrases[0].Data;
          //cev = cv["Phrases0"];
          NextDevice = cv;  
        }
        GetDevValues(i);
        break;
      }    
    }
  } else if (tl == 1) {
      
  } else if (tl == 2) {
      
  }
}

function GetScreenBorders() {
  //setViewport();
  var wdth = evCanvas.width;
  StartScrFrame = Math.floor(MyCursor / FrameSize);
  FinishScrFrame = Math.floor((wdth - LengthNameTL - MyCursor) / FrameSize); 
}

function TwoDigit(zn) {
  var s = zn;
  if (+zn < 10) {
    s = "0" + s;   
  }   
  return s;
}

function SecondsToString(scnd) {
 var HH = Math.floor(scnd / 3600);
 var MM = Math.floor(scnd % 3600);   
 var SS = Math.floor(MM % 60);
 var MM = Math.floor(MM / 60); 
 var s = "";
 if (HH !== 0) {
   s = HH;  
 }
 if (MM !== 0) {
   if (s !== "") {
     s = s + ":" + TwoDigit(MM); 
   } else {
     s = MM;  
   } 
 }
 if (SS !== 0) {
   if (s !== "") {
     s = s + ":" + TwoDigit(SS); 
   } else {
     s = ":" + TwoDigit(SS);  
   } 
 }
 return s;
}

function FramesToShortString(frm) {
  var HH, MM, SS, FF, dlt, fr;
  var st;
    if (frm < 0) {
      st = '-';
      fr = -1 * frm;
    } else { 
      st = '';
      fr = frm;
  }
    dlt = Math.floor(fr / 25);
    FF = Math.floor(fr % 25);
    HH = Math.floor(dlt / 3600);
    MM = Math.floor(dlt % 3600);
    SS = Math.floor(MM % 60);
    MM = Math.floor(MM / 60);
    if (HH !== 0) {
      st = st + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) +
        ':' + TwoDigit(FF);
      return st.toString();
    }
    if (MM !== 0) {
      st = st + TwoDigit(MM) + ':' + TwoDigit(SS) + ':' + TwoDigit(FF);
      return st.toString();
    }
    st = st + TwoDigit(SS) + ':' + TwoDigit(FF);
    return st.toString();
}

function FramesToSecondString(frm) {
  var HH, MM, SS, FF, dlt, fr;
  var st;
    if (frm < 0) {
      st = '-';
      fr = -1 * frm;
    } else { 
      st = '';
      fr = frm;
  }
    dlt = Math.floor(fr / 25);
    FF = Math.floor(fr % 25);
    HH = Math.floor(dlt / 3600);
    MM = Math.floor(dlt % 3600);
    SS = Math.floor(MM % 60);
    MM = Math.floor(MM / 60);
    if (HH !== 0) {
      st = st + HH + ':' + TwoDigit(MM) + ':' + TwoDigit(SS);
      return st.toString();
    }
    if (MM !== 0) {
      st = st + MM + ':' + TwoDigit(SS);
      return st.toString();
    }
    st = st + "0:" + TwoDigit(SS);
    return st.toString();
}


function FramesToStr(frm) {
  var ZN, HH, MM, SS, FF, dlt;
  var  znak;

  ZN = frm;
  znak = "";
  if (frm < 0) {
    znak = "-";
    ZN = -1 * ZN;
  }
  dlt = Math.floor(ZN / 25);
  FF = Math.floor(ZN % 25);
  HH = Math.floor(dlt / 3600);
  MM = Math.floor(dlt % 3600);
  SS = Math.floor(MM % 60);
  MM = Math.floor(MM / 60);
  var result = znak + TwoDigit(HH) + ':' + TwoDigit(MM) + ':' + TwoDigit(SS) +
      ':' + TwoDigit(FF);
  return result; 
}

function smoothcolor(Clr,step) {
   
   var result;
   var r = (Clr & 0xFF0000) >>16;
   var g = (Clr & 0xFF00) >>8;
   var b = Clr & 255;

    if (r >= g && r >= b) {
      if (r + step <= 255) {
        r = r + step;
        g = g + step;
        b = b + step;
      } else {
        if (r - step > 0) {
          r = r - step;
        } else {
          r = 0;
        }  
        if (g - step > 0) {
          g = g - step;
        } else {
          g = 0;
        }  
        if (b - step > 0) {
          b = b - step;
        } else {
          b = 0;
        }  
      }
      result =  0x1000000 + r + 0x100 * g + 0x10000 * b ;
      return '#'+result.toString(16).substr(1);
    }

    if (g >= r && g >= b) {
      if (g + step <= 255) {
        r = r + step;
        g = g + step;
        b = b + step;
      } else { 
        if (r - step > 0) {
          r = r - step;
        } else {
          r = 0;
        }  
        if (g - step > 0) {
          g = g - step;
        } else {
          g = 0;
        }  
        if (b - step > 0) {
          b = b - step;
        } else {
          b = 0;
        }  
      }
      result =  0x1000000 + r + 0x100 * g + 0x10000 * b ;
      return '#'+result.toString(16).substr(1);
    }

    if (b >= r && b >= g) {
      if (b + step <= 255) {
        r = r + step;
        g = g + step;
        b = b + step;
      } else { 
        if (r - step > 0) {
          r = r - step;
        } else {
          r = 0;
        }
        if (g - step > 0) {
          g = g - step;
        } else {
          g = 0;
        }  
        if (b - step > 0) {
          b = b - step;
        } else {
          b = 0;
        }  
      result =  0x1000000 + r + 0x100 * g + 0x10000 * b ;
      return '#'+result.toString(16).substr(1);
    }
}
}