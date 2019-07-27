library VoucherBtnPlugins;

uses
  ComServ,
  VoucherBtnPlugins_TLB in 'VoucherBtnPlugins_TLB.pas',
  uRd01PrintBarCode in 'uRd01PrintBarCode.pas' {PrintRd01BarCode: CoClass},
  uPublic in 'uPublic.pas',
  ufrmRd01PrintBarCode in 'ufrmRd01PrintBarCode.pas' {frmRd01PrintBarCode},
  ufrmReportManage in 'ufrmReportManage.pas' {frmReportManage},
  ufmPub in 'ufmPub.pas' {frmPub},
  uCreateQR in 'uCreateQR.pas' {frmCreateQR},
  uFilter in 'uFilter.pas' {frm_Filter},
  uClassDefine in 'uClassDefine.pas',
  uRepView in 'uRepView.pas' {frmRepView},
  uRd10PrintBarCode in 'uRd10PrintBarCode.pas',
  ufrmRd10PrintBarCode in 'ufrmRd10PrintBarCode.pas' {frmRd10PrintBarCode},
  uPrintDispatchlist in 'uPrintDispatchlist.pas',
  ufrmDispatchlist in 'ufrmDispatchlist.pas' {frmDispatchlist},
  uWWBarCode in 'uWWBarCode.pas' {wwBarCode: CoClass},
  ufrmWWPrintBarCode in 'ufrmWWPrintBarCode.pas' {frmWWPrintBarCode},
  uSplitQty in 'uSplitQty.pas' {frm_split};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
