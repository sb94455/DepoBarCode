unit ufrmDispatchlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Math, Dialogs, DB, ADODB, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, StdCtrls, ExtCtrls, Buttons, ComCtrls, ToolWin, frxClass, frxPreview,
  frxExportRTF, frxExportXLS, frxExportPDF, frxGradient, frxBarcode, frxOLE,
  frxDesgn, frxDBSet, xmldom, XMLIntf, msxmldom, XMLDoc, cxContainer, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  ActnList, Menus, Grids, DBGrids, cxInplaceContainer, cxVGrid, cxOI,
  frxADOComponents, DBClient;

type
  TfrmDispatchlist = class(TForm)
    conMain: TADOConnection;
    dsQRCode: TADODataSet;
    frxReport1: TfrxReport;
    clbr1: TCoolBar;
    tlb1: TToolBar;
    btnPrint: TToolButton;
    dlgSave1: TSaveDialog;
    frxOLEObject1: TfrxOLEObject;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxGradientObject1: TfrxGradientObject;
    frxPDFExport1: TfrxPDFExport;
    frxXLSExport1: TfrxXLSExport;
    frxRTFExport1: TfrxRTFExport;
    btnExit: TToolButton;
    frxdbdtstQRCode: TfrxDBDataset;
    mmo1: TMemo;
    lblSelTemplate: TLabel;
    cxgrdbtblvwVouchRows: TcxGridDBTableView;
    cxgrdlvlVouchRows: TcxGridLevel;
    cxgrdVouchRows: TcxGrid;
    spl1: TSplitter;
    cxgrdbtblvwQRCodes: TcxGridDBTableView;
    cxgrdlvlQRCodes: TcxGridLevel;
    cxgrdQRCodes: TcxGrid;
    qryVouchs: TADOQuery;
    ds_Vouchs: TDataSource;
    ds_QRCode: TDataSource;
    pmVouchs: TPopupMenu;
    actlstVouchers: TActionList;
    actCreateQR: TAction;
    cxgrdbclmnVouchRowsAutoId: TcxGridDBColumn;
    cxgrdbclmnVouchRowsVouchType: TcxGridDBColumn;
    cxgrdbclmnVouchRowsVouchId: TcxGridDBColumn;
    cxgrdbclmnVouchRowsVouchRowId: TcxGridDBColumn;
    cxgrdbclmnVouchRowsCreateDateTime: TcxGridDBColumn;
    cxgrdbclmnVouchRowsCreateType: TcxGridDBColumn;
    cxgrdbclmnVouchRowsPrintCount: TcxGridDBColumn;
    cxgrdbclmnVouchRowsStatue: TcxGridDBColumn;
    btnReportManage: TToolButton;
    btn1: TToolButton;
    cxcbbReport: TcxLookupComboBox;
    ds_Report: TDataSource;
    qryReport: TADOQuery;
    actCreateAllQR: TAction;
    actNewMQR: TAction;
    actDelQR: TAction;
    actDelAllQr: TAction;
    pgc1: TPageControl;
    tsByVoucher: TTabSheet;
    tsByInventory: TTabSheet;
    cxgrdbtblvwInverntory: TcxGridDBTableView;
    cxgrdlvlGrid1Level1: TcxGridLevel;
    cxgrdInventory: TcxGrid;
    tlbByInventory: TToolBar;
    btnFilt: TToolButton;
    btnAddByInventory: TToolButton;
    actlstInventory: TActionList;
    tlbVoucher: TToolBar;
    btnCreateQR: TToolButton;
    btnCreateAllQR: TToolButton;
    btnNewMQR: TToolButton;
    actFilt: TAction;
    dsQrCodeByInventory: TADODataSet;
    ds_QrCodeByInventory: TDataSource;
    actAddByInventory: TAction;
    btnSelAll: TToolButton;
    cxgrdbclmnQRCodesColumn1: TcxGridDBColumn;
    actSelAll: TAction;
    actUnSelAll: TAction;
    actSelUnSel: TAction;
    btnSelUnSel: TToolButton;
    btnUnSelAll: TToolButton;
    btn4: TToolButton;
    cdsQRforPrint: TClientDataSet;
    N1: TMenuItem;
    btn2: TToolButton;
    frxdbdtstVouchs: TfrxDBDataset;
    btnPrintVouchs: TToolButton;
    procedure frxReport1Preview(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    function frxDesigner1SaveReport(frxReport1: TfrxReport; SaveAs: Boolean): Boolean;
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure qryReportBeforeOpen(DataSet: TDataSet);
    procedure qryVouchsBeforeOpen(DataSet: TDataSet);
    procedure actCreateQRExecute(Sender: TObject);
    procedure qryVouchsAfterOpen(DataSet: TDataSet);
    procedure conMainBeforeConnect(Sender: TObject);
    procedure btnReportManageClick(Sender: TObject);
    procedure cxcbbReportPropertiesChange(Sender: TObject);
    procedure actCreateAllQRExecute(Sender: TObject);
    procedure actDelQRExecute(Sender: TObject);
    procedure actNewMQRExecute(Sender: TObject);
    procedure actFiltExecute(Sender: TObject);
    procedure dsQrCodeByInventoryBeforeOpen(DataSet: TDataSet);
    procedure dsQrCodeByInventoryAfterOpen(DataSet: TDataSet);
    procedure actAddByInventoryExecute(Sender: TObject);
    procedure dsQRCodeAfterOpen(DataSet: TDataSet);
    procedure actSelAllExecute(Sender: TObject);
    procedure actUnSelAllExecute(Sender: TObject);
    procedure actSelUnSelExecute(Sender: TObject);
    procedure qryVouchsAfterScroll(DataSet: TDataSet);
    procedure cxgrdbtblvwQRCodesCellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure frxReport1PrintReport(Sender: TObject);
    procedure btnPrintVouchsClick(Sender: TObject);
  private
    { Private declarations }
    strSqlWhere, strCbbItemIndexValue: string;
    rpPrinted: Boolean;
    FVouchType: string;
    procedure SetVouchType(Value: string);
    procedure CopySelRowsToCds(ViewSoure: TcxGridDBTableView; cdsDes: TClientDataSet);
    procedure cxcbbReportQuery;
  public
    { Public declarations }
    KeyName: string;
    keyValue: string;
    property VouchType: string read FVouchType write SetVouchType;
  end;

var
  frmDispatchlist: TfrmDispatchlist;

implementation

uses
  ufrmReportManage, ufmPub, uCreateQR, uFilter, uRepView;
{$R *.dfm}

procedure TfrmDispatchlist.SetVouchType(Value: string);
begin
  FVouchType := Value;
  cxcbbReportQuery;
end;

procedure TfrmDispatchlist.frxReport1Preview(Sender: TObject);
var
  frmPreview: TfrxPreviewForm;
begin
  Exit;
  (Sender as TfrxReport).PreviewOptions.Modal := False;
  frmPreview := TfrxPreviewForm((Sender as TfrxReport).PreviewForm);
  frmPreview.BorderStyle := bsNone;
  frmPreview.Parent := Self;
  frmPreview.Align := alClient;
  frmPreview.CancelB.Visible := False;
end;

procedure TfrmDispatchlist.btnPrintClick(Sender: TObject);
var
  ms: TMemoryStream;
  i: Integer;
begin
  if Trim(cxcbbReport.EditText) = '' then
    Exit;

  try
    CopySelRowsToCds(cxgrdbtblvwQRCodes, cdsQRforPrint);
    if cdsQRforPrint.RecordCount <= 0 then
    begin
      MessageBox(Handle, '未选择任何记录，请选择后继续 。', '提示', MB_ICONINFORMATION + MB_OK);
      Abort;
    end;
    GetBaseFile(StrToInt(VarToStr(cxcbbReport.EditValue)), ms);
    frxReport1.LoadFromStream(ms);
    rpPrinted := False;
    frxReport1.DataSets.Clear;
    for i := 0 to Self.ComponentCount - 1 do
    begin
      if Self.Components[i] is TfrxDataSet then
        frxReport1.DataSets.Add(Self.Components[i] as TfrxDataSet);
    end;
    frxReport1.PrepareReport();
    frxReport1.ShowReport();


//    if frmRepView = nil then
//      frmRepView := TfrmRepView.Create(nil);
//    frxReport1.Preview := frmRepView.frxprvw1;
//    if frxReport1.PrepareReport then
//    begin
//      frxReport1.ShowPreparedReport;
//      frmRepView.ShowModal;
////      frxReport1.Preview:=nil;
////      FreeAndNil(frmRepView);
//    end;
//    if frmRepView.PrintFlag <> True then
//      Exit;
    if rpPrinted = False then
      Exit;
    if cdsQRforPrint.RecordCount <= 0 then
      Exit;
    with TADOQuery.Create(nil) do
    begin
      try
        ConnectionString := strDBConnectString;
        LockType := ltOptimistic;
        SQL.Text := 'select * from SZHL_QRCodeRecord where 1=2';
        Open;
        cdsQRforPrint.First;
        while not cdsQRforPrint.Eof do
        begin
          Append;
          FieldByName('SrcId').Value := cdsQRforPrint.FieldByName('AutoID').Value;
          FieldByName('dAction').Value := 'Print';
          FieldByName('dDatetime').Value := Now;
          FieldByName('cUser').Value := Login_cUserName;
          FieldByName('cIPAdress').Value := GetComputerName;
          FieldByName('cHostName').Value := GetHostIP;
          Post;
          cdsQRforPrint.Next;
        end;
      finally
        Free;
      end;
    end;

  finally
    FreeAndNil(ms);
  end;
end;

procedure TfrmDispatchlist.CopySelRowsToCds(ViewSoure: TcxGridDBTableView; cdsDes: TClientDataSet);
var
  i, j: Integer;
  artFlt, flrft: Boolean;
  mStream: TMemoryStream;
begin

  try
    artFlt := True; //设置将要改变过滤的标志
    mStream := TMemoryStream.Create;
    mStream.Position := 0; //流指针指向开始位
    cdsDes.Close;
    cdsDes.FieldDefs.Clear;
    cdsDes.FieldDefs.Assign(ViewSoure.DataController.DataSet.FieldDefs);
    cdsDes.CreateDataSet;
    ViewSoure.DataController.Filter.Root.Criteria.SaveToStream(mStream); //将过滤状态存入流
    flrft := ViewSoure.DataController.Filter.Active; //保存过滤状态是否激活
    ViewSoure.DataController.Filter.Root.Clear; //清除原有过滤设置
    ViewSoure.DataController.Filter.Root.AddItem(ViewSoure.Columns[0], foEqual, 'True', '√ '); //以0列为真过滤
    ViewSoure.DataController.Filter.Active := True; //激活过滤
    if ViewSoure.DataController.FilteredRecordCount > 0 then  //过滤后有记录数
    begin
      for j := 0 to ViewSoure.ViewData.RowCount - 1 do//以行数循环
      begin
        ViewSoure.DataController.DataSet.RecNo := ViewSoure.ViewData.Rows[j].RecordIndex + 1; //定位数据集记录指针
      //将记录追加到本地数据集：
        cdsDes.Append;
        for i := 0 to cdsDes.FieldCount - 1 do
          if cdsDes.Fields.Fields[i].CanModify then
            cdsDes.Fields.Fields[i].AsVariant := ViewSoure.DataController.DataSet.Fields.Fields[i].AsVariant;
        cdsDes.Post;
      end;
    end;

  //恢复客户过滤状态：
    ViewSoure.DataController.Filter.Root.Clear; //清除原有过滤设置
    mStream.Position := 0;
    ViewSoure.DataController.Filter.Root.Criteria.LoadFromStream(mStream);
    ViewSoure.DataController.Filter.Active := flrft;
    artFlt := False;
  finally
    FreeAndNil(mStream);
  end;
end;

function TfrmDispatchlist.frxDesigner1SaveReport(frxReport1: TfrxReport; SaveAs: Boolean): Boolean;
var
  ms: TMemoryStream;
begin
  if SaveAs then
    inherited
  else
  begin
    try
      ms := TMemoryStream.Create;
      frxReport1.SaveToStream(ms);
      SaveBaseFile(qryReport.FieldByName('id').AsInteger, VouchType, ms);
      MessageBox(Handle, '报表模板保存成功！', '提示', MB_ICONINFORMATION + MB_OK);
    finally
      FreeAndNil(ms);
    end;
  end;
  Result := True;
end;

procedure TfrmDispatchlist.FormShow(Sender: TObject);
var
  i: Integer;
begin

  if pgc1.PageCount > 0 then
    pgc1.ActivePageIndex := 0;
  FormatDBGridView(cxgrdbtblvwVouchRows);
  FormatDBGridView(cxgrdbtblvwQRCodes);
//  FormatDBGridView(cxgrdbtblvwQRPrint,'autoid');
  FormatDBGridView(cxgrdbtblvwInverntory);

  if Trim(keyValue) = '' then
    Exit;

  qryVouchs.Close;
  qryVouchs.Open;

end;

procedure TfrmDispatchlist.btnExitClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if Components[i] is TcxGridDBTableView then
    begin
      SaveGridViewColumns(Components[i] as TcxGridDBTableView);
    end;
  end;
  Close;
end;

procedure TfrmDispatchlist.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmDispatchlist.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F12) and (ssCtrl in Shift) then
  begin
    mmo1.Visible := not mmo1.Visible;
  end;
