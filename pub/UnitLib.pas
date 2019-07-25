unit UnitLib;

interface

uses
  System.SysUtils, FMX.NumberBox, FMX.text, DateUtils, FMX.ListBox, System.Types,
  System.UITypes, FMX.Edit, System.IOUtils, StrUtils, FMX.Header, Data.DB, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, FMX.StdCtrls, FMX.Layouts, FMX.Controls,
  FMX.DateTimeCtrls, FMX.Types, FireDAC.Comp.Client, uSZHLFMXEdit, FMX.Objects,
  System.classes, FMX.Dialogs, System.Threading, FMX.Grid,
{$IFDEF MSWINDOWS} Windows, {$ENDIF} FMX.Forms;

type
  TVouchArrow = (vhBlue, vhRed);

  TSZHL_Vouch = class(TObject)
    ListTable, ListTableDef: string;
    DesMainKey, DesMainTable, DesMainTableDef, DesMainKeyField: string;
    DesSubKey, DesSubTable, DesSubCardTable, DesSubTableDef, DesSubKeyField, DesSubLinkSrcFeild, DesSubLinkMainFeild, DesSubQtyField: string;
    SrcTable, SrcTableDef, SrcKeyField, SrcLinkMainField, SrcLinkDesSubField: string;
    // SrcMainTable,SrcMainCodeField,SrcMainKeyField,SrcMainLinkSubField:string;
    SrcQtyField, SrcRmtQtyField, SrcQty_AmtField: string;
    VouchArrow: TVouchArrow;
  public
    function Prepared: Boolean;
    procedure btn1Click(Sender: TObject);
  end;

  TFrmField = class(TObject)
    TableName: string;
    DisplayControlClassName: string;
    FieldName: string;
  end;

  TVouchFrmLayConst = record
    const
      LabelSplitHeader = 5;
      LabelSplit = 2;
      HeightUnit = 32; // 25;  //行高
      EmptyRowHeightUnit = 5; // 行间隔
      labelWidthUnit = 60;
  end;

  TLoginInfo = record
    FLogined: Boolean;
    OperationId: string;
    UserID: string;
    UserName: string;
    PassWord: string;
    SaveName: Boolean;
  private
    procedure Setlogined(const Value: Boolean);
  public
    property logined: Boolean read Flogined write Setlogined;
  end;

  TQRCodeInfo = class
    cmd, VouchType, cInvCode, cBatch: string;
    Vouchid, VouchsId, AutoId: string;
    status: string;
    iQuantity: Double;
    Balance: Double;
  end;

function MinOfArray(const A: array of Double): Double;

function repeatStr(subStr: string; count: integer): string;

procedure ShowMessage_debug(const AMessage: string);

procedure getWareHouse(Sender: TForm; txtEdit: TEdit);

procedure getInventory(Sender: TForm; txtEdit: TEdit);

procedure getVendor(Sender: TForm; txtEdit: TEdit);

procedure getCustomer(Sender: TForm; txtEdit: TEdit);

procedure getDepartment(Sender: TForm; txtEdit: TEdit);

procedure getPerson(Sender: TForm; txtEdit: TEdit);

function GetMin_Number3(A, b, c: Double): Double;

function GetMin_Number2(A, b: Double): Double;

procedure getPostion(Sender: TForm; txtEdit: TEdit; cWhCode: string);

procedure ShowForm(TopForm: TForm; NewForm: TForm);

function GetValueByKey(aString: string; aKey: string): string;

function GetQRInfo_ByAutoid(aString: string): TQRCodeInfo;

function CheckWarehouse(pcWhCode: string; var fdm_warehouse: TFDMemTable; var pbWhPos: Boolean): Boolean;

function CheckPostion(var pcWhCode: string; pcPosCode: string; var fdm_Postion: TFDMemTable): Boolean;

procedure Delay(dwMilliseconds: DWORD);

function GetIniFileName: string;

procedure ClearChildCtrl(Layout: TControl; Shown: Boolean = True);

procedure AlignHeaders(aGrid: TStringGrid);

procedure CreateADCtrlDB(strTableDef: string; parentLay: TLayout; fdm_table: TFDMemTable; isFilter: Boolean = False);

procedure CreateADCtrl(strTableDef: string; parentLay: TLayout; fdm_table: TFDMemTable; bindSource: TBindSourceDB; isFilter: Boolean = False);

procedure SyncMemTableToLookupControl(layParent: TControl; fdm_table: TFDMemTable);

procedure FindSZHL(Sender: TFmxObject; fdm_table: TFDMemTable; strFieldName: string = '');

procedure LinkControlToStringField(Sender: TComponent; BindSourceDB1: TBindSourceDB; FieldName: string; Edit2: TComponent);

procedure LinkControlToDateField(Sender: TComponent; BindSourceDB1: TBindSourceDB; FieldName: string; DateControl: tdateedit);

procedure LinkComboBoxControlToStringField(Sender: TComponent; BindSourceDB1: TBindSourceDB; FieldName: string; CombBoxControl: TComboBox);

function GetFirstParentControl(Sender: TObject; strClassName: string): TFmxObject;

function Get_FirstParent_TSZHL_Edit(Sender: TObject): TSZHL_Edit;

function Get_FirstParent_TSZHL_ComboBox(Sender: TObject): TSZHL_ComboBox;

function Get_FirstParent_TForm(Sender: TObject): TForm;

function DrawSZHL_Edit(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: integer = 1): TSZHL_Edit;

function DrawSZHL_ComboBox(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: integer = 1): TSZHL_ComboBox;

function DrawSZHL_DateEdit(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: integer = 1): TSZHL_DateEdit;

function DrawSZHL_Label(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; LabelSplit1: Extended; strDefault: string = ''; ConditionPos: integer = 1): TSZHL_Label;

function DrawSZHL_NumberBox(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: integer = 1): TSZHL_NumberBox;

function GetColumnStyle(fdPara: TField): string;

function GetFieldInfoByFieldName(strTableName, strFieldName: string): TSZHL_FieldDict;

//function ComputerLocalIP: string;
// function GetFieldInfoByAutoId(intAutoid: Integer): TSZHL_FieldDict;

var
  PubVar_WebServiceUrl: string;
  PubVar_MiddleServer: string;
  PubVar_LoginInfo: TLoginInfo;
  // fdFieldInfo1: TSZHL_FieldDict;

const
  Const_AccNo = '1';
  VirtualPath = '/SZHLBarCode';
  Const_Url_Def_Login: string = VirtualPath + '/Login.asmx?wsdl';
  Const_Url_Def_Arrival: string = VirtualPath + '/ArrivalVouchService.asmx?wsdl';
  Const_Url_Def_BaseData: string = VirtualPath + '/BaseDataService.asmx?wsdl';
  Const_Url_Def_PurchaseIn: string = VirtualPath + '/PurchaseInService.asmx?wsdl';
  Const_Url_Def_ProduceOrderPart: string = VirtualPath + '/ProduceOrderService.asmx?wsdl';
  Const_Url_Def_MaterialOut: string = VirtualPath + '/MaterialOutService.asmx?wsdl';
  Const_Url_Def_ProductIn: string = VirtualPath + '/ProductInService.asmx?wsdl';
  Const_Url_Def_OutOrder: string = VirtualPath + '/OMOrderService.asmx?wsdl';
  Const_Url_Def_CheckVouch: string = VirtualPath + '/CheckVouchService.asmx?wsdl';
  Const_Url_Def_SaleOut: string = VirtualPath + '/SaleOutService.asmx?wsdl';

implementation

uses
  MainForm, UnitU8DM, BaseForm, AboutForm, InventoryForm, StockForm, VendorForm,
  CustomerForm, PositionForm, WareHouseForm, DeptForm, personForm, LoginForm;
