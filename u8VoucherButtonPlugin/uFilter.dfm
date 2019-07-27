object frm_Filter: Tfrm_Filter
  Left = 552
  Top = 191
  Width = 474
  Height = 362
  Caption = #36807#28388
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
  object pnl1: TPanel
    Left = 0
    Top = 294
    Width = 466
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btn_Exit: TButton
      Left = 358
      Top = 8
      Width = 91
      Height = 25
      Cancel = True
      Caption = #21462#28040'(&C)'
      ModalResult = 2
      TabOrder = 0
    end
    object btn_OK: TButton
      Left = 240
      Top = 8
      Width = 91
      Height = 25
      Caption = #30830#23450'(&O)'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btn_OKClick
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 0
    Width = 466
    Height = 144
    VertScrollBar.Tracking = True
    Align = alClient
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    object cxLabel1: TcxLabel
      Left = 136
      Top = 40
      AutoSize = False
      Caption = 'cxLabel1'
      Height = 16
      Width = 177
    end
    object cxButtonEdit1: TcxButtonEdit
      Left = 240
      Top = 88
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Text = 'cxButtonEdit1'
      Width = 121
    end
    object cxTextEdit1: TcxTextEdit
      Left = 128
      Top = 104
      TabOrder = 2
      Text = 'cxTextEdit1'
      Width = 121
    end
    object cxCalcEdit1: TcxCalcEdit
      Left = 256
      Top = 24
      EditValue = 0.000000000000000000
      TabOrder = 3
      Width = 121
    end
  end
  object lv1: TListView
    Left = 0
    Top = 144
    Width = 466
    Height = 150
    Align = alBottom
    Columns = <
      item
        Caption = 'autoid'
      end
      item
        Caption = 'fdname'
      end
      item
        Caption = 'EditType'
      end
      item
        Caption = 'OperChar'
      end
      item
        Caption = 'Value'
      end
      item
        Caption = 'ControlName'
      end>
    GridLines = True
    MultiSelect = True
    RowSelect = True
    TabOrder = 2
    ViewStyle = vsReport
    Visible = False
  end
end
