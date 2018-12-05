
var ProductIndex = 0;

var ListProducts = [
    { image : "images/product1.jpg", 
      typeshow : 2,
	  listimg : [
	      {image: "images/armdirector1.jpg"},
		  {image: "images/armdirector2.jpg"},
		  {image: "images/armdirector3.jpg"}
	  ],
      textRUS : "ARM-Director </br> Система автоматизации мероприятий",
	  textUK : "ARM-Director </br> System of automation </br> of performances",
	  textcolor : "white",
	  descriptionRUS : "В процессе проведения мероприятия программно-аппаратные средства комплекса в соответсвии с режиссерским сценарием осуществляют автоматизированое управление медиа оборудованием (видеомикшеры, видеосервера, титравальные станции и т.п.)",
	  descriptionUK : "The software and hardware of the complex are used for managing by media equipments (video mixers, video servers, titrating station, etc.) in the complaince with the scenario of director in the process of producing the program of entertainment.",
      page : "pages/notpage.html",
	  typeaction : "Аренда",
	  infopage : "pages/notpage.html",
	  price : "-2",
	  id : "000001",
	  files : [
	    {textRUS: "Руководство пользователя",
		textUK: "User mahual",
		file: "",
		payment: false,
		onlyuser : false},
		{textRUS: "Модуль управления (Демо)",
		textUK: "Module of manage {Demo}",
		file: "download/ARMDirector.exe",
		payment: true,
		onlyuser : true},
		{textRUS: "Установка и настройка",
		textUK: "installation and configuration",
		file: "download/Установка и настройка ARM Director.docx",
		payment: false,
		onlyuser : true}
	  ]},
	{ image : "images/noimage.jpg",
	  typeshow : 1,
	  listimg : [
	      {image: "images/123456.gif"},
	  ],
      textRUS : "Продукт 2",
	  textUK : "Product 2",
	  textcolor : "black",
	  descriptionRUS : "Описание продукта 2",
	  descriptionUK : "Description product 2",
      page : "pages/notpage.html",
	  price : "-2",
	  infopage : "pages/notpage.html",
	  id : "000002",
	  typeaction : "Купить",
	  files : [
	    {textRUS: "Руководство пользователя",
		textUK: "Руководство пользователя",
		file: "11.txt",
		payment: true,
		onlyuser : false},
		{textRUS: "Модуль управления (Демо)",
		textUK: "Руководство пользователя",
		file: "11.txt",
		payment: false,
		onlyuser : false},
		{textRUS: "Пример использования",
		textUK: "Руководство пользователя",
		file: "22.txt",
		payment: false,
		onlyuser : false}
	  ]},
    { image : "images/noimage.jpg",
	  typeshow : 1,
	  listimg : [
	    {image: "images/giphy.gif"},
	  ],
      textRUS : "Продукт 3",
	  textUK : "Product 3",
	  textcolor : "black",
	  descriptionRUS : "Описание продукта 3",
	  descriptionUK : "Description product 3",
      page : "pages/notpage.html",
	  price : "-2",
	  infopage : "pages/notpage.html",
	  id : "000003",
	  typeaction : "Купить",
	  files : [
	    {textRUS: "Руководство пользователя",
		textUK: "Руководство пользователя",
		file: "",
	    payment: false,
		onlyuser : false},
		{textRUS: "Модуль управления (Демо)",
		textUK: "Руководство пользователя",
		file: "",
		payment: false,
		onlyuser : false},
		{textRUS: "Пример использования",
		textUK: "Руководство пользователя",
		file: "", 
		payment: false,
		onlyuser : false}
	  ]},
    { image : "images/noimage.jpg",
	  typeshow : 1,
	  listimg : [
	    {image: "images/1111.gif"},
	  ],
      textRUS : "Продукт 4",
	  textUK : "Product 4",
	  textcolor : "black",
	  descriptionRUS : "Описание продукта 4",
	  descriptionUK : "Description product 4",
      page : "pages/notpage.html",
	  price : "-2",
	  infopage : "pages/notpage.html",
	  id : "000004",
	  typeaction : "Купить",
	  files : [
	    {textRUS: "Руководство пользователя",
		textUK: "User manual",
		file: "",
		payment: false,
		onlyuser : false},
		{textRUS: "Модуль управления (Демо)",
		textUK: "Module of control {Demo}",
		file: "",
		payment: false,
		onlyuser : true},
		{textRUS: "Пример использования",
		textUK: "Sample of using",
		file: "", 
		payment: false,
		onlyuser : false}
	  ]},
    { image : "images/noimage.jpg",
	  typeshow : 2,
	  listimg : [
	    {image: "images/123456.gif"},
		{image: "images/giphy.gif"},
		{image: "images/1111.gif"}
	  ],
      textRUS : "Продукт 5",
	  textUK : "Product 5",
	  textcolor : "black",
	  descriptionRUS : "Описание продукта 5",
	  descriptionUK : "Description product 5",
      page : "pages/notpage.html",
	  price : "-2",
	  infopage : "pages/notpage.html",
	  id : "000005",
	  typeaction : "Купить",
	  files : [
	    {textRUS: "Руководство пользователя",
		textUK: "Руководство пользователя",
		file: "",
		payment: false,
		onlyuser : true},
		{textRUS: "Модуль управления (Демо)",
		textUK: "Руководство пользователя",
		file: "",
		payment: false,
		onlyuser : false},
		{textRUS: "Пример использования",
		textUK: "Руководство пользователя",
		file: "", 
		payment: false,
		onlyuser : false}
	  ]},
    { image : "images/noimage.jpg",
	  typeshow : 0,
	  listimg : [],
      textRUS : "Продукт 6",
	  textUK : "Product 6",
	  textcolor : "black",
	  descriptionRUS : "Описание продукта 6",
	  descriptionUK : "Description product 6",
      page : "pages/notpage.html",
	  price : "-2",
	  infopage : "pages/notpage.html",
	  id : "000006",
	  typeaction : "Купить",
	  files : [
	    {textRUS: "Руководство пользователя",
		textUK: "Руководство пользователя",
		file: "",
		payment: false,
		onlyuser : false},
		{textRUS: "Модуль управления (Демо)",
		textUK: "Руководство пользователя",
		file: "",
		payment: true,
		onlyuser : false},
		{textRUS: "Пример использования",
		textUK: "Руководство пользователя",
		file: "", 
		payment: false,
		onlyuser : false}
	  ]}	  
];