//
//function ComputerLocalIP: string;
//var
//  ch: array[1..32] of char;
//  wsData: TWSAData;
//  myHost: PHostEnt;
//  i: integer;
//begin
//  Result := '';
//  if WSAstartup(2, wsData) <> 0 then
//    Exit; // can’t start winsock
//  try
//    if GetHostName(@ch[1], 32) <> 0 then
//      Exit; // getHostName failed
//  except
//    Exit;
//  end;
//  myHost := GetHostByName(@ch[1]); // GetHostName error
//  if myHost = nil then
//    exit;
//  for i := 1 to 4 do
//  begin
//    Result := Result + IntToStr(Ord(myHost.h_addr^[i - 1]));
//    if i < 4 then
//      Result := Result + '.';
//  end;
//end;

//获取本机IP的MAC地址

//function GetMacAddress: string;
//var
//  Lib: Cardinal;
//  Func: function(GUID: PGUID): Longint; stdcall;
//  GUID1, GUID2: TGUID;
//begin
//  Result := '';
//  Lib := LoadLibrary('rpcrt4.dll');
//  if Lib <> 0 then
//  begin
//    if Win32Platform <> VER_PLATFORM_WIN32_NT then
//      @Func := GetProcAddress(Lib, 'UuidCreate')
//    else
//      @Func := GetProcAddress(Lib, 'UuidCreateSequential');
//    if Assigned(Func) then
//    begin
//      if (Func(@GUID1) = 0) and (Func(@GUID2) = 0) and (GUID1.D4[2] = GUID2.D4[2]) and (GUID1.D4[3] = GUID2.D4[3]) and (GUID1.D4[4] = GUID2.D4[4]) and (GUID1.D4[5] = GUID2.D4[5]) and (GUID1.D4[6] = GUID2.D4[6]) and (GUID1.D4[7] = GUID2.D4[7]) then
//      begin
//        Result := IntToHex(GUID1.D4[2], 2) + '-' + IntToHex(GUID1.D4[3], 2) + '-' + IntToHex(GUID1.D4[4], 2) + '-' + IntToHex(GUID1.D4[5], 2) + '-' + IntToHex(GUID1.D4[6], 2) + '-' + IntToHex(GUID1.D4[7], 2);
//      end;
//    end;
//    FreeLibrary(Lib);
//  end;
//end;

//取本机的计算机名
{ ComputerName }

//function ComputerName: string;
//var
//  FStr: PChar;
//  FSize: Cardinal;
//begin
//  FSize := 255;
//  GetMem(FStr, FSize);
//  Windows.GetComputerName(FStr, FSize);
//  Result := FStr;
//  FreeMem(FStr);
//end;

//取Windows登录用户名
{ WinUserName }

//function WinUserName: string;
//var
//  FStr: PChar;
//  FSize: Cardinal;
//begin
//  FSize := 255;
//  GetMem(FStr, FSize);
//  GetUserName(FStr, FSize);
//  Result := FStr;
//  FreeMem(FStr);
//end;

function GetColumnStyle(fdPara: TField): string;
begin

  if fdPara is TStringField then
  begin
    Result := 'StringColumn';
  end
  else if fdPara is TDateField then
  begin
    Result := 'DateColumn';
  end
  else if fdPara is TBooleanField then
  begin
    Result := 'CheckColumn';
  end
  else if fdPara is TFloatField then
  begin
    Result := 'FloatColumn';
  end
  else if fdPara is TIntegerField then
  begin
    Result := 'IntegerColumn';
  end
  else if fdPara is TBCDField then
  begin
    Result := 'FloatColumn';
  end
  else if fdPara is TFMTBCDField then
  begin
    Result := 'FloatColumn';
  end
  else if True then
  begin
    Result := 'StringColumn';
  end;
end;

function repeatStr(subStr: string; count: integer): string;
var
  i: integer;
begin
  for i := 1 to count do
    Result := Result + subStr;
end;

procedure AlignHeaders(aGrid: TStringGrid);
var
  tmpInt: integer;
  Header: THeader;
begin
  // aGrid.StyledSettings := [];
  Header := THeader(aGrid.FindStyleResource('header'));
  if Assigned(Header) then
  begin
    for tmpInt := 0 to Header.count - 1 do
    begin
      Header.Items[tmpInt].TextAlign := TTextAlign(0);
      Header.Items[tmpInt].StyledSettings := [];
      with Header.Items[tmpInt].Font do
      begin
        Size := 12;
        Style := [TFontStyle.fsBold];
      end;
    end;
    Header.Height := 28;
  end;
  aGrid.RealignContent;
end;

function GetIniFileName: string;
begin
  Result := System.IOUtils.TPath.GetHomePath + '\U8AndServer.ini'
end;

procedure Delay(dwMilliseconds: DWORD);
var
  iStart, iStop: DWORD;
begin
{$IFDEF ANDROID}
  iStart := TThread.GetTickCount;
  repeat
    iStop := TThread.GetTickCount;
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
{$ELSE}
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
{$ENDIF}
end;

function GetValueByKey(aString: string; aKey: string): string;
var
  i: integer;
  aList: TStringList;
begin
  Result := '';

  aList := TStringList.Create;
  with aList do
  try
    aList.Delimiter := ';';
    aList.DelimitedText := aString.Trim;
    for i := 0 to aList.count - 1 do
    begin
      if SameText(aList.Names[i], aKey.Trim) = True then
      begin
        Result := Trim(aList.ValueFromIndex[i]);
        Break;
      end;
    end;
  finally
    free
  end;
end;

function GetQRInfo_ByAutoid(aString: string): TQRCodeInfo;
var
  i: integer;
  aList: TStringList;
  QRInfo: TQRCodeInfo;
  strSQL: string;
  fdm1: TFDMemTable;
begin
  aList := TStringList.Create;
  QRInfo := TQRCodeInfo.Create;

  with aList do
  try
    aList.Delimiter := ';';
    aList.DelimitedText := aString.Trim;
    for i := 0 to aList.count - 1 do
    begin
      if SameText(aList.Names[i], 'vouchsid') = True then
        QRInfo.VouchsId := Trim(aList.ValueFromIndex[i]);
    end;
    for i := 0 to aList.count - 1 do
    begin
      if SameText(aList.Names[i], 'c') = True then
        QRInfo.cmd := Trim(aList.ValueFromIndex[i]);
//      if SameText(aList.Names[i], 'cInvCode') = True then
//        QRInfo.InvCode := Trim(aList.ValueFromIndex[i]);
//      if SameText(aList.Names[i], 'cBatch') = True then
//        QRInfo.BatchNo := Trim(aList.ValueFromIndex[i]);

      if SameText(aList.Names[i], 'SN') = True then
      begin
        try
          QRInfo.AutoId := Trim(aList.ValueFromIndex[i]);
          fdm1 := TFDMemTable.Create(nil);
          strSQL := format('select * from SZHL_QRCode where autoid = ''%s''', [QRInfo.AutoId]);

          U8DM.ExecSql(fdm1, strSQL);
          if fdm1.RecordCount = 0 then
          begin
            strSQL := format('select * from SZHL_QRCode where sn = ''%s'' and vouchsid=''%s''', [QRInfo.AutoId, QRInfo.VouchsId]);
            U8DM.ExecSql(fdm1, strSQL);
            if fdm1.RecordCount = 0 then
