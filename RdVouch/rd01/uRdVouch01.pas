unit uRdVouch01;

interface

uses
  System.SysUtils, FMX.VirtualKeyboard, FMX.platform, System.Types, System.UITypes,
  System.Classes, System.Variants, StrUtils, Xml.XMLDoc, System.diagnostics, Xml.XMLIntf,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Soap.SOAPHTTPClient,
  BaseForm, FMX.Layouts, FMX.DateTimeCtrls, FMX.Objects, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.Ani, FMX.ListBox, FMX.Edit, FMX.ScrollBox, FMX.Memo, System.Rtti,
  PurchaseInService, FMX.Grid.Style, FMX.Grid, UnitLib, WareHouseForm, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Bind.Grid, Data.Bind.Grid,
  FMX.TabControl, Data.FMTBcd, Data.SqlExpr, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Phys.SQLiteVDataSet,
  Data.Bind.Controls, Fmx.Bind.Navigator, FMX.EditBox, FMX.NumberBox;

type
  Tfrm_RdVouch01 = class(TBaseFrm)
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
    fdlclsql1: TFDLocalSQL;
    qry_Detail_group: TFDQuery;
    con1: TFDConnection;
    TabControlDetail: TTabControl;
    TabItemList: TTabItem;
    btn1: TButton;
    TabItemCard: TTabItem;
    LayDetailCard: TLayout;
    BindNavigator1: TBindNavigator;
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
    procedure FormDestroy(Sender: TObject);
    procedure StringGrid_DetailSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
    procedure BindSourceDB_MainSubDataSourceDataChange(Sender: TObject; Field: TField);
    procedure Tab_DetailDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
  private
    { Private declarations }

    tsKey: tstringlist;
    sw: TStopwatch;
    SL_QRAutoID: TStringList;
    FVouchObj: TSZHL_Vouch;
    FRdFlag: Boolean;
    FQRCode: string;
    FPosition: string;
    fdm_append: TFDMemTable;
    fdm_WareHouse: TFDMemTable;
    fdm_Postion: TFDMemTable;
    FbWhPos: Boolean;
    function GetPostXML(): string;
    procedure DecryptQRCode;
    procedure DecryptQRCode_A(qrInfo1: TQRCodeInfo);
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
  frm_RdVouch01: Tfrm_RdVouch01;
  FService: IFMXVirtualKeyboardToolbarService;
  FService_kb: FMX.VirtualKeyboard.IFMXVirtualKeyboardService;

implementation

{$R *.fmx}

uses
  UnitU8DM, uSZHLFMXEdit;

procedure Tfrm_RdVouch01.BindSourceDB_MainSubDataSourceDataChange(Sender: TObject; Field: TField);
begin
  inherited;
  if Field <> nil then
    if SameText(Field.FieldName, 'cWhCode') then
      if fdm_Main.FieldByName('cWhCode').AsString.Trim.IsEmpty = False then
        CheckWarehouse(fdm_Main.FieldByName('cWhCode').AsString.Trim, fdm_WareHouse, FbWhPos);
end;

procedure Tfrm_RdVouch01.btn_ClearDetailClick(Sender: TObject);
begin
  if fdm_Main.State in [dsInsert, dsEdit] then
    fdm_Main.Cancel;
  ClearChildCtrl(lyt_Main, true); // 清空&显示/隐藏
  fdm_Main.Append;
//  fdm_Detail.Close;
  fdm_Detail.EmptyDataSet;
//  fdm_Sub.Close;
  fdm_Sub.EmptyDataSet;

end;

