unit MainForm;

interface

uses System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  FMX.MultiView,
  FMX.Ani,
  FMX.ListBox,
  System.Actions,
  AboutForm,
  FMX.Controls.Presentation, {$IFDEF ANDROID} FMX.platform.Android, {$ENDIF}
  StockForm,
  UnitU8DM,
  LoginForm,
  FMX.Edit;

type
  TMainFrm = class(TForm)
    Master: TPanel;
    ImageTool: TImage;
    TextTitle: TText;
    ExeBtnGPL: TGridPanelLayout;
    InventoryRec: TRectangle;
    InventoryCA: TColorAnimation;
    InventoryImg: TImage;
    InventoryText: TText;
    PickingRec: TRectangle;
    PickingCA: TColorAnimation;
    PickingImg: TImage;
    PickingText: TText;
    BtnGPL: TGridPanelLayout;
    btnLogin: TCornerButton;
    AboutCBtn: TCornerButton;
    MsgRec: TRectangle;
    MsgCA: TColorAnimation;
    MsgText: TText;
    AniIndicator2: TAniIndicator;
    Rectangle2: TRectangle;
    ColorAnimation2: TColorAnimation;
    Text2: TText;
    Image8: TImage;
    ProductInRec: TRectangle;
    ProductInCA: TColorAnimation;
    ProductInimg: TImage;
    ProductInText: TText;
    PurInRec: TRectangle;
    PurInCA: TColorAnimation;
    PurInImg: TImage;
    PurInText: TText;
    ColorAnimation1: TColorAnimation;
    Image7: TImage;
    Text1: TText;
    rctnglSaleOut: TRectangle;
    ColorAnimation3: TColorAnimation;
    Image1: TImage;
    Text3: TText;
    OutPichingRec: TRectangle;
    lbl_LoginInfo: TLabel;
    Btn_Exit: TButton;
    OtherInRec: TRectangle;
    OtherInCA: TColorAnimation;
    OtherInIMG: TImage;
    OtherInText: TText;
    OtherOutRec: TRectangle;
    OtherOutcd: TColorAnimation;
    OtherOutimg: TImage;
    OtherOutText: TText;
    rctngl1: TRectangle;
    clrnmtn1: TColorAnimation;
    img1: TImage;
    txt1: TText;
    procedure FormCreate(Sender: TObject);
    procedure AboutbtnClick(Sender: TObject);
    // procedure LoginBtnClick(Sender: TObject);
    // procedure PurInBtnClick(Sender: TObject);
    // procedure OutBillBtnClick(Sender: TObject);
    // procedure InventoryBtnClick(Sender: TObject);
    // procedure StockBtnClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure PurInRecClick(Sender: TObject);
    procedure PickingRecClick(Sender: TObject);
    procedure InventoryRecClick(Sender: TObject);
    // procedure StockRecClick(Sender: TObject);
    procedure SaleOutRectClick(Sender: TObject);
    procedure ProductInRecClick(Sender: TObject);
    procedure Rectangle2Click(Sender: TObject);
    procedure MsgRecClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Btn_ExitClick(Sender: TObject);
    procedure OutPichingRecClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OtherInRecClick(Sender: TObject);
    procedure OtherOutRecClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FItemDM : TU8DM;
    FTopForm: TForm;
//    FLogin:Boolean;
    function CheckLogin: Boolean;
//    function GetLogined: Boolean;
  public
    { Public declarations }
    // FLoginFrm: TLoginFrm;
    // FPurInMngFrm: TPurInMngFrm;
    // FPickingMngFrm: TPickingMngFrm;
    // FOutOrderMngFrm: TOutOrderMngFrm;
    // FProductInMngFrm: TProductInMngFrm;
    // FOutPickingMngFrm: TOutPickingMngFrm;
    // FIntrustInMngFrm: TIntrustInMngFrm;
    // FSaleOutMngFrm: TSaleOutMngFrm;
//    procedure Setlogin(aValue: Boolean);
    procedure SetMsg(aMsg: string);
    property ItemDM: TU8DM read FItemDM;
    property TopForm: TForm read FTopForm write FTopForm;
//    property  Logined:Boolean read FLogin Write Setlogin;
  end;

var
  MainFrm: TMainFrm;

implementation

uses UnitLib,
  uRdVouchList01,
  uRdVouchList08,
  uRdVouchList09,
  uRdVouchList11,
  uRdVouchList10,
  uRdVouchList32,
  uRdVouchListWW11,
  uRdVouchListWW01,
  testFrm;

{$R *.fmx}

{ TForm1 }
function TMainFrm.CheckLogin: Boolean;
begin
{$IFDEF DEBUG}
  Result := true;
  exit;
{$ENDIF}
if PubVar_LoginInfo.logined=false then
  btnLoginClick(self);
  Result := PubVar_LoginInfo.logined;
end;

procedure TMainFrm.AboutbtnClick(Sender: TObject);
begin
  if not Assigned(AboutFrm) then
    AboutFrm := TAboutFrm.Create(self);
  AboutFrm.ShowModal(procedure(ModalResult: TModalResult)
    begin
      // if ModalResult = mrok then
      // begin
      // showmessage('ModalResult=mrok');
      // end;
      // AboutFrm.Focused := nil;
      self.Show; // 不然显示不出，暂时没有好办法
      AboutFrm := nil;
    end);
