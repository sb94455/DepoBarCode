unit uPrintDispatchlist;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, SysUtils, ActiveX, VoucherBtnPlugins_TLB, StdVCL, Dialogs, Controls,
  Variants, Classes, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, ADODB;

type
  TRdPrintDispatchlist = class(TAutoObject, IPrintDispatchlist)
  protected
    procedure RunCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; const other: WideString); safecall;
    procedure BeforeRunSysCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; var Cancel: WordBool; const other: WideString); safecall;
    procedure Init(var objLogin, objForm, objVoucher, msBar: OleVariant); safecall;
  private
  end;

implementation

uses
  ComServ, ufmPub,ufrmDispatchlist;

procedure TRdPrintDispatchlist.RunCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; const other: WideString);
begin
  strDBConnectString := objLogin.UfDbName;
  login_cUserId := objLogin.cUserId;
  Login_cUserName := objLogin.cUserName;
  login_cUserPassWord := objLogin.cUserPassWord;
  login_cAcc_Id := objLogin.cAcc_Id;

  if ufmPub.frmPub = nil then
    frmPub := TfrmPub.Create(nil);
  with TfrmDispatchlist.Create(nil) do
  begin
    try
      mmo1.Text := objVoucher.GetHeadDom.xml;
      vouchType := 'Dispatchlist';
      KeyName := 'DLID';
      keyValue := GetKeyValueFromXML(objVoucher.GetHeadDom.xml, keyname);
//      ShowMessage(keyValue);
      ShowModal;
    finally
      Free
    end;
  end;
  FreeAndNil(frmPub);
end;

procedure TRdPrintDispatchlist.BeforeRunSysCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; var Cancel: WordBool; const other: WideString);
begin

end;

procedure TRdPrintDispatchlist.Init(var objLogin, objForm, objVoucher, msBar: OleVariant);
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TRdPrintDispatchlist, CLASS_PrintDispatchlist, ciMultiInstance, tmApartment);

end.