procedure Tfrm_RdVouch01.btn_SaveClick(Sender: TObject);
var
  fdm_SZHL_QRCodeRecord: TFDMemTable;
  strUpdateSql: string;

  procedure HttpPost();
  var
    Service_Data: PurchaseInServiceSoap;
    strReturn, strsqlcode: string;
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
      {$ENDIF}                                                                                                                                                                                                                                                ;
      tmpHTTPRIO := THTTPRIO.Create(self);
      Service_Data := GetPurchaseInServiceSoap(False, PubVar_WebServiceUrl + Const_Url_Def_PurchaseIn, tmpHTTPRIO);
      {$IFDEF DEBUG}
      sw1.Stop;
      ShowMessage(Format('GetPurchaseInServiceSoap(毫秒):%d', [sw1.ElapsedMilliseconds])); //602
      {$ENDIF}

      {$IFDEF DEBUG}
      sw1 := TStopwatch.StartNew;
      {$ENDIF}                                                                                                                                                                                                                                                ;
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
      begin
        ShowMessage(format('单据%s保存成功.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));
        btn_ClearDetailClick(Sender);
      end;

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
  sw := TStopwatch.StartNew;
  HttpPost;
  sw.Stop;
  {$IFDEF DEBUG}
  ShowMessage(Format('HttpPost花费时间(毫秒):%d', [sw.ElapsedMilliseconds])); //602
  {$ENDIF}

  sw := TStopwatch.StartNew;
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
        fdm_SZHL_QRCodeRecord.FieldByName('VouchType').Value := 'ArrivalVouch';

        fdm_SZHL_QRCodeRecord.FieldByName('dAction').Value := 'rd01';
        fdm_SZHL_QRCodeRecord.FieldByName('dDatetime').Value := Now;
        fdm_SZHL_QRCodeRecord.FieldByName('cUser').Value := PubVar_LoginInfo.UserID;
        fdm_SZHL_QRCodeRecord.FieldByName('QRAutoid').Value := fdm_Detail.FieldByName('cDefine33').AsInteger;
        fdm_SZHL_QRCodeRecord.FieldByName('cInvCode').Value := fdm_Detail.FieldByName('cInvCode').AsString;
        fdm_SZHL_QRCodeRecord.FieldByName('Qty').Value := fdm_Detail.FieldByName('iQuantity').AsFloat;
        fdm_SZHL_QRCodeRecord.FieldByName('cIPAdress').Value := ''; //ComputerLocalIP;
        fdm_SZHL_QRCodeRecord.Post;
//        strUpdateSql := Format('update szhl_QrCode set Balance=Balance+%f where autoid=%s', [fdm_Detail.FieldByName('iQuantity').AsFloat, fdm_Detail.FieldByName('Autoid').AsString]);
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

//      strUpdateSql := Format('exec SZHL_ComputerQrBalance %s', [fdm_Detail.FieldByName('Autoid').AsString]);
//      DM_Global.ExecuteSql(strUpdateSql);
      btn_ClearDetailClick(Self);
    finally
      FreeAndNil(fdm_SZHL_QRCodeRecord);
    end;
  end;
  sw.Stop;
  {$IFDEF DEBUG}
  ShowMessage(Format('update szhl_QrCode set Balance(毫秒):%d', [sw.ElapsedMilliseconds])); //602
  {$ENDIF}

  SL_QRAutoID.Clear;
end;

procedure Tfrm_RdVouch01.cbRedClick(Sender: TObject);
begin
  if cbRed.IsChecked = false then
    VouObj.VouchArrow := vhRed
  else
    VouObj.VouchArrow := vhBlue;
end;

procedure Tfrm_RdVouch01.DecryptQRCode_A(qrInfo1: TQRCodeInfo);
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
    fdm_Detail.FieldByName('cPosition').Value := Self.Position.Trim;
    fdm_Detail.FieldByName('iUnitCost').Value := 0; // XML不能为空
    fdm_Detail.FieldByName('iPrice').Value := 0; // XML不能为空
    fdm_Detail.FieldByName('iArrsId').Value := fdm_Sub.FieldByName('Autoid').AsString;
    fdm_Detail.FieldByName('cpoid').Value := fdm_Sub.FieldByName('cpoid').AsString;
    fdm_Detail.FieldByName('iPOsID').Value := fdm_Sub.FieldByName('PO_Podetails_ID').AsString;
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

procedure Tfrm_RdVouch01.DecryptQRCode;       //二维码转换
var
  cmd, strVouchsSql, strDesInvCode, codebatch: string;
  iQuantity: double;
  qrInfo1: TQRCodeInfo;
  strWhCode, strPostion: string;


begin
  if edt_QRCode.Text.Trim.Length = 0 then
    EXIT;
  FQRCode := edt_QRCode.Text;

  cmd := Trim(GetValueByKey(FQRCode, 'c'));
  try
    if SameText(cmd, 'W') = true then    //获取仓库
    begin
      strWhCode := Trim(GetValueByKey(FQRCode, 'cWhCode'));
      if CheckWarehouse(strWhCode, fdm_WareHouse, FbWhPos) then
        fdm_Main.FieldByName('cWhCode').Value := strWhCode;
    end;
    if SameText(cmd, 'P') = true then        //获取货位
    begin
      strPostion := Trim(GetValueByKey(FQRCode, 'cPosition'));
      if CheckPostion(strWhCode, strPostion, fdm_Postion) then
      begin
        cWhCode := strWhCode;
        Position := strPostion;
      end;
    end;
    if (SameText(cmd, 'S') = true) or (SameText(cmd, '') = true) then        // 来源，暂时只允许一个单据来源，且不允许物料重复。
    begin
      StringGrid_Sub.selected := -1;
      if fdm_append = nil then
        fdm_append := TFDMemTable.Create(nil);
      if fdm_Sub.RecordCount > 0 then // 目前只接受一个来源的录入方式
        EXIT;

      strVouchsSql := format('select *,0.00 as %s  from %s where %s = (''%s'') order by cinvcode', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable,    //
        'id', GetValueByKey(FQRCode, 'id')]);
      DM_Global.ExecSql(fdm_append, strVouchsSql);

      fdm_Sub.AppendData(fdm_append);
      if fdm_Sub.RecordCount > 0 then
        if fdm_Main.State in [dsInsert, dsEdit] then
        begin
          fdm_Main.FieldByName('cVenCode').Value := fdm_append.FieldByName('cVenCode').AsString.Trim;
          fdm_Main.FieldByName('cOrderCode').Value := fdm_append.FieldByName('cPOID').AsString.Trim;
          fdm_Main.FieldByName('cARVCode').Value := fdm_append.FieldByName('cCode').AsString.Trim;
          fdm_Main.FieldByName('ipurarriveid').Value := fdm_append.FieldByName('ID').AsString.Trim;
          fdm_Main.FieldByName('cMemo').Value := fdm_append.FieldByName('cMemo').AsString.Trim;
          fdm_Main.FieldByName('cDepCode').Value := fdm_append.FieldByName('cDepCode').AsString.Trim;
        end;
    end;
    if SameText(cmd, 'A') = true then
    begin
      if fdm_Detail.RecordCount = 0 then
        StringGrid_Detail.Selected := -1;
      qrInfo1 := GetQRInfo_ByAutoid(edt_QRCode.Text);
//      qrInfo1.cBatch := FormatDateTime('YYYYMMDD', Now);
      DecryptQRCode_A(qrInfo1);
    end
  finally
    edt_QRCode.Text := '';
  end;

end;

procedure Tfrm_RdVouch01.edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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

procedure Tfrm_RdVouch01.fdm_DetailAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch01.fdm_DetailAfterPost(DataSet: TDataSet);
begin
  inherited;
  RefreshData;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch01.fdm_DetailBeforePost(DataSet: TDataSet);
var
  strErrMsg: string;
begin
  inherited;
  edt_QRCode.SetFocus;
  strErrMsg := DM_Global.CheckAllowEmptys(DataSet, VouObj.DesSubTableDef);
  if strErrMsg <> '' then
  begin
    showmessage(strErrMsg);
    Abort;
  end;
  if cWhCode <> '' then
  begin
    //showmessage('请选择仓库');
    if DM_Global.CheckWareHousePos(cWhCode) = true then
    begin
      if DataSet.FieldByName('cposition').AsString = '' then
      begin
        showmessage('当前仓库有货位管理，请指定货位。');
        // exit;
      end;
    end;
  end;

  if fdm_Sub.FieldByName('bInvBatch').AsBoolean = False then
    DataSet.FieldByName('cBatch').Value := ''
  else
  begin
    DataSet.FieldByName('cBatch').AsString := fdm_Sub.FieldByName('cbatch').AsString;
    if DataSet.FieldByName('cBatch').AsString = '' then
    begin
      showmessage('当前存货有批次管理，请指定批次。');
    end;
  end;
end;

procedure Tfrm_RdVouch01.fdm_MainAfterInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('dDate').Value := DateToStr(DATE());
  DataSet.FieldByName('cMaker').Value := PubVar_LoginInfo.UserName;
end;

procedure Tfrm_RdVouch01.fdm_MainAfterOpen(DataSet: TDataSet);
var
  strVouchsSql, strVouchsSql_sub: string;
  i: integer;
begin
  inherited;

  // 子表（来源展开）表 ,初次随表头打开，用来处理打开已经有的单据。
  LinkGridToData_Sub.Columns.Clear;
  strVouchsSql_sub := format('select %s from %s where %s =''%s''', [FVouchObj.DesSubLinkSrcFeild, FVouchObj.DesSubTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  strVouchsSql := format('select *,0.00 %s from %s where %s in (%s)', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, FVouchObj.SrcLinkDesSubField, strVouchsSql_sub]);
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

procedure Tfrm_RdVouch01.fdm_MainBeforePost(DataSet: TDataSet); // 保存前检查主表必输入项
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

procedure Tfrm_RdVouch01.fdm_SubAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, true);
end;

procedure Tfrm_RdVouch01.FormActivate(Sender: TObject);
begin
  inherited;
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  FService_kb.HideVirtualKeyboard; // 隐藏虚拟键盘
{$ENDIF}
//  VKAutoShowMode := TVKAutoShowMode.Never; //此窗口不弹出输入法
end;

procedure Tfrm_RdVouch01.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frm_RdVouch01 := nil;
end;

procedure Tfrm_RdVouch01.FormCreate(Sender: TObject);
begin
  inherited;
  // 控制虚拟键盘的操作
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService_kb));
{$ENDIF}
  tsKey := tstringlist.Create;
  //FRdFlag := true; // 默认正数(蓝字)单据
  ClearChildCtrl(lyt_Main, False); // 清空&显示/隐藏
  TabControl1.ActiveTab := TabControl1.Tabs[0]; // 默认页签
  SL_QRAutoID := TStringList.Create;
