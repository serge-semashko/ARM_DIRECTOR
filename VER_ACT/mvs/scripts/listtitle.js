var ListMessages = [
    {RUS : "Контент платный.</br>Скачивание возможно, только после оплаты.",
	UK: "Paid content.</br>Downloading is possible, only after payment."},
	{RUS : "Запрашиваемый контент</br>недоступен или удален.",
	UK: "Required content</br>is inaccessible or removed."},
	{RUS : "Контент доступен</br>только зарегистрированным пользователям.",
	UK: "Contents are available</br>only to the registered users."},
	{RUS : "Файл не найден.",
	UK: "File don't find."},
	{RUS : "Неправильные данные.",
	UK: "Data is wrong."},
	{RUS : "Данные подтверждены.",
	UK: "Data is confirmed."},
	{RUS : "Вы действительно</br>хотите выйти?",
	UK: "Do you really</br>want to exit?"},
	{RUS : "Регистрация выполнена.</br>Войти на сайт?",
	UK: "Registration is complete.</br>Do you want to enter</br>on the web-site?"},
	{RUS : " ваша регистрация не была закончена.</br>Для завершения регистрации Вы должны были получить письмо по электронной почте.</br>Если письмо еще не пришло, проверьте папку спама</br>или напишите о проблеме на support@mvsgroup.tv",
	UK: " your registration hasn't been finished.</br>For the end of registration you had to receive the letter by e-mail.</br>If the letter hasn't come yet, check the folder of spam</br>or write about a problem on support@mvsgroup.tv"},
	{RUS : " для завершения регистрации на указанный Вами адрес электронной почты было отослано письмо.</br>Перейдите по указанной в письме ссылке для проверки введенных Вами данных.</br></br>Если письмо не пришло в течении получаса, после Вашей регистрации на сайте, проверьте не было ли данное письмо помещенно в папку спама, и если в папке спама письма так же не окажется напишите в службу поддержки <b>support@mvsgroup.tv</b>",
	UK: " for completion of registration for the e-mail address specified by you the letter has been sent.</br>Follow the link specified in the letter for verification of the data entered by you and the end of registration.</br></br>If the letter hasn't come within half an hour after your registration on the website whether check this letter has been placed in the folder of spam if in the folder of spam of the letter also it doesn't appear write to support service <b> of support@mvsgroup.tv </b>. "},
	{RUS : " почтовый сервер в данный момент не может отправить запрос по указаному вами E-mail. Если электронный адрес указан правильно, то служба поддержки в течении суток отправит Вам письмо для подтверждения регистрации.",
	UK: " the e-mail server can't send a request by E-mail specified by you at present. If the e-mail address is specified correctly, then the support service within days will send you the letter for registration confirmation."}
];

var whosisDisigner = [
    {RUS: "&copy; MVSGroup.tv 2018. Разработчик Завьялов П.А.",
	UK  : "&copy; MVSGroup.tv 2018. Design of P.Zavialov"} 
];

var textContacns = [
   {RUS: "По всем интересующим Вас вопросам </br> пишите на почту <span id='mailadress' style='color: aqua; ' >support@mvsgroup.tv</span></br> Мы постараемся ответить Вам так быстро, </br> как только сможем.",
   UK: "Please contact our mail at </br> <span id='mailadress' style='color: aqua; ' >support@mvsgroup.tv</span></br>  if you have any queries.</br>We will try to respond to you</br>as soon as posible"}
];

var textNotPage = [
   {RUS: "Приносим искренние извинения,</br>но в настоящий момент</br>данная странца находится</br> в процессе разработки.",
   UK: "We asks you to excuse us,</br>but this page</br>is currently disigned."}
];

