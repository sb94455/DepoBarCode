// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://221.224.62.236:280/U8BarCodeWebService/ProduceOrderService.asmx?wsdl
//  >Import : http://221.224.62.236:280/U8BarCodeWebService/ProduceOrderService.asmx?wsdl>0
// Encoding : utf-8
// Version  : 1.0
// (2017/11/14 23:13:55 - - $Rev: 90173 $)
// ************************************************************************ //

unit ProduceOrderService;

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
  // binding   : ProduceOrderServiceSoap
  // service   : ProduceOrderService
  // port      : ProduceOrderServiceSoap
  // URL       : http://221.224.62.236/U8BarCodeWebService/ProduceOrderService.asmx
  // ************************************************************************ //
  ProduceOrderServiceSoap = interface(IInvokable)
  ['{1DA2986E-5B10-E709-FB21-9B94779786C8}']
    function  QueryProduceOrdersNotInByOrderNo(const orderNo: string): string; stdcall;
    function  QueryProduceOrdersPartInfos(const modId: string): string; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : ProduceOrderServiceHttpGet
  // service   : ProduceOrderService
  // port      : ProduceOrderServiceHttpGet
  // ************************************************************************ //
  ProduceOrderServiceHttpGet = interface(IInvokable)
  ['{BB21EFD6-56F9-7DEA-B7CD-A75128B0CEE1}']
    function  QueryProduceOrdersNotInByOrderNo(const orderNo: string): string_; stdcall;
    function  QueryProduceOrdersPartInfos(const modId: string): string_; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : ProduceOrderServiceHttpPost
  // service   : ProduceOrderService
  // port      : ProduceOrderServiceHttpPost
  // ************************************************************************ //
  ProduceOrderServiceHttpPost = interface(IInvokable)
  ['{1EC3A26D-8261-A02F-CF11-4E2D2303F6F9}']
    function  QueryProduceOrdersNotInByOrderNo(const orderNo: string): string_; stdcall;
    function  QueryProduceOrdersPartInfos(const modId: string): string_; stdcall;
  end;

function GetProduceOrderServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ProduceOrderServiceSoap;
function GetProduceOrderServiceHttpGet(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ProduceOrderServiceHttpGet;
function GetProduceOrderServiceHttpPost(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ProduceOrderServiceHttpPost;


implementation
  uses System.SysUtils;

function GetProduceOrderServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ProduceOrderServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/ProduceOrderService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/ProduceOrderService.asmx';
  defSvc  = 'ProduceOrderService';
  defPrt  = 'ProduceOrderServiceSoap';
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
    Result := (RIO as ProduceOrderServiceSoap);
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


function GetProduceOrderServiceHttpGet(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ProduceOrderServiceHttpGet;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/ProduceOrderService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'ProduceOrderService';
  defPrt  = 'ProduceOrderServiceHttpGet';
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
    Result := (RIO as ProduceOrderServiceHttpGet);
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


function GetProduceOrderServiceHttpPost(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ProduceOrderServiceHttpPost;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/ProduceOrderService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'ProduceOrderService';
  defPrt  = 'ProduceOrderServiceHttpPost';
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
    Result := (RIO as ProduceOrderServiceHttpPost);
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
  { ProduceOrderServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(ProduceOrderServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ProduceOrderServiceSoap), 'http://tempuri.org/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ProduceOrderServiceSoap), ioDocument);
  { ProduceOrderServiceSoap.QueryProduceOrdersNotInByOrderNo }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProduceOrderServiceSoap), 'QueryProduceOrdersNotInByOrderNo', '',
                                 '[ReturnName="QueryProduceOrdersNotInByOrderNoResult"]', IS_OPTN);
  { ProduceOrderServiceSoap.QueryProduceOrdersPartInfos }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProduceOrderServiceSoap), 'QueryProduceOrdersPartInfos', '',
                                 '[ReturnName="QueryProduceOrdersPartInfosResult"]', IS_OPTN);
  { ProduceOrderServiceHttpGet }
  InvRegistry.RegisterInterface(TypeInfo(ProduceOrderServiceHttpGet), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ProduceOrderServiceHttpGet), '');
  { ProduceOrderServiceHttpPost }
  InvRegistry.RegisterInterface(TypeInfo(ProduceOrderServiceHttpPost), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ProduceOrderServiceHttpPost), '');
  RemClassRegistry.RegisterXSInfo(TypeInfo(string_), 'http://tempuri.org/', 'string_', 'string');

end.
