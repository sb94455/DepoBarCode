object frmReportManage: TfrmReportManage
  Left = 664
  Top = 255
  Width = 455
  Height = 361
  Caption = #25253#34920#31649#29702
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxgrd1: TcxGrid
    Left = 0
    Top = 29
    Width = 447
    Height = 305
    Align = alClient
    TabOrder = 0
    object cxgrdbtblvwReport: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = ds_Report
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Styles.StyleSheet = frmPub.cxgrdtblvwstylshtGridTableViewStyleSheetDevExpress
      object cxgrdbclmnReportColumn1: TcxGridDBColumn
      end
    end
    object cxgrdlvlReport: TcxGridLevel
      GridView = cxgrdbtblvwReport
    end
  end
  object tlb1: TToolBar
    Left = 0
    Top = 0
    Width = 447
    Height = 29
    ButtonHeight = 21
    ButtonWidth = 59
    Caption = 'tlb1'
    Flat = True
    ShowCaptions = True
    TabOrder = 1
    object btnADD: TToolButton
      Left = 0
      Top = 0
      Action = actADD
    end
    object btnModify: TToolButton
      Left = 59
      Top = 0
      Action = actModify
    end
    object btnSave: TToolButton
      Left = 118
      Top = 0
      Action = actSave
    end
    object btnCancel: TToolButton
      Left = 177
      Top = 0
      Action = actCancel
    end
    object btnDel: TToolButton
      Left = 236
      Top = 0
      Action = actDel
    end
    object btnDesign: TToolButton
      Left = 295
      Top = 0
      Action = actDesign
    end
    object btn2: TToolButton
      Left = 354
      Top = 0
      Width = 8
      Caption = 'btn2'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object btnExit: TToolButton
      Left = 362
      Top = 0
      Action = actExit
    end
  end
  object actlst1: TActionList
    Left = 16
    Top = 258
    object actADD: TAction
      Caption = #22686#21152
      OnExecute = actADDExecute
    end
    object actModify: TAction
      Caption = #20462#25913
      OnExecute = actModifyExecute
    end
    object actDel: TAction
      Caption = #21024#38500
      OnExecute = actDelExecute
    end
    object actSave: TAction
      Caption = #20445#23384
      OnExecute = actSaveExecute
    end
    object actDesign: TAction
      Caption = #35774#35745#25253#34920
      OnExecute = actDesignExecute
    end
    object actExit: TAction
      Caption = #36864#20986
      OnExecute = actExitExecute
    end
    object actCancel: TAction
      Caption = #21462#28040
      OnExecute = actCancelExecute
    end
  end
  object dsReport: TADODataSet
    BeforeOpen = dsReportBeforeOpen
    AfterOpen = dsReportAfterOpen
    AfterInsert = dsReportAfterInsert
    Parameters = <>
    Left = 48
    Top = 258
  end
  object ds_Report: TDataSource
    AutoEdit = False
    DataSet = dsReport
    Left = 80
    Top = 258
  end
  object frxrprtReport: TfrxReport
    Version = '5.4.6'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 42881.674438819440000000
    ReportOptions.LastChange = 42881.674438819440000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 144
    Top = 258
    Datasets = <>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
    end
  end
  object frxdsgnr1: TfrxDesigner
    CloseQuery = False
    DefaultScriptLanguage = 'PascalScript'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -13
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultLeftMargin = 10.000000000000000000
    DefaultRightMargin = 10.000000000000000000
    DefaultTopMargin = 10.000000000000000000
    DefaultBottomMargin = 10.000000000000000000
    DefaultPaperSize = 9
    DefaultOrientation = poPortrait
    TemplatesExt = 'fr3'
    Restrictions = []
    RTLLanguage = False
    MemoParentFont = False
    OnSaveReport = frxdsgnr1SaveReport
    Left = 112
    Top = 258
  end
end
