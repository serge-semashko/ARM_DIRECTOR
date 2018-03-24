object FrSetTC: TFrSetTC
  Left = 0
  Top = 0
  Caption = #1042#1088#1077#1084#1103' '#1089#1090#1072#1088#1090#1072
  ClientHeight = 71
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 137
    Height = 16
    Caption = #1042#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072' '#1086#1090#1089#1095#1077#1090#1072':'
  end
  object Edit1: TEdit
    Left = 152
    Top = 5
    Width = 97
    Height = 24
    TabOrder = 0
    Text = '00:00:00:00'
    OnKeyDown = Edit1KeyDown
    OnKeyPress = Edit1KeyPress
    OnKeyUp = Edit1KeyUp
  end
  object BitBtn1: TBitBtn
    Left = 130
    Top = 40
    Width = 110
    Height = 25
    Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 1
  end
  object BitBtn2: TBitBtn
    Left = 19
    Top = 40
    Width = 110
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 2
  end
end