end;

procedure TfrmDispatchlist.qryReportBeforeOpen(DataSet: TDataSet);
begin
  (DataSet as TADOQuery).SQL.Text := Format('select * from SZHL_Report where VouchType=''%s''', [VouchType]);
end;

procedure TfrmDispatchlist.qryVouchsBeforeOpen(DataSet: TDataSet);
begin
  (DataSet as TADOQuery).SQL.Text := Format('select * from SZHL_DispatchListsView Where %s=%s', ['VouchId', keyValue]);
end;

procedure TfrmDispatchlist.qryVouchsAfterOpen(DataSet: TDataSet);
begin
  FillGridViewColumns(cxgrdbtblvwVouchRows, 'SZHL_DispatchListsView');

  dsQRCode.Close;
  dsQRCode.CommandText := 'select * from SZHL_QRCode Where VouchType=:VouchType and VouchsID=:VouchsID';     //-- where VouchType=:VouchType and VouchID=:VouchID
  dsQRCode.Parameters.ParamByName('VouchType').Value := VouchType;
  dsQRCode.Parameters.ParamByName('VouchsID').Value := qryVouchs.FieldByName('VouchsID').AsString;
  dsQRCode.Open;


//  dsQRPrint.Close;
//  dsQRPrint.CommandText := 'select * from SZHL_QRPrint where VouchType=:VouchType and VouchsID=:VouchsID';
//  dsQRPrint.Parameters.ParamByName('VouchType').Value := vouchType;
//  dsQRPrint.Parameters.ParamByName('VouchsID').Value := qryVouchs.FieldByName('VouchsID').AsString;
//  dsQRPrint.Open;
//  FillGridViewColumns(cxgrdbtblvwQRPrint, 'SZHL_QRPrint');
end;

