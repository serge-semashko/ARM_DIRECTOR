object FrProtocols: TFrProtocols
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103' '#1074#1080#1076#1077#1086#1084#1080#1082#1096#1080#1088#1086#1084
  ClientHeight = 564
  ClientWidth = 492
  Color = clBtnFace
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
    Top = 529
    Width = 492
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object imgButtons: TImage
      Left = 177
      Top = 0
      Width = 315
      Height = 35
      Align = alRight
      OnMouseMove = imgButtonsMouseMove
      OnMouseUp = imgButtonsMouseUp
      ExplicitTop = 6
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 492
    Height = 529
    Align = alClient
    BevelOuter = bvNone
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object imgAddParam: TImage
      Left = 0
      Top = 247
      Width = 492
      Height = 282
      Align = alClient
      OnMouseMove = imgAddParamMouseMove
      OnMouseUp = imgAddParamMouseUp
      ExplicitLeft = 4
      ExplicitTop = 250
      ExplicitWidth = 425
      ExplicitHeight = 271
    end
    object Panel4: TPanel
      Left = 0
      Top = 0
      Width = 492
      Height = 247
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel4'
      ShowCaption = False
      TabOrder = 0
      StyleElements = []
      object GroupBox1: TGroupBox
        Left = 276
        Top = 0
        Width = 215
        Height = 244
        Caption = #1052#1086#1076#1091#1083#1100' '#1091#1087#1088#1072#1074#1083#1077#1085#1080#1103':'
        TabOrder = 0
        object imgPorts: TImage
          Left = 1
          Top = 14
          Width = 213
          Height = 229
          Align = alClient
          OnMouseMove = imgPortsMouseMove
          OnMouseUp = imgPortsMouseUp
          ExplicitLeft = 41
          ExplicitTop = 12
          ExplicitWidth = 190
        end
        object ComboBox4: TComboBox
          Left = 5
          Top = 15
          Width = 87
          Height = 22
          BevelInner = bvNone
          BevelKind = bkSoft
          Style = csOwnerDrawFixed
          Ctl3D = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentCtl3D = False
          ParentFont = False
          TabOrder = 0
          Visible = False
          StyleElements = []
          OnChange = ComboBox4Change
        end
        object Edit1: TEdit
          Left = 75
          Top = 16
          Width = 92
          Height = 19
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 1
          Text = '000.000.000.000'
          Visible = False
          OnChange = Edit1Change
          OnKeyDown = Edit1KeyDown
          OnKeyPress = Edit1KeyPress
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 0
        Width = 272
        Height = 119
        Caption = #1054#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1077
        TabOrder = 1
        object imgDevice: TImage
          Left = 1
          Top = 14
          Width = 270
          Height = 104
          Align = alClient
          OnMouseMove = imgDeviceMouseMove
          OnMouseUp = imgDeviceMouseUp
          ExplicitLeft = 2
          ExplicitWidth = 224
        end
        object ComboBox1: TComboBox
          Left = 95
          Top = 36
          Width = 124
          Height = 22
          BevelInner = bvNone
          BevelKind = bkSoft
          Style = csOwnerDrawFixed
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
          Visible = False
          StyleElements = []
          OnChange = ComboBox1Change
        end
      end
      object GroupBox3: TGroupBox
        Left = 3
        Top = 120
        Width = 271
        Height = 124
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099':'
        TabOrder = 2
        object imgMainParam: TImage
          Left = 1
          Top = 14
          Width = 269
          Height = 109
          Align = alClient
          OnMouseMove = imgMainParamMouseMove
          OnMouseUp = imgMainParamMouseUp
          ExplicitLeft = 0
          ExplicitTop = 12
          ExplicitWidth = 220
        end
        object ComboBox3: TComboBox
          Left = 96
          Top = 84
          Width = 89
          Height = 22
          BevelInner = bvNone
          BevelKind = bkSoft
          Style = csOwnerDrawFixed
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
          Visible = False
          StyleElements = []
          OnChange = ComboBox3Change
        end
      end
    end
    object ComboBox2: TComboBox
      Left = 112
      Top = 296
      Width = 145
      Height = 22
      BevelInner = bvNone
      BevelKind = bkSoft
      Style = csOwnerDrawFixed
      TabOrder = 1
      Visible = False
      StyleElements = []
      OnChange = ComboBox2Change
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 356
    Top = 88
  end
end
