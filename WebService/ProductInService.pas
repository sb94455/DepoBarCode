// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://221.224.62.236:280/U8BarCodeWebService/ProductInService.asmx?wsdl
//  >Import : http://221.224.62.236:280/U8BarCodeWebService/ProductInService.asmx?wsdl>0
// Encoding : utf-8
// Version  : 1.0
// (2017/11/17 1:19:39 - - $Rev: 90173 $)
// ************************************************************************ //

unit ProductInService;

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
  // binding   : ProductInServiceSoap
  // service   : ProductInService
  // port      : ProductInServiceSoap
  // URL       : http://221.224.62.236/U8BarCodeWebService/ProductInService.asmx
  // ************************************************************************ //
  ProductInServiceSoap = interface(IInvokable)
  ['{E3828CDF-7903-D1FF-E500-7C7CB7064EE0}']
    function  Update(const xml: string): string; stdcall;
    function  Check(const id: string): string; stdcall;
    function  Delete(const id: string): string; stdcall;
    function  QueryByCode(const billCode: string): string; stdcall;
    function  Insert(const xml: string): string; stdcall;
    function  BackCheck(const id: string): string; stdcall;
    function  Query(const xml: string): string; stdcall;
    function  QueryDetail(const id: string): string; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : ProductInServiceHttpGet
  // service   : ProductInService
  // port      : ProductInServiceHttpGet
  // ************************************************************************ //
  ProductInServiceHttpGet = interface(IInvokable)
  ['{D73EABE4-F17C-6ECE-9A9A-0C92916A8ED9}']
    function  Update(const xml: string): string_; stdcall;
    function  Check(const id: string): string_; stdcall;
    function  Delete(const id: string): string_; stdcall;
    function  QueryByCode(const billCode: string): string_; stdcall;
    function  Insert(const xml: string): string_; stdcall;
    function  BackCheck(const id: string): string_; stdcall;
    function  Query(const xml: string): string_; stdcall;
    function  QueryDetail(const id: string): string_; stdcall;
  end;


  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // style     : ????
  // use       : ????
  // binding   : ProductInServiceHttpPost
  // service   : ProductInService
  // port      : ProductInServiceHttpPost
  // ************************************************************************ //
  ProductInServiceHttpPost = interface(IInvokable)
  ['{261FF883-22FB-1ED4-D9E9-30A93AAAAE0F}']
    function  Update(const xml: string): string_; stdcall;
    function  Check(const id: string): string_; stdcall;
    function  Delete(const id: string): string_; stdcall;
    function  QueryByCode(const billCode: string): string_; stdcall;
    function  Insert(const xml: string): string_; stdcall;
    function  BackCheck(const id: string): string_; stdcall;
    function  Query(const xml: string): string_; stdcall;
    function  QueryDetail(const id: string): string_; stdcall;
  end;

function GetProductInServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ProductInServiceSoap;
function GetProductInServiceHttpGet(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ProductInServiceHttpGet;
function GetProductInServiceHttpPost(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ProductInServiceHttpPost;


implementation
  uses System.SysUtils;

function GetProductInServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ProductInServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/ProductInService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/ProductInService.asmx';
  defSvc  = 'ProductInService';
  defPrt  = 'ProductInServiceSoap';
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
    Result := (RIO as ProductInServiceSoap);
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


function GetProductInServiceHttpGet(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ProductInServiceHttpGet;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/ProductInService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'ProductInService';
  defPrt  = 'ProductInServiceHttpGet';
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
    Result := (RIO as ProductInServiceHttpGet);
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


function GetProductInServiceHttpPost(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ProductInServiceHttpPost;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/ProductInService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'ProductInService';
  defPrt  = 'ProductInServiceHttpPost';
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
    Result := (RIO as ProductInServiceHttpPost);
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
  { ProductInServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(ProductInServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ProductInServiceSoap), 'http://tempuri.org/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ProductInServiceSoap), ioDocument);
  { ProductInServiceSoap.Update }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProductInServiceSoap), 'Update', '',
                                 '[ReturnName="UpdateResult"]', IS_OPTN);
  { ProductInServiceSoap.Check }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProductInServiceSoap), 'Check', '',
                                 '[ReturnName="CheckResult"]', IS_OPTN);
  { ProductInServiceSoap.Delete }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProductInServiceSoap), 'Delete', '',
                                 '[ReturnName="DeleteResult"]', IS_OPTN);
  { ProductInServiceSoap.QueryByCode }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProductInServiceSoap), 'QueryByCode', '',
                                 '[ReturnName="QueryByCodeResult"]', IS_OPTN);
  { ProductInServiceSoap.Insert }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProductInServiceSoap), 'Insert', '',
                                 '[ReturnName="InsertResult"]', IS_OPTN);
  { ProductInServiceSoap.BackCheck }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProductInServiceSoap), 'BackCheck', '',
                                 '[ReturnName="BackCheckResult"]', IS_OPTN);
  { ProductInServiceSoap.Query }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProductInServiceSoap), 'Query', '',
                                 '[ReturnName="QueryResult"]', IS_OPTN);
  { ProductInServiceSoap.QueryDetail }
  InvRegistry.RegisterMethodInfo(TypeInfo(ProductInServiceSoap), 'QueryDetail', '',
                                 '[ReturnName="QueryDetailResult"]', IS_OPTN);
  { ProductInServiceHttpGet }
  InvRegistry.RegisterInterface(TypeInfo(ProductInServiceHttpGet), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ProductInServiceHttpGet), '');
  { ProductInServiceHttpPost }
  InvRegistry.RegisterInterface(TypeInfo(ProductInServiceHttpPost), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ProductInServiceHttpPost), '');
  RemClassRegistry.RegisterXSInfo(TypeInfo(string_), 'http://tempuri.org/', 'string_', 'string');

end.
