//
// Created by the DataSnap proxy generator.
// 2017-12-30 18:34:10
//

unit uServerMethods1Client;

interface

uses
  System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON,
  Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr, Data.DBXDBReaders,
  Data.DBXCDSReaders, Data.FireDACJSONReflect, untGlobal, Data.DBXJSONReflect;

type
  TServerMethods1Client = class(TDSAdminClient)
  private
    FDataModuleCreateCommand: TDBXCommand;
    FDataModuleDestroyCommand: TDBXCommand;
    FGetServerDateCommand: TDBXCommand;
    FQuerySqlCommand: TDBXCommand;
    FQuerySql6Command: TDBXCommand;
    FQuerySqlsCommand: TDBXCommand;
    FQuerySql2Command: TDBXCommand;
    FQuerySql3Command: TDBXCommand;
    FQuerySql4Command: TDBXCommand;
    FQuerySql5Command: TDBXCommand;
    FQuerySql8Command: TDBXCommand;
    FExecuteSqlCommand: TDBXCommand;
    FSaveDataCommand: TDBXCommand;
    FSaveData6Command: TDBXCommand;
    FSaveDatas6Command: TDBXCommand;
    FSaveData2Command: TDBXCommand;
    FSaveData3Command: TDBXCommand;
    FSaveData4Command: TDBXCommand;
    FSaveData5Command: TDBXCommand;
    FSaveDatasCommand: TDBXCommand;
    FGetFieldValueCommand: TDBXCommand;
    FGetSetOfBookCommand: TDBXCommand;
    FGetSvrDataCommand: TDBXCommand;
    FspOpenCommand: TDBXCommand;
    FspExecCommand: TDBXCommand;
    FspOpenOutCommand: TDBXCommand;
    FspExecOutCommand: TDBXCommand;
    FspOpen2Command: TDBXCommand;
    FechoCommand: TDBXCommand;
    FDownLoadFileCommand: TDBXCommand;
    FUploadFileCommand: TDBXCommand;
    FDownLoadFile2Command: TDBXCommand;
    FUploadFile2Command: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    function GetServerDate: string;
    function QuerySql(accountNo: String; sql: String): OleVariant;
    function QuerySql6(accountNo: String; sql: String; params: String): OleVariant;
    function QuerySqls(accountNo: String; sqls: String): OleVariant;
    function QuerySql2(accountNo: string; sql: string): TFDJSONDataSets;
    function QuerySql3(accountNo: string; sql: string): TStream;
    function QuerySql4(myInfo: TMyInfo): TFDJSONDataSets;
    function QuerySql5(myInfoList: TMyInfoList): TFDJSONDataSets;
    function QuerySql8(accountNo: String; sql: String): string;
    function ExecuteSql(accountNo: String; sql: String): Boolean;
    function SaveData(accountNo: String; tableName: String; delta: OleVariant): Boolean;
    function SaveData6(Delta: OleVariant; AccountNo: string; TableName: string; aWhere: string; noSaveFields: string): Boolean;
    function SaveDatas6(AccountNo: string; tableNum: Integer; Deltas: OleVariant; TableNames: OleVariant; wheres: OleVariant; noSaveFields: OleVariant): Boolean;
    function SaveData2(accountNo: string; tableName: string; delta: TFDJSONDeltas): Boolean;
    function SaveData3(accountNo: string; tableName: string; delta: TStream): Boolean;
    function SaveData4(myUpdate: TMyUpdate): Boolean;
    function SaveData5(myUpdateList: TMyUpdateList): Boolean;
    function SaveDatas(accountNo: String; tableNames: OleVariant; deltas: OleVariant; tableCount: Integer): Boolean;
    function GetFieldValue(accountNo: String; sql: String): OleVariant;
    function GetSetOfBook: OleVariant;
    function GetSvrData(accountNo: String; defineId: String; inParams: OleVariant): OleVariant;
    function spOpen(accountNo: String; spName: String; inParams: OleVariant): OleVariant;
    function spExec(accountNo: String; spName: String; inParams: OleVariant): Boolean;
    function spOpenOut(accountNo: String; spName: String; inParams: OleVariant): OleVariant;
    function spExecOut(accountNo: String; spName: String; inParams: OleVariant): OleVariant;
    function spOpen2(accountNo: string; spName: string; inParams: string): TFDJSONDataSets;
    function echo(str: string): string;
    function DownLoadFile(fileName: string): TStream;
    function UploadFile(Stream: TStream): Boolean;
    function DownLoadFile2(fileName: String): OleVariant;
    function UploadFile2(Stream: OleVariant; FileName: String): Boolean;
  end;

