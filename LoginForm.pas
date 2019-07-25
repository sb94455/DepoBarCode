unit LoginForm;

interface

uses System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FireDAC.Comp.Client,
  System.IniFiles,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  Soap.SOAPHTTPClient,
  BaseForm,
  FMX.Controls.Presentation,
  FMX.Edit,
  FMX.Objects,
  FMX.Layouts,
  FMX.Ani,
  System.Messaging,
  FMX.ListBox;

type
  TLoginFrm = class(TBaseFrm)
    rctngl_Top: TRectangle;
    Layout3: TLayout;
    Image1: TImage;
    Rectangle2: TRectangle;
    ClientLay: TLayout;
    Layout4: TLayout;
    UserNameEdt: TEdit;
    Img_User: TImage;
    PassWordEdt: TEdit;
    Img_PWD: TImage;
    Layout6: TLayout;
    SaveNameChk: TCheckBox;
    Layout7: TLayout;
    LoginBtn: TButton;
    Layout2: TLayout;
    ErrorText: TText;
    Layout1: TLayout;
    Layout5: TLayout;
    procedure PassWordEdtKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure UserNameEdtKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure LoginBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    FExitOnSuccess: Boolean;
    // procedure InnerLogin;
  protected
    procedure InitData; override;
    procedure ListenerMethod(const Sender: TObject; const M: TMessage); override;
  public
    procedure SetLogined(aValue: Boolean);
    procedure ShowError;
    property ExitOnSucces: Boolean read FExitOnSuccess write FExitOnSuccess;
  end;

var
  loginFrm: TLoginFrm;

implementation

uses LoginService,
  UnitLib,
  UnitU8DM;

{$R *.fmx}

procedure TLoginFrm.FormCreate(Sender: TObject);
begin
  inherited;
{$IFDEF DEBUG}
    if PassWordEdt.Text.trim = '' then
    begin
      UserNameEdt.Text := 'demo';
      PassWordEdt.Text := 'szhlrj.com3.14';
    end;
    // ModalResult := mrok;
{$ENDIF}
end;

procedure TLoginFrm.FormShow(Sender: TObject);
begin
  inherited;
  ErrorText.Visible := False;

  with TIniFile.Create(GetIniFileName) do
    try
      PubVar_LoginInfo.SaveName := ReadBool('Login', 'SaveUserName', False);
      if PubVar_LoginInfo.SaveName = True then
      begin
        PubVar_LoginInfo.UserName := ReadString('Login', 'UserName', '');
        UserNameEdt.Text := PubVar_LoginInfo.UserName;
        SaveNameChk.IsChecked := True;
      end;
      PassWordEdt.Text := '';
      PubVar_LoginInfo.PassWord := '';
    finally
      Free;
    end;

  ErrorText.Text := '';

  AniIndicator.Visible := False;
end;

procedure TLoginFrm.InitData;
begin
end;

procedure TLoginFrm.ListenerMethod(const Sender: TObject; const M: TMessage);
begin

end;

procedure TLoginFrm.LoginBtnClick(Sender: TObject);
var
  // tmpHTTPRIO: THTTPRIO;
  Service_Data       : LoginSoap;
  strWebserviceReturn: string;
  fdmUserInfo        : TFDMemTable;
begin
  try

    // tmpHTTPRIO := THTTPRIO.Create(Nil);

    Service_Data := GetLoginSoap(False, PubVar_WebServiceUrl + Const_Url_Def_Login, u8dm.HTTPRIO1);
    strWebserviceReturn := Service_Data.U8Login(UserNameEdt.Text, PassWordEdt.Text);
    if SameText(strWebserviceReturn, 'OK') then
    begin
      PubVar_LoginInfo.logined := True; // 主窗口以此判断
      fdmUserInfo := TFDMemTable.Create(nil);
      u8dm.ExecSql(fdmUserInfo, format('select * from ufsystem..ua_user where cUser_id like ''%s'' or cUser_Name like ''%s''',
        [UserNameEdt.Text.Trim, UserNameEdt.Text.Trim]));
      try
        if fdmUserInfo.RecordCount > 0 then
        begin
          begin
            PubVar_LoginInfo.UserID := fdmUserInfo.FieldByName('cUser_id').AsString.Trim;
            PubVar_LoginInfo.UserName := fdmUserInfo.FieldByName('cUser_Name').AsString.Trim;
          end
        end
        else
        begin
          showmessage(format('未找到用户%s,请确认', [UserNameEdt.Text.Trim]));
          abort;
        end;
      finally
        freeandnil(fdmUserInfo);
      end;
       PubVar_LoginInfo.logined:=True;
      PubVar_LoginInfo.PassWord := PassWordEdt.Text;
      PubVar_LoginInfo.SaveName := SaveNameChk.IsChecked;
      with TIniFile.Create(GetIniFileName) do
        try
          WriteString('Login', 'UserName', PubVar_LoginInfo.UserName);
          WriteBool('Login', 'SaveUserName', PubVar_LoginInfo.SaveName);
        finally
          Free;
        end;
      // ModalResult := mrok;                 不起作用
      // Close;
      btn_BaseBack.OnClick(Self); // 调用返回键
    end
    // else
    // begin
    // loginInfo.logined := False;
    // loginInfo.userName := UserNameEdt.Text;
    // loginInfo.PassWord := '';
    /// /      loginInfo.SaveName := SaveNameChk.IsChecked;
    // end;
    else
    begin
      showmessage('密码错误，请重试。');
      PassWordEdt.Text := '';
    end;
  except
    on E: Exception do
    begin
      ErrorText.Text := E.Message;
    end;
  end;

end;

procedure TLoginFrm.PassWordEdtKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    LoginBtn.OnClick(LoginBtn);
end;

procedure TLoginFrm.SetLogined(aValue: Boolean);
begin
  AniIndicator.Visible := False;
  if aValue then
  begin
    UserNameEdt.Enabled := False;
    PassWordEdt.Enabled := False;
    SaveNameChk.Enabled := False;
    LoginBtn.Enabled := False;
    txt_BaseMsg.Text := '已登录';
    // SetMsg('已登录');
    ErrorText.Visible := False;
    // MainFrm.Setlogin(True);
    // Timer1.Enabled := True;
  end else begin
    // MainFrm.UserNameText.Text := '未登录';
    UserNameEdt.Enabled := True;
    PassWordEdt.Enabled := True;
    SaveNameChk.Enabled := True;
    LoginBtn.Enabled := True;
    txt_BaseMsg.Text := '未登录';
    // MainFrm.Setlogin(False);
  end;
end;

procedure TLoginFrm.ShowError;
begin

end;

procedure TLoginFrm.UserNameEdtKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    PassWordEdt.SetFocus;
end;

end.
