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
  var dv, cv, cev, scnd, cnt1, cnt2;
  for (var i=0; i < 32; i++) { 
    DevValue[i] = -1; 
    ArrDev1[i] = -1;
    ArrDev2[i] = -1;
    cnt1 = 0;
    cnt2 = 0;
  } 
  
  for (var j=+ev; j<+EvCount; j++) {
    dv = TLT[ActiveTL].Events[j].Rows[0].Phrases[0].Data;
    //cev = cv["Phrases0"];
    //dv = cv;
    if (DevValue[dv-1] == -1) {
      if (+j !== +ev && +j !== +EvCount-1) {
         DevValue[dv-1] = GetSeconds(Position, TLT[ActiveTL].Events[j].Start);  
      } else { 
         DevValue[dv-1] = GetSeconds(Position, TLT[ActiveTL].Events[j].Finish);
      }
    }
    if (dv == Device1) {
      if (cnt1 < 32) {  
        ArrDev1[cnt1] = j;
        cnt1 = +cnt1 + 1;
      }
    }
    if (dv == Device2) {
      if (cnt2 < 32) {  
        ArrDev2[cnt2] = j;
        cnt2 = +cnt2 + 1;
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
  //StartScrFrame = Math.floor(MyCursor / FrameSize);
  //FinishScrFrame = Math.floor((wdth - LengthNameTL - MyCursor) / FrameSize); 
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
 //if (SS !== 0) {
   if (s !== "") {
     s = s + ":" + TwoDigit(SS); 
   } else {
     s = ":" + TwoDigit(SS);  
   } 
 //}
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

//function zpad(tt) {
//    var str = tt.toString();
//    while (str.length < 2) {
//        str = '0' + str;
//    }
//    return str;
//}

//function SecondToShortStr(frm) {
//    var fr, st;
//    if (frm < 0) {
//        st = '-';
//        fr = -1 * frm;
//    } else {
//        st = '';
//        fr = frm;
//    }

//    var h = parseInt(fr / 3600);
//    var m = parseInt((fr - h * 3600) / 60);
//    var s = parseInt(fr - h * 3600 - m * 60);
//  if (h!=0) {
//    return  st + zpad(h)+':'+zpad(m)+':'+zpad(s);
//  }
//  if (m!=0) {
//    return  st + ':'+zpad(m)+':'+zpad(s);
//  }
//    return  st + ':'+zpad(s);
//
//}

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

//Определение координат элемента на страницы
function getElementPosition(elemId) {
    var elem = typeof elemId == 'object' ? elemId : document.getElementById(elemId);
 
    var w = elem.offsetWidth;
    var h = elem.offsetHeight;
 
    var l = 0;
    var t = 0;
 
    while (elem)
    {
        l += elem.offsetLeft;
        t += elem.offsetTop;
        elem = elem.offsetParent;
    }
 
    return {"left":l, "top":t, "width": w, "height":h};
}
 
//Определение текущих координат указателя мыши
function mousePageXY(e) {
  var x = 0, y = 0;
 
  if (!e) e = window.event;
 
  if (e.pageX || e.pageY) {
    x = e.pageX;
    y = e.pageY;
  }
  else if (e.clientX || e.clientY) {
    x = e.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)
                  - document.documentElement.clientLeft;
    y = e.clientY + (document.documentElement.scrollTop || document.body.scrollTop) 
                  - document.documentElement.clientTop;
  }
 
  return {"left":x, "top":y};
}

function myTextDraw(cv, Text, Left, OffsetX, Width, Top, Height) {
  var lentext = cv.measureText(Text).width;//textWidth(Text, cv) + 2 * OffsetX;
  var fnwidth = cv.measureText(Text).width;
  var fnheight = Height;//metrics.width; 
  //var delx = 1;
  //if (OffsetX !== 0) { delx = OffsetX; } 
  var XLeft = Math.floor(OffsetX / 10) * 10;
  var kx = (Width - 2*XLeft)/fnwidth;
  var ky = Height/fnheight;
  cv.save();
  cv.scale((Width - 2*XLeft)/fnwidth, Height/fnheight);
  cv.fillText(Text, (+Left + +OffsetX)/kx, (+Top + Height/2)/ky);
  cv.restore();  
  cv.scale(1, 1);      
}

function rectRound(cv, x, y, wdt, hgh, rds, color1, color2) {
  cv.beginPath();
  cv.fillStyle = color1;
  cv.strokeStyle = color2;
  cv.moveTo(x+rds, y);
  cv.lineTo(x+wdt-rds, y);
  cv.quadraticCurveTo(x+wdt, y, x+wdt, y+rds);
  cv.lineTo(x+wdt, y+hgh-rds);
  cv.quadraticCurveTo(x+wdt, y+hgh, x+wdt-rds, y+hgh);
  cv.lineTo(x+rds, y+hgh);
  cv.quadraticCurveTo(x, y+hgh, x, y+hgh-rds);
  cv.lineTo(x, y+rds);
  cv.quadraticCurveTo(x, y, x+rds, y);
  cv.stroke();
  cv.closePath();
  cv.fill();  
}

function drawToolBar(cv,Width,Height) {
  var MColor = ProgrammColor; 
  var SColor = smoothcolor(ProgrammColor,128);
  var lwdt = cv.lineWidth;
  var font0 = Math.floor((Height-8) / 2) +  "pt Arial";
  var font1 = Math.floor(Height / 2) +  "pt Arial";
  var font2 = Math.floor(Height / 5 * 2) +  "pt Arial";
  
  var stepw = Height;
  
  if (Width < 24*Height + 40) {
    stepw = (Width - 40 - 5 * Height) / 19; 
  }
  
  cv.font = font0;//Math.floor((Height-8) / 2) +  "pt Arial";
  
  cv.lineWidth = 4;
  RectSound[0] = 20
  RectSound[1] = 4;
  RectSound[2] = 20 + Height;
  RectSound[3] = Height-10;
  if (mnSoundSelect) {
    rectRound(cv, 20, 4, Height, Height-10, (Height-10)/2, SColor, "white");  
  } else {
    rectRound(cv, 20, 4, Height, Height-10, (Height-10)/2, MColor, "white");
  }
  var dlty = (Height-10) / 5;
  var dltx = (Height - 2 * dlty) / 2 - dlty/2-2;
  cv.lineWidth = 1;
  cv.beginPath();
  cv.strokeStyle = "white";
  cv.fillStyle = "white";
  cv.moveTo(20+dltx, 4+2*dlty);
  cv.lineTo(20+dltx+dlty, 4+2*dlty);
  cv.lineTo(20+dltx+2*dlty, 4+dlty);
  cv.lineTo(20+dltx+2*dlty, 4+4*dlty);
  cv.lineTo(20+dltx+dlty, 4+3*dlty);
  cv.lineTo(20+dltx, 4+3*dlty);
  cv.lineTo(20+dltx, 4+2*dlty);
  cv.stroke();
  cv.closePath();
  cv.fill();
  cv.lineWidth = 4;
  
  //text="x";
  cv.textBaseline = "middle"; 
  cv.textAlign  = "left";
  if (AudioOn) {
    cv.fillText("))", 21+dltx+2*dlty, 2 + (Height-8) / 2);  
  } else {
    cv.fillText("x", 21+dltx+2*dlty, 2 + (Height-8) / 2);  
  }
  
  
  cv.textBaseline = "middle"; 
  cv.textAlign  = "center";
  cv.fillStyle = "white";
  cv.font = font2;//Math.floor(Height/2) +  "pt Arial";
  
  //var text = "00000";
  var otstup = 20 + +Height + 1.5*stepw;//cv.measureText(text).width;
  cv.textAlign  = "left";
  var text = "Размер кадра";
  var len = cv.measureText(text).width;
  if (len < 3.5 * stepw-5) {
    cv.fillText(text, otstup, 3 + (Height-10) / 2);  
  } else {
    myTextDraw(cv, text, otstup, 0, 3.5 * stepw-5, 3, Height-10); 
  }
  //cv.fillText(text, otstup + Height/2, 3 + (Height-10) / 2);
  
  otstup = +otstup + 3.5 * stepw + 5;
  cv.font = font1;
  
  RectMinus[0] = otstup;
  RectMinus[1] = 3;
  RectMinus[2] = otstup + Height;
  RectMinus[3] = Height-10;
  
  if (mnMinusSelect) {
    rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, SColor, "white");
  } else {
    rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, MColor, "white");
  }
  
  
  cv.fillStyle = "white";
  cv.textAlign  = "center";
  cv.fillText("-", +otstup + Height/2 , 2 + (Height-10) / 2);
  
  cv.font = font2;
  otstup = otstup + Height;
  
  var text = FrameSize + "px";
  var len = cv.measureText(text).width;
  if (len < 2 * stepw - 4) {
    //cv.fillText(text, otstup, 3 + (Height-10) / 2); 
    cv.fillText(text, +otstup  + +stepw, 3 + (Height-10) / 2);
  } else {
    cv.textAlign  = "left";  
    myTextDraw(cv, text, otstup, 2, 2*stepw - 4, 3, Height-10); 
  }

  //cv.fillText(FrameSize + "px", +otstup  + +Height, 3 + (Height-10) / 2);
  
  otstup = +otstup + 2*stepw;
  
  cv.font = font1;
  
  RectPlus[0] = otstup;
  RectPlus[1] = 3;
  RectPlus[2] = otstup + Height;
  RectPlus[3] = Height-10;
  
  if (mnPlusSelect) {
    rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, SColor, "white");
  } else {
    rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, MColor, "white");
  }
  
  //rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, ProgrammColor, "white");
  cv.fillStyle = "white";
  cv.textAlign  = "center";
  cv.fillText("+", otstup + Height/2, 3 + (Height-10) / 2);
  
  otstup = +otstup + +Height + 1.5*stepw;//cv.measureText("00000").width;
  cv.font = font2;
  cv.textAlign  = "left";
  text = "Высота тайм-линии";
  var len = cv.measureText(text).width;
  if (len < 5 * stepw-5) {
    cv.fillText(text, otstup, 3 + (Height-10) / 2);  
  } else {
    myTextDraw(cv, text, otstup, 0, 5 * stepw-5, 3, Height-10); 
  }
  otstup = +otstup + 5 * stepw + 5;
  
  cv.font = font1;
  cv.textAlign  = "center";
  
  RectDown[0] = otstup;
  RectDown[1] = 3;
  RectDown[2] = otstup + Height;
  RectDown[3] = Height-10;
  
  if (mnDownSelect) {
    rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, SColor, "white");
  } else {
    rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, MColor, "white");
  }
  
  //rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, ProgrammColor, "white");
  cv.fillStyle = "white";
  cv.fillText("-", otstup + Height/2, 2 + (Height-10) / 2);
  
  cv.font = font2;
  otstup = otstup + Height;
  
  var text = TimeLineHeight + "px";
  var len = cv.measureText(text).width;
  if (len < 2 * stepw - 4) {
    cv.fillText(text, +otstup  + +stepw, 3 + (Height-10) / 2);
  } else {
    cv.textAlign  = "left";  
    myTextDraw(cv, text, otstup, 2, 2*stepw - 4, 3, Height-10); 
  }

  cv.font = font2;
  otstup = +otstup + 2*stepw;
  
  RectUp[0] = otstup;
  RectUp[1] = 3;
  RectUp[2] = otstup + Height;
  RectUp[3] = Height-10;
  
  if (mnUpSelect) {
    rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, SColor, "white");
  } else {
    rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, MColor, "white");
  }
  
  //rectRound(cv, otstup, 3, Height, Height-10, (Height-10)/2, ProgrammColor, "white");
  cv.fillStyle = "white";
  cv.textAlign  = "center";
  cv.fillText("+", otstup + Height/2, 3 + (Height-10) / 2);
  cv.lineWidth = lwdt;
}