procedure TfrmDispatchlist.conMainBeforeConnect(Sender: TObject);
begin
  conMain.ConnectionString := strDBConnectString;
end;

procedure TfrmDispatchlist.btnReportManageClick(Sender: TObject);
var
  i: Integer;
begin
  with TfrmReportManage.Create(Self) do
  begin
    frxrprtReport.DataSets.Clear;
    for i := 0 to Self.ComponentCount - 1 do
    begin
      if Self.Components[i] is TfrxDataSet then
      begin
        frxrprtReport.DataSets.Add(Self.Components[i] as TfrxDataSet);
//        ShowMessage((Self.Components[i] as TfrxDataSet).UserName);
      end;
    end;
    ReportClass := VouchType;
    ShowModal;
  end;
  cxcbbReportQuery;
end;

procedure TfrmDispatchlist.cxcbbReportQuery;
var
  i: Integer;
begin
  qryReport.Close;
  qryReport.Open;
  if cxcbbReport.Properties.ListSource.DataSet.RecordCount > 0 then
  begin
    cxcbbReport.ItemIndex := 0;
  end;
  if Trim(strCbbItemIndexValue) <> '' then
  begin
    for i := 0 to cxcbbReport.Properties.ListSource.DataSet.RecordCount - 1 do
    begin
      cxcbbReport.ItemIndex := i;
      if Trim(strCbbItemIndexValue) = Trim(VarToStr(cxcbbReport.EditValue)) then
        Exit;
    end;
  end;
