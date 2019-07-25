unit VouListRd01;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  DateUtils, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  BaseForm, FMX.StdCtrls, FMX.Ani, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  FMX.DateTimeCtrls, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, UnitU8DM, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client
  {$IFDEF ANDROID} , FMX.platform.Android {$ENDIF}, Soap.SOAPHTTPClient, Xml.XMLDoc,
  Xml.XMLIntf, FireDAC.Stan.StorageBin, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Controls, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Data.Bind.Components, Data.Bind.DBScope, Fmx.Bind.Navigator, Data.Bind.Grid,
  FMX.Edit,Windows;

type
  Tfrm_Rd01List = class(TBaseFrm)
    GridPanelLayout1: TGridPanelLayout;
    cMemoLay: TLayout;
    cMemoText: TText;
    edt_VenName: TEdit;
    cOrderCodeLay: TLayout;
    cOrderCodeLbl: TText;
    cCodeStartEdt: TEdit;
    Layout1: TLayout;
    iArrsIdLbl: TText;
    cCodeEndEdt: TEdit;
    stringGrid_VouchList: TStringGrid;
    btn_ViewVouch: TButton;
    btn_NewVouch: TButton;
    cCodeAndDateLay: TGridPanelLayout;
    cCodeLay: TLayout;
    cCodeText: TText;
    dDateLay: TLayout;
    dDateText: TText;
    DetailText: TText;
    QueryBtn: TButton;
    ClearBtn: TButton;
    DeleteBtn: TButton;
    dDateStartEdt: TDateEdit;
    dDateEndEdt: TDateEdit;
    LinkGridToData_VouchList: TLinkGridToDataSource;
    BindingsList1: TBindingsList;
    BindSourceDB_VouchList: TBindSourceDB;
    FDM_VouchList: TFDMemTable;
    stringGrid_Dict: TStringGrid;
    LinkGridToData_Dict: TLinkGridToDataSource;
    BindSourceDB_Dict: TBindSourceDB;
    ClearEditButton1: TClearEditButton;
    SearchEditButton1: TSearchEditButton;
    lyt_Main: TLayout;
    FDM_VouchListFilter: TFDMemTable;
    procedure btn_ViewVouchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure QueryBtnClick(Sender: TObject);
    procedure btn_NewVouchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure CalcLookupFields(DataSet: TFDMemTable; strTableName: string);
    procedure SearchEditButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FListTableName: string;
    FListFilterTableName: string;
    function GetSqlWhereText: string;
//    procedure Add_FDMCalcFields(var FDM_OldTable: TFDMemTable; strTableName: string);
  protected
    procedure InitData; override;
  public
    { Public declarations }
    procedure RefreshData; override;
    procedure RefreshDelete;
  end;

var
  frm_Rd01List: Tfrm_Rd01List;

implementation

uses
  UnitLib, PurchaseInService, VouRd01, uSZHLFMXEdit;
{$R *.fmx}

procedure Tfrm_Rd01List.btn_ViewVouchClick(Sender: TObject);
var
  vouchId1: string;
begin
  if FDM_VouchList.Eof then
    Exit;
  vouchId1 := FDM_VouchList.FieldByName('id').AsString;
  if vouchId1 = '' then
    exit;

  if not Assigned(frm_Rd01) then
  begin
    frm_Rd01 := tfrm_Rd01.Create(Self);
    with frm_Rd01.VouchObj do
    begin
      RdFlag := 1;

      vouchId := vouchId1;
      VouchTableName := 'RdRecord01';
      VouchKeyFieldName := 'ID';

      VouchsKeyFieldName := 'AutoID';
      VouchsTableName := 'RdRecords01';
      VouchsQtyFieldName := 'iQuantity';
      VouchsRelationSourceFieldName := 'iArrsId';
      VouchsRelationVouchFieldName := 'id';

      SourceVouchTableName := 'WssBC_ArrivalVouchs_NotIn';
      SourceVouchKeyFieldName := 'Autoid';
      SourceVouchQtyFieldName := 'fValidQuantity';
      SourceVouchRmtQtyFieldName := 'fValidInQuan';
    end;
    frm_Rd01.RefreshData;
  end;

  ShowForm(Self, frm_Rd01);
end;

