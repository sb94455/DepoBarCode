unit uWWBarCode;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
 ComObj, SysUtils, ActiveX, VoucherBtnPlugins_TLB, StdVCL, Dialogs, Controls,
  Variants, Classes, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, ADODB;

type
  TwwBarCode = class(TAutoObject, IwwBarCode)
  protected
    procedure BeforeRunSysCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; var Cancel: WordBool; const other: WideString); safecall;
    procedure Init(var objLogin, objForm, objVoucher, msBar: OleVariant); safecall;
    procedure RunCommand(var objLogin, objFrom, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; const other: WideString); safecall;
  end;

implementation

uses
  ComServ,ufmPub, ufrmWWPrintBarCode;

procedure TwwBarCode.BeforeRunSysCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; var Cancel: WordBool; const other: WideString);
begin

end;

procedure TwwBarCode.Init(var objLogin, objForm, objVoucher, msBar: OleVariant);
begin

end;

procedure TwwBarCode.RunCommand(var objLogin, objFrom, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; const other: WideString);
begin
  strDBConnectString := objLogin.UfDbName;

  login_cUserId := objLogin.cUserId;
  Login_cUserName := objLogin.cUserName;
  login_cUserPassWord := objLogin.cUserPassWord;
  login_cAcc_Id := objLogin.cAcc_Id;

  if ufmPub.frmPub = nil then
    frmPub := TfrmPub.Create(nil);
  with TfrmWWPrintBarCode.Create(nil) do
  begin
    try
      mmo1.Text := objVoucher.GetHeadDom.xml;
      vouchType := 'OM_MOdetail';
      KeyName := 'MOID';
      keyValue := GetKeyValueFromXML(objVoucher.GetHeadDom.xml, keyname);
      ShowModal;
    finally
      Free
    end;
  end;
  FreeAndNil(frmPub);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TwwBarCode, Class_wwBarCode, ciMultiInstance, tmApartment);

end.

