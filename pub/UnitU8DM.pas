unit unitU8DM;

interface

uses
  System.SysUtils, FMX.Dialogs, System.Classes, FMX.Types, FMX.Controls,
  IPPeerClient, Soap.InvokeRegistry, uSZHLFMXEdit, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, Generics.Collections, FMX.Grid, LoginService, Soap.Rio,
  Soap.SOAPHTTPClient, FMX.Forms, System.Messaging, Data.FireDACJSONReflect,
  Inifiles, IOUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  uServerMethods1Client, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, Data.DB, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet, FireDAC.Phys.DS, FireDAC.Phys.DSDef, FireDAC.Comp.UI,
  FireDAC.FMXUI.Wait, Data.DBXDataSnap, Data.DBXCommon, Data.SqlExpr, FireDAC.Stan.StorageBin,
  Data.FMTBcd;

type
  TExeStatus = (esReady, esWaiting);

  TU8DM = class(TDataModule)
    HTTPRIO1: THTTPRIO;
    FDM_SZHL_ItmDef: TFDMemTable;
    SQLConnection1: TSQLConnection;
    FDM_SZHL_TableDef: TFDMemTable;
    ds_SZHL_TableDef: TDataSource;
    AndroidLight: TStyleBook;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    FCurrentTableName: string;
    MessageManager: TMessageManager;
    procedure ListenerMethod(const Sender: TObject; const M: TMessage); virtual;
    procedure ReadServerAddr;
  public
    MsgText: string;
    // tmpHTTPRIO : THTTPRIO;
    methods: TServerMethods1Client;
    procedure cbb_EvenChange(Sender: TObject);
    procedure btnSrh_EvenClick(Sender: TObject);
    procedure ExecSql(var FDM_para: TFDMemTable; strSql: string);
    function ExecSql0(strSql: string): string;
    function ExecuteSql(strSql: string): boolean;
    function SetADTableByDef(strTbDef: string): boolean;
    function CheckSnUsed(cVouchType, SN: string): boolean;
    function CheckWareHousePos(cWhCode: string): boolean;
    function CheckInvBatch(cInvCode: string): boolean;
    function CheckAllowEmptys(DataSet: TDataSet; strTableDef: string): string;
    // procedure CalcLookupFields(DataSet: TFDMemTable; strTableName: string);
    procedure ExecSqlADTable(ft1: TFDMemTable; strTbName: string);
    procedure FormatGrid_byAD(strTableDef, strFilter: string; FDM_Data: TFDMemTable; Link1: TLinkGridToDataSource; isGroup: boolean = False);
    function Save2(FDMemTable1: TFDMemTable; strTableName: string): Boolean;
    procedure doinitdatae;
  end;