//procedure Tfrm_Rd01List.CalcLookupFields(DataSet: TFDMemTable; strTableName: string);
//var
// i: Integer;
//  Field_Current: TField;
//  FDM_Result: TFDMemTable;
//  LookupKeyFieldName, LookupRefTableName, LookupRefKeyFieldName, LookupRefFieldName: string;
//  strSqlText: string;
// LookupKeyFieldName_DataType: TFieldType;
//
//  procedure subProcedure();
//  begin
//    Field_Current := DataSet.FieldList.Find(DM_Global.FDM_SZHL_ItmDef.FieldByName('FieldName').AsString);
//    if Field_Current <> nil then
//    begin
//      LookupKeyFieldName := DM_Global.FDM_SZHL_ItmDef.FieldByName('LookupKeyFieldName').AsString;
//      LookupRefTableName := DM_Global.FDM_SZHL_ItmDef.FieldByName('LookupRefTableName').AsString;
//      LookupRefKeyFieldName := DM_Global.FDM_SZHL_ItmDef.FieldByName('LookupRefKeyFieldName').AsString;
//      LookupRefFieldName := DM_Global.FDM_SZHL_ItmDef.FieldByName('LookupRefFieldName').AsString;
//      if DataSet.FieldByName(LookupKeyFieldName) is TStringField then
//      begin
//        strSqlText := Format('select %s Field1 from %s where %s=''%s''', [LookupRefFieldName, LookupRefTableName, LookupRefKeyFieldName, DataSet.FieldByName(LookupKeyFieldName).AsString]);
//      end
//      else if DataSet.FieldByName(LookupKeyFieldName) is TNumericField then
//      begin
//        strSqlText := Format('select %s from %s where %s=%s', [LookupRefFieldName, LookupRefTableName, LookupRefKeyFieldName, DataSet.FieldByName(LookupKeyFieldName).AsString]);
//      end;
//      FDM_Result := TFDMemTable.Create(self);
//      DM_Global.ExecSql(FDM_Result, strSqlText);
//      if FDM_Result.RecordCount > 0 then
//      begin
//        DataSet.FieldByName(Field_Current.FieldName).Value := FDM_Result.Fields[0].Value;
//      end;
//    end;
//  end;
//
//begin
//  inherited;
//  if FDM_VouchList.RecordCount > 0 then
//  begin
//    if DM_Global.SetADTable(strTableName) then
//      Exit;
//    DM_Global.FDM_SZHL_ItmDef.Filtered := False;
//    DM_Global.FDM_SZHL_ItmDef.Filter := 'FieldKind=''Lookup''';
//    DM_Global.FDM_SZHL_ItmDef.Filtered := True;
//
//    FDM_VouchList.BeginBatch();
//    FDM_VouchList.First;
//    while not FDM_VouchList.eof do
//    begin
//      FDM_VouchList.Edit;
////      CalcLookupFields(FDM_VouchList, FListTableName);
//      if DM_Global.FDM_SZHL_ItmDef.FindFirst then
//      begin
//        subProcedure;
//      end;
//      while DM_Global.FDM_SZHL_ItmDef.FindNext do
//      begin
//        subProcedure;
//      end;
//
//      FDM_VouchList.Post;
//      FDM_VouchList.next;
//    end;
//    FDM_VouchList.EndBatch;
//  end;
//
//end;

procedure Tfrm_Rd01List.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frm_Rd01List := nil;
end;

procedure Tfrm_Rd01List.FormCreate(Sender: TObject);
var
  sqlVouchList: string;
begin
  inherited;
  ClearChildCtrl(lyt_Main, False);

  FListTableName := 'WssBC_V_PurchaseInList';
  FListFilterTableName := 'WssBC_V_PurchaseInList_Filter';

  CreateADFilterCtrl(FListFilterTableName, lyt_Main, FDM_ADDict);

  dDateStartEdt.Date := StartOfTheMonth(Now);
  dDateEndEdt.Date := Now;
  stringGrid_Dict.Visible := False;
  {$IFDEF DEBUG}
  stringGrid_Dict.Visible := True;
  {$ENDIF}
end;

