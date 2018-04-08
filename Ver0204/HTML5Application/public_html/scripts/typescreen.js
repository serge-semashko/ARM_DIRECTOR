/* 
  * Created by Zavialov on 14.01.2018.
 */
"use strict";
function SetTypeScreen(typesrc) {
  setViewport();
  if (typesrc==0) {
    
    evCanvas.width = scrW;
    evCanvas.height = scrH * 0.5;
    dvCanvas.width = scrW;
    dvCanvas.height = scrH * 0.2;
    edCanvas.width = scrW;
    edCanvas.height = scrH * 0.1;
    tvCanvas.width = scrW;
    tvCanvas.height = scrH * 0.2;

    ecv.clearRect(0, 0, evCanvas.width, evCanvas.height);
    dcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
    edcv.clearRect(0, 0, dvCanvas.width, dvCanvas.height);
    tlcv.clearRect(0, 0, tvCanvas.width, tvCanvas.height);
    ecv.fillStyle = "black";
    dcv.fillStyle = "black";
    edcv.fillStyle = "black";
    tlcv.fillStyle = "black";
    ecv.fillRect(0, 0, evCanvas.width, evCanvas.height);
    dcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
    edcv.fillRect(0, 0, dvCanvas.width, dvCanvas.height);
    tlcv.fillRect(0, 0, tvCanvas.width, tvCanvas.height);  
  } else if (typesrc==1) {
    //Экран 2  
  } else if (typesrc==2) {
    //Экран 3
  } else if (typesrc==3) {
    //Экран 4  
  } else if (typesrc==4) {
    //Экран 5
  }  

}