end;

procedure TfrmDispatchlist.cxcbbReportPropertiesChange(Sender: TObject);
begin
  strCbbItemIndexValue := VarToStr(cxcbbReport.EditValue);
end;

procedure TfrmDispatchlist.actCreateQRExecute(Sender: TObject);
var
  strMsg: string;
begin
  if qryVouchs.Eof then
    Exit;
  strMsg := '';
  with TADOStoredProc.Create(nil) do
  begin
    try
      ConnectionString := strDBConnectString;
      ProcedureName := 'SZHL_CreateRd10QR';
      Parameters.Clear;
      Parameters.CreateParameter('@MoOrderDetails_Modid', ftInteger, pdInput, 100, qryVouchs.FieldByName('VouchsID').AsInteger);
      Parameters.CreateParameter('@msg', ftString, pdOutput, 100, '');
      Prepared;
      ExecProc;
      CreateQR;
      strMsg := strMsg + VarToStr(Parameters.ParamByName('@msg').Value);
      if Length(trim(strMsg)) > 0 then
      begin
        MessageBox(0, PChar(strMsg), '错误', MB_ICONWARNING + MB_OK);
      end
      else
      begin
        dsQRCode.Close;
        dsQRCode.Open;
        MessageBox(Handle, '当前行生成条码成功！', '提示', MB_ICONINFORMATION + MB_OK);
      end;
    finally
      Free
    end;
  end;
