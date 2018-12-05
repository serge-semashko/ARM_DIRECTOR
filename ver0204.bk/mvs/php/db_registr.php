<?php
    function writeLog($text) {
        $file = fopen("log.txt", "a+");
        $today = date("d.m.y H:i:s");
        fwrite($file, $today . " > " . $text." | ");
    };
	
	function getRandomCode($cnt,$lim) {
		$strtext = "0123456789aAbBcCdDtEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ";
        $tempcode = "";
        for ($i=0; $i<$cnt; $i++) {
	       $j = rand(0, $lim);
	       $tempcode .=$strtext{$j};
        };   
        return $tempcode;
	};
    writeLog("Start");

    $path1 = dirname(__FILE__);
	writeLog($path1);
	   
    writeLog("Point1");  
    require_once(dirname(__FILE__).'/connection.php');
	writeLog(dirname(__FILE__).'/connection.php');
	
    $link = mysqli_connect($host, $user, $password, $database) or die("Ошибка " . mysqli_error($link));

    if(!empty($_POST)) {
        $tmp = $_POST['param'];
		writeLog($tmp);
		$param = json_decode($tmp,TRUE);
		
		$name = $param["name"];
		writeLog($name);
		$subname = $param["subname"];
		writeLog($subname);
		$username = $param["username"];
        $emailsignup = $param["emailsignup"];
        $psw_signup = $param["psw_signup"];
        $psw_confirm = $param["psw_confirm"];
        //die();
		if ($username) {   
	        $query ="SELECT * FROM users WHERE login='$username';";
			writeLog($query);
			$result = mysqli_query($link, $query) or die("Ошибка " . mysqli_error($link)); 
            if($result) {
		        if (mysqli_num_rows($result) != 0) {
					$param += ['regresult'=>'user_exist'];
					//writeLog("||-------------||");
					$tmp1 = json_encode($param);
	                writeLog($tmp1);
	                echo $tmp1;
		           	mysqli_close($link);
					exit;
				};
            };
			$query ="SELECT * FROM users WHERE email='$emailsignup';";
			writeLog($query);
			$result = mysqli_query($link, $query) or die("Ошибка " . mysqli_error($link)); 
            if($result) {
		        if (mysqli_num_rows($result) != 0) {
					$param += ['regresult'=>'email_exist'];
					writeLog("||===============||");
					$tmp1 = json_encode($param);
	                writeLog($tmp1);
	                echo $tmp1;
		           	mysqli_close($link);
					exit;
				};
            };
			$code = getRandomCode(25,35);//'hgERE754546KKLLLJJedFFG86hgj';
			$code1 = getRandomCode(6,9);
			$code2 = getRandomCode(6,9);
			$code3 = getRandomCode(6,9);
			$query ="INSERT INTO users (login,email,password,name,subname,buyer,staff,permission,verification,code1,code2,code3,registration) VALUES ('$username','$emailsignup','$psw_signup','$name','$subname','0','0','0','$code','$code1','$code2','$code3','0');";
			writeLog($query);
			$result = mysqli_query($link, $query) or die("Ошибка " . mysqli_error($link));
            writeLog("---->1111");
			if($result) {
				writeLog("---->22222");
				$param += ['regresult'=>'user_OK'];
				$param += ['code'=>$code];
				$param += ['code1'=>$code1];
				$param += ['code2'=>$code2];
				$param += ['code3'=>$code3];
				writeLog($param['regresult']);
				writeLog("---->+++++++++");
			}; 			
		} else {
			writeLog("---->333333");
			$param += ['regresult'=>'user_error'];
		};
	};
	
        $param += ['isregistration'=>'yes']; 
	writeLog("---->444444");
	$tmp1 = json_encode($param);
	writeLog("---->555555");
	writeLog($tmp1);
	echo $tmp1;
	writeLog("---->6666666");	
	mysqli_close($link);
	writeLog("---->77777");
        			
?>