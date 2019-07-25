{*******************************************************
ȫ�ֶ��� ���¹�
*******************************************************}

unit untGlobal;

interface

uses
  System.SysUtils,  Datasnap.DBClient,
  firedac.stan.param, db, System.Variants, System.ZLib, System.Classes, Data.FireDACJSONReflect,
  System.Generics.Collections;

type
  TMyUpdate = class(TObject)
  public
    AccountNo: string;
    TableName: string;
    Delta: TFDJSONDeltas;
  end;

type
  TMyUpdateList = class(TList<TMyUpdate>)
  public
    destructor Destroy; override;
  end;

type
  TMyInfo = class(TObject)
  public
    AccountNo: string;
    SQL: string;
    Params: string;
  end;

type
  TMyInfoList = class(TList<TMyInfo>)
  public
    destructor Destroy; override;
  end;

type
  TDBParams = record    // ���ݿ����
    driveId: string;     // ora,mssql,mysql...
    ip: string;          // ���ݿ������ip
    database: string;    // ���ݿ���
    user: string;        // ���ݿ��ʺ�
    password: string;    // ���ݿ�����
    accountNo: string;    // ���ױ��
    accountName: string;  // ��������
  end;

type
  TPoolParams = record      // �ز���
    poolSize: Integer;      // Ĭ�ϳ�����
    maxValue: Integer;      // ��������
    timeout: Integer;       // ��ʱʱ��
  end;

type
  TBrokerParams = record    // �������������
    active: Integer;        // �Ƿ�����
    ip: string;             // ���������IP
    port: Word;             // ����������˿�
  end;

type
  TLocalParams = record   // ���м������
    tcpIp: string;        // TCP Э��
    tcpPort: Word;
    httpIp: string;       // HTTP Э��
    httpPort: Word;
  end;

type
  TAuthParams = record     // ��½�м����֤����
    user: string;          // �ʺ�
    password: string;      // ����
  end;

function GetGuidID: string;
// TFDParams����ΪOleVariant

function PackageFDParams(Params: TFDParams; Types: TParamTypes = AllParamTypes): OleVariant;
// ��OleVariant��ԭTFDParams

procedure UnpackFDParams(const Source: OleVariant; Dest: TFDParams);

procedure StreamToVariant(Stream: TStream; var V: OLEVariant);

procedure VariantToStream(const V: OLEVariant; Stream: TStream);

function CompressData(V: OleVariant): OleVariant;

function DeCompressData(V: OleVariant): OleVariant;

function CopyStream(const AStream: TStream): TMemoryStream;

var
  DBParams: TDBParams;           // ���ݿ����
  poolParams: TPoolParams;       // �ز���
  brokerParams: TBrokerParams;   // �������������
  localParams: TLocalParams;     // ���м������
  authParams: TAuthParams;       // ��֤����
  cdsMultiDB: TClientDataSet;  // �������ڴ��
  cdsPlug: TClientDataSet;    // ����ڴ��
  g_plug_path: string;        // ���·��

implementation

function CopyStream(const AStream: TStream): TMemoryStream;
const
  LBufSize = $F000;
var
  LBuffer: TBytes;
  LReadLen: Integer;
begin
  Result := nil;
  if AStream = nil then
    Exit;
  Result := TMemoryStream.Create;
  try
    if AStream.Size = -1 then
    begin
      SetLength(LBuffer, LBufSize);
      repeat
        LReadLen := AStream.Read(lBuffer[0], LBufSize);
        if LReadLen > 0 then
          Result.WriteBuffer(LBuffer[0], LReadLen);
        if LReadLen < LBufSize then
          break;
      until LReadLen < LBufSize;
    end
    else
      Result.CopyFrom(AStream, 0);
    Result.Position := 0;
  except
    Result.Free;
  end;
end;

function DeCompressData(V: OleVariant): OleVariant;
var
  M, M0: TMemoryStream;
begin
  M := TMemoryStream.Create;
  M0 := TMemoryStream.Create;
  try
    if V = Null then
      exit;
    VariantToStream(V, M);
    M.Position := 0;
    ZDeCompressStream(M, M0);
    StreamToVariant(M0, V);
  finally
    M.Free;
    M0.Free
  end;
  Result := V;
end;

function CompressData(V: OleVariant): OleVariant;
var
  M, M0: TMemoryStream;
