// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://szhlrj.com:280/U8BarCodeWebService/BaseDataService.asmx?wsdl
//  >Import : http://szhlrj.com:280/U8BarCodeWebService/BaseDataService.asmx?wsdl>0
// Encoding : utf-8
// Codegen  : [wfForceSOAP12+]
// Version  : 1.0
// (2017/7/1 17:35:44 - - $Rev: 86412 $)
// ************************************************************************ //

unit BaseDataService;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

const
  IS_OPTN = $0001;
  IS_REF  = $0080;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]


  string_         =  type string;      { "http://tempuri.org/"[GblElm] }

  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // soapAction: http://tempuri.org/%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : BaseDataServiceSoap12
  // service   : BaseDataService
  // port      : BaseDataServiceSoap12
  // URL       : http://szhlrj.com/U8BarCodeWebService/BaseDataService.asmx
  // ************************************************************************ //
  BaseDataServiceSoap = interface(IInvokable)
  ['{03FD04ED-CFA7-A531-4B27-9DCB82ED0B99}']
    function  QueryInventory(const queryValue: string): string; stdcall;
    function  QueryWareHouse(const queryValue: string): string; stdcall;
    function  QueryPosition(const queryValue: string): string; stdcall;
    function  QueryPositionByWareHouse(const wareHouse: string; const position: string): string; stdcall;
    function  QueryInvPositionSum(const cInvCode: string; const cWhCode: string; const cFree1: string; const cFree2: string; const cFree3: string; const cPosCode: string
                                  ): string; stdcall;
    function  QueryInvPositionSumByModId(const modId: string): string; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : BaseDataServiceHttpGet
  // service   : BaseDataService
  // port      : BaseDataServiceHttpGet
  // ************************************************************************ //
  BaseDataServiceHttpGet = interface(IInvokable)
  ['{5D04FF75-3D74-D555-100F-A98A75C01B3C}']
    function  QueryInventory(const queryValue: string): string_; stdcall;
    function  QueryWareHouse(const queryValue: string): string_; stdcall;
    function  QueryPosition(const queryValue: string): string_; stdcall;
    function  QueryPositionByWareHouse(const wareHouse: string; const position: string): string_; stdcall;
    function  QueryInvPositionSum(const cInvCode: string; const cWhCode: string; const cFree1: string; const cFree2: string; const cFree3: string; const cPosCode: string
                                  ): string_; stdcall;
    function  QueryInvPositionSumByModId(const modId: string): string_; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : BaseDataServiceHttpPost
  // service   : BaseDataService
  // port      : BaseDataServiceHttpPost
  // ************************************************************************ //
  BaseDataServiceHttpPost = interface(IInvokable)
  ['{891189D1-9687-878F-15CB-962E02B43FBD}']
    function  QueryInventory(const queryValue: string): string_; stdcall;
    function  QueryWareHouse(const queryValue: string): string_; stdcall;
    function  QueryPosition(const queryValue: string): string_; stdcall;
    function  QueryPositionByWareHouse(const wareHouse: string; const position: string): string_; stdcall;
    function  QueryInvPositionSum(const cInvCode: string; const cWhCode: string; const cFree1: string; const cFree2: string; const cFree3: string; const cPosCode: string
                                  ): string_; stdcall;
    function  QueryInvPositionSumByModId(const modId: string): string_; stdcall;
  end;

function GetBaseDataServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): BaseDataServiceSoap;
function GetBaseDataServiceHttpGet(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): BaseDataServiceHttpGet;
function GetBaseDataServiceHttpPost(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): BaseDataServiceHttpPost;


implementation
  uses System.SysUtils;

function GetBaseDataServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): BaseDataServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/BaseDataService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/BaseDataService.asmx';
  defSvc  = 'BaseDataService';
  defPrt  = 'BaseDataServiceSoap12';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as BaseDataServiceSoap);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


function GetBaseDataServiceHttpGet(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): BaseDataServiceHttpGet;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/BaseDataService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'BaseDataService';
  defPrt  = 'BaseDataServiceHttpGet';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as BaseDataServiceHttpGet);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


function GetBaseDataServiceHttpPost(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): BaseDataServiceHttpPost;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/BaseDataService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'BaseDataService';
  defPrt  = 'BaseDataServiceHttpPost';
var
  RIO: THTTPRIO;
begin
  Result := nil;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := defURL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    Result := (RIO as BaseDataServiceHttpPost);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  { BaseDataServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(BaseDataServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(BaseDataServiceSoap), 'http://tempuri.org/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(BaseDataServiceSoap), ioDocument);
  InvRegistry.RegisterInvokeOptions(TypeInfo(BaseDataServiceSoap), ioSOAP12);
  { BaseDataServiceSoap.QueryInventory }
  InvRegistry.RegisterMethodInfo(TypeInfo(BaseDataServiceSoap), 'QueryInventory', '',
                                 '[ReturnName="QueryInventoryResult"]', IS_OPTN);
  { BaseDataServiceSoap.QueryWareHouse }
  InvRegistry.RegisterMethodInfo(TypeInfo(BaseDataServiceSoap), 'QueryWareHouse', '',
                                 '[ReturnName="QueryWareHouseResult"]', IS_OPTN);
  { BaseDataServiceSoap.QueryPosition }
  InvRegistry.RegisterMethodInfo(TypeInfo(BaseDataServiceSoap), 'QueryPosition', '',
                                 '[ReturnName="QueryPositionResult"]', IS_OPTN);
  { BaseDataServiceSoap.QueryPositionByWareHouse }
  InvRegistry.RegisterMethodInfo(TypeInfo(BaseDataServiceSoap), 'QueryPositionByWareHouse', '',
                                 '[ReturnName="QueryPositionByWareHouseResult"]', IS_OPTN);
  { BaseDataServiceSoap.QueryInvPositionSum }
  InvRegistry.RegisterMethodInfo(TypeInfo(BaseDataServiceSoap), 'QueryInvPositionSum', '',
                                 '[ReturnName="QueryInvPositionSumResult"]', IS_OPTN);
  { BaseDataServiceSoap.QueryInvPositionSumByModId }
  InvRegistry.RegisterMethodInfo(TypeInfo(BaseDataServiceSoap), 'QueryInvPositionSumByModId', '',
                                 '[ReturnName="QueryInvPositionSumByModIdResult"]', IS_OPTN);
  { BaseDataServiceHttpGet }
  InvRegistry.RegisterInterface(TypeInfo(BaseDataServiceHttpGet), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(BaseDataServiceHttpGet), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(BaseDataServiceHttpGet), ioSOAP12);
  { BaseDataServiceHttpPost }
  InvRegistry.RegisterInterface(TypeInfo(BaseDataServiceHttpPost), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(BaseDataServiceHttpPost), '');
  InvRegistry.RegisterInvokeOptions(TypeInfo(BaseDataServiceHttpPost), ioSOAP12);
  RemClassRegistry.RegisterXSInfo(TypeInfo(string_), 'http://tempuri.org/', 'string_', 'string');

end.
