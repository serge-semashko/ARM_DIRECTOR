�
 TFMMAIN 0�  TPF0TfmMainfmMainLeft� Top� BorderIconsbiSystemMenu
biMinimize BorderStylebsSingleCaptionCOM-port service exampleClientHeight�ClientWidth:Color	clBtnFaceDoubleBuffered	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoScreenCenterStyleElements OnClose	FormCloseOnCreate
FormCreate	OnDestroyFormDestroyOnHideFormHidePixelsPerInch`
TextHeight TPanelPanel1Left Top Width:HeighthAlignalClient
BevelOuterbvNoneCaptionPanel1Ctl3DFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style ParentCtl3D
ParentFontShowCaptionTabOrder StyleElements  TImageImage1Left`Top� WidthHeight  TPanelPanel5Left Top Width:Height� AlignalTop
BevelOuterbvNoneCaptionPanel5Ctl3DParentCtl3DShowCaptionTabOrder StyleElements  	TGroupBox	GroupBox1Left Top Width�Height� AlignalLeftCaption    Общая информация:Color	clBtnFaceCtl3DFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColorParentCtl3D
ParentFontTabOrder StyleElements  TImageImgProtocolLeftTopWidth�Height� AlignalClientExplicitTopExplicitWidth�ExplicitHeight�    	TGroupBox	GroupBox2Left�Top WidthsHeight� AlignalRightCaption   Порт управления:TabOrderStyleElements  TImageimgPortLeftTopWidthqHeight� AlignalClient    TPanelPanel6Left Top� Width:Height�AlignalClient
BevelOuterbvNoneCaptionPanel6Ctl3DParentCtl3DShowCaptionTabOrderStyleElements  	TGroupBox	GroupBox3Left�Top WidthsHeight�AlignalRightCaption0   Состояние приема/передачиCtl3DParentCtl3DTabOrder StyleElements  TImageImgTransLeftTopWidthqHeightvAlignalClientExplicitLeft@ExplicitTop8ExplicitWidthiExplicitHeighti   	TGroupBox	GroupBox4Left Top Width�Height�AlignalLeftCaption-   Обмен данными с серверомCtl3DParentCtl3DTabOrderStyleElements  TImageimgWebLeftTopWidth�HeightvAlignalClientExplicitLeftExplicitTopExplicitWidth�ExplicitHeight=     TPanelPanel2Left TophWidth:Height$AlignalBottom
BevelOuterbvNoneCaptionPanel2Ctl3DParentCtl3DShowCaptionTabOrderStyleElements  TSpeedButtonSpeedButton2Left� TopWidth� HeightCaption   Ручная передачаFlat	OnClickSpeedButton2Click  TSpeedButtonSpeedButton4Left9TopWidthxHeightCaption	   0@0<5B@KFlat	OnClickSpeedButton4Click  TSpeedButtonSpeedButton8LeftTopWidth� HeightCaption!   Загрузить командыFlat	OnClickSpeedButton8Click  TSpeedButtonSpeedButton1Left�TopWidthxHeightCaption   0:@KBLFlat	OnClickSpeedButton1Click   
TPopupMenu
PopupMenu1Left Top�  	TMenuItemRestoreItemCaption*   Открыть окно программыOnClickRestoreItemClick  	TMenuItemN1Caption	   0@0<5B@KOnClickN1Click  	TMenuItemFileExitItem1Caption!   Закрыть программуOnClickFileExitItem1Click  	TMenuItemN2Caption-  	TMenuItemHideItemCaption,   Свернуть окно программыOnClickHideItemClick   TTimerTimer1EnabledInterval2OnTimerTimer1TimerLeft8Top�   TClientSocketClientSocket1Active
ClientTypectNonBlockingPort 	OnConnectClientSocket1ConnectOnDisconnectClientSocket1DisconnectOnReadClientSocket1ReadOnWriteClientSocket1WriteOnErrorClientSocket1ErrorLeftwTopp   