implementation

procedure TServerMethods1Client.DataModuleCreate(Sender: TObject);
begin
  if FDataModuleCreateCommand = nil then
  begin
    FDataModuleCreateCommand := FDBXConnection.CreateCommand;
    FDataModuleCreateCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FDataModuleCreateCommand.Text := 'TServerMethods1.DataModuleCreate';
    FDataModuleCreateCommand.Prepare;
  end;
  if not Assigned(Sender) then
    FDataModuleCreateCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FDataModuleCreateCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FDataModuleCreateCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(Sender), True);
      if FInstanceOwner then
        Sender.Free
    finally
      FreeAndNil(FMarshal)
    end
  end;
  FDataModuleCreateCommand.ExecuteUpdate;
end;

procedure TServerMethods1Client.DataModuleDestroy(Sender: TObject);
begin
  if FDataModuleDestroyCommand = nil then
  begin
    FDataModuleDestroyCommand := FDBXConnection.CreateCommand;
    FDataModuleDestroyCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FDataModuleDestroyCommand.Text := 'TServerMethods1.DataModuleDestroy';
    FDataModuleDestroyCommand.Prepare;
  end;
  if not Assigned(Sender) then
    FDataModuleDestroyCommand.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FDataModuleDestroyCommand.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FDataModuleDestroyCommand.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(Sender), True);
      if FInstanceOwner then
        Sender.Free
    finally
      FreeAndNil(FMarshal)
    end
  end;
  FDataModuleDestroyCommand.ExecuteUpdate;
end;

function TServerMethods1Client.GetServerDate: string;
begin
  if FGetServerDateCommand = nil then
  begin
    FGetServerDateCommand := FDBXConnection.CreateCommand;
    FGetServerDateCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetServerDateCommand.Text := 'TServerMethods1.GetServerDate';
    FGetServerDateCommand.Prepare;
  end;
  FGetServerDateCommand.ExecuteUpdate;
  Result := FGetServerDateCommand.Parameters[0].Value.GetWideString;
end;

function TServerMethods1Client.QuerySql(accountNo: String; sql: String): OleVariant;
begin
  if FQuerySqlCommand = nil then
  begin
    FQuerySqlCommand := FDBXConnection.CreateCommand;
    FQuerySqlCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FQuerySqlCommand.Text := 'TServerMethods1.QuerySql';
    FQuerySqlCommand.Prepare;
  end;
  FQuerySqlCommand.Parameters[0].Value.SetWideString(accountNo);
  FQuerySqlCommand.Parameters[1].Value.SetWideString(sql);
  FQuerySqlCommand.ExecuteUpdate;
  Result := FQuerySqlCommand.Parameters[2].Value.AsVariant;
end;

function TServerMethods1Client.QuerySql6(accountNo: String; sql: String; params: String): OleVariant;
begin
  if FQuerySql6Command = nil then
  begin
    FQuerySql6Command := FDBXConnection.CreateCommand;
    FQuerySql6Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FQuerySql6Command.Text := 'TServerMethods1.QuerySql6';
    FQuerySql6Command.Prepare;
  end;
  FQuerySql6Command.Parameters[0].Value.SetWideString(accountNo);
  FQuerySql6Command.Parameters[1].Value.SetWideString(sql);
  FQuerySql6Command.Parameters[2].Value.SetWideString(params);
  FQuerySql6Command.ExecuteUpdate;
  Result := FQuerySql6Command.Parameters[3].Value.AsVariant;
