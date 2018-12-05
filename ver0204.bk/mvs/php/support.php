<?php
    function writeLog($text) {
        $file = fopen("logsupport.txt", "a+");
        $today = date("d.m.y H:i:s");
        fwrite($file, $today . " > " . $text." | ");
    };

    $path1 = dirname(__FILE__);
	writeLog($path1);
 
    writeLog("Support:");  
    require_once(dirname(__FILE__).'/connection.php');
	writeLog(dirname(__FILE__).'/connection.php');
	
    $link = mysqli_connect($host, $user, $password, $database) or die("Ошибка " . mysqli_error($link));
    writeLog("DB Connection: Yes;");    
    writeLog('POST DATA: Start ');
	if(!empty($_POST))
    {   
        writeLog("POST DATA: Yes "); 
        $tmp = $_POST['param'];
	    writeLog($tmp);
		$param = json_decode($tmp,TRUE);
		
		$source = $param['source'];
		writeLog($source); 
		$codeerror = $param['codeerror'];
		writeLog($codeerror);
		$userid = $param['userid'];
		writeLog($userid);
		$description = $param['description'];
		writeLog($description);
		
		if ($source) { 
		    writeLog('POST DATA: Recieve '); 
            $query ="INSERT INTO support (support.source, userid, codeerror, discription) VALUE ('$source','$userid','$codeerror','$description');";
			writeLog('SQL QUERY: '.$query);
			$result = mysqli_query($link, $query) or die("Ошибка " . mysqli_error($link));
            			
            if($result) {
				writeLog('SQL QUERY: Good '); 
				$param += ['value' => 'yes'];
			} else {
			    writeLog('SQL QUERY: Bad ');
				$param += ['value'=>'no'];
            }
		} else {
			writeLog('POST DATA: Error ');
			$param += ['value'=>'error'];
		};	
	};	
	writeLog('POST DATA: Finish ');
	$param['pswrd'] = "";
	$tmp1 = json_encode($param);
	writeLog('OUT DATA: '.$tmp1);
	
	echo $tmp1;
	writeLog('OUT DATA: Sent');
	mysqli_close($link);
    writeLog('DB Connection: Close ');	
?>