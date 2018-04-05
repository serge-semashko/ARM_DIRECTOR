function drawDev(dv) {
    dcv.lineWidth = 4;
    dcv.textBaseline = "top";
    dcv.textAlign  = "left";
    dv.Number = Number(dv.Number);
    dleft = Number(dv.Left) ;
    dtop = Number(dv.Top);
    dh = Number(dv.Bottom) - Number(dv.Top);
    dw = Number(dv.Right) - Number(dv.Left)-2;
    dcv.strokeStyle = "#00FF00";
    cpen = intToRGB(dv.Color);
    cbrush = ProgrammColor;
    cfont = ProgrammFontColor;
    //  if Curr 
    //        then cv.Brush.Color:=clRed
    //        else if Next then cv.Brush.Color:=clGreen
    //                else cv.Brush.Color:=ProgrammColor;
    //  cv.Rectangle(Rect);

    if (dv.Curr == "Yes") {
        cbrush = "#FF0000"
    } else {
        if (dv.Next == "Yes") {
            cbrush = "#00FF00"
        } else {
            cbrush = ProgrammColor
        }
    }

    dcv.strokeStyle = cpen;
    dcv.fillStyle = cbrush;
    //    dv.Left = dv.Left-150;
    if (dvd)
        console.log("\ncolor:" + cpen + "," + cbrush + " rect(", dleft + "," + dtop + "," + dw + "," + dh + ")")
    dcv.strokeRect(dleft, dtop, dw, dh);
    dcv.fillRect(dleft + 2, dtop + 2, dw - 4, dh - 4);
    dcv.font = smallFont;
    // if (dvd)
    //     console.log("\nlrect colors:" + cpen + "," + cbrush + " rect(", dleft + "," + dtop + "," + textWidth('00', dcv) + "," + textHeight(font) + ")")
    dcv.fillStyle = cpen;
    dcv.fillRect(dleft + 1, dtop + 1, textWidth('00', dcv) + 5, textHeight(dcv) + 5);
    var message = dv.Number;
    // if (dvd)
    //     console.log(typeof (a));
    var ttop = dtop + textHeight(dcv);
    dcv.fillStyle = cfont;
    dcv.textBaseline = "middle";
    dcv.textAlign  = "center";
    dcv.fillText(message, dleft+1+(textWidth('00', dcv) + 5)/2, dtop+1 + (textHeight(dcv) + 5)/2);
if (dv.Value > -1) {


        // cv.TextOut(Rect.Left+(cv.TextWidth('00') - cv.TextWidth(inttostr(Number))) div 2
        //                        ,rect.Top-2,inttostr(Number));
        //
        //
        //  else cv.Brush.Color:=ProgrammColor;


        dcv.font = mainFont;
        // dcv.textAlign  = "center";

        //  //cv.Font.Size:=DefineFontSizeW(cv, Rect.Right - Rect.Left -20, '000');
        //  cv.Font.Size:=fns;
        //  px:=Rect.Left + (Rect.Right-Rect.Left-cv.TextWidth(inttostr(value))) div 2;
        //  py:=Rect.Top + (Rect.Bottom - Rect.Top-cv.TextHeight('0')) div 2;
        var nleft, ntop, nleft;
        ntop = dtop + 50;
        dcv.fillStyle = cfont;
        dcv.textBaseline = "middle";
        dcv.textAlign  = "center";

        dcv.fillText(dv.Value, dleft+dw/2, dtop+dh/2);
        // +textHeight(dcv)/2
    }
    dcv.font = mainFont;


}
