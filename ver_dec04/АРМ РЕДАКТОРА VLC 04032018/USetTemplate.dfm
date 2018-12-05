object FrSetTemplate: TFrSetTemplate
  Left = 432
  Top = 145
  BorderStyle = bsDialog
  Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1096#1072#1073#1083#1086#1085#1099
  ClientHeight = 543
  ClientWidth = 659
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
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 462
    Width = 659
    Height = 81
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object SpeedButton3: TSpeedButton
      Left = 504
      Top = 46
      Width = 146
      Height = 28
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Flat = True
      StyleElements = []
      OnClick = SpeedButton3Click
    end
    object SpeedButton4: TSpeedButton
      Left = 357
      Top = 46
      Width = 146
      Height = 28
      Caption = #1054#1090#1084#1077#1085#1072
      Flat = True
      StyleElements = []
      OnClick = SpeedButton4Click
    end
    object SpeedButton1: TSpeedButton
      Left = 575
      Top = 11
      Width = 76
      Height = 24
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Flat = True
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object Edit1: TEdit
      Left = 7
      Top = 10
      Width = 566
      Height = 25
      AutoSize = False
      TabOrder = 0
      StyleElements = []
    end
    object CheckBox1: TCheckBox
      Left = 13
      Top = 52
      Width = 280
      Height = 14
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1074' '#1088#1077#1078#1080#1084#1077' '#1101#1092#1080#1088
      TabOrder = 1
      StyleElements = []
    end
  end
  object GridMyLists: TStringGrid
    Left = 0
    Top = 20
    Width = 659
    Height = 442
    Align = alClient
    BorderStyle = bsNone
    Ctl3D = False
    DrawingStyle = gdsClassic
    FixedCols = 0
    GridLineWidth = 0
    Options = [goRowSelect]
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 1
    StyleElements = []
    OnDblClick = GridMyListsDblClick
    OnDrawCell = GridMyListsDrawCell
    OnMouseUp = GridMyListsMouseUp
    ColWidths = (
      64
      64
      64
      64
      64)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 659
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    StyleElements = []
  end
end