end;

function TServerMethods1Client.QuerySqls(accountNo: String; sqls: String): OleVariant;
begin
  if FQuerySqlsCommand = nil then
  begin
    FQuerySqlsCommand := FDBXConnection.CreateCommand;
    FQuerySqlsCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FQuerySqlsCommand.Text := 'TServerMethods1.QuerySqls';
    FQuerySqlsCommand.Prepare;
  end;
  FQuerySqlsCommand.Parameters[0].Value.SetWideString(accountNo);
  FQuerySqlsCommand.Parameters[1].Value.SetWideString(sqls);
  FQuerySqlsCommand.ExecuteUpdate;
  Result := FQuerySqlsCommand.Parameters[2].Value.AsVariant;
end;

function TServerMethods1Client.QuerySql2(accountNo: string; sql: string): TFDJSONDataSets;
begin
  if FQuerySql2Command = nil then
  begin
    FQuerySql2Command := FDBXConnection.CreateCommand;
    FQuerySql2Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FQuerySql2Command.Text := 'TServerMethods1.QuerySql2';
    FQuerySql2Command.Prepare;
  end;
  FQuerySql2Command.Parameters[0].Value.SetWideString(accountNo);
  FQuerySql2Command.Parameters[1].Value.SetWideString(sql);
  FQuerySql2Command.ExecuteUpdate;
  if not FQuerySql2Command.Parameters[2].Value.IsNull then
  begin
    FUnMarshal := TDBXClientCommand(FQuerySql2Command.Parameters[2].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FQuerySql2Command.Parameters[2].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FQuerySql2Command.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.QuerySql3(accountNo: string; sql: string): TStream;
begin
  if FQuerySql3Command = nil then
  begin
    FQuerySql3Command := FDBXConnection.CreateCommand;
    FQuerySql3Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FQuerySql3Command.Text := 'TServerMethods1.QuerySql3';
    FQuerySql3Command.Prepare;
  end;
  FQuerySql3Command.Parameters[0].Value.SetWideString(accountNo);
  FQuerySql3Command.Parameters[1].Value.SetWideString(sql);
  FQuerySql3Command.ExecuteUpdate;
  Result := FQuerySql3Command.Parameters[2].Value.GetStream(FInstanceOwner);
end;

function TServerMethods1Client.QuerySql4(myInfo: TMyInfo): TFDJSONDataSets;
begin
  if FQuerySql4Command = nil then
  begin
    FQuerySql4Command := FDBXConnection.CreateCommand;
    FQuerySql4Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FQuerySql4Command.Text := 'TServerMethods1.QuerySql4';
    FQuerySql4Command.Prepare;
  end;
  if not Assigned(myInfo) then
    FQuerySql4Command.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FQuerySql4Command.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FQuerySql4Command.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(myInfo), True);
      if FInstanceOwner then
        myInfo.Free
    finally
      FreeAndNil(FMarshal)
    end
  end;
  FQuerySql4Command.ExecuteUpdate;
  if not FQuerySql4Command.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDBXClientCommand(FQuerySql4Command.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FQuerySql4Command.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FQuerySql4Command.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.QuerySql5(myInfoList: TMyInfoList): TFDJSONDataSets;
begin
  if FQuerySql5Command = nil then
  begin
    FQuerySql5Command := FDBXConnection.CreateCommand;
    FQuerySql5Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FQuerySql5Command.Text := 'TServerMethods1.QuerySql5';
    FQuerySql5Command.Prepare;
  end;
  if not Assigned(myInfoList) then
    FQuerySql5Command.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FQuerySql5Command.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FQuerySql5Command.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(myInfoList), True);
      if FInstanceOwner then
        myInfoList.Free
    finally
      FreeAndNil(FMarshal)
    end
  end;
  FQuerySql5Command.ExecuteUpdate;
  if not FQuerySql5Command.Parameters[1].Value.IsNull then
  begin
    FUnMarshal := TDBXClientCommand(FQuerySql5Command.Parameters[1].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FQuerySql5Command.Parameters[1].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FQuerySql5Command.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.QuerySql8(accountNo: String; sql: String): string;
begin
  if FQuerySql8Command = nil then
  begin
    FQuerySql8Command := FDBXConnection.CreateCommand;
    FQuerySql8Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FQuerySql8Command.Text := 'TServerMethods1.QuerySql8';
    FQuerySql8Command.Prepare;
  end;
  FQuerySql8Command.Parameters[0].Value.SetWideString(accountNo);
  FQuerySql8Command.Parameters[1].Value.SetWideString(sql);
  FQuerySql8Command.ExecuteUpdate;
  Result := FQuerySql8Command.Parameters[2].Value.GetWideString;
end;

function TServerMethods1Client.ExecuteSql(accountNo: String; sql: String): Boolean;
begin
  if FExecuteSqlCommand = nil then
  begin
    FExecuteSqlCommand := FDBXConnection.CreateCommand;
    FExecuteSqlCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FExecuteSqlCommand.Text := 'TServerMethods1.ExecuteSql';
    FExecuteSqlCommand.Prepare;
  end;
  FExecuteSqlCommand.Parameters[0].Value.SetWideString(accountNo);
  FExecuteSqlCommand.Parameters[1].Value.SetWideString(sql);
  FExecuteSqlCommand.ExecuteUpdate;
  Result := FExecuteSqlCommand.Parameters[2].Value.GetBoolean;
end;

function TServerMethods1Client.SaveData(accountNo: String; tableName: String; delta: OleVariant): Boolean;
begin
  if FSaveDataCommand = nil then
  begin
    FSaveDataCommand := FDBXConnection.CreateCommand;
    FSaveDataCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FSaveDataCommand.Text := 'TServerMethods1.SaveData';
    FSaveDataCommand.Prepare;
  end;
  FSaveDataCommand.Parameters[0].Value.SetWideString(accountNo);
  FSaveDataCommand.Parameters[1].Value.SetWideString(tableName);
  FSaveDataCommand.Parameters[2].Value.AsVariant := delta;
  FSaveDataCommand.ExecuteUpdate;
  Result := FSaveDataCommand.Parameters[3].Value.GetBoolean;
end;

function TServerMethods1Client.SaveData6(Delta: OleVariant; AccountNo: string; TableName: string; aWhere: string; noSaveFields: string): Boolean;
begin
  if FSaveData6Command = nil then
  begin
    FSaveData6Command := FDBXConnection.CreateCommand;
    FSaveData6Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FSaveData6Command.Text := 'TServerMethods1.SaveData6';
    FSaveData6Command.Prepare;
  end;
  FSaveData6Command.Parameters[0].Value.AsVariant := Delta;
  FSaveData6Command.Parameters[1].Value.SetWideString(AccountNo);
  FSaveData6Command.Parameters[2].Value.SetWideString(TableName);
  FSaveData6Command.Parameters[3].Value.SetWideString(aWhere);
  FSaveData6Command.Parameters[4].Value.SetWideString(noSaveFields);
  FSaveData6Command.ExecuteUpdate;
  Result := FSaveData6Command.Parameters[5].Value.GetBoolean;
end;

function TServerMethods1Client.SaveDatas6(AccountNo: string; tableNum: Integer; Deltas: OleVariant; TableNames: OleVariant; wheres: OleVariant; noSaveFields: OleVariant): Boolean;
begin
  if FSaveDatas6Command = nil then
  begin
    FSaveDatas6Command := FDBXConnection.CreateCommand;
    FSaveDatas6Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FSaveDatas6Command.Text := 'TServerMethods1.SaveDatas6';
    FSaveDatas6Command.Prepare;
  end;
  FSaveDatas6Command.Parameters[0].Value.SetWideString(AccountNo);
  FSaveDatas6Command.Parameters[1].Value.SetInt32(tableNum);
  FSaveDatas6Command.Parameters[2].Value.AsVariant := Deltas;
  FSaveDatas6Command.Parameters[3].Value.AsVariant := TableNames;
  FSaveDatas6Command.Parameters[4].Value.AsVariant := wheres;
  FSaveDatas6Command.Parameters[5].Value.AsVariant := noSaveFields;
  FSaveDatas6Command.ExecuteUpdate;
  Result := FSaveDatas6Command.Parameters[6].Value.GetBoolean;
end;

function TServerMethods1Client.SaveData2(accountNo: string; tableName: string; delta: TFDJSONDeltas): Boolean;
begin
  if FSaveData2Command = nil then
  begin
    FSaveData2Command := FDBXConnection.CreateCommand;
    FSaveData2Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FSaveData2Command.Text := 'TServerMethods1.SaveData2';
    FSaveData2Command.Prepare;
  end;
  FSaveData2Command.Parameters[0].Value.SetWideString(accountNo);
  FSaveData2Command.Parameters[1].Value.SetWideString(tableName);
  if not Assigned(delta) then
    FSaveData2Command.Parameters[2].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FSaveData2Command.Parameters[2].ConnectionHandler).GetJSONMarshaler;
    try
      FSaveData2Command.Parameters[2].Value.SetJSONValue(FMarshal.Marshal(delta), True);
      if FInstanceOwner then
        delta.Free
    finally
      FreeAndNil(FMarshal)
    end
  end;
  FSaveData2Command.ExecuteUpdate;
  Result := FSaveData2Command.Parameters[3].Value.GetBoolean;