end;

procedure Tfrm_RdVouch01.FormDeactivate(Sender: TObject);
begin
  inherited;
  VKAutoShowMode := TVKAutoShowMode.DefinedBySystem;
end;

procedure Tfrm_RdVouch01.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(SL_QRAutoID);
  FreeAndNil(fdm_append);

// QrAutoID:=TStringList.Create;
end;

procedure Tfrm_RdVouch01.FormFocusChanged(Sender: TObject);
var
  t1: TSZHL_NumberBox;
//  b: TTabItem;
begin

  inherited;
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
  FService_kb.HideVirtualKeyboard;
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
        FService_kb.ShowVirtualKeyboard(t1);
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
      FService_kb.HideVirtualKeyboard;
      {$ENDIF}
    end;

//  VKAutoShowMode := TVKAutoShowMode.Never;
  end;
end;

procedure Tfrm_RdVouch01.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = vkF11 then
    edt_QRCode.Text := 'C=A;SN=10978;cPOID=0000000001;cCode=PR18020001;cInvCode=01-113-4003LR;Autoid=1000000001;cBatch=batch1;iQty=2';
end;

procedure Tfrm_RdVouch01.FormShow(Sender: TObject);
begin
  inherited;
  txt_BaseTitle.Text := VouObj.DesMainTableDef;

  TabItem1.Visible := False;
{$IFDEF DEBUG}
  Position := '18042';
  TabItem1.Visible := true;
{$ENDIF}
  if FVouchObj.DesMainKey.Trim <> '' then
  begin
    btn_Save.Visible := False;
    btn_ClearDetail.Visible := False;
    BillCodeLay.Visible := False;
  end;
  self.edt_QRCode.SetFocus;
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  FService_kb.HideVirtualKeyboard; // 隐藏虚拟键盘
{$ENDIF}
//  VKAutoShowMode := TVKAutoShowMode.Never; // 此窗口不弹出输入法
end;

