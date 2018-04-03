object FTextTemplate: TFTextTemplate
  Left = 192
  Top = 146
  BorderStyle = bsDialog
  Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1096#1072#1073#1083#1086#1085#1099
  ClientHeight = 629
  ClientWidth = 1051
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 583
    Width = 1051
    Height = 46
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object SpeedButton1: TSpeedButton
      Left = 862
      Top = 4
      Width = 180
      Height = 35
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 665
      Top = 4
      Width = 180
      Height = 35
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1051
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object SpeedButton3: TSpeedButton
      Left = 189
      Top = 6
      Width = 180
      Height = 30
      Hint = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1090#1077#1082#1089#1090#1086#1074#1086#1075#1086' '#1092#1072#1081#1083#1072
      Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      NumGlyphs = 2
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      StyleElements = []
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 9
      Top = 6
      Width = 180
      Height = 30
      Hint = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1105'/'#1057#1085#1103#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1080#1077
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      StyleElements = []
      OnClick = SpeedButton4Click
    end
    object SpeedButton5: TSpeedButton
      Left = 370
      Top = 6
      Width = 180
      Height = 30
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      StyleElements = []
      OnClick = SpeedButton5Click
    end
  end
  object Edit1: TEdit
    Left = 8
    Top = 544
    Width = 1035
    Height = 22
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 2
    StyleElements = []
  end
  object CheckListBox1: TCheckListBox
    Left = 8
    Top = 41
    Width = 1036
    Height = 492
    BevelInner = bvNone
    BevelOuter = bvNone
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 20
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 3
    StyleElements = []
    OnClick = CheckListBox1Click
    OnDblClick = CheckListBox1DblClick
  end
  object OpenDialog1: TOpenDialog
    Left = 928
    Top = 8
  end
end
