object FButtonOptions: TFButtonOptions
  Left = 697
  Top = 244
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1082#1085#1086#1087#1082#1080
  ClientHeight = 568
  ClientWidth = 1014
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
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
    Top = 518
    Width = 1014
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object SpeedButton1: TSpeedButton
      Left = 806
      Top = 6
      Width = 200
      Height = 37
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 607
      Top = 6
      Width = 200
      Height = 37
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -17
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton2Click
    end
  end
  object Panel3: TPanel
    Left = 605
    Top = 0
    Width = 409
    Height = 518
    Align = alRight
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 409
      Height = 48
      Align = alTop
      BevelOuter = bvNone
      Ctl3D = True
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
    end
    object StringGrid1: TStringGrid
      Left = 0
      Top = 48
      Width = 409
      Height = 432
      Align = alClient
      BorderStyle = bsNone
      DrawingStyle = gdsClassic
      FixedCols = 0
      GridLineWidth = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ScrollBars = ssNone
      TabOrder = 1
      StyleElements = []
      OnDblClick = StringGrid1DblClick
      OnDrawCell = StringGrid1DrawCell
      OnMouseUp = StringGrid1MouseUp
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
    object Panel7: TPanel
      Left = 0
      Top = 480
      Width = 409
      Height = 38
      Align = alBottom
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 2
      StyleElements = []
      object CheckBox1: TCheckBox
        Left = 56
        Top = 9
        Width = 337
        Height = 25
        Caption = #1059#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1075#1088#1072#1092#1080#1082#1091
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        State = cbChecked
        TabOrder = 0
        StyleElements = []
      end
    end
  end
  object Panel5: TPanel
    Left = 17
    Top = 0
    Width = 588
    Height = 518
    Align = alClient
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 2
    StyleElements = []
    object Image2: TImage
      Left = 0
      Top = 57
      Width = 588
      Height = 311
      Align = alClient
      OnMouseDown = Image2MouseDown
      OnMouseMove = Image2MouseMove
      OnMouseUp = Image2MouseUp
    end
    object Panel6: TPanel
      Left = 0
      Top = 368
      Width = 588
      Height = 150
      Align = alBottom
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object Bevel1: TBevel
        Left = 146
        Top = 75
        Width = 340
        Height = 32
      end
      object Label4: TLabel
        Left = 8
        Top = 1
        Width = 55
        Height = 20
        Caption = #1064#1088#1080#1092#1090
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlBottom
        StyleElements = []
      end
      object Label2: TLabel
        Left = 8
        Top = 55
        Width = 85
        Height = 20
        Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        StyleElements = []
      end
      object Bevel2: TBevel
        Left = 8
        Top = 75
        Width = 117
        Height = 32
      end
      object Image1: TImage
        Left = 10
        Top = 77
        Width = 112
        Height = 27
        OnClick = Image1Click
      end
      object Label6: TLabel
        Left = 289
        Top = 1
        Width = 33
        Height = 20
        Caption = #1054#1089#1085'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlBottom
        StyleElements = []
      end
      object Label7: TLabel
        Left = 363
        Top = 1
        Width = 34
        Height = 20
        Caption = #1044#1086#1087'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlBottom
        StyleElements = []
      end
      object Label8: TLabel
        Left = 440
        Top = 1
        Width = 39
        Height = 20
        Caption = #1062#1074#1077#1090
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlBottom
        StyleElements = []
      end
      object Label3: TLabel
        Left = 149
        Top = 78
        Width = 332
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Caption = #1053#1077' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object Label5: TLabel
        Left = 147
        Top = 55
        Width = 166
        Height = 20
        Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1096#1072#1073#1083#1086#1085
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        StyleElements = []
      end
      object SpeedButton3: TSpeedButton
        Left = 484
        Top = 76
        Width = 82
        Height = 32
        Caption = #1059#1076#1072#1083#1080#1090#1100
        Flat = True
        StyleElements = []
        OnClick = SpeedButton3Click
      end
      object SpeedButton4: TSpeedButton
        Left = 9
        Top = 107
        Width = 113
        Height = 32
        Caption = #1057#1073#1088#1086#1089
        Flat = True
        StyleElements = []
        OnClick = SpeedButton4Click
      end
      object cbFontName: TComboBox
        Left = 9
        Top = 20
        Width = 267
        Height = 28
        BevelKind = bkFlat
        Style = csOwnerDrawVariable
        Ctl3D = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 22
        ParentCtl3D = False
        ParentFont = False
        TabOrder = 0
        StyleElements = []
        OnChange = cbFontNameChange
        OnDrawItem = cbFontNameDrawItem
        OnMeasureItem = cbFontNameMeasureItem
      end
      object ColorBox1: TColorBox
        Left = 438
        Top = 20
        Width = 127
        Height = 22
        Selected = clWhite
        Style = [cbStandardColors]
        BevelKind = bkFlat
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 22
        ParentFont = False
        TabOrder = 1
        StyleElements = []
        OnChange = ColorBox1Change
      end
      object cbMainFont: TComboBox
        Left = 288
        Top = 20
        Width = 64
        Height = 28
        BevelKind = bkFlat
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 3
        ParentFont = False
        TabOrder = 2
        Text = '12'
        StyleElements = []
        OnChange = cbMainFontChange
        Items.Strings = (
          '8'
          '9'
          '10'
          '12'
          '14'
          '16'
          '18'
          '20'
          '22'
          '24'
          '26'
          '28'
          '30'
          '32')
      end
      object cbSubFont: TComboBox
        Left = 363
        Top = 20
        Width = 64
        Height = 28
        BevelKind = bkFlat
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemIndex = 2
        ParentFont = False
        TabOrder = 3
        Text = '10'
        StyleElements = []
        OnChange = cbSubFontChange
        Items.Strings = (
          '8'
          '9'
          '10'
          '12'
          '14'
          '16'
          '18'
          '20'
          '22'
          '24'
          '26'
          '28'
          '30'
          '32')
      end
    end
    object Panel8: TPanel
      Left = 0
      Top = 0
      Width = 588
      Height = 57
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 1
      StyleElements = []
      object Label1: TLabel
        Left = 6
        Top = 10
        Width = 161
        Height = 30
        AutoSize = False
        Caption = #1053#1086#1084#1077#1088' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object lbNumber: TLabel
        Left = 172
        Top = 10
        Width = 69
        Height = 30
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object Label9: TLabel
        Left = 258
        Top = 10
        Width = 146
        Height = 30
        AutoSize = False
        Caption = #1048#1084#1103' '#1091#1089#1090#1088#1086#1081#1089#1090#1074#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        StyleElements = []
      end
      object Edit1: TEdit
        Left = 406
        Top = 13
        Width = 156
        Height = 26
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        StyleElements = []
        OnChange = Edit1Change
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 17
    Height = 518
    Align = alLeft
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 3
    StyleElements = []
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen, cdAnyColor]
    Left = 872
    Top = 16
  end
end
