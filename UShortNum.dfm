object frShortNum: TfrShortNum
  Left = 192
  Top = 146
  BorderStyle = bsDialog
  Caption = #1050#1086#1088#1086#1090#1082#1080#1077' '#1085#1086#1084#1077#1088#1072
  ClientHeight = 154
  ClientWidth = 287
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
  OnKeyPress = FormKeyPress
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 111
    Width = 287
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    ExplicitTop = 94
    ExplicitWidth = 293
    object SpeedButton1: TSpeedButton
      Left = 147
      Top = 5
      Width = 137
      Height = 30
      Caption = #1056#1072#1089#1089#1090#1072#1074#1080#1090#1100
      Flat = True
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 5
      Top = 5
      Width = 137
      Height = 30
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      StyleElements = []
      OnClick = SpeedButton2Click
    end
  end
  object CheckBox1: TCheckBox
    Left = 16
    Top = 74
    Width = 265
    Height = 30
    Caption = #1044#1086#1073#1072#1074#1076#1103#1090#1100' '#1090#1077#1082#1089#1090' '#1082' '#1085#1086#1084#1077#1088#1091
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    StyleElements = []
    OnClick = CheckBox1Click
  end
  object Edit1: TEdit
    Left = 16
    Top = 16
    Width = 257
    Height = 30
    AutoSize = False
    TabOrder = 2
    Visible = False
    StyleElements = []
  end
  object CheckBox2: TCheckBox
    Left = 16
    Top = 55
    Width = 257
    Height = 17
    Caption = #1044#1086#1073#1072#1074#1083#1103#1090#1100' '#1089#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1085#1086#1084#1077#1088#1091
    TabOrder = 3
  end
end
