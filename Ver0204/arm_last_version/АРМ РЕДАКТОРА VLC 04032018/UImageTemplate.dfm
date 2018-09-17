object FGRTemplate: TFGRTemplate
  Left = 402
  Top = 211
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1096#1072#1073#1083#1086#1085
  ClientHeight = 635
  ClientWidth = 973
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  StyleElements = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 664
    Top = 0
    Width = 309
    Height = 635
    Align = alRight
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 309
      Height = 25
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1077' '#1096#1072#1073#1083#1086#1085#1099
      Layout = tlCenter
      StyleElements = []
    end
    object GridImgTemplate: TStringGrid
      Left = 0
      Top = 25
      Width = 309
      Height = 610
      Align = alClient
      BorderStyle = bsNone
      ColCount = 3
      DrawingStyle = gdsClassic
      FixedCols = 0
      FixedRows = 0
      GridLineWidth = 0
      Options = [goRowSelect]
      ScrollBars = ssNone
      TabOrder = 0
      StyleElements = []
      OnDblClick = GridImgTemplateDblClick
      OnDrawCell = GridImgTemplateDrawCell
      OnKeyPress = GridImgTemplateKeyPress
      OnMouseDown = GridImgTemplateMouseDown
      OnMouseUp = GridImgTemplateMouseUp
      OnTopLeftChanged = GridImgTemplateTopLeftChanged
      ColWidths = (
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
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 664
    Height = 635
    Align = alClient
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object Image1: TImage
      Left = 1
      Top = 37
      Width = 662
      Height = 419
      Align = alClient
    end
    object Layer1: TImage
      Left = 23
      Top = 62
      Width = 364
      Height = 273
      Transparent = True
      OnClick = Layer1Click
      OnMouseDown = Layer1MouseDown
      OnMouseMove = Layer1MouseMove
      OnMouseUp = Layer1MouseUp
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 662
      Height = 36
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object Label2: TLabel
        Left = 152
        Top = 4
        Width = 433
        Height = 26
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
        StyleElements = []
      end
      object SpeedButton1: TSpeedButton
        Left = 4
        Top = 5
        Width = 149
        Height = 25
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083
        Flat = True
        StyleElements = []
        OnClick = SpeedButton1Click
      end
      object ComboBox1: TComboBox
        Left = 592
        Top = 6
        Width = 65
        Height = 21
        BevelInner = bvNone
        BevelKind = bkFlat
        Style = csDropDownList
        Ctl3D = False
        ItemIndex = 0
        ParentCtl3D = False
        TabOrder = 0
        Text = '16x9'
        Visible = False
        StyleElements = []
        OnChange = ComboBox1Change
        Items.Strings = (
          '16x9'
          '4x3')
      end
    end
    object Panel2: TPanel
      Left = 1
      Top = 456
      Width = 662
      Height = 178
      Align = alBottom
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      ShowCaption = False
      TabOrder = 1
      StyleElements = []
      object SpeedButton3: TSpeedButton
        Left = 372
        Top = 130
        Width = 150
        Height = 30
        Caption = #1042#1099#1093#1086#1076
        Flat = True
        StyleElements = []
        OnClick = SpeedButton3Click
      end
      object SpeedButton2: TSpeedButton
        Left = 261
        Top = 50
        Width = 98
        Height = 30
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Flat = True
        StyleElements = []
        OnClick = SpeedButton2Click
      end
      object Label1: TLabel
        Left = 260
        Top = 3
        Width = 30
        Height = 13
        Caption = #1058#1077#1082#1089#1090
        StyleElements = []
      end
      object SpeedButton5: TSpeedButton
        Left = 362
        Top = 50
        Width = 98
        Height = 30
        Caption = #1053#1086#1074#1099#1081
        Flat = True
        StyleElements = []
        OnClick = SpeedButton5Click
      end
      object SpeedButton6: TSpeedButton
        Left = 461
        Top = 50
        Width = 98
        Height = 30
        Caption = #1059#1076#1072#1083#1080#1090#1100
        Flat = True
        StyleElements = []
        OnClick = SpeedButton6Click
      end
      object SpeedButton7: TSpeedButton
        Left = 560
        Top = 50
        Width = 98
        Height = 30
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100
        Flat = True
        StyleElements = []
        OnClick = SpeedButton7Click
      end
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 259
        Height = 178
        Align = alLeft
        BevelOuter = bvNone
        ShowCaption = False
        TabOrder = 0
        StyleElements = []
        object Label4: TLabel
          Left = 10
          Top = 2
          Width = 108
          Height = 13
          Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1096#1072#1073#1083#1086#1085
          StyleElements = []
        end
        object Image2: TImage
          Left = 16
          Top = 28
          Width = 225
          Height = 137
        end
        object Bevel1: TBevel
          Left = 9
          Top = 19
          Width = 241
          Height = 153
          Shape = bsFrame
        end
      end
      object Edit1: TEdit
        Left = 261
        Top = 20
        Width = 397
        Height = 19
        TabOrder = 1
        StyleElements = []
        OnKeyUp = Edit1KeyUp
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 824
    Top = 8
  end
end
