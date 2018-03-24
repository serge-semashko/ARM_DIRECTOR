"use strict";
var ev = {
    "BackGround": "#474749",
    "ForeGround": "#575759",
    "Interval": "2",
    "fsize": "4",
    "sf5": "#5C5C5E",
    "sb5": "#4C4C4E",
    "sct25": "#909092",
    "sct56": "#AFAFB1",
    "eTop": "0",
    "eLeft": "364",
    "eW": "1556",
    "eH": "64",
    "nTop": "0",
    "nLeft": "187",
    "nRight": "273",
    "nBottom": "64",
    "oTop": "0",
    "oLeft": "0",
    "oRight": "182",
    "oBottom": "64",
    "sTop": "0",
    "sLeft": "278",
    "sRight": "364",
    "sBottom": "64",
    "ColorTimeline": "#777779",
    "ColorEvent": "#98E2EB",
    "Number": "4",
    "Dev": "2",
    "Start": "-7",
    "Finish": "132",
    "Duration": "139",
    "Mix": "0",
    "Text": "Бутусов крупный план",
    "Top": "0",
    "Left": "0",
    "Right": "1920",
    "Bottom": "64"
};

function drawEvent(ev, ps) {
    var Foreground = intToRGB(ev.ForeGround);
    var Background = intToRGB(ev.BackGround);
    var  cfont, cbrush;
    var sht;
    ecv.textBaseline = "middle";
    ev.Mix = Number(ev.Mix);
    ev.fsize = Number(ev.fsize);
    ev.Number = Number(ev.Number)+1;
    ev.Interval = Number(ev.Interval);
    ev.Duration = Number(ev.Duration);
    ev.Finish = Number(ev.Finish);
    ev.Start = Number(ev.Start);

    ev.Top = Number(ev.Top);
    ev.Bottom = Number(ev.Bottom);
    ev.Left = Number(ev.Left);
    ev.Right = Number(ev.Right);

    ev.nTop = Number(ev.nTop);
    ev.nBottom = Number(ev.nBottom);
    ev.nLeft = Number(ev.nLeft);
    ev.nRight = Number(ev.nRight);

    ev.sTop = Number(ev.sTop);
    ev.sBottom = Number(ev.sBottom);
    ev.sLeft = Number(ev.sLeft);
    ev.sRight = Number(ev.sRight);

    ev.eTop = Number(ev.eTop);
    ev.eBottom = Number(ev.eBottom);
    ev.eLeft = Number(ev.eLeft);
    ev.eRight = Number(ev.eRight);

    ev.oTop = Number(ev.oTop);
    ev.oBottom = Number(ev.oBottom);
    ev.oLeft = Number(ev.oLeft);
    ev.oRight = Number(ev.oRight);
    // cv.Brush.Color:=Foreground;
    cbrush = ev.ForeGround;
    ecv.fillStyle = cbrush;
    ecv.fillRect(ev.Left, ev.Top, ev.Right-ev.Left, ev.Bottom-ev.Top); // cv.FillRect(Rect);
    cbrush = ev.sf5; // cv.Brush.Color:=smoothcolor(Foreground,5);
    ecv.fillRect(ev.eLeft, ev.eTop, ev.eRight - ev.eLeft, ev.eBottom - ev.eTop);  // cv.FillRect(REvent);


    // cv.Brush.Color:=ColorTimeline;
    cbrush = ev.ColorTimeline; // cv.Brush.Color:=ColorTimeline;
    ecv.fillStyle = cbrush;

    if (ev.Start < 0) {
        ev.Start = 0;
    }
    var rtLeft =ev.eLeft+ev.Start*ev.fsize; // rt.Left := REvent.Left + start * TLParameters.FrameSize;;
    var rtTop = ev.eTop;
    var rtRight = ev.eLeft + ev.Finish * ev.fsize;
    var rtBottom = ev.eBottom;


    if (ev.Duration > 0) {
        ecv.fillRect( rtLeft,rtTop, rtRight-rtLeft, rtBottom-rtTop);
    }

    if (ev.Number < 0) return;

    if (ev.Mix > 0) {
        //    if Mix > 0 then begin
        //      if Mix > Duration then Mix := Duration;
        if (ev.Mix > ev.Duration) {
            ev.Mix = ev.Duration
        }
        // if ps <> -1 then begin
        if (ps != -1) {

            cbrush = ev.sb5; // cv.Brush.Color := SmoothColor(BackGround,5);
            ecv.fillStyle = cbrush;
            // cv.Polygon([Point(rt.Left,rt.Top), Point(rt.Left,rt.Bottom),
            //     Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top)]);
            ecv.beginPath();
            ecv.moveTo(rtLeft, rtTop);
            ecv.lineTo(rtLeft, rtBottom);
            ecv.lineTo(rtLeft + ev.Mix * ev.fsize, rtTop);
            ecv.closePath();
            ecv.fill();
            var hgh = rtBottom - rtTop + ev.Interval;
            // if ps=0 then begin
            if (ps == 0) {
                cbrush = ev.sct25; // cv.Brush.Color := SmoothColor(ColorTimeline,25);
                ecv.fillStyle = cbrush;
                ecv.beginPath();
                // cv.Polygon([Point(rt.Left,rt.Top-Interval), Point(rt.Left,rt.Top-hgh),
                //     Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top-Interval)]);
                // end else begin
                ecv.moveTo(rtLeft, rtTop - ev.Interval);
                ecv.lineTo(rtLeft, rtTop - hgh);
                ecv.lineTo(rtLeft + ev.Mix * ev.fsize, rtTop - ev.Interval);
                ecv.closePath();
                ecv.fill();
            } else {
                cbrush = ev.sct25; // cv.Brush.Color := SmoothColor(ColorTimeline,25);
                ecv.fillStyle = cbrush;
                ecv.beginPath();
                // cv.Polygon([Point(rt.Left,rt.Top-Interval), Point(rt.Left,rt.Top-hgh),
                //     Point(rt.Left + Mix * TLParameters.FrameSize, rt.Top-Interval)]);
                // end else begin
                ecv.moveTo(rtLeft, rtTop - ev.Interval);
                ecv.lineTo(rtLeft, rtTop - hgh);
                ecv.lineTo(rtLeft + ev.Mix * ev.fsize, rtTop - ev.Interval);
                ecv.closePath();
                ecv.fill();
            }
        } else {

            //        cv.Brush.Color := SmoothColor(ColorTimeline,56);
            cbrush = ev.sct56;
            ecv.fillStyle = cbrush;
            // if start=0 then begin
            if (ev.Start == 0) {
                var str = ev.Duration - ev.Mix;//     str:=Duration-Mix;
                //     if Finish > str then begin
                if (ev.Finish > str) {
                    var dlt = (ev.Finish - str) * ev.fsize;//         dlt := (Finish - str) * TLParameters.FrameSize;
                    var stp = parseInt(dlt * (rtBottom-rtTop)/(ev.Mix*ev.fsize));//  stp := trunc(dlt * ((rt.Bottom-rt.Top) / (Mix * TLParameters.FrameSize)));
                    //         cv.Polygon([Point(rt.Left,rt.Bottom-stp), Point(rt.Left,rt.Bottom),
                    //         Point(rt.Left + dlt, rt.Bottom)]);
                    ecv.beginPath();
                    ecv.moveTo(rtLeft,rtBottom-stp);
                    ecv.lineTo(rtLeft,rtBottom);
                    ecv.lineTo(rtLeft+dlt,rtBottom);
                    ecv.closePath();
                    ecv.fill();
                    //     end;
                }
                // end else begin
            } else {
                //     cv.Polygon([Point(rt.Left,rt.Top), Point(rt.Left,rt.Bottom),
                //         Point(rt.Left + Mix * TLParameters.FrameSize, rt.Bottom)]);
                ecv.beginPath();
                ecv.moveTo(rtLeft,rtTop);
                ecv.lneTo(rtLeft,rtBottom);
                ecv.lineTo(rtLeft+ev.Mix*ev.fsize,rtBottom);
                ecv.closePath();
                ecv.fill();
                // end;
            }

        }
    }
    //          cv.Brush.Style:=bsClear;
    cfont = ProgrammFontColor;
    //    cv.Font.Name:=ProgrammFontName;
    var s = SecondToShortStr(parseInt((ev.Finish - ev.Start) / 25)+1);
    ecv.font = mainFont;
    ecv.fillStyle = cfont;

    //    //cv.Font.Size:=DefineFontSizeW(cv,RSecond.Right-RSecond.Left,'0:00');
    //    cv.TextOut(RSecond.Left, RSecond.Top + (RSecond.Bottom-RSecond.Top-cv.TextHeight('0')) div 2, s);
    sht = ( ev.sBottom-ev.sTop+textHeight(ecv))/2;

    ecv.fillText(s, ev.sLeft, (Number(ev.sTop) + Number(ev.sBottom))/2);

    //    s:=inttostr(Number);
    //    cv.TextOut(ROrder.Right - cv.TextWidth(s)-2, ROrder.Top + (ROrder.Bottom-ROrder.Top-cv.TextHeight('0')) div 2, s);
    sht = ( ev.Bottom-ev.Top+textHeight(ecv))/2;
    ecv.fillText(ev.Number, ev.oRight - textWidth(ev.Number.toString(), ecv), (Number(ev.oTop) + Number(ev.oBottom))/2);

    cbrush = intToRGB(ev.ColorEvent);
    ecv.fillStyle = cbrush;
    //    cv.Rectangle(RNumber);
    var nw = Number(ev.nRight) - Number(ev.nLeft);
    var nh = Number(ev.nBottom) - Number(ev.nTop);
    ecv.fillRect(ev.nLeft, ev.nTop, nw, nh);
    if (ev.Dev >= 0) {
        s = ev.Dev
    } else {
        s = '';
    }
    //    cv.TextOut(RNumber.Left + (RNumber.Right - RNumber.Left - cv.TextWidth(s)) div 2,
    //               RNumber.Top + (RNumber.Bottom-RNumber.Top-cv.TextHeight('0')) div 2, s);
    ecv.font = mainFont;
    ecv.fillStyle = cfont;
    sht = ( ev.nBottom-ev.nTop+textHeight(ecv))/2;
    ecv.textAlign = "center";
    ecv.fillText(s, (Number(ev.nLeft) + Number(ev.nRight))/2, (Number(ev.nTop) +Number(ev.nBottom))/2);
    ecv.textAlign = "left";
    //  if Number>= 0 then begin
    if (ev.Number >= 0) {
        //     cv.Brush.Style:=bsClear;
        //     cfont=ProgrammFontColor;
        cfont = ProgrammFontColor;
        //       cv.Font.Name:=ProgrammFontName;
        s = parseInt((Number(ev.Finish) - Number(ev.Start)) / 25);
        //cv.Font.Size:=40;
        //     //cv.Font.Size:=DefineFontSizeW(cv,RSecond.Right-RSecond.Left,'0:00');
//        ecv.fillText(s, ev.sLeft, ev.sTop, Number(ev.sRight) - Number(ev.sLeft), Number(ev.sBottom) - Number(ev.sTop));

        s = ev.Number;
        //     cv.TextOut(ROrder.Right - cv.TextWidth(s)-2, ROrder.Top + (ROrder.Bottom-ROrder.Top-cv.TextHeight('0')) div 2, s);

        //     cv.Brush.Style:=bsSolid;
        //     cv.Brush.Color:=ColorEvent;
        //     cv.Rectangle(RNumber);
        //     if dev >=0 then s:=inttostr(Dev) else s:='';
        //     cv.TextOut(RNumber.Left + (RNumber.Right - RNumber.Left - cv.TextWidth(s)) div 2,
        //                RNumber.Top + (RNumber.Bottom-RNumber.Top-cv.TextHeight('0')) div 2, s);


    }
    //    cv.Brush.Style:=bsClear;
    //    txt :=trim(Text);
    //    cv.Font.Color:=ProgrammFontColor;
    cfont = ProgrammFontColor;
    //    if txt<>'' then if txt[1]='#' then cv.Font.Color:=ProgrammCommentColor;
    if (ev.Text[0] == "#") {
        cfont = ProgrammCommentColor;
    }
    ecv.fillStyle = cfont;
    //    cv.Font.Name:=ProgrammFontName;
    //    //cv.Font.Size:=DefineFontSizeH(cv,REvent.Bottom-REvent.Top - trunc((REvent.Bottom-REvent.Top) / 6));
    //    //Warning*****************
    //    cv.TextOut(REvent.Left + 15,REvent.Top + (REvent.Bottom-REvent.Top-cv.TextHeight('0')) div 2, Text);
    ecv.textAlign = "left";
    sht = ( ev.eBottom-ev.eTop+textHeight(ecv))/2;
    ecv.fillText(ev.Text, Number(ev.eLeft) + 20,(ev.eTop+ev.eBottom)/2);
    //  end;


}
