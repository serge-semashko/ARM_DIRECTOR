<?php
    //function writeLog($text) {
    //    $file = fopen("log.txt", "a+");
    //    $today = date("d.m.y H:i:s");
    //    fwrite($file, $today . " > " . $text." | ");
    //};

    $path1 = dirname(__FILE__);
	//writeLog($path1);
 
    //writeLog("Point1");  
    require_once(dirname(__FILE__).'/connection.php');
	//writeLog(dirname(__FILE__).'/connection.php');
	
    $link = mysqli_connect($host, $user, $password, $database) or die("Ошибка " . mysqli_error($link));
   
    if(!empty($_POST))
    {
        $tmp = $_POST['param'];
	    //writeLog($tmp);
		$param = json_decode($tmp,TRUE);
		$code = $param['codever'];
		//writeLog($code);
		$login = trim($param['login']);
		//writeLog($login);
		$password = $param['pswrd'];
		//writeLog($password);

		if ($code) { 
            $query ="SELECT id, login, password, email, name FROM users WHERE verification='$code';";
			$result = mysqli_query($link, $query) or die("Ошибка " . mysqli_error($link)); 
            if($result) {
				//writeLog('111111');
		        if (mysqli_num_rows($result) != 0) {
                    //writeLog('222222');
					$row = mysqli_fetch_array($result); 
					$id = $row['id'];
					$lg = trim($row['login']);
					//writeLog($lg);
					$psw = trim($row['password']);
					//writeLog($psw);
					$email = trim($row['email']);
					$nm = trim($row['name']);
					$param += ['name' => $nm];
					//writeLog($email);
					//writeLog('333333');
					$bool1 = false;
					$bool2 = false;
					$bool3 = false;
					//writeLog($lg.'='.$login);
					$lg = strtolower($lg);
					$email = strtolower($email);
					$login = strtolower($login);
					if ($lg == $login) { 
					    $bool1 = true; 
						//writeLog(' bool1 ');
					};
					//$lg = strtolower($lg);
					//$email = strtolower($email);
					if ($lg == $email) { 
					    $bool2 = true; 
						//writeLog(' bool2 ');
					};
					if ($psw == $password) { 
					    $bool3 = true; 
						//writeLog(' bool3 ');
					};
					
					
					$bl = ($bool1 or $bool2) and $bool3;
					if ($bl) {
						//writeLog(' bl=true ');
					} else {
					    //writeLog(' bl=false ');
					};
					mysqli_free_result($result);
					if ($bl) {
						//writeLog('444444');
						$param += ['mvsuid' => $id];
					    $query ="UPDATE users SET registration='1' WHERE verification='$code';";
						$result = mysqli_query($link, $query) or die("Ошибка " . mysqli_error($link)); 
                        //writeLog('555555');
						if($result) { 
						//    writeLog('666666'); 
						    $param += ['value' => 'yes'];
						} else {
						//	writeLog('777777');
							$param += ['value'=>'no'];
                        }
					} else {
					//	writeLog('888888');
						$param += ['value'=>'user_error'];
					}	
				} else {
					//writeLog('999999');
					//echo "Пользователь не найден<br>\n";
					$param += ['value'=>'no'];
				}
            }   
		} else {
			//writeLog('aaaaaaa');
			$param += ['value'=>'error'];
		};	
	};	
	//writeLog('bbbbbb');
	$param['pswrd'] = "";
	$tmp1 = json_encode($param);
	//writeLog($tmp1);
	echo $tmp1;
	//writeLog('cccccc');
	mysqli_close($link);
    //writeLog('dddddd');	
?>