procedure Tfrm_RdVouch01.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
var
  t1: TSZHL_NumberBox;
begin
  inherited;
  {$IFDEF DEBUG}
  ShowMessage('hello,FormVirtualKeyboardHidden');
  {$ENDIF}
  if lyt_Main.Visible = False then
    lyt_Main.Visible := true;
  exit;
  if Focused is TSZHL_NumberBox then
  begin

    t1 := Focused as TSZHL_NumberBox;

    if t1.FieldDict.Editing = True then
      KeyboardVisible := True;
  end;
//lyt_Main.Visible:=True;
end;

procedure Tfrm_RdVouch01.RefreshData; // 根据Detail汇总到Sub
var
  strVouchsSql: string;
  bkTmp: TBookmark;
begin
  inherited;
  if fdm_Detail.eof then
    EXIT;

  // 子表（来源展开）表 ,初次随表头打开，用来处理打开已经有的单据。
//  bkTmp := fdm_Detail.Bookmark;
//  fdm_Detail.DisableControls;
//  fdm_Detail.last;
//  if fdm_Sub.Locate('cInvCode;Autoid', VarArrayOf([fdm_Detail.FieldByName('cInvCode').AsString.Trim, fdm_Detail.FieldByName('iArrsId').AsString.Trim])) = true then
//  begin
////    fdm_Sub.Edit;
////    fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat + fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
////    fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat - fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
////    fdm_sub.FieldByName('NowQty').Value := fdm_sub.FieldByName('NowQty').Value + fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
////    fdm_Sub.Post;
//    fdm_append.EmptyDataSet;
//  end;
//
//  fdm_Detail.EnableControls;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, true);
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch01.setDefaulPosition(Value: string);
begin
  FPosition := Value;
  txt_BaseTitle.Text := format('%s  P:%s', [VouObj.DesMainTableDef, Value])
