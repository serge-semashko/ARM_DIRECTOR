"use strict";

var OldEvent = -1;

function getPhraseSecconds(cnt, len) {
  var res = "";
  var scnd = cnt - len;
  if (scnd > 0) {
    if (scnd == 1) {
      res = "одна секунда";  
    } else if (scnd > 1 && scnd <= 4) {
      if (scnd == 2) { res = " две секунды"; };
      if (scnd == 3) { res = " три секунды"; };
      if (scnd == 4) { res = " четыре секунды"; };
      //if (scnd == 5) { res = " две секунды"; };
      //res = scnd + " секунды";  
    } else {
      res = scnd + " секунд";  
    }    
  }
  return res
}

function getDigitsString(val, mode) {
  var stext = "";
  var sdigits = "";
  var thousands = Math.floor(val / 1000);
  var hh = Math.floor(val % 1000);
  var hundreds = Math.floor(hh / 100);
  hh = Math.floor(hh % 100);
  var tens = Math.floor(hh / 10);
  var ones = Math.floor(hh % 10);
  
  if (thousands > 0) {
    stext = "тысяча";
    sdigits = "1000.wav";
  }
  if (hundreds > 0) {
    if (stext !== "") { 
      stext = stext + " ";
      sdigits = sdigits + ", ";
    }  
    if (hundreds == 1) {
      stext = stext + "сто";
      sdigits = sdigits + "100.wav";  
    } else if (hundreds == 2) {
      stext = stext + "двести";
      sdigits = sdigits + "200.wav";  
    } else if (hundreds == 3) {
      stext = stext + "триста";
      sdigits = sdigits + "300.wav";  
    } else if (hundreds == 4) {
      stext = stext + "четыреста";
      sdigits = sdigits + "400.wav";  
    } else if (hundreds == 5) {
      stext = stext + "пятьсот";
      sdigits = sdigits + "500.wav";  
    } else if (hundreds == 6) {
      stext = stext + "шестьсот";
      sdigits = sdigits + "600.wav";  
    } else if (hundreds == 7) {
      stext = stext + "семьсот";
      sdigits = sdigits + "700.wav";  
    } else if (hundreds == 8) {
       stext = stext + "восемьсот";
      sdigits = sdigits + "800.wav"; 
    } else if (hundreds == 9) {
      stext = stext + "девятьсот";
      sdigits = sdigits + "900.wav";  
    }
  }
  if (tens > 0) {
    if (stext !== "") { 
      stext = stext + " ";
      sdigits = sdigits + ", ";
    } 
    
    if (tens == 1) {
      if (ones == 0) {
        stext = stext + "десять";
        sdigits = sdigits + "10.wav";  
      } else if (ones == 1) {
        stext = stext + "одинаддцать";
        sdigits = sdigits + "11.wav";  
      } else if (ones == 2) {
        stext = stext + "двенадцать";
        sdigits = sdigits + "12.wav";  
      } else if (ones == 3) {
        stext = stext + "тринадцать";
        sdigits = sdigits + "13.wav";  
      } else if (ones == 4) {
        stext = stext + "четырнадцать";
        sdigits = sdigits + "14.wav";  
      } else if (ones == 5) {
        stext = stext + "пятнадцать";
        sdigits = sdigits + "15.wav";  
      } else if (ones == 6) {
        stext = stext + "шестнадцать";
        sdigits = sdigits + "16.wav";  
      } else if (ones == 7) {
        stext = stext + "семнадцать";
        sdigits = sdigits + "17.wav";  
      } else if (ones == 8) {
        stext = stext + "восемнадцать";
        sdigits = sdigits + "18.wav";  
      } else if (ones == 9) {
        stext = stext + "девятнадцать";
        sdigits = sdigits + "19.wav";  
      }
    } else {  
      if (tens == 2) {
        stext = stext + "двадцать";
        sdigits = sdigits + "20.wav";  
      } else  if (tens == 3) {
        stext = stext + "тридцать";
        sdigits = sdigits + "30.wav";  
      } else  if (tens == 4) {
        stext = stext + "сорок";
        sdigits = sdigits + "40.wav";  
      } else  if (tens == 5) {
        stext = stext + "пятьдесят";
        sdigits = sdigits + "50.wav";  
      } else  if (tens == 6) {
        stext = stext + "шестьдесят";
        sdigits = sdigits + "60.wav";  
      } else  if (tens == 7) {
        stext = stext + "семьдесят";
        sdigits = sdigits + "70.wav";  
      } else  if (tens == 8) {
        stext = stext + "восемьдесят";
        sdigits = sdigits + "80.wav";  
      } else  if (tens == 9) {
        stext = stext + "девяносто";
        sdigits = sdigits + "90.wav";  
      }
//==================================================================
      if (ones !== 0) { 
        if (stext !== "") { 
          stext = stext + " ";
          sdigits = sdigits + ", ";
        }   
        if (ones == 1) {
          stext = stext + "один";
          sdigits = sdigits + "1.wav"    
        } else if (ones == 2) {
          stext = stext + "два";
          sdigits = sdigits + "2.wav"    
        } else if (ones == 3) {
          stext = stext + "три";
          sdigits = sdigits + "3.wav"    
        } else if (ones == 4) {
          stext = stext + "четыре";
          sdigits = sdigits + "4.wav"    
        } else if (ones == 5) {
          stext = stext + "пять";
          sdigits = sdigits + "5.wav"    
        } else if (ones == 6) {
          stext = stext + "шесть";
          sdigits = sdigits + "6.wav"    
        } else if (ones == 7) {
          stext = stext + "семь";
          sdigits = sdigits + "7.wav"    
        } else if (ones == 8) {
          stext = stext + "восемь";
          sdigits = sdigits + "8.wav"    
        } else if (ones == 9) {
          stext = stext + "девять";
          sdigits = sdigits + "9.wav"    
        }
      }
//==================================================================
    }  
  } else {
    if (ones > 0) {  
      if (stext !== "") { 
        stext = stext + " ";
        sdigits = sdigits + ", ";
      }  
      if (ones == 1) {
        stext = stext + "один";
        sdigits = sdigits + "1.wav"    
      } else if (ones == 2) {
        stext = stext + "два";
        sdigits = sdigits + "2.wav"    
      } else if (ones == 3) {
        stext = stext + "три";
        sdigits = sdigits + "3.wav"    
      } else if (ones == 4) {
        stext = stext + "четыре";
        sdigits = sdigits + "4.wav"    
      } else if (ones == 5) {
        stext = stext + "пять";
        sdigits = sdigits + "5.wav"    
      } else if (ones == 6) {
        stext = stext + "шесть";
        sdigits = sdigits + "6.wav"    
      } else if (ones == 7) {
        stext = stext + "семь";
        sdigits = sdigits + "7.wav"    
      } else if (ones == 8) {
        stext = stext + "восемь";
        sdigits = sdigits + "8.wav"    
      } else if (ones == 9) {
        stext = stext + "девять";
        sdigits = sdigits + "9.wav"    
      }
    }  
  }
  var res = "";
  if (mode == 0) {
    if (stext !== "") {
      res = stext + "[" + sdigits + "]";
    }
  } else if (mode == 1) {
    if (stext !== "") {
      res = stext;
    }
  } else if (mode == 2) {
    if (stext !== "") {
      res = sdigits;
    }
  }
  return res;
}

