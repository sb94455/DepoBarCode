// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://221.224.62.236:280/U8BarCodeWebService/SaleOutService.asmx?wsdl
//  >Import : http://221.224.62.236:280/U8BarCodeWebService/SaleOutService.asmx?wsdl>0
// Encoding : utf-8
// Version  : 1.0
// (2017/11/30 20:54:25 - - $Rev: 90173 $)
// ************************************************************************ //

unit SaleOutService;

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
  // binding   : SaleOutServiceSoap
  // service   : SaleOutService
  // port      : SaleOutServiceSoap
  // URL       : http://221.224.62.236/U8BarCodeWebService/SaleOutService.asmx
  // ************************************************************************ //
  SaleOutServiceSoap = interface(IInvokable)
  ['{E3D655D0-992A-DDDC-79D7-067533573A87}']
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
  // binding   : SaleOutServiceHttpGet
  // service   : SaleOutService
  // port      : SaleOutServiceHttpGet
  // ************************************************************************ //
  SaleOutServiceHttpGet = interface(IInvokable)
  ['{7B86E22A-6DF5-FF11-79DC-E2851C5AD71B}']
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
  // binding   : SaleOutServiceHttpPost
  // service   : SaleOutService
  // port      : SaleOutServiceHttpPost
  // ************************************************************************ //
  SaleOutServiceHttpPost = interface(IInvokable)
  ['{5D6793E1-24FB-BE97-BCD1-3904C11E47E6}']
    function  Update(const xml: string): string_; stdcall;
    function  Check(const id: string): string_; stdcall;
    function  Delete(const id: string): string_; stdcall;
    function  QueryByCode(const billCode: string): string_; stdcall;
    function  Insert(const xml: string): string_; stdcall;
    function  BackCheck(const id: string): string_; stdcall;
    function  Query(const xml: string): string_; stdcall;
    function  QueryDetail(const id: string): string_; stdcall;
  end;

function GetSaleOutServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): SaleOutServiceSoap;
function GetSaleOutServiceHttpGet(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): SaleOutServiceHttpGet;
function GetSaleOutServiceHttpPost(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): SaleOutServiceHttpPost;


implementation
  uses System.SysUtils;

function GetSaleOutServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): SaleOutServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/SaleOutService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/SaleOutService.asmx';
  defSvc  = 'SaleOutService';
  defPrt  = 'SaleOutServiceSoap';
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
    Result := (RIO as SaleOutServiceSoap);
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


function GetSaleOutServiceHttpGet(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): SaleOutServiceHttpGet;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/SaleOutService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'SaleOutService';
  defPrt  = 'SaleOutServiceHttpGet';
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
    Result := (RIO as SaleOutServiceHttpGet);
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


function GetSaleOutServiceHttpPost(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): SaleOutServiceHttpPost;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/SaleOutService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'SaleOutService';
  defPrt  = 'SaleOutServiceHttpPost';
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
    Result := (RIO as SaleOutServiceHttpPost);
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
  { SaleOutServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(SaleOutServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(SaleOutServiceSoap), 'http://tempuri.org/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(SaleOutServiceSoap), ioDocument);
  { SaleOutServiceSoap.Update }
  InvRegistry.RegisterMethodInfo(TypeInfo(SaleOutServiceSoap), 'Update', '',
                                 '[ReturnName="UpdateResult"]', IS_OPTN);
  { SaleOutServiceSoap.Check }
  InvRegistry.RegisterMethodInfo(TypeInfo(SaleOutServiceSoap), 'Check', '',
                                 '[ReturnName="CheckResult"]', IS_OPTN);
  { SaleOutServiceSoap.Delete }
  InvRegistry.RegisterMethodInfo(TypeInfo(SaleOutServiceSoap), 'Delete', '',
                                 '[ReturnName="DeleteResult"]', IS_OPTN);
  { SaleOutServiceSoap.QueryByCode }
  InvRegistry.RegisterMethodInfo(TypeInfo(SaleOutServiceSoap), 'QueryByCode', '',
                                 '[ReturnName="QueryByCodeResult"]', IS_OPTN);
  { SaleOutServiceSoap.Insert }
  InvRegistry.RegisterMethodInfo(TypeInfo(SaleOutServiceSoap), 'Insert', '',
                                 '[ReturnName="InsertResult"]', IS_OPTN);
  { SaleOutServiceSoap.BackCheck }
  InvRegistry.RegisterMethodInfo(TypeInfo(SaleOutServiceSoap), 'BackCheck', '',
                                 '[ReturnName="BackCheckResult"]', IS_OPTN);
  { SaleOutServiceSoap.Query }
  InvRegistry.RegisterMethodInfo(TypeInfo(SaleOutServiceSoap), 'Query', '',
                                 '[ReturnName="QueryResult"]', IS_OPTN);
  { SaleOutServiceSoap.QueryDetail }
  InvRegistry.RegisterMethodInfo(TypeInfo(SaleOutServiceSoap), 'QueryDetail', '',
                                 '[ReturnName="QueryDetailResult"]', IS_OPTN);
  { SaleOutServiceHttpGet }
  InvRegistry.RegisterInterface(TypeInfo(SaleOutServiceHttpGet), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(SaleOutServiceHttpGet), '');
  { SaleOutServiceHttpPost }
  InvRegistry.RegisterInterface(TypeInfo(SaleOutServiceHttpPost), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(SaleOutServiceHttpPost), '');
  RemClassRegistry.RegisterXSInfo(TypeInfo(string_), 'http://tempuri.org/', 'string_', 'string');

end.