//            U8DM.ExecSql(fdm1, strSQL);
              ShowMessage(Format('未找到条码信息%s', [QRInfo.AutoId]))
            else
            begin
              QRInfo.cInvCode := fdm1.FieldByName('cInvCode').AsString.Trim;
              QRInfo.status := fdm1.FieldByName('status').AsString.Trim;
              QRInfo.cBatch := fdm1.FieldByName('cBatch').AsString.Trim;
              QRInfo.iQuantity := fdm1.FieldByName('iQuantity').AsFloat;
              QRInfo.Balance := fdm1.FieldByName('Balance').AsFloat;
              QRInfo.Vouchid := fdm1.FieldByName('Vouchid').AsString.Trim;
              QRInfo.Vouchsid := fdm1.FieldByName('Vouchsid').AsString.Trim;
              QRInfo.VouchType := fdm1.FieldByName('VouchType').AsString.Trim;
              break;
            end;
          end
          else
          begin
            QRInfo.cInvCode := fdm1.FieldByName('cInvCode').AsString.Trim;
            QRInfo.status := fdm1.FieldByName('status').AsString.Trim;
            QRInfo.cBatch := fdm1.FieldByName('cBatch').AsString.Trim;
            QRInfo.iQuantity := fdm1.FieldByName('iQuantity').AsFloat;
            QRInfo.Balance := fdm1.FieldByName('Balance').AsFloat;
            QRInfo.Vouchid := fdm1.FieldByName('Vouchid').AsString.Trim;
            QRInfo.Vouchsid := fdm1.FieldByName('Vouchsid').AsString.Trim;
            QRInfo.VouchType := fdm1.FieldByName('VouchType').AsString.Trim;
          end;
        finally
          FreeAndNil(fdm1);
        end;

      end;

//      if SameText(aList.Names[i], 'iQuantity') = True then
//        QRInfo.Qty := StrToFloat(aList.ValueFromIndex[i].Trim);
    end;
//    QRInfo.dataOk := True;
//    if QRInfo.cmd.Trim.Length <= 0 then
//      QRInfo.dataOk := False;
//    if QRInfo.SN.Trim.Length <= 0 then
//      QRInfo.dataOk := False;
//    if QRInfo.InvCode.Trim.Length <= 0 then
//      QRInfo.dataOk := False;
//    if QRInfo.BatchNo.Trim.Length <= 0 then
//      QRInfo.dataOk := False;
//    if QRInfo.Qty = 0 then
//      QRInfo.dataOk := False;

    Result := QRInfo;
  finally
    free
  end;
end;

function CheckWarehouse(pcWhCode: string; var fdm_warehouse: TFDMemTable; var pbWhPos: Boolean): Boolean;
var
  strSQL: string;
begin
  Result := True;
  if fdm_warehouse = nil then
    fdm_warehouse := TFDMemTable.Create(nil);
  strSQL := format('select * from warehouse where cwhcode = ''%s''', [pcWhCode]);
  U8DM.ExecSql(fdm_warehouse, strSQL);
  if fdm_warehouse.RecordCount <= 0 then
  begin
    Result := False;
    ShowMessage(format('当前账套没有编码为%s的仓库档案.', [pcWhCode]));
    Abort;
  end
  else
    pbWhPos := fdm_warehouse.FieldByName('bWhPos').AsBoolean
end;

function CheckPostion(var pcWhCode: string; pcPosCode: string; var fdm_Postion: TFDMemTable): Boolean;
var
  strSQL: string;
begin

  Result := True;
  pcWhCode := pcWhCode.Trim;
  pcPosCode := pcPosCode.Trim;

  if pcWhCode.IsEmpty then
    strSQL := format('select * from position  where  cPosCode = ''%s''', [pcPosCode])
  else
    strSQL := format('select * from position  where cwhcode=''%'' and cPosCode = ''%s''', [pcWhCode, pcWhCode]);

  if fdm_Postion = nil then
    fdm_Postion := TFDMemTable.Create(nil);
  U8DM.ExecSql(fdm_Postion, strSQL);
  if fdm_Postion.RecordCount <= 0 then
  begin
    Result := False;
    if pcWhCode.IsEmpty then
      ShowMessage(format('没有编码为%s的货位档案.', [pcWhCode]))
    else
      ShowMessage(format('当前仓库%s没有编码为%s的货位档案.', [pcWhCode, pcWhCode]));
    Abort;
  end
  else
  begin
    pcWhCode := fdm_Postion.FieldByName('cWhCode').Value;
  end;

end;

procedure ShowForm(TopForm: TForm; NewForm: TForm);
begin
  TBaseFrm(NewForm).TopForm := TopForm;
  TBaseFrm(NewForm).Parent := TopForm;
  TBaseFrm(NewForm).Width := TopForm.Width;
  TBaseFrm(NewForm).Height := TopForm.Height;
  NewForm.Show;
end;

procedure LinkControlToStringField(Sender: TComponent; BindSourceDB1: TBindSourceDB; FieldName: string; Edit2: TComponent);
var
  l1: TLinkControlToField;
begin
  l1 := TLinkControlToField.Create(Sender);
  // l1.Category = 'Quick Bindings';
  // l1.Track:=false;
  l1.DataSource := BindSourceDB1;
  l1.FieldName := FieldName;
  l1.Control := Edit2;
  l1.Active := True;
end;

procedure LinkControlToDateField(Sender: TComponent; BindSourceDB1: TBindSourceDB; FieldName: string; DateControl: tdateedit);
var
  l1: TLinkControlToField;
begin
  l1 := TLinkControlToField.Create(Sender);
  // l1.Category = 'Quick Bindings';
  // l1.Track:=false;
  l1.DataSource := BindSourceDB1;
  l1.FieldName := FieldName;
  l1.Control := DateControl;
  l1.Active := True;
end;

procedure LinkComboBoxControlToStringField(Sender: TComponent; BindSourceDB1: TBindSourceDB; FieldName: string; CombBoxControl: TComboBox);
var
  l1: TLinkControlToField;
begin
  l1 := TLinkControlToField.Create(Sender);
  // l1.Category = 'Quick Bindings';
  // l1.Track:=false;
  l1.DataSource := BindSourceDB1;
  l1.FieldName := FieldName;
  l1.Control := CombBoxControl;
  l1.Active := True;
end;

function DrawSZHL_Edit(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: integer = 1): TSZHL_Edit;
begin
  Result := TSZHL_Edit.Create(nil);
  with Result do
  begin
    FieldDict.FDMDataSet := fdm_table;
    SetValueByDictMemTalbe(FDM_Dict1);
    FieldDict.ConditionPos := ConditionPos;

    Parent := lyLine;
    Position.X := 5 + xpos;
    Width := FieldDict.Width;
    xpos := Position.X + Width;
    Height := lyLine.Height;
    // Tag := U8DM.FDM_SZHL_ItmDef.FieldByName('autoid').AsInteger;
    Anchors := [TAnchorKind.akLeft];
    // TextSettings.HorzAlign := TTextAlign.Leading;
    // StyledSettings := [];
    // Font.Family := '宋体';       //字体设定
    // Font.Size := 12;
    // FDM_Dict1.FieldByName(''
    Result.ReadOnly := not FieldDict.Editing;
  end;

end;

function DrawSZHL_ComboBox(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: integer = 1): TSZHL_ComboBox;
var
  i: integer;
  fdm_ComboBox: TFDMemTable;
  strValue, strSQL: string;
  DefaultValue: string;
