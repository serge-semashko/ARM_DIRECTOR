object FrListErrors: TFrListErrors
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1057#1087#1080#1089#1086#1082' '#1086#1096#1080#1073#1086#1082
  ClientHeight = 404
  ClientWidth = 832
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 361
    Width = 832
    Height = 43
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object imgBtn: TImage
      Left = 651
      Top = 1
      Width = 180
      Height = 41
      Align = alRight
      OnMouseMove = imgBtnMouseMove
      OnMouseUp = imgBtnMouseUp
      ExplicitLeft = 288
      ExplicitHeight = 46
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 832
    Height = 361
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object ImgUpDown: TImage
      Left = 811
      Top = 0
      Width = 21
      Height = 361
      Align = alRight
      OnMouseDown = ImgUpDownMouseDown
      OnMouseMove = ImgUpDownMouseMove
      OnMouseUp = ImgUpDownMouseUp
      ExplicitLeft = 446
      ExplicitTop = 5
      ExplicitHeight = 431
    end
    object ImgListErr: TImage
      Left = 0
      Top = 0
      Width = 811
      Height = 361
      Align = alClient
      ExplicitTop = -96
      ExplicitWidth = 448
      ExplicitHeight = 423
    end
  end
end
