unit uRdVouchListWW11;

interface

uses System.SysUtils,
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
  Tfrm_RdVouchListWW11 = class(TBaseFrm)
    stringGrid_VouchList: TStringGrid;
    btn_ViewVouch: TButton;
    btn_NewVouch: TButton;
    DetailText: TText;
    QueryBtn: TButton;
    ClearBtn: TButton;
    DeleteBtn: TButton;
    LinkGridToData_VouchList: TLinkGridToDataSource;
    BindingsList1: TBindingsList;
    BindSourceDB_VouchList: TBindSourceDB;
    FDM_VouchList: TFDMemTable;
    BindSourceDB_Dict: TBindSourceDB;
    lyt_Main: TLayout;
    procedure btn_ViewVouchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_NewVouchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FDM_VouchListAfterOpen(DataSet: TDataSet);
    procedure DeleteBtnClick(Sender: TObject);
    procedure QueryBtnClick(Sender: TObject);
  private
    { Private declarations }
    // FListTableName: string;
    FVouchObj: TSZHL_Vouch;
    procedure LoadVouch(strVouchId: string);
    function GetSqlWhereText: string;
  protected
    procedure InitData; override;
  public
    { Public declarations }
    procedure RefreshData; override;
    procedure RefreshDelete;
    property VouObj: TSZHL_Vouch read FVouchObj write FVouchObj;
  end;

var
  frm_RdVouchListWW11: Tfrm_RdVouchListWW11;

implementation

uses uRdVouchWW11,
  MaterialOutService,
  uSZHLFMXEdit;
{$R *.fmx}

procedure Tfrm_RdVouchListWW11.btn_ViewVouchClick(Sender: TObject);
begin
  if FDM_VouchList.Active = true then
    if FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim <> '' then
      LoadVouch(FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim);
end;

procedure Tfrm_RdVouchListWW11.DeleteBtnClick(Sender: TObject);
var
  // tmpHTTPRIO           : THTTPRIO;
  Service_Data         : MaterialOutServiceSoap;
  strReturn, strPostXML: string;
begin
  if FDM_VouchList.RecordCount > 0 then
    if FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim <> '' then
    begin
      try
        begin
          // tmpHTTPRIO := THTTPRIO.Create(Nil);
          Service_Data := GetMaterialOutServiceSoap(False, PubVar_WebServiceUrl + Const_Url_Def_MaterialOut, u8dm.HTTPRIO1);
          strReturn := Service_Data.Delete(FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim);

          if SameText(strReturn, 'OK') then
          begin
            showmessage('单据删除成功');
            RefreshData;
          end else begin
            showmessage(format('单据删除失败.'#10#13'%s', ['  ' + strReturn.Trim]));
          end;
        end
      except
        on E: Exception do
        begin
          showmessage(E.Message);
        end;
      end;
    end;

end;

procedure Tfrm_RdVouchListWW11.FDM_VouchListAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(VouObj.ListTableDef, '', FDM_VouchList, LinkGridToData_VouchList);
end;

procedure Tfrm_RdVouchListWW11.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FVouchObj := nil;
  frm_RdVouchListWW11 := nil;
end;

procedure Tfrm_RdVouchListWW11.FormCreate(Sender: TObject); // iOMoDID=1 AND iOMoMID AND cmocode AND invcode
begin
  inherited;
  FVouchObj := TSZHL_Vouch.Create;
  with FVouchObj do
  begin
    // MainKey := strVouchId;
    ListTable := 'SZHL_Wss_V_WWMaterialOut_List';
       ListTableDef := '委外材料出库单列表视图';

    DesMainTable := 'RdRecord11';
    DesMainTableDef := '委外材料出库单主表';
    DesMainKeyField := 'ID';

    DesSubTable := 'RdRecords11';
        DesSubTableDef := '委外材料出库单子表';
    DesSubKeyField := 'Autoid';
    DesSubQtyField := 'iQuantity';
    DesSubLinkSrcFeild := 'iOMoMID';

    SrcTable := 'SZHL_Wss_V_WWMaterialOut_Src';
      SrcTableDef := '委外材料出库单参照委外订单子表视图';
    SrcKeyField := 'MOMaterialsID';
    SrcLinkDesSubField := 'MOMaterialsID';
    SrcLinkMainField := 'MODetailsID';

    SrcQtyField := 'iQuantity';
    SrcRmtQtyField := 'iSendQTY';
    SrcQty_AmtField := format('%s_Amt', [SrcQtyField.Trim]);
  end;
  ClearChildCtrl(lyt_Main, False);

  txt_BaseTitle.Text := format('%s列表', [FVouchObj.DesMainTableDef]);
  CreateADCtrl(VouObj.ListTableDef, lyt_Main, FDM_VouchList, nil, true);
end;

procedure Tfrm_RdVouchListWW11.InitData;
begin
  inherited;
end;

procedure Tfrm_RdVouchListWW11.LoadVouch(strVouchId: string);
begin
  if not Assigned(frm_RdVouchWW11) then
  begin
    frm_RdVouchWW11 := Tfrm_RdVouchWW11.Create(Self);
  end;

  frm_RdVouchWW11.VouObj := Self.VouObj;
  with frm_RdVouchWW11.VouObj do
  begin
    DesMainKey := strVouchId;
    if Prepared then
    begin
      frm_RdVouchWW11.InitData;
      ShowForm(Self, frm_RdVouchWW11);
    end;
  end;

end;

procedure Tfrm_RdVouchListWW11.QueryBtnClick(Sender: TObject);
begin
  inherited;
  RefreshData;
end;

function Tfrm_RdVouchListWW11.GetSqlWhereText: string;
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
          end else begin
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
        end else begin
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
          end else begin
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

procedure Tfrm_RdVouchListWW11.RefreshData;
var
  sqlVouchList: string;
  column      : TColumn;
begin
  LinkGridToData_VouchList.Columns.Clear; // 不加这句，新增的calc类型字段会报错找不到，花费1H+
  sqlVouchList := format('select distinct(cCode),cWhCode,dDate,ID from %s where %s ', [VouObj.ListTable, GetSqlWhereText]);
  DM_Global.ExecSql(FDM_VouchList, sqlVouchList);
end;

procedure Tfrm_RdVouchListWW11.RefreshDelete;
begin
end;

procedure Tfrm_RdVouchListWW11.btn_NewVouchClick(Sender: TObject);
begin
  LoadVouch('');
end;

end.