end;

procedure Tfrm_RdVouch01.setWhCode(const Value: string);
begin
  fdm_Main.FieldByName('cWhCode').Value := Value;
  FindSZHL(lyt_Main, fdm_Main, 'cWhCode');
end;

procedure Tfrm_RdVouch01.StringGrid_DetailSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
begin
  exit;
  inherited;
  if SameText('数量', StringGrid_Detail.Columns[ACol].Header) then
  begin
    StringGrid_Detail.Options := StringGrid_Detail.Options + [TGridOption.Editing];
  end
  else
    StringGrid_Detail.Options := StringGrid_Detail.Options - [TGridOption.Editing];

  CanSelect := true;
end;

procedure Tfrm_RdVouch01.StringGrid_SubCellDblClick(const Column: TColumn; const Row: Integer);
begin
  inherited;
  exit;
  if edt_QRCode.Text.IsEmpty then
  begin
    edt_QRCode.Text := format('C=S;ccode=%s;id=%s;cpoid=%s', [fdm_Sub.FieldByName('ccode').AsString, fdm_Sub.FieldByName('id').AsString, fdm_Sub.FieldByName('cpoid').AsString]);
    try
      SZHL_ComboBoxSyncToDB(lyt_Main, fdm_Main);
      DecryptQRCode;
      edt_QRCode.SetFocus;
    finally
      DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
    end;
  end;
end;

procedure Tfrm_RdVouch01.Tab_DetailDblClick(Sender: TObject);
begin
  inherited;
  ShowMessage(fdm_Sub.RecordCount.ToString);
end;

function Tfrm_RdVouch01.GetcWhCode: string;
begin
  Result := '';
  if (not fdm_Main.eof) or (fdm_Main.State in [dsEdit, dsInsert]) then
    Result := fdm_Main.FieldByName('cWhCode').AsString.Trim;
end;

