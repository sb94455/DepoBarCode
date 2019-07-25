// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://221.224.62.236:280/U8BarCodeWebService/PurchaseInService.asmx?wsdl
//  >Import : http://221.224.62.236:280/U8BarCodeWebService/PurchaseInService.asmx?wsdl>0
// Encoding : utf-8
// Version  : 1.0
// (2017/11/11 11:48:40 - - $Rev: 90173 $)
// ************************************************************************ //

unit PurchaseInService;

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
  // binding   : PurchaseInServiceSoap
  // service   : PurchaseInService
  // port      : PurchaseInServiceSoap
  // URL       : http://221.224.62.236/U8BarCodeWebService/PurchaseInService.asmx
  // ************************************************************************ //
  PurchaseInServiceSoap = interface(IInvokable)
  ['{117ED237-A010-D6A5-17CD-0D89501FA65A}']
    function  Update(const xml: string): string; stdcall;
    function  Insert(const xml: string): string; stdcall;
    function  InsertOut(const xml: string): string; stdcall;
    function  Delete(const id: string): string; stdcall;
    function  Query(const xml: string): string; stdcall;
    function  QueryDetail(const id: string): string; stdcall;
    function  QueryOut(const xml: string): string; stdcall;
    function  QueryOutDetail(const id: string): string; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : PurchaseInServiceHttpGet
  // service   : PurchaseInService
  // port      : PurchaseInServiceHttpGet
  // ************************************************************************ //
  PurchaseInServiceHttpGet = interface(IInvokable)
  ['{347C10CB-7ED5-F127-CC85-F6D56C9A4D14}']
    function  Update(const xml: string): string_; stdcall;
    function  Insert(const xml: string): string_; stdcall;
    function  InsertOut(const xml: string): string_; stdcall;
    function  Delete(const id: string): string_; stdcall;
    function  Query(const xml: string): string_; stdcall;
    function  QueryDetail(const id: string): string_; stdcall;
    function  QueryOut(const xml: string): string_; stdcall;
    function  QueryOutDetail(const id: string): string_; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : PurchaseInServiceHttpPost
  // service   : PurchaseInService
  // port      : PurchaseInServiceHttpPost
  // ************************************************************************ //
  PurchaseInServiceHttpPost = interface(IInvokable)
  ['{8B341CDC-2F62-123B-2734-B5728CE8FA7E}']
    function  Update(const xml: string): string_; stdcall;
    function  Insert(const xml: string): string_; stdcall;
    function  InsertOut(const xml: string): string_; stdcall;
    function  Delete(const id: string): string_; stdcall;
    function  Query(const xml: string): string_; stdcall;
    function  QueryDetail(const id: string): string_; stdcall;
    function  QueryOut(const xml: string): string_; stdcall;
    function  QueryOutDetail(const id: string): string_; stdcall;
  end;

function GetPurchaseInServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): PurchaseInServiceSoap;
function GetPurchaseInServiceHttpGet(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): PurchaseInServiceHttpGet;
function GetPurchaseInServiceHttpPost(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): PurchaseInServiceHttpPost;


implementation
  uses System.SysUtils;

function GetPurchaseInServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): PurchaseInServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/PurchaseInService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/PurchaseInService.asmx';
  defSvc  = 'PurchaseInService';
  defPrt  = 'PurchaseInServiceSoap';
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
    Result := (RIO as PurchaseInServiceSoap);
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


function GetPurchaseInServiceHttpGet(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): PurchaseInServiceHttpGet;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/PurchaseInService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'PurchaseInService';
  defPrt  = 'PurchaseInServiceHttpGet';
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
    Result := (RIO as PurchaseInServiceHttpGet);
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


function GetPurchaseInServiceHttpPost(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): PurchaseInServiceHttpPost;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/PurchaseInService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'PurchaseInService';
  defPrt  = 'PurchaseInServiceHttpPost';
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
    Result := (RIO as PurchaseInServiceHttpPost);
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
  { PurchaseInServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(PurchaseInServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(PurchaseInServiceSoap), 'http://tempuri.org/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(PurchaseInServiceSoap), ioDocument);
  { PurchaseInServiceSoap.Update }
  InvRegistry.RegisterMethodInfo(TypeInfo(PurchaseInServiceSoap), 'Update', '',
                                 '[ReturnName="UpdateResult"]', IS_OPTN);
  { PurchaseInServiceSoap.Insert }
  InvRegistry.RegisterMethodInfo(TypeInfo(PurchaseInServiceSoap), 'Insert', '',
                                 '[ReturnName="InsertResult"]', IS_OPTN);
  { PurchaseInServiceSoap.InsertOut }
  InvRegistry.RegisterMethodInfo(TypeInfo(PurchaseInServiceSoap), 'InsertOut', '',
                                 '[ReturnName="InsertOutResult"]', IS_OPTN);
  { PurchaseInServiceSoap.Delete }
  InvRegistry.RegisterMethodInfo(TypeInfo(PurchaseInServiceSoap), 'Delete', '',
                                 '[ReturnName="DeleteResult"]', IS_OPTN);
  { PurchaseInServiceSoap.Query }
  InvRegistry.RegisterMethodInfo(TypeInfo(PurchaseInServiceSoap), 'Query', '',
                                 '[ReturnName="QueryResult"]', IS_OPTN);
  { PurchaseInServiceSoap.QueryDetail }
  InvRegistry.RegisterMethodInfo(TypeInfo(PurchaseInServiceSoap), 'QueryDetail', '',
                                 '[ReturnName="QueryDetailResult"]', IS_OPTN);
  { PurchaseInServiceSoap.QueryOut }
  InvRegistry.RegisterMethodInfo(TypeInfo(PurchaseInServiceSoap), 'QueryOut', '',
                                 '[ReturnName="QueryOutResult"]', IS_OPTN);
  { PurchaseInServiceSoap.QueryOutDetail }
  InvRegistry.RegisterMethodInfo(TypeInfo(PurchaseInServiceSoap), 'QueryOutDetail', '',
                                 '[ReturnName="QueryOutDetailResult"]', IS_OPTN);
  { PurchaseInServiceHttpGet }
  InvRegistry.RegisterInterface(TypeInfo(PurchaseInServiceHttpGet), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(PurchaseInServiceHttpGet), '');
  { PurchaseInServiceHttpPost }
  InvRegistry.RegisterInterface(TypeInfo(PurchaseInServiceHttpPost), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(PurchaseInServiceHttpPost), '');
  RemClassRegistry.RegisterXSInfo(TypeInfo(string_), 'http://tempuri.org/', 'string_', 'string');

end.