begin
  Result := TSZHL_ComboBox.Create(nil);
  with Result do
  begin
    FieldDict.FDMDataSet := fdm_table;
    SetValueByDictMemTalbe(FDM_Dict1);
    FieldDict.ConditionPos := ConditionPos;
    Parent := lyLine;
    Position.X := 0 + xpos;

    Width := FieldDict.Width;
    xpos := Position.X + Width;
    Height := lyLine.Height;
    // Tag := U8DM.FDM_SZHL_ItmDef.FieldByName('autoid').AsInteger;
    Anchors := [TAnchorKind.akLeft];
    //
    // TextSettings.HorzAlign := TTextAlign.Leading;
    // StyledSettings := [];
    // TextSettings.Font.Family := '宋体';
    // TextSettings.Font.Size := 12;
    // seq := seq1;

    if SameText(Result.FieldDict.Ref_Table, 'RdStyleIn') then
    begin
      strSQL := 'select ''[''+cRdCode+'']''+cRdName DisplayValue,cRdCode Value from rd_style where bRdFlag=1 and bRdEnd=1';
    end;
    if SameText(Result.FieldDict.Ref_Table, 'RdStyleOut') then
    begin
      strSQL := 'select ''[''+cRdCode+'']''+cRdName DisplayValue,cRdCode Value from rd_style where bRdFlag=0 and bRdEnd=1';
    end;
    if SameText(Result.FieldDict.Ref_Table, 'WareHouse') then
    begin
      strSQL := 'select ''[''+cWhCode+'']''+cWhName DisplayValue,cWhCode value from WareHouse';
    end;
    if SameText(Result.FieldDict.Ref_Table, 'Vendor') then
    begin
      strSQL := 'select ''[''+cVenCode+'']''+cVenName DisplayValue,cVenCode value from Vendor';
    end;
    if SameText(Result.FieldDict.Ref_Table, 'bredvouch') then // 采购入库红蓝判断
    begin
      strSQL := ' select ''蓝单(正)'' DisplayValue,0 as Value union select ''红单(负)'',1 ';
    end;
    if SameText(Result.FieldDict.Ref_Table, 'bReturnFlag') then
    // 销售出库单单据红蓝判断标志 关联发货退货单主表字段
    begin
      strSQL := ' select ''蓝单(正)'' DisplayValue,0 as Value union select ''红单(负)'',1 ';
    end;
    if SameText(Result.FieldDict.Ref_Table, 'bRdFlagOut') then
    begin
      strSQL := ' select ''蓝单(正)'' DisplayValue,0 as Value union select ''红单(负)'',1 ';
    end;
    if strSQL = '' then
      Exit;

    fdm_ComboBox := TFDMemTable.Create(nil);
    try
      Result.Clear;
      Result.RefValue.Clear;
      U8DM.ExecSql(fdm_ComboBox, strSQL);
      while not fdm_ComboBox.Eof do
      begin
        Result.Items.Add(fdm_ComboBox.FieldByName('DisplayValue').AsString);
        Result.RefValue.Add(fdm_ComboBox.FieldByName('Value').AsString);
        fdm_ComboBox.Next;
      end;

    finally
      fdm_ComboBox.free;
    end;
    if fdm_table.Active then
    begin
      strValue := fdm_table.FieldByName(Result.FieldDict.FieldName).AsString;
      Result.ItemIndex := Result.RefValue.IndexOf(strValue);
    end;
    // showmessage(inttostr(Result.Items.Count));  //调试
    if U8DM.FDM_SZHL_ItmDef.FieldByName('DefaultValue').AsString.Trim <> '' then
    // 设置默认仓库，默认类别
      Result.ItemIndex := U8DM.FDM_SZHL_ItmDef.FieldByName('DefaultValue').Value;
    // for i := 0 to fdm_table.FieldCount - 1 do
    // showmessage(fdm_table.Fields[i].FieldName);

  end;

end;

function DrawSZHL_Label(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; LabelSplit1: Extended; strDefault: string = ''; ConditionPos: integer = 1): TSZHL_Label;
var
  l1: TSZHL_Label;
  intCount: integer;
begin

  l1 := TSZHL_Label.Create(nil);
  l1.SetValueByDictMemTalbe(FDM_Dict1);
  l1.FieldDict.FDMDataSet := fdm_table;
  l1.FieldDict.ConditionPos := ConditionPos;
  // if isSencondCondition = True then
  // l1.FieldDict.posY = 2;

  if Length(Trim(strDefault)) > 0 then
    l1.text := strDefault
  else if ConditionPos = 2 then
  begin
    intCount := Trunc(l1.Width) div 20;
    l1.text := repeatStr(' ', intCount) + '至'
  end
  else
    l1.text := l1.FieldDict.FieldDef + ':';
  l1.Parent := lyLine;
  l1.Position.X := LabelSplit1 + xpos;
  l1.Width := l1.FieldDict.LabelWidth;
  // ShowMessage('Draw '+l1.FieldDict.FieldName+' label xpos='+l1.Position.X .ToString+' width='+l1.Width.ToString);
  xpos := l1.Position.X + l1.Width;
  l1.Height := lyLine.Height;
  l1.Anchors := [TAnchorKind.akLeft];
  // if ConditionPos=2 then
  // l1.Align := tAlignlayout.Client;
  // l1.TextSettings.VertAlign := TTextAlign.Trailing;
  // l1.StyledSettings := [];
  // l1.TextSettings.Font.Family := 'Times New Roman';
  // l1.TextSettings.Font.Size := 4;
  if l1.FieldDict.AllowEmpty = False then
  begin
    l1.TextSettings.FontColor := TAlphaColorRec.Red;
  end;
  // l1.seq := seq1;

  Result := l1;
end;

function DrawSZHL_NumberBox(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: integer = 1): TSZHL_NumberBox;
begin
  Result := TSZHL_NumberBox.Create(nil);
  with Result do
  begin
    FieldDict.FDMDataSet := fdm_table;
    SetValueByDictMemTalbe(FDM_Dict1);
    FieldDict.ConditionPos := ConditionPos;

    Parent := lyLine;
    Position.X := 5 + xpos;
    Width := FieldDict.Width;
    xpos := Position.X + Width;
    Height := lyLine.Height;
    // Font.Family := '宋体';       //字体设定
    // Font.Size := 12;

    // Tag := U8DM.FDM_SZHL_ItmDef.FieldByName('autoid').AsInteger;
    Anchors := [TAnchorKind.akLeft];

//    if sametext(FieldDict.FieldName,'iquantity') then
//    begin
//    showmessage(    IfThen(FieldDict.Editing,'True','False'));
////      showmessage(format('autoid:%s,editing:%s ',[FieldDict.Autoid,FieldDict.Editing.ToString(True)]));
//    end;

    Result.ReadOnly := not FieldDict.Editing;
    // TextSettings.HorzAlign := TTextAlign.Leading;
    // StyledSettings := [];
    // TextSettings.Font.Family := '宋体';
    // TextSettings.Font.Size := 12;
    // seq := seq1;
  end;
end;

function DrawSZHL_DateEdit(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: integer = 1): TSZHL_DateEdit;
begin
  Result := TSZHL_DateEdit.Create(nil);
  with Result do
  begin
    FieldDict.FDMDataSet := fdm_table;
    SetValueByDictMemTalbe(FDM_Dict1);
    FieldDict.ConditionPos := ConditionPos;
    Parent := lyLine;
    Position.X := 0 + xpos;
    Width := FieldDict.Width;
    xpos := Position.X + Width;
    format := 'YYYY-MM-DD';
    Height := lyLine.Height;
    Anchors := [TAnchorKind.akLeft];
    TextSettings.HorzAlign := TTextAlign.Leading;
    // StyledSettings := [];
    // TextSettings.Font.Family := '宋体';
    // TextSettings.Font.Size := 12;
    // seq := seq1;
    Result.ReadOnly := not FieldDict.Editing;
  end;

  if ConditionPos = 1 then
  begin
    if Result.FieldDict.isFilter = True then
    begin

      Result.Date := encodedate(yearof(now), monthof(now), dayof(now));
      // strtodate('2018-01-01', dateFmtSet); 显示当前日期
    end;
  end;
  Result.Date := encodedate(yearof(now), monthof(now), dayof(now));
  // strtodate('2018-01-01', dateFmtSet);  显示当前日期
end;

function Get_FirstParent_TSZHL_Edit(Sender: TObject): TSZHL_Edit;
var
  iCompe: TFmxObject;
begin
  Result := nil;
  if (Sender is TFmxObject) then
  begin
    iCompe := Sender as TFmxObject;
    while True do
    begin
      if iCompe is TSZHL_Edit then
      begin
        Result := (iCompe as TSZHL_Edit);
        Exit;
      end;
      iCompe := iCompe.Parent;
    end;
  end;
end;

// function Get_cVenCode_TSZHL_Edit(Sender: TObject): TSZHL_Edit;
// var
// iCompe: TFmxObject;
// begin
// Result := nil;
// if (Sender is TFmxObject) then
// begin
// iCompe := Sender as TFmxObject;
// while True do
// begin
// if iCompe is TSZHL_Edit then
// begin
// if (iCompe as TSZHL_Edit).FieldDict.Lookup_Table='Vendor' and (iCompe as TSZHL_Edit).FieldDict.FieldName='cVenCode' then
//
// Result := (iCompe as TSZHL_Edit);
// Exit;
// end;
// iCompe := iCompe.Parent;
// end;
// end;
// end;
function Get_FirstParent_TForm(Sender: TObject): TForm;
var
  iCompe: TFmxObject;
