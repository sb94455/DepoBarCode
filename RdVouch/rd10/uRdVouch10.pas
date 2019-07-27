unit uRdVouch10;

interface

uses
  System.SysUtils, FMX.platform, System.Types, System.UITypes, System.Classes,
  System.Variants, StrUtils, Xml.XMLDoc, Xml.XMLIntf, FMX.Types, FMX.Controls,
  FMX.VirtualKeyboard, FMX.Forms, FMX.Graphics, FMX.Dialogs, Soap.SOAPHTTPClient,
  BaseForm, FMX.Layouts, FMX.DateTimeCtrls, FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Ani, FMX.ListBox, FMX.Edit, FMX.ScrollBox, FMX.Memo, System.Rtti,
  ProductInService, FMX.Grid.Style, FMX.Grid, UnitLib, WareHouseForm, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Bind.Grid, Data.Bind.Grid,
  FMX.TabControl, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Phys.SQLiteVDataSet;

type
  Tfrm_RdVouch10 = class(TBaseFrm)
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
    ColorAnimation1: TColorAnimation;
    qry_Detail_group: TFDQuery;
    con1: TFDConnection;
    fdlclsql1: TFDLocalSQL;
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
    procedure StringGrid_DetailSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
  private
    { Private declarations }
    dosub: Boolean;
    FVouchObj: TSZHL_Vouch;
    FRdFlag: Boolean;
    FQRCode: string;
    FPosition: string;
    fdm_append: TFDMemTable;
    fdm_sn: TFDMemTable;
    fdm_Postion: TFDMemTable;
    // FcWhCode: string;
    SL_QRAutoID: TStringList;
    procedure DecryptQRCode_A(qrInfo1: TQRCodeInfo);
    function GetPostXML(): string;
    procedure DecryptQRCode;
    procedure setDefaulPosition(Value: string);
    function GetcWhCode: string;
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
  frm_RdVouch10: Tfrm_RdVouch10;

implementation

{$R *.fmx}

uses
  UnitU8DM, uSZHLFMXEdit;

procedure Tfrm_RdVouch10.btn_ClearDetailClick(Sender: TObject);
begin
  if fdm_Main.State in [dsInsert, dsEdit] then
    fdm_Main.Cancel;
  ClearChildCtrl(lyt_Main, true); // 清空&显示/隐藏
  fdm_Main.Append;
  fdm_Detail.EmptyDataSet;
  fdm_Sub.EmptyDataSet;
end;

