object FGRTemplate: TFGRTemplate
  Left = 454
  Top = 211
  Width = 803
  Height = 510
  Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1081' '#1096#1072#1073#1083#1086#1085
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object Image1: TImage
    Left = 0
    Top = 50
    Width = 466
    Height = 366
    Align = alClient
  end
  object Layer1: TImage
    Left = 8
    Top = 56
    Width = 449
    Height = 273
    Transparent = True
    OnClick = Layer1Click
    OnMouseDown = Layer1MouseDown
    OnMouseMove = Layer1MouseMove
    OnMouseUp = Layer1MouseUp
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 785
    Height = 50
    Align = alTop
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 10
      Top = 7
      Width = 149
      Height = 41
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1092#1072#1081#1083
      OnClick = SpeedButton1Click
    end
    object Label3: TLabel
      Left = 364
      Top = 20
      Width = 41
      Height = 16
      Caption = 'Label3'
    end
    object ComboBox1: TComboBox
      Left = 217
      Top = 10
      Width = 70
      Height = 24
      BevelInner = bvNone
      BevelKind = bkFlat
      Style = csDropDownList
      Ctl3D = False
      ItemHeight = 16
      ItemIndex = 0
      ParentCtl3D = False
      TabOrder = 0
      Text = '16x9'
      OnChange = ComboBox1Change
      Items.Strings = (
        '16x9'
        '4x3')
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 416
    Width = 785
    Height = 49
    Align = alBottom
    TabOrder = 1
    object SpeedButton3: TSpeedButton
      Left = 560
      Top = 8
      Width = 217
      Height = 41
      Caption = #1042#1099#1093#1086#1076
    end
    object SpeedButton4: TSpeedButton
      Left = 304
      Top = 8
      Width = 249
      Height = 41
    end
  end
  object Panel3: TPanel
    Left = 466
    Top = 50
    Width = 319
    Height = 366
    Align = alRight
    Caption = 'Panel3'
    TabOrder = 2
    object Label1: TLabel
      Left = 10
      Top = 211
      Width = 56
      Height = 16
      Caption = #1058#1077#1082#1089#1090
    end
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 317
      Height = 207
      Align = alTop
      TabOrder = 0
      object Bevel1: TBevel
        Left = 10
        Top = 10
        Width = 296
        Height = 188
        Shape = bsFrame
      end
      object Image2: TImage
        Left = 20
        Top = 20
        Width = 277
        Height = 168
      end
    end
    object Memo1: TMemo
      Left = 8
      Top = 232
      Width = 305
      Height = 89
      Lines.Strings = (
        'Memo1')
      TabOrder = 1
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 480
    Top = 16
  end
end