end;

function TServerMethods1Client.SaveData3(accountNo: string; tableName: string; delta: TStream): Boolean;
begin
  if FSaveData3Command = nil then
  begin
    FSaveData3Command := FDBXConnection.CreateCommand;
    FSaveData3Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FSaveData3Command.Text := 'TServerMethods1.SaveData3';
    FSaveData3Command.Prepare;
  end;
  FSaveData3Command.Parameters[0].Value.SetWideString(accountNo);
  FSaveData3Command.Parameters[1].Value.SetWideString(tableName);
  FSaveData3Command.Parameters[2].Value.SetStream(delta, FInstanceOwner);
  FSaveData3Command.ExecuteUpdate;
  Result := FSaveData3Command.Parameters[3].Value.GetBoolean;
end;

function TServerMethods1Client.SaveData4(myUpdate: TMyUpdate): Boolean;
begin
  if FSaveData4Command = nil then
  begin
    FSaveData4Command := FDBXConnection.CreateCommand;
    FSaveData4Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FSaveData4Command.Text := 'TServerMethods1.SaveData4';
    FSaveData4Command.Prepare;
  end;
  if not Assigned(myUpdate) then
    FSaveData4Command.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FSaveData4Command.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FSaveData4Command.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(myUpdate), True);
      if FInstanceOwner then
        myUpdate.Free
    finally
      FreeAndNil(FMarshal)
    end
  end;
  FSaveData4Command.ExecuteUpdate;
  Result := FSaveData4Command.Parameters[1].Value.GetBoolean;
