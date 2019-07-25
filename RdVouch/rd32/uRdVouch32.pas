unit uRdVouch32;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Diagnostics, StrUtils, Xml.XMLDoc, Xml.XMLIntf, FMX.Types, FMX.Controls,
  FMX.Forms, FMX.Graphics, FMX.Dialogs, Soap.SOAPHTTPClient, BaseForm, FMX.Layouts,
  FMX.DateTimeCtrls, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani,
  FMX.ListBox, FMX.Edit, FMX.ScrollBox, FMX.Memo, System.Rtti, SaleOutService,
  FMX.Grid.Style, FMX.Grid, UnitLib, WareHouseForm, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, System.Bindings.Outputs, FMX.Bind.Editors, Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Bind.Grid, Data.Bind.Grid, FMX.TabControl;

type
  Tfrm_RdVouch32 = class(TBaseFrm)
    DetailLay: TLayout;
    BillCodeLay: TLayout;
    edt_QRCode: TEdit;
    btn_Save: TButton;
    fdm_Main: TFDMemTable;
    fdm_Sub: TFDMemTable;
    fdm_Detail: TFDMemTable;
    BindSourceDB_Main: TBindSourceDB;
    BindingsList1: TBindingsList;
    lyt_Main: TLayout;
    ClearEditButton1: TClearEditButton;
    BindSourceDB_Detail: TBindSourceDB;
    BindSourceDB_Sub: TBindSourceDB;
    TabControl1: TTabControl;
    Tab_Sub: TTabItem;
    Tab_Detail: TTabItem;
    LinkGridToData_Sub: TLinkGridToDataSource;
    StringGrid_Sub: TStringGrid;
    StringGrid_Detail: TStringGrid;
    LinkGridToData_Detail: TLinkGridToDataSource;
    btn_ClearDetail: TButton;
    lbl_txt_QRCodeLabe: TLabel;
    EllipsesEditButton1: TEllipsesEditButton;
    TabItem1: TTabItem;
    Memo1: TMemo;
    cbRed: TCheckBox;
    fdm_SubDetail: TFDMemTable;
    StringGrid_SubDetail: TStringGrid;
    BindSourceDB_SubDetail: TBindSourceDB;
    LinkGridToData_SubDetail: TLinkGridToDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fdm_MainAfterOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure fdm_SubAfterOpen(DataSet: TDataSet);
    procedure fdm_DetailAfterOpen(DataSet: TDataSet);
    procedure fdm_DetailAfterPost(DataSet: TDataSet);
    procedure fdm_MainAfterInsert(DataSet: TDataSet);
    procedure fdm_MainBeforePost(DataSet: TDataSet);
    procedure fdm_DetailBeforePost(DataSet: TDataSet);
    procedure btn_ClearDetailClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure cbRedClick(Sender: TObject);
    procedure StringGrid_SubCellDblClick(const Column: TColumn; const Row: Integer);
    procedure fdm_SubDetailAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
    dosub: Boolean;
    FVouchObj: TSZHL_Vouch;
    FRdFlag: Boolean;
    FQRCode: string;
    FPosition: string;
    strSQL: string;
//    fdm_append: TFDMemTable;
    SL_QRAutoID: TStringList;
    fdm_Prepare_source: TFDMemTable; // ������մ�����Ϣ��Ϊ��������ܣ����ظ�create
    fdm_Postion: TFDMemTable; // ����ֿ���Ϣ    ��Ϊ��������ܣ����ظ�create
    // FcWhCode: string;
    function GetPostXML(): string;
    procedure DecryptQRCode;
    procedure DecryptQRCode_blue(pQR_Info: TQRCodeInfo);
    procedure DecryptQRCode_AppendDetail(pQR_Info1: TQRCodeInfo; fdmsub{, fdmstock}: TFDMemTable; qty: Double);
    procedure DecryptQRCode_Red(pQR_Info: TQRCodeInfo);
    procedure setDefaulPosition(Value: string);
    function GetcWhCode: string;
    procedure ShowSubDetail;
    procedure setWhCode(const Value: string);
  protected
  public
    procedure InitData; override;
    procedure RefreshData; override;
    property Position: string read FPosition write setDefaulPosition;
    property cWhCode: string read GetcWhCode write setWhCode;
    property QRCode: string read FQRCode write FQRCode;
    property VouObj: TSZHL_Vouch read FVouchObj write FVouchObj;
    property RdFlag: Boolean read FRdFlag write FRdFlag;
  end;

