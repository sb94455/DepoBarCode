unit CustomerForm;

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
  TCustomerFrm = class(TBaseFrm)
    cWhCodeLay: TLayout;
    txt_Search: TText;
    edt_Search: TEdit;
    DetailLay: TLayout;
    DetailText: TText;
    strngrdCustomer: TStringGrid;
    Confirm: TButton;
    FDM_Customer: TFDMemTable;
    BindSourceDB_Customer: TBindSourceDB;
    LinkGridToData_Customer: TLinkGridToDataSource;
    BindingsList_Customer: TBindingsList;
    clsBtn_1: TClearEditButton;
    srhBtn_1: TSearchEditButton;
    procedure ConfirmClick(Sender: TObject);
    procedure edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure strngrdCustomerCellDblClick(const Column: TColumn; const Row: Integer);
    procedure FormCreate(Sender: TObject);
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
  CustomerFrm: TCustomerFrm;

implementation

uses UnitU8DM,
  UnitLib;

{$R *.fmx}
{ TCustomerFrm }

procedure TCustomerFrm.srhBtn_1Click(Sender: TObject);
begin
  inherited;

  InitData;
end;

procedure TCustomerFrm.ConfirmClick(Sender: TObject);
begin
  inherited;
  DefModalResult := mrOk;
  btn_BaseBackClick(Self);

end;

procedure TCustomerFrm.edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    srhBtn_1.OnClick(srhBtn_1);
end;

procedure TCustomerFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Confirm.ModalResult := mrOk;
end;

procedure TCustomerFrm.strngrdCustomerCellDblClick(const Column: TColumn; const Row: Integer);
begin
  inherited;
  ConfirmClick(Self);
end;

procedure TCustomerFrm.InitData;
var
  strSqlText: string;
begin
  if (Length(Trim(edt_Search.Text)) + Length(Trim(edt_Search.Text)) < 1) then
  begin
    txt_BaseMsg.Text := '查询条件至少包含1个字符！';
    exit;
  end;
  strSqlText := Format('select * from Customer where cVenCode like ''%%%s%%'' or cVenName like ''%%%s%%''',
    [Trim(edt_Search.Text), Trim(edt_Search.Text)]);
  U8DM.ExecSql(FDM_Customer, strSqlText);
  U8DM.FormatGrid_byAD('客户档案参照', '', FDM_Customer, LinkGridToData_Customer);
end;

end.
