<?php 
    //function writeLog($text) {
    //    $file = fopen("log.txt", "a+");
    //    $today = date("d.m.y H:i:s");
    //    fwrite($file, $today . " > " . $text." | ");
    //}; 
	//writeLog("start:  ");
	if(!empty($_POST)) {
        $tmp = $_POST['param'];
		//writeLog($tmp);
		$param = json_decode($tmp,TRUE);
		$email = $param['email'];
		//writeLog($email);
		$code = $param['code'];
		//writeLog($code);
		$name = $param['nm'];
		//writeLog($name);
		$subname = $param['snm'];
		//writeLog($subname);
		$language = $param['language'];
		//writeLog($language);
		if ($language == "RUS") {
			$lang = "#RUS"; 
		} else {
			$lang = "#ENG";
	    };		
		$link = 'https://mvsgroup.tv/pages/verification.html?'.$code.$lang; 
        //writeLog($link);
		
        $to  = "<support@mvsgroup.tv>, " ; 
        //writeLog($to);
        $subject = "Подтверждение регистрации"; 
        //writeLog($subject);
		if ($language == "RUS") {
            $message = " <p>Здравствуйте, <b>".$name." ".$subname.".</b></p>"; 
			$message .= "<p> Это письмо пришло к Вам, так как данный e-mail был указан при регистрации на сайте MVSGroup.tv,";
			$message .= " если это были Вы, то для продолжения регистрации перейдите по ниже указанной ссылке:</p>";
			$message .= "<p><a href='".$link."'>Продолжить регистрацию.</a></p>";
			$message .= "<p>Если же письмо пришло к Вам по ошибке, мы приносим Вам наши извинения.</p>";
		} else {
			$message = " <p>Hellow, <b>".$name." ".$subname.".</b></p>"; 
			$message .= "<p>This letter has come to you as this e-mail has been specified at registration on the website MVSGroup.tv,";
			$message .= " if it were you, then for continuation of registration follow below to the specified link:</p>";
			$message .= "<p><a href='".$link."'>To continue registration.</a></p>";
			$message .= "<p>If the letter has come to you by mistake, we bring you our apologies.</p>";
		};
        //writeLog($message); 
        $headers  = "Content-type: text/html; charset=UTF-8 \r\n"; 
        $headers .= "From: От кого письмо <zavialovpavel@gmail.com>\r\n"; 
        $headers .= "Reply-To: pzavialov@mvsgroup.tv\r\n"; 
        //writeLog($headers);
        $res = mail($to, $subject, $message, $headers);
        if ($res) {
			//echo "yes";
			//writeLog("yes");
			$param += ['result'=>'yes'];
		} else {
			//echo "no";
			//writeLog("no");
			$param += ['result'=>'no'];
		};
	} else {
		//writeLog("no");
		$param += ['result'=>'error'];
	};
	$tmp1 = json_encode($param);
	//writeLog($tmp1);
	echo $tmp1;
?>