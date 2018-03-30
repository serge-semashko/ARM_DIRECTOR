object Form2: TForm2
  Left = 381
  Top = 247
  Width = 1142
  Height = 656
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object PanelProject: TPanel
    Left = 0
    Top = 0
    Width = 1126
    Height = 618
    Align = alClient
    BevelOuter = bvNone
    Caption = #1055#1088#1086#1077#1082#1090
    TabOrder = 0
    Visible = False
    object Panel6: TPanel
      Left = 288
      Top = 0
      Width = 838
      Height = 618
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel6'
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object Splitter1: TSplitter
        Left = 0
        Top = 88
        Width = 838
        Height = 5
        Cursor = crVSplit
        Align = alTop
      end
      object Panel10: TPanel
        Left = 0
        Top = 93
        Width = 838
        Height = 525
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel10'
        TabOrder = 0
        object Panel11: TPanel
          Left = 0
          Top = 0
          Width = 838
          Height = 49
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object sbListPlayLists: TSpeedButton
            Left = 1
            Top = 19
            Width = 185
            Height = 30
            Caption = #1055#1083#1077#1081'-'#1083#1080#1089#1090#1099
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object sbListGraphTemplates: TSpeedButton
            Left = 187
            Top = 19
            Width = 185
            Height = 30
            Caption = #1043#1088#1072#1092#1080#1095#1077#1089#1082#1080#1077' '#1096#1072#1073#1083#1086#1085#1099
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object sbListTextTemplates: TSpeedButton
            Left = 372
            Top = 19
            Width = 185
            Height = 30
            Caption = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1096#1072#1073#1083#1086#1085#1099
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Bevel4: TBevel
            Left = 185
            Top = 0
            Width = 2
            Height = 30
            Shape = bsLeftLine
            Visible = False
          end
          object Bevel5: TBevel
            Left = 371
            Top = 1
            Width = 2
            Height = 29
            Shape = bsLeftLine
            Visible = False
          end
        end
        object GridLists: TStringGrid
          Left = 0
          Top = 49
          Width = 838
          Height = 476
          Align = alClient
          BorderStyle = bsNone
          Color = clMoneyGreen
          Ctl3D = False
          FixedCols = 0
          GridLineWidth = 0
          Options = [goFixedHorzLine, goHorzLine, goRowSelect]
          ParentCtl3D = False
          ScrollBars = ssNone
          TabOrder = 1
          ColWidths = (
            64
            64
            64
            64
            64)
        end
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 838
        Height = 88
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel5'
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        object GridProjects: TStringGrid
          Left = 0
          Top = 0
          Width = 838
          Height = 88
          Align = alClient
          BorderStyle = bsNone
          Color = clMoneyGreen
          Ctl3D = False
          DefaultRowHeight = 30
          FixedCols = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          GridLineWidth = 0
          Options = [goFixedHorzLine, goHorzLine, goRowMoving, goRowSelect]
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssNone
          TabOrder = 0
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 288
      Height = 618
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object imgButtonsProject: TImage
        Left = 0
        Top = 0
        Width = 288
        Height = 97
        Align = alTop
      end
      object imgBlockProjects: TImage
        Left = 15
        Top = 288
        Width = 24
        Height = 24
        Picture.Data = {
          07544269746D6170A2070000424DA20700000000000036000000280000001900
          00001900000001001800000000006C0700000000000000000000000000000000
          0000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC80000000000000000000000000000000000000000000000000000
          00000000000000000000000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000C3C3C3C3C3C3C3C3C3C3C3C3C3C3
          C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3C3000000E7BFC8E7
          BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDE
          DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEC3C3C3C3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7FFF
          FFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEC3C3C37F7F7FFFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3
          000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FF
          FFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7F7F7F7FC3C3C3FFFFFFDEDEDE
          DEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
          BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C37F7F7F
          7F7F7FC3C3C3FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BF
          C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEC3C3C37F7F7FFFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7BFC8E7BFC800E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFFFFFFDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEC3C3C3000000E7
          BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFF7F7F7F000000E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8E7BFC800000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000E7BFC8E7BFC8E7BFC800E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE00
          0000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8
          E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7
          BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000
          FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
          BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BF
          C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFF
          DEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE0000
          00E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8000000DEDEDEDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDE000000E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC8000000DEDEDEDEDEDE000000E7BFC8E7BFC8E7
          BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC80000
          00FFFFFFDEDEDEDEDEDE000000000000000000000000000000DEDEDEFFFFFFDE
          DEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8E7BFC8E7BFC8000000FFFFFFDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEFFFFFFFFFFFFDEDEDE000000E7BFC8E7BFC8E7BFC8E7BFC800E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8000000FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEDEDE000000E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7
          BFC8E7BFC8000000000000000000000000000000000000000000000000000000
          000000E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC800E7BFC8E7BFC8E7BFC8E7
          BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C800E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8
          E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BFC8E7BF
          C8E7BFC8E7BFC8E7BFC8E7BFC800}
        Stretch = True
        Transparent = True
      end
      object lbProjectName: TLabel
        Left = 0
        Top = 96
        Width = 288
        Height = 48
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Caption = #1055#1088#1086#1077#1082#1090' '#1085#1077' '#1074#1099#1073#1088#1072#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
      end
      object lbDateEnd: TLabel
        Left = 150
        Top = 254
        Width = 125
        Height = 25
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object lbDateStart: TLabel
        Left = 150
        Top = 230
        Width = 125
        Height = 25
        Align = alCustom
        Alignment = taCenter
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
      end
      object Label3: TLabel
        Left = 15
        Top = 205
        Width = 120
        Height = 25
        AutoSize = False
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label4: TLabel
        Left = 15
        Top = 230
        Width = 120
        Height = 24
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1089#1086#1079#1076#1072#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object Label5: TLabel
        Left = 15
        Top = 254
        Width = 120
        Height = 26
        AutoSize = False
        Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object lbEditor: TLabel
        Left = 150
        Top = 205
        Width = 125
        Height = 25
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
      end
      object lbpComment: TLabel
        Left = 0
        Top = 142
        Width = 287
        Height = 60
        Alignment = taCenter
        AutoSize = False
        Layout = tlCenter
        WordWrap = True
      end
      object imgButtonsControlProj: TImage
        Left = 0
        Top = 437
        Width = 288
        Height = 181
        Align = alBottom
      end
      object GridTimeLines: TStringGrid
        Left = 1
        Top = 313
        Width = 286
        Height = 56
        Align = alCustom
        BorderStyle = bsNone
        Color = clBtnFace
        ColCount = 3
        Ctl3D = False
        DefaultRowHeight = 25
        FixedCols = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [goRowSelect]
        ParentCtl3D = False
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 0
        ColWidths = (
          34
          102
          142)
      end
    end
  end
end
