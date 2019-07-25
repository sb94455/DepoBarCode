unit uRdVouch11;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Diagnostics, StrUtils, Xml.XMLDoc, Xml.XMLIntf, FMX.Types, FMX.Controls,
  FMX.Forms, FMX.Graphics, FMX.Dialogs, Soap.SOAPHTTPClient, BaseForm,
  uSZHLFMXEdit, FMX.Layouts, FMX.DateTimeCtrls, FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Ani, FMX.ListBox, FMX.Edit, FMX.ScrollBox, FMX.Memo, System.Rtti,
  MaterialOutService, FMX.Grid.Style, FMX.Grid, UnitLib, WareHouseForm, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Bind.Grid, Data.Bind.Grid,
  FMX.TabControl, Data.Bind.Controls, FMX.Bind.Navigator, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.DApt,
  FireDAC.Phys.SQLiteVDataSet;

type
  Tfrm_RdVouch11 = class(TBaseFrm)
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
    StringGrid_Stock: TStringGrid;
    TabControlDetail: TTabControl;
    TabItemList: TTabItem;
    TabItemCard: TTabItem;
    fdm_CurrentStock: TFDMemTable;
    LayDetailCard: TLayout;
    BindNavigator1: TBindNavigator;
    BindSourceDB_Stock: TBindSourceDB;
    LinkGridToData_CurrentStock: TLinkGridToDataSource;
    cbRed: TCheckBox;
    con1: TFDConnection;
    qry_Detail_group: TFDQuery;
    FDLocalSQL: TFDLocalSQL;
    btn1: TButton;
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
    procedure DecryptQRCode_blue(pQR_Info: TQRCodeInfo);
    procedure DecryptQRCode_AppendDetail(pQR_Info1: TQRCodeInfo; fdmsub{, fdmstock}: TFDMemTable; qty: Double);
    procedure DecryptQRCode_Red(pQR_Info: TQRCodeInfo);
    procedure fdm_CurrentStockAfterOpen(DataSet: TDataSet);
    procedure cbRedClick(Sender: TObject);
    procedure BindSourceDB_MainSubDataSourceDataChange(Sender: TObject; Field: TField);
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid_DetailSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
    procedure btn1Click(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
  private
    { Private declarations }
    FVouchObj: TSZHL_Vouch;
    FRdFlag: Boolean;
    // FQRCode: string;
    FPosition: string;
    FbWhPos: Boolean;
    //
    SL_QRAutoID: TStringList;
    strSQL: string;
    fdm_Prepare_source: TFDMemTable; // 储存参照窗口信息，为了提高性能，不重复create
//    fdm_stock: TFDMemTable; // 储存结存信息，为了提高性能，不重复create
    fdm_WareHouse: TFDMemTable; // 储存仓库信息    ，为了提高性能，不重复create
    fdm_Postion: TFDMemTable; // 储存仓库信息    ，为了提高性能，不重复create
    // fdm_beyond: TFDMemTable;
    function GetPostXML(): string;
    procedure DecryptQRCode;
    procedure setDefaulPosition(Value: string);
    function GetcWhCode: string;
    procedure GetInvStock(pWhCode: string; pFbWhPos: Boolean; pBatch, pInvCode, pPostion: string);
    procedure setWhCode(const Value: string);
  protected
  public
    procedure InitData; override;
    procedure RefreshData; override;
    property Position: string read FPosition write setDefaulPosition;
    property cWhCode: string read GetcWhCode write setWhCode;
    // property QRCode: string read FQRCode write FQRCode;
    property VouObj: TSZHL_Vouch read FVouchObj write FVouchObj;
    property RdFlag: Boolean read FRdFlag write FRdFlag;
  end;

var
  frm_RdVouch11: Tfrm_RdVouch11;

implementation

{$R *.fmx}

uses
  UnitU8DM;

procedure Tfrm_RdVouch11.BindSourceDB_MainSubDataSourceDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  if Field <> nil then
    if SameText(Field.FieldName, 'cWhCode') then
      if fdm_Main.FieldByName('cWhCode').AsString.Trim.IsEmpty = False then
        CheckWarehouse(fdm_Main.FieldByName('cWhCode').AsString.Trim, fdm_WareHouse, FbWhPos);
end;

procedure Tfrm_RdVouch11.btn1Click(Sender: TObject);
begin
  inherited;
  if fdm_Detail.RecordCount > 0 then
    if not (fdm_Detail.State in [dsInsert, dsEdit]) then
    begin
      fdm_Detail.Edit;
      fdm_Detail.FieldByName('cbatch').Value := 'test';
      fdm_Detail.Post;

    end;

end;

procedure Tfrm_RdVouch11.btn_ClearDetailClick(Sender: TObject);
begin
  if fdm_Main.State in [dsInsert, dsEdit] then
    fdm_Main.Cancel;
  ClearChildCtrl(lyt_Main, true); // 清空&显示/隐藏
  fdm_Main.Append;
  fdm_Detail.EmptyDataSet;
  fdm_Sub.EmptyDataSet;
end;

procedure Tfrm_RdVouch11.btn_SaveClick(Sender: TObject);
var
  fdm_SZHL_QRCodeRecord, fdm_SZHL_QRCode: TFDMemTable;
  strUpdateSql: string;

  procedure HttpPost();
  var
    Service_Data: MaterialOutServiceSoap;
    strReturn: string;
    tmpHTTPRIO: THTTPRIO;
    sw1: TStopwatch;
  begin
    try
      {$IFDEF DEBUG}
      sw1 := TStopwatch.StartNew;
      {$ENDIF}
      if Memo1.Text.Trim.IsEmpty then
        Memo1.Text := GetPostXML();
      {$IFDEF DEBUG}
      sw1.Stop;
      ShowMessage(Format('GetPostXML(毫秒):%d', [sw1.ElapsedMilliseconds])); //602
      {$ENDIF}

      {$IFDEF DEBUG}
      sw1 := TStopwatch.StartNew;
      {$ENDIF}
      tmpHTTPRIO := THTTPRIO.Create(self);
      Service_Data := GetMaterialOutServiceSoap(False, PubVar_WebServiceUrl + Const_Url_Def_MaterialOut, tmpHTTPRIO);
      {$IFDEF DEBUG}
      sw1.Stop;
      ShowMessage(Format('GetMaterialOutServiceSoap(毫秒):%d', [sw1.ElapsedMilliseconds])); //602
      {$ENDIF}

      {$IFDEF DEBUG}
      sw1 := TStopwatch.StartNew;
      {$ENDIF}
      strReturn := Service_Data.Insert(Memo1.Text.Trim);
      {$IFDEF DEBUG}
      sw1.Stop;
      ShowMessage(Format('Service_Data.Insert(毫秒):%d', [sw1.ElapsedMilliseconds])); //602
      {$ENDIF}

      if not SameText(strReturn, 'OK') then
      begin
        ShowMessage(format('单据%s保存失败.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));
      end
      else
        ShowMessage(format('单据%s保存成功.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));
    except
      on E: Exception do
      begin
        ShowMessage(E.Message);
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
    fdm_SZHL_QRCodeRecord.CachedUpdates := True;

    try
      DM_Global.ExecSql(fdm_SZHL_QRCodeRecord, 'select * from SZHL_QRCodeRecord where 1=2');
      while not fdm_Detail.Eof do
      begin
        fdm_SZHL_QRCodeRecord.Append;
        fdm_SZHL_QRCodeRecord.FieldByName('SrcId').Value := fdm_Detail.FieldByName('AutoId').AsFloat;
        fdm_SZHL_QRCodeRecord.FieldByName('dAction').Value := 'rd11';
        fdm_SZHL_QRCodeRecord.FieldByName('QRAutoid').Value := fdm_Detail.FieldByName('cDefine33').AsInteger;
        fdm_SZHL_QRCodeRecord.FieldByName('cInvCode').Value := fdm_Detail.FieldByName('cInvCode').AsString;
        fdm_SZHL_QRCodeRecord.FieldByName('dDatetime').Value := Now;
        fdm_SZHL_QRCodeRecord.FieldByName('cUser').Value := PubVar_LoginInfo.UserID;
        fdm_SZHL_QRCodeRecord.FieldByName('Qty').Value := fdm_Detail.FieldByName('iQuantity').AsFloat;
        fdm_SZHL_QRCodeRecord.FieldByName('cIPAdress').Value := ''; //ComputerLocalIP;
        fdm_SZHL_QRCodeRecord.Post;
//        strUpdateSql := Format('update szhl_QrCode set Balance=Balance-%f where autoid=%s', [fdm_Detail.FieldByName('iQuantity').AsFloat, fdm_Detail.FieldByName('Autoid').AsString]);
//        DM_Global.ExecSql0(strUpdateSql);
        fdm_Detail.Next;
      end;
      fdm_SZHL_QRCodeRecord.ApplyUpdates();
      if U8DM.Save2(fdm_SZHL_QRCodeRecord, 'SZHL_QRCodeRecord') then
      {$IFDEF DEBUG}
        ShowMessage('写入表SZHL_QRCodeRecord记录ok')
      {$ENDIF}
      else
        ShowMessage('写入表SZHL_QRCodeRecord记录出错');
      btn_ClearDetailClick(Self);
    finally
      FreeAndNil(fdm_SZHL_QRCodeRecord);
    end;
  end;
end;

procedure Tfrm_RdVouch11.cbRedClick(Sender: TObject);
begin
  if cbRed.IsChecked = False then
    VouObj.VouchArrow := vhRed
  else
    VouObj.VouchArrow := vhBlue;
end;

procedure Tfrm_RdVouch11.DecryptQRCode; // 录入二维码检查
var
  CurrentBatch: string;
  fdm_Ref, fdm_Detail_Copy: TFDMemTable;
  QRQty_Sub_Detail_Amt, MinQty: Double;
  SubQty, SubQtyRmt, SubQtyAmt, copyQty, AllQty: Double;
  ID, AutoId: Integer;
  //
  qrInfo1: TQRCodeInfo;
  cmd, strWhCode, strPostion: string;
  FQRCode: string;
begin
  if (fdm_Detail.State in [dsEdit, dsInsert]) then // 如果明细没提交先提交
  begin
    fdm_Detail.Post;
  end;
  FQRCode := edt_QRCode.Text.Trim;
  cmd := GetValueByKey(FQRCode, 'c');
  if SameText(cmd, '') = true then
  begin
    Exit;
  end;
  if SameText(cmd, 'W') = true then
  begin
    strWhCode := Trim(GetValueByKey(FQRCode, 'cWhCode'));
    if CheckWarehouse(strWhCode, fdm_WareHouse, FbWhPos) then
      fdm_Main.FieldByName('cWhCode').Value := strWhCode;
  end;
  if SameText(cmd, 'P') = true then
  begin
    strPostion := Trim(GetValueByKey(FQRCode, 'cPosition'));
    if CheckPostion(strWhCode, strPostion, fdm_Postion) then
    begin
      cWhCode := strWhCode;
      Position := strPostion;
    end;

  end;
  if SameText(cmd, 'S') = true then // 来源，暂时只允许一个单据来源，且不允许物料重复。
  begin
    StringGrid_Sub.selected := -1;
    if fdm_Sub.RecordCount > 0 then
    begin
      showmessage('已经参照了生产订单一行，不允许多个来源。');
      Exit;
    end;
    if fdm_Prepare_source = nil then
      fdm_Prepare_source := TFDMemTable.Create(nil);

    strSQL := format('select *,%s from %s where %s = ''%s''', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, 'MoCode', GetValueByKey(FQRCode, 'MoCode')]);
    DM_Global.ExecSql(fdm_Prepare_source, strSQL);

    fdm_Sub.AppendData(fdm_Prepare_source);
    if fdm_Sub.RecordCount > 0 then
      if fdm_Main.State in [dsInsert, dsEdit] then // 传部门编码，生产订单号给主表
      begin
        fdm_Main.FieldByName('cDepCode').Value := fdm_Prepare_source.FieldByName('MDeptCode').AsString.Trim;
        fdm_Main.FieldByName('cMPoCode').Value := fdm_Prepare_source.FieldByName('MoCode').AsString.Trim;
      end;
  end;
  if SameText(cmd, 'A') = true then
  begin
    if fdm_Detail.RecordCount = 0 then
      StringGrid_Detail.Selected := -1;
    qrInfo1 := GetQRInfo_ByAutoid(edt_QRCode.Text);
    if fdm_Main.FieldByName('cWhCode').AsString.Trim.IsEmpty then
    begin
      showmessage('请选择仓库后再试。');
      Abort;
    end;

    if SL_QRAutoID.IndexOf(qrInfo1.AutoId) >= 0 then// fdm_Detail.Locate('cDefine33;cInvCode', VarArrayOf([QrInfo1.AutoId, QrInfo1.cInvCode]), [loPartialKey]) then
    begin
      showmessage('不允许重复扫码。');
      Abort;
    end;

    if VouObj.VouchArrow = vhRed then // 领料
      DecryptQRCode_red(qrInfo1)
    else
      DecryptQRCode_blue(qrInfo1);
    SL_QRAutoID.Add(qrInfo1.AutoId);

  end;
  edt_QRCode.Text := '';
end;

procedure Tfrm_RdVouch11.edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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

procedure Tfrm_RdVouch11.DecryptQRCode_AppendDetail(pQR_Info1: TQRCodeInfo; fdmsub{, fdmstock}: TFDMemTable; qty: Double);
begin
//  fdm_Detail.Filtered := False;
//  fdm_Detail.Filter := VouObj.DesSubLinkSrcFeild + '=' + fdmsub.FieldByName(VouObj.SrcLinkDesSubField).AsString;
//  fdm_Detail.Filter := fdm_Detail.Filter + ' and cDefine33=''' + pQR_Info1.AutoId.Trim + ''''; //qrauto
//  fdm_Detail.Filter := fdm_Detail.Filter + ' and cBatch=''' + pQR_Info1.cBatch.Trim + '''';
//  fdm_Detail.Filter := fdm_Detail.Filter + ' and cInvCode=''' + pQR_Info1.cInvCode + '''';
//  fdm_Detail.Filter := fdm_Detail.Filter + ' and cMoLotCode=''' + fdmsub.FieldByName('cMoLotCode').AsString.Trim + '''';
//  fdm_Detail.Filter := fdm_Detail.Filter + ' and cmocode=''' + fdmsub.FieldByName('cmocode').AsString.Trim + '''';
//  fdm_Detail.Filter := fdm_Detail.Filter + ' and imoseq=''' + fdmsub.FieldByName('imoseq').AsString.Trim + '''';
//  fdm_Detail.Filter := fdm_Detail.Filter + ' and cPosition=''' + Self.Position.Trim + '''';
//  fdm_Detail.Filtered := True;
//  try
//    if fdm_Detail.FindFirst then
//    begin
  fdm_Detail.Append;
  fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdmsub.FieldByName(VouObj.SrcLinkDesSubField).AsString; // 来源字段
  fdm_Detail.FieldByName('cDefine33').Value := pQR_Info1.AutoId;
  fdm_Detail.FieldByName('iQuantity').Value := qty;
  fdm_Detail.FieldByName('cBatch').Value := pQR_Info1.cBatch;
  fdm_Detail.FieldByName('cPosition').Value := Self.Position.Trim;
  fdm_Detail.FieldByName('cInvCode').Value := pQR_Info1.cInvCode;
  fdm_Detail.FieldByName('cmocode').Value := fdmsub.FieldByName('MoCode').AsString;    //ipesodid
//  cpesocode              fdm_Detail.FieldByName('cmocode').Value := fdmsub.FieldByName('MoCode').AsString;
  fdm_Detail.FieldByName('cMoLotCode').Value := fdmsub.FieldByName('MoLotCode').AsString;
  fdm_Detail.FieldByName('imoseq').Value := fdmsub.FieldByName('SortSeq').Value;
  fdm_Detail.FieldByName('iUnitCost').Value := 0; // XML不能为空
  fdm_Detail.FieldByName('iPrice').Value := 0; // XML不能为空
  fdm_Detail.Post;
//    end
//    else
//    begin
//      fdm_Detail.Edit;
//      fdm_Detail.FieldByName('iQuantity').Value := qty + fdm_Detail.FieldByName('iQuantity').AsFloat;
//      fdm_Detail.Post;
//    end;
//  finally
//    fdm_Detail.Filtered := False;
//    fdm_Detail.Filter := '';
//  end;
end;

procedure Tfrm_RdVouch11.DecryptQRCode_blue(pQR_Info: TQRCodeInfo);

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
  cur_srcLine_QtyAmt{, cur_stockLine_QtyAmt}: Double; // 当前来源行，未领 数量
  minValue: Double;
  sw1, sw2: TStopwatch;
begin

  try

     {$IFDEF DEBUG}
    sw1 := TStopwatch.StartNew;
      {$ENDIF}
    QR_Rmt_Qty := pQR_Info.Balance; // 取实际余额 ////////pQR_Info.iQuantity;

//    fdm_Sub.CachedUpdates := true;
//    fdm_Detail.CachedUpdates := true;

    fdm_Sub.First;
    while not fdm_Sub.eof do          // 退出条件，1：数量分解、分配完。2.结存数量不够分配。如果数量超额，超在生产订单子件最后一行。
    begin
      if SameText(fdm_Sub.FieldByName('cInvCode').AsString, pQR_Info.cInvCode) = False then
      begin
        fdm_Sub.Next;
        Continue;
      end;

      cur_srcLine_QtyAmt := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat;   //未领数量
      minValue := GetMin_Number2(QR_Rmt_Qty, cur_srcLine_QtyAmt);                    // 更新待领出条码数量

      // 更新参照表
      fdm_Sub.Edit;
      fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := cur_srcLine_QtyAmt - minValue;
      fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat + minValue;
      fdm_Sub.Post;
      {$IFDEF DEBUG}
      sw2 := TStopwatch.StartNew;
      {$ENDIF}

      DecryptQRCode_AppendDetail(pQR_Info, fdm_Sub, minValue);   // 查找记录，没有新增一条，保存记录
      {$IFDEF DEBUG}
      sw2.Stop;
      ShowMessage(Format('DecryptQRCode_AppendDetail(毫秒):%d', [sw2.ElapsedMilliseconds])); //602
      {$ENDIF}
      QR_Rmt_Qty := QR_Rmt_Qty - minValue;
      if QR_Rmt_Qty <= 0 then   //条码数量分配完
      begin
        Break;
      end;
      fdm_Sub.Next;
      {if ((fdm_Sub.eof = true) and (QR_Rmt_Qty <> 0)) then
      // 未分配完，又允许 再分配（未超额，有库存），分配在最后一行。
      begin
        fdm_Sub.RecNo := fdm_Sub.RecordCount - 1;
      end;  }
    end;
//    if QR_Rmt_Qty = 0 then //
//    begin
//
//      fdm_Sub.CancelUpdates;
//      fdm_Detail.CancelUpdates;
//    end;
  finally
//    fdm_Sub.CachedUpdates := False;
//    fdm_Sub.Filtered := False;
//    fdm_Detail.CachedUpdates := False;
//    fdm_Detail.Filtered := False;

  end;
  {$IFDEF DEBUG}
  sw1.Stop;
  ShowMessage(Format('DecryptQRCode_blue(毫秒):%d', [sw1.ElapsedMilliseconds])); //602
  {$ENDIF}
end;

procedure Tfrm_RdVouch11.DecryptQRCode_Red(pQR_Info: TQRCodeInfo);

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
  cur_srcLine_QtyAmt{, cur_stockLine_QtyAmt}: Double; // 当前来源行，未领 数量
  minValue: Double;
  sw1, sw2: TStopwatch;
begin
  try
     {$IFDEF DEBUG}
    sw1 := TStopwatch.StartNew;
      {$ENDIF}
//    pQR_Info.iQuantity := pQR_Info.iQuantity *  - 1;
    QR_Rmt_Qty := pQR_Info.Balance; // 取实际余额 ////////pQR_Info.iQuantity;

    fdm_Sub.First;
    while not fdm_Sub.eof do          // 退出条件，1：数量分解、分配完。2.结存数量不够分配。如果数量超额，超在生产订单子件最后一行。
    begin
      if SameText(fdm_Sub.FieldByName('cInvCode').AsString, pQR_Info.cInvCode) = False then
      begin
        fdm_Sub.Next;
        Continue;
      end;

      cur_srcLine_QtyAmt := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat;   //已领数量
      minValue := GetMin_Number2(QR_Rmt_Qty, cur_srcLine_QtyAmt);                    // 更新待领出条码数量

      // 更新参照表
      fdm_Sub.Edit;
      fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := cur_srcLine_QtyAmt - minValue;              //已领数量减少
      fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat + minValue;  //未领数量增加
      fdm_Sub.Post;
      {$IFDEF DEBUG}
      sw2 := TStopwatch.StartNew;
      {$ENDIF}
//                               pQR_Info.iQuantity := pQR_Info.iQuantity *  - 1;
      DecryptQRCode_AppendDetail(pQR_Info, fdm_Sub, -minValue);   // 查找记录，没有新增一条，保存记录
      {$IFDEF DEBUG}
      sw2.Stop;
      ShowMessage(Format('DecryptQRCode_AppendDetail(毫秒):%d', [sw2.ElapsedMilliseconds])); //602
      {$ENDIF}
      QR_Rmt_Qty := QR_Rmt_Qty - minValue;
      if QR_Rmt_Qty <= 0 then   //条码数量分配完
      begin
        Break;
      end;
      fdm_Sub.Next;
      {if ((fdm_Sub.eof = true) and (QR_Rmt_Qty <> 0)) then
      // 未分配完，又允许 再分配（未超额，有库存），分配在最后一行。
      begin
        fdm_Sub.RecNo := fdm_Sub.RecordCount - 1;
      end;  }
    end;
//    if QR_Rmt_Qty = 0 then //
//    begin
//
//      fdm_Sub.CancelUpdates;
//      fdm_Detail.CancelUpdates;
//    end;
  finally
//    fdm_Sub.CachedUpdates := False;
//    fdm_Sub.Filtered := False;
//    fdm_Detail.CachedUpdates := False;
//    fdm_Detail.Filtered := False;
  end;
  {$IFDEF DEBUG}
  sw1.Stop;
  ShowMessage(Format('DecryptQRCode_red):%d', [sw1.ElapsedMilliseconds])); //602
  {$ENDIF}
end;

procedure Tfrm_RdVouch11.fdm_DetailAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch11.fdm_DetailAfterPost(DataSet: TDataSet);
begin
  inherited;
//  RefreshData;
//  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch11.fdm_DetailBeforePost(DataSet: TDataSet);
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
//  if cWhCode <> '' then                      //改在表头验证
//  begin
//    // showmessage('请选择仓库');
//    if DM_Global.CheckWareHousePos(cWhCode) = true then
//    begin
//      if DataSet.FieldByName('cposition').AsString = '' then
//      begin
//        showmessage('当前仓库有货位管理，请指定货位。');
//        // exit;
//      end;
//    end;
//  end;
//  if DM_Global.CheckInvBatch(DataSet.FieldByName('cInvCode').AsString) = true then       //改在来源字段关联查询验证
//  begin
  if fdm_Sub.FieldByName('bInvBatch').AsBoolean = False then
    DataSet.FieldByName('cBatch').Value := ''
  else if DataSet.FieldByName('cBatch').AsString = '' then
  begin
    showmessage('当前存货有批次管理，请指定批次。');
  end;
//  end
//  else
//    DataSet.FieldByName('cBatch').Value := ''; // 无批次管理清除批次。
end;

procedure Tfrm_RdVouch11.fdm_MainAfterInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('dDate').Value := DateToStr(DATE());
  DataSet.FieldByName('cMaker').Value := PubVar_LoginInfo.UserName;
end;

procedure Tfrm_RdVouch11.fdm_MainAfterOpen(DataSet: TDataSet);
var
  strVouchsSql, strVouchsSql_sub: string;
  i: Integer;
begin
  inherited;

  // 子表（来源展开）表 ,初次随表头打开，用来处理打开已经有的单据。
  LinkGridToData_Sub.Columns.Clear;
  strVouchsSql_sub := format('select %s from %s where %s =''%s''', [FVouchObj.DesSubLinkSrcFeild, FVouchObj.DesSubTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  // strVouchsSql := 'select db_name()'; // *,0.00 %s from %s where %s in (%s)', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, FVouchObj.SrcLinkDesSubField, strVouchsSql_sub]);
  // DM_Global.ExecSql(fdm_Sub, strVouchsSql);

  strVouchsSql := format('select db_name() dbname, *,0.00 %s from %s where %s in (%s)', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, FVouchObj.SrcLinkDesSubField, strVouchsSql_sub]);
  DM_Global.ExecSql(fdm_Sub, strVouchsSql);

  // 明细表
  LinkGridToData_Detail.Columns.Clear;
  strVouchsSql := format('select * from %s where %s=''%s''', [FVouchObj.DesSubTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);

  fdm_Detail.FieldDefs.Clear;
  fdm_Detail.FieldDefs.Add('autoid', ftInteger, 0, true);
  fdm_Detail.FieldDefs.Add('id', ftInteger, 0, true);
  fdm_Detail.FieldDefs.Add('iquantity', ftFloat, 0, False);
  fdm_Detail.FieldDefs.Add('cbatch', ftString, 20, False);
  fdm_Detail.FieldDefs.Add('cposition', ftString, 50, False);
  fdm_Detail.FieldDefs.Add('iarrsid', ftInteger, 0, False);
  fdm_Detail.FieldDefs.Add('cDefine33', ftString, 50, False);
//                              fdm_Detail.FieldDefs.Add('iarrsid',ftInteger,0,true);
  fdm_Detail.CreateDataSet;
  DM_Global.ExecSql(fdm_Detail, strVouchsSql);

end;

procedure Tfrm_RdVouch11.fdm_MainBeforePost(DataSet: TDataSet); // 保存前检查主表必输入项
var
  strErrMsg: string;
begin
  inherited;

  SZHL_ComboBoxSyncToDB(lyt_Main, fdm_Main); // 同步combobox类型的控件内容至数据库
  strErrMsg := DM_Global.CheckAllowEmptys(DataSet, VouObj.DesMainTableDef);
  if strErrMsg <> '' then
  begin
    showmessage(strErrMsg);
    Abort;
  end;
end;

procedure Tfrm_RdVouch11.fdm_SubAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, true);
end;

procedure Tfrm_RdVouch11.fdm_CurrentStockAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD('材料出库单参照生产订单用料表明细视图', '', fdm_CurrentStock, LinkGridToData_CurrentStock, true);
end;

procedure Tfrm_RdVouch11.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frm_RdVouch11 := nil;
end;

procedure Tfrm_RdVouch11.FormCreate(Sender: TObject);
begin
  inherited;
  FRdFlag := true; // 默认正数(兰字)单据       //蓝字判断  咱不修改
  ClearChildCtrl(lyt_Main, False); // 隐藏原控件
  TabControl1.ActiveTab := TabControl1.Tabs[0]; // 默认页签
  SL_QRAutoID := TStringList.Create;
end;

procedure Tfrm_RdVouch11.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(SL_QRAutoID);
end;

procedure Tfrm_RdVouch11.FormFocusChanged(Sender: TObject);
var
  t1: TSZHL_NumberBox;
//  b: TTabItem;
begin

  inherited;
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
//  FService_kb.HideVirtualKeyboard;
  {$ENDIF}
  if Assigned(Focused) then
  begin
//    if Focused is TTabItem then
//    begin
//      b := (Focused as TTabItem);
//      if SameText(b.Name, 'Tab_Detail') then
//        lyt_Main.Visible := False
//      else
//        lyt_Main.Visible := True;
//    end;
    if Focused is TSZHL_NumberBox then
    begin
      fdm_Detail.FieldByName('iquantity').AsString;
      t1 := Focused as TSZHL_NumberBox;
      {$IFDEF DEBUG}
      ShowMessage('t1.Text:' + t1.Text);

      ShowMessage('fdm_Detail.FieldByName(iquantity).AsString;:' + fdm_Detail.FieldByName('iquantity').AsString);
  {$ENDIF}

      if t1.FieldDict.Editing = True then
      begin
        lyt_Main.Visible := False;
          {$IF DEFINED(IOS) or DEFINED(ANDROID)}
//        FService_kb.ShowVirtualKeyboard(t1);
          {$ENDIF}
        Exit;
      end
//      else
//      begin
//        lyt_Main.Visible := True;
//              {$IF DEFINED(IOS) or DEFINED(ANDROID)}
//        FService_kb.HideVirtualKeyboard;
//          {$ENDIF}
//      end;


    end;

    begin
      lyt_Main.Visible := True;
      {$IF DEFINED(IOS) or DEFINED(ANDROID)}
//      FService_kb.HideVirtualKeyboard;
      {$ENDIF}
    end;

//  VKAutoShowMode := TVKAutoShowMode.Never;
  end;
end;

procedure Tfrm_RdVouch11.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = vkF11 then
    edt_QRCode.Text := 'C=A;SN=10978;cPOID=0000000001;cCode=PR18020001;cInvCode=01-113-4003LR;Autoid=1000000001;cBatch=batch1;iQty=2';
end;

procedure Tfrm_RdVouch11.FormShow(Sender: TObject);
begin
  inherited;
  btn1.Visible := False;
  txt_BaseTitle.Text := VouObj.DesMainTableDef;

  TabItem1.Visible := False;

  if FVouchObj.DesMainKey.Trim <> '' then
  begin
    btn_Save.Visible := False;
    btn_ClearDetail.Visible := False;
    BillCodeLay.Visible := False;

  end;
  self.edt_QRCode.SetFocus;
end;

procedure Tfrm_RdVouch11.RefreshData; // 根据Detail汇总到Sub
var
  strVouchsSql: string;
  bkTmp: TBookmark;
begin
  inherited;

  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, true);
//  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch11.setDefaulPosition(Value: string);
begin
  FPosition := Value;
  txt_BaseTitle.Text := format('%s  P:%s', [VouObj.DesMainTableDef, Value])
end;

procedure Tfrm_RdVouch11.GetInvStock(pWhCode: string; pFbWhPos: Boolean; pBatch, pInvCode, pPostion: string); // 显示存货结存数据
var
  strSQL, strWhCode, strInvCode: string;
begin
//  if fdm_Main.FieldByName('cWhCode').AsString.Trim.IsEmpty then
//  begin
//    showmessage('请选择仓库后重试');
//    Exit;
//  end
//  else
//  begin
//    if ((pFbWhPos = true) and (Position.IsEmpty = true)) then
//    begin
//      showmessage(format('仓库%s有货位管理，请先指定默认货位.', [pWhCode]));
//      Exit;
//    end;
//  end;
//  if fdm_stock = nil then
//    fdm_stock := TFDMemTable.Create(self);
//  if pFbWhPos = False then
//    strSQL := format('select * from CurrentStock where iQuantity>0 and  cinvcode=''%s'' and cWhCode= ''%s'' order by cBatch ', [pInvCode, pWhCode])
//  else
//    strSQL := format('select * from InvPositionSum where  iQuantity>0 and cinvcode=''%s'' and cWhCode= ''%s'' and cposcode=''%s'' order by cBatch ', [pInvCode, pWhCode, pPostion]);
//  DM_Global.ExecSql(fdm_stock, strSQL);

end;

function Tfrm_RdVouch11.GetcWhCode: string;
begin
  Result := '';
  if (not fdm_Main.eof) or (fdm_Main.State in [dsEdit, dsInsert]) then
    Result := fdm_Main.FieldByName('cWhCode').AsString.Trim;
end;

function Tfrm_RdVouch11.GetPostXML(): string;
var
  FXmlDoc: TXMLDocument;
  LoopInt, tmpInt: Integer;
  ndVouchHead, tmpListRootNode: IXMLNode;
  ndVouchBody, ndProduct: IXMLNode;
  bkm_Detail: TBookmark;

  procedure WriteChildNodeByDataSet(XMLDoc: TXMLDocument; nsParent: IXMLNode; dstSource: TDataSet; strNodeName, strFieldName: string);
  var
    ndTmp: IXMLNode;
    fdTmp: TField;
  begin
    strFieldName := Trim(strFieldName);
    fdTmp := dstSource.Fields.FindField(strFieldName);

    if fdTmp = nil then
    begin
      showmessage(format('%s表生成提交soap所需要的XML时错误，未发现字段%s', [VouObj.DesMainTable, strFieldName]));
      Abort;
    end;

    ndTmp := XMLDoc.CreateNode(strNodeName);
    nsParent.ChildNodes.Add(ndTmp);
    ndTmp.Text := dstSource.FieldByName(strFieldName).AsString;
  end;

begin
  try

    FXmlDoc := TXMLDocument.Create(self); // 写入XML
    // 加入版本信息 ‘<?xml version="1.0" encoding="GB2312" ?> ’
    FXmlDoc.Active := true;
    FXmlDoc.Version := '1.0';
    FXmlDoc.Encoding := 'UTF-8';

    // 表头
    ndVouchHead := FXmlDoc.CreateNode('XMaterialOutInfo'); // 主单根结点
    FXmlDoc.DocumentElement := ndVouchHead;

    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cCode', 'cCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'dDate', 'dDate');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cWhCode', 'cWhCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMemo', 'cMemo');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cDepCode', 'cDepCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMaker', 'cMaker');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'crdcode', 'crdcode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMPoCode', 'cMPoCode');

    // 表体
    ndVouchBody := FXmlDoc.CreateNode('XMaterialOutsInfos'); // 子表根结点
    ndVouchHead.ChildNodes.Add(ndVouchBody);


    qry_Detail_group.Close;
    qry_Detail_group.SQL.Text := 'select iMPoIds,cMoCode,iMoSeq ,cMoLotCode,cInvCode,cBatch,cposition,'      //
      + 'Max(iUnitCost) iUnitCost,max(iPrice) iPrice, sum(cast(iQuantity as float))iQuantity '                                        //
      + ' from  fdm_Detail' //
      + ' group by iMPoIds,cMoCode,iMoSeq ,cMoLotCode,cInvCode,cBatch,cposition';          //
    FDLocalSQL.Active := True;
    qry_Detail_group.Open;
    while not qry_Detail_group.eof do               // 表体
    begin
      ndProduct := FXmlDoc.CreateNode('XMaterialOutsInfo'); // 子表根结点
      ndVouchBody.ChildNodes.Add(ndProduct);
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cInvCode', 'cInvCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'invcode', 'cInvCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cBatch', 'cBatch');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iMPoIds', 'iMPoIds');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'ipesodid', 'iMPoIds');     //
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cmocode', 'cMoCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cpesocode', 'cMoCode');        //

      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'imoseq', 'iMoSeq');

      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iQuantity', 'iQuantity');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iUnitCost', 'iUnitCost');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iPrice', 'iPrice');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cmolotcode', 'cMoLotCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cposition', 'cPosition');
      qry_Detail_group.Next;
    end;

    Result := FXmlDoc.Xml.Text;
  finally
    FXmlDoc.Active := False;
    FXmlDoc.Free;
  end;