function getCameraPhrase(ev, cam, mode) {
  var txt = getDigitsString(ev,1) + " камера " + getDigitsString(cam,1);
  var dgs = getDigitsString(ev,2) + ", камера.wav, " + getDigitsString(cam,2);
  var res = "";
  if (mode == 0) {
    res = txt + "["+ dgs +"}";  
  } else if (mode == 1) {
    res = txt;  
  } else if (mode == 2) {
    res = dgs;  
  } 
  return res;
}

function MyDrawEvents(cv, Width, Height, menu) {

    var LeftTxt = +LengthNameTL + +MyCursor;
    var LeftSec = LeftTxt - WidthDevice - IntervalDevice;
    var LeftDev = LeftSec - WidthDevice;
    if (DoubleSize == 1) {
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


    var ScreenFrm = Math.floor((Width - LeftTxt) / FrameSize);
    var ScreenSec = Math.floor(ScreenFrm / 25);
    var Delta = 50;
    cv.lineWidth = 1;
    cv.fillStyle = Background;
    cv.fillRect(0, 0, Width, Height);
    var tmph;// = Height / (+CountEvents + 1);
    if (menu) {
        tmph = (Height - HeightMenu / 3) / (+CountEvents + 1);
    } else {
        tmph = Height / (+CountEvents + 1);
    }

    var interval = (tmph / 100) * 10;
    tmph = tmph - interval;
    var top = interval;
    if (menu) {
        cv.fillStyle = ProgrammColor;
        cv.fillRect(0, 0, Width, HeightMenu / 3);
        top = top + HeightMenu / 3;
    }

    cv.fillStyle = Foreground;
    for (var i = 0; i <= CountEvents + 1; i++) {
        cv.fillRect(0, top, Width, tmph);
        top = +top + (+tmph + +interval);
    }

    var fs = Math.floor(tmph / 2);
    if (fs > MaxFontSize) {
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
            if (LastEvent > TLT[ActiveTL].Count - 1) {
                LastEvent = TLT[ActiveTL].Count - 1;
            }
            top = interval;
            if (menu) {
                top = top + HeightMenu / 3;
            }
            evColor = rgbFromNum(TLT[ActiveTL].Events[CurrEvent].Color);
            evFontName = TLT[ActiveTL].Events[CurrEvent].FontName;
            evSafeZone = TLT[ActiveTL].Events[CurrEvent].SafeZone;
            ;
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

            cv.fillStyle = smoothcolor(srccolor, 80);
            cv.fillRect(LeftTxt + strtev, top, fnshev - strtev, tmph);

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
            cv.textAlign = "left";

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
                myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec - 10, top, tmph);
            }
//==============================================================================      
            // if (i == CurrEvent+1) {
            //phrsec = Math.floor((TLT[ActiveTL].Events[i].Start - TLP.Position) / 25);
            phrdur = TLT[ActiveTL].Events[CurrEvent].Finish - TLT[ActiveTL].Events[CurrEvent].Start;
            var phrsub = TLT[ActiveTL].Events[CurrEvent].Finish - TLP.Position;
            var phroffset = TLP.Position - TLT[ActiveTL].Events[CurrEvent].Start;
            var phrost = TLT[ActiveTL].Events[CurrEvent].Finish -90;
            
            var kadr = CurrEvent + EventOffset + 2;
            if (CurrEvent < TLT[ActiveTL].Count - 1) {
                var kamera = TLT[ActiveTL].Events[CurrEvent + 1].Rows[0].Phrases[0].Data;
                if (phrdur < Delta) {
                    PhraseFactor = phrdur / Delta;
                    Phrase = Phrase = getCameraPhrase(kadr,kamera,PhraseMode);//kadr + " Камера " + kamera + " " + getPhraseSecconds(phrsec, 3); // phrsec + " секунд";
                } else {
                    PhraseFactor = 1;
                    //if (TLP.Position >= TLT[ActiveTL].Events[CurrEvent].Start &&
                    //        TLP.Position <= +TLT[ActiveTL].Events[CurrEvent].Start + +evSafeZone) {
                    //    //StepPhrase = +TLT[ActiveTL].Events[CurrEvent].Start + 50;
                    //    Phrase = getCameraPhrase(kadr,kamera,PhraseMode);//kadr + " Камера " + kamera + " " + getPhraseSecconds(phrsec, 3); //phrsec + " секунд";
                    if (CurrEvent !== OldEvent) {
                      Phrase = getCameraPhrase(kadr,kamera,PhraseMode);  
                    } else {
                    
                      if (TLP.Position < phrost) {
                        var tlps = Math.floor(phroffset % 125);
                        if (tlps < 100) {
                          Phrase = getCameraPhrase(kadr,kamera,PhraseMode);  
                        } else  {
                          Phrase = "";  
                        }
                      } else {
                        Phrase = "";
                        if (phrsec !== "0") {
                          Phrase = getDigitsString(phrsec, PhraseMode)//phrsec;
                        }  
                      }
                    }
                }
            } 
            //OldEvent = CurrEvent; 
            
            var audio = new Audio();
            
            if (!audio.speaking) {
              audio.preload = 'auto';  
              audio.src = 'phrases/1000.wav';
              audio.play();
              audio.constructor;
            }
            
                       
            if (AudioOn) {
              if (!synth.speaking) {
                  if (Phrase != lastPhrase) {
                      speak(Phrase);
                      lastPhrase = Phrase;
                      OldEvent = CurrEvent;
                  }
              }
            }
            if (menu) {

                cv.textAlign = "left";
                cv.fillText(Phrase, 50, HeightMenu / 6);
                //cv.fillText(Phrase + "  :" + pss + " == " + psstr, 50, HeightMenu / 2);  
            }
            // }
//==============================================================================      
            cv.fillStyle = evColor;
            rectHalfRound(cv, LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph, tmph / 3, evColor, evColor);
            //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
            cv.fillStyle = cfont;
            //cv.textAlign  = "center";
            lentxt = cv.measureText(evdevice).width;
            if (lentxt < LeftSec - LeftDev) {
                cv.textAlign = "center";
                cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
            } else {
                cv.textAlign = "left";
                myTextDraw(cv, evdevice, LeftDev, 0, LeftSec - LeftDev, top, tmph);
            }

            //cv.textAlign  = "right";
            var evps = +CurrEvent + +EventOffset + 1;
            lentxt = cv.measureText(evps).width;
            if (lentxt < LeftDev - 10) {
                cv.textAlign = "right";
                cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);
            } else {
                cv.textAlign = "left";
                myTextDraw(cv, evps, 0, 10, LeftDev - 10, top, tmph);
            }

            if (TLT[ActiveTL].Events[CurrEvent].Start <= TLP.Position &&
                    +TLT[ActiveTL].Events[CurrEvent].Start + +evSafeZone >= TLP.Position) {
                cv.fillStyle = "rgba(255,255,255,.65)";
                tmpdur = +fnshev - strtev - 1;//LeftTxt + +TLP.Start;
                if (tmpdur < 0) {
                    tmpdur = 0;
                }
                cv.fillRect(+LeftTxt + 1, top, tmpdur + strtev, tmph);
                cv.globalAlpha = 1;
            }

            top = top + tmph + interval;
            cv.fillStyle = "white";
            cv.fillRect(LeftTxt + strtev, top + 0.5, fnshev - strtev, tmph - 1);

            if (evmix == "Mix" || evmix == "Wipe") {
                cv.beginPath();
                cv.moveTo(+LeftTxt + strtev, top + tmph - 1);
                cv.lineTo(+LeftTxt + strtev, top + 0.5);
                cv.lineTo(+LeftTxt + strtev + evmixdur, top + 0.5);
                cv.lineTo(+LeftTxt + strtev, top + tmph - 1);
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
            for (var ic = 0; ic <= ScreenSec; ic++) {
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
            cv.textAlign = "left";
            cv.fillStyle = cfont;
            evtext = FramesToShortString(TLP.Position - TLP.Start);

            //lentxt = cv.measureText(evtext).width;
            lentxt = cv.measureText("00:00:00").width;
            var offx = Math.floor((LeftTxt - lentxt) / 20) * 10;
            if (lentxt < LeftTxt - 20) {
                cv.fillText(evtext, offx, +top + +tmph / 2);
                //cv.fillText(evtext, (LeftTxt - lentxt-10) / 2, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evtext, 0, 10, LeftTxt - 20, top, tmph);
            }
            top = top + tmph + interval;

            for (var i = CurrEvent + 1; i <= LastEvent; i++) {
//==============================================================================          
                evColor = rgbFromNum(TLT[ActiveTL].Events[i].Color);
                evFontName = TLT[ActiveTL].Events[i].FontName;
                evSafeZone = TLT[ActiveTL].Events[i].SafeZone;
                ;
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

                cv.fillStyle = smoothcolor(srccolor, 80);
                cv.fillRect(LeftTxt + strtev, top, fnshev - strtev, tmph);

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
                if (fs > MaxFontSize) {
                    fs = MaxFontSize;
                }
                cv.font = fs + "pt Arial";

                if (evtext.charAt(0) == "#") {
                    cv.fillStyle = "yellow";
                } else {
                    cv.fillStyle = cfont;
                }
                cv.textBaseline = "middle";
                cv.textAlign = "left";
                lentxt = cv.measureText(evtext).width;
                if (lentxt <= Width - LeftTxt - 10) {
                    cv.fillText(evtext, +LeftTxt, +top + +tmph / 2);
                } else {
                    myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt - 10, top, tmph);
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
                    myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec - 10, top, tmph);
                }

                cv.fillStyle = evColor;
                rectHalfRound(cv, LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph, tmph /3, evColor, evColor);
                //cv.fillRect(+LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph);
                cv.fillStyle = cfont;
                //cv.textAlign  = "center";
                //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
                lentxt = cv.measureText(evdevice).width;
                if (lentxt < LeftSec - LeftDev) {
                    cv.textAlign = "center";
                    cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
                } else {
                    cv.textAlign = "left";
                    myTextDraw(cv, evdevice, LeftDev, 0, LeftSec - LeftDev, top, tmph);
                }

                //cv.textAlign  = "right";
                //cv.fillText(i + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
                var evps = i + +EventOffset + 1;
                lentxt = cv.measureText(evps).width;
                if (lentxt < LeftDev - 10) {
                    cv.textAlign = "right";
                    cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);
                } else {
                    cv.textAlign = "left";
                    myTextDraw(cv, evps, 0, 10, LeftDev - 10, top, tmph);
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
                if (i == CurrEvent + 1) {
                    cv.fillStyle = Foreground;
                    for (var ic = 0; ic <= ScreenSec; ic++) {
                        cv.beginPath();
                        cv.moveTo(+LeftTxt + ic * step, +top);
                        cv.lineTo(+LeftTxt + ic * step, +top + +tmph);
                        cv.lineWidth = 1;
                        cv.strokeStyle = Foreground;
                        cv.stroke();
                        cv.closePath();
                    }
                }

                top = top + 2 * (tmph + interval);
//==============================================================================                
            }
        }
    } else if (+tptl == 1) {
        var FinishFrm = TLP.Position + ScreenFrm;
        var fev, sev;
        if (TLT[ActiveTL].Count > 0) {
            fev = -1;
            sev = 0;
            for (var i = 0; i < TLT[ActiveTL].Count - 1; i++) {
                if (TLT[ActiveTL].Events[i].Finish > TLP.Position) {
                    sev = i;
                    break;
                }
            }
            fev = sev + CountEvents;
            if (fev > TLT[ActiveTL].Count - 1) {
                fev = TLT[ActiveTL].Count - 1
            }

            top = interval;
//=============================================================================      
            evColor = rgbFromNum(TLT[ActiveTL].Events[sev].Color);
            evFontName = TLT[ActiveTL].Events[sev].FontName;
            evSafeZone = TLT[ActiveTL].Events[sev].SafeZone;
            ;

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

            cv.fillStyle = smoothcolor(srccolor, 80);
            cv.fillRect(LeftTxt + strtev, top, fnshev - strtev, tmph);

            var fs = Math.floor(tmph / 2);
            if (fs > MaxFontSize) {
                fs = MaxFontSize;
            }
            cv.font = fs + "pt Arial";

            if (evtext.charAt(0) == "#") {
                cv.fillStyle = "yellow";
            } else {
                cv.fillStyle = cfont;
            }
            cv.textBaseline = "middle";
            cv.textAlign = "left";
            lentxt = cv.measureText(evtext).width;
            if (lentxt <= Width - LeftTxt - 10) {
                cv.fillText(evtext, +LeftTxt, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt, top, tmph);
            }

            cv.fillStyle = Foreground1;
            cv.fillRect(0, +top, +LeftTxt, +tmph);
            cv.fillStyle = cfont;
            if ((TLT[ActiveTL].Events[sev].Start <= TLP.Position &&
                    +TLT[ActiveTL].Events[sev].Finish >= TLP.Position)) {
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

            var tmpw = Width / 17.5;
            var intrv2 = tmpw / 100 * 10;
            if (interval < 10) {
                intrv2 = 10
            }
            tmpw = tmpw - intrv2;

            WidthDevice = tmpw;
            IntervalDevice = intrv2;

            LeftTxt = +LengthNameTL + +MyCursor;
            LeftSec = LeftTxt - WidthDevice - IntervalDevice;
            LeftDev = LeftSec - WidthDevice;
            if (DoubleSize == 1) {
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

            //if (typeof WidthDevice == "undefined") {
            //  WidthDevice = LeftTxt / 3.5;   
            //}

            //LeftSec = LeftTxt - + WidthDevice - +IntervalDevice;
            //LeftDev = LeftSec - + WidthDevice;
            //cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);

            lentxt = cv.measureText(evtext).width;
            if (lentxt < LeftTxt - LeftSec - 10) {
                cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec - 10, top, tmph);
            }

            //cv.fillStyle = evColor;
            //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
            //cv.fillStyle = cfont;
            //cv.textAlign  = "center";
            //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
            cv.fillStyle = cfont;

            //cv.fillText(sev + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);

            var evps = sev + +EventOffset + 1;
            lentxt = cv.measureText(evps).width;
            if (lentxt < LeftDev - 10) {
                cv.textAlign = "right";
                cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);
            } else {
                cv.textAlign = "center";
                myTextDraw(cv, evps, 0, 10, LeftDev - 10, top, tmph);
            }



            if (TLT[ActiveTL].Events[sev].Start <= TLP.Position &&
                    +TLT[ActiveTL].Events[sev].Start + +evSafeZone >= TLP.Position) {
                cv.fillStyle = "rgba(255,255,255,.65)";
                tmpdur = +fnshev - strtev - 1;//LeftTxt + +TLP.Start;
                if (tmpdur < 0) {
                    tmpdur = 0;
                }
                cv.fillRect(+LeftTxt + 1, top, tmpdur + strtev, tmph);
                cv.globalAlpha = 1;
            }

            top = top + tmph + interval;
            cv.fillStyle = "white";
            cv.fillRect(LeftTxt + strtev, top + 0.5, fnshev - strtev, tmph - 1);

            cv.fillStyle = Foreground;
            for (var ic = 0; ic <= ScreenSec; ic++) {
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
            cv.textAlign = "left";
            cv.fillStyle = cfont;
            evtext = FramesToShortString(TLP.Position - TLP.Start);
            //cv.fillText(evtext, +LeftDev - 10, +top + +tmph / 2);
            //myTextDraw(cv, evtext, 0, 10, LeftTxt, top, tmph);
            lentxt = cv.measureText(evtext).width;
            var offx = Math.floor((LeftTxt - lentxt) / 20) * 10;
            if (lentxt < LeftTxt - 20) {
                cv.fillText(evtext, offx, +top + +tmph / 2);
                //cv.fillText(evtext, (LeftTxt - lentxt-10) / 2, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evtext, 0, 10, LeftTxt - 20, top, tmph);
            }

            top = top + tmph + interval;
            //=============================================================================

            for (var i = sev + 1; i <= fev; i++) {
//=============================================================================      
                evColor = rgbFromNum(TLT[ActiveTL].Events[i].Color);
                evFontName = TLT[ActiveTL].Events[i].FontName;
                evSafeZone = TLT[ActiveTL].Events[i].SafeZone;
                ;

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

                cv.fillStyle = smoothcolor(srccolor, 80);
                cv.fillRect(LeftTxt + strtev, top, fnshev - strtev, tmph);

                var fs = Math.floor(tmph / 2);
                if (fs > MaxFontSize) {
                    fs = MaxFontSize;
                }
                cv.font = fs + "pt Arial";

                if (evtext.charAt(0) == "#") {
                    cv.fillStyle = "yellow";
                } else {
                    cv.fillStyle = cfont;
                }
                cv.textBaseline = "middle";
                cv.textAlign = "left";

                lentxt = cv.measureText(evtext).width;
                if (lentxt <= Width - LeftTxt - 10) {
                    cv.fillText(evtext, +LeftTxt, +top + +tmph / 2);
                } else {
                    myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt, top, tmph);
                }

                //cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 

                cv.fillStyle = Foreground1;
                cv.fillRect(0, +top, +LeftTxt, +tmph);
                cv.fillStyle = cfont;
                if ((TLT[ActiveTL].Events[i].Start <= TLP.Position &&
                        +TLT[ActiveTL].Events[i].Finish >= TLP.Position)) {
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

                lentxt = cv.measureText(evtext).width;
                if (lentxt < LeftTxt - LeftSec - 10) {
                    cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
                } else {
                    myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec - 10, top, tmph);
                }
                //if (typeof WidthDevice == "undefined") {
                //  WidthDevice = LeftTxt / 3.5;   
                //}

                //LeftSec = LeftTxt - + WidthDevice - +IntervalDevice;
                //LeftDev = LeftSec - + WidthDevice;
                //cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);

                evps = i + +EventOffset + 1;
                lentxt = cv.measureText(evps).width;
                if (lentxt < LeftDev - 10) {
                    cv.textAlign = "right";
                    cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);
                } else {
                    cv.textAlign = "center";
                    myTextDraw(cv, evps, 0, 10, LeftDev - 10, top, tmph);
                }
                //cv.textAlign  = "right";
                //cv.fillText(i + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);

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
    if (DoubleSize == 1) {
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


    var ScreenFrm = Math.floor((Width - LeftTxt) / FrameSize);
    var ScreenSec = Math.floor(ScreenFrm / 25);
    var Position = TLP.Position;
    cv.fillStyle = Background;
    cv.fillRect(0, 0, Width, Height);

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
        tmph = (Height - HeightMenu / 3) / (+CNTEvents + 1);
    } else {
        tmph = Height / (+CNTEvents + 1);
    }

    var interval = (tmph / 100) * 10;
    tmph = tmph - interval;
    var top = interval;
    if (menu) {
        cv.fillStyle = ProgrammColor;
        cv.fillRect(0, 0, Width, HeightMenu / 3);
        top = top + HeightMenu / 3;
    }


    cv.fillStyle = Foreground;
    for (var i = 0; i <= CNTEvents + 1; i++) {
        cv.fillRect(0, top, Width, tmph);
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
                top = top + HeightMenu / 3;
            }

            evColor = rgbFromNum(TLT[ActiveTL].Events[FirstEvent].Color);
            evFontName = TLT[ActiveTL].Events[FirstEvent].FontName;
            evSafeZone = TLT[ActiveTL].Events[FirstEvent].SafeZone;
            ;
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
            if (fs > MaxFontSize) {
                fs = MaxFontSize;
            }
            cv.font = fs + "pt Arial";

            if (+LeftTxt + strtev <= Width) {


                wdthev = fnshev - strtev;

                evmixdur = evmixdur * FrameSize;

                if (wdthev < evmixdur) {
                    evmixdur = wdthev;
                }

                cv.fillStyle = smoothcolor(srccolor, 80);
                cv.fillRect(LeftTxt + strtev, top, fnshev - strtev, tmph);

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
                cv.textAlign = "left";
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
            if (Start <= Position && Finish >= Position) {
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
                myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec - 10, top, tmph);
            }


            cv.fillStyle = evColor;
            rectHalfRound(cv, LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph, tmph / 3, evColor, evColor);
            //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
            cv.fillStyle = cfont;
            cv.textAlign = "center";
            //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
            lentxt = cv.measureText(evdevice).width;
            if (lentxt < LeftSec - LeftDev) {
                cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evdevice, LeftDev + interval, 0, LeftSec - LeftDev, top, tmph);
            }


            cv.textAlign = "right";
            //cv.fillText(FirstEvent + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
            var evps = +CurrEvent + +EventOffset + 1;
            lentxt = cv.measureText(evps).width;
            if (lentxt < LeftDev - 10) {
                cv.textAlign = "right";
                cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);
            } else {
                cv.textAlign = "left";
                myTextDraw(cv, evps, 0, 10, LeftDev - 20, top, tmph);
            }


            if (Start <= Position && +Start + +evSafeZone >= Position) {
                cv.fillStyle = "rgba(255,255,255,.65)";
                tmpdur = +fnshev - strtev - 1;//LeftTxt + +TLP.Start;
                if (tmpdur < 0) {
                    tmpdur = 0;
                }
                cv.fillRect(+LeftTxt + 1, top, tmpdur + strtev, tmph);
                cv.globalAlpha = 1;
            }
            top = top + tmph + interval;
            if (+LeftTxt + strtev <= Width) {
                //top = top + tmph + interval;
                cv.fillStyle = "white";
                cv.fillRect(LeftTxt + strtev, top + 0.5, fnshev - strtev, tmph - 1);

                if (evmix == "Mix" || evmix == "Wipe") {
                    cv.beginPath();
                    cv.moveTo(+LeftTxt + strtev, top + tmph - 1);
                    cv.lineTo(+LeftTxt + strtev, top + 0.5);
                    cv.lineTo(+LeftTxt + strtev + evmixdur, top + 0.5);
                    cv.lineTo(+LeftTxt + strtev, top + tmph - 1);
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
                for (var ic = 0; ic <= ScreenSec; ic++) {
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
            cv.textAlign = "left";
            cv.fillStyle = cfont;
            evtext = FramesToShortString(TLP.Position - TLP.Start);
            //cv.fillText(evtext, +LeftDev - 10, +top + +tmph / 2);
            //myTextDraw(cv, evtext, 0, 10, LeftTxt, top, tmph);

            //var lentxt = cv.measureText(evtext).width;
            var lentxt = cv.measureText("00:00:00").width;
            var offx = Math.floor((LeftTxt - lentxt) / 20) * 10;
            if (lentxt < LeftTxt - 10) {
                cv.fillText(evtext, offx, +top + +tmph / 2);
                //cv.fillText(evtext, (LeftTxt - lentxt-10) / 2, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evtext, 0, 10, LeftTxt - 10, top, tmph);
            }

            top = top + tmph + interval;

            for (var i = 1; i < CNTEvents; i++) {
//==============================================================================
                if (device == 0) {
                    IndexEvent = ArrDev1[i];
                } else {
                    IndexEvent = ArrDev2[i];
                }
                if (IndexEvent !== -1) {
                    evColor = rgbFromNum(TLT[ActiveTL].Events[IndexEvent].Color);
                    evFontName = TLT[ActiveTL].Events[IndexEvent].FontName;
                    evSafeZone = TLT[ActiveTL].Events[IndexEvent].SafeZone;
                    ;
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

                    cv.fillStyle = smoothcolor(srccolor, 80);
                    cv.fillRect(LeftTxt + strtev, top, fnshev - strtev, tmph);

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
                    if (fs > MaxFontSize) {
                        fs = MaxFontSize;
                    }
                    cv.font = fs + "pt Arial";

                    if (evtext.charAt(0) == "#") {
                        cv.fillStyle = "yellow";
                    } else {
                        cv.fillStyle = cfont;
                    }
                    cv.textBaseline = "middle";
                    cv.textAlign = "left";
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
                        myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec - 10, top, tmph);
                    }

                    cv.fillStyle = evColor;
                    rectHalfRound(cv, LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph, tmph / 3, evColor, evColor);
                    //cv.fillRect(+LeftDev - 1, top, LeftSec - LeftDev + 2, +tmph);
                    cv.fillStyle = cfont;
                    cv.textAlign = "center";
                    //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
                    lentxt = cv.measureText(evdevice).width;
                    if (lentxt < LeftSec - LeftDev) {
                        cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
                    } else {
                        myTextDraw(cv, evdevice, LeftDev + interval, 0, LeftSec - LeftDev, top, tmph);
                    }


                    cv.textAlign = "right";
                    //cv.fillText(IndexEvent + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);
                    var evps = +CurrEvent + +EventOffset + i + 1;
                    lentxt = cv.measureText(evps).width;
                    if (lentxt < LeftDev - 10) {
                        cv.textAlign = "right";
                        cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);
                    } else {
                        cv.textAlign = "left";
                        myTextDraw(cv, evps, 0, 10, LeftDev - 20, top, tmph);
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
                        for (var ic = 0; ic <= ScreenSec; ic++) {
                            cv.beginPath();
                            cv.moveTo(+LeftTxt + ic * step, +top);
                            cv.lineTo(+LeftTxt + ic * step, +top + +tmph);
                            cv.lineWidth = 1;
                            cv.strokeStyle = Foreground;
                            cv.stroke();
                            cv.closePath();
                        }
                    }

                    top = top + 2 * (tmph + interval);


                }
//==============================================================================                
            }
        }
    } else if (+tptl == 1) {
        var FinishFrm = TLP.Position + ScreenFrm;
        var fev, sev;
        if (TLT[ActiveTL].Count > 0) {
            fev = -1;
            sev = 0;
            for (var i = 0; i < TLT[ActiveTL].Count - 1; i++) {
                if (TLT[ActiveTL].Events[i].Finish > TLP.Position) {
                    sev = i;
                    break;
                }
            }
            fev = sev + CountEvents;
            if (fev > TLT[ActiveTL].Count - 1) {
                fev = TLT[ActiveTL].Count - 1
            }

            top = interval;
//=============================================================================      
            evColor = rgbFromNum(TLT[ActiveTL].Events[sev].Color);
            evFontName = TLT[ActiveTL].Events[sev].FontName;
            evSafeZone = TLT[ActiveTL].Events[sev].SafeZone;
            ;

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

            cv.fillStyle = smoothcolor(srccolor, 80);
            cv.fillRect(LeftTxt + strtev, top, fnshev - strtev, tmph);

            var fs = Math.floor(tmph / 2);
            if (fs > MaxFontSize) {
                fs = MaxFontSize;
            }
            cv.font = fs + "pt Arial";

            if (evtext.charAt(0) == "#") {
                cv.fillStyle = "yellow";
            } else {
                cv.fillStyle = cfont;
            }
            cv.textBaseline = "middle";
            cv.textAlign = "left";
            lentxt = cv.measureText(evtext).width;
            if (lentxt <= Width - LeftTxt - 10) {
                cv.fillText(evtext, +LeftTxt, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt, top, tmph);
            }

            cv.fillStyle = Foreground1;
            cv.fillRect(0, +top, +LeftTxt, +tmph);
            cv.fillStyle = cfont;
            if ((TLT[ActiveTL].Events[sev].Start <= TLP.Position &&
                    +TLT[ActiveTL].Events[sev].Finish >= TLP.Position)) {
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

            var tmpw = Width / 17.5;
            var intrv2 = tmpw / 100 * 10;
            if (interval < 10) {
                intrv2 = 10
            }
            tmpw = tmpw - intrv2;

            WidthDevice = tmpw;
            IntervalDevice = intrv2;

            LeftTxt = +LengthNameTL + +MyCursor;
            LeftSec = LeftTxt - WidthDevice - IntervalDevice;
            LeftDev = LeftSec - WidthDevice;
            if (DoubleSize == 1) {
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

            //if (typeof WidthDevice == "undefined") {
            //  WidthDevice = LeftTxt / 3.5;   
            //}

            //LeftSec = LeftTxt - + WidthDevice - +IntervalDevice;
            //LeftDev = LeftSec - + WidthDevice;
            //cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);

            lentxt = cv.measureText(evtext).width;
            if (lentxt < LeftTxt - LeftSec - 10) {
                cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec - 10, top, tmph);
            }

            //cv.fillStyle = evColor;
            //cv.fillRect(+LeftDev-1, top, LeftSec - LeftDev + 2, +tmph);
            //cv.fillStyle = cfont;
            //cv.textAlign  = "center";
            //cv.fillText(evdevice, +LeftDev + (LeftSec - LeftDev) / 2, +top + +tmph / 2);
            cv.fillStyle = cfont;

            //cv.fillText(sev + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);

            var evps = sev + +EventOffset + 1;
            lentxt = cv.measureText(evps).width;
            if (lentxt < LeftDev - 10) {
                cv.textAlign = "right";
                cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);
            } else {
                cv.textAlign = "center";
                myTextDraw(cv, evps, 0, 10, LeftDev - 10, top, tmph);
            }



            if (TLT[ActiveTL].Events[sev].Start <= TLP.Position &&
                    +TLT[ActiveTL].Events[sev].Start + +evSafeZone >= TLP.Position) {
                cv.fillStyle = "rgba(255,255,255,.65)";
                tmpdur = +fnshev - strtev - 1;//LeftTxt + +TLP.Start;
                if (tmpdur < 0) {
                    tmpdur = 0;
                }
                cv.fillRect(+LeftTxt + 1, top, tmpdur + strtev, tmph);
                cv.globalAlpha = 1;
            }

            top = top + tmph + interval;
            cv.fillStyle = "white";
            cv.fillRect(LeftTxt + strtev, top + 0.5, fnshev - strtev, tmph - 1);

            cv.fillStyle = Foreground;
            for (var ic = 0; ic <= ScreenSec; ic++) {
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
            cv.textAlign = "left";
            cv.fillStyle = cfont;
            evtext = FramesToShortString(TLP.Position - TLP.Start);
            //cv.fillText(evtext, +LeftDev - 10, +top + +tmph / 2);
            //myTextDraw(cv, evtext, 0, 10, LeftTxt, top, tmph);
            lentxt = cv.measureText(evtext).width;
            var offx = Math.floor((LeftTxt - lentxt) / 20) * 10;
            if (lentxt < LeftTxt - 20) {
                cv.fillText(evtext, offx, +top + +tmph / 2);
                //cv.fillText(evtext, (LeftTxt - lentxt-10) / 2, +top + +tmph / 2);
            } else {
                myTextDraw(cv, evtext, 0, 10, LeftTxt - 20, top, tmph);
            }

            top = top + tmph + interval;
            //=============================================================================

            for (var i = sev + 1; i <= fev; i++) {
//=============================================================================      
                evColor = rgbFromNum(TLT[ActiveTL].Events[i].Color);
                evFontName = TLT[ActiveTL].Events[i].FontName;
                evSafeZone = TLT[ActiveTL].Events[i].SafeZone;
                ;

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

                cv.fillStyle = smoothcolor(srccolor, 80);
                cv.fillRect(LeftTxt + strtev, top, fnshev - strtev, tmph);

                var fs = Math.floor(tmph / 2);
                if (fs > MaxFontSize) {
                    fs = MaxFontSize;
                }
                cv.font = fs + "pt Arial";

                if (evtext.charAt(0) == "#") {
                    cv.fillStyle = "yellow";
                } else {
                    cv.fillStyle = cfont;
                }
                cv.textBaseline = "middle";
                cv.textAlign = "left";

                lentxt = cv.measureText(evtext).width;
                if (lentxt <= Width - LeftTxt - 10) {
                    cv.fillText(evtext, +LeftTxt, +top + +tmph / 2);
                } else {
                    myTextDraw(cv, evtext, LeftTxt, 0, Width - LeftTxt, top, tmph);
                }

                //cv.fillText(evtext, +LeftTxt, +top + +tmph / 2); 

                cv.fillStyle = Foreground1;
                cv.fillRect(0, +top, +LeftTxt, +tmph);
                cv.fillStyle = cfont;
                if ((TLT[ActiveTL].Events[i].Start <= TLP.Position &&
                        +TLT[ActiveTL].Events[i].Finish >= TLP.Position)) {
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

                lentxt = cv.measureText(evtext).width;
                if (lentxt < LeftTxt - LeftSec - 10) {
                    cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);
                } else {
                    myTextDraw(cv, evtext, LeftSec, 5, LeftTxt - LeftSec - 10, top, tmph);
                }
                //if (typeof WidthDevice == "undefined") {
                //  WidthDevice = LeftTxt / 3.5;   
                //}

                //LeftSec = LeftTxt - + WidthDevice - +IntervalDevice;
                //LeftDev = LeftSec - + WidthDevice;
                //cv.fillText(evtext, +LeftSec + 5, +top + +tmph / 2);

                evps = i + +EventOffset + 1;
                lentxt = cv.measureText(evps).width;
                if (lentxt < LeftDev - 10) {
                    cv.textAlign = "right";
                    cv.fillText(evps, +LeftDev - 10, +top + +tmph / 2);
                } else {
                    cv.textAlign = "center";
                    myTextDraw(cv, evps, 0, 10, LeftDev - 10, top, tmph);
                }
                //cv.textAlign  = "right";
                //cv.fillText(i + EventOffset + 1, +LeftDev - 10, +top + +tmph / 2);

                top = top + tmph + interval;
                //=============================================================================          
            }
        }
    } else if (+tptl == 2) {

    }


}