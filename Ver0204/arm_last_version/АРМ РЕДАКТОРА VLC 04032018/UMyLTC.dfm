object frLTC: TfrLTC
  Left = 192
  Top = 146
  BorderStyle = bsDialog
  Caption = #1056#1077#1078#1080#1084' '#1089#1080#1085#1093#1088#1086#1085#1080#1079#1072#1094#1080#1080
  ClientHeight = 128
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 391
    Height = 84
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    TabStop = True
    StyleElements = []
    object RadioButton1: TRadioButton
      Left = 32
      Top = 20
      Width = 343
      Height = 14
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1080#1089#1090#1077#1084#1085#1086#1077' '#1074#1088#1077#1084#1103' '#1082#1086#1084#1087#1100#1102#1090#1077#1088#1072
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      StyleElements = []
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 32
      Top = 53
      Width = 350
      Height = 14
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1074#1085#1077#1096#1085#1080#1081' '#1090#1072#1081#1084'-'#1082#1086#1076' LTC '
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 1
      StyleElements = []
      OnClick = RadioButton2Click
    end
  end
  object Panel2: TPanel
    Left = 64
    Top = 8
    Width = 391
    Height = 73
    BevelOuter = bvNone
    Caption = 'Panel2'
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object Label2: TLabel
      Left = 26
      Top = 30
      Width = 148
      Height = 13
      Caption = #1042#1088#1077#1084#1103' '#1089#1090#1072#1088#1090#1072' (HH:MM:SS:FF)'
      StyleElements = []
    end
    object Edit1: TEdit
      Left = 244
      Top = 25
      Width = 117
      Height = 26
      AutoSize = False
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 11
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = '00:00:00:00'
      StyleElements = []
      OnChange = Edit1Change
      OnKeyDown = Edit1KeyDown
      OnKeyPress = Edit1KeyPress
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 88
    Width = 391
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel3'
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 2
    StyleElements = []
    object SpeedButton1: TSpeedButton
      Left = 259
      Top = 4
      Width = 130
      Height = 30
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 130
      Top = 4
      Width = 130
      Height = 30
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Flat = True
      StyleElements = []
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 0
      Top = 4
      Width = 130
      Height = 30
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Flat = True
      StyleElements = []
      OnClick = SpeedButton3Click
    end
  end
end