var ListMenus = [
    {RUS: "Продукты",
	UK  : "Products",
	page: "pages/products.html",
	submenu : [
	]},
	{RUS: "Услуги",
	UK  : "Services",
	page: "pages/services.html",
	submenu : [
	    {RUS: "Разработка, автоматизация ...",
		UK: "Development, automation ...",
	    page: "pages/servicesapp.html"},
		{RUS: "Фото, видео ...",
		UK: "Photo and video ...",
	    page: "pages/servicesvideo.html"}
	]},
	{RUS: "Поддержка",
	UK  : "Supports",
	page: "pages/supports.html",
	submenu : [
	    {RUS: "Скачать файлы",
		UK: "Download",
	    page: "pages/notpage.html"},
		{RUS: "Документация",
		UK: "Documentation",
	    page: "pages/notpage.html"},
		{RUS: "Библиотека",
		UK: "Labrary",
	    page: "pages/notpage.html"}
	]},
	{RUS: "Контакты",
	UK  : "Contacts",
	page: "pages/contacts.html",
	submenu : [
	]}
];

var textServices = [
	{RUS: "Разработка ПО,</br>аппаратных средств,</br>автоматизации, монтаж,</br>сопровождение ...",
	UK  : "Software and</br>hardware development,</br>automation, installation,</br>maintenance ..."},
	{RUS: "Услуги</br>Фото, Видео ...",
	UK  : "Services</br>of photo and video ..."}
];

var ListSections = [
    {RUS: "Продукты",
	UK  : "Products"},
	{RUS: "Разработка ПО, аппаратных средств, автоматизация, монтаж, сопровождение ...",
	UK  : "Software and hardware development, automation, installation, maintenance..."},
	{RUS: "Услуги Фото, Видео",
	UK  : "Services of photo and video"},
	{RUS: "Программные модули, Документация, Библиотека, Контакты",
	UK  : "Download, Documentation, Library, Contacts"}
];

var ListTitles = [
    {image : "url(images/tabimage1.png)", 
	textRUS: "Мы не ищем легких решений,</br>мы находим оптимальные",
	textUK : "We aren't seeking light decisions,</br>we finds optimal ones"},  
    {image : "url(images/tabimage2.png)", 
	textRUS: "Мы изучаем новые технологии,</br>и используем лучшие из них",
	textUK : "We are learning new technologies,</br>and we are using the best of them"},
    {image : "url(images/tabimage3.png)", 
	textRUS: "В критичиских ситуациях,</br>мы готовы прийти на помощь",
	textUK : "In the heavy cases,</br>we are ready to come to help you"}, 
    {image : "url(images/tabimage4.png)", 
	textRUS: "Нас не пугают масштабные проекты,</br>нас пугает их отсутствие",
	textUK : "We are not afraid the big projects,</br>we are afraid to lack them"}, 
    {image : "url(images/tabimage5.png)", 
	textRUS: "Кто-то только обещает,</br>мы реально делаем",
	textUK : "Someone just promise,</br>we are really making"} 
];

var ListFooter1 = [
    {RUS: "Продукты",
	UK  : "Products",
	page: "pages/products.html"},
	{RUS: "Услуги",
	UK  : "Services",
	page: "pages/services.html"},
	{RUS: "Поддержка",
	UK  : "Supports",
	page: "pages/supports.html"},
	{RUS: "Контакты",
	UK  : "Contacts",
	page: "pages/contacts.html"}
];

var ListFooter2 = [
    {RUS: "Разработка ПО, аппаратных средств,</br> автоматизация, монтаж, сопровождение ... ",
	UK  : "Software and hardware development,</br> automation, installation, maintenance ...",
	page: "pages/servicesapp.html"},
	{RUS: "Услуги фото, видео ...",
	UK  : "Services of photo and video",
	page: "pages/servicesvideo.html"},
];

var ListFooter3 = [
    {RUS: "Продукты",
	UK  : "Products",
	page: "pages/products.html"},
	{RUS: "Услуги",
	UK  : "Services",
	page: "pages/services.html"},
	{RUS: "Поддержка",
	UK  : "Supports",
	page: "pages/supports.html"},
	{RUS: "Контакты",
	UK  : "Contacts",
	page: "pages/contacts.html"}
];

var ListFooter4 = [
    {RUS: "Скачать файлы",
	UK  : "Download",
	page: "pages/notpage.html"},
	{RUS: "Документация",
	UK  : "Services",
	page: "pages/notpage.html"},
	{RUS: "Библиотека",
	UK  : "Labrary",
	page: "pages/notpage.html"},
	{RUS: "Контакты",
	UK  : "Contacts",
	page: "pages/contacts.html"}
];

