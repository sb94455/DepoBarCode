// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://szhlrj.com:280/U8BarCodeWebService/Login.asmx?wsdl
//  >Import : http://szhlrj.com:280/U8BarCodeWebService/Login.asmx?wsdl>0
// Encoding : utf-8
// Codegen  : [wfForceSOAP12+]
// Version  : 1.0
// (2017/5/31 23:35:46 - - $Rev: 86412 $)
// ************************************************************************ //

unit LoginService;

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



  // ************************************************************************ //
  // Namespace : http://tempuri.org/
  // soapAction: http://tempuri.org/U8Login
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : LoginSoap12
  // service   : Login
  // port      : LoginSoap12
  // URL       : http://szhlrj.com/U8BarCodeWebService/Login.asmx
  // ************************************************************************ //
  LoginSoap = interface(IInvokable)
  ['{A5E25D8D-0C60-F0D8-43BD-F809FFA28031}']
    function  U8Login(const userId: string; const password: string): string; stdcall;
  end;

function GetLoginSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): LoginSoap;


implementation
  uses System.SysUtils;

function GetLoginSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): LoginSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/Login.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/Login.asmx';
  defSvc  = 'Login';
  defPrt  = 'LoginSoap12';
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
    Result := (RIO as LoginSoap);
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
  { LoginSoap }
  InvRegistry.RegisterInterface(TypeInfo(LoginSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(LoginSoap), 'http://tempuri.org/U8Login');
  InvRegistry.RegisterInvokeOptions(TypeInfo(LoginSoap), ioDocument);
  InvRegistry.RegisterInvokeOptions(TypeInfo(LoginSoap), ioSOAP12);
  { LoginSoap.U8Login }
  InvRegistry.RegisterMethodInfo(TypeInfo(LoginSoap), 'U8Login', '',
                                 '[ReturnName="U8LoginResult"]', IS_OPTN);

end.