end;

procedure TMainFrm.btnLoginClick(Sender: TObject);
begin
  if not Assigned(loginFrm) then
    loginFrm := TLoginFrm.Create(self);
  loginFrm.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      loginFrm.Focused := nil;
//      Setlogin(PubVar_LoginInfo.logined);
      if PubVar_LoginInfo.logined then
      begin
        Show; // 不然显示不出，暂时没有好办法
      end;
      loginFrm := nil;
    end);
end;

procedure TMainFrm.Btn_ExitClick(Sender: TObject);
begin
  close;
end;

procedure TMainFrm.InventoryRecClick(Sender: TObject);
begin
  if CheckLogin = False then
    exit;

  if not Assigned(StockFrm) then           //确保只创建一个窗口
    StockFrm := TStockFrm.Create(self);
  ShowForm(self, StockFrm);
end;

procedure TMainFrm.MsgRecClick(Sender: TObject);
begin
{$IFDEF DEBUG}
  if not Assigned(frmTest) then
    frmTest := TfrmTest.Create(self);
  ShowForm(self, frmTest);
{$ENDIF}
end;

procedure TMainFrm.OtherInRecClick(Sender: TObject);
begin
   if CheckLogin = False then
    exit;
  if not Assigned(frm_RdVouchList08) then
    frm_RdVouchList08 := Tfrm_RdVouchList08.Create(self);
  ShowForm(self, frm_RdVouchList08);
end;

procedure TMainFrm.OtherOutRecClick(Sender: TObject);
begin
  if CheckLogin = False then
    exit;
  if not Assigned(frm_RdVouchList09) then
    frm_RdVouchList09 := Tfrm_RdVouchList09.Create(self);
  ShowForm(self, frm_RdVouchList09);
end;

procedure TMainFrm.OutPichingRecClick(Sender: TObject);
begin
  if CheckLogin = False then
    exit;
  if not Assigned(frm_RdVouchListWW11) then
    frm_RdVouchListWW11 := Tfrm_RdVouchListWW11.Create(self);
  ShowForm(self, frm_RdVouchListWW11);
end;

procedure TMainFrm.PurInRecClick(Sender: TObject);
begin
  if CheckLogin = False then
    exit;

  if not Assigned(frm_RdVouchList01) then
    frm_RdVouchList01 := Tfrm_RdVouchList01.Create(self);
  ShowForm(self, frm_RdVouchList01);
end;


procedure TMainFrm.Rectangle2Click(Sender: TObject);
begin
  if CheckLogin = False then
    exit;
  if not Assigned(frm_RdVouchListWW01) then
    frm_RdVouchListWW01 := Tfrm_RdVouchListWW01.Create(self);
  ShowForm(self, frm_RdVouchListWW01);
end;

procedure TMainFrm.PickingRecClick(Sender: TObject);
begin

  if CheckLogin = False then
    exit;
  if not Assigned(frm_RdVouchList11) then
    frm_RdVouchList11 := Tfrm_RdVouchList11.Create(self);
    ShowForm(self, frm_RdVouchList11);
end;

procedure TMainFrm.ProductInRecClick(Sender: TObject);
begin
  if CheckLogin = False then
    exit;

  if not Assigned(frm_RdVouchList10) then
    frm_RdVouchList10 := Tfrm_RdVouchList10.Create(self);
  ShowForm(self, frm_RdVouchList10);
end;

procedure TMainFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    exit;
  MessageDlg('您确定要退出吗？', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0, procedure(const AResult: TModalResult)
    begin
      if AResult = mrOK then
{$IFDEF ANDROID}
        MainActivity.finish
{$ELSE}
        close
{$ENDIF}
      else
        abort;
    end);

end;

procedure TMainFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  MessageDlg('您确定要退出吗？', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0,
//    procedure(const AResult: TModalResult)
//    begin
//      if AResult <> mrOK then
//      abort;
//    end);
  /// /
  // if MessageDlg('是否确定退出？', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], -1) = mrOK then
  // CanClose := true
  // else
  // CanClose := False;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
{$IFDEF ANDROID}
  Width := Screen.Width;
  Height := Screen.Height;
{$ENDIF}
  FMX.Types.VKAutoShowMode := TVKAutoShowMode.vkasNever;
  // FMX.Forms.
end;


procedure TMainFrm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
//  if Key = vkHardwareBack then
//    close;
end;

procedure TMainFrm.FormShow(Sender: TObject);
begin
  rctngl1.Visible:=False;
end;

//function TMainFrm.GetLogined: Boolean;
//begin
//
//end;

procedure TMainFrm.SaleOutRectClick(Sender: TObject);
begin

  if not Assigned(frm_RdVouchList32) then
    frm_RdVouchList32 := Tfrm_RdVouchList32.Create(self);
  ShowForm(self, frm_RdVouchList32);

end;



procedure TMainFrm.SetMsg(aMsg: string);
begin
end;

end.
