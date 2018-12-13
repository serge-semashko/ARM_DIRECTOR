/**
 * Created by Semashko on 11.02.2017.
 */
"use strict";
function drawTimeCode(ev) {
    // cv.Brush.Color := Background;
    ecv.strokeStyle = ev.BackGround;
    // cv.Font.Color:=ProgrammFontColor;
    ecv.fillStyle = ProgrammFontColor;
    // cv.Font.Name:=ProgrammFontName;
    ecv.font = mainFont;
    // //cv.Font.Size:=40;
    // cv.Font.Size:=szFontEvents1;
    // //cv.Font.Size:=DefineFontSizeH(cv,CurrTime.RTC.Bottom - CurrTime.RTC.Top);
    // s:=FramesToShortStr(tc);
    var shl = parseInt(ev.tcRight - textWidth("00:00:00:00",ecv));
    ecv.textAlign  = "right";
    var shtop = ev.tcTop+  (ev.tcBottom-ev.tcTop+textWidth("M",ecv))/2;
    ecv.fillText(ev.timeCode+"             ",ev.tcRight,shtop);
    ecv.textAlign  = "left";
    // cv.TextOut(CurrTime.RTC.Right - cv.TextWidth('00:00:00:00'), CurrTime.RTC.Top +
    //     (CurrTime.RTC.Bottom - CurrTime.RTC.Top - cv.TextHeight('0')) div 2, s);


}
function drawSeconds(ev) {
    // clp:=cv.Pen.Color;
    // pnw:=cv.Pen.Width;
    // stp := 25 * TLParameters.FrameSize;
    var stp = 25*ev.fsize;
    // str := Rsecond.Left + stp;
    var str = ev.sLeft + stp;
    // cv.Pen.Color:=BackGround;
    ecv.fillStyle = ev.BackGround;
    ecv.strokeStyle =  ev.BackGround;
    // while str < Rsecond.Right do begin
    // ecv.lineWidth = 5;
    ecv.lineCap = "butt";
    while (str <ev.sRight) {
        //     cv.MoveTo(str,RSecond.Top);
        ecv.moveTo(str,ev.sTop);
        // cv.LineTo(str,RSecond.Bottom);
        ecv.lineTo(str,ev.sBottom);
        // str:=str+stp;
        str = str+stp;
        // end;
    }
    ecv.stroke();
}
function drawAirSecond(ev, i) {
    var Foreground = intToRGB(ev.ForeGround);
    var Background = intToRGB(ev.BackGround);
    var  cfont, cbrush;
    ev.Mix = Number(ev.Mix);
    ev.fsize = Number(ev.fsize);
    ev.Duration = Number(ev.Duration);
    ev.Finish = Number(ev.Finish);
    ev.Start = Number(ev.Start);

    ev.Top = Number(ev.Top);
    ev.Bottom = Number(ev.Bottom);
    ev.Left = Number(ev.Left);
    ev.Right = Number(ev.Right);


    ev.sTop = Number(ev.sTop);
    ev.sBottom = Number(ev.sBottom);
    ev.sLeft = Number(ev.sLeft);
    ev.sRight = Number(ev.sRight);

    ev.tcTop = Number(ev.tcTop);
    ev.tcBottom = Number(ev.tcBottom);
    ev.tcLeft = Number(ev.tcLeft);
    ev.tcRight = Number(ev.tcRight);
    ecv.fillStyle = Background;
    ecv.fillRect(ev.Left, ev.Top, ev.Right - ev.Left, ev.Bottom - ev.Top);
    ecv.fillStyle = ev.Color;
    var rtTop = ev.sTop;
    var rtBottom = ev.sBottom;
    if (ev.Start < 0) {
        ev.Start = 0;
    }
    var rtLeft = ev.sLeft + ev.Start * ev.fsize;
    var rtRight = ev.sLeft + ev.Finish * ev.fsize;
    if (ev.Duration > 0) {
        ecv.fillRect(rtLeft, rtTop, rtRight - rtLeft, rtBottom - rtTop);
    }
    if (ev.Mix > 0) {
        ecv.fillStyle = ev.sc56;
        //     cv.Pen.Color := SmoothColor(color,56);
        //     if Mix > Duration then Mix := Duration;
        if (ev.Mix > ev.Duration) {
            ev.Mix = ev.Duration;
        }

        //     if start=0 then begin
        if (ev.Start == 0) {
            var str = ev.Duration - ev.Mix; //        str:=Duration-Mix;
            //        if Finish > str then begin
            if (ev.Finish > str) {
                var dlt = (ev.Finish - str) * ev.fsize; //            dlt := (Finish - str) * TLParameters.FrameSize;
                var stp = parseInt(dlt * (rtBottom - rtTop) / (ev.Mix * ev.fsize))// stp := trunc(dlt * ((rt.Bottom-rt.Top) / (Mix * TLParameters.FrameSize)));
                //           cv.Polygon([Point(rt.Left,rt.Top + stp), Point(rt.Left,rt.Top), Point(rt.Left + dlt, rt.Top)]);
                ecv.beginPath();
                ecv.moveTo(rtLeft, rtTop + stp);
                ecv.lineTo(rtLeft, rtTop);
                ecv.lineTo(rtLeft + dlt, rtTop);
                ecv.closePath();
                ecv.fill();

            }
        } else {

            //         cv.Polygon([Point(rt.Left,rt.Bottom), Point(rt.Left,rt.Top), Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top)]);
            ecv.beginPath();
            ecv.moveTo(rtLeft, rtBottom);
            ecv.lineTo(rtLeft, rtTop);
            ecv.lineTo(rtLeft + ev.Mix * ev.fsize, rtTop);
            ecv.closePath();
            ecv.fill();
        }

    }
    drawSeconds(ev);
    drawTimeCode(ev);

}