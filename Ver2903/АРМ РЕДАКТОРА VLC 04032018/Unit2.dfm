object HTTPSRVForm: THTTPSRVForm
  Left = 324
  Top = 155
  Width = 1162
  Height = 757
  Caption = 'WEB srv'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1144
    Height = 65
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 0
    object BitBtn1: TBitBtn
      Left = 16
      Top = 8
      Width = 81
      Height = 49
      Caption = 'BitBtn1'
      TabOrder = 0
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 65
    Width = 425
    Height = 647
    Align = alLeft
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Memo2: TMemo
    Left = 665
    Top = 65
    Width = 479
    Height = 647
    Align = alRight
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Memo2')
    ParentFont = False
    TabOrder = 2
  end
  object varname: TLabeledEdit
    Left = 448
    Top = 184
    Width = 121
    Height = 24
    EditLabel.Width = 91
    EditLabel.Height = 16
    EditLabel.Caption = 'Variable  name'
    TabOrder = 3
  end
  object VarVal: TLabeledEdit
    Left = 448
    Top = 232
    Width = 201
    Height = 24
    EditLabel.Width = 87
    EditLabel.Height = 16
    EditLabel.Caption = 'Variable value'
    TabOrder = 4
  end
  object BitBtn2: TBitBtn
    Left = 448
    Top = 264
    Width = 75
    Height = 25
    Caption = 'add'
    TabOrder = 5
    OnClick = BitBtn2Click
  end
  object ObjNum: TComboBox
    Left = 448
    Top = 128
    Width = 145
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 6
    Text = '1'
    Items.Strings = (
      '1'
      '2'
      '3')
  end
  object HTTPSRV: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnAfterCommandHandler = HTTPSRVAfterCommandHandler
    OnBeforeCommandHandler = HTTPSRVBeforeCommandHandler
    OnConnect = HTTPSRVConnect
    OnExecute = HTTPSRVExecute
    OnDisconnect = HTTPSRVDisconnect
    OnListenException = HTTPSRVListenException
    OnNoCommandHandler = HTTPSRVNoCommandHandler
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    OnInvalidSession = HTTPSRVInvalidSession
    OnSessionStart = HTTPSRVSessionStart
    OnSessionEnd = HTTPSRVSessionEnd
    OnCreateSession = HTTPSRVCreateSession
    OnCommandOther = HTTPSRVCommandOther
    OnCreatePostStream = HTTPSRVCreatePostStream
    OnCommandGet = HTTPSRVCommandGet
    Left = 64
    Top = 80
  end
  object Timer1: TTimer
    Interval = 4000
    OnTimer = Timer1Timer
    Left = 472
    Top = 80
  end
end
