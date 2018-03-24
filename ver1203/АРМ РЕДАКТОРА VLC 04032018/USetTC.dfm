object frSetTC: TfrSetTC
  Left = 541
  Top = 245
  BorderStyle = bsNone
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1090#1072#1081#1084' '#1082#1086#1076#1072
  ClientHeight = 77
  ClientWidth = 275
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  StyleElements = []
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 0
    Top = 1
    Width = 275
    Height = 75
    Shape = bsFrame
  end
  object SpeedButton1: TSpeedButton
    Left = 10
    Top = 48
    Width = 85
    Height = 25
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Flat = True
    StyleElements = []
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 96
    Top = 48
    Width = 85
    Height = 25
    Caption = #1042#1099#1081#1090#1080
    Flat = True
    StyleElements = []
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 181
    Top = 48
    Width = 85
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100
    Flat = True
    StyleElements = []
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 127
    Top = 15
    Width = 139
    Height = 25
    Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
    Flat = True
    StyleElements = []
    OnClick = SpeedButton4Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 14
    Width = 113
    Height = 19
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
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
