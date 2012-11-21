object frmMain: TfrmMain
  Left = 192
  Top = 124
  Width = 442
  Height = 398
  Caption = 'Text Simplicity'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 426
    Height = 293
    Align = alClient
    BorderWidth = 5
    Color = clBlack
    TabOrder = 0
    object imgGysto: TImage
      Left = 6
      Top = 6
      Width = 414
      Height = 281
      Align = alClient
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 293
    Width = 426
    Height = 48
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnOpen: TButton
      Left = 16
      Top = 12
      Width = 81
      Height = 25
      Caption = 'Open subtitles'
      TabOrder = 0
      OnClick = btnOpenClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 341
    Width = 426
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object OpenDialog1: TOpenDialog
    Filter = 'SRT files|*.srt'
    Left = 16
    Top = 16
  end
end
