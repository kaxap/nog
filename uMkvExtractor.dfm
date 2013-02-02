object frmMkvExtractor: TfrmMkvExtractor
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Subtitle extractor'
  ClientHeight = 137
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 156
    Height = 13
    Caption = 'Extracting subtitles, please wait...'
  end
  object lblProgress: TLabel
    Left = 32
    Top = 90
    Width = 3
    Height = 13
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 40
    Width = 353
    Height = 25
    TabOrder = 0
  end
  object Button1: TButton
    Left = 280
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
  end
end