begin
  Result := nil;
  if (Sender is TFmxObject) then
  begin
    iCompe := Sender as TFmxObject;
    while True do
    begin
      if iCompe is TForm then
      begin
        Result := (iCompe as TForm);
        Exit;
      end;
      iCompe := iCompe.Parent;
    end;
  end;
end;

function Get_FirstParent_TSZHL_ComboBox(Sender: TObject): TSZHL_ComboBox;
var
  iCompe: TFmxObject;
begin
  Result := nil;
  if (Sender is TFmxObject) then
  begin
    iCompe := Sender as TFmxObject;
    while True do
    begin
      if iCompe is TSZHL_ComboBox then
      begin
        Result := (iCompe as TSZHL_ComboBox);
        Exit;
      end;
      iCompe := iCompe.Parent;
    end;
  end;
end;

procedure CreateADCtrl(strTableDef: string; parentLay: TLayout; fdm_table: TFDMemTable; bindSource: TBindSourceDB; isFilter: Boolean = False);
// 根据AD动态显示字段标题（label)及控件,并绑定FDMemTable
var
  strTableId, strTableName, curFieldname: string;
  i: integer;
  lyLine: TLayout;
  xpos, yPos, LabelSplit1: Extended;
  ConditionPos: integer;
  tsEdt: TSZHL_Edit;
  dateEdtControl: TSZHL_DateEdit;
  tsNumberBox: TSZHL_NumberBox;
  tsb1: TSearchEditButton;
  tscb: TSZHL_ComboBox;
  isSencondCondition: Boolean; // 区间条件第2栏目标志

  function GetNewLayWithBlankRow(lay1: TLayout; PreEmptyRow: Boolean = True): TLayout;
  var
    emptyRowlay: TLayout;
  begin
    if PreEmptyRow = True then
    begin
      emptyRowlay := TLayout.Create(parentLay);
      emptyRowlay.Parent := parentLay;
      emptyRowlay.Height := TVouchFrmLayConst.EmptyRowHeightUnit;
      emptyRowlay.Width := lay1.Width;
      emptyRowlay.Position.Y := yPos;
      yPos := yPos + TVouchFrmLayConst.EmptyRowHeightUnit;
    end;

    Result := TLayout.Create(parentLay);
    Result.Parent := parentLay;
    Result.Height := TVouchFrmLayConst.HeightUnit;
    Result.Width := lay1.Width;
    Result.Position.Y := yPos;
    yPos := yPos + TVouchFrmLayConst.HeightUnit;
  end;

begin
  if not U8DM.SetADTableByDef(strTableDef) then
    Exit;
  // if U8DM.FDM_SZHL_ItmDef.RecordCount = 0 then
  // Exit;
  strTableName := U8DM.FDM_SZHL_TableDef.FieldByName('Name').AsString.Trim;
  strTableId := U8DM.FDM_SZHL_TableDef.FieldByName('tableid').AsString.Trim;
  xpos := 0;
  yPos := 0;
  isSencondCondition := False;

  U8DM.FDM_SZHL_ItmDef.Filtered := False;

  if isFilter = True then
    U8DM.FDM_SZHL_ItmDef.Filter := 'iFilterVisible=True and isFilter=True'
  else
    U8DM.FDM_SZHL_ItmDef.Filter := 'iVisible=True'; // or isFilter=True';
  U8DM.FDM_SZHL_ItmDef.Filter := U8DM.FDM_SZHL_ItmDef.Filter + ' and tableid=' + strTableId;
  U8DM.FDM_SZHL_ItmDef.Filtered := True;

  U8DM.FDM_SZHL_ItmDef.FindFirst;
  while U8DM.FDM_SZHL_ItmDef.Found do
  begin

    // if U8DM.FDM_SZHL_ItmDef.FieldByName('iVisible').AsBoolean = False then
    // begin
    // U8DM.FDM_SZHL_ItmDef.Next;
    // Continue;
    // end;
    curFieldname := U8DM.FDM_SZHL_ItmDef.FieldByName('FieldName').AsString;
    if fdm_table.Active = True then
      if ((fdm_table.Fields.FindField(curFieldname) = nil) and (U8DM.FDM_SZHL_ItmDef.FieldByName('FieldKind').AsString.ToLower.Equals('data') = True)) then
      begin
        U8DM.FDM_SZHL_ItmDef.FindNext;
        Continue;
      end;

    if yPos = 0 then
    begin
      lyLine := GetNewLayWithBlankRow(parentLay);
    end;

    // 计算当前控件组合位置   xPos
    // 如果计算现有X坐标+将要画的控件宽度大于屏幕宽度
    if (U8DM.FDM_SZHL_ItmDef.FieldByName('isBetween').AsBoolean = False) then
      if xpos + U8DM.FDM_SZHL_ItmDef.FieldByName('Width').AsInteger + TVouchFrmLayConst.LabelSplitHeader + U8DM.FDM_SZHL_ItmDef.FieldByName('LabelWidth').AsInteger > parentLay.Width then
      begin
        xpos := 0;
        lyLine := GetNewLayWithBlankRow(parentLay);
      end;

    if (U8DM.FDM_SZHL_ItmDef.FieldByName('isBetween').AsBoolean = True) then
    begin
      if (isSencondCondition = False) and (isFilter = True) then
      begin
        if xpos + U8DM.FDM_SZHL_ItmDef.FieldByName('Width').AsInteger * 2 + TVouchFrmLayConst.LabelSplit * 2 + U8DM.FDM_SZHL_ItmDef.FieldByName('LabelWidth').AsInteger * 2 > parentLay.Width then
        begin
          xpos := 0;
          lyLine := GetNewLayWithBlankRow(parentLay);
        end;
      end;

    end;

    if xpos = 0 then // 第一个控件caption前面留的距离 与后面标题离左面的距离不一样，可以分隔开，
    begin
      LabelSplit1 := TVouchFrmLayConst.LabelSplitHeader;
    end
    else
    begin
      LabelSplit1 := TVouchFrmLayConst.LabelSplit;
    end;

    if isFilter then
      if isSencondCondition = True then
        ConditionPos := 2
      else
        ConditionPos := 1
    else
      ConditionPos := 1;

    DrawSZHL_Label(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, LabelSplit1, '', ConditionPos);

    if U8DM.FDM_SZHL_ItmDef.FieldByName('FieldKind').AsString.ToLower.Equals('data') then
    begin
      if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'String') = True then // 根据类型画控件，字符型对应TEdit
      begin
        if (SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('EditStyle').AsString, 'ComboBox') = True) then
        begin
          tscb := DrawSZHL_ComboBox(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
          tscb.OnChange := U8DM.cbb_EvenChange;

          // if not isFilter then // 过滤条件下fdm_table可能没打开，所以得放在前面
          // if fdm_table.FieldDefs.Find(tsEdt.FieldDict.FieldName) <> nil then
          // LinkComboBoxControlToStringField(parentLay, bindSource, tscb.FieldDict.FieldName, tscb);
        end;
        if (SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('EditStyle').AsString, '') = True) then
        begin
          tsEdt := DrawSZHL_Edit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
          if not isFilter then // 过滤条件下fdm_table可能没打开，所以得放在前面
            if fdm_table.FieldDefs.Find(tsEdt.FieldDict.FieldName) <> nil then
              LinkControlToStringField(parentLay, bindSource, tsEdt.FieldDict.FieldName, tsEdt);
        end;

        if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('EditStyle').AsString, 'Ref') = True then
        begin
          tsEdt := DrawSZHL_Edit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
          tsb1 := TSearchEditButton.Create(nil);
          tsb1.Parent := tsEdt;
          tsb1.OnClick := U8DM.btnSrh_EvenClick;

          if not isFilter then // 过滤条件下fdm_table可能没打开，所以得放在前面
            if fdm_table.FieldDefs.Find(tsEdt.FieldDict.FieldName) <> nil then
              LinkControlToStringField(parentLay, bindSource, tsEdt.FieldDict.FieldName, tsEdt);
        end;

      end;
      if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'float') = True then // 根据类型画控件，日期型对应TDateEdit
      begin
        tsNumberBox := DrawSZHL_NumberBox(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
//        tsNumberBox.ValueType := TNumValueType.float;
//        if SameText(tsNumberBox.FieldDict.FieldName, 'iQuantity') = True then
//          tsNumberBox.ReadOnly := False;
        //update SZHL_ItmDef set editing=1 WHERE FieldName='IQUANTITY'  AND TableId IN (SELECT TableId FROM SZHL_TableDef WHERE Name='SZHL_QRCode')
        if not isFilter then // 过滤条件下fdm_table可能没打开，所以得放在前面
          if fdm_table.FieldDefs.Find(tsNumberBox.FieldDict.FieldName) <> nil then // 数据字典当前行，数据集中也找到此列，才关联
            LinkControlToStringField(parentLay, bindSource, tsNumberBox.FieldDict.FieldName, tsNumberBox);

      end;
      if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'int') = True then // 根据类型画控件，日期型对应TDateEdit
      begin
        tsNumberBox := DrawSZHL_NumberBox(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
//        tsNumberBox.ValueType := TNumValueType.Integer;
      end;
      if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'date') = True then // 根据类型画控件，日期型对应TDateEdit
      begin
        dateEdtControl := DrawSZHL_DateEdit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
        //
        if not isFilter then // 过滤条件下fdm_table可能没打开，所以得放在前面
          if fdm_table.FieldDefs.Find(dateEdtControl.FieldDict.FieldName) <> nil then // 数据字典当前行，数据集中也找到此列，才关联
            LinkControlToDateField(parentLay, bindSource, dateEdtControl.FieldDict.FieldName, dateEdtControl);

        if isSencondCondition = True then
          isSencondCondition := False
        else if (U8DM.FDM_SZHL_ItmDef.FieldByName('isBetween').AsBoolean = True) and (isFilter = True) then
        begin
          isSencondCondition := True;
          Continue
        end;
      end;
    end;
    if U8DM.FDM_SZHL_ItmDef.FieldByName('FieldKind').AsString.ToLower.Equals('lookup') then
    begin
      tsEdt := DrawSZHL_Edit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
    end;
    U8DM.FDM_SZHL_ItmDef.FindNext;

  end;
  // end;
  U8DM.FDM_SZHL_ItmDef.Filtered := False;
  U8DM.FDM_SZHL_ItmDef.Filter := '';