end;

function TServerMethods1Client.SaveData5(myUpdateList: TMyUpdateList): Boolean;
begin
  if FSaveData5Command = nil then
  begin
    FSaveData5Command := FDBXConnection.CreateCommand;
    FSaveData5Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FSaveData5Command.Text := 'TServerMethods1.SaveData5';
    FSaveData5Command.Prepare;
  end;
  if not Assigned(myUpdateList) then
    FSaveData5Command.Parameters[0].Value.SetNull
  else
  begin
    FMarshal := TDBXClientCommand(FSaveData5Command.Parameters[0].ConnectionHandler).GetJSONMarshaler;
    try
      FSaveData5Command.Parameters[0].Value.SetJSONValue(FMarshal.Marshal(myUpdateList), True);
      if FInstanceOwner then
        myUpdateList.Free
    finally
      FreeAndNil(FMarshal)
    end
  end;
  FSaveData5Command.ExecuteUpdate;
  Result := FSaveData5Command.Parameters[1].Value.GetBoolean;
end;

function TServerMethods1Client.SaveDatas(accountNo: String; tableNames: OleVariant; deltas: OleVariant; tableCount: Integer): Boolean;
begin
  if FSaveDatasCommand = nil then
  begin
    FSaveDatasCommand := FDBXConnection.CreateCommand;
    FSaveDatasCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FSaveDatasCommand.Text := 'TServerMethods1.SaveDatas';
    FSaveDatasCommand.Prepare;
  end;
  FSaveDatasCommand.Parameters[0].Value.SetWideString(accountNo);
  FSaveDatasCommand.Parameters[1].Value.AsVariant := tableNames;
  FSaveDatasCommand.Parameters[2].Value.AsVariant := deltas;
  FSaveDatasCommand.Parameters[3].Value.SetInt32(tableCount);
  FSaveDatasCommand.ExecuteUpdate;
  Result := FSaveDatasCommand.Parameters[4].Value.GetBoolean;
end;

function TServerMethods1Client.GetFieldValue(accountNo: String; sql: String): OleVariant;
begin
  if FGetFieldValueCommand = nil then
  begin
    FGetFieldValueCommand := FDBXConnection.CreateCommand;
    FGetFieldValueCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetFieldValueCommand.Text := 'TServerMethods1.GetFieldValue';
    FGetFieldValueCommand.Prepare;
  end;
  FGetFieldValueCommand.Parameters[0].Value.SetWideString(accountNo);
  FGetFieldValueCommand.Parameters[1].Value.SetWideString(sql);
  FGetFieldValueCommand.ExecuteUpdate;
  Result := FGetFieldValueCommand.Parameters[2].Value.AsVariant;
end;

function TServerMethods1Client.GetSetOfBook: OleVariant;
begin
  if FGetSetOfBookCommand = nil then
  begin
    FGetSetOfBookCommand := FDBXConnection.CreateCommand;
    FGetSetOfBookCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetSetOfBookCommand.Text := 'TServerMethods1.GetSetOfBook';
    FGetSetOfBookCommand.Prepare;
  end;
  FGetSetOfBookCommand.ExecuteUpdate;
  Result := FGetSetOfBookCommand.Parameters[0].Value.AsVariant;
end;

function TServerMethods1Client.GetSvrData(accountNo: String; defineId: String; inParams: OleVariant): OleVariant;
begin
  if FGetSvrDataCommand = nil then
  begin
    FGetSvrDataCommand := FDBXConnection.CreateCommand;
    FGetSvrDataCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetSvrDataCommand.Text := 'TServerMethods1.GetSvrData';
    FGetSvrDataCommand.Prepare;
  end;
  FGetSvrDataCommand.Parameters[0].Value.SetWideString(accountNo);
  FGetSvrDataCommand.Parameters[1].Value.SetWideString(defineId);
  FGetSvrDataCommand.Parameters[2].Value.AsVariant := inParams;
  FGetSvrDataCommand.ExecuteUpdate;
  Result := FGetSvrDataCommand.Parameters[3].Value.AsVariant;
end;

function TServerMethods1Client.spOpen(accountNo: String; spName: String; inParams: OleVariant): OleVariant;
begin
  if FspOpenCommand = nil then
  begin
    FspOpenCommand := FDBXConnection.CreateCommand;
    FspOpenCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FspOpenCommand.Text := 'TServerMethods1.spOpen';
    FspOpenCommand.Prepare;
  end;
  FspOpenCommand.Parameters[0].Value.SetWideString(accountNo);
  FspOpenCommand.Parameters[1].Value.SetWideString(spName);
  FspOpenCommand.Parameters[2].Value.AsVariant := inParams;
  FspOpenCommand.ExecuteUpdate;
  Result := FspOpenCommand.Parameters[3].Value.AsVariant;
end;

