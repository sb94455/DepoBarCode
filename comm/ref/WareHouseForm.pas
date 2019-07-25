unit WareHouseForm;

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
  FMX.ListBox, Fmx.Bind.Grid;

type
  TWareHouseFrm = class(TBaseFrm)
    cWhCodeLay: TLayout;
    txt_Search: TText;
    edt_Search: TEdit;
    DetailLay: TLayout;
    DetailText: TText;
    strngrdWareHouse: TStringGrid;
    Confirm: TButton;
    FDM_WareHouse: TFDMemTable;
    BindSourceDB_WareHouse: TBindSourceDB;
    LinkGridToData_WareHouse: TLinkGridToDataSource;
    BindingsList_WareHouse: TBindingsList;
    clsBtn_1: TClearEditButton;
    srhBtn_1: TSearchEditButton;
    procedure ConfirmClick(Sender: TObject);
    procedure edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure strngrdWareHouseCellDblClick(const Column: TColumn; const Row: Integer);
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
  WareHouseFrm: TWareHouseFrm;

implementation

uses UnitU8DM,
  UnitLib;

{$R *.fmx}
{ TWareHouseFrm }

procedure TWareHouseFrm.ConfirmClick(Sender: TObject);
begin
  inherited;
  DefModalResult := mrOk;
  btn_BaseBackClick(Self);
end;

procedure TWareHouseFrm.edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    srhBtn_1.OnClick(srhBtn_1);
end;

procedure TWareHouseFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Confirm.ModalResult := mrOk;
end;

procedure TWareHouseFrm.FormShow(Sender: TObject);
begin
  inherited;
  strngrdWareHouse.ReadOnly := true;
end;

procedure TWareHouseFrm.srhBtn_1Click(Sender: TObject);
begin
  inherited;
  InitData;
end;

procedure TWareHouseFrm.strngrdWareHouseCellDblClick(const Column: TColumn; const Row: Integer);
begin
  inherited;
  ConfirmClick(Self);
end;

procedure TWareHouseFrm.InitData;
var
  strSqlText: string;
begin
  strSqlText := Format('select * from WareHouse where cWhcode like ''%%%s%%'' or cwhName like ''%%%s%%''',
    [Trim(edt_Search.Text), Trim(edt_Search.Text)]);
  U8DM.ExecSql(FDM_WareHouse, strSqlText);
  U8DM.FormatGrid_byAD('≤÷ø‚µµ∞∏≤Œ’’', '', FDM_WareHouse, LinkGridToData_WareHouse);
end;

end.
