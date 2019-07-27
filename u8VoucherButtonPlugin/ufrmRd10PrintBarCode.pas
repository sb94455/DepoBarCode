unit ufrmRd10PrintBarCode;

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
  TfrmRd10PrintBarCode = class(TForm)
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
    btnSelect2Ok: TToolButton;
    frxdbdtstVouchs: TfrxDBDataset;
    btnPrintVouchs: TToolButton;
    pmQrCode: TPopupMenu;
    N21: TMenuItem;
    N22: TMenuItem;
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
    procedure ToolButton1Click(Sender: TObject);
    procedure btnSelect2OkClick(Sender: TObject);
    procedure pmQrCodePopup(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    strSqlWhere, strCbbItemIndexValue: string;
//    rpPrinted: Boolean;
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
  frmRd10PrintBarCode: TfrmRd10PrintBarCode;

implementation

uses
  ufrmReportManage, ufmPub, uCreateQR, uFilter, uRepView, uSplitQty;
{$R *.dfm}

procedure TfrmRd10PrintBarCode.SetVouchType(Value: string);
begin
  FVouchType := Value;
  cxcbbReportQuery;
end;

procedure TfrmRd10PrintBarCode.frxReport1Preview(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.btnPrintClick(Sender: TObject);
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
//    showmessage(format ('您已经选择了%d条记录.',[cdsQRforPrint.RecordCount]));
    GetBaseFile(StrToInt(VarToStr(cxcbbReport.EditValue)), ms);
    frxReport1.LoadFromStream(ms);
//    rpPrinted := False;
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
//    if rpPrinted = False then
//      Exit;
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

procedure TfrmRd10PrintBarCode.CopySelRowsToCds(ViewSoure: TcxGridDBTableView; cdsDes: TClientDataSet);
var
  i, j: Integer;
  artFlt, flrft: Boolean;
  mStream: TMemoryStream;
  SavePlace: TBookmark;
begin

  try
    artFlt := True; //设置将要改变过滤的标志
    mStream := TMemoryStream.Create;
    mStream.Position := 0; //流指针指向开始位
    cdsDes.close;
    cdsDes.FieldDefs.Clear;
    cdsDes.Fields.Clear;
    for i := 0 to ViewSoure.DataController.DataSet.FieldDefs.Count - 1 do
    begin
      with cdsDes.FieldDefs.AddFieldDef do
      begin
        Name := ViewSoure.DataController.DataSet.FieldDefs[i].Name;
        if SameText(Name, 'autoid') then
          DataType := ftInteger
        else
          DataType := ViewSoure.DataController.DataSet.FieldDefs[i].DataType;
        Size := ViewSoure.DataController.DataSet.FieldDefs[i].Size;
        Required := ViewSoure.DataController.DataSet.FieldDefs[i].Required;
        CreateField(cdsDes);
      end;
    end;
    cdsDes.CreateDataSet;
    cdsDes.Open;
    ViewSoure.DataController.Filter.Root.Criteria.SaveToStream(mStream); //将过滤状态存入流

    SavePlace := ViewSoure.DataController.DataSet.GetBookmark;
    ViewSoure.DataController.DataSet.DisableControls;

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
    ViewSoure.DataController.DataSet.GotoBookmark(SavePlace);
    ViewSoure.DataController.DataSet.FreeBookmark(SavePlace);
    ViewSoure.DataController.DataSet.EnableControls; //先定位再打开控件不会闪烁
  end;
end;

function TfrmRd10PrintBarCode.frxDesigner1SaveReport(frxReport1: TfrxReport; SaveAs: Boolean): Boolean;
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

procedure TfrmRd10PrintBarCode.FormShow(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.btnExitClick(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRd10PrintBarCode.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F12) and (ssCtrl in Shift) then
  begin
    mmo1.Visible := not mmo1.Visible;
  end;
end;

procedure TfrmRd10PrintBarCode.qryReportBeforeOpen(DataSet: TDataSet);
begin
  (DataSet as TADOQuery).SQL.Text := Format('select * from SZHL_Report where VouchType=''%s''', [VouchType]);
end;

procedure TfrmRd10PrintBarCode.qryVouchsBeforeOpen(DataSet: TDataSet);
begin
  (DataSet as TADOQuery).SQL.Text := Format('select * from SZHL_MoOrderVouchView Where %s=%s', ['VouchId', keyValue]);
end;

procedure TfrmRd10PrintBarCode.qryVouchsAfterOpen(DataSet: TDataSet);
begin
  FillGridViewColumns(cxgrdbtblvwVouchRows, 'SZHL_MoOrderVouchView');

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

procedure TfrmRd10PrintBarCode.conMainBeforeConnect(Sender: TObject);
begin
  conMain.ConnectionString := strDBConnectString;
end;

procedure TfrmRd10PrintBarCode.btnReportManageClick(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.cxcbbReportQuery;
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

procedure TfrmRd10PrintBarCode.cxcbbReportPropertiesChange(Sender: TObject);
begin
  strCbbItemIndexValue := VarToStr(cxcbbReport.EditValue);
end;

procedure TfrmRd10PrintBarCode.actCreateQRExecute(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.actCreateAllQRExecute(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.actDelQRExecute(Sender: TObject);
begin
  if dsQRCode.Eof then
    Exit;
end;

procedure TfrmRd10PrintBarCode.actNewMQRExecute(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.actFiltExecute(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.dsQrCodeByInventoryBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet as TADODataSet) do
  begin
    CommandText := 'select * from SZHL_QRCode ' + strSqlWhere;
  end;

end;

procedure TfrmRd10PrintBarCode.dsQrCodeByInventoryAfterOpen(DataSet: TDataSet);
begin
  FillGridSelColumn(cxgrdbtblvwInverntory, 'autoid');
  FillGridViewColumns(cxgrdbtblvwInverntory, 'SZHL_QRCodeByInventory');
end;

procedure TfrmRd10PrintBarCode.actAddByInventoryExecute(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.dsQRCodeAfterOpen(DataSet: TDataSet);
begin
  FillGridSelColumn(cxgrdbtblvwQRCodes, 'autoid');
  FillGridViewColumns(cxgrdbtblvwQRCodes, 'SZHL_QRCode', False);
  if cxgrdbtblvwQRCodes.GetColumnByFieldName('printsign') <> nil then
    with cxgrdbtblvwQRCodes.DataController.Filter do
    begin
      AutoDataSetFilter := True;
      Root.Clear;
      Root.BoolOperatorKind := fboAnd;
      Root.AddItem(cxgrdbtblvwQRCodes.GetColumnByFieldName('printsign'), foEqual, null, '空');
//      Root.AddItem(cxgrdbtblvwQRCodes.GetColumnByFieldName('status'), foNotEqual, '作废', '作废');
      Active := True;
    end;
end;

procedure TfrmRd10PrintBarCode.actSelAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to cxgrdbtblvwQRCodes.DataController.RowCount - 1 do
  begin
    cxgrdbtblvwQRCodes.ViewData.Rows[i].Values[0] := True;
  end;
end;

procedure TfrmRd10PrintBarCode.actUnSelAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to cxgrdbtblvwQRCodes.DataController.RowCount - 1 do
  begin
    cxgrdbtblvwQRCodes.ViewData.Rows[i].Values[0] := False;
  end;
end;

procedure TfrmRd10PrintBarCode.actSelUnSelExecute(Sender: TObject);
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

procedure TfrmRd10PrintBarCode.qryVouchsAfterScroll(DataSet: TDataSet);
begin
  if dsQRCode.Active then
  begin
    dsQRCode.Close;
    dsQRCode.CommandText := 'select * from SZHL_QRCode_View Where Active=1 and VouchType=:VouchType and VouchsID=:VouchsID';     //-- where VouchType=:VouchType and VouchID=:VouchID
    dsQRCode.Parameters.ParamByName('VouchType').Value := VouchType;
    dsQRCode.Parameters.ParamByName('VouchsID').Value := qryVouchs.FieldByName('VouchsID').AsString;
    dsQRCode.Open;
  end;
end;

procedure TfrmRd10PrintBarCode.cxgrdbtblvwQRCodesCellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
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

procedure TfrmRd10PrintBarCode.frxReport1PrintReport(Sender: TObject);
var
  b: TBookmarkStr;
  intPrintCount: Integer;
begin

//  rpPrinted := True;
  if dsQRCode.RecordCount = 0 then
    exit;
  if cdsQRforPrint.RecordCount = 0 then
    exit;
//  if rpPrinted = true then
//  begin
//
//  end;
  dsQRCode.DisableControls;
  b := dsQRCode.Bookmark;
  intPrintCount := qryVouchs.FieldByName('Define34').AsInteger;
  inc(intPrintCount);
  cdsQRforPrint.First;
  while not cdsQRforPrint.Eof do
  begin
    if dsQRCode.Locate('QRCode', cdsQRforPrint.FieldByName('QRCode').asstring, []) then
    begin
      dsQRCode.Edit;
      dsQRCode.FieldByName('PrintSign').Value := Format('第%d次打印,%s', [intPrintCount, FormatDateTime('YYYY-MM-DD', Now)]);
      dsQRCode.Post;
    end;
    cdsQRforPrint.Next;
  end;
  dsQRCode.Bookmark := b;
  dsQRCode.EnableControls;

  qryVouchs.Edit;
  qryVouchs.FieldByName('Define34').Value := intPrintCount;
  qryVouchs.Post;
end;

procedure TfrmRd10PrintBarCode.btnPrintVouchsClick(Sender: TObject);
var
  intPrintCount, i: Integer;
  b: TBookmarkStr;
begin
//  rpPrinted := false;
  btnPrintClick(Self);

end;

procedure TfrmRd10PrintBarCode.ToolButton1Click(Sender: TObject);
begin
  with cxgrdbtblvwQRCodes.DataController.Filter do
  begin
    ShowMessage(FilterText);
  end;
end;

procedure TfrmRd10PrintBarCode.btnSelect2OkClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to cxgrdbtblvwQRCodes.Controller.SelectedRowCount - 1 do
  begin
    cxgrdbtblvwQRCodes.Controller.SelectedRows[i].Values[0] := True;
  end;
end;

procedure TfrmRd10PrintBarCode.pmQrCodePopup(Sender: TObject);
begin
  CopySelRowsToCds(cxgrdbtblvwQRCodes, cdsQRforPrint);
  if cdsQRforPrint.RecordCount = 0 then  //过滤后有记录数
  begin
    N21.Enabled := False;
    n22.Enabled := False;
  end
  else if cdsQRforPrint.RecordCount = 1 then
  begin
    N21.Enabled := False;
    n22.Enabled := True;
  end
  else if cdsQRforPrint.RecordCount > 1 then  //过滤后有记录数
  begin
    N21.Enabled := True;
    n22.Enabled := False;
  end
end;

procedure TfrmRd10PrintBarCode.N22Click(Sender: TObject);
var
  strMsg: string;
  SavePlace: TBookmark;
begin
  with Tfrm_split.Create(Self) do
  try
    autoid := cdsQRforPrint.FieldByName('autoid').AsInteger;
    totalqty := cdsQRforPrint.FieldByName('iQuantity').AsFloat;

    if ShowModal = mrOk then
    begin
      if ok then
        with TADOStoredProc.Create(self) do
        try
          begin
            Connection := conMain;
            ProcedureName := 'SZHL_SplitQR';
            Parameters.Refresh;
            Parameters.ParamByName('@JSONstring').Value := strjson;
            Parameters.ParamByName('@msg').Value := '';
            ExecProc;
            strMsg := Parameters.ParamByName('@msg').Value;
            if trim(strMsg) = '' then
            begin
              MessageBox(Application.handle, '拆分成功！', '提示', MB_ICONINFORMATION + MB_OK);
              SavePlace := dsQRCode.GetBookmark;
              dsQRCode.DisableControls;
              qryVouchsAfterScroll(qryVouchs);
              dsQRCode.GotoBookmark(SavePlace);
              dsQRCode.FreeBookmark(SavePlace);
              dsQRCode.EnableControls; //先定位再打开控件不会闪烁
            end
            else
              MessageBox(Application.Handle, PChar('拆分失败.'#10#13 + strMsg), '错误', MB_ICONERROR);
          end;
        finally
          Free
        end;
    end;
  finally
    Free
  end;
end;

procedure TfrmRd10PrintBarCode.N1Click(Sender: TObject);
var
  b1:TBookmark;
begin
//  q1.RecordCount
  with TADOQuery.Create(nil) do
    try
      Connection := conMain;
      SQL.Text := Format('select * from  SZHL_QRCodeRecord where vouchtype=''%s'' and  vouchid=%s ',['Rd_10BarCode', qryVouchs.FieldByName('VouchId').AsString]);
      Open;
      if RecordCount>0                   then
       MessageBox(Handle,'条码已经被使用，无法删除','错误',MB_ICONERROR)

       ELSE
       BEGIN
          Close;
          IF  MessageBox(Handle,'确定要删除吗？','提示', MB_YESNOCANCEL+ MB_ICONQUESTION)=IDYES THEN
          BEGIN
                SQL.Text := Format('update SZHL_QRCode set active=0 where vouchtype=''%s'' and  vouchid=%s ',['Rd_10BarCode', qryVouchs.FieldByName('VouchId').AsString]);
               ExecSQL;
               b1:=qryVouchs.GetBookmark;
               qryVouchs.DisableControls;
               qryVouchs.Close;
               qryVouchs.Open;
               qryVouchs.EnableControls;
               qryVouchs.GotoBookmark(b1);
          END;
         END;
    finally
      Free
    end;
end;

end.