var
  frm_RdVouch32: Tfrm_RdVouch32;

implementation

{$R *.fmx}

uses
  UnitU8DM;

procedure Tfrm_RdVouch32.btn_ClearDetailClick(Sender: TObject);
begin
  if fdm_Main.State in [dsInsert, dsEdit] then
    fdm_Main.Cancel;
  ClearChildCtrl(lyt_Main, true); // ���&��ʾ/����
  fdm_Main.Append;
  fdm_Detail.EmptyDataSet;
  fdm_Sub.EmptyDataSet;
end;

procedure Tfrm_RdVouch32.btn_SaveClick(Sender: TObject);
var
  fdm_SZHL_QRCodeRecord: TFDMemTable;

  procedure HttpPost();
  var
    Service_Data: SaleOutServiceSoap;
    strReturn: string;
    tmpHTTPRIO: THTTPRIO;
  begin
    try
      if Memo1.Text.Trim.IsEmpty then
        Memo1.Text := GetPostXML();
      Service_Data := GetSaleOutServiceSoap(False, PubVar_WebServiceUrl + Const_Url_Def_SaleOut, tmpHTTPRIO);
      strReturn := Service_Data.Insert(Memo1.Text.Trim);

      if not SameText(strReturn, 'OK') then
      begin
        showmessage(format('����%s����ʧ��.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));
      end
      else
        showmessage(format('����%s����ɹ�.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));

    except
      on E: Exception do
      begin
        showmessage(E.Message);
      end;
    end;

  end;

begin
  inherited;
  if fdm_Main.State in [dsEdit, dsInsert] then
    fdm_Main.Post;
  if fdm_Detail.State in [dsEdit, dsInsert] then
    fdm_Detail.Post;
  HttpPost;
  if fdm_Detail.RecordCount > 0 then
  begin
    fdm_Detail.First;
    fdm_SZHL_QRCodeRecord := TFDMemTable.Create(nil);
    try
      DM_Global.ExecSql(fdm_SZHL_QRCodeRecord, 'select * from SZHL_QRCodeRecord where 1=2');
      while not fdm_Detail.Eof do
      begin
        fdm_SZHL_QRCodeRecord.Append;
        fdm_SZHL_QRCodeRecord.FieldByName('SrcId').Value := fdm_Detail.FieldByName('AutoId').AsFloat;
        fdm_SZHL_QRCodeRecord.FieldByName('dAction').Value := 'rd10';
        fdm_SZHL_QRCodeRecord.FieldByName('VouchType').Value := 'Rd_10BarCode';
        fdm_SZHL_QRCodeRecord.FieldByName('dDatetime').Value := Now;
        fdm_SZHL_QRCodeRecord.FieldByName('cUser').Value := PubVar_LoginInfo.UserID;
        fdm_SZHL_QRCodeRecord.FieldByName('Qty').Value := fdm_Detail.FieldByName('iQuantity').AsFloat;
        fdm_SZHL_QRCodeRecord.FieldByName('cIPAdress').Value := ''; //ComputerLocalIP;
        fdm_SZHL_QRCodeRecord.Post;
//        strUpdateSql := Format('update szhl_QrCode set Balance=Balance+%f where autoid=%s', [fdm_Detail.FieldByName('iQuantity').AsFloat, fdm_Detail.FieldByName('Autoid').AsString]);
//        DM_Global.ExecSql0(strUpdateSql);
        fdm_Detail.Next;
      end;
    finally
      FreeAndNil(fdm_SZHL_QRCodeRecord);
    end;
  end;
  SL_QRAutoID.Clear;
end;

procedure Tfrm_RdVouch32.cbRedClick(Sender: TObject);
begin
  if cbRed.IsChecked = false then
    VouObj.VouchArrow := vhRed
  else
    VouObj.VouchArrow := vhBlue;
end;

procedure Tfrm_RdVouch32.DecryptQRCode;
var
  cmd, strWhCode, strPostion: string;
  qrInfo1: TQRCodeInfo;
  ////////////////////////////////
//  strVouchsSql, strDesInvCode, CurrentBatch: string;
//  fdm_Ref, fdm_Detail_Copy: TFDMemTable;
//  QRQty, QRQty_Sub_Detail_Amt, MinQty: double;
//  SubQty, SubQtyRmt, SubQtyAmt, copyQty, AllQty, iQuantity: double;
//  SN, ID, AutoId: Integer;
//label
//  loopstart;
//label
//  loopstart1;
//label
//  loopstart2;

//  function GetSourceVouchKeyValue(): string;
//  begin
//    Result := GetValueByKey(FQRCode, FVouchObj.SrcKeyField);
//  end;

begin
  FQRCode := edt_QRCode.Text;

  cmd := Trim(GetValueByKey(FQRCode, 'c'));
  if SameText(cmd, 'W') = True then
  begin
    fdm_Main.FieldByName('cWhCode').Value := Trim(GetValueByKey(FQRCode, 'cWhCode'));
    edt_QRCode.Text := '';
  end;
  if SameText(cmd, 'P') = True then
  begin

    if CheckPostion(strWhCode, strPostion, fdm_Postion) then
    begin
      cWhCode := strWhCode;
      Position := strPostion;
    end;
  end;
  if SameText(cmd, 'S') = True then // ��Դ����ʱֻ����һ��������Դ���Ҳ����������ظ���
  begin
    StringGrid_Sub.selected := -1;
    if fdm_Sub.RecordCount > 0 then
    begin
      showmessage('�Ѿ�������һ�У�����������Դ��');
      Exit;
    end;
    if fdm_Prepare_source = nil then
      fdm_Prepare_source := TFDMemTable.Create(nil);

    strSQL := format('select *,%s from %s where %s = ''%s''', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, 'DLID', GetValueByKey(FQRCode, 'DLID')]);
    DM_Global.ExecSql(fdm_Prepare_source, strSQL);

     fdm_Sub.AppendData(fdm_Prepare_source);
    if fdm_Sub.RecordCount > 0 then
      if fdm_Main.State in [dsInsert, dsEdit] then // �����ű��룬���������Ÿ�����
      begin
        fdm_Main.FieldByName('cCusCode').Value := fdm_Prepare_source.FieldByName('cCusCode').AsString.Trim;
        fdm_Main.FieldByName('cCode').Value := fdm_Prepare_source.FieldByName('cCode').AsString.Trim;
        fdm_Main.FieldByName('cSTCode').Value := fdm_Prepare_source.FieldByName('cSTCode').AsString.Trim;
        fdm_Main.FieldByName('cDLCode').Value := fdm_Prepare_source.FieldByName('cDLCode').AsString.Trim;
        fdm_Main.FieldByName('cMemo').Value := fdm_Prepare_source.FieldByName('cMemo').AsString.Trim;

      end;
  end;
  if SameText(cmd, 'A') = True then
  begin
    if fdm_Detail.RecordCount = 0 then
      StringGrid_Detail.Selected := -1;
    qrInfo1 := GetQRInfo_ByAutoid(edt_QRCode.Text);
    if fdm_Main.FieldByName('cWhCode').AsString.Trim.IsEmpty then
    begin
      showmessage('��ѡ��ֿ�����ԡ�');
      Abort;
    end;

    if SL_QRAutoID.IndexOf(qrInfo1.AutoId) >= 0 then// fdm_Detail.Locate('cDefine33;cInvCode', VarArrayOf([QrInfo1.AutoId, QrInfo1.cInvCode]), [loPartialKey]) then
    begin
      showmessage('�������ظ�ɨ�롣');
      Abort;
    end;

    if VouObj.VouchArrow = vhRed then // ����
      DecryptQRCode_red(qrInfo1)
    else
      DecryptQRCode_blue(qrInfo1);
    SL_QRAutoID.Add(qrInfo1.AutoId);

  end;
  edt_QRCode.Text := '';
end;

procedure Tfrm_RdVouch32.DecryptQRCode_AppendDetail(pQR_Info1: TQRCodeInfo; fdmsub: TFDMemTable; qty: Double);
begin
  fdm_Detail.Append;
  fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdmsub.FieldByName(VouObj.SrcLinkDesSubField).AsString; // ��Դ�ֶ�
  fdm_Detail.FieldByName('cDefine33').Value := pQR_Info1.AutoId;
  fdm_Detail.FieldByName('iQuantity').Value := qty;
  fdm_Detail.FieldByName('cBatch').Value := pQR_Info1.cBatch;
  fdm_Detail.FieldByName('cPosition').Value := Self.Position.Trim;
  fdm_Detail.FieldByName('cInvCode').Value := pQR_Info1.cInvCode;
  fdm_Detail.FieldByName('cSOCode').Value := fdmsub.FieldByName('cSOCode').AsString;    //ipesodid
  fdm_Detail.FieldByName('cbdlcode').Value := fdmsub.FieldByName('cDLCode').AsString;
//  fdm_Detail.FieldByName('imoseq').Value := fdmsub.FieldByName('SortSeq').Value;
//  fdm_Detail.FieldByName('iUnitCost').Value := 0; // XML����Ϊ��
//  fdm_Detail.FieldByName('iPrice').Value := 0; // XML����Ϊ��
  fdm_Detail.Post;
end;

procedure Tfrm_RdVouch32.DecryptQRCode_blue(pQR_Info: TQRCodeInfo);

  function get_fdm_sub_SumAmt: Double;
  begin
    with fdm_Sub.Aggregates.Add do
    begin
      name := 'sumAmt';
      GroupingLevel := 0;
      IndexName := '';
      Expression := 'sum(' + VouObj.SrcQty_AmtField + ')';
      Active := true;

    end;
    fdm_Sub.AggregatesActive := true;
    if VarIsNull(fdm_Sub.Aggregates[0].Value) then
      Result := 0
    else
      Result := fdm_Sub.Aggregates[0].Value;
    fdm_Sub.Aggregates[0].Free;
  end;

var
  Sum_src_QtyAmt, QR_Rmt_Qty: Double;
  cur_srcLine_QtyAmt{, cur_stockLine_QtyAmt}: Double; // ��ǰ��Դ�У�δ�� ����
  minValue: Double;
  sw1, sw2: TStopwatch;
begin
  try
     {$IFDEF DEBUG}
    sw1 := TStopwatch.StartNew;
      {$ENDIF}
    QR_Rmt_Qty := pQR_Info.Balance; // ȡʵ����� ////////pQR_Info.iQuantity;

    fdm_Sub.First;
    while not fdm_Sub.eof do          // �˳�������1�������ֽ⡢�����ꡣ2.��������������䡣�����������������������Ӽ����һ�С�
    begin
      if SameText(fdm_Sub.FieldByName('cInvCode').AsString, pQR_Info.cInvCode) = False then
      begin
        fdm_Sub.Next;
        Continue;
      end;

      cur_srcLine_QtyAmt := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat;   //δ������
      minValue := GetMin_Number2(QR_Rmt_Qty, cur_srcLine_QtyAmt);                    // ���´������������

      // ���²��ձ�
      fdm_Sub.Edit;
      fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := cur_srcLine_QtyAmt - minValue;
      fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat + minValue;
      fdm_Sub.Post;
      {$IFDEF DEBUG}
      sw2 := TStopwatch.StartNew;
      {$ENDIF}

      DecryptQRCode_AppendDetail(pQR_Info, fdm_Sub, minValue);   // ���Ҽ�¼��û������һ���������¼
      {$IFDEF DEBUG}
      sw2.Stop;
      ShowMessage(Format('DecryptQRCode_AppendDetail(����):%d', [sw2.ElapsedMilliseconds])); //602
      {$ENDIF}
      QR_Rmt_Qty := QR_Rmt_Qty - minValue;
      if QR_Rmt_Qty <= 0 then   //��������������
      begin
        Break;
      end;
      fdm_Sub.Next;

    end;

  finally

  end;
  {$IFDEF DEBUG}
  sw1.Stop;
  ShowMessage(Format('DecryptQRCode_blue(����):%d', [sw1.ElapsedMilliseconds])); //602
  {$ENDIF}
end;

procedure Tfrm_RdVouch32.DecryptQRCode_Red(pQR_Info: TQRCodeInfo);

  function get_fdm_sub_SumAmt: Double;
  begin
    with fdm_Sub.Aggregates.Add do
    begin
      name := 'sumAmt';
      GroupingLevel := 0;
      IndexName := '';
      Expression := 'sum(' + VouObj.SrcQty_AmtField + ')';
      Active := true;

    end;
    fdm_Sub.AggregatesActive := true;
    if VarIsNull(fdm_Sub.Aggregates[0].Value) then
      Result := 0
    else
      Result := fdm_Sub.Aggregates[0].Value;
    fdm_Sub.Aggregates[0].Free;
  end;

var
  Sum_src_QtyAmt, QR_Rmt_Qty: Double;
  cur_srcLine_QtyAmt{, cur_stockLine_QtyAmt}: Double; // ��ǰ��Դ�У�δ�� ����
  minValue: Double;
  sw1, sw2: TStopwatch;
begin
  try
     {$IFDEF DEBUG}
    sw1 := TStopwatch.StartNew;
      {$ENDIF}

    QR_Rmt_Qty := pQR_Info.Balance; // ȡʵ����� ////////pQR_Info.iQuantity;

    fdm_Sub.First;
    while not fdm_Sub.eof do          // �˳�������1�������ֽ⡢�����ꡣ2.��������������䡣�����������������������Ӽ����һ�С�
    begin
      if SameText(fdm_Sub.FieldByName('cInvCode').AsString, pQR_Info.cInvCode) = False then
      begin
        fdm_Sub.Next;
        Continue;
      end;

      cur_srcLine_QtyAmt := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat;   //��de������
      minValue := GetMin_Number2(QR_Rmt_Qty, cur_srcLine_QtyAmt);                    // ���´������������

      // ���²��ձ�
      fdm_Sub.Edit;
      fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := cur_srcLine_QtyAmt - minValue;              //������������
      fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat + minValue;  //δ����������
      fdm_Sub.Post;
      {$IFDEF DEBUG}
      sw2 := TStopwatch.StartNew;
      {$ENDIF}

      DecryptQRCode_AppendDetail(pQR_Info, fdm_Sub, -minValue);   // ���Ҽ�¼��û������һ���������¼
      {$IFDEF DEBUG}
      sw2.Stop;
      ShowMessage(Format('DecryptQRCode_AppendDetail(����):%d', [sw2.ElapsedMilliseconds])); //602
      {$ENDIF}
      QR_Rmt_Qty := QR_Rmt_Qty - minValue;
      if QR_Rmt_Qty <= 0 then   //��������������
      begin
        Break;
      end;
      fdm_Sub.Next;
    end;
  finally
  end;
  {$IFDEF DEBUG}
  sw1.Stop;
  ShowMessage(Format('DecryptQRCode_red):%d', [sw1.ElapsedMilliseconds])); //602
  {$ENDIF}
end;

procedure Tfrm_RdVouch32.edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
  try
    SZHL_ComboBoxSyncToDB(lyt_Main, fdm_Main);
    DecryptQRCode;
    edt_QRCode.SetFocus;
  finally
    DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
  end;
end;

procedure Tfrm_RdVouch32.fdm_DetailAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch32.fdm_DetailAfterPost(DataSet: TDataSet);
begin
  inherited;
  RefreshData;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch32.ShowSubDetail;       //��ʾsubdetail����
var
  strVouchSql, strWhCode, strcInvCode: string;
begin
  strWhCode := fdm_Main.FieldByName('cWhCode').AsString.Trim;
  if strWhCode.IsEmpty = true then
  begin
    exit;
    showmessage('��ѡ��ֿ������');
  end;
  strcInvCode := fdm_Sub.FieldByName('cInvCode').AsString.Trim;
  strVouchSql := Format('select *  from InvPositionSum where 1=1 and cinvcode=''%s'' and cWhCode= ''%s'' order by cBatch ', [strcInvCode, strWhCode]);
  DM_Global.ExecSql(fdm_SubDetail, strVouchSql);
end;

procedure Tfrm_RdVouch32.StringGrid_SubCellDblClick(const Column: TColumn; const Row: Integer);
begin
  inherited;
  ShowSubDetail;
end;

procedure Tfrm_RdVouch32.fdm_DetailBeforePost(DataSet: TDataSet);
var
  strErrMsg: string;
begin
  inherited;
  strErrMsg := DM_Global.CheckAllowEmptys(DataSet, VouObj.DesSubTableDef);
  if strErrMsg <> '' then
  begin
    showmessage(strErrMsg);
    Abort;
  end;
  if cWhCode <> '' then
  begin
    // showmessage('��ѡ��ֿ�');
    if DM_Global.CheckWareHousePos(cWhCode) = True then
    begin
      if DataSet.FieldByName('cposition').AsString = '' then
      begin
        showmessage('��ǰ�ֿ��л�λ������ָ����λ��');
        // exit;
      end;
    end;
  end;
  if DM_Global.CheckInvBatch(DataSet.FieldByName('cInvCode').AsString) = True then
  begin
    if DataSet.FieldByName('cBatch').AsString = '' then
    begin
      showmessage('��ǰ��������ι�����ָ�����Ρ�');
      // exit;
    end;
  end
  else
    DataSet.FieldByName('cBatch').Value := ''; // �����ι���������Ρ�
end;

procedure Tfrm_RdVouch32.fdm_MainAfterInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('dDate').Value := DateToStr(DATE());
  DataSet.FieldByName('cMaker').Value := PubVar_LoginInfo.UserName;
end;

procedure Tfrm_RdVouch32.fdm_MainAfterOpen(DataSet: TDataSet);
var
  strVouchsSql, strVouchsSql_sub: string;
begin
  inherited;

  // �ӱ���Դչ������ ,�������ͷ�򿪣�����������Ѿ��еĵ��ݡ�
  LinkGridToData_Sub.Columns.Clear;
  strVouchsSql_sub := format('select %s from %s where %s =''%s''', [FVouchObj.DesSubLinkSrcFeild, FVouchObj.DesSubTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  strVouchsSql := format('select *,0.00 %s from %s where %s in (%s)', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, FVouchObj.SrcLinkDesSubField, strVouchsSql_sub]);
  DM_Global.ExecSql(fdm_Sub, strVouchsSql);

  // ��ϸ��
  LinkGridToData_Detail.Columns.Clear;
  strVouchsSql := format('select * from %s where %s=''%s''', [FVouchObj.DesSubTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  DM_Global.ExecSql(fdm_Detail, strVouchsSql);

end;

procedure Tfrm_RdVouch32.fdm_MainBeforePost(DataSet: TDataSet); // ����ǰ��������������
var
  strErrMsg: string;
begin
  inherited;
  SZHL_ComboBoxSyncToDB(lyt_Main, fdm_Main);
  strErrMsg := DM_Global.CheckAllowEmptys(DataSet, VouObj.DesMainTableDef);
  if strErrMsg <> '' then
  begin
    showmessage(strErrMsg);
    Abort;
  end;

end;

procedure Tfrm_RdVouch32.fdm_SubAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, True);

end;

procedure Tfrm_RdVouch32.fdm_SubDetailAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD('���ϳ��ⵥ���������������ϱ���ϸ��ͼ', '', fdm_SubDetail, LinkGridToData_SubDetail, true);

end;

procedure Tfrm_RdVouch32.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  frm_RdVouch32 := nil;
end;

procedure Tfrm_RdVouch32.FormCreate(Sender: TObject);
begin
  inherited;

  FRdFlag := True; // Ĭ������(����)����
  ClearChildCtrl(lyt_Main, False); // ����ԭ�ؼ�
  TabControl1.ActiveTab := TabControl1.Tabs[0]; // Ĭ��ҳǩ
  SL_QRAutoID := TStringList.Create;
end;

procedure Tfrm_RdVouch32.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  {$IFDEF DEBUG}
  if Key = vkF11 then
    edt_QRCode.Text := 'C=A;SN=10978;cPOID=0000000001;cCode=PR18020001;cInvCode=01-113-4003LR;Autoid=1000000001;cBatch=batch1;iQty=2';
    {$ENDIF}
end;

procedure Tfrm_RdVouch32.FormShow(Sender: TObject);
begin
  inherited;
  txt_BaseTitle.Text := VouObj.DesMainTableDef;

  TabItem1.Visible := False;
{$IFDEF DEBUG}
  Position := 'F014';
  TabItem1.Visible := True;
{$ENDIF}
  if FVouchObj.DesMainKey.Trim <> '' then
  begin
    btn_Save.Visible := False;
    btn_ClearDetail.Visible := False;
    BillCodeLay.Visible := False;
    // fdm_Main.Append;
    // if fdm_Sub.Active = True then
    // fdm_Sub.EmptyDataSet;
    // fdm_Detail.EmptyDataSet;
  end;
  self.edt_QRCode.SetFocus;
end;

procedure Tfrm_RdVouch32.RefreshData; // ����Detail���ܵ�Sub
var
  strVouchsSql: string;
  bkTmp: TBookmark;
begin
  inherited;
  if fdm_Detail.eof then
    exit;

  // �ӱ���Դչ������ ,�������ͷ�򿪣�����������Ѿ��еĵ��ݡ�
  bkTmp := fdm_Detail.Bookmark;
  fdm_Detail.DisableControls;
  // fdm_Sub.EmptyDataSet;
  fdm_Detail.last;
  //while not fdm_Detail.eof do
 // begin
    // if fdm_Sub.Locate(VouObj.SrcLinkDesSubField, VarArrayOf([Trim(fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString)])) = False then
    // begin
    // try
    // fdm_Sub.AppendData(fdm_sub_append);
    // finally
    // fdm_sub_append.EmptyDataSet;
    // end;
    // end;
//    if fdm_Sub.Locate('cInvCode', VarArrayOf([fdm_Detail.FieldByName('cInvCode').AsString.Trim])) = True then
//    begin
//      fdm_Sub.Edit;
//      fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat + fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
//      fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat - fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
//      fdm_sub.FieldByName('NowQty').Value := fdm_sub.FieldByName('NowQty').Value +  fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
//      fdm_Sub.Post;
//      fdm_append.EmptyDataSet;
//    end;
  //  fdm_Detail.Next;
  //end;
  fdm_Detail.EnableControls;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, True);
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch32.setDefaulPosition(Value: string);
begin
  FPosition := Value;
  txt_BaseTitle.Text := format('%s  P:%s', [VouObj.DesMainTableDef, Value])
end;

procedure Tfrm_RdVouch32.setWhCode(const Value: string);
begin
  fdm_Main.FieldByName('cWhCode').Value := Value;
  FindSZHL(lyt_Main, fdm_Main, 'cWhCode');
end;

function Tfrm_RdVouch32.GetcWhCode: string;
begin
  Result := '';
  if (not fdm_Main.eof) or (fdm_Main.State in [dsEdit, dsInsert]) then
    Result := fdm_Main.FieldByName('cWhCode').AsString.Trim;
end;

function Tfrm_RdVouch32.GetPostXML(): string;
var
  FXmlDoc: TXMLDocument;
  LoopInt, tmpInt: Integer;
  ndVouchHead, tmpListRootNode: IXMLNode;
  ndVouchBody, ndProduct: IXMLNode;
  bkm_Detail: TBookmark;

  procedure WriteChildNodeByDataSet(XMLDoc: TXMLDocument; nsParent: IXMLNode; dstSource: TDataSet; strNodeName, strFieldName: string);
  var                         //д��XML��Ϣ
    ndTmp: IXMLNode;
    fdTmp: TField;
  begin
    strFieldName := Trim(strFieldName);
    fdTmp := dstSource.Fields.FindField(strFieldName);

    if fdTmp = nil then
    begin
      showmessage(format('%s�������ύsoap����Ҫ��XMLʱ����δ�����ֶ�%s', [VouObj.DesMainTable, strFieldName]));
      Abort;
    end;
    // if dstSource.FieldByName(strFieldName).AsString = '' then
    // begin
    // showmessage(format('%s���ύsoap����XMLʱ�����ֶ�%s����Ϊ��', [VouObj.MainTable, strFieldName]));
    // Abort;
    // end;
    ndTmp := XMLDoc.CreateNode(strNodeName);
    nsParent.ChildNodes.Add(ndTmp);
    ndTmp.Text := dstSource.FieldByName(strFieldName).AsString;
  end;

begin
  try

    FXmlDoc := TXMLDocument.Create(self);
    FXmlDoc.Active := True;
    FXmlDoc.Version := '1.0';
    FXmlDoc.Encoding := 'UTF-8';
    // ����汾��Ϣ ��<?xml version="1.0" encoding="GB2312" ?> ��

    // ��ͷ
    ndVouchHead := FXmlDoc.CreateNode('XSaleOutInfo'); // ���������
    FXmlDoc.DocumentElement := ndVouchHead;

    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cCode', 'cCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cSTCode', 'cSTCode');              //��������--1
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cRdCode', 'cRdCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cCusCode', 'cCusCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cBusCode', 'cBusCode');          //�շ�ҵ��� --��������
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'dDate', 'dDate');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cWhCode', 'cWhCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cDepCode', 'cDepCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMemo', 'cMemo');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cDLCode', 'cDLCode');        //������������ʶ  --�������
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMaker', 'cMaker');

    // ����
    ndVouchBody := FXmlDoc.CreateNode('XSaleOutsInfos'); // �ӱ�����
    ndVouchHead.ChildNodes.Add(ndVouchBody);

    bkm_Detail := fdm_Detail.GetBookmark;
    fdm_Detail.DisableControls;
    fdm_Detail.First;
    while not fdm_Detail.eof do
    begin
      // ����
      ndProduct := FXmlDoc.CreateNode('XSaleOutsInfo'); // �ӱ�����
      ndVouchBody.ChildNodes.Add(ndProduct);
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cInvCode', 'cInvCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'iQuantity', 'iQuantity');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cBatch', 'cBatch');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cPosition', 'cPosition');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cbMemo', 'cbMemo');
      //WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'iDLsID', 'iDLsID');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cbdlcode', 'cbdlcode');
      //WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cInvStd', 'cInvStd');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'iordercode', 'cSOCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, VouObj.DesSubLinkSrcFeild, VouObj.DesSubLinkSrcFeild); // iDLsID

      fdm_Detail.Next;
    end;
    fdm_Detail.Bookmark := bkm_Detail;
    fdm_Detail.EnableControls;
    Result := FXmlDoc.Xml.Text;
  finally
    FXmlDoc.Active := False;
    FXmlDoc.Free;
  end;
end;

procedure Tfrm_RdVouch32.InitData;
var
  strVouchSql: string;
begin
  inherited;

  // ������
  strVouchSql := format('select * from %s where %s=''%s''', [FVouchObj.DesMainTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  DM_Global.ExecSql(fdm_Main, strVouchSql);
  if fdm_Main.eof then
    fdm_Main.Append;

  CreateADCtrl(FVouchObj.DesMainTableDef, lyt_Main, fdm_Main, BindSourceDB_Main);
  //SZHL_ComboBoxSyncToControl(lyt_Main, fdm_Main);

end;

end.

