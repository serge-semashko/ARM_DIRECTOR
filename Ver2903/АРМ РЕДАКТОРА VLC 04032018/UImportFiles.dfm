object FImportFiles: TFImportFiles
  Left = 605
  Top = 225
  BorderStyle = bsDialog
  Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1082#1083#1080#1087#1072
  ClientHeight = 456
  ClientWidth = 732
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  StyleElements = []
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 422
    Width = 732
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 0
    StyleElements = []
    object SpeedButton1: TSpeedButton
      Left = 367
      Top = 1
      Width = 150
      Height = 30
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 213
      Top = 1
      Width = 150
      Height = 30
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton2Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 0
    Width = 732
    Height = 422
    Align = alClient
    BevelOuter = bvNone
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 1
    StyleElements = []
    object Bevel1: TBevel
      Left = 626
      Top = 10
      Width = 95
      Height = 73
      Shape = bsFrame
    end
    object lbClip: TLabel
      Left = 10
      Top = 93
      Width = 210
      Height = 20
      AutoSize = False
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1082#1083#1080#1087#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object lbSong: TLabel
      Left = 10
      Top = 123
      Width = 210
      Height = 20
      AutoSize = False
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1077#1089#1085#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object lbSinger: TLabel
      Left = 10
      Top = 153
      Width = 210
      Height = 20
      AutoSize = False
      Caption = #1048#1089#1087#1086#1083#1085#1080#1090#1077#1083#1100':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object lbTotalDurTxt: TLabel
      Left = 10
      Top = 251
      Width = 240
      Height = 20
      AutoSize = False
      Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1084#1077#1076#1080#1072'-'#1076#1072#1085#1085#1099#1093':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object lbNTKTxt: TLabel
      Left = 10
      Top = 280
      Width = 204
      Height = 20
      AutoSize = False
      Caption = #1053#1072#1095#1072#1083#1086' '#1074#1086#1089#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object lbDURTxt: TLabel
      Left = 10
      Top = 310
      Width = 251
      Height = 20
      AutoSize = False
      Caption = #1061#1088#1086#1085#1086#1084#1077#1090#1088#1072#1078' '#1074#1086#1089#1087#1088#1086#1080#1079#1074'-'#1080#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object lbTypeTxt: TLabel
      Left = 10
      Top = 347
      Width = 210
      Height = 19
      AutoSize = False
      Caption = #1058#1080#1087' '#1084#1077#1076#1080#1072'-'#1076#1072#1085#1085#1099#1093
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object lbType1: TLabel
      Left = 241
      Top = 349
      Width = 478
      Height = 49
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      StyleElements = []
    end
    object Label1: TLabel
      Left = 10
      Top = 183
      Width = 210
      Height = 20
      AutoSize = False
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
    end
    object SpeedButton3: TSpeedButton
      Left = 627
      Top = 11
      Width = 93
      Height = 71
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      StyleElements = []
      OnClick = SpeedButton3Click
    end
    object LbTypeMedia: TLabel
      Left = 240
      Top = 350
      Width = 317
      Height = 22
      AutoSize = False
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 4
      Width = 615
      Height = 78
      Caption = #1060#1072#1081#1083'-'#1084#1077#1076#1080#1072' '#1076#1072#1085#1085#1099#1093': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      StyleElements = []
      object lbFile: TLabel
        Left = 2
        Top = 15
        Width = 611
        Height = 60
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Caption = #1048#1084#1087#1086#1088#1090#1080#1088#1091#1077#1084#1099#1081' '#1092#1072#1081#1083
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
      end
    end
    object GroupBox1: TGroupBox
      Left = 424
      Top = 245
      Width = 297
      Height = 86
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      StyleElements = []
      object lbStartTimeTxt: TLabel
        Left = 31
        Top = 49
        Width = 102
        Height = 16
        Caption = #1042#1088#1077#1084#1103' '#1089#1090#1072#1088#1090#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object edClip: TEdit
      Left = 240
      Top = 93
      Width = 481
      Height = 22
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = 'edClip'
      StyleElements = []
      OnKeyUp = edClipKeyUp
    end
    object edSong: TEdit
      Left = 240
      Top = 123
      Width = 481
      Height = 22
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      Text = 'edSong'
      StyleElements = []
      OnKeyUp = edSongKeyUp
    end
    object edSinger: TEdit
      Left = 240
      Top = 153
      Width = 481
      Height = 22
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 2
      Text = 'edSinger'
      StyleElements = []
      OnKeyUp = edSingerKeyUp
    end
    object mmComment: TMemo
      Left = 240
      Top = 183
      Width = 481
      Height = 62
      Ctl3D = False
      Lines.Strings = (
        'mmComment')
      ParentCtl3D = False
      TabOrder = 3
      StyleElements = []
      OnKeyUp = mmCommentKeyUp
    end
    object edTotalDur: TEdit
      Left = 240
      Top = 252
      Width = 95
      Height = 22
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '00:00:00:00'
      StyleElements = []
      OnChange = edTotalDurChange
      OnKeyDown = edTotalDurKeyDown
      OnKeyPress = edTotalDurKeyPress
    end
    object edNTK: TEdit
      Left = 240
      Top = 281
      Width = 95
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      Text = '00:00:00:00'
      StyleElements = []
      OnChange = edNTKChange
      OnKeyDown = edNTKKeyDown
      OnKeyPress = edNTKKeyPress
    end
    object EdDur: TEdit
      Left = 240
      Top = 310
      Width = 95
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Text = '00:00:00:00'
      StyleElements = []
      OnChange = EdDurChange
      OnKeyDown = EdDurKeyDown
      OnKeyPress = EdDurKeyPress
    end
    object EdStartTime: TEdit
      Left = 576
      Top = 293
      Width = 95
      Height = 22
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      Text = '00:00:00:00'
      StyleElements = []
      OnChange = EdStartTimeChange
      OnKeyDown = EdStartTimeKeyDown
      OnKeyPress = EdStartTimeKeyPress
    end
    object CheckBox1: TCheckBox
      Left = 455
      Top = 268
      Width = 265
      Height = 17
      Caption = #1042#1086#1089#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1077' '#1087#1086' '#1074#1088#1077#1084#1077#1085#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      StyleElements = []
      OnClick = CheckBox1Click
    end
  end
  object Panel1: TPanel
    Left = 600
    Top = 353
    Width = 241
    Height = 189
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    Visible = False
    StyleElements = []
    object Label3: TLabel
      Left = 0
      Top = 0
      Width = 241
      Height = 52
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1077': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      StyleElements = []
      ExplicitLeft = -32
      ExplicitTop = -15
    end
    object mmMistakes: TMemo
      Left = 0
      Top = 52
      Width = 241
      Height = 137
      Align = alClient
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'mmMistakes')
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      StyleElements = []
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      #1060#1072#1081#1083#1099' '#1084#1091#1083#1100#1090#1080#1084#1077#1076#1080#1072'|*.mp3;*.wma;*.wav;*.vob;*.avi;*.mpg;*.mp4;*.mo' +
      'v;*.mpeg;*.flv;*.wmv;*.qt;|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = #1054#1090#1082#1088#1099#1090#1080#1077' '#1084#1091#1083#1100#1090#1080#1084#1077#1076#1080#1072' '#1092#1072#1081#1083#1086#1074
    Left = 688
    Top = 8
  end
end