end;

procedure SyncMemTableToLookupControl(layParent: TControl; fdm_table: TFDMemTable);
begin
  FindSZHL(layParent, fdm_table);
end;

procedure FindSZHL(Sender: TFmxObject; fdm_table: TFDMemTable; strFieldName: string = '');
var
  i: integer;
  ChildObject: TFmxObject;
  SZHL_ComboBox: TSZHL_ComboBox;
  SZHL_Edit: TSZHL_Edit;
  SZHL_DateEdit: TSZHL_DateEdit;
  SZHL_NumberBox: TSZHL_NumberBox;
  ctrlObj: TControl;
  strDebug: string;
  strLookupSql: string;
begin
  if Sender.Children <> nil then
    for i := 0 to Sender.Children.count - 1 do
    begin
      ChildObject := Sender.Children[i];
      if ChildObject.ChildrenCount > 0 then
        FindSZHL(ChildObject, fdm_table, strFieldName);
      // ctrlObj := ChildObject as TControl;
      // strDebug := ctrlObj.Name + ':' + ctrlObj.ClassName + '[' + Sender.ClassName + ']';

      if ChildObject is TSZHL_ComboBox then
      begin
        SZHL_ComboBox := ChildObject as TSZHL_ComboBox;
        if SameText(SZHL_ComboBox.FieldDict.FieldName, strFieldName) or strFieldName.Trim.IsEmpty then

          // 根据字段内容，定位当前列表显示行
          SZHL_ComboBox.ItemIndex := SZHL_ComboBox.RefValue.IndexOf(fdm_table.FieldByName(SZHL_ComboBox.FieldDict.FieldName).AsString.Trim);
      end
      else if ChildObject is TSZHL_Edit then
      begin

        SZHL_Edit := ChildObject as TSZHL_Edit;
        if SameText(SZHL_Edit.FieldDict.FieldName, strFieldName) or strFieldName.Trim.IsEmpty then
          if SZHL_Edit.FieldDict.FieldKind.ToLower.Equals('data') then
          begin
            SZHL_Edit.text := fdm_table.FieldByName(SZHL_Edit.FieldDict.FieldName.Trim).AsString.Trim
          end
          else
          begin
            if ((SZHL_Edit.FieldDict.Lookup_RelationField.Trim.Length > 0) and (SZHL_Edit.FieldDict.Lookup_Table.Trim.Length > 0) and (SZHL_Edit.FieldDict.Lookup_KeyField.Trim.Length > 0) and (SZHL_Edit.FieldDict.Lookup_ReturnField.Trim.Length > 0)) then
            begin
              strLookupSql := format('select %s from %s where %s=''%s''', [SZHL_Edit.FieldDict.Lookup_ReturnField, SZHL_Edit.FieldDict.Lookup_Table, SZHL_Edit.FieldDict.Lookup_KeyField, fdm_table.FieldByName(SZHL_Edit.FieldDict.Lookup_RelationField).AsString]);
              SZHL_Edit.text := U8DM.ExecSql0(strLookupSql);
            end;
          end;

      end;

    end;
end;

procedure CreateADCtrlDB(strTableDef: string; parentLay: TLayout; fdm_table: TFDMemTable; isFilter: Boolean = False);
// 根据AD动态显示字段标题（label)及控件,并绑定FDMemTable
var
  strTableName, curFieldname: string;
  i: integer;
  lyLine: TLayout;
  xpos, yPos, LabelSplit1: Extended;
  ConditionPos: integer;
  tsEdt: TSZHL_Edit;
  dateEdtControl: TSZHL_DateEdit;
  tsNumberBox: TSZHL_NumberBox;
  tsb1: TSearchEditButton;
  tscb: TSZHL_ComboBox;
  isSencondCondition: Boolean; // 区间条件第2栏目标志

  function GetNewLayWithBlankRow(lay1: TLayout; PreEmptyRow: Boolean = True): TLayout;
  var
    emptyRowlay: TLayout;
  begin
    if PreEmptyRow = True then
    begin
      emptyRowlay := TLayout.Create(parentLay);
      emptyRowlay.Parent := parentLay;
      emptyRowlay.Height := TVouchFrmLayConst.EmptyRowHeightUnit;
      emptyRowlay.Width := lay1.Width;
      emptyRowlay.Position.Y := yPos;
      yPos := yPos + TVouchFrmLayConst.EmptyRowHeightUnit;
    end;

    Result := TLayout.Create(parentLay);
    Result.Parent := parentLay;
    Result.Height := TVouchFrmLayConst.HeightUnit;
    Result.Width := lay1.Width;
    Result.Position.Y := yPos;
    yPos := yPos + TVouchFrmLayConst.HeightUnit;
  end;

