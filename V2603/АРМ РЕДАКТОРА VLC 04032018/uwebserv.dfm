object HTTPSRVForm: THTTPSRVForm
  Left = 608
  Top = 217
  Caption = 'WEB srv'
  ClientHeight = 454
  ClientWidth = 588
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  StyleElements = []
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 588
    Height = 65
    Align = alTop
    ShowCaption = False
    TabOrder = 0
    TabStop = True
    StyleElements = []
    object Label1: TLabel
      Left = 16
      Top = 15
      Width = 87
      Height = 16
      Caption = 'Object number'
      StyleElements = []
    end
    object ObjNum: TComboBox
      Left = 8
      Top = 34
      Width = 145
      Height = 24
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = '0'
      StyleElements = []
      Items.Strings = (
        '0'
        '1'
        '2'
        '3')
    end
    object varname: TLabeledEdit
      Left = 160
      Top = 33
      Width = 121
      Height = 24
      EditLabel.Width = 91
      EditLabel.Height = 16
      EditLabel.Caption = 'Variable  name'
      TabOrder = 1
      StyleElements = []
    end
    object VarVal: TLabeledEdit
      Left = 288
      Top = 33
      Width = 201
      Height = 24
      EditLabel.Width = 87
      EditLabel.Height = 16
      EditLabel.Caption = 'Variable value'
      TabOrder = 2
      StyleElements = []
    end
    object BitBtn2: TBitBtn
      Left = 496
      Top = 32
      Width = 75
      Height = 25
      Caption = 'add'
      TabOrder = 3
      StyleElements = []
      OnClick = BitBtn2Click
    end
  end
  object Memo2: TMemo
    Left = 0
    Top = 65
    Width = 588
    Height = 389
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    StyleElements = []
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 4000
    OnTimer = Timer1Timer
    Left = 472
    Top = 80
  end
end
