// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://szhlrj.com:280/U8BarCodeWebService/OtherQueryService.asmx?wsdl
//  >Import : http://szhlrj.com:280/U8BarCodeWebService/OtherQueryService.asmx?wsdl>0
// Encoding : utf-8
// Codegen  : [wfForceSOAP12+]
// Version  : 1.0
// (2017/6/11 0:49:10 - - $Rev: 86412 $)
// ************************************************************************ //

unit OtherQueryService;

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
  // soapAction: http://tempuri.org/GetParameterValueByName
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : OtherQueryServiceSoap12
  // service   : OtherQueryService
  // port      : OtherQueryServiceSoap12
  // URL       : http://szhlrj.com/U8BarCodeWebService/OtherQueryService.asmx
  // ************************************************************************ //
  OtherQueryServiceSoap = interface(IInvokable)
  ['{574E012C-DF7F-64EF-3497-FF18331C4588}']
    function  GetParameterValueByName(const name_: string): string; stdcall;
  end;

function GetOtherQueryServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): OtherQueryServiceSoap;


implementation
  uses System.SysUtils;

function GetOtherQueryServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): OtherQueryServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/OtherQueryService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/OtherQueryService.asmx';
  defSvc  = 'OtherQueryService';
  defPrt  = 'OtherQueryServiceSoap12';
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
    Result := (RIO as OtherQueryServiceSoap);
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
  { OtherQueryServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(OtherQueryServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(OtherQueryServiceSoap), 'http://tempuri.org/GetParameterValueByName');
  InvRegistry.RegisterInvokeOptions(TypeInfo(OtherQueryServiceSoap), ioDocument);
  InvRegistry.RegisterInvokeOptions(TypeInfo(OtherQueryServiceSoap), ioSOAP12);
  { OtherQueryServiceSoap.GetParameterValueByName }
  InvRegistry.RegisterMethodInfo(TypeInfo(OtherQueryServiceSoap), 'GetParameterValueByName', '',
                                 '[ReturnName="GetParameterValueByNameResult"]', IS_OPTN);
  InvRegistry.RegisterParamInfo(TypeInfo(OtherQueryServiceSoap), 'GetParameterValueByName', 'name_', 'name', '');

end.