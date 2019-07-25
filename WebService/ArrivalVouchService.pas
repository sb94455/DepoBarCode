// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://szhlrj.com:280/U8BarCodeWebService/ArrivalVouchService.asmx?wsdl
//  >Import : http://szhlrj.com:280/U8BarCodeWebService/ArrivalVouchService.asmx?wsdl>0
// Encoding : utf-8
// Codegen  : [wfForceSOAP12+]
// Version  : 1.0
// (2017/6/4 16:41:42 - - $Rev: 86412 $)
// ************************************************************************ //

unit ArrivalVouchService;

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
  // soapAction: http://tempuri.org/QueryArriveVouchsNotInByOrderNo
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : ArrivalVouchServiceSoap12
  // service   : ArrivalVouchService
  // port      : ArrivalVouchServiceSoap12
  // URL       : http://szhlrj.com/U8BarCodeWebService/ArrivalVouchService.asmx
  // ************************************************************************ //
  ArrivalVouchServiceSoap = interface(IInvokable)
  ['{001F7185-ED1A-C5A7-BF0A-E66308A47077}']
    function  QueryArriveVouchsNotInByOrderNo(const orderNo: string): string; stdcall;
  end;

function GetArrivalVouchServiceSoap(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ArrivalVouchServiceSoap;


implementation
  uses System.SysUtils;

function GetArrivalVouchServiceSoap(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ArrivalVouchServiceSoap;
const
  defWSDL = 'http://221.224.62.236:280/U8BarCodeWebService/ArrivalVouchService.asmx?wsdl';
  defURL  = 'http://221.224.62.236/U8BarCodeWebService/ArrivalVouchService.asmx';
  defSvc  = 'ArrivalVouchService';
  defPrt  = 'ArrivalVouchServiceSoap12';
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
    Result := (RIO as ArrivalVouchServiceSoap);
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
  { ArrivalVouchServiceSoap }
  InvRegistry.RegisterInterface(TypeInfo(ArrivalVouchServiceSoap), 'http://tempuri.org/', 'utf-8');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ArrivalVouchServiceSoap), 'http://tempuri.org/QueryArriveVouchsNotInByOrderNo');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ArrivalVouchServiceSoap), ioDocument);
  InvRegistry.RegisterInvokeOptions(TypeInfo(ArrivalVouchServiceSoap), ioSOAP12);
  { ArrivalVouchServiceSoap.QueryArriveVouchsNotInByOrderNo }
  InvRegistry.RegisterMethodInfo(TypeInfo(ArrivalVouchServiceSoap), 'QueryArriveVouchsNotInByOrderNo', '',
                                 '[ReturnName="QueryArriveVouchsNotInByOrderNoResult"]', IS_OPTN);

end.