begin
  M := TMemoryStream.Create;
  M0 := TMemoryStream.Create;
  try
    if V = Null then
      exit;
    VariantToStream(V, M);
    M.Position := 0;
    ZCompressStream(M, M0);
    StreamToVariant(M0, V);
  finally
    M.Free;
    M0.Free
  end;
  Result := V;
end;

procedure StreamToVariant(Stream: TStream; var V: OLEVariant);
var
  P: Pointer;
begin
  V := VarArrayCreate([0, Stream.Size - 1], varByte);
  P := VarArrayLock(V);
  Stream.Position := 0;
  Stream.Read(P^, Stream.Size);
  VarArrayUnlock(V);
end;

procedure VariantToStream(const V: OLEVariant; Stream: TStream);
var
  P: Pointer;
begin
  Stream.Position := 0;
  Stream.Size := VarArrayHighBound(V, 1) - VarArrayLowBound(V, 1) + 1;
  P := VarArrayLock(V);
  Stream.Write(P^, Stream.Size);
  VarArrayUnlock(V);
  Stream.Position := 0;
end;

function PackageFDParams(Params: TFDParams; Types: TParamTypes = AllParamTypes): OleVariant;
var
  I, Idx, Count: Integer;
begin
  Result := NULL;
  Count := 0;
  for I := 0 to Params.Count - 1 do
    if Params[I].ParamType in Types then
      Inc(Count);
  if Count > 0 then
  begin
    Idx := 0;
    Result := VarArrayCreate([0, Count - 1], varVariant);
    for I := 0 to Params.Count - 1 do
      if Params[I].ParamType in Types then
      begin
        if VarIsCustom(Params[I].Value) then
          Result[Idx] := VarArrayOf([Params[I].Name, VarToStr(Params[I].Value), Ord(Params[I].DataType), Ord(Params[I].ParamType), Params[I].Size, Params[I].Precision, Params[I].NumericScale])
        else
          Result[Idx] := VarArrayOf([Params[I].Name, Params[I].Value, Ord(Params[I].DataType), Ord(Params[I].ParamType), Params[I].Size, Params[I].Precision, Params[I].NumericScale]);
        Inc(Idx);
      end;
  end;
end;

procedure UnpackFDParams(const Source: OleVariant; Dest: TFDParams);
var
  TempParams: TFDParams;
  HighBound, I: Integer;
  LParam: TFDParam;
begin
  if not VarIsNull(Source) and VarIsArray(Source) and VarIsArray(Source[0]) then
  begin
    TempParams := TFDParams.Create;
    try
      for I := 0 to VarArrayHighBound(Source, 1) do
      begin
        HighBound := VarArrayHighBound(Source[I], 1);
        LParam := TempParams.Add;
        LParam.Name := Source[I][0];
        if HighBound > 1 then
          LParam.DataType := TFieldType(Source[I][2]);
        if HighBound > 2 then
          LParam.ParamType := TParamType(Source[I][3]);
        if HighBound > 3 then
          LParam.Size := Source[I][4];
        if HighBound > 4 then
          LParam.Precision := Source[I][5];
        if HighBound > 5 then
          LParam.NumericScale := Source[I][6];
        LParam.Value := Source[I][1];  // Value must be set last
      end;
      Dest.Assign(TempParams);
    finally
      TempParams.Free;
    end;
  end;
end;

function GetGuidID: string;
var
  AGUID: TGUID;
begin
  CreateGUID(AGUID);
  Result := GUIDToString(AGUID);
end;

{ TMyInfoList }

destructor TMyInfoList.Destroy;
begin
  while self.Count > 0 do
  begin
    Self[0].Free;
    Self.Delete(0);
  end;
  inherited Destroy;
end;

{ TMyUpdateList }

destructor TMyUpdateList.Destroy;
begin
  while self.Count > 0 do
  begin
    Self[0].Free;
    Self.Delete(0);
  end;
  inherited Destroy;
end;

initialization
  // �����·��
//  g_plug_path := ExtractFilePath(Application.ExeName) + 'plug\';
  cdsMultiDB := TClientDataSet.Create(nil);
  // ��������ڴ��
  cdsPlug := TClientDataSet.Create(nil);

finalization
  FreeAndNil(cdsMultiDB);
  FreeAndNil(cdsPlug);

end.


