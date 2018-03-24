CREATE TABLE `p_category` (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '',
  `shortName` varchar(45) DEFAULT NULL COMMENT='Короткое имя',
  `ExtID` int(11) DEFAULT NULL,
  `ExtDB` varchar(45) DEFAULT NULL,
  `fullName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Сатегории атрибутов (групп)';

CREATE TABLE `p_docGroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `grpID` int(11) NOT NULL,
  `docID` int(11) NOT NULL,
  `permit` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Список атрибутов для каждого документа';

CREATE TABLE `p_documents` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `fullName` varchar(245) NOT NULL,
  `extID` int(11) NOT NULL,
  `extDB` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Документоы';

CREATE TABLE `p_groups` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `fullName` varchar(245) NOT NULL,
  `shortName` varchar(15) NOT NULL,
  `catName` varchar(45) DEFAULT NULL,
  `dictID` int(11) DEFAULT NULL,
  `dictName` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `p_permits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userID` int(11) NOT NULL,
  `docID` int(11) NOT NULL,
  `p_type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `p_userRole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ruleID` int(11) NOT NULL COMMENT 'ИД правила. ',
  `userID` int(11) NOT NULL,
  `groupID` int(11) NOT NULL,
  `exclude` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Определяет, что документ не должен входить в эту группу - ',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Списк правил  пол�';

CREATE TABLE `p_users` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `ExtID` int(11) DEFAULT NULL,
  `ExtDB` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Пользователи\n';