end;

procedure Tfrm_RdVouch11.InitData;
var
  strVouchSql: string;
begin
  inherited;

  // 打开主表

  strVouchSql := format('select * from %s where %s=''%s''', [FVouchObj.DesMainTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  DM_Global.ExecSql(fdm_Main, strVouchSql);
  if fdm_Main.eof then
    fdm_Main.Append;

  CreateADCtrl(FVouchObj.DesMainTableDef, lyt_Main, fdm_Main, BindSourceDB_Main);
  // SZHL_ComboBoxSyncToControl(lyt_Main, fdm_Main);
//  strVouchSql :=
//    'update SZHL_ItmDef set editing=1 WHERE FieldName=''IQUANTITY''  AND TableId IN (SELECT TableId FROM SZHL_TableDef WHERE Name=''SZHL_QRCode'')';
//  DM_Global.ExecuteSql(strVouchSql);

  CreateADCtrl(FVouchObj.DesSubCardTable, LayDetailCard, fdm_Detail, BindSourceDB_Detail);
  SyncMemTableToLookupControl(LayDetailCard, fdm_Detail);
end;

procedure Tfrm_RdVouch11.setWhCode(const Value: string);
begin
  fdm_Main.FieldByName('cWhCode').Value := Value;
  FindSZHL(lyt_Main, fdm_Main, 'cWhCode');
end;

procedure Tfrm_RdVouch11.StringGrid_DetailSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if SameText('数量', StringGrid_Detail.Columns[ACol].Header) then
  begin
    StringGrid_Detail.Options := StringGrid_Detail.Options + [TGridOption.Editing];
  end
  else
    StringGrid_Detail.Options := StringGrid_Detail.Options - [TGridOption.Editing];

  CanSelect := true;
end;

end.