function TServerMethods1Client.spExec(accountNo: String; spName: String; inParams: OleVariant): Boolean;
begin
  if FspExecCommand = nil then
  begin
    FspExecCommand := FDBXConnection.CreateCommand;
    FspExecCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FspExecCommand.Text := 'TServerMethods1.spExec';
    FspExecCommand.Prepare;
  end;
  FspExecCommand.Parameters[0].Value.SetWideString(accountNo);
  FspExecCommand.Parameters[1].Value.SetWideString(spName);
  FspExecCommand.Parameters[2].Value.AsVariant := inParams;
  FspExecCommand.ExecuteUpdate;
  Result := FspExecCommand.Parameters[3].Value.GetBoolean;
end;

function TServerMethods1Client.spOpenOut(accountNo: String; spName: String; inParams: OleVariant): OleVariant;
begin
  if FspOpenOutCommand = nil then
  begin
    FspOpenOutCommand := FDBXConnection.CreateCommand;
    FspOpenOutCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FspOpenOutCommand.Text := 'TServerMethods1.spOpenOut';
    FspOpenOutCommand.Prepare;
  end;
  FspOpenOutCommand.Parameters[0].Value.SetWideString(accountNo);
  FspOpenOutCommand.Parameters[1].Value.SetWideString(spName);
  FspOpenOutCommand.Parameters[2].Value.AsVariant := inParams;
  FspOpenOutCommand.ExecuteUpdate;
  Result := FspOpenOutCommand.Parameters[3].Value.AsVariant;
end;

function TServerMethods1Client.spExecOut(accountNo: String; spName: String; inParams: OleVariant): OleVariant;
begin
  if FspExecOutCommand = nil then
  begin
    FspExecOutCommand := FDBXConnection.CreateCommand;
    FspExecOutCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FspExecOutCommand.Text := 'TServerMethods1.spExecOut';
    FspExecOutCommand.Prepare;
  end;
  FspExecOutCommand.Parameters[0].Value.SetWideString(accountNo);
  FspExecOutCommand.Parameters[1].Value.SetWideString(spName);
  FspExecOutCommand.Parameters[2].Value.AsVariant := inParams;
  FspExecOutCommand.ExecuteUpdate;
  Result := FspExecOutCommand.Parameters[3].Value.AsVariant;
end;

function TServerMethods1Client.spOpen2(accountNo: string; spName: string; inParams: string): TFDJSONDataSets;
begin
  if FspOpen2Command = nil then
  begin
    FspOpen2Command := FDBXConnection.CreateCommand;
    FspOpen2Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FspOpen2Command.Text := 'TServerMethods1.spOpen2';
    FspOpen2Command.Prepare;
  end;
  FspOpen2Command.Parameters[0].Value.SetWideString(accountNo);
  FspOpen2Command.Parameters[1].Value.SetWideString(spName);
  FspOpen2Command.Parameters[2].Value.SetWideString(inParams);
  FspOpen2Command.ExecuteUpdate;
  if not FspOpen2Command.Parameters[3].Value.IsNull then
  begin
    FUnMarshal := TDBXClientCommand(FspOpen2Command.Parameters[3].ConnectionHandler).GetJSONUnMarshaler;
    try
      Result := TFDJSONDataSets(FUnMarshal.UnMarshal(FspOpen2Command.Parameters[3].Value.GetJSONValue(True)));
      if FInstanceOwner then
        FspOpen2Command.FreeOnExecute(Result);
    finally
      FreeAndNil(FUnMarshal)
    end
  end
  else
    Result := nil;
end;

function TServerMethods1Client.echo(str: string): string;
begin
  if FechoCommand = nil then
  begin
    FechoCommand := FDBXConnection.CreateCommand;
    FechoCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FechoCommand.Text := 'TServerMethods1.echo';
    FechoCommand.Prepare;
  end;
  FechoCommand.Parameters[0].Value.SetWideString(str);
  FechoCommand.ExecuteUpdate;
  Result := FechoCommand.Parameters[1].Value.GetWideString;
end;

function TServerMethods1Client.DownLoadFile(fileName: string): TStream;
begin
  if FDownLoadFileCommand = nil then
  begin
    FDownLoadFileCommand := FDBXConnection.CreateCommand;
    FDownLoadFileCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FDownLoadFileCommand.Text := 'TServerMethods1.DownLoadFile';
    FDownLoadFileCommand.Prepare;
  end;
  FDownLoadFileCommand.Parameters[0].Value.SetWideString(fileName);
  FDownLoadFileCommand.ExecuteUpdate;
  Result := FDownLoadFileCommand.Parameters[1].Value.GetStream(FInstanceOwner);
