//amchart

var firstDate = new Date();
var newDatam2 = {};
var ProgrammCommentColor = "yellow";

function zpad(tt) {
    var str = tt.toString();
    while (str.length < 2) {
        str = '0' + str;
    }
    return str;
}

function SecondToShortStr(frm) {
    var fr, st;
    if (frm < 0) {
        st = '-';
        fr = -1 * frm;
    } else {
        st = '';
        fr = frm;
    }

    var h = parseInt(fr / 3600);
    var m = parseInt((fr - h * 3600) / 60);
    var s = parseInt(fr - h * 3600 - m * 60);
  if (h!=0) {
    return  st + zpad(h)+':'+zpad(m)+':'+zpad(s);
  }
  if (m!=0) {
    return  st + ':'+zpad(m)+':'+zpad(s);
  }
    return  st + ':'+zpad(s);

}

var xVal = 0;
var yVal1 = 100;
var yVal2 = 220;
var yVal3 = 10;
var updateInterval = 1;
var dataLength = 60; // number of dataPoints visible at any point
