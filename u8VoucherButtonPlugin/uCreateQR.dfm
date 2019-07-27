object frmCreateQR: TfrmCreateQR
  Left = 737
  Top = 306
  Width = 513
  Height = 446
  Caption = #34917#24405#26465#30721
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxgrdCreateQR: TcxGrid
    Left = 0
    Top = 0
    Width = 505
    Height = 378
    Align = alClient
    TabOrder = 0
    object cxgrdbtblvwCreateQR: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = ds_QRCode
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Styles.StyleSheet = frmPub.cxgrdtblvwstylshtGridTableViewStyleSheetDevExpress
    end
    object cxgrdlvlGrid1Level1: TcxGridLevel
      GridView = cxgrdbtblvwCreateQR
    end
  end
  object pnlCreateQR: TPanel
    Left = 0
    Top = 378
    Width = 505
    Height = 41
    Align = alBottom
    TabOrder = 1
    object btnOk: TButton
      Left = 311
      Top = 8
      Width = 75
      Height = 25
      Caption = #30830#23450
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      Left = 407
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 1
    end
    object cxnvgtr1: TcxNavigator
      Left = 1
      Top = 1
      Width = 180
      Height = 39
      Control = cxgrdbtblvwCreateQR
      Buttons.First.Visible = False
      Buttons.PriorPage.Visible = False
      Buttons.Prior.Visible = False
      Buttons.Next.Visible = False
      Buttons.NextPage.Visible = False
      Buttons.Last.Visible = False
      Buttons.Refresh.Visible = False
      Buttons.SaveBookmark.Visible = False
      Buttons.GotoBookmark.Visible = False
      Buttons.Filter.Visible = False
      Align = alLeft
      TabOrder = 2
    end
  end
  object ds_QRCode: TDataSource
    DataSet = dsQRCode
    Left = 64
    Top = 88
  end
  object dsQRCode: TADODataSet
    BeforeOpen = dsQRCodeBeforeOpen
    AfterOpen = dsQRCodeAfterOpen
    AfterInsert = dsQRCodeAfterInsert
    BeforePost = dsQRCodeBeforePost
    Parameters = <>
    Left = 104
    Top = 88
  end
end
