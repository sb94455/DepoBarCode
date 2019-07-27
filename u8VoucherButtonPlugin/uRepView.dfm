object frmRepView: TfrmRepView
  Left = 562
  Top = 209
  Width = 699
  Height = 620
  Caption = #25171#21360#39044#35272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object frxprvw1: TfrxPreview
    Left = 0
    Top = 29
    Width = 691
    Height = 564
    Align = alClient
    OutlineVisible = True
    OutlineWidth = 121
    ThumbnailVisible = False
    UseReportHints = True
  end
  object tlb1: TToolBar
    Left = 0
    Top = 0
    Width = 691
    Height = 29
    ButtonHeight = 21
    ButtonWidth = 33
    Caption = 'tlb1'
    ShowCaptions = True
    TabOrder = 1
    object btn1: TToolButton
      Left = 0
      Top = 2
      Caption = #25171#21360
      ImageIndex = 0
      OnClick = btn1Click
    end
    object btn2: TToolButton
      Left = 33
      Top = 2
      Caption = #36864#20986
      ImageIndex = 1
      OnClick = btn2Click
    end
  end
end