procedure Tfrm_RdVouch10.btn_SaveClick(Sender: TObject);
var
  fdm_SZHL_QRCodeRecord: TFDMemTable;
  strUpdateSql: string;

  procedure HttpPost();
  var
    tmpHTTPRIO: THTTPRIO;
    Service_Data: ProductInServiceSoap;
    strReturn: string;
  begin
    try
      if Memo1.Text.Trim.IsEmpty then
        Memo1.Text := GetPostXML();

      tmpHTTPRIO := THTTPRIO.Create(Nil);
      // exit;
      Service_Data := GetProductInServiceSoap(False, PubVar_WebServiceUrl + Const_Url_Def_ProductIn, tmpHTTPRIO);
      strReturn := Service_Data.Insert(Memo1.Text.Trim);

      if not SameText(strReturn, 'OK') then
      begin
        showmessage(format('单据%s保存失败.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));
      end
      else
        showmessage(format('单据%s保存成功.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));

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
        fdm_Detail.Next;
      end;
    finally
      FreeAndNil(fdm_SZHL_QRCodeRecord);
    end;
  end;

  SL_QRAutoID.Clear;
end;

procedure Tfrm_RdVouch10.cbRedClick(Sender: TObject);
begin
  if cbRed.IsChecked = false then
    VouObj.VouchArrow := vhRed
  else
    VouObj.VouchArrow := vhBlue;
end;

procedure Tfrm_RdVouch10.DecryptQRCode;
var
  cmd, strVouchsSql, strDesInvCode, cBatch: string;
  fdm_Ref: TFDMemTable;
//  SubQty, SubQtyRmt, SubQtyAmt, iQuantity: double;
//  allsubqty, alldetailqty: double;
//  SN, VouchId, VouchsId: Integer;
  qrInfo1: TQRCodeInfo;
  strWhCode, strPostion: string;
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
    strPostion := Trim(GetValueByKey(FQRCode, 'cPosition'));
    if CheckPostion(strWhCode, strPostion, fdm_Postion) then
    begin
      cWhCode := strWhCode;
      Position := strPostion;
    end;
  end;
  if SameText(cmd, 'S') = True then // 来源，暂时只允许一个单据来源，且不允许物料重复。
  begin
    if fdm_append = nil then
      fdm_append := TFDMemTable.Create(nil);
    if fdm_Sub.RecordCount > 0 then
      exit;

    strVouchsSql := format('select *,0.00 as %s  from %s where %s = ''%s''', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, 'MoCode', GetValueByKey(FQRCode, 'MoCode')]);
    DM_Global.ExecSql(fdm_append, strVouchsSql);
    fdm_Sub.AppendData(fdm_append);
    if fdm_Sub.RecordCount > 0 then
      if fdm_Main.State in [dsInsert, dsEdit] then
      begin
        fdm_Main.FieldByName('cDepCode').Value := fdm_append.FieldByName('MDeptCode').AsString.Trim;
        fdm_Main.FieldByName('cMPoCode').AsString := fdm_append.FieldByName('MoCode').AsString;
        fdm_Main.FieldByName('iproorderid').Value := fdm_append.FieldByName('MoID').AsString;
      end;
    if fdm_sn = nil then
      fdm_sn := TFDMemTable.Create(nil);
    strVouchsSql := format('select * from SZHL_QRCode where VouchId = (''%s'') ', [GetValueByKey(FQRCode, 'id')]);
    DM_Global.ExecSql(fdm_sn, strVouchsSql);
  end;
  if SameText(cmd, 'A') = True then
  begin
    if fdm_Detail.RecordCount = 0 then
      StringGrid_Detail.Selected := -1;
    qrInfo1 := GetQRInfo_ByAutoid(edt_QRCode.Text);
    DecryptQRCode_A(qrInfo1);
  end;
  edt_QRCode.Text := '';
end;

procedure Tfrm_RdVouch10.DecryptQRCode_A(qrInfo1: TQRCodeInfo);
var
  minQty, InvDefaultQty: Double;
  SubQty, SubQtyRmt, SubQtyAmt: Double;
  recordno: TBookmark;
  qz: Boolean;                       //强制超到货入库标准

  procedure insertOrUpdate(updateQty: Double);
  begin
    fdm_Detail.Append;
    fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdm_Sub.FieldByName(VouObj.SrcLinkDesSubField).AsString;
    fdm_Detail.FieldByName('iQuantity').Value := updateQty;
    fdm_Detail.FieldByName('cDefine33').Value := qrInfo1.AutoId;
    fdm_Detail.FieldByName('cInvCode').Value := qrInfo1.cInvCode.Trim;
    fdm_Detail.FieldByName('cBatch').Value := qrInfo1.cBatch;
    fdm_Detail.FieldByName('cPosition').Value := Self.Position.Trim;
    fdm_Detail.FieldByName('iUnitCost').Value := 0; // XML不能为空
    fdm_Detail.FieldByName('iPrice').Value := 0; // XML不能为空

    fdm_Detail.FieldByName('cmocode').Value := fdm_Sub.FieldByName('MoCode').AsString;
    fdm_Detail.FieldByName('cMoLotCode').Value := fdm_Sub.FieldByName('MoLotCode').AsString;
    fdm_Detail.FieldByName('imoseq').Value := fdm_Sub.FieldByName('SortSeq').AsString;
    fdm_Detail.FieldByName('iNQuantity').Value := fdm_Sub.FieldByName('Qty').AsString;
    fdm_Detail.Post;
  end;

begin

  if (fdm_Detail.State in [dsEdit, dsInsert]) then
  begin
    fdm_Detail.Post;
  end;

  if fdm_Detail.RecordCount > 0 then
  begin
    fdm_Detail.First;
    if fdm_Detail.Locate('cInvCode;cDefine33', VarArrayOf([qrInfo1.cInvCode, qrInfo1.AutoId.Trim]), [loCaseInsensitive]) = True then //.Locate('cDefine33;cInvCode', VarArrayOf([SN,strDesInvCode]), [loPartialKey]) and (SN <> 0) then       ////// 单次重复扫码 双判定
    begin
      showmessage(Format('物料:%s序列号为%s重复。', [qrInfo1.cInvCode, qrInfo1.AutoId]));
      edt_QRCode.Text := '';
      Abort;
    end;
  end;

  InvDefaultQty := qrInfo1.iQuantity;

  try
    fdm_Sub.DisableControls;
    qz := False;

    if fdm_Sub.RecordCount > 0 then
      fdm_Sub.First;
    while not fdm_Sub.Eof do
    begin
      if SameText(fdm_Sub.FieldByName('cInvCode').AsString, qrInfo1.cInvCode) = False then
      begin
        fdm_Sub.Next;
        Continue;
      end;

      recordno := fdm_Sub.Bookmark;

      SubQty := fdm_Sub.FieldByName(VouObj.SrcQtyField).AsFloat;     //到货数量
      SubQtyRmt := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat;  //已入数量
      SubQtyAmt := SubQty - SubQtyRmt;                                    //未入数量

      if SubQtyAmt > InvDefaultQty then
        minQty := InvDefaultQty
      else
        minQty := SubQtyAmt;
      if Abs(minQty) > 0 then
      begin
        fdm_Sub.Edit;
        fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value + minQty;
        fdm_Sub.Post;
        InvDefaultQty := InvDefaultQty - minQty;
        insertOrUpdate(minQty);
        SL_QRAutoID.Add(qrInfo1.AutoId);
      end;

      if (qz = True) and (Abs(InvDefaultQty) > 0) then
      begin
        minQty := InvDefaultQty;
        fdm_Sub.Edit;
        fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value + minQty;
        fdm_Sub.Post;
        InvDefaultQty := InvDefaultQty - minQty;
        insertOrUpdate(minQty);
        SL_QRAutoID.Add(qrInfo1.AutoId);
        break;
      end;
      if InvDefaultQty = 0 then
        Break;

      fdm_Sub.Next;

      if fdm_Sub.Eof then
      begin
        fdm_Sub.Bookmark := recordno;
        qz := true;
      end;

    end;
  finally

    fdm_Sub.EnableControls;
  end;

end;

procedure Tfrm_RdVouch10.edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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

procedure Tfrm_RdVouch10.fdm_DetailAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch10.fdm_DetailAfterPost(DataSet: TDataSet);
begin
  inherited;
  RefreshData;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch10.fdm_DetailBeforePost(DataSet: TDataSet);
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
    // showmessage('请选择仓库');
    if DM_Global.CheckWareHousePos(cWhCode) = True then
    begin
      if DataSet.FieldByName('cposition').AsString = '' then
      begin
        showmessage('当前仓库有货位管理，请指定货位。');
        // exit;
      end;
    end;
  end;
  if DM_Global.CheckInvBatch(DataSet.FieldByName('cInvCode').AsString) = True then
  begin
    if DataSet.FieldByName('cBatch').AsString = '' then
    begin
      //showmessage('当前存货有批次管理，请指定批次。');
      DataSet.FieldByName('cBatch').Value := FormatDateTime('yyyymmdd', Date());
    end;
  end
  else
    DataSet.FieldByName('cBatch').Value := ''; // 无批次管理清除批次。
end;

procedure Tfrm_RdVouch10.fdm_MainAfterInsert(DataSet: TDataSet);
begin
  inherited;

  DataSet.FieldByName('dDate').Value := DateToStr(DATE());
  DataSet.FieldByName('cMaker').Value := PubVar_LoginInfo.UserName;
end;

procedure Tfrm_RdVouch10.fdm_MainAfterOpen(DataSet: TDataSet);
var
  strVouchsSql, strVouchsSql_sub: string;
begin
  inherited;

  // 子表（来源展开）表 ,初次随表头打开，用来处理打开已经有的单据。
  LinkGridToData_Sub.Columns.Clear;
  strVouchsSql_sub := format('select %s from %s where %s =''%s''', [FVouchObj.DesSubLinkSrcFeild, FVouchObj.DesSubTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  strVouchsSql := format('select *, %s from %s where %s in (%s)', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, FVouchObj.SrcLinkDesSubField, strVouchsSql_sub]);
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
//  fdm_Detail.FieldDefs.Add('iarrsid', ftInteger, 0, False);
  fdm_Detail.FieldDefs.Add('cDefine33', ftString, 50, False);
//                              fdm_Detail.FieldDefs.Add('iarrsid',ftInteger,0,true);
  fdm_Detail.CreateDataSet;
  DM_Global.ExecSql(fdm_Detail, strVouchsSql);

end;

procedure Tfrm_RdVouch10.fdm_MainBeforePost(DataSet: TDataSet); // 保存前检查主表必输入项
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

procedure Tfrm_RdVouch10.fdm_SubAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, True);

end;

procedure Tfrm_RdVouch10.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  VKAutoShowMode := TVKAutoShowMode.DefinedBySystem;
  frm_RdVouch10 := nil;
end;

procedure Tfrm_RdVouch10.FormCreate(Sender: TObject);
begin
  inherited;

  FRdFlag := True; // 默认正数(兰字)单据
  ClearChildCtrl(lyt_Main, False); // 清楚控件内容
  TabControl1.ActiveTab := TabControl1.Tabs[0]; // 默认页签
  SL_QRAutoID := TStringList.Create;
end;

procedure Tfrm_RdVouch10.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = vkF11 then
    edt_QRCode.Text := 'C=A;SN=10978;cPOID=0000000001;cCode=PR18020001;cInvCode=01-113-4003LR;Autoid=1000000001;cBatch=batch1;iQty=2';
end;

procedure Tfrm_RdVouch10.FormShow(Sender: TObject);
var
  FService: IFMXVirtualKeyboardService;
begin
  inherited;
  txt_BaseTitle.Text := VouObj.DesMainTableDef;

  TabItem1.Visible := False;
{$IFDEF DEBUG}
  Position := '18042';
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
  // self.edt_QRCode.SetFocus;
  begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) then
    begin
      FService.HideVirtualKeyboard;
      edt_QRCode.SetFocus;
    end;
  end;
  // if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, Keyboard) then
  // begin
  // if TVirtualKeyBoardState.Visible in Keyboard.GetVirtualKeyBoardState then
  // begin
  // Keyboard.HideVirtualKeyboard;
  // end
  // end;
end;

procedure Tfrm_RdVouch10.RefreshData; // 根据Detail汇总到Sub
var
  strVouchsSql: string;
  bkTmp: TBookmark;
begin
  inherited;
  if fdm_Detail.eof then
    exit;

  // 子表（来源展开）表 ,初次随表头打开，用来处理打开已经有的单据。
  bkTmp := fdm_Detail.Bookmark;
  fdm_Detail.DisableControls;
  // fdm_Sub.EmptyDataSet;
  fdm_Detail.last;
  //while not fdm_Detail.eof do
  //begin
    // if fdm_Sub.Locate(VouObj.SrcLinkDesSubField, VarArrayOf([Trim(fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString)])) = False then
    // begin
    // try
    // fdm_Sub.AppendData(fdm_sub_append);
    // finally
    // fdm_sub_append.EmptyDataSet;
    // end;
    // end;
  if fdm_Sub.Locate('cInvCode', VarArrayOf([fdm_Detail.FieldByName('cInvCode').AsString.Trim])) and fdm_Sub.Locate('MoLotCode', VarArrayOf([fdm_Detail.FieldByName('cMoLotCode').AsString.Trim])) then
  begin
    fdm_Sub.Edit;
    fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat + fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
    fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat - fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
    fdm_sub.FieldByName('NowQty').Value := fdm_sub.FieldByName('NowQty').AsFloat + fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
    fdm_Sub.Post;
    fdm_append.EmptyDataSet;
  end;
  //  fdm_Detail.Next;
 // end;
  fdm_Detail.EnableControls;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, True);
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch10.setDefaulPosition(Value: string);
begin
  FPosition := Value;
  txt_BaseTitle.Text := format('%s  P:%s', [VouObj.DesMainTableDef, Value])
end;

procedure Tfrm_RdVouch10.setWhCode(const Value: string);
begin
  fdm_Main.FieldByName('cWhCode').Value := Value;
  FindSZHL(lyt_Main, fdm_Main, 'cWhCode');
end;

procedure Tfrm_RdVouch10.StringGrid_DetailSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
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

function Tfrm_RdVouch10.GetcWhCode: string;
begin
  Result := '';
  if (not fdm_Main.eof) or (fdm_Main.State in [dsEdit, dsInsert]) then
    Result := fdm_Main.FieldByName('cWhCode').AsString.Trim;
end;

function Tfrm_RdVouch10.GetPostXML(): string;
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
    // if dstSource.FieldByName(strFieldName).AsString = '' then
    // begin
    // showmessage(format('%s表提交soap生成XML时错误，字段%s内容为空', [VouObj.MainTable, strFieldName]));
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
    // 加入版本信息 ‘<?xml version="1.0" encoding="UTF-8" ?> ’

    // 表头
    ndVouchHead := FXmlDoc.CreateNode('XProductInInfo'); // 主单根结点
    FXmlDoc.DocumentElement := ndVouchHead;
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cCode', 'cCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'dDate', 'dDate');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cWhCode', 'cWhCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'iproorderid', 'iproorderid');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMemo', 'cMemo');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cDepCode', 'cDepCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMaker', 'cMaker');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cRdCode', 'cRdCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMPoCode', 'cMPoCode');

    //
    ndVouchBody := FXmlDoc.CreateNode('XProductInsInfos'); // 子表根结点
    ndVouchHead.ChildNodes.Add(ndVouchBody);
                             qry_Detail_group.Close;

    qry_Detail_group.SQL.Text := //
      'select cInvCode,cBatch,iMPoIds,cmocode,imoseq,cMoLotCode,cposition,'      //
      + 'Max(iUnitCost) iUnitCost,max(iPrice) iPrice, sum(cast(iQuantity as float)) iQuantity, sum(cast(inquantity as float)) inquantity '                                        //
      + ' from fdm_Detail' //
      + ' group by cInvCode,cBatch,iMPoIds,cmocode,imoseq,cMoLotCode,cposition';          //
    fdlclsql1.Active := True;
    qry_Detail_group.Connection := con1;
    qry_Detail_group.Open;

    while not qry_Detail_group.eof do
    begin
      ndProduct := FXmlDoc.CreateNode('XProductInsInfo'); // 子表根结点
      ndVouchBody.ChildNodes.Add(ndProduct);
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cInvCode', 'cInvCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cBatch', 'cBatch');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iMPoIds', 'iMPoIds');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cmocode', 'cmocode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'imoseq', 'imoseq');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cMoLotCode', 'cMoLotCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iQuantity', 'iQuantity');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iUnitCost', 'iUnitCost');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iPrice', 'iPrice');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cPosition', 'cPosition');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'inquantity', 'inquantity');
      qry_Detail_group.Next;
    end;

    Result := FXmlDoc.Xml.Text;
  finally
    FXmlDoc.Active := False;
    FXmlDoc.Free;
  end;
end;

procedure Tfrm_RdVouch10.InitData;
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
  //SZHL_ComboBoxSyncToControl(lyt_Main, fdm_Main);

end;

end.