begin
  if not U8DM.SetADTableByDef(strTableDef) then
    Exit;
  // if U8DM.FDM_SZHL_ItmDef.RecordCount = 0 then
  // Exit;
  strTableName := U8DM.FDM_SZHL_TableDef.FieldByName('Name').AsString.Trim;

  xpos := 0;
  yPos := 0;
  isSencondCondition := False;

  U8DM.FDM_SZHL_ItmDef.Filtered := False;

  if isFilter = True then
    U8DM.FDM_SZHL_ItmDef.Filter := 'iFilterVisible=True and isFilter=True'
  else
    U8DM.FDM_SZHL_ItmDef.Filter := 'iVisible=True'; // or isFilter=True';
  U8DM.FDM_SZHL_ItmDef.Filtered := True;

  U8DM.FDM_SZHL_ItmDef.FindFirst;
  while U8DM.FDM_SZHL_ItmDef.Found do
  begin

    curFieldname := U8DM.FDM_SZHL_ItmDef.FieldByName('FieldName').AsString;
    if fdm_table.Active = True then
      if fdm_table.Fields.FindField(curFieldname) = nil then
      begin
        U8DM.FDM_SZHL_ItmDef.FindNext;
        Continue;
      end;

    if yPos = 0 then
    begin
      lyLine := GetNewLayWithBlankRow(parentLay);
    end;

    // 计算当前控件组合位置   xPos
    // 如果计算现有X坐标+将要画的控件宽度大于屏幕宽度
    if (U8DM.FDM_SZHL_ItmDef.FieldByName('isBetween').AsBoolean = False) then
      if xpos + U8DM.FDM_SZHL_ItmDef.FieldByName('Width').AsInteger + TVouchFrmLayConst.LabelSplitHeader + U8DM.FDM_SZHL_ItmDef.FieldByName('LabelWidth').AsInteger > parentLay.Width then
      begin
        xpos := 0;
        lyLine := GetNewLayWithBlankRow(parentLay);
      end;

    if (U8DM.FDM_SZHL_ItmDef.FieldByName('isBetween').AsBoolean = True) then
    begin
      if (isSencondCondition = False) and (isFilter = True) then
      begin
        if xpos + U8DM.FDM_SZHL_ItmDef.FieldByName('Width').AsInteger * 2 + TVouchFrmLayConst.LabelSplit * 2 + U8DM.FDM_SZHL_ItmDef.FieldByName('LabelWidth').AsInteger * 2 > parentLay.Width then
        begin
          xpos := 0;
          lyLine := GetNewLayWithBlankRow(parentLay);
        end;
      end;

    end;

    if xpos = 0 then // 第一个控件caption前面留的距离 与后面标题离左面的距离 不一样，可以分隔开，
    begin
      LabelSplit1 := TVouchFrmLayConst.LabelSplitHeader;
    end
    else
    begin
      LabelSplit1 := TVouchFrmLayConst.LabelSplit;
    end;

    if isFilter then
      if isSencondCondition = True then
        ConditionPos := 2
      else
        ConditionPos := 1
    else
      ConditionPos := 1;

    DrawSZHL_Label(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, LabelSplit1, '', ConditionPos);
    // if U8DM.FDM_SZHL_ItmDef.FieldByName('FieldKind').AsString.Equals('Lookup') = True then
    // begin
    // end
    // else
    // begin

    if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'String') = True then // 根据类型画控件，字符型对应TEdit
    begin
      if (SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('EditStyle').AsString, 'ComboBox') = True) then
      begin
        tscb := DrawSZHL_ComboBox(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
        tscb.OnChange := U8DM.cbb_EvenChange;
      end;
      if (SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('EditStyle').AsString, '') = True) then
      begin
        tsEdt := DrawSZHL_Edit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
      end;
      if (SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('EditStyle').AsString, 'Lookup') = True) then
      begin
        tsEdt := DrawSZHL_Edit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
      end;
      if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('EditStyle').AsString, 'Ref') = True then
      begin
        tsEdt := DrawSZHL_Edit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
        tsb1 := TSearchEditButton.Create(nil);
        tsb1.Parent := tsEdt;
        tsb1.OnClick := U8DM.btnSrh_EvenClick;
      end
    end;
    if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'float') = True then // 根据类型画控件，日期型对应TDateEdit
    begin
      tsNumberBox := DrawSZHL_NumberBox(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
      tsNumberBox.ValueType := TNumValueType.float;
    end;
    if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'date') = True then // 根据类型画控件，日期型对应TDateEdit
    begin
      dateEdtControl := DrawSZHL_DateEdit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);

      if isSencondCondition = True then
        isSencondCondition := False
      else if (U8DM.FDM_SZHL_ItmDef.FieldByName('isBetween').AsBoolean = True) and (isFilter = True) then
      begin
        isSencondCondition := True;
        Continue
      end;
    end;
    U8DM.FDM_SZHL_ItmDef.FindNext;

  end;
  // end;
  U8DM.FDM_SZHL_ItmDef.Filtered := False;
  U8DM.FDM_SZHL_ItmDef.Filter := '';
end;

procedure ClearChildCtrl(Layout: TControl; Shown: Boolean = True);
var
  i: integer;
  c1: TControl;
  // strDefString:string;
begin
  for i := 0 to Layout.ControlsCount - 1 do
  begin
    // if Layout.Controls.Items[i].Name <> '' then
    // begin

    // Layout.Controls.Items[i].Visible := Shown;
    if (Layout.Controls.Items[i] is TEdit) then
    begin
      (Layout.Controls.Items[i] as TEdit).text := '';
    end;
    if (Layout.Controls.Items[i] is tdateedit) then
    begin
      (Layout.Controls.Items[i] as tdateedit).Date := now;
      (Layout.Controls.Items[i] as tdateedit).ReadOnly := False;
    end;
    if (Layout.Controls.Items[i] is TSZHL_ComboBox) then
    begin
      // (Layout.Controls.Items[i] as TSZHL_ComboBox).FieldDict.
      (Layout.Controls.Items[i] as TSZHL_ComboBox).ItemIndex := -1;
      // (Layout.Controls.Items[i] as TSZHL_ComboBox).Items.IndexOf('');
    end;

    // end;
    ClearChildCtrl(Layout.Controls.Items[i], Shown);
  end;

end;

procedure ShowMessage_debug(const AMessage: string);
begin
{$IFDEF DEBUG}
  ShowMessage(AMessage);
{$ENDIF}
  Exit;
end;

procedure getWareHouse(Sender: TForm; txtEdit: TEdit);
begin
  WareHouseFrm := TWareHouseFrm.Create(Application);
  WareHouseFrm.Parent := Sender;
  WareHouseFrm.Position := TFormPosition.MainFormCenter;
  WareHouseFrm.TopForm := Sender;
  WareHouseFrm.edt_search.text := txtEdit.text;
  WareHouseFrm.InitData;
  WareHouseFrm.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if WareHouseFrm.DefModalResult = mrOk then
      begin
        if not WareHouseFrm.fdm_warehouse.Eof then
          txtEdit.text := WareHouseFrm.fdm_warehouse.FieldByName('cWhCode').AsString;
        Sender.Show;
        WareHouseFrm.Focused := nil;
        WareHouseFrm := nil;
      end;
    end);
  // WareHouseFrm := TWareHouseFrm.Create(Application);
  // WareHouseFrm.TopForm := Sender;
  // WareHouseFrm.ShowModal(
  // procedure(ModalResult: TModalResult)
  // begin
  // if ModalResult = mrOk then
  // begin
  // if WareHouseFrm.strngrdWareHouse.RowCount > 0 then
  // txtEdit.Text := WareHouseFrm.strngrdWareHouse.Cells[0, WareHouseFrm.strngrdWareHouse.Row];
  // end;
  // TTask.Run( // 释放此窗体的必要代码
  // procedure
  // begin
  // TThread.Synchronize(nil,
  // procedure
  // begin
  // WareHouseFrm.Focused := nil; // 防止键盘的出现导致的异常
  // WareHouseFrm.DisposeOf; // 释放此窗体
  // WareHouseFrm := nil; // 释放此窗体
  // end);
  // end);
  // end);
end;

