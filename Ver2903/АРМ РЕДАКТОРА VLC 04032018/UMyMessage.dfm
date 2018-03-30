object FMyMessage: TFMyMessage
  Left = 409
  Top = 312
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
  ClientHeight = 284
  ClientWidth = 623
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
  object spbYes: TSpeedButton
    Left = 249
    Top = 247
    Width = 60
    Height = 30
    Caption = #1044#1072
    Flat = True
    StyleElements = []
    OnClick = spbYesClick
  end
  object spbNot: TSpeedButton
    Left = 313
    Top = 247
    Width = 60
    Height = 30
    Caption = #1053#1077#1090
    Flat = True
    StyleElements = []
    OnClick = spbNotClick
  end
  object Label1: TLabel
    Left = 15
    Top = 0
    Width = 593
    Height = 225
    Alignment = taCenter
    AutoSize = False
    Caption = 'Label1'
    Layout = tlCenter
    WordWrap = True
    StyleElements = []
  end
end
