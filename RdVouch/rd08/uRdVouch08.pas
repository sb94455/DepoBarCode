unit uRdVouch08;

interface

uses
  System.SysUtils,
  FMX.Platform,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  StrUtils,
  Xml.XMLDoc,
  Xml.XMLIntf,
  FMX.Types,
  FMX.Controls,
  FMX.VirtualKeyboard,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  Soap.SOAPHTTPClient,
  BaseForm,
  FMX.Layouts,
  FMX.DateTimeCtrls,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.ListBox,
  FMX.Edit,
  FMX.ScrollBox,
  FMX.Memo,
  System.Rtti,
  ProductInService,
  FMX.Grid.Style,
  FMX.Grid,
  UnitLib,
  WareHouseForm,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Bind.Grid,
  Data.Bind.Grid,
  FMX.TabControl, Data.FMTBcd, Data.SqlExpr, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.FMXUI.Wait;

type
  Tfrm_RdVouch08 = class(TBaseFrm)
    btn_ClearDetail: TButton;
    ColorAnimation1: TColorAnimation;
    btn_Save: TButton;
    BillCodeLay: TLayout;
    edt_QRCode: TEdit;
    ClearEditButton1: TClearEditButton;
    EllipsesEditButton1: TEllipsesEditButton;
    lbl_txt_QRCodeLabe: TLabel;
    cbRed: TCheckBox;
    lyt_Main: TLayout;
    DetailLay: TLayout;
    TabControl1: TTabControl;
    Tab_Detail: TTabItem;
    StringGrid_Detail: TStringGrid;
    TabItem1: TTabItem;
    Memo1: TMemo;
    fdm_Main: TFDMemTable;
    BindSourceDB_Main: TBindSourceDB;
    fdm_Detail: TFDMemTable;
    BindSourceDB_Detail: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToData_Detail: TLinkGridToDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure fdm_MainAfterOpen(DataSet: TDataSet);
    procedure fdm_DetailAfterOpen(DataSet: TDataSet);
    procedure fdm_DetailAfterPost(DataSet: TDataSet);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure btn_ClearDetailClick(Sender: TObject);
    procedure fdm_DetailBeforePost(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbRedClick(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure fdm_MainAfterInsert(DataSet: TDataSet);
    procedure btn_BaseBackClick(Sender: TObject);


  private
    FVouchObj : TSZHL_Vouch;
    FRdFlag   : Boolean;
    FQRCode   : string;
    FPosition : string;
    procedure setDefaulPosition(Value: string);
    procedure DecryptQRCode;
    function GetcWhCode: string;
    { Private declarations }
  public
    procedure InitData; override;
    property VouObj: TSZHL_Vouch read FVouchObj write FVouchObj;
    property Position: string read FPosition write setDefaulPosition;
    property RdFlag: Boolean read FRdFlag write FRdFlag;
    property QRCode: string read FQRCode write FQRCode;
    property cWhCode: string read GetcWhCode;
    { Public declarations }
  end;

var
  frm_RdVouch08: Tfrm_RdVouch08;

implementation

uses
UnitU8DM,uSZHLFMXEdit;

{$R *.fmx}


procedure Tfrm_RdVouch08.fdm_DetailAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch08.btn_BaseBackClick(Sender: TObject);
begin
  inherited;
  frm_RdVouch08 :=nil;
end;

procedure Tfrm_RdVouch08.btn_ClearDetailClick(Sender: TObject);
begin
  inherited;
  if fdm_Main.State in [dsInsert, dsEdit] then
    fdm_Main.Cancel;
  ClearChildCtrl(lyt_Main, true); // 清空&显示/隐藏
  fdm_Main.Append;
  fdm_Detail.EmptyDataSet;
end;

procedure Tfrm_RdVouch08.btn_SaveClick(Sender: TObject);
var
 strsqlmain ,strsqldetail : string;
begin
  inherited;
  strsqlmain := Format('Exec SZHL_UPDAREOTHRTINMIAN ''%s'',''%s'',''%s'' ',[fdm_main.FieldByName('cWhCode').AsString,fdm_main.FieldByName('cMemo').AsString,fdm_main.FieldByName('cMaker').AsString]);
  DM_Global.ExecuteSql(strsqlmain);
  fdm_detail.First;

  while not fdm_detail.Eof do
  begin
    strsqldetail := Format('Exec SZHL_UPDAREOTHRTINDETAIL ''%s'',''%s'',''%s'',''%s'' ',[fdm_detail.FieldByName('cInvCode').AsString,fdm_detail.FieldByName('iQuantity').AsString,fdm_detail.FieldByName('cBatch').AsString,fdm_detail.FieldByName('cposition').AsString]);
    DM_Global.ExecuteSql(strsqldetail);
    fdm_detail.Next;
  end;
  Showmessage('单据保存成功');
end;

procedure Tfrm_RdVouch08.cbRedClick(Sender: TObject);
begin
  if cbRed.IsChecked = false then
    VouObj.VouchArrow := vhRed
  else
    VouObj.VouchArrow := vhBlue;
end;

procedure Tfrm_RdVouch08.DecryptQRCode;
var
  cmd, strVouchsSql, strDesInvCode ,cBatch : string;
  fdm_Ref                         : TFDMemTable;
  SubQty, SubQtyRmt, SubQtyAmt  ,iQuantity   : double;
  SN , VouchId, VouchsId : Integer;
  label loopstart;
  label loopstart1;

  function GetSourceVouchKeyValue(): string;
  begin
    Result := GetValueByKey(FQRCode, FVouchObj.SrcKeyField);
  end;

begin
  FQRCode := edt_QRCode.Text;

  cmd := Trim(GetValueByKey(FQRCode, 'c'));

  if SameText(cmd, 'P') = True then
  begin
    Position := Trim(GetValueByKey(FQRCode, 'cPosition'));
    edt_QRCode.Text := '';
  end;

  if SameText(cmd, 'A') = True then
  begin
    SN := StrToInt(GetValueByKey(FQRCode, 'SN'));
//    VouchId := StrToInt(GetValueByKey(FQRCode, 'VouchId'));
//    VouchsId := StrToInt(GetValueByKey(FQRCode, 'VouchsId'));
    strDesInvCode := GetValueByKey(FQRCode, 'cInvCode');
    cBatch := GetValueByKey(FQRCode, 'cBatch');
    iQuantity := StrToFloat(GetValueByKey(FQRCode, 'iQuantity'));

    if (fdm_Detail.State in [dsEdit, dsInsert]) then
    begin
      fdm_Detail.Post;
    end;
    if fdm_Detail.Locate('cdefine33;cInvCode', VarArrayOf([SN,strDesInvCode]), [loPartialKey]) then       ////// 单次重复扫码 双判定
    begin
      showmessage('不允许重复扫码。');
      edt_QRCode.Text := '';
      Abort;
    end;

    if VouObj.VouchArrow = vhBlue then
    begin
      fdm_Detail.Append;
      fdm_Detail.FieldByName('cdefine33').Value := SN;
      fdm_Detail.FieldByName('iQuantity').Value := iQuantity;
      fdm_Detail.FieldByName('cInvCode').Value := strDesInvCode;
      fdm_Detail.FieldByName('cBatch').Value := cBatch;
      fdm_Detail.FieldByName('cPosition').Value := Position;
      fdm_Detail.Post;
    end;
    if VouObj.VouchArrow = vhRed then
    begin
      fdm_Detail.Append;
      fdm_Detail.FieldByName('cdefine33').Value := SN;
      fdm_Detail.FieldByName('iQuantity').Value := -1*iQuantity;
      fdm_Detail.FieldByName('cInvCode').Value := strDesInvCode;
      fdm_Detail.FieldByName('cBatch').Value := cBatch;
      fdm_Detail.FieldByName('cPosition').Value := Position;
      fdm_Detail.Post;
    end;

    edt_QRCode.Text := '';
  end;

end;

function Tfrm_RdVouch08.GetcWhCode: string;
begin
  Result := '';
  if (not fdm_Main.eof) or (fdm_Main.State in [dsEdit, dsInsert]) then
    Result := fdm_Main.FieldByName('cWhCode').AsString.Trim;
end;

procedure Tfrm_RdVouch08.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = vkF11 then
    edt_QRCode.Text := 'C=A;SN=10978;cPOID=0000000001;cCode=PR18020001;cInvCode=01-113-4003LR;Autoid=1000000001;cBatch=batch1;iQty=2';
end;

procedure Tfrm_RdVouch08.setDefaulPosition(Value: string);
begin
  FPosition := Value;
  txt_BaseTitle.Text := format('%s  P:%s', [VouObj.DesMainTableDef, Value])
end;

procedure Tfrm_RdVouch08.fdm_DetailAfterPost(DataSet: TDataSet);
begin
  inherited;
  RefreshData;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouch08.fdm_DetailBeforePost(DataSet: TDataSet);
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
      showmessage('当前存货有批次管理，请指定批次。');
      // exit;
    end;
  end
  else
    DataSet.FieldByName('cBatch').Value := ''; // 无批次管理清除批次。
end;

procedure Tfrm_RdVouch08.edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
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

//procedure Tfrm_RdVouch08.fdm_DetailBeforePost(DataSet: TDataSet);
//var
//strErrMsg: string;
//begin
//  inherited;
//  strErrMsg := DM_Global.CheckAllowEmptys(DataSet, VouObj.DesSubTableDef);
//  if strErrMsg <> '' then
//  begin
//    showmessage(strErrMsg);
//    Abort;
//  end;
//  if cWhCode <> '' then
//  begin
//    // showmessage('请选择仓库');
//    if DM_Global.CheckWareHousePos(cWhCode) = True then
//    begin
//      if DataSet.FieldByName('cposition').AsString = '' then
//      begin
//        showmessage('当前仓库有货位管理，请指定货位。');
//        // exit;
//      end;
//    end;
//  end;
//  if DM_Global.CheckInvBatch(DataSet.FieldByName('cInvCode').AsString) = True then
//  begin
//    if DataSet.FieldByName('cBatch').AsString = '' then
//    begin
//      showmessage('当前存货有批次管理，请指定批次。');
//      // exit;
//    end;
//  end
//  else
//    DataSet.FieldByName('cBatch').Value := ''; // 无批次管理清除批次。
//end;

procedure Tfrm_RdVouch08.fdm_MainAfterInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('dDate').Value := DateToStr(DATE());
  DataSet.FieldByName('cMaker').Value := PubVar_LoginInfo.UserName;
end;

procedure Tfrm_RdVouch08.fdm_MainAfterOpen(DataSet: TDataSet);
var
  strVouchsSql, strVouchsSql_sub: string;
begin
  inherited;

  // 明细表
  LinkGridToData_Detail.Columns.Clear;
  strVouchsSql := format('select *  from %s where %s=''%s''', [FVouchObj.DesSubTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  DM_Global.ExecSql(fdm_Detail, strVouchsSql);
end;

procedure Tfrm_RdVouch08.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  VKAutoShowMode := TVKAutoShowMode.DefinedBySystem;
  frm_RdVouch08 := nil;
end;

procedure Tfrm_RdVouch08.FormCreate(Sender: TObject);
begin
  inherited;
  FRdFlag := True; // 默认正数(兰字)单据
  ClearChildCtrl(lyt_Main, False); // 清楚控件内容
  TabControl1.ActiveTab := TabControl1.Tabs[0]; // 默认页签
end;

procedure Tfrm_RdVouch08.FormShow(Sender: TObject);
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

procedure Tfrm_RdVouch08.InitData;
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

