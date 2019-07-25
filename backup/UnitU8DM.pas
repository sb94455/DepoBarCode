unit UnitU8DM;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, IPPeerClient, Soap.InvokeRegistry,
  LoginService, Soap.Rio, Soap.SOAPHTTPClient, FMX.Forms, System.Messaging,
  Inifiles, IOUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.Phys.DS, FireDAC.Phys.DSDef, FireDAC.VCLUI.Wait;

type
  TExeStatus = (esReady, esWaiting);

  TU8DM = class(TDataModule)
    HTTPRIO1: THTTPRIO;
    fdm_Dict: TFDMemTable;
    FDConnection1: TFDConnection;
    FDStoredProc1: TFDStoredProc;
    ds_Dict: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
//    FLoginObj: TLoginObjEx;
//    FSaleOutObj: TSaleOutObjEx;
//    FStockObj: TStockObjEx;
//    FInventoryObj: TInventoryObjEx;
//    FPositionObj: TPositionObjEx;
    MessageManager: TMessageManager;
//    FProductInObjEx: TProductInObjEx;
    procedure ListenerMethod(const Sender: TObject; const M: TMessage); virtual;
    procedure ReadServerAddr;
  public
    MsgText: string;
    procedure ExecSql(ft1: TFDMemTable; strSql: string);
    function GetADTable(strTbName: string): TFDMemTable;
    procedure ExecSqlADTable(ft1: TFDMemTable; strTbName: string);
//    property ProductInObj: TProductInObjEx read FProductInObjEx write FProductInObjEx;
//    property SaleOutObj: TSaleOutObjEx read FSaleOutObj write FSaleOutObj;
//    property StockObj: TStockObjEx read FStockObj write FStockObj;
//    property PositionObj: TPositionObjEx read FPositionObj write FPositionObj;
    //Property InventoryObj : TInventoryObjEx Read FInventoryObj Write FInventoryObj;
  end;

var
  U8DM: TU8DM;

implementation

uses
  UnitLib;
{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TU8DM.DataModuleCreate(Sender: TObject);
begin
  ReadServerAddr;
//  FItemMsg := TItemMsg.Create;
//  FLoginObj := TLoginObjEx.Create;
  MessageManager := TMessageManager.DefaultManager;
  MessageManager.SubscribeToMessage(TMessage<Integer>, Self.ListenerMethod);

end;

function TU8DM.GetADTable(strTbName: string): TFDMemTable;
begin
  Result := TFDMemTable.Create(nil);
  ExecSqlADTable(Result, strTbName);
end;

procedure TU8DM.ExecSqlADTable(ft1: TFDMemTable; strTbName: string);
var
  strSql: string;
begin
  strSql := 'select * from SZHL_ItmDef where tableid in (select tableid from SZHL_TableDef where name=''' + Trim(strTbName) + ''') order by seq';
  ExecSql(ft1, strSql);
end;

procedure TU8DM.ExecSql(ft1: TFDMemTable; strSql: string);
begin
  FDConnection1.Connected := True;
  FDStoredProc1.Close;
  FDStoredProc1.Unprepare;
  FDStoredProc1.StoredProcName := 'TServerMethods1.GetData';
  FDStoredProc1.Prepare;
  FDStoredProc1.ParamByName('sqlstr').Value := strSql; // 'select * from SZHL_ItmDef where tableid in (select tableid from SZHL_TableDef where name=''' + Trim(strTbName) + ''') order by seq';
  FDStoredProc1.Open;
  ft1.Close;
  ft1.Data := FDStoredProc1.Data;
  FDStoredProc1.Close;
end;

procedure TU8DM.ListenerMethod(const Sender: TObject; const M: TMessage);
begin

end;

procedure TU8DM.ReadServerAddr;
var
  IniFile: TIniFile;
begin
  try
    IniFile := TIniFile.Create(TPath.GetHomePath + '\U8AndServer.ini');
    AppServer := IniFile.ReadString('Config', 'ServerAddr', AppServer);

  finally
    FreeAndNil(IniFile);
  end;
end;

end.