procedure getInventory(Sender: TForm; txtEdit: TEdit);
begin
  InventoryFrm := TInventoryFrm.Create(Application);
  InventoryFrm.Parent := Sender;
  InventoryFrm.TopForm := Sender;
  InventoryFrm.edt_search.text := txtEdit.text;
  InventoryFrm.InitData;
  InventoryFrm.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if InventoryFrm.DefModalResult = mrOk then
      begin
        if not InventoryFrm.FDM_Inventory.Eof then
          txtEdit.text := InventoryFrm.FDM_Inventory.FieldByName('cInvCode').AsString;
        Sender.Show;
        InventoryFrm.Focused := nil;
        InventoryFrm := nil;
      end;

    end);
end;

procedure getVendor(Sender: TForm; txtEdit: TEdit);
begin
  VendorFrm := TVendorFrm.Create(Application);
  VendorFrm.Parent := Sender;
  VendorFrm.TopForm := Sender;
  VendorFrm.edt_search.text := txtEdit.text;
  VendorFrm.InitData;
  VendorFrm.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if VendorFrm.DefModalResult = mrOk then
      begin
        if not VendorFrm.FDM_Vendor.Eof then
          txtEdit.text := VendorFrm.FDM_Vendor.FieldByName('cVenCode').AsString;
        Sender.Show;
        VendorFrm.Focused := nil;
        VendorFrm := nil;
      end;

    end);
end;

procedure getCustomer(Sender: TForm; txtEdit: TEdit);
begin
  CustomerFrm := TCustomerFrm.Create(Application);
  CustomerFrm.Parent := Sender;
  CustomerFrm.TopForm := Sender;
  CustomerFrm.edt_search.text := txtEdit.text;
  CustomerFrm.InitData;
  CustomerFrm.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if CustomerFrm.DefModalResult = mrOk then
      begin
        if not CustomerFrm.FDM_Customer.Eof then
          txtEdit.text := CustomerFrm.FDM_Customer.FieldByName('cVenCode').AsString;
        Sender.Show;
        CustomerFrm.Focused := nil;
        CustomerFrm := nil;
      end;

    end);
end;

procedure getPerson(Sender: TForm; txtEdit: TEdit);
begin
  personFrm := tpersonFrm.Create(Application);
  personFrm.Parent := Sender;
  personFrm.TopForm := Sender;
  personFrm.edt_search.text := txtEdit.text;
  personFrm.InitData;
  personFrm.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if personFrm.DefModalResult = mrOk then
      begin
        if not personFrm.FDM_Person.Eof then
          txtEdit.text := personFrm.FDM_Person.FieldByName('cPersonCode').AsString;
        Sender.Show;
        personFrm.Focused := nil;
        personFrm := nil;
      end;

    end);
end;

function GetMin_Number3(A, b, c: Double): Double;
var
  a1: array of Double;
begin
  try
    SetLength(a1, 3);
    a1[0] := A;
    a1[1] := b;
    a1[2] := c;
    Result := MinOfArray(a1);
  finally
    SetLength(a1, 0);
    a1 := nil;
  end;

end;

function GetMin_Number2(A, b: Double): Double;
var
  a1: array of Double;
begin
  try
    SetLength(a1, 2);
    a1[0] := A;
    a1[1] := b;
    Result := MinOfArray(a1);
  finally
    SetLength(a1, 0);
    a1 := nil;
  end;

end;

procedure getDepartment(Sender: TForm; txtEdit: TEdit);
begin
  DeptFrm := TDeptFrm.Create(Application);
  DeptFrm.Parent := Sender;
  DeptFrm.TopForm := Sender;
  DeptFrm.edt_search.text := txtEdit.text;
  DeptFrm.InitData;
  DeptFrm.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if DeptFrm.DefModalResult = mrOk then
      begin
        if not DeptFrm.FDM_Dept.Eof then
          txtEdit.text := DeptFrm.FDM_Dept.FieldByName('cDepCode').AsString;
        Sender.Show;
        DeptFrm.Focused := nil;
        DeptFrm := nil;
      end;

    end);
end;

procedure getPostion(Sender: TForm; txtEdit: TEdit; cWhCode: string);
begin
  PositionFrm := TPositionFrm.Create(Application);
  PositionFrm.Parent := Sender;
  PositionFrm.TopForm := Sender;
  PositionFrm.cWhCode := cWhCode;
  PositionFrm.edt_search.text := txtEdit.text;
  PositionFrm.srhBtn_1Click(Sender);
  PositionFrm.InitData;
  PositionFrm.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if PositionFrm.DefModalResult = mrOk then
      begin
        if not PositionFrm.FDM_Position.Eof then
          txtEdit.text := PositionFrm.FDM_Position.FieldByName('cPosCode').AsString;
        Sender.Show;
        PositionFrm.Focused := nil;
        PositionFrm := nil;
      end;

    end);
end;

function GetFirstParentControl(Sender: TObject; strClassName: string): TFmxObject;
var
  ParentObject: TFmxObject;
begin
  Result := nil;
  if (Sender is TFmxObject) then
  begin
    ParentObject := Sender as TFmxObject;
    while True do
    begin
      if ParentObject = nil then
      begin
        Exit;
      end;
      if SameText(ParentObject.ClassName, strClassName) = True then
      begin
        Result := ParentObject;
        Exit;
      end;
      ParentObject := ParentObject.Parent;
    end;
  end;
end;

{ TSZHL_Vouch }

procedure TSZHL_Vouch.btn1Click(Sender: TObject);
begin

end;

function MinOfArray(const A: array of Double): Double;
var
  Idx: integer;
begin
  Assert(Length(A) > 0);
  Result := A[Low(A)];
  for Idx := Succ(Low(A)) to High(A) do
    if A[Idx] < Result then
      Result := A[Idx];
end;

function TSZHL_Vouch.Prepared: Boolean;

  function GetString(blInit: Boolean; str: string): Boolean;
  begin
    if blInit = True then
      Result := Length(Trim(str)) > 0;
  end;

begin
  Result := True;
  VouchArrow := vhBlue;
  Result := GetString(Result, ListTable);
  Result := GetString(Result, ListTableDef);

  // Result := GetString(Result, MainKey);               //新建是空值
  Result := GetString(Result, DesMainTable);
  Result := GetString(Result, DesMainTableDef);
  Result := GetString(Result, DesMainKeyField);

  // Result := GetString(Result, DesKey);                 //新建是空值
  Result := GetString(Result, DesSubTable);
  Result := GetString(Result, DesSubTableDef);
  Result := GetString(Result, DesSubKeyField);
  Result := GetString(Result, DesSubLinkSrcFeild);
  Result := GetString(Result, DesSubQtyField);

  Result := GetString(Result, SrcTable);
  Result := GetString(Result, SrcTableDef);
  Result := GetString(Result, SrcKeyField);
  Result := GetString(Result, SrcLinkDesSubField);
  Result := GetString(Result, SrcQtyField);
  Result := GetString(Result, SrcRmtQtyField);
  Result := GetString(Result, SrcLinkMainField);

end;

function GetFieldInfoByFieldName(strTableName, strFieldName: string): TSZHL_FieldDict;
begin

end;

// function GetFieldInfoByAutoId(intAutoid: Integer): TSZHL_FieldDict;
// begin
// if fdFieldInfo1 = nil then
// fdFieldInfo1 := TSZHL_FieldDict.Create;
//
// Result := fdFieldInfo1;
// end;

// function Replicate(pcChar: Char; piCount: integer): string;
// begin
// Result := '';
// SetLength(Result, piCount);
// fillChar(Pointer(Result)^, piCount, pcChar)
// end;

{ TLoginInfo }

procedure TLoginInfo.Setlogined(const Value: Boolean);
begin
  FLogined := Value;
  if Assigned(MainFrm) then
  begin
    with MainFrm do
    begin
      if Value then
      begin
        lbl_LoginInfo.Text := format('[%s]%s', [PubVar_LoginInfo.UserID, PubVar_LoginInfo.UserName]);
    // LoginBtn.Text := LoginFrm.UserNameEdt.Text;
      end
      else
      begin
        lbl_LoginInfo.Text := '未登录';
    // LoginBtn.Text := '未登录';
      end;
    end;
  end;
end;

end.