end;

function TServerMethods1Client.UploadFile(Stream: TStream): Boolean;
begin
  if FUploadFileCommand = nil then
  begin
    FUploadFileCommand := FDBXConnection.CreateCommand;
    FUploadFileCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FUploadFileCommand.Text := 'TServerMethods1.UploadFile';
    FUploadFileCommand.Prepare;
  end;
  FUploadFileCommand.Parameters[0].Value.SetStream(Stream, FInstanceOwner);
  FUploadFileCommand.ExecuteUpdate;
  Result := FUploadFileCommand.Parameters[1].Value.GetBoolean;
end;

function TServerMethods1Client.DownLoadFile2(fileName: String): OleVariant;
begin
  if FDownLoadFile2Command = nil then
  begin
    FDownLoadFile2Command := FDBXConnection.CreateCommand;
    FDownLoadFile2Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FDownLoadFile2Command.Text := 'TServerMethods1.DownLoadFile2';
    FDownLoadFile2Command.Prepare;
  end;
  FDownLoadFile2Command.Parameters[0].Value.SetWideString(fileName);
  FDownLoadFile2Command.ExecuteUpdate;
  Result := FDownLoadFile2Command.Parameters[1].Value.AsVariant;
end;

function TServerMethods1Client.UploadFile2(Stream: OleVariant; FileName: String): Boolean;
begin
  if FUploadFile2Command = nil then
  begin
    FUploadFile2Command := FDBXConnection.CreateCommand;
    FUploadFile2Command.CommandType := TDBXCommandTypes.DSServerMethod;
    FUploadFile2Command.Text := 'TServerMethods1.UploadFile2';
    FUploadFile2Command.Prepare;
  end;
  FUploadFile2Command.Parameters[0].Value.AsVariant := Stream;
  FUploadFile2Command.Parameters[1].Value.SetWideString(FileName);
  FUploadFile2Command.ExecuteUpdate;
  Result := FUploadFile2Command.Parameters[2].Value.GetBoolean;
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

constructor TServerMethods1Client.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

destructor TServerMethods1Client.Destroy;
begin
  FDataModuleCreateCommand.DisposeOf;
  FDataModuleDestroyCommand.DisposeOf;
  FGetServerDateCommand.DisposeOf;
  FQuerySqlCommand.DisposeOf;
  FQuerySql6Command.DisposeOf;
  FQuerySqlsCommand.DisposeOf;
  FQuerySql2Command.DisposeOf;
  FQuerySql3Command.DisposeOf;
  FQuerySql4Command.DisposeOf;
  FQuerySql5Command.DisposeOf;
  FQuerySql8Command.DisposeOf;
  FExecuteSqlCommand.DisposeOf;
  FSaveDataCommand.DisposeOf;
  FSaveData6Command.DisposeOf;
  FSaveDatas6Command.DisposeOf;
  FSaveData2Command.DisposeOf;
  FSaveData3Command.DisposeOf;
  FSaveData4Command.DisposeOf;
  FSaveData5Command.DisposeOf;
  FSaveDatasCommand.DisposeOf;
  FGetFieldValueCommand.DisposeOf;
  FGetSetOfBookCommand.DisposeOf;
  FGetSvrDataCommand.DisposeOf;
  FspOpenCommand.DisposeOf;
  FspExecCommand.DisposeOf;
  FspOpenOutCommand.DisposeOf;
  FspExecOutCommand.DisposeOf;
  FspOpen2Command.DisposeOf;
  FechoCommand.DisposeOf;
  FDownLoadFileCommand.DisposeOf;
  FUploadFileCommand.DisposeOf;
  FDownLoadFile2Command.DisposeOf;
  FUploadFile2Command.DisposeOf;
  inherited;
end;

end.

