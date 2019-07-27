object frm_split: Tfrm_split
  Left = 655
  Top = 265
  Width = 459
  Height = 234
  Caption = #25286#20998
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object btnOk: TButton
    Left = 320
    Top = 24
    Width = 121
    Height = 25
    Caption = #30830#23450
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOkClick
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 0
    Width = 289
    Height = 207
    Align = alLeft
    TabOrder = 1
    object cxGrid1DBTableView1: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      NavigatorButtons.First.Visible = False
      NavigatorButtons.PriorPage.Visible = False
      NavigatorButtons.Prior.Visible = False
      NavigatorButtons.Next.Visible = False
      NavigatorButtons.NextPage.Visible = False
      NavigatorButtons.Last.Visible = False
      NavigatorButtons.Post.Visible = False
      NavigatorButtons.Refresh.Visible = False
      NavigatorButtons.SaveBookmark.Visible = False
      NavigatorButtons.GotoBookmark.Visible = False
      NavigatorButtons.Filter.Visible = False
      DataController.DataSource = ds2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.Navigator = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object cxGrid1DBTableView1autoid: TcxGridDBColumn
        Caption = #26469#28304'ID'
        DataBinding.FieldName = 'autoid'
        HeaderAlignmentHorz = taCenter
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
      end
      object cxGrid1DBTableView1qty: TcxGridDBColumn
        Caption = #25968#37327
        DataBinding.FieldName = 'qty'
        HeaderAlignmentHorz = taCenter
        Options.Filtering = False
        Options.Moving = False
        Width = 136
      end
    end
    object cxGrid1Level1: TcxGridLevel
      GridView = cxGrid1DBTableView1
    end
  end
  object btnCancel: TButton
    Left = 320
    Top = 80
    Width = 121
    Height = 25
    Cancel = True
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
  end
  object ds2: TDataSource
    DataSet = ds1
    Left = 336
    Top = 120
  end
  object ds1: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    Left = 288
    Top = 152
    Data = {
      350000009619E0BD010000001800000002000000000003000000350006617574
      6F696404000100000000000371747908000400000000000000}
    object ds1autoid: TIntegerField
      FieldName = 'autoid'
    end
    object ds1qty: TFloatField
      FieldName = 'qty'
    end
  end
end
