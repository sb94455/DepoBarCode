unit uCreateQR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, ADODB, StdCtrls, ExtCtrls, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, cxNavigator;

type
  TfrmCreateQR = class(TForm)
    cxgrdbtblvwCreateQR: TcxGridDBTableView;
    cxgrdlvlGrid1Level1: TcxGridLevel;
    cxgrdCreateQR: TcxGrid;
    pnlCreateQR: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    ds_QRCode: TDataSource;
    dsQRCode: TADODataSet;
    cxnvgtr1: TcxNavigator;
    procedure dsQRCodeBeforeOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure dsQRCodeAfterOpen(DataSet: TDataSet);
    procedure dsQRCodeAfterInsert(DataSet: TDataSet);
    procedure dsQRCodeBeforePost(DataSet: TDataSet);
    procedure btnOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    VouchID, VouchsID: Integer;
    VouchType, CreateType, cInvCode, cBatch: string;
    Qty: Double;
  end;

var
  frmCreateQR: TfrmCreateQR;

implementation

uses
  ufmPub;
{$R *.dfm}

procedure TfrmCreateQR.dsQRCodeBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet as TADODataSet) do
  begin
    ConnectionString := ufmPub.strDBConnectString;
    CommandType := cmdText;
    CommandText := 'select * from SZHL_QRCode where 1=2';
    LockType := ltBatchOptimistic;
  end;

end;

procedure TfrmCreateQR.FormShow(Sender: TObject);
begin
  FormatDBGridView(cxgrdbtblvwCreateQR, False);
  dsQRCode.Open;
end;

procedure TfrmCreateQR.dsQRCodeAfterOpen(DataSet: TDataSet);
begin
  FillGridViewColumns(cxgrdbtblvwCreateQR, 'CreateQRCode');
end;

procedure TfrmCreateQR.dsQRCodeAfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('cInvCode').Value := cInvCode;
  DataSet.FieldByName('cBatch').Value := cBatch;
  DataSet.FieldByName('VouchsID').Value := VouchsID;
  DataSet.FieldByName('VouchID').Value := VouchID;
  DataSet.FieldByName('Status').Value := 'New';
  DataSet.FieldByName('CreateType').Value := CreateType;
  DataSet.FieldByName('Vouchtype').Value := VouchType;
  DataSet.FieldByName('PrintCount').Value := 0;
  DataSet.FieldByName('Status').Value := 'new';
end;

procedure TfrmCreateQR.dsQRCodeBeforePost(DataSet: TDataSet);
var
  strError: TStringList;
  bInvBatch: Boolean;

  function IsBatchInv(strcInvCode: string): Boolean;
  var
    blReturn: Boolean;
  begin
    blReturn := False;
    with TADOQuery.Create(nil) do
    try
      ConnectionString := strDBConnectString;
      SQL.Text := 'select * from inventory where cInvCode=:cInvCode';
      Parameters.ParamByName('cInvCode').Value := strcInvCode;
      Open;
      if Eof then
        Exit;
      blReturn := FieldByName('bInvBatch').AsBoolean;
    finally
      Free;
    end;
  end;

begin
  DataSet.FieldByName('CreateDateTime').Value := Now;
  try
    strError := TStringList.Create;
    if VarIsNull(DataSet.FieldByName('cInvCode').Value) then
      strError.Add('存货编码不能为空值；')
    else if Trim(DataSet.FieldByName('cInvCode').AsString) = '' then
      strError.Add('存货编码不能为空；')
    else
    begin
      bInvBatch := IsBatchInv(DataSet.FieldByName('cInvCode').AsString);
    end;
    if bInvBatch = True then
    begin
      if VarIsNull(DataSet.FieldByName('cBatch').Value) then
        strError.Add('存货有批次管理，批号不能为空值；')
      else if Trim(DataSet.FieldByName('cBatch').AsString) = '' then
        strError.Add('存货有批次管理，批号不能为空；')
    end;
    if VarIsNull(DataSet.FieldByName('iQuantity').Value) then
      strError.Add('数量不能为空值；');
    if strError.Count > 0 then
    begin
      MessageBox(Application.Handle, PChar(strError.Text), '错误', MB_ICONERROR);
      Abort;
    end;
  finally
    FreeAndNil(strError);
  end;

end;

procedure TfrmCreateQR.btnOkClick(Sender: TObject);
begin
  cxgrdbtblvwCreateQR.DataController.Post;
  dsQRCode.UpdateBatch();
  CreateQR;
end;

procedure TfrmCreateQR.FormClose(Sender: TObject; var Action: TCloseAction);
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
  Action := caFree;
end;

procedure TfrmCreateQR.FormDestroy(Sender: TObject);
begin
  FreeAndNil(frmCreateQR);
end;

end.

