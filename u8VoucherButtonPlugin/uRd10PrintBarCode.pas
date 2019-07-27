unit uRd10PrintBarCode;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, SysUtils, ActiveX, VoucherBtnPlugins_TLB, StdVCL, Dialogs, Controls,
  Variants, Classes, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, ADODB;

type
  TRdPrint10BarCode = class(TAutoObject, IPrintRd10BarCode)
  protected
    procedure RunCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; const other: WideString); safecall;
    procedure BeforeRunSysCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; var Cancel: WordBool; const other: WideString); safecall;
    procedure Init(var objLogin, objForm, objVoucher, msBar: OleVariant); safecall;
  private
  end;

implementation

uses
  ComServ, ufmPub, ufrmRd10PrintBarCode;

procedure TRdPrint10BarCode.RunCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; const other: WideString);
begin
  strDBConnectString := objLogin.UfDbName;
  login_cUserId := objLogin.cUserId;
  Login_cUserName := objLogin.cUserName;
  login_cUserPassWord := objLogin.cUserPassWord;
  login_cAcc_Id := objLogin.cAcc_Id;

  if ufmPub.frmPub = nil then
    frmPub := TfrmPub.Create(nil);
  with TfrmRd10PrintBarCode.Create(nil) do
  begin
    try
      mmo1.Text := objVoucher.GetHeadDom.xml;
      vouchType := 'Rd_10BarCode';
      KeyName := 'MoID';
      keyValue := GetKeyValueFromXML(objVoucher.GetHeadDom.xml, keyname);
      ShowModal;
    finally
      Free
    end;
  end;
  FreeAndNil(frmPub);
end;

procedure TRdPrint10BarCode.BeforeRunSysCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; var Cancel: WordBool; const other: WideString);
begin

end;

procedure TRdPrint10BarCode.Init(var objLogin, objForm, objVoucher, msBar: OleVariant);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TRdPrint10BarCode, CLASS_PrintRd10BarCode, ciMultiInstance, tmApartment);

end.

