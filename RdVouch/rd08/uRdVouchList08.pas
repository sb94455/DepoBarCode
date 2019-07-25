unit uRdVouchList08;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  DateUtils,
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
  FMX.DateTimeCtrls,
  System.Rtti,
  FMX.Grid.Style,
  FMX.Grid,
  FMX.ScrollBox,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  UnitU8DM,
  FireDAC.DApt.Intf,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client{$IFDEF ANDROID} ,
  FMX.platform.Android {$ENDIF},
  Soap.SOAPHTTPClient,
  Xml.XMLDoc,
  Xml.XMLIntf,
  FireDAC.Stan.StorageBin,
  FMX.Bind.Grid,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.Controls,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,
  FMX.Bind.Navigator,
  Data.Bind.Grid,
  FMX.Edit,
  FMX.ListBox,
  UnitLib;

type
  Tfrm_RdVouchList08 = class(TBaseFrm)
    FDM_VouchList: TFDMemTable;
    lyt_Main: TLayout;
    DetailText: TText;
    QueryBtn: TButton;
    ClearBtn: TButton;
    stringGrid_VouchList: TStringGrid;
    btn_ViewVouch: TButton;
    btn_NewVouch: TButton;
    BindSourceDB_VouchList: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToData_VouchList: TLinkGridToDataSource;
    BindSourceDB_Dict: TBindSourceDB;
    procedure FormCreate(Sender: TObject);
    procedure btn_BaseBackClick(Sender: TObject);
    procedure QueryBtnClick(Sender: TObject);
    procedure btn_ViewVouchClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure btn_NewVouchClick(Sender: TObject);
    procedure FDM_VouchListAfterOpen(DataSet: TDataSet);
  private
    FVouchObj: TSZHL_Vouch;
    function GetSqlWhereText: string;
    procedure LoadVouch(strVouchId: string);
    { Private declarations }
  public
    procedure RefreshData; override;
    property VouObj: TSZHL_Vouch read FVouchObj write FVouchObj;
    { Public declarations }
  end;

var
  frm_RdVouchList08: Tfrm_RdVouchList08;

implementation

uses
  uRdVouch01,
  uRdVouch08,
  uSZHLFMXEdit;
{$R *.fmx}

procedure Tfrm_RdVouchList08.btn_BaseBackClick(Sender: TObject);
begin
  inherited;
  frm_RdVouchList08 :=nil;
end;

procedure Tfrm_RdVouchList08.btn_NewVouchClick(Sender: TObject);
begin
  inherited;
  LoadVouch('');
end;

procedure Tfrm_RdVouchList08.btn_ViewVouchClick(Sender: TObject);
begin
  if FDM_VouchList.Active = true then
    if FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim <> '' then
      LoadVouch(FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim);
end;

procedure Tfrm_RdVouchList08.ClearBtnClick(Sender: TObject);
begin
  inherited;
  ClearChildCtrl(lyt_Main,False);
end;

procedure Tfrm_RdVouchList08.LoadVouch(strVouchId: string);
begin
  if not Assigned(frm_RdVouch08) then
  begin
    frm_RdVouch08 := Tfrm_RdVouch08.Create(Self);
  end;
 // frm_RdVouch08.Tab_Sub.Visible := strVouchId.IsEmpty;             //
  frm_RdVouch08.VouObj := Self.VouObj;
  with frm_RdVouch08.VouObj do
  begin
    DesMainKey := strVouchId;
    if Prepared then
    begin
      frm_RdVouch08.InitData;
      ShowForm(Self, frm_RdVouch08);
    end;
  end;

end;

procedure Tfrm_RdVouchList08.FDM_VouchListAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(VouObj.ListTableDef, '', FDM_VouchList, LinkGridToData_VouchList);
end;

procedure Tfrm_RdVouchList08.FormCreate(Sender: TObject);
begin
  inherited;
  FVouchObj := TSZHL_Vouch.Create;
  with FVouchObj do
  begin
    // MainKey := strVouchId;
    ListTable := 'SZHL_Wss_V_OtherIn_List';
    ListTableDef := '其他入库单列表视图';

    DesMainTable := 'RdRecord08';
    DesMainTableDef := '其他入库单主表';
    DesMainKeyField := 'ID';

    DesSubTable := 'RdRecords08';
    DesSubTableDef     := '其他入库单子表';
    DesSubKeyField := 'Autoid';
    DesSubQtyField := 'iQuantity';
    DesSubLinkSrcFeild := 'iMPoIds';
    DesSubLinkMainFeild := 'ID';

    SrcTable := 'SZHL_Wss_V_ProductIn_Src';
    SrcTableDef       := '产成品入库单参照生产订单视图';
    SrcKeyField := 'ModId';
    SrcLinkDesSubField := 'ModId';
    SrcQtyField := 'Qty';
    SrcRmtQtyField := 'sumQty';
    SrcLinkMainField := 'MOID'; // mom_order.ID

    SrcQty_AmtField := format('%s_Amt', [SrcQtyField.Trim]);
       Prepared;
  end;
  ClearChildCtrl(lyt_Main, False);

  txt_BaseTitle.Text := format('%s列表', [FVouchObj.DesMainTableDef]);
  CreateADCtrl(VouObj.ListTableDef, lyt_Main, FDM_VouchList, nil, true);
end;

procedure Tfrm_RdVouchList08.QueryBtnClick(Sender: TObject);
begin
  inherited;
  RefreshData;
end;

procedure Tfrm_RdVouchList08.RefreshData;
var
  sqlVouchList: string;
  column      : TColumn;
begin
  LinkGridToData_VouchList.Columns.Clear; // 不加这句，新增的calc类型字段会报错找不到，花费1H+
  sqlVouchList := format('select distinct(cCode) ,cWhCode ,dDate,ID from %s where %s order by ID', [VouObj.ListTable, GetSqlWhereText]);
  DM_Global.ExecSql(FDM_VouchList, sqlVouchList);
end;

function Tfrm_RdVouchList08.GetSqlWhereText: string;
var
  strSqlstring: string;

  procedure FindSpecialChildrenObject(Sender: TFmxObject; var strSql: string);
  var
    i, SZHL_ComboBox_ItemIndex: Integer;
    ChildObject               : TFmxObject;
    SZHL_Edit                 : TSZHL_Edit;
    SZHL_DateEdit             : TSZHL_DateEdit;
    SZHL_ComboBox             : TSZHL_ComboBox;
  begin
    for i := 0 to Sender.Children.Count - 1 do
    begin
      ChildObject := Sender.Children[i];
      if ChildObject is TSZHL_Edit then
      begin
        SZHL_Edit := (ChildObject as TSZHL_Edit);
        if SZHL_Edit.Text.Trim <> '' then
        begin
          if SZHL_Edit.FieldDict.isBetween = true then
          begin

            if SZHL_Edit.FieldDict.ConditionPos = 1 then
            begin
              strSql := strSql + format('and %s>=''%s''', [SZHL_Edit.FieldDict.FieldName, SZHL_Edit.Text.Trim]);
            end;
            if SZHL_Edit.FieldDict.ConditionPos = 2 then
            begin
              strSql := strSql + format('and %s<=''%s''', [SZHL_Edit.FieldDict.FieldName, SZHL_Edit.Text.Trim]);
            end;
          end
          else
          begin
            strSql := strSql + format('and %s=''%s''', [SZHL_Edit.FieldDict.FieldName, SZHL_Edit.Text.Trim]);
          end;
        end;
      end;

      if ChildObject is TSZHL_DateEdit then
      begin
        SZHL_DateEdit := (ChildObject as TSZHL_DateEdit);
        if SZHL_DateEdit.FieldDict.isBetween = true then
        begin
          if SZHL_DateEdit.FieldDict.ConditionPos = 1 then
          begin
            strSql := strSql + format(' and %s>=''%s''', [SZHL_DateEdit.FieldDict.FieldName, SZHL_DateEdit.Text.Trim]);
          end;
          if SZHL_DateEdit.FieldDict.ConditionPos = 2 then
          begin
            strSql := strSql + format(' and %s<=''%s''', [SZHL_DateEdit.FieldDict.FieldName, SZHL_DateEdit.Text.Trim]);
          end;
        end
        else
        begin
          strSql := strSql + format(' and %s=''%s''', [SZHL_DateEdit.FieldDict.FieldName, SZHL_DateEdit.Text.Trim]);
        end;

      end;
      if ChildObject is TSZHL_ComboBox then
      begin
        SZHL_ComboBox := ChildObject as TSZHL_ComboBox;
        if SZHL_ComboBox.ItemIndex >= 0 then
        begin
          SZHL_ComboBox_ItemIndex := SZHL_ComboBox.ItemIndex;
          if SZHL_ComboBox.FieldDict.isBetween = true then
          begin
            if SZHL_ComboBox.FieldDict.ConditionPos = 1 then
            begin
              strSql := strSql + format(' and %s>=''%s''', [SZHL_ComboBox.FieldDict.FieldName,
                SZHL_ComboBox.RefValue.Strings[SZHL_ComboBox_ItemIndex]]);
            end;
            if SZHL_ComboBox.FieldDict.ConditionPos = 2 then
            begin
              strSql := strSql + format(' and %s<=''%s''', [SZHL_ComboBox.FieldDict.FieldName,
                SZHL_ComboBox.RefValue.Strings[SZHL_ComboBox_ItemIndex]]);
            end;
          end
          else
          begin
            strSql := strSql + format('and %s=''%s''', [SZHL_ComboBox.FieldDict.FieldName, SZHL_ComboBox.RefValue.Strings[SZHL_ComboBox_ItemIndex]]);
          end;
        end;
      end;
      if ChildObject.ChildrenCount > 0 then
         FindSpecialChildrenObject(ChildObject, strSql);
    end;
  end;

begin
  strSqlstring := '1=1 ';

  FindSpecialChildrenObject(lyt_Main, strSqlstring);
  result := strSqlstring;
end;

end.