function Tfrm_RdVouch01.GetPostXML(): string;
var
  FXmlDoc: TXMLDocument;
  LoopInt, tmpInt: Integer;
  ndVouchHead, tmpListRootNode: IXMLNode;
  ndVouchBody, ndProduct: IXMLNode;
  bkm_Detailsum: TBookmark;

  procedure WriteChildNodeByDataSet(XMLDoc: TXMLDocument; nsParent: IXMLNode; dstSource: TDataSet; strNodeName, strFieldName: string);
  var
    ndTmp: IXMLNode;
    fdTmp: TField;
  begin
    strFieldName := Trim(strFieldName);
    fdTmp := dstSource.Fields.FindField(strFieldName);

    if fdTmp = nil then
    begin
      showmessage(format('%s表生成提交soap所需要的XML时错误，未发现字段%s', [VouObj.DesMainTable, strFieldName]));  //验证字段
      Abort;
    end;
    // if dstSource.FieldByName(strFieldName).AsString = '' then
    // begin
    // showmessage(format('%s表提交soap生成XML时错误，字段%s内容为空', [VouObj.MainTable, strFieldName]));
    // Abort;
    // end;
    ndTmp := XMLDoc.CreateNode(strNodeName);      //创建节点
    nsParent.ChildNodes.Add(ndTmp);
    ndTmp.Text := dstSource.FieldByName(strFieldName).AsString;  //添加内容
  end;

begin

  try

    FXmlDoc := TXMLDocument.Create(self);
    FXmlDoc.Active := true;
    FXmlDoc.Version := '1.0';
    FXmlDoc.Encoding := 'UTF-8';
    // 加入版本信息 ‘<?xml version="1.0" encoding="GB2312" ?> ’

    // 表头
    ndVouchHead := FXmlDoc.CreateNode('XPurchaseInInfo'); // 主单根结点
    FXmlDoc.DocumentElement := ndVouchHead;

    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cCode', 'cCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'dDate', 'dDate');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cWhCode', 'cWhCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cVenCode', 'cVenCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMemo', 'cMemo');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMaker', 'cMaker');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cOrderCode', 'cOrderCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cARVCode', 'cARVCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cRdCode', 'cRdCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'ipurarriveid', 'ipurarriveid');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cDepCode', 'cDepCode');




    // WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'c',PubVar_LoginInfo.UserName);

    // 表体
    ndVouchBody := FXmlDoc.CreateNode('XPurchaseInsInfos'); // 子表根结点
    ndVouchHead.ChildNodes.Add(ndVouchBody);

    qry_Detail_group.Close;

    qry_Detail_group.SQL.Text := //
      'select cInvCode,iPOsID,iArrsId,cPOID ,cBatch,cposition,'      //
      + 'Max(iUnitCost) iUnitCost,max(iPrice) iPrice, sum(cast(iQuantity as float)) iQuantity '                                        //
      + ' from fdm_Detail' //
      + ' group by cInvCode,iPOsID,iArrsId,cPOID,cBatch,cposition';          //
    fdlclsql1.Active := True;
    qry_Detail_group.Connection := con1;
    qry_Detail_group.Open;

    while not qry_Detail_group.eof do
    begin
      // 表体
      ndProduct := FXmlDoc.CreateNode('XProductInsInfo'); // 子表根结点
      ndVouchBody.ChildNodes.Add(ndProduct);
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cInvCode', 'cInvCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cBatch', 'cBatch');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iQuantity', 'iQuantity');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iUnitCost', 'iUnitCost');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iPrice', 'iPrice');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iPOsID', 'iPOsID');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'iArrsId', 'iArrsId');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cPOID', 'cPOID');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, qry_Detail_group, 'cPosition', 'cPosition');
      qry_Detail_group.Next;
    end;

    Result := FXmlDoc.Xml.Text;
  finally
    FXmlDoc.Active := False;
    FXmlDoc.Free;
  end;
end;

procedure Tfrm_RdVouch01.InitData;
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
//  SZHL_ComboBoxSyncToControl(lyt_Main, fdm_Main);

  CreateADCtrl(FVouchObj.DesSubCardTable, LayDetailCard, fdm_Detail, BindSourceDB_Detail);
  SyncMemTableToLookupControl(LayDetailCard, fdm_Detail);

end;

end.

