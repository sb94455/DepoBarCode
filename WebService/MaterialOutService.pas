// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://221.224.62.236:280/U8BarCodeWebService/MaterialOutService.asmx?wsdl
//  >Import : http://221.224.62.236:280/U8BarCodeWebService/MaterialOutService.asmx?wsdl>0
// Encoding : utf-8
// Version  : 1.0
// (2017/11/14 23:15:33 - - $Rev: 90173 $)
// ************************************************************************ //

unit MaterialOutService;

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
  // binding   : MaterialOutServiceSoap
  // service   : MaterialOutService
  // port      : MaterialOutServiceSoap
  // URL       : http://221.224.62.236/U8BarCodeWebService/MaterialOutService.asmx
  // ************************************************************************ //
  MaterialOutServiceSoap = interface(IInvokable)
  ['{26C6F4FA-9B98-EFB4-BF52-196AC150B746}']
    function  Update(const xml: string): string; stdcall;
    function  QueryByCode(const billCode: string): string; stdcall;
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
  // binding   : MaterialOutServiceHttpGet
  // service   : MaterialOutService
  // port      : MaterialOutServiceHttpGet
  // ************************************************************************ //
  MaterialOutServiceHttpGet = interface(IInvokable)
  ['{CCF1625F-A63A-1E71-0B61-736FB1B52661}']
    function  Update(const xml: string): string_; stdcall;
    function  QueryByCode(const billCode: string): string_; stdcall;
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
  // binding   : MaterialOutServiceHttpPost
  // service   : MaterialOutService
  // port      : MaterialOutServiceHttpPost
  // ************************************************************************ //
  MaterialOutServiceHttpPost = interface(IInvokable)
  ['{0EB64663-B04C-F5F9-317A-13C11752EA29}']
    function  Update(const xml: string): string_; stdcall;
    function  QueryByCode(const billCode: string): string_; stdcall;
    function  Insert(const xml: string): string_; stdcall;
    function  InsertOut(const xml: string): string_; stdcall;
    function  Delete(const id: string): string_; stdcall;
    function  Query(const xml: string): string_; stdcall;
    function  QueryDetail(const id: string): string_; stdcall;
    function  QueryOut(const xml: string): string_; stdcall;
    function  QueryOutDetail(const id: string): string_; stdcall;
  end;

function GetMaterialOutServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): MaterialOutServiceSoap;
function GetMaterialOutServiceHttpGet(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): MaterialOutServiceHttpGet;
function GetMaterialOutServiceHttpPost(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): MaterialOutServiceHttpPost;


implementation
  uses System.SysUtils;

function GetMaterialOutServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): MaterialOutServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/MaterialOutService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/MaterialOutService.asmx';
  defSvc  = 'MaterialOutService';
  defPrt  = 'MaterialOutServiceSoap';
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
    Result := (RIO as MaterialOutServiceSoap);
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


function GetMaterialOutServiceHttpGet(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): MaterialOutServiceHttpGet;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/MaterialOutService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'MaterialOutService';
  defPrt  = 'MaterialOutServiceHttpGet';
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
    Result := (RIO as MaterialOutServiceHttpGet);
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


function GetMaterialOutServiceHttpPost(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): MaterialOutServiceHttpPost;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/MaterialOutService.asmx?wsdl';
  defURL  = '';
  defSvc  = 'MaterialOutService';
  defPrt  = 'MaterialOutServiceHttpPost';
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
    Result := (RIO as MaterialOutServiceHttpPost);
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
  { MaterialOutServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(MaterialOutServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(MaterialOutServiceSoap), 'http://tempuri.org/%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(MaterialOutServiceSoap), ioDocument);
  { MaterialOutServiceSoap.Update }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'Update', '',
                                 '[ReturnName="UpdateResult"]', IS_OPTN);
  { MaterialOutServiceSoap.QueryByCode }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'QueryByCode', '',
                                 '[ReturnName="QueryByCodeResult"]', IS_OPTN);
  { MaterialOutServiceSoap.Insert }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'Insert', '',
                                 '[ReturnName="InsertResult"]', IS_OPTN);
  { MaterialOutServiceSoap.InsertOut }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'InsertOut', '',
                                 '[ReturnName="InsertOutResult"]', IS_OPTN);
  { MaterialOutServiceSoap.Delete }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'Delete', '',
                                 '[ReturnName="DeleteResult"]', IS_OPTN);
  { MaterialOutServiceSoap.Query }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'Query', '',
                                 '[ReturnName="QueryResult"]', IS_OPTN);
  { MaterialOutServiceSoap.QueryDetail }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'QueryDetail', '',
                                 '[ReturnName="QueryDetailResult"]', IS_OPTN);
  { MaterialOutServiceSoap.QueryOut }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'QueryOut', '',
                                 '[ReturnName="QueryOutResult"]', IS_OPTN);
  { MaterialOutServiceSoap.QueryOutDetail }
  InvRegistry.RegisterMethodInfo(TypeInfo(MaterialOutServiceSoap), 'QueryOutDetail', '',
                                 '[ReturnName="QueryOutDetailResult"]', IS_OPTN);
  { MaterialOutServiceHttpGet }
  InvRegistry.RegisterInterface(TypeInfo(MaterialOutServiceHttpGet), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(MaterialOutServiceHttpGet), '');
  { MaterialOutServiceHttpPost }
  InvRegistry.RegisterInterface(TypeInfo(MaterialOutServiceHttpPost), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(MaterialOutServiceHttpPost), '');
  RemClassRegistry.RegisterXSInfo(TypeInfo(string_), 'http://tempuri.org/', 'string_', 'string');

end.