procedure Tfrm_Rd01List.FormShow(Sender: TObject);
var
settings: TFormatSettings;
begin
  inherited;
  GetLocaleFormatSettings(GetUserDefaultLCID, settings);
  settings.DateSeparator := '-';
  settings.TimeSeparator := ':';
  settings.ShortDateFormat := 'yyyy-mm-dd';
  settings.ShortTimeFormat := 'hh:nn:ss';
  dDateStartEdt.DateTime := StrToDateTime('2017-12-1',settings);  //需要进行格式转换
end;

procedure Tfrm_Rd01List.InitData;
begin
  inherited;
//  DataGrid.ReadOnly := true;
//  AlignHeaders(DataGrid);
end;

procedure Tfrm_Rd01List.QueryBtnClick(Sender: TObject);
var
  sqlVouchList: string;
  column: TColumn;
begin

  LinkGridToData_VouchList.Columns.Clear;     //不加这句，新增的calc类型字段会报错找不到，花费1H+
  sqlVouchList := Format('select * from %s where %s ', [FListTableName, GetSqlWhereText]);
  DM_Global.ExecSql(FDM_VouchList, sqlVouchList);

//  DM_Global.Add_FDMCalcFields(FDM_VouchList, FListTableName);
  DM_Global.CalcLookupFields(FDM_VouchList, FListTableName);

  DM_Global.FormatGrid_byAD(FListTableName, '', FDM_VouchList, LinkGridToData_VouchList);
end;

function Tfrm_Rd01List.GetSqlWhereText: string;
var
  strSqlstring: string;

  procedure FindSpecialChildrenObject(Sender: TFmxObject; var strSql: string);
  var
    i: Integer;
    ChildObject: TFmxObject;
    SZHL_Edit: TSZHL_Edit;
    SZHL_DateEdit: TSZHL_DateEdit;
  begin
//    if True then
//    ShowMessage('Sender:' + Sender.Name + ':' + Sender.ClassName + ',共' + inttostr(Sender.Children.Count));
    for i := 0 to Sender.Children.Count - 1 do
    begin
      ChildObject := Sender.Children[i];
      if ChildObject is TSZHL_Edit then
      begin
        SZHL_Edit := (ChildObject as TSZHL_Edit);
        if SZHL_Edit.FieldDict.isBetween = true then
        begin
          if SZHL_Edit.Seq = 1 then
          begin
            strSql := strSql + format('and %s>=''%s''', [SZHL_Edit.FieldDict.FieldName, SZHL_Edit.Text.Trim]) + #13;
          end;
          if SZHL_Edit.Seq = 2 then
          begin
            strSql := strSql + format('and %s<=''%s''', [SZHL_Edit.FieldDict.FieldName, SZHL_Edit.Text.Trim]) + #13;
          end;
        end
        else
        begin
          strSql := strSql + format('and %s=''%s''', [SZHL_Edit.FieldDict.FieldName, SZHL_Edit.Text.Trim]) + #13;
        end;

      end;
      if ChildObject is TSZHL_DateEdit then
      begin
        SZHL_DateEdit := (ChildObject as TSZHL_DateEdit);
        if SZHL_DateEdit.FieldDict.isBetween = true then
        begin
          if SZHL_DateEdit.Seq = 1 then
          begin
            strSql := strSql + format('and %s>=''%s''', [SZHL_DateEdit.FieldDict.FieldName, SZHL_DateEdit.Text.Trim]) + #13;
          end;
          if SZHL_DateEdit.Seq = 2 then
          begin
            strSql := strSql + format('and %s<=''%s''', [SZHL_DateEdit.FieldDict.FieldName, SZHL_DateEdit.Text.Trim]) + #13;
          end;
        end
        else
        begin
          strSql := strSql + format('and %s=''%s''', [SZHL_DateEdit.FieldDict.FieldName, SZHL_DateEdit.Text.Trim]) + #13;
        end;

      end;
      if ChildObject.ChildrenCount > 0 then
        FindSpecialChildrenObject(ChildObject, strSql);
    end;
  end;

begin
  strSqlstring := '1=1'#13;

  FindSpecialChildrenObject(lyt_Main, strSqlstring);
  result := strSqlstring;
