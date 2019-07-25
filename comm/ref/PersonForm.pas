unit PersonForm;

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
  BaseForm,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.Layouts,
  FMX.Objects,
  FMX.Controls.Presentation,
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid,
  FMX.ScrollBox,
  FMX.Edit,
  Soap.InvokeRegistry,
  Soap.Rio,
  Soap.SOAPHTTPClient,
  Inifiles,
  IOUtils,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FMX.Bind.Grid,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.Grid,
  Data.Bind.DBScope,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.ListBox;

type
  TpersonFrm = class(TBaseFrm)
    cWhCodeLay: TLayout;
    txt_Search: TText;
    edt_Search: TEdit;
    DetailLay: TLayout;
    DetailText: TText;
    strngrdPerson: TStringGrid;
    Confirm: TButton;
    FDM_Person: TFDMemTable;
    BindSourceDB_Person: TBindSourceDB;
    LinkGridToData_Person: TLinkGridToDataSource;
    BindingsList_Person: TBindingsList;
    clsBtn_1: TClearEditButton;
    srhBtn_1: TSearchEditButton;
    procedure ConfirmClick(Sender: TObject);
    procedure edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure strngrdPersonCellDblClick(const Column: TColumn; const Row: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure srhBtn_1Click(Sender: TObject);
  private
    FBindForm      : TForm;
    FDefModalResult: TModalResult;
  protected

  public
    procedure InitData; override;
    property BindForm: TForm read FBindForm write FBindForm;
    property DefModalResult: TModalResult read FDefModalResult write FDefModalResult;
  end;

var
  personFrm: TpersonFrm;

implementation

uses UnitU8DM,
  UnitLib;

{$R *.fmx}
{ TpersonFrm }

procedure TpersonFrm.ConfirmClick(Sender: TObject);
begin
  inherited;
  DefModalResult := mrOk;
  btn_BaseBackClick(Self);
end;

procedure TpersonFrm.edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    srhBtn_1.OnClick(srhBtn_1);
end;

procedure TpersonFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Confirm.ModalResult := mrOk;
end;

procedure TpersonFrm.FormShow(Sender: TObject);
begin
  inherited;
  strngrdPerson.ReadOnly := true;
end;

procedure TpersonFrm.srhBtn_1Click(Sender: TObject);
begin
  InitData;
end;

procedure TpersonFrm.strngrdPersonCellDblClick(const Column: TColumn; const Row: Integer);
begin
  inherited;

  ConfirmClick(Self);
end;

procedure TpersonFrm.InitData;
var
  strSqlText: string;
begin
  inherited;
  strSqlText := Format('select * from person where cPersonCode like ''%%%s%%'' or cPersonName like ''%%%s%%''',
    [Trim(edt_Search.Text), Trim(edt_Search.Text)]);
  U8DM.ExecSql(FDM_Person, strSqlText);
  U8DM.FormatGrid_byAD('人员档案参照', '', FDM_Person, LinkGridToData_Person);
end;

end.
