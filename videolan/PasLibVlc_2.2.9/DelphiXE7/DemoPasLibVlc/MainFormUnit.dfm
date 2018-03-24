object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'libvlc demo'
  ClientHeight = 453
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object OpenDialog: TOpenDialog
    DefaultExt = '*.*'
    Title = 'Select file to play'
    Left = 8
    Top = 12
  end
  object MainMenu: TMainMenu
    Left = 44
    Top = 12
    object MenuFile: TMenuItem
      Caption = 'File'
      object MenuFileOpen: TMenuItem
        Caption = 'Open'
        OnClick = MenuFileOpenClick
      end
      object MenuFileQuit: TMenuItem
        Caption = 'Quit'
        OnClick = MenuFileQuitClick
      end
    end
  end
end
