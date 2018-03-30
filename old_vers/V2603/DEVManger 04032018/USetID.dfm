object FrSetID: TFrSetID
  Left = 0
  Top = 0
  BorderStyle = bsNone
  BorderWidth = 1
  Caption = 'FrSetID'
  ClientHeight = 202
  ClientWidth = 375
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Shape2: TShape
    Left = 0
    Top = 0
    Width = 375
    Height = 201
  end
  object Label2: TLabel
    Left = 13
    Top = 8
    Width = 347
    Height = 74
    Align = alCustom
    Alignment = taCenter
    AutoSize = False
    Caption = 
      #1055#1088#1080' '#1079#1072#1087#1091#1089#1082#1077' '#1084#1086#1076#1091#1083#1102' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072#1084#1080' '#1085#1077' '#1087#1088#1080#1089#1074#1086#1077#1085' '#1091#1089#1083#1086#1074#1085#1099#1081' ' +
      #1085#1086#1084#1077#1088'.'
    Layout = tlCenter
    WordWrap = True
  end
  object Shape1: TShape
    Left = 196
    Top = 163
    Width = 89
    Height = 23
  end
  object SpeedButton1: TSpeedButton
    Left = 195
    Top = 162
    Width = 91
    Height = 23
    Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
    Flat = True
    StyleElements = []
    OnClick = SpeedButton1Click
  end
  object Shape3: TShape
    Left = 94
    Top = 163
    Width = 89
    Height = 23
  end
  object SpeedButton2: TSpeedButton
    Left = 94
    Top = 162
    Width = 89
    Height = 23
    Caption = #1042#1099#1093#1086#1076
    Flat = True
    OnClick = SpeedButton2Click
  end
  object Label1: TLabel
    Left = 19
    Top = 123
    Width = 65
    Height = 13
    Alignment = taRightJustify
    Caption = 'URL '#1057#1077#1088#1074#1077#1088#1072
    Visible = False
  end
  object Label3: TLabel
    Left = 148
    Top = 95
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1086#1084#1077#1088':'
  end
  object Label4: TLabel
    Left = 128
    Top = 58
    Width = 113
    Height = 85
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label4'
    Layout = tlCenter
    Visible = False
  end
  object Edit1: TEdit
    Left = 193
    Top = 93
    Width = 26
    Height = 21
    AutoSize = False
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    Text = '0'
    StyleElements = []
    OnKeyDown = Edit1KeyDown
    OnKeyPress = Edit1KeyPress
  end
  object SpinButton1: TSpinButton
    Left = 218
    Top = 94
    Width = 16
    Height = 18
    DownGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    TabOrder = 1
    UpGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    StyleElements = []
    OnDownClick = SpinButton1DownClick
    OnUpClick = SpinButton1UpClick
  end
  object Edit2: TEdit
    Left = 90
    Top = 120
    Width = 265
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 2
    Visible = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 250
    OnTimer = Timer1Timer
    Left = 312
    Top = 72
  end
end
