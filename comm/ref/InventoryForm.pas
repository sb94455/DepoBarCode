unit InventoryForm;

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
  TInventoryFrm = class(TBaseFrm)
    cCodeLay: TLayout;
    txt_Search: TText;
    edt_Search: TEdit;
    DetailLay: TLayout;
    DetailText: TText;
    strngrdInventory: TStringGrid;
    Confirm: TButton;
    FDM_Inventory: TFDMemTable;
    BindSourceDB_Inventory: TBindSourceDB;
    LinkGridToData_Inventory: TLinkGridToDataSource;
    BindingsList_Inventory: TBindingsList;
    clsBtn_1: TClearEditButton;
    srhBtn_1: TSearchEditButton;
    procedure edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_cInvNameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure ConfirmClick(Sender: TObject);
    procedure strngrdInventoryCellDblClick(const Column: TColumn; const Row: Integer);
    procedure srhBtn_1Click(Sender: TObject);
  private
    FDefModalResult: TModalResult;
  protected
    procedure InitData; override;
  public
    procedure RefreshData; override;
    property DefModalResult: TModalResult read FDefModalResult write FDefModalResult;
  end;

var
  InventoryFrm: TInventoryFrm;

implementation

uses UnitLib,
  UnitU8DM;
{$R *.fmx}

procedure TInventoryFrm.edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    Self.srhBtn_1.OnClick(Self.srhBtn_1);
end;

procedure TInventoryFrm.edt_cInvNameKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    Self.srhBtn_1.OnClick(Self.srhBtn_1);
end;

procedure TInventoryFrm.ConfirmClick(Sender: TObject);
begin
  DefModalResult := mrOk;
  btn_BaseBackClick(Self);
end;

procedure TInventoryFrm.InitData;
var
  strSqlText: string;
begin
  if Length(Trim(edt_Search.Text)) < 2 then
  begin
    txt_BaseMsg.Text := '查询条件至少包含2位字符！';
    showmessage(txt_BaseMsg.Text);
    exit;
  end;
  strSqlText := Format('select * from inventory where cInvCode like ''%%%s%%'' or cInvName like ''%%%s%%''',
    [Trim(edt_Search.Text), Trim(edt_Search.Text)]);
  U8DM.ExecSql(FDM_Inventory, strSqlText);
  U8DM.FormatGrid_byAD('存货档案参照', '', FDM_Inventory, LinkGridToData_Inventory);
end;

procedure TInventoryFrm.RefreshData;
var
  LoopInt: Integer;
begin
  inherited;
  AniIndicator.Visible := False;
end;

procedure TInventoryFrm.srhBtn_1Click(Sender: TObject);

begin
  inherited;

  InitData;
end;

procedure TInventoryFrm.strngrdInventoryCellDblClick(const Column: TColumn; const Row: Integer);
begin
  inherited;
  ConfirmClick(Self);
end;

end.