//  if Length(Trim(cCodeStartEdt.Text)) > 0 then
//  begin
//    Result := Result + Format(' and Code>=''%s''', [Trim(cCodeStartEdt.Text)]);
//  end;
//  if Length(Trim(cCodeEndEdt.Text)) > 0 then
//  begin
//    Result := Result + Format(' and Code>=''%s''', [Trim(cCodeEndEdt.Text)]);
//  end;
//  if Length(Trim(dDateStartEdt.Text)) > 0 then
//  begin
//    Result := Result + ' and dDate>=''' + FormatDateTime('YYYY-MM-dd', dDateStartEdt.Date) + ''''
//  end;
//  if Length(Trim(dDateEndEdt.Text)) > 0 then
//  begin
//    Result := Result + ' and dDate<=''' + FormatDateTime('YYYY-MM-dd', dDateEndEdt.Date) + ''''
//  end;
//
end;

procedure Tfrm_Rd01List.RefreshData;
begin

end;

procedure Tfrm_Rd01List.RefreshDelete;
begin
end;

procedure Tfrm_Rd01List.SearchEditButton1Click(Sender: TObject);
var
  a: TEdit;
begin
  a := GetFirstParentControl(Sender, edt_VenName.ClassName) as TEdit;
  if a <> nil then
  begin
    a.Text := 'a:=getNearlySpecialObject(Sender, edt_VenName.ClassName);';
//    a.Tag
  end;
end;

//procedure Tfrm_Rd01List.Add_FDMCalcFields(var FDM_OldTable: TFDMemTable; strTableName: string);
//var
//  FDM_NewTable: TFDMemTable;
//  HasNew: Boolean;
//
//  procedure DoAddFieldDef;
//  begin
//    with FDM_NewTable.FieldDefs.AddFieldDef do
//    begin
//      name := trim(DM_Global.FDM_SZHL_ItmDef.FieldByName('Fieldname').AsString);
//      DisplayName := trim(DM_Global.FDM_SZHL_ItmDef.FieldByName('Fieldname').AsString);
//      DataType := ftWideString;
//      Size := 50;
//      Required := true;
//      Attributes := [faReadonly];
//    end;
//  end;
//
//begin
//  FDM_NewTable := TFDMemTable.Create(Application);
//  FDM_NewTable.FieldDefs.Assign(FDM_OldTable.FieldDefs);
//
//  try
//    if not DM_Global.SetADTable(strTableName) then
//      Exit;
//    DM_Global.FDM_SZHL_ItmDef.Filtered := False;
//    DM_Global.FDM_SZHL_ItmDef.Filter := 'FieldKind=''Lookup''';
//    DM_Global.FDM_SZHL_ItmDef.Filtered := True;
//    HasNew := False;
//    if DM_Global.FDM_SZHL_ItmDef.FindFirst then
//    begin
//      HasNew := True;
//      DoAddFieldDef;
//    end;
//    while DM_Global.FDM_SZHL_ItmDef.FindNext do
//    begin
//      DoAddFieldDef;
//    end;
//    FDM_NewTable.CreateDataSet;
//  finally
//    if HasNew = true then
//    begin
//      FDM_NewTable.AppendData(FDM_OldTable.Data);
//      FreeAndNil(FDM_OldTable);
//      FDM_OldTable := FDM_NewTable;
//    end
//    else
//    begin
//      FreeAndNil(FDM_NewTable);
//    end;
//  end;
//
//end;

procedure Tfrm_Rd01List.btn_NewVouchClick(Sender: TObject);
//var
//  vouchid: string;
begin

  if not Assigned(frm_Rd01) then
  begin
    frm_Rd01 := tfrm_Rd01.Create(Self);
    with frm_Rd01.VouchObj do
    begin
      RdFlag := 1;

      vouchId := '-';
      VouchTableName := 'RdRecord01';
      VouchKeyFieldName := 'ID';

      VouchsKeyFieldName := 'AutoID';
      VouchsTableName := 'RdRecords01';
      VouchsKeyFieldName := 'Autoid';
      VouchsQtyFieldName := 'iQuantity';
      VouchsRelationSourceFieldName := 'iArrsId';
      VouchsRelationVouchFieldName := 'id';

      SourceVouchTableName := 'WssBC_ArrivalVouchs_NotIn';
      SourceVouchKeyFieldName := 'Autoid';
      SourceVouchQtyFieldName := 'fValidQuantity';
      SourceVouchRmtQtyFieldName := 'fValidInQuan';
    end;

    frm_Rd01.RefreshData;

    ShowForm(Self, frm_Rd01);
  end;
end;

end.

