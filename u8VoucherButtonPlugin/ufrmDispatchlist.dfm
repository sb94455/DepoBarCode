object frmDispatchlist: TfrmDispatchlist
  Left = 742
  Top = 232
  Width = 719
  Height = 613
  Caption = #21457#36135#21333#26465#30721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object clbr1: TCoolBar
    Left = 0
    Top = 0
    Width = 711
    Height = 29
    AutoSize = True
    Bands = <
      item
        Control = tlb1
        ImageIndex = -1
        Width = 707
      end>
    object tlb1: TToolBar
      Left = 9
      Top = 0
      Width = 694
      Height = 25
      ButtonHeight = 21
      ButtonWidth = 59
      Caption = 'tlb1'
      Flat = True
      ShowCaptions = True
      TabOrder = 0
      object lblSelTemplate: TLabel
        Left = 0
        Top = 0
        Width = 26
        Height = 21
        Caption = #27169#26495
      end
      object cxcbbReport: TcxLookupComboBox
        Left = 26
        Top = 0
        Properties.DropDownAutoSize = True
        Properties.KeyFieldNames = 'Id'
        Properties.ListColumns = <
          item
            FieldName = 'Id'
          end
          item
            Width = 100
            FieldName = 'Caption'
          end
          item
            Width = 100
            FieldName = 'Remark'
          end>
        Properties.ListFieldIndex = 1
        Properties.ListOptions.ShowHeader = False
        Properties.ListSource = ds_Report
        Properties.OnChange = cxcbbReportPropertiesChange
        TabOrder = 0
        Width = 145
      end
      object btnPrint: TToolButton
        Left = 171
        Top = 0
        Caption = #39044#35272
        ImageIndex = 1
        Visible = False
        OnClick = btnPrintClick
      end
      object btnPrintVouchs: TToolButton
        Left = 230
        Top = 0
        Caption = #25171#21360#21333#25454
        ImageIndex = 3
        OnClick = btnPrintVouchsClick
      end
      object btnReportManage: TToolButton
        Left = 289
        Top = 0
        Caption = #27169#26495#32500#25252
        ImageIndex = 3
        OnClick = btnReportManageClick
      end
      object btn1: TToolButton
        Left = 348
        Top = 0
        Width = 8
        Caption = 'btn1'
        ImageIndex = 3
        Style = tbsSeparator
      end
      object btnExit: TToolButton
        Left = 356
        Top = 0
        Caption = #36864#20986
        ImageIndex = 2
        OnClick = btnExitClick
      end
    end
  end
  object mmo1: TMemo
    Left = 0
    Top = 29
    Width = 711
    Height = 132
    Align = alTop
    Lines.Strings = (
      'mmo1')
    ScrollBars = ssBoth
    TabOrder = 1
    Visible = False
  end
  object pgc1: TPageControl
    Left = 0
    Top = 161
    Width = 711
    Height = 425
    ActivePage = tsByInventory
    Align = alClient
    TabOrder = 2
    object tsByVoucher: TTabSheet
      Caption = #20851#32852#21333#25454#26465#30721
      object spl1: TSplitter
        Left = 0
        Top = 29
        Width = 703
        Height = 3
        Cursor = crVSplit
        Align = alTop
      end
      object cxgrdVouchRows: TcxGrid
        Left = 0
        Top = 32
        Width = 703
        Height = 208
        Align = alClient
        TabOrder = 0
        object cxgrdbtblvwVouchRows: TcxGridDBTableView
          PopupMenu = pmVouchs
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = ds_Vouchs
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.HeaderHeight = 22
          Styles.StyleSheet = frmPub.cxgrdtblvwstylshtGridTableViewStyleSheetDevExpress
          object cxgrdbclmnVouchRowsAutoId: TcxGridDBColumn
            DataBinding.FieldName = 'AutoId'
          end
          object cxgrdbclmnVouchRowsVouchType: TcxGridDBColumn
            DataBinding.FieldName = 'VouchType'
          end
          object cxgrdbclmnVouchRowsVouchId: TcxGridDBColumn
            DataBinding.FieldName = 'VouchId'
          end
          object cxgrdbclmnVouchRowsVouchRowId: TcxGridDBColumn
            DataBinding.FieldName = 'VouchRowId'
          end
          object cxgrdbclmnVouchRowsCreateDateTime: TcxGridDBColumn
            DataBinding.FieldName = 'CreateDateTime'
          end
          object cxgrdbclmnVouchRowsCreateType: TcxGridDBColumn
            DataBinding.FieldName = 'CreateType'
          end
          object cxgrdbclmnVouchRowsPrintCount: TcxGridDBColumn
            DataBinding.FieldName = 'PrintCount'
          end
          object cxgrdbclmnVouchRowsStatue: TcxGridDBColumn
            DataBinding.FieldName = 'Statue'
          end
        end
        object cxgrdlvlVouchRows: TcxGridLevel
          GridView = cxgrdbtblvwVouchRows
        end
      end
      object cxgrdQRCodes: TcxGrid
        Left = 0
        Top = 240
        Width = 703
        Height = 157
        Align = alBottom
        TabOrder = 1
        Visible = False
        object cxgrdbtblvwQRCodes: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          OnCellClick = cxgrdbtblvwQRCodesCellClick
          DataController.DataSource = ds_QRCode
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsSelection.MultiSelect = True
          object cxgrdbclmnQRCodesColumn1: TcxGridDBColumn
          end
        end
        object cxgrdlvlQRCodes: TcxGridLevel
          GridView = cxgrdbtblvwQRCodes
        end
      end
      object tlbVoucher: TToolBar
        Left = 0
        Top = 0
        Width = 703
        Height = 29
        ButtonHeight = 21
        ButtonWidth = 59
        Caption = 'tlbVoucher'
        Indent = 10
        ShowCaptions = True
        TabOrder = 2
        Visible = False
        object btnCreateQR: TToolButton
          Left = 10
          Top = 2
          Action = actCreateQR
        end
        object btnCreateAllQR: TToolButton
          Left = 69
          Top = 2
          Action = actCreateAllQR
        end
        object btnNewMQR: TToolButton
          Left = 128
          Top = 2
          Action = actNewMQR
        end
        object btn4: TToolButton
          Left = 187
          Top = 2
          Width = 8
          Caption = 'btn4'
          ImageIndex = 2
          Style = tbsSeparator
        end
        object btnSelAll: TToolButton
          Left = 195
          Top = 2
          Action = actSelAll
        end
        object btnUnSelAll: TToolButton
          Left = 254
          Top = 2
          Action = actUnSelAll
        end
        object btnSelUnSel: TToolButton
          Left = 313
          Top = 2
          Action = actSelUnSel
        end
        object btn2: TToolButton
          Left = 372
          Top = 2
          Caption = 'btn2'
          ImageIndex = 0
          Visible = False
        end
      end
    end
    object tsByInventory: TTabSheet
      Caption = #33258#30001#26465#30721
      ImageIndex = 1
      object cxgrdInventory: TcxGrid
        Left = 0
        Top = 29
        Width = 703
        Height = 368
        Align = alClient
        TabOrder = 0
        object cxgrdbtblvwInverntory: TcxGridDBTableView
          NavigatorButtons.ConfirmDelete = False
          DataController.DataSource = ds_QrCodeByInventory
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Styles.StyleSheet = frmPub.cxgrdtblvwstylshtGridTableViewStyleSheetDevExpress
        end
        object cxgrdlvlGrid1Level1: TcxGridLevel
          GridView = cxgrdbtblvwInverntory
        end
      end
      object tlbByInventory: TToolBar
        Left = 0
        Top = 0
        Width = 703
        Height = 29
        ButtonHeight = 21
        ButtonWidth = 59
        Caption = 'tlbByInventory'
        Indent = 10
        ShowCaptions = True
        TabOrder = 1
        object btnFilt: TToolButton
          Left = 10
          Top = 2
          Action = actFilt
        end
        object btnAddByInventory: TToolButton
          Left = 69
          Top = 2
          Action = actAddByInventory
        end
      end
    end
  end
  object conMain: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=Szhlrj.com;Persist Security Info=Tr' +
      'ue;User ID=sa;Initial Catalog=UFDATA_001_2017;Data Source=192.16' +
      '8.1.200'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    BeforeConnect = conMainBeforeConnect
    Left = 80
    Top = 414
  end
  object dsQRCode: TADODataSet
    Connection = conMain
    CursorType = ctStatic
    AfterOpen = dsQRCodeAfterOpen
    CommandText = 'select * from SZHL_QRCode'
    Parameters = <>
    Left = 144
    Top = 414
  end
  object frxReport1: TfrxReport
    Version = '5.4.6'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = #39044#35774
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41781.352412766200000000
    ReportOptions.LastChange = 41781.352412766200000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'procedure Memo1OnAfterPrint(Sender: TfrxComponent);'
      'begin'
      ''
      'end;'
      ''
      'begin'
      ''
      'end.')
    OnPreview = frxReport1Preview
    OnPrintReport = frxReport1PrintReport
    Left = 112
    Top = 510
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
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 793.701300000000000000
        RowCount = 0
        object Memo1: TfrxMemoView
          Left = 30.236240000000000000
          Top = 3.779530000000000000
          Width = 110.866213330000000000
          Height = 12.598433330000000000
          OnAfterPrint = 'Memo1OnAfterPrint'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            'w')
          ParentFont = False
        end
      end
    end
  end
  object dlgSave1: TSaveDialog
    Left = 112
    Top = 542
  end
  object frxOLEObject1: TfrxOLEObject
    Left = 48
    Top = 510
  end
  object frxBarCodeObject1: TfrxBarCodeObject
    Left = 80
    Top = 478
  end
  object frxGradientObject1: TfrxGradientObject
    Left = 16
    Top = 510
  end
  object frxPDFExport1: TfrxPDFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PrintOptimized = False
    Outline = False
    Background = False
    HTMLTags = True
    Quality = 95
    Transparency = False
    Author = 'FastReport'
    Subject = 'FastReport PDF export'
    Creator = 'FastReport (http://www.fast-report.com)'
    ProtectionFlags = [ePrint, eModify, eCopy, eAnnot]
    HideToolbar = False
    HideMenubar = False
    HideWindowUI = False
    FitWindow = False
    CenterWindow = False
    PrintScaling = False
    PdfA = False
    Left = 80
    Top = 510
  end
  object frxXLSExport1: TfrxXLSExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    ExportEMF = True
    AsText = False
    Background = True
    FastExport = True
    PageBreaks = True
    EmptyLines = True
    SuppressPageHeadersFooters = False
    Left = 16
    Top = 542
  end
  object frxRTFExport1: TfrxRTFExport
    UseFileCache = True
    ShowProgress = True
    OverwritePrompt = False
    DataOnly = False
    PictureType = gpPNG
    Wysiwyg = True
    Creator = 'FastReport http://www.fast-report.com'
    SuppressPageHeadersFooters = False
    HeaderFooterMode = hfText
    AutoSize = False
    Left = 144
    Top = 510
  end
  object frxdbdtstQRCode: TfrxDBDataset
    Enabled = False
    UserName = #26465#30721
    CloseDataSource = False
    DataSet = cdsQRforPrint
    BCDToCurrency = False
    Left = 112
    Top = 478
  end
  object qryVouchs: TADOQuery
    Connection = conMain
    CursorType = ctStatic
    BeforeOpen = qryVouchsBeforeOpen
    AfterOpen = qryVouchsAfterOpen
    AfterScroll = qryVouchsAfterScroll
    Parameters = <>
    SQL.Strings = (
      'select * from SZHL_ArrivalVouchVIEW')
    Left = 48
    Top = 446
  end
  object ds_Vouchs: TDataSource
    DataSet = qryVouchs
    Left = 144
    Top = 446
  end
  object ds_QRCode: TDataSource
    DataSet = dsQRCode
    Left = 112
    Top = 446
  end
  object pmVouchs: TPopupMenu
    Left = 48
    Top = 542
    object N1: TMenuItem
      Caption = #22797#21046
    end
  end
  object actlstVouchers: TActionList
    Left = 48
    Top = 414
    object actCreateQR: TAction
      Caption = #29983#25104#24403#21069
      OnExecute = actCreateQRExecute
    end
    object actCreateAllQR: TAction
      Caption = #29983#25104#25152#26377
      OnExecute = actCreateAllQRExecute
    end
    object actNewMQR: TAction
      Caption = #21442#29031#34917#30721
      OnExecute = actNewMQRExecute
    end
    object actDelQR: TAction
      Caption = #21024#38500#24403#21069#35760#24405
      OnExecute = actDelQRExecute
    end
    object actDelAllQr: TAction
      Caption = #21024#38500#25152#26377#35760#24405
    end
    object actSelAll: TAction
      Caption = #36873#25321#25152#26377
      OnExecute = actSelAllExecute
    end
    object actUnSelAll: TAction
      Caption = #21462#28040#25152#26377
      OnExecute = actUnSelAllExecute
    end
    object actSelUnSel: TAction
      Caption = #21453#36873
      OnExecute = actSelUnSelExecute
    end
  end
  object ds_Report: TDataSource
    DataSet = qryReport
    Left = 16
    Top = 478
  end
  object qryReport: TADOQuery
    Connection = conMain
    CursorType = ctStatic
    BeforeOpen = qryReportBeforeOpen
    Parameters = <>
    SQL.Strings = (
      'select * from szhl_report')
    Left = 16
    Top = 446
  end
  object actlstInventory: TActionList
    Left = 16
    Top = 414
    object actFilt: TAction
      Caption = #26597#35810
      OnExecute = actFiltExecute
    end
    object actAddByInventory: TAction
      Caption = #25163#21160#34917#30721
      OnExecute = actAddByInventoryExecute
    end
  end
  object dsQrCodeByInventory: TADODataSet
    Connection = conMain
    CursorType = ctStatic
    BeforeOpen = dsQrCodeByInventoryBeforeOpen
    AfterOpen = dsQrCodeByInventoryAfterOpen
    CommandText = 'select * from SZHL_QRCode'
    Parameters = <>
    Left = 112
    Top = 414
  end
  object ds_QrCodeByInventory: TDataSource
    DataSet = dsQrCodeByInventory
    Left = 48
    Top = 478
  end
  object cdsQRforPrint: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 80
    Top = 446
  end
  object frxdbdtstVouchs: TfrxDBDataset
    UserName = #21333#25454
    CloseDataSource = False
    DataSet = qryVouchs
    BCDToCurrency = False
    Left = 224
    Top = 470
  end
end