end;

procedure TfrmDispatchlist.actCreateAllQRExecute(Sender: TObject);
var
  bkVouchs: string;
  strMsgOk: string;
  strMsg: string;
  strMsgFail: string;
begin
  if qryVouchs.Eof then
    Exit;
  strMsg := '';
  strMsgOk := '';
  strMsgFail := '';
  with TADOStoredProc.Create(nil) do
  begin
    try
      bkVouchs := qryVouchs.Bookmark;
      qryVouchs.DisableControls;
      ConnectionString := strDBConnectString;
      ProcedureName := 'SZHL_CreateRd10QR';
      qryVouchs.First;
      while not qryVouchs.Eof do
      begin
        Parameters.Clear;
        Parameters.CreateParameter('@MoOrderDetails_Modid', ftInteger, pdInput, 1, qryVouchs.FieldByName('VouchsID').AsInteger);
        Parameters.CreateParameter('@msg', ftString, pdOutput, 100, '');
        Prepared;
        ExecProc;

        strMsg := VarToStr(Parameters.ParamByName('@msg').Value);
        if Length(trim(strMsg)) > 0 then
        begin
          strMsgFail := strMsgFail + strMsg + #10#13;
        end
        else
        begin
          strMsgOk := strMsgOk + 'ID为' + qryVouchs.FieldByName('VouchsID').AsString + '的行生成条码成功！' + #10#13;
        end;

        qryVouchs.Next;
      end;
      CreateQR;
      if Length(trim(strMsgOk)) > 0 then
      begin
        dsQRCode.Close;
        dsQRCode.Open;
      end;
      if (Length(trim(strMsgFail)) <= 0) and (Length(trim(strMsgOk)) > 0) then
      begin
        MessageBox(Handle, PChar('生成成功 ' + #10#13 + strMsgOk), '确认', MB_ICONINFORMATION + MB_OK);
      end
      else if (Length(trim(strMsgFail)) > 0) and (Length(trim(strMsgOk)) > 0) then
      begin
        MessageBox(Handle, PChar('部分生成成功 ' + #10#13 + strMsgOk + strMsgFail), '警告', MB_ICONWARNING + MB_OK);
      end
      else if (Length(trim(strMsgFail)) > 0) and (Length(trim(strMsgOk)) <= 0) then
      begin
        MessageBox(Handle, PChar(strMsgFail), '错误', MB_ICONWARNING + MB_OK);
      end;
    finally
      Free;
      qryVouchs.Bookmark := bkVouchs;
      qryVouchs.EnableControls;
    end;
  end;
end;

procedure TfrmDispatchlist.actDelQRExecute(Sender: TObject);
begin
  if dsQRCode.Eof then
    Exit;
end;

procedure TfrmDispatchlist.actNewMQRExecute(Sender: TObject);
begin
  if qryVouchs.Eof then
    Exit;

  with TfrmCreateQR.Create(Self) do
  begin
    try
      VouchID := qryVouchs.FieldByName('VouchID').Value;
      VouchsID := qryVouchs.FieldByName('VouchsID').Value;
      VouchType := Self.VouchType;
      cInvCode := qryVouchs.FieldByName('cInvCode').Value;
      cBatch := qryVouchs.FieldByName('cBatch').Value;
      CreateType := '按单据补码';
      Qty := qryVouchs.FieldByName('cInvDefine13').Value;
      if ShowModal = mrOk then
      begin
        dsQRCode.Close;
        dsQRCode.Open;
        CreateQR;
      end;
    finally
      Free
    end;
  end;
end;

procedure TfrmDispatchlist.actFiltExecute(Sender: TObject);
begin
  with Tfrm_Filter.Create(Self) do
  begin
    try
      strTBName := 'SZHL_QRCode';
      if ShowModal = mrOk then
      begin
        strSqlWhere := 'where CreateType not like ''%单据%''  ' + strWhere;
        dsQrCodeByInventory.Close;
        dsQrCodeByInventory.Open;
      end;
    finally
      Free
    end;
  end;
end;

procedure TfrmDispatchlist.dsQrCodeByInventoryBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet as TADODataSet) do
  begin
    CommandText := 'select * from SZHL_QRCode ' + strSqlWhere;
  end;

end;

procedure TfrmDispatchlist.dsQrCodeByInventoryAfterOpen(DataSet: TDataSet);
begin
  FillGridSelColumn(cxgrdbtblvwInverntory, 'autoid');
  FillGridViewColumns(cxgrdbtblvwInverntory, 'SZHL_QRCodeByInventory');
end;

procedure TfrmDispatchlist.actAddByInventoryExecute(Sender: TObject);
begin
  with TfrmCreateQR.Create(Self) do
  try
    VouchType := Self.VouchType;
    CreateType := '手动补码';
    if ShowModal = mrOk then
    begin
      dsQrCodeByInventory.Close;
      dsQrCodeByInventory.Open;
      CreateQR;
    end;

  finally
    Free
  end;
end;

procedure TfrmDispatchlist.dsQRCodeAfterOpen(DataSet: TDataSet);
begin
  FillGridSelColumn(cxgrdbtblvwQRCodes, 'autoid');
  FillGridViewColumns(cxgrdbtblvwQRCodes, 'SZHL_QRCode', False);
end;

procedure TfrmDispatchlist.actSelAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to cxgrdbtblvwQRCodes.DataController.RowCount - 1 do
  begin
    cxgrdbtblvwQRCodes.ViewData.Rows[i].Values[0] := True;
  end;
end;

procedure TfrmDispatchlist.actUnSelAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to cxgrdbtblvwQRCodes.DataController.RowCount - 1 do
  begin
    cxgrdbtblvwQRCodes.ViewData.Rows[i].Values[0] := False;
  end;
end;

procedure TfrmDispatchlist.actSelUnSelExecute(Sender: TObject);
var
  i: integer;
  blValue: Boolean;
begin

  cxgrdbtblvwQRCodes.DataController.Post;
  for i := 0 to cxgrdbtblvwQRCodes.ViewData.RowCount - 1 do
  begin
    if VarIsNull(cxgrdbtblvwQRCodes.ViewData.Rows[i].Values[0]) then
      cxgrdbtblvwQRCodes.ViewData.Rows[i].Values[0] := False;
    cxgrdbtblvwQRCodes.ViewData.Rows[i].Values[0] := not cxgrdbtblvwQRCodes.ViewData.Rows[i].Values[0];
  end;
end;

procedure TfrmDispatchlist.qryVouchsAfterScroll(DataSet: TDataSet);
begin
  Exit;
  if dsQRCode.Active then
  begin
    dsQRCode.Close;
    dsQRCode.CommandText := 'select * from SZHL_QRCode  where VouchType=:VouchType and VouchsID=:VouchsID';     //-- where VouchType=:VouchType and VouchID=:VouchID
    dsQRCode.Parameters.ParamByName('VouchType').Value := VouchType;
    dsQRCode.Parameters.ParamByName('VouchsID').Value := qryVouchs.FieldByName('VouchsID').AsString;
    dsQRCode.Open;

  end;
end;

procedure TfrmDispatchlist.cxgrdbtblvwQRCodesCellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  i, iRowIndex: Integer;
  gv1: TcxGridDBTableView;
begin
  gv1 := Sender as TcxGridDBTableView;
  iRowIndex := ACellViewInfo.RecordViewInfo.Index;
  if (AButton = mbLeft) then
    if ([ssCtrl] = AShift) or ([ssShift] = AShift) then
    begin
      for i := 0 to gv1.DataController.GetSelectedCount - 1 do
      begin
        gv1.ViewData.Rows[gv1.DataController.GetSelectedRowIndex(i)].Values[0] := True;
      end;
    end;
  if (AButton = mbRight) then
    if ([ssCtrl] = AShift) or ([ssShift] = AShift) then
    begin
      for i := 0 to gv1.DataController.GetSelectedCount - 1 do
      begin
        gv1.ViewData.Rows[gv1.DataController.GetSelectedRowIndex(i)].Values[0] := False;
      end;
    end;
  AHandled := True;
end;

procedure TfrmDispatchlist.frxReport1PrintReport(Sender: TObject);
begin
  rpPrinted := True;
end;

procedure TfrmDispatchlist.btnPrintVouchsClick(Sender: TObject);
var
  ms: TMemoryStream;
  i: Integer;
begin
  if Trim(cxcbbReport.EditText) = '' then
    Exit;

  GetBaseFile(StrToInt(VarToStr(cxcbbReport.EditValue)), ms);
  frxReport1.LoadFromStream(ms);
  rpPrinted := False;
  frxReport1.DataSets.Clear;
  for i := 0 to Self.ComponentCount - 1 do
  begin
    if Self.Components[i] is TfrxDataSet then
      frxReport1.DataSets.Add(Self.Components[i] as TfrxDataSet);
  end;
  frxReport1.PrepareReport();
  frxReport1.ShowReport();
end;

end.

