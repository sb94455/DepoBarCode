unit StockForm;

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
  FMX.Layouts,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.Ani,
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid,
  FMX.ScrollBox,
  FMX.Edit,
  FMX.ListBox,
  WareHouseForm,
  UnitLib,
  PositionForm,
  InventoryForm,
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
  FMX.Menus;

type
  TStockFrm = class(TBaseFrm)
    DetailLay: TLayout;
    DetailText: TText;
    stringGrid_CurrentStock: TStringGrid;
    QueryBtn: TButton;
    GridPanelLayout1: TGridPanelLayout;
    cInvAddCodeLay: TLayout;
    edt_Inventory: TEdit;
    cFree2Lay: TLayout;
    edt_WareHouse: TEdit;
    cDefine22Lay: TLayout;
    edt_cBatch: TEdit;
    ClearBtn: TButton;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    ClearEditButton3: TClearEditButton;
    FDM_CurrentStock: TFDMemTable;
    BindSourceDB_CurrentStock: TBindSourceDB;
    LinkGridToData_CurrentStock: TLinkGridToDataSource;
    BindingsList_CurrentStock: TBindingsList;
    PopupMenu1: TPopupMenu;
    mniSaveWidth: TMenuItem;
    SearchEditButton1: TSearchEditButton;
    SearchEditButton2: TSearchEditButton;
    SearchEditButton3: TSearchEditButton;
    lbl_Inventory: TLabel;
    lbl_WareHouse: TLabel;
    lbl_Batch: TLabel;
    procedure QueryBtnClick(Sender: TObject);
    procedure edt_InventoryKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_WareHouseKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_cBatchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure mniSaveWidthClick(Sender: TObject);
    procedure SearchEditButton2Click(Sender: TObject);
    procedure SearchEditButton1Click(Sender: TObject);
    procedure SearchEditButton3Click(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure btn_BaseBackClick(Sender: TObject);

  private
    FQRCode: string;
    FVouchObj: TSZHL_Vouch;
//    FWareHouseFrm: TWareHouseFrm;
    // FPositionFrm: TPositionFrm;
    procedure DecryptQRCode;

  protected
    procedure InitData; override;
  public
    procedure RefreshData; override;
  end;

var
  StockFrm: TStockFrm;

implementation

uses UnitU8DM  ;

{$R *.fmx}
{ TStockFrm }


procedure TStockFrm.DecryptQRCode;        //现存量扫码获得存货编码，重写edt_Inventory的OnKeyUp事件
var
  cmd : string;
  function GetSourceVouchKeyValue(): string;
  begin
    Result := GetValueByKey(FQRCode, FVouchObj.SrcKeyField);
  end;
begin
  FQRCode := edt_Inventory.Text;
  edt_Inventory.Text := '';
  cmd := Trim(GetValueByKey(FQRCode, 'c'));
  if SameText(cmd, 'A') = true then
  begin
    edt_Inventory.Text := Trim(GetValueByKey(FQRCode, 'cInvCode'));
  end;
end;

procedure TStockFrm.QueryBtnClick(Sender: TObject);
var
  strSqlText: string;
  AllQty : Double;

  function getSqlWhereText: string;
  begin
    Result := '';
    if Length(edt_Inventory.Text.Trim) > 0 then
    begin
      Result := Result + format(' and cInvCode=''%s''', [edt_Inventory.Text.Trim]);
    end;
    if Length(Trim(edt_WareHouse.Text)) > 0 then
    begin
      Result := Result + format(' and cWhCode=''%s''', [edt_WareHouse.Text.Trim]);
    end;
    if Length(Trim(edt_cBatch.Text)) > 0 then
    begin
      Result := Result + format(' and cPosCode LIKE ''%s%%''', [edt_cBatch.Text.Trim]);
    end;
    if Result = '' then
    begin
      Self.txt_BaseMsg.Text := '请先选择一个条件！';
      Abort;
    end;
  end;

begin
  inherited;
  strSqlText :=  'Select * from CurrentStock where 1=1 ' + getSqlWhereText;
  U8DM.ExecSql(FDM_CurrentStock, strSqlText);
  U8DM.FormatGrid_byAD('现存量表', '', FDM_CurrentStock, LinkGridToData_CurrentStock);

  if edt_Inventory.Text.Trim <> '' then
  begin
    AllQty := 0;
    FDM_CurrentStock.first;
    while not FDM_CurrentStock.Eof do
    begin
      AllQty := AllQty + FDM_CurrentStock.FieldByName('iQuantity').AsFloat ;
      FDM_CurrentStock.Next;
    end;
    FDM_CurrentStock.Append;
    FDM_CurrentStock.FieldByName('cInvCode').Value := '合计';
    FDM_CurrentStock.FieldByName('iQuantity').Value := AllQty ;
    FDM_CurrentStock.Post;
  end
end;

procedure TStockFrm.edt_InventoryKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
  begin
    DecryptQRCode;
    edt_Inventory.SetFocus;
  end;
       //getInventory(Self, edt_Inventory);
end;

procedure TStockFrm.btn_BaseBackClick(Sender: TObject);
begin
  inherited;
  StockFrm :=nil;         //其他窗口释放窗口的方法不适用 -----释放窗体
end;


procedure TStockFrm.ClearBtnClick(Sender: TObject);
begin
  inherited;
  edt_Inventory.text :='';            //清空按钮
  edt_Warehouse.text :='';
  edt_cBatch.text:='';

end;

procedure TStockFrm.edt_cBatchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    getPostion(Self, edt_cBatch,edt_cBatch.Text);
end;

procedure TStockFrm.edt_WareHouseKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
     getWareHouse(Self, edt_WareHouse);
end;

procedure TStockFrm.InitData;
begin
end;

procedure TStockFrm.mniSaveWidthClick(Sender: TObject);
begin
  inherited;
  ShowMessage_debug('mniSaveWidthClick');
end;

procedure TStockFrm.RefreshData;
begin

end;

procedure TStockFrm.SearchEditButton1Click(Sender: TObject);
begin
  inherited;
 getPostion(Self, edt_cBatch,edt_WareHouse.Text);               //查询仓库必须
end;

procedure TStockFrm.SearchEditButton2Click(Sender: TObject);
begin
  inherited;
  getWareHouse(Self, edt_WareHouse);
end;

procedure TStockFrm.SearchEditButton3Click(Sender: TObject);
begin
  inherited;
     getInventory(Self, edt_Inventory);
end;

end.
