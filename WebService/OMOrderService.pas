// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://221.224.62.236:280/U8BarCodeWebService/OMOrderService.asmx?wsdl
//  >Import : http://221.224.62.236:280/U8BarCodeWebService/OMOrderService.asmx?wsdl>0
// Encoding : utf-8
// Version  : 1.0
// (2017/11/16 14:02:47 - - $Rev: 90173 $)
// ************************************************************************ //

unit OMOrderService;

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
  // binding   : OMOrderServiceSoap
  // service   : OMOrderService
  // port      : OMOrderServiceSoap
  // URL       : http://221.224.62.236/U8BarCodeWebService/OMOrderService.asmx
  // ************************************************************************ //
  OMOrderServiceSoap = interface(IInvokable)
  ['{B5688ACF-7C67-39BA-1DFB-2DC18E47727B}']
    function  Query(const xml: string): string; stdcall;
    function  QueryDetail(const id: string): string; stdcall;
    function  QueryDetailMaterials(const id: string): string; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : OMOrderServiceHttpGet
  // service   : OMOrderService
  // port      : OMOrderServiceHttpGet
  // ************************************************************************ //
  OMOrderServiceHttpGet = interface(IInvokable)
  ['{F1E7F459-E8D6-7E5D-B5CF-B380A45C8266}']
    function  Query(const xml: string): string_; stdcall;
    function  QueryDetail(const id: string): string_; stdcall;
    function  QueryDetailMaterials(const id: string): string_; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : OMOrderServiceHttpPost
  // service   : OMOrderService
  // port      : OMOrderServiceHttpPost
  // ************************************************************************ //
  OMOrderServiceHttpPost = interface(IInvokable)
  ['{D80A5213-E69C-28C8-4C8F-E04A70B6CAD6}']
    function  Query(const xml: string): string_; stdcall;
    function  QueryDetail(const id: string): string_; stdcall;
    function  QueryDetailMaterials(const id: string): string_; stdcall;
  end;

function GetOMOrderServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): OMOrderServiceSoap;
function GetOMOrderServiceHttpGet(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): OMOrderServiceHttpGet;
function GetOMOrderServiceHttpPost(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): OMOrderServiceHttpPost;


implementation
  uses System.SysUtils;

function GetOMOrderServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): OMOrderServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/OMOrderService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/OMOrderService.asmx';
  defSvc  = 'OMOrderService';
  defPrt  = 'OMOrderServiceSoap';
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
    Result := (RIO as OMOrderServiceSoap);
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


function GetOMOrderServiceHttpGet(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): OMOrderServiceHttpGet;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/OMOrderService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'OMOrderService';
  defPrt  = 'OMOrderServiceHttpGet';
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
    Result := (RIO as OMOrderServiceHttpGet);
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


function GetOMOrderServiceHttpPost(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): OMOrderServiceHttpPost;
const
  defWSDL = 'http://221.224.62.236/U8BarCodeWebService/OMOrderService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'OMOrderService';
  defPrt  = 'OMOrderServiceHttpPost';
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
    Result := (RIO as OMOrderServiceHttpPost);
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
  { OMOrderServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(OMOrderServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(OMOrderServiceSoap), 'http://tempuri.org/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(OMOrderServiceSoap), ioDocument);
  { OMOrderServiceSoap.Query }
  InvRegistry.RegisterMethodInfo(TypeInfo(OMOrderServiceSoap), 'Query', '',
                                 '[ReturnName="QueryResult"]', IS_OPTN);
  { OMOrderServiceSoap.QueryDetail }
  InvRegistry.RegisterMethodInfo(TypeInfo(OMOrderServiceSoap), 'QueryDetail', '',
                                 '[ReturnName="QueryDetailResult"]', IS_OPTN);
  { OMOrderServiceSoap.QueryDetailMaterials }
  InvRegistry.RegisterMethodInfo(TypeInfo(OMOrderServiceSoap), 'QueryDetailMaterials', '',
                                 '[ReturnName="QueryDetailMaterialsResult"]', IS_OPTN);
  { OMOrderServiceHttpGet }
  InvRegistry.RegisterInterface(TypeInfo(OMOrderServiceHttpGet), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(OMOrderServiceHttpGet), '');
  { OMOrderServiceHttpPost }
  InvRegistry.RegisterInterface(TypeInfo(OMOrderServiceHttpPost), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(OMOrderServiceHttpPost), '');
  RemClassRegistry.RegisterXSInfo(TypeInfo(string_), 'http://tempuri.org/', 'string_', 'string');

end.