var
  U8DM: TU8DM;
  dateFmtSet: TFormatSettings;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  UnitLib;
{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

function TU8DM.Save2(FDMemTable1: TFDMemTable; strTableName: string): Boolean;
var
  LDeltas: TFDJSONDeltas;
begin
  if FDMemTable1.State in dsEditModes then
    FDMemTable1.Post;
  LDeltas := TFDJSONDeltas.Create;
  TFDJSONDeltasWriter.ListAdd(LDeltas, '1', FDMemTable1);
  Result := methods.SaveData2(Const_AccNo, strTableName, LDeltas);
//    Result:=true
//  else
//    Self.Caption := 'save fail';
end;

procedure TU8DM.DataModuleCreate(Sender: TObject);
begin
  dateFmtSet := TFormatSettings.Create;
  dateFmtSet.DateSeparator := '-';
  dateFmtSet.TimeSeparator := ':';
  dateFmtSet.ShortDateFormat := 'YYYY-MM-DD';

  MessageManager := TMessageManager.DefaultManager;
  MessageManager.SubscribeToMessage(TMessage<Integer>, Self.ListenerMethod);
  doinitdatae;
end;

procedure TU8DM.FormatGrid_byAD(strTableDef, strFilter: string; FDM_Data: TFDMemTable; Link1: TLinkGridToDataSource; isGroup: boolean = False);
var
  i, colwidth: Integer;
  strFieldName: string;
  col: TLinkGridToDataSourceColumn;
  // strTableName: string;

  function NewLinkColumn(Link1: TLinkGridToDataSource; FDM_Dic1, FDM_Data1: TFDMemTable): TLinkGridToDataSourceColumn;
  var
    Field1: TField;
    col1: TLinkGridToDataSourceColumn;
  begin
    strFieldName := FDM_SZHL_ItmDef.FieldByName('FieldName').AsString;             //建立stringgrid字段
    Field1 := FDM_Data1.Fields.FindField(strFieldName);
    if Field1 <> nil then
    begin
      col1 := Link1.Columns.Add;
      with col1 do
      begin
        Header := FDM_Dic1.FieldByName('FieldDef').AsString;
        // FDM_ADDict_tmp.Table.Rows[i].ValueS['FieldDef']; //fdm_Dict.FieldByName('FieldDef').AsString;
        MemberName := FDM_Dic1.FieldByName('FieldName').AsString; // FDM_ADDict_tmp.Table.Rows[i].ValueS['FieldName'];
        Width := FDM_Dic1.FieldByName('Width').AsInteger; // FDM_ADDict_tmp.Table.Rows[i].ValueS['Width'];
        ReadOnly := FDM_Dic1.FieldByName('Editing').AsBoolean;
        ColumnStyle := GetColumnStyle(Field1);
      end;
    end;
  end;

begin

  SetADTableByDef(strTableDef);
  //strTableName:= U8DM.FDM_SZHL_TableDef.FieldByName('Name').AsString.Trim;
  FDM_SZHL_ItmDef.Filtered := False;
  if strFilter = '' then
    FDM_SZHL_ItmDef.Filter := 'iVisible=true'
  else
    FDM_SZHL_ItmDef.Filter := strFilter;
  FDM_SZHL_ItmDef.Filtered := True;

  if FDM_SZHL_ItmDef.FindFirst = True then
  begin
    (Link1.DataSource as TBindSourceDB).DataSet := nil; // 必须先断开，否则出错；
    Link1.Columns.Clear;

    while FDM_SZHL_ItmDef.Found do
    begin
      NewLinkColumn(Link1, FDM_SZHL_ItmDef, FDM_Data);
      FDM_SZHL_ItmDef.FindNext;
    end;
    (Link1.DataSource as TBindSourceDB).DataSet := FDM_Data;
  end;
  FDM_SZHL_ItmDef.Filtered := False;
  AlignHeaders(Link1.GridControl as TStringGrid);
end;

function TU8DM.SetADTableByDef(strTbDef: string): boolean;
begin
  Result := False;
  if FDM_SZHL_TableDef.RecordCount > 0 then
  begin
    FDM_SZHL_TableDef.First;
    if FDM_SZHL_TableDef.Locate('Def', strTbDef, [loCaseInsensitive]) then
      Result := True
       // ExecSql(FDM_SZHL_ItmDef, 'select * from SZHL_ItmDef where tableid in (select tableid from SZHL_TableDef where mobile=1) order by tableid,seq');
    else
    begin
      ShowMessage(format('在数据字典中未能找到别名为"%s"的记录，请检查.', [strTbDef]));
    end;
  end;
  FDM_SZHL_ItmDef.Filtered := False;
end;

procedure TU8DM.ExecSqlADTable(ft1: TFDMemTable; strTbName: string);
begin
  FDM_SZHL_TableDef.Locate('TalbeName', Trim(strTbName));
  ft1.Close;
  ft1.AppendData(FDM_SZHL_ItmDef.Data);
end;

function TU8DM.ExecuteSql(strSql: string): boolean;
// var
// LDataSets: TFDJSONDataSets;
// LDataSet: TFDDataSet;
begin
  if SQLConnection1.ConnectionState = csStateClosed then
    SQLConnection1.Open;
  Result := methods.ExecuteSql(Const_AccNo, strSql);
  // LDataSet := TFDJSONDataSetsReader.GetListValueByName(LDataSets, '1');
  // FDM_para.Close;
  // FDM_para.Data := LDataSet;
end;

procedure TU8DM.DataModuleDestroy(Sender: TObject);
begin
  methods.free;
  // dateFmtSet:=NIL;
end;

procedure TU8DM.doinitdatae;
begin
  ReadServerAddr;
//  if SQLConnection1.ConnectionState = csStateClosed then
//  begin
  SQLConnection1.Close;
  SQLConnection1.Params.Values['HostName'] := PubVar_MiddleServer;
  SQLConnection1.Open;
//  end;
  methods := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
  // tmpHTTPRIO := THTTPRIO.Create(Nil);
  ExecSql(FDM_SZHL_TableDef, 'select * from SZHL_TableDef where mobile=1');
  ExecSql(FDM_SZHL_ItmDef, 'select * from SZHL_ItmDef where tableid in (select tableid from SZHL_TableDef where mobile=1) order by tableid,seq');

end;

procedure TU8DM.ExecSql(var FDM_para: TFDMemTable; strSql: string); // 核心DAC
var
  LDataSets: TFDJSONDataSets;
  LDataSet: TFDDataSet;
begin
  if SQLConnection1.ConnectionState = csStateClosed then
    SQLConnection1.Open;
  LDataSets := methods.QuerySql2(Const_AccNo, strSql);
  LDataSet := TFDJSONDataSetsReader.GetListValueByName(LDataSets, '1');
  FDM_para.Close;
  FDM_para.Data := LDataSet;
end;

//procedure TU8DM.UpdateSZHL_QRCode(strsql : string);      //更新条码数量
//begin
//  if SQLConnection1.ConnectionState = csStateClosed then
//    SQLConnection1.Open;
//  with UpdateQRCodeQuery do
//  begin
//    SQL.Clear;
//    SQL.Text := 'update  SZHL_QRCodeRecord set SrcId = 2 where AutoId=6222';
//    ExecSQL;
//  end;
//end;

function TU8DM.ExecSql0(strSql: string): string;
var
  LDataSets: TFDJSONDataSets;
  FDM_para: TFDMemTable;
  LDataSet: TFDDataSet;
begin
  if SQLConnection1.ConnectionState = csStateClosed then
    SQLConnection1.Open;
  LDataSets := methods.QuerySql2(Const_AccNo, strSql);
  LDataSet := TFDJSONDataSetsReader.GetListValueByName(LDataSets, '1');
  FDM_para := TFDMemTable.Create(nil);
  try
    FDM_para.Data := LDataSet;
    // if FDM_para.RecordCount = 0 then
    // Result := 0
    // else
    Result := FDM_para.Fields[0].AsString;
  finally
    FDM_para.free;
  end;
end;

procedure TU8DM.ListenerMethod(const Sender: TObject; const M: TMessage);
begin

end;

procedure TU8DM.ReadServerAddr;
//var
//  IniFile: TIniFile;
begin
//  try
//    IniFile := TIniFile.Create(GetIniFileName);
//    PubVar_WebServiceUrl := IniFile.ReadString('Config', 'ServerAddr', PubVar_WebServiceUrl);
//    PubVar_MiddleServer := IniFile.ReadString('Config', 'MiddleServer', PubVar_WebServiceUrl);
//  finally
//    FreeAndNil(IniFile);
//  end;


  with TIniFile.Create(GetIniFileName) do
  try
    begin
        //ly_MidCb.Selected.Text := ReadString('Config', 'ServerAddr', PubVar_AppServer);
      PubVar_WebServiceUrl := ReadString('Config', 'WebServiceUrl', PubVar_WebServiceUrl);
      PubVar_MiddleServer := ReadString('Config', 'MiddleServer', PubVar_WebServiceUrl);
    end;
  finally
    free
  end;
end;

function TU8DM.CheckInvBatch(cInvCode: string): boolean;
var
  f1: TFDMemTable;
  strCheckSql: string;
begin
  f1 := TFDMemTable.Create(nil);
  strCheckSql := format('select * from Inventory where isnull(bInvBatch,0)=0 and cInvCode= ''%s''', [cInvCode]);
  ExecSql(f1, strCheckSql);
  try
    Result := f1.Eof;
  finally
    FreeAndNil(f1);
  end;
end;

function TU8DM.CheckSnUsed(cVouchType, SN: string): boolean;
var
  f1: TFDMemTable;
  strCheckSql: string;
begin
  f1 := TFDMemTable.Create(nil);
  strCheckSql := format('Exec SZHL_ChechSnUsed ''%s'',''%s''', [cVouchType, SN]);
  ExecSql(f1, strCheckSql);
  try
    if not f1.Eof then
    begin
      Result := f1.Fields[0].AsBoolean;
    end;
  finally
    FreeAndNil(f1);
  end;
end;

function TU8DM.CheckWareHousePos(cWhCode: string): boolean;
var
  f1: TFDMemTable;
  strCheckSql: string;
begin
  f1 := TFDMemTable.Create(nil);
  strCheckSql := format('select * from WareHouse where bWhPos=0 and cWhCode= ''%s''', [cWhCode]);
  ExecSql(f1, strCheckSql);
  try
    Result := f1.Eof;
  finally
    FreeAndNil(f1);
  end;
end;

function TU8DM.CheckAllowEmptys(DataSet: TDataSet; strTableDef: string): string;
var
  strFieldName: string;
  strErrMsg: string;
begin
  inherited;
  strErrMsg := '';
  FDM_SZHL_ItmDef.Filtered := False;
  SetADTableByDef(strTableDef);
  FDM_SZHL_ItmDef.Filter := 'AllowEmpty=false';
  FDM_SZHL_ItmDef.Filtered := True;
  if FDM_SZHL_ItmDef.FindFirst then
  begin
    while FDM_SZHL_ItmDef.Found do
    begin
      if FDM_SZHL_ItmDef.FieldByName('FieldKind').AsString.Trim.ToLower.Equals('data') = True then
      begin
        strFieldName := FDM_SZHL_ItmDef.FieldByName('FieldName').AsString;
        if Trim(DataSet.FieldByName(strFieldName).AsString) = '' then
        begin
          strErrMsg := strErrMsg + format('字段:%s不能为空.'#13#10, [FDM_SZHL_ItmDef.FieldByName('FieldDef').AsString]);
        end;
      end;
      FDM_SZHL_ItmDef.FindNext;
    end;
  end;
  if strErrMsg <> '' then
    strErrMsg := '以下项目不能为空，请输入后重试。'#13#10 + Trim(strErrMsg);
  Result := strErrMsg;

end;
//
// procedure TU8DM.CalcLookupFields(DataSet: TFDMemTable; strTableName: string);
// var
// // i: Integer;
// Field_Current: TField;
// FDM_Result   : TFDMemTable;
// LookupKeyFieldName, LookupRefTableName, LookupRefKeyFieldName, LookupRefFieldName: string;
// strSqlText: string;
// // LookupKeyFieldName_DataType: TFieldType;
//
// procedure subProcedure();
// begin
// Field_Current := DataSet.FieldList.Find(FDM_SZHL_ItmDef.FieldByName('FieldName').AsString);
// if Field_Current <> nil then
// begin
// LookupKeyFieldName := FDM_SZHL_ItmDef.FieldByName('LookupKeyFieldName').AsString;
// LookupRefTableName := FDM_SZHL_ItmDef.FieldByName('LookupRefTableName').AsString;
// LookupRefKeyFieldName := FDM_SZHL_ItmDef.FieldByName('LookupRefKeyFieldName').AsString;
// LookupRefFieldName := FDM_SZHL_ItmDef.FieldByName('LookupRefFieldName').AsString;
// if DataSet.FieldByName(LookupKeyFieldName) is TStringField then
// begin
// strSqlText := Format('select %s Field1 from %s where %s=''%s''', [LookupRefFieldName, LookupRefTableName, LookupRefKeyFieldName,
// DataSet.FieldByName(LookupKeyFieldName).AsString]);
// end else if DataSet.FieldByName(LookupKeyFieldName) is TNumericField then
// begin
// strSqlText := Format('select %s from %s where %s=%s', [LookupRefFieldName, LookupRefTableName, LookupRefKeyFieldName,
// DataSet.FieldByName(LookupKeyFieldName).AsString]);
// end;
// FDM_Result := TFDMemTable.Create(Self);
// ExecSql(FDM_Result, strSqlText);
// if FDM_Result.RecordCount > 0 then
// begin
// DataSet.FieldByName(Field_Current.FieldName).Value := FDM_Result.Fields[0].Value;
// end;
// end;
// end;
//
// begin
// inherited;
// if DataSet.RecordCount > 0 then
// begin
// if SetADTable(strTableName) then
// Exit;
// FDM_SZHL_ItmDef.Filtered := False;
// FDM_SZHL_ItmDef.Filter := 'FieldKind=''Lookup''';
// FDM_SZHL_ItmDef.Filtered := True;
//
// DataSet.BeginBatch();
// DataSet.First;
// while not DataSet.Eof do
// begin
// DataSet.Edit;
// if FDM_SZHL_ItmDef.FindFirst then
// begin
// subProcedure;
// end;
// while FDM_SZHL_ItmDef.FindNext do
// begin
// subProcedure;
// end;
//
// DataSet.Post;
// DataSet.next;
// end;
// DataSet.EndBatch;
// end;
//
// end;

procedure TU8DM.cbb_EvenChange(Sender: TObject);
var
  cbb: TSZHL_ComboBox;
begin
  if not (Sender is TSZHL_ComboBox) then
    exit;

  cbb := Sender as TSZHL_ComboBox;
  if cbb.FieldDict.FDMDataSet <> nil then
    if cbb.FieldDict.FDMDataSet.Active then
      if cbb.FieldDict.FDMDataSet.State in [DSINSERT, DSEDIT] then
        cbb.FieldDict.FDMDataSet.FieldByName(cbb.FieldDict.FieldName).Value := cbb.RefValue.Strings[cbb.ItemIndex];
end;

procedure TU8DM.btnSrh_EvenClick(Sender: TObject);
var
  objEdit: TSZHL_Edit;
  objForm: TForm;
  msg: string;
begin
  inherited;
  objEdit := Get_FirstParent_TSZHL_Edit(Sender);
  objForm := Get_FirstParent_TForm(Sender);
  if not (objEdit.FieldDict.FDMDataSet.State in [DSINSERT, DSEDIT]) then
  begin
    objEdit.FieldDict.FDMDataSet.Edit;
  end;
  if (objForm = nil) or (objEdit = nil) then
    exit;
  if SameText(objEdit.FieldDict.Ref_Table, 'Inventory') = True then
    getInventory(objForm, objEdit);
  if SameText(objEdit.FieldDict.Ref_Table, 'Warehouse') = True then
    getWareHouse(objForm, objEdit);
  if SameText(objEdit.FieldDict.Ref_Table, 'Vendor') = True then
    getVendor(objForm, objEdit);
  if SameText(objEdit.FieldDict.Ref_Table, 'Department') = True then
    getDepartment(objForm, objEdit);
  if SameText(objEdit.FieldDict.Ref_Table, 'Customer') = True then
    getDepartment(objForm, objEdit);
  if SameText(objEdit.FieldDict.Ref_Table, 'Person') = True then
    getPerson(objForm, objEdit);
  if objEdit.FieldDict.FDMDataSet <> nil then
    if objEdit.FieldDict.FDMDataSet.FindField(objEdit.FieldDict.FieldName) <> nil then
    begin
      objEdit.FieldDict.FDMDataSet.FieldByName(objEdit.FieldDict.FieldName).Value := objEdit.text;
      objEdit.RefValue := objEdit.text;
    end;
end;

// procedure TU8DM.Add_FDMCalcFields(var FDM_OldTable: TFDMemTable; strTableName: string);
// var
// FDM_NewTable: TFDMemTable;
// HasNew      : Boolean;
//
// procedure DoAddFieldDef;
// begin
// with FDM_NewTable.FieldDefs.AddFieldDef do
// begin
// name := Trim(FDM_SZHL_ItmDef.FieldByName('Fieldname').AsString);
// DisplayName := Trim(FDM_SZHL_ItmDef.FieldByName('Fieldname').AsString);
// DataType := ftWideString;
// Size := 50;
// Required := True;
// Attributes := [faReadonly];
// end;
// end;
//
// begin
// FDM_NewTable := TFDMemTable.Create(Application);
// FDM_NewTable.FieldDefs.Assign(FDM_OldTable.FieldDefs);
//
// try
// if not SetADTable(strTableName) then
// Exit;
// FDM_SZHL_ItmDef.Filtered := False;
// FDM_SZHL_ItmDef.Filter := 'FieldKind=''Lookup''';
// FDM_SZHL_ItmDef.Filtered := True;
// HasNew := False;
// if FDM_SZHL_ItmDef.FindFirst = True then
// begin
// HasNew := True;
// while FDM_SZHL_ItmDef.Found do
// begin
// DoAddFieldDef;
// FDM_SZHL_ItmDef.FindNext
// end;
// end;
// FDM_NewTable.CreateDataSet;
// finally
// if HasNew = True then
// begin
// FDM_NewTable.AppendData(FDM_OldTable.Data);
// FreeAndNil(FDM_OldTable);
// FDM_OldTable := FDM_NewTable;
// end else begin
// FreeAndNil(FDM_NewTable);
// end;
// end;
//
// end;

end.

