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
	//	$psw_login = $param['passwrd'];
		//writeLog($psw_login);

		if ($code) 
		{   
	        $query ="SELECT * FROM users WHERE verification='$code';";
			$result = mysqli_query($link, $query) or die("Ошибка " . mysqli_error($link)); 
			//print_r($result);
            if($result) {
		        if (mysqli_num_rows($result) != 0) {
                    while($row = mysqli_fetch_array($result)) {
						//$id = $row['id'];
						$nm = $row['name'];
						$snm = $row['subname'];
						//$permission = $row['permission'];
						$registration = $row['registration'];
						//$vercode = $row['verification'];
						//if ($vercode = $codever) {
						//$param += ['login'=>$lg];
						$param += ['name'=>$nm];
						$param += ['subname'=>$snm];
						//$param += ['permission' => $permission];
						$param += ['registration' => $registration];
						//$param += ['mvsuid' => $id];
						$param += ['verification' => 'yes'];
						//} else {
						//	$param += ['verification' => 'no'];
						//};
                    }
				} else {
					//echo "Пользователь не найден<br>\n";
					$param += ['verification'=>'no'];
				}
            }
		} else {
			$param += ['verification'=>'error'];
		};	
	};	
	$tmp1 = json_encode($param);
	//writeLog($tmp1);
	echo $tmp1;
		
	mysqli_close($link);	
?>