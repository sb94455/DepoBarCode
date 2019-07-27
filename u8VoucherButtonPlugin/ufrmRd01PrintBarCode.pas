unit ufrmRd01PrintBarCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Math, Dialogs, DB, ADODB, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, cxDBData, cxGridLevel, cxClasses, cxControls, MidasLib,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, StdCtrls, ExtCtrls, Buttons, ComCtrls, ToolWin, frxClass, frxPreview,
  frxExportRTF, frxExportXLS, frxExportPDF, frxGradient, frxBarcode, frxOLE,
  frxDesgn, frxDBSet, xmldom, XMLIntf, msxmldom, XMLDoc, cxContainer, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox,
  ActnList, Menus, Grids, DBGrids, cxInplaceContainer, cxVGrid, cxOI,
  frxADOComponents, DBClient;

type
  TfrmRd01PrintBarCode = class(TForm)
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
    btnSelAll1: TToolButton;
    btn3: TToolButton;
    btnSelUnSel1: TToolButton;
    btnSelUnSel2: TToolButton;
    pmQrCode: TPopupMenu;
    N21: TMenuItem;
    N22: TMenuItem;
    dbgrd1: TDBGrid;
    ds33: TDataSource;
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
    procedure pmQrCodePopup(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    strSqlWhere, strCbbItemIndexValue: string;
    rpPrinted: Boolean;
    FVouchType: string;
    procedure SetVouchType(Value: string);
    procedure CopySelRowsToCds(ViewSoure: TcxGridDBTableView; cdsDes: TClientDataSet);
    function GetcxgrdbtblvwActive: TcxGridDBTableView;
    procedure cxcbbReportQuery;
    property cxgrdbtblvwActive: TcxGridDBTableView read GetcxgrdbtblvwActive;
  public
    { Public declarations }
    KeyName: string;
    keyValue: string;
    property VouchType: string read FVouchType write SetVouchType;
  end;

var
  frmRd01PrintBarCode: TfrmRd01PrintBarCode;

implementation

uses
  ufrmReportManage, ufmPub, uCreateQR, uFilter, uRepView, uPublic, uSplitQty;
{$R *.dfm}

procedure TfrmRd01PrintBarCode.SetVouchType(Value: string);
begin
  FVouchType := Value;
  cxcbbReportQuery;
end;

function TfrmRd01PrintBarCode.GetcxgrdbtblvwActive: TcxGridDBTableView;
begin
  if pgc1.ActivePageIndex = 0 then
    Result := cxgrdbtblvwQRCodes
  else
    Result := cxgrdbtblvwInverntory;
end;

procedure TfrmRd01PrintBarCode.frxReport1Preview(Sender: TObject);
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

procedure TfrmRd01PrintBarCode.btnPrintClick(Sender: TObject);
var
  ms: TMemoryStream;
  i: Integer;
begin
  if Trim(cxcbbReport.EditText) = '' then
    Exit;

  try
    CopySelRowsToCds(GetcxgrdbtblvwActive, cdsQRforPrint);
    if cdsQRforPrint.RecordCount <= 0 then
    begin
      MessageBox(Handle, 'δѡ���κμ�¼����ѡ������ ��', '��ʾ', MB_ICONINFORMATION + MB_OK);
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
          FieldByName('cIPAdress').Value := GetHostIP;
          FieldByName('cHostName').Value := GetComputerName;
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

procedure TfrmRd01PrintBarCode.CopySelRowsToCds(ViewSoure: TcxGridDBTableView; cdsDes: TClientDataSet);
var
  i, j: Integer;
  artFlt, flrft: Boolean;
  mStream: TMemoryStream;
begin

  try
    artFlt := True; //���ý�Ҫ�ı���˵ı�־
    mStream := TMemoryStream.Create;
    mStream.Position := 0; //��ָ��ָ��ʼλ
    cdsDes.Close;
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
    ViewSoure.DataController.Filter.Root.Criteria.SaveToStream(mStream); //������״̬������
    flrft := ViewSoure.DataController.Filter.Active; //�������״̬�Ƿ񼤻�
    ViewSoure.DataController.Filter.Root.Clear; //���ԭ�й�������
    ViewSoure.DataController.Filter.Root.AddItem(ViewSoure.Columns[0], foEqual, 'True', '�� '); //��0��Ϊ�����
    ViewSoure.DataController.Filter.Active := True; //�������
    if ViewSoure.DataController.FilteredRecordCount > 0 then  //���˺��м�¼��
    begin
      for j := 0 to ViewSoure.ViewData.RowCount - 1 do//������ѭ��
      begin
        ViewSoure.DataController.DataSet.RecNo := ViewSoure.ViewData.Rows[j].RecordIndex + 1; //��λ���ݼ���¼ָ��
      //����¼׷�ӵ��������ݼ���
        cdsDes.Append;
        for i := 0 to cdsDes.FieldCount - 1 do
          if cdsDes.Fields.Fields[i].CanModify then
            cdsDes.Fields.Fields[i].AsVariant := ViewSoure.DataController.DataSet.Fields.Fields[i].AsVariant;
        cdsDes.Post;
      end;
    end;

  //�ָ��ͻ�����״̬��
    ViewSoure.DataController.Filter.Root.Clear; //���ԭ�й�������
    mStream.Position := 0;
    ViewSoure.DataController.Filter.Root.Criteria.LoadFromStream(mStream);
    ViewSoure.DataController.Filter.Active := flrft;
    artFlt := False;
  finally
    FreeAndNil(mStream);
  end;
end;

function TfrmRd01PrintBarCode.frxDesigner1SaveReport(frxReport1: TfrxReport; SaveAs: Boolean): Boolean;
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
      MessageBox(Handle, '����ģ�屣��ɹ���', '��ʾ', MB_ICONINFORMATION + MB_OK);
    finally
      FreeAndNil(ms);
    end;
  end;
  Result := True;
end;

procedure TfrmRd01PrintBarCode.FormShow(Sender: TObject);
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

  cxcbbReportQuery;

  qryVouchs.Close;
  qryVouchs.Open;

end;

procedure TfrmRd01PrintBarCode.btnExitClick(Sender: TObject);
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

procedure TfrmRd01PrintBarCode.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRd01PrintBarCode.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F12) and (ssCtrl in Shift) then
  begin
    mmo1.Visible := not mmo1.Visible;
  end;
end;

procedure TfrmRd01PrintBarCode.qryReportBeforeOpen(DataSet: TDataSet);
begin
  (DataSet as TADOQuery).SQL.Text := Format('select * from SZHL_Report where VouchType=''%s''', [VouchType]);
end;

procedure TfrmRd01PrintBarCode.qryVouchsBeforeOpen(DataSet: TDataSet);
begin
  (DataSet as TADOQuery).SQL.Text := Format('select * from SZHL_ArrivalVouchView  where %s=%s', ['VouchId', keyValue]);
end;

procedure TfrmRd01PrintBarCode.qryVouchsAfterOpen(DataSet: TDataSet);
begin
  FillGridViewColumns(cxgrdbtblvwVouchRows, 'SZHL_ArrivalVouchView');

  dsQRCode.Close;
  dsQRCode.CommandText := 'select * from SZHL_QRCode  where VouchType=:VouchType and VouchsID=:VouchsID';     //-- where VouchType=:VouchType and VouchID=:VouchID
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

procedure TfrmRd01PrintBarCode.conMainBeforeConnect(Sender: TObject);
begin
  conMain.ConnectionString := strDBConnectString;
end;

procedure TfrmRd01PrintBarCode.btnReportManageClick(Sender: TObject);
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
  cxcbbReportQuery
end;

procedure TfrmRd01PrintBarCode.cxcbbReportQuery;
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

procedure TfrmRd01PrintBarCode.cxcbbReportPropertiesChange(Sender: TObject);
begin
  strCbbItemIndexValue := VarToStr(cxcbbReport.EditValue);
end;

procedure TfrmRd01PrintBarCode.actCreateQRExecute(Sender: TObject);
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
      ProcedureName := 'SZHL_CreateRd01QR';
      Parameters.Clear;
      Parameters.CreateParameter('@ArrivalVouchs_Autoid', ftInteger, pdInput, 100, qryVouchs.FieldByName('VouchsID').AsInteger);
      Parameters.CreateParameter('@msg', ftString, pdOutput, 100, '');
      Prepared;
      ExecProc;
      CreateQR;
      strMsg := strMsg + VarToStr(Parameters.ParamByName('@msg').Value);
      if Length(trim(strMsg)) > 0 then
      begin
        MessageBox(0, PChar(strMsg), '����', MB_ICONWARNING + MB_OK);
      end
      else
      begin
        dsQRCode.Close;
        dsQRCode.Open;
        MessageBox(Handle, '��ǰ����������ɹ���', '��ʾ', MB_ICONINFORMATION + MB_OK);
      end;
    finally
      Free
    end;
  end;
end;

procedure TfrmRd01PrintBarCode.actCreateAllQRExecute(Sender: TObject);
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
      ProcedureName := 'SZHL_CreateRd01QR';
      qryVouchs.First;
      while not qryVouchs.Eof do
      begin
        Parameters.Clear;
        Parameters.CreateParameter('@ArrivalVouchs_Autoid', ftInteger, pdInput, 1, qryVouchs.FieldByName('VouchsID').AsInteger);
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
          strMsgOk := strMsgOk + 'IDΪ' + qryVouchs.FieldByName('VouchsID').AsString + '������������ɹ���' + #10#13;
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
        MessageBox(Handle, PChar('���ɳɹ� ' + #10#13 + strMsgOk), 'ȷ��', MB_ICONINFORMATION + MB_OK);
      end
      else if (Length(trim(strMsgFail)) > 0) and (Length(trim(strMsgOk)) > 0) then
      begin
        MessageBox(Handle, PChar('�������ɳɹ� ' + #10#13 + strMsgOk + strMsgFail), '����', MB_ICONWARNING + MB_OK);
      end
      else if (Length(trim(strMsgFail)) > 0) and (Length(trim(strMsgOk)) <= 0) then
      begin
        MessageBox(Handle, PChar(strMsgFail), '����', MB_ICONWARNING + MB_OK);
      end;
    finally
      Free;
      qryVouchs.Bookmark := bkVouchs;
      qryVouchs.EnableControls;
    end;
  end;
end;

procedure TfrmRd01PrintBarCode.actDelQRExecute(Sender: TObject);
begin
  if dsQRCode.Eof then
    Exit;
end;

procedure TfrmRd01PrintBarCode.actNewMQRExecute(Sender: TObject);
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
      CreateType := '�����ݲ���';
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

procedure TfrmRd01PrintBarCode.actFiltExecute(Sender: TObject);
begin
  with Tfrm_Filter.Create(Self) do
  begin
    try
      strTBName := 'SZHL_QRCode';
      if ShowModal = mrOk then
      begin
        strSqlWhere := 'where CreateType not like ''%����%''  ' + strWhere;
        dsQrCodeByInventory.Close;
        dsQrCodeByInventory.Open;
      end;
    finally
      Free
    end;
  end;
end;

procedure TfrmRd01PrintBarCode.dsQrCodeByInventoryBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet as TADODataSet) do
  begin
    CommandText := 'select * from SZHL_QRCode ' + strSqlWhere;
  end;

end;

procedure TfrmRd01PrintBarCode.dsQrCodeByInventoryAfterOpen(DataSet: TDataSet);
begin
  FillGridSelColumn(cxgrdbtblvwInverntory, 'AutoId');
  FillGridViewColumns(cxgrdbtblvwInverntory, 'SZHL_QRCodeByInventory', False);
end;

procedure TfrmRd01PrintBarCode.actAddByInventoryExecute(Sender: TObject);
begin
  with TfrmCreateQR.Create(Self) do
  try
    VouchType := Self.VouchType;
    CreateType := '�ֶ�����';
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

procedure TfrmRd01PrintBarCode.dsQRCodeAfterOpen(DataSet: TDataSet);
begin
  FillGridSelColumn(cxgrdbtblvwQRCodes, 'autoid');
  FillGridViewColumns(cxgrdbtblvwQRCodes, 'SZHL_QRCode', False);
end;

procedure TfrmRd01PrintBarCode.actSelAllExecute(Sender: TObject);
var
  i: integer;
begin
  GetcxgrdbtblvwActive.DataController.Post;
  for i := 0 to GetcxgrdbtblvwActive.DataController.RowCount - 1 do
  begin
    GetcxgrdbtblvwActive.ViewData.Rows[i].Values[0] := True;
  end;
end;

procedure TfrmRd01PrintBarCode.actUnSelAllExecute(Sender: TObject);
var
  i: integer;
begin

  GetcxgrdbtblvwActive.DataController.Post;
  for i := 0 to GetcxgrdbtblvwActive.DataController.RowCount - 1 do
  begin
    GetcxgrdbtblvwActive.ViewData.Rows[i].Values[0] := False;
  end;
end;

procedure TfrmRd01PrintBarCode.actSelUnSelExecute(Sender: TObject);
var
  i: integer;
  blValue: Boolean;
begin

  GetcxgrdbtblvwActive.DataController.Post;
  for i := 0 to GetcxgrdbtblvwActive.ViewData.RowCount - 1 do
  begin
    if VarIsNull(GetcxgrdbtblvwActive.ViewData.Rows[i].Values[0]) then
      GetcxgrdbtblvwActive.ViewData.Rows[i].Values[0] := False;
    GetcxgrdbtblvwActive.ViewData.Rows[i].Values[0] := not GetcxgrdbtblvwActive.ViewData.Rows[i].Values[0];
  end;
end;

procedure TfrmRd01PrintBarCode.qryVouchsAfterScroll(DataSet: TDataSet);
begin
  if dsQRCode.Active then
  begin
    dsQRCode.Close;
    dsQRCode.CommandText := 'select * from SZHL_QRCode_View  where active=1 and VouchType=:VouchType and VouchsID=:VouchsID';     //-- where VouchType=:VouchType and VouchID=:VouchID
    dsQRCode.Parameters.ParamByName('VouchType').Value := VouchType;
    dsQRCode.Parameters.ParamByName('VouchsID').Value := qryVouchs.FieldByName('VouchsID').AsString;
    dsQRCode.Open;
  end;
  with cxgrdbtblvwQRCodes.DataController.Filter do
  begin
    Root.Clear;
    Root.BoolOperatorKind := fboAnd;
    Root.AddItem(cxgrdbtblvwQRCodes.GetColumnByFieldName('printsign'), foEqual, Null, '��');
//    Root.AddItem(cxgrdbtblvwQRCodes.GetColumnByFieldName('status'), foNotEqual, '����', '����');
    Active := True;
  end;

end;

procedure TfrmRd01PrintBarCode.cxgrdbtblvwQRCodesCellClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
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

procedure TfrmRd01PrintBarCode.frxReport1PrintReport(Sender: TObject);
var
  i, j: Integer;
  artFlt, flrft: Boolean;
  mStream: TMemoryStream;
  ViewSoure: TcxGridDBTableView;
begin
  rpPrinted := True;
  ViewSoure := cxgrdbtblvwQRCodes;
  try
    artFlt := True; //���ý�Ҫ�ı���˵ı�־
    mStream := TMemoryStream.Create;
    mStream.Position := 0; //��ָ��ָ��ʼλ


    ViewSoure.DataController.Filter.Root.Criteria.SaveToStream(mStream); //������״̬������
    flrft := ViewSoure.DataController.Filter.Active; //�������״̬�Ƿ񼤻�
    ViewSoure.DataController.Filter.Root.Clear; //���ԭ�й�������
    ViewSoure.DataController.Filter.Root.AddItem(ViewSoure.Columns[0], foEqual, 'True', '�� '); //��0��Ϊ�����
    ViewSoure.DataController.Filter.Active := True; //�������
    j := qryVouchs.FieldByName('cDefine34').AsInteger;
    if ViewSoure.DataController.FilteredRecordCount > 0 then  //���˺��м�¼��
    begin
      for i := 0 to ViewSoure.ViewData.RowCount - 1 do//������ѭ��
      begin
        ViewSoure.DataController.DataSet.RecNo := ViewSoure.ViewData.Rows[i].RecordIndex + 1; //��λ���ݼ���¼ָ��
        ViewSoure.DataController.DataSet.EDIT;
        ViewSoure.DataController.DataSet.FieldByName('printsign').Value := format('��%d�δ�ӡ', [1 + j]);
        ViewSoure.DataController.DataSet.FieldByName('printtime').Value := Now;
        ViewSoure.DataController.DataSet.POST;
      end;
    end;
    qryVouchs.Edit;
    qryVouchs.FieldByName('cDefine34').Value := 1 + j;
    qryVouchs.Post;

  //�ָ��ͻ�����״̬��
    ViewSoure.DataController.Filter.Root.Clear; //���ԭ�й�������
    mStream.Position := 0;
    ViewSoure.DataController.Filter.Root.Criteria.LoadFromStream(mStream);
    ViewSoure.DataController.Filter.Active := flrft;
    artFlt := False;
  finally
    FreeAndNil(mStream);
  end;
end;

procedure TfrmRd01PrintBarCode.pmQrCodePopup(Sender: TObject);
begin
  CopySelRowsToCds(GetcxgrdbtblvwActive, cdsQRforPrint);
  if cdsQRforPrint.RecordCount = 0 then  //���˺��м�¼��
  begin
    N21.Enabled := False;
    n22.Enabled := False;
  end
  else if cdsQRforPrint.RecordCount = 1 then
  begin
    N21.Enabled := False;
    n22.Enabled := True;
  end
  else if cdsQRforPrint.RecordCount > 1 then  //���˺��м�¼��
  begin
    N21.Enabled := True;
    n22.Enabled := False;
  end
end;

procedure TfrmRd01PrintBarCode.N21Click(Sender: TObject);
var
  i: Integer;
  sum_Qty: Double;
  strFieldsList: string;
  strJasonData: string;
  strMsg: string;
begin

  strJasonData := DataSetToJson(cdsQRforPrint, 'autoid');
//  ShowMessage(strJasonData);
  with TADOStoredProc.Create(self) do
  begin
    try
      Connection := conMain;
      ProcedureName := 'SZHL_MergeQR';
      Parameters.Refresh;
      Parameters.ParamByName('@JSONstring').Value := strJasonData;
      Parameters.ParamByName('@msg').Value := ''; //             parameters.Items[1].Value;
      ExecProc;
      strMsg := Parameters.ParamByName('@msg').Value;
      if trim(strMsg) = '' then
        MessageBox(Application.handle, '�ϲ��ɹ���', '��ʾ', MB_ICONINFORMATION + MB_OK)
      else
        MessageBox(Application.Handle, PChar('�ϲ�ʧ��.'#10#13 + strMsg), '����', MB_ICONERROR);
    finally
      Free
    end;
  end;
end;

procedure TfrmRd01PrintBarCode.N22Click(Sender: TObject);
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
              MessageBox(Application.handle, '��ֳɹ���', '��ʾ', MB_ICONINFORMATION + MB_OK);
              SavePlace := dsQRCode.GetBookmark;
              dsQRCode.DisableControls;
              qryVouchsAfterScroll(qryVouchs);
              dsQRCode.GotoBookmark(SavePlace);
              dsQRCode.FreeBookmark(SavePlace);
              dsQRCode.EnableControls; //�ȶ�λ�ٴ򿪿ؼ�������˸
            end
            else
              MessageBox(Application.Handle, PChar('���ʧ��.'#10#13 + strMsg), '����', MB_ICONERROR);
          end;
        finally
          Free
        end;
    end;
  finally
    Free
  end;
end;

procedure TfrmRd01PrintBarCode.N1Click(Sender: TObject);
var
  b1:TBookmark;
begin
//  q1.RecordCount
  with TADOQuery.Create(nil) do
    try
      Connection := conMain;
      SQL.Text := Format('select * from  SZHL_QRCodeRecord where vouchtype=''%s'' and  vouchid=%s ',['ArrivalVouch', qryVouchs.FieldByName('VouchId').AsString]);
      Open;
      if RecordCount>0                   then
       MessageBox(Handle,'�����Ѿ���ʹ�ã��޷�ɾ��','����',MB_ICONERROR)

       ELSE
       BEGIN
          Close;
          IF  MessageBox(Handle,'ȷ��Ҫɾ����','��ʾ',MB_YESNOCANCEL+ MB_ICONQUESTION)=IDYES THEN
          BEGIN
                SQL.Text := Format('update SZHL_QRCode set active=0 where vouchtype=''%s'' and  vouchid=%s ',['ArrivalVouch', qryVouchs.FieldByName('VouchId').AsString]);
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

