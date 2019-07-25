unit AboutForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  BaseForm, FMX.Layouts, FMX.Objects, FMX.platform, FMX.Controls.Presentation,
  FMX.Ani, FMX.Edit, Inifiles, IOUtils, FMX.ListBox;

type
  TAboutFrm = class(TBaseFrm)
    ItemMsgText: TText;
    Layout1: TLayout;
    Img_Logo: TImage;
    T_Ver: TText;
    Layout2: TLayout;
    btn_Save: TButton;
    Text2: TText;
    ly_Middle: TLabel;
    ly_MidCb: TComboBox;
    cbb1: TComboBox;
    cbb2: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutFrm: TAboutFrm;

implementation

{$R *.fmx}

uses
  UnitLib, UnitU8dm;

procedure TAboutFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Focused := nil;
end;

procedure TAboutFrm.FormCreate(Sender: TObject);
begin
  inherited;

  btn_Save.ModalResult := mrok;
//  with TIniFile.Create(GetIniFileName) do
//  try
//    begin
//        //ly_MidCb.Selected.Text := ReadString('Config', 'ServerAddr', PubVar_AppServer);
//      PubVar_WebServiceUrl := ReadString('Config', 'WebServiceUrl', PubVar_WebServiceUrl);
//      PubVar_MiddleServer        := ReadString('Config', 'MiddleServer', PubVar_WebServiceUrl);
//    end;
//  finally
//    free
//  end;
end;

procedure TAboutFrm.FormShow(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  ItemMsgText.Text := '';
  T_Ver.Text := ItemMsgText.Text;
  cbb2.Visible := False;
  for i := 0 to cbb1.Count - 1 do
    cbb1.Items[i] := UpperCase(cbb1.Items[i]);
end;

procedure TAboutFrm.btn_SaveClick(Sender: TObject);
var
  SwitchIndex: Integer;
begin
  with TIniFile.Create(GetIniFileName) do
  try
    begin
      PubVar_LoginInfo.logined := False;
      SwitchIndex := cbb1.ItemIndex;
      WriteString('Config', 'WebServiceUrl', cbb1.Items[SwitchIndex]);
      WriteString('Config', 'MiddleServer', cbb2.Items[SwitchIndex]);
      PubVar_WebServiceUrl := cbb1.Items[SwitchIndex];
      PubVar_MiddleServer := cbb2.Items[SwitchIndex];                          //

      ItemMsgText.Text := '服务器地址已保存！';
      U8DM.doinitdatae;

      btn_BaseBack.OnClick(Sender);
    end;
  finally
    free;
  end;
end;

end.

