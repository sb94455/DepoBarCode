unit uRd01PrintBarCode;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, SysUtils, ActiveX, VoucherBtnPlugins_TLB, StdVCL, Dialogs, Controls,
  Variants, Classes, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, ADODB;

type
  TPrintRd01BarCode = class(TAutoObject, IPrintRd01BarCode)
  protected
    procedure RunCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; const other: WideString); safecall;
    procedure BeforeRunSysCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; var Cancel: WordBool; const other: WideString); safecall;
    procedure Init(var objLogin, objForm, objVoucher, msBar: OleVariant); safecall;
  private
  end;

implementation

uses
  ComServ, ufmPub, ufrmRd01PrintBarCode;

procedure TPrintRd01BarCode.RunCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; const other: WideString);
begin
//  UfCurrentDbConnectionString := objLogin.UfDbName;      C:\U8SOFT\ufcomsql\U8Login.dll
  strDBConnectString := objLogin.UfDbName;

  login_cUserId := objLogin.cUserId;
  Login_cUserName := objLogin.cUserName;
  login_cUserPassWord := objLogin.cUserPassWord;
  login_cAcc_Id := objLogin.cAcc_Id;

  if ufmPub.frmPub = nil then
    frmPub := TfrmPub.Create(nil);
  with TfrmRd01PrintBarCode.Create(nil) do
  begin
    try
      mmo1.Text := objVoucher.GetHeadDom.xml;
      vouchType := 'ArrivalVouch';
      KeyName := 'Id';
      keyValue := GetKeyValueFromXML(objVoucher.GetHeadDom.xml, keyname);
      ShowModal;

//      if (Pos(substr1, mmo1.Text) > 0) then
//      begin
//        ShowModal;
//      end
//      else
//      begin
//        mmo1.Visible := TRUE;
//        frxReport1.Visible := False;
//        ShowModal;
//      end;
    finally
      Free
    end;
  end;
  FreeAndNil(frmPub);
end;

procedure TPrintRd01BarCode.BeforeRunSysCommand(var objLogin, objForm, objVoucher: OleVariant; const sKey: WideString; VarentValue: OleVariant; var Cancel: WordBool; const other: WideString);
begin
//       ShowMessage('BeforeRunSysCommand');
//       Cancel:=True;
end;

procedure TPrintRd01BarCode.Init(var objLogin, objForm, objVoucher, msBar: OleVariant);
begin
//            ShowMessage('Init');
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPrintRd01BarCode, Class_PrintRd01BarCode, ciMultiInstance, tmApartment);

end.

