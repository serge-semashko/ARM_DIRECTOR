<?php
    function writeLog($text) {
        $file = fopen("log.txt", "a+");
        $today = date("d.m.y H:i:s");
        fwrite($file, $today . " > " . $text." | ");
    };
    
    $path1 = dirname(__FILE__);
	writeLog($path1);
 
    writeLog("Point1");  
    require_once(dirname(__FILE__).'/connection.php');
	writeLog(dirname(__FILE__).'/connection.php');
	
    $link = mysqli_connect($host, $user, $password, $database) or die("Ошибка " . mysqli_error($link));
   
    if(!empty($_POST))
    {
        $tmp = $_POST['param'];
		writeLog($tmp);
		$param = json_decode($tmp,TRUE);
		$login = $param['login'];
		writeLog($login);
		$psw_login = $param['passwrd'];
		writeLog($psw_login);

		if ($login) 
		{
	        $query ="SELECT * FROM users WHERE login='$login' OR email='$login';";
			$result = mysqli_query($link, $query) or die("Ошибка " . mysqli_error($link)); 
			//print_r($result);
            if($result) {
		        if (mysqli_num_rows($result) != 0) {
                    while($row = mysqli_fetch_array($result)) {
						$nm = $row['name'];
						$snm = $row['subname'];
						$permission = $row['permission'];
						$registration = $row['registration'];
						$tid = $row['id'];
						$param += ['name'=>$nm];
						$param += ['subname'=>$snm];
						$param += ['permission' => $permission];
						$param += ['registration' => $registration];
						$param += ['uid' => $tid];
						if ($psw_login != $row['password']) {
							$param += ['isregistration'=>'no'];
						} else {
 							$param += ['isregistration'=>'yes'];
						}
                    }
				} else {
					//echo "Пользователь не найден<br>\n";
					$param += ['isregistration'=>'empty'];
				}
            }
		} else {
			$param += ['isregistration'=>'data_error'];
		};	
	};	
	$tmp1 = json_encode($param);
	//$tmp1 = str_replace('\uf', '', $tmp1)
	writeLog($tmp1);
	//$cText = mb_convert_encoding($tmp1, 'utf-8', mb_detect_encoding($tmp1));
	
	//echo $cText;	
	mysqli_close($link);
	$search = array("\ufeff");
    $replace = array("");
    $encoded_string = str_replace($search, $replace, $tmp1);
	echo $encoded_string
	//echo $tmp1;
	//echo json_encode($param);
?>