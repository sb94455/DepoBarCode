unit uRdVouchList11;

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
  Tfrm_RdVouchList11 = class(TBaseFrm)
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
    procedure ClearBtnClick(Sender: TObject);
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
  frm_RdVouchList11: Tfrm_RdVouchList11;

implementation

uses uRdVouch11,
  MaterialOutService,
  uSZHLFMXEdit;
{$R *.fmx}

procedure Tfrm_RdVouchList11.btn_ViewVouchClick(Sender: TObject);
begin
  if FDM_VouchList.Active = true then
    if FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim <> '' then
      LoadVouch(FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim);
end;

procedure Tfrm_RdVouchList11.ClearBtnClick(Sender: TObject);
begin
  inherited;
  ClearChildCtrl(lyt_Main, False);
end;

procedure Tfrm_RdVouchList11.DeleteBtnClick(Sender: TObject);
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
          Service_Data := GetMaterialOutServiceSoap(False, PubVar_AppServer + Const_Url_Def_MaterialOut, u8dm.HTTPRIO1);
          strReturn := Service_Data.Delete(FDM_VouchList.FieldByName(VouObj.DesMainKeyField).AsString.Trim);

          if SameText(strReturn, 'OK') then
          begin
            showmessage('����ɾ���ɹ�');
            RefreshData;
          end else begin
            showmessage(format('����ɾ��ʧ��.'#10#13'%s', ['  ' + strReturn.Trim]));
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

procedure Tfrm_RdVouchList11.FDM_VouchListAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(VouObj.ListTableDef, '', FDM_VouchList, LinkGridToData_VouchList);
end;

procedure Tfrm_RdVouchList11.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FVouchObj := nil;
  frm_RdVouchList11 := nil;
end;

procedure Tfrm_RdVouchList11.FormCreate(Sender: TObject);
begin
  inherited;
  FVouchObj := TSZHL_Vouch.Create;
  with FVouchObj do
  begin
    // MainKey := strVouchId;
    ListTable := 'SZHL_Wss_V_MaterialOut_List';
    ListTabledef := '���ϳ��ⵥ�б���ͼ';

    DesMainTable := 'RdRecord11';
    DesMainTableDef := '���ϳ��ⵥ����';
    DesMainKeyField := 'ID';

    DesSubTable := 'RdRecords11';
    DesSubTableDef := '���ϳ��ⵥ�ӱ�';
    DesSubKeyField := 'Autoid';
    DesSubQtyField := 'iQuantity';
    DesSubLinkSrcFeild := 'iMPoIds'; // ��Ӧmom_moallocate.AllocateId
    DesSubCardTable:='���ϳ��ⵥ�ӱ�Ƭ��ͼ';

    SrcTable := 'SZHL_Wss_V_MaterialOut_Src';
    SrcTableDef := '���ϳ��ⵥ���������������ϱ���ͼ';
    SrcKeyField := 'AllocateId';
    SrcLinkDesSubField := 'AllocateId';
    SrcLinkMainField := 'Modid';

    SrcQtyField := 'Qty';
    SrcRmtQtyField := 'IssQty';
    SrcQty_AmtField := format('%s_Amt', [SrcQtyField.Trim]);
       Prepared;
  end;
  ClearChildCtrl(lyt_Main, False);

  txt_BaseTitle.Text := format('%s�б�', [FVouchObj.DesMainTableDef]);
  CreateADCtrl(VouObj.ListTableDef, lyt_Main, FDM_VouchList, nil, true);
end;

procedure Tfrm_RdVouchList11.InitData;
begin
  inherited;
end;

procedure Tfrm_RdVouchList11.LoadVouch(strVouchId: string);
begin
  if not Assigned(frm_RdVouch11) then
  begin
    frm_RdVouch11 := Tfrm_RdVouch11.Create(Self);
  end;

  frm_RdVouch11.VouObj := Self.VouObj;
  with frm_RdVouch11.VouObj do
  begin
    DesMainKey := strVouchId;
    if Prepared then
    begin
      frm_RdVouch11.InitData;
      ShowForm(Self, frm_RdVouch11);
    end;
  end;

end;

procedure Tfrm_RdVouchList11.QueryBtnClick(Sender: TObject);
begin
  inherited;
  RefreshData;
end;

function Tfrm_RdVouchList11.GetSqlWhereText: string;
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

procedure Tfrm_RdVouchList11.RefreshData;
var
  sqlVouchList: string;
  column      : TColumn;
begin
  LinkGridToData_VouchList.Columns.Clear; // ������䣬������calc�����ֶλᱨ���Ҳ���������1H+
  sqlVouchList := format('select distinct(cCode),cWhCode,dDate,ID from %s where %s ', [VouObj.ListTable, GetSqlWhereText]);
  DM_Global.ExecSql(FDM_VouchList, sqlVouchList);
end;

procedure Tfrm_RdVouchList11.RefreshDelete;
begin
end;

procedure Tfrm_RdVouchList11.btn_NewVouchClick(Sender: TObject);
begin
  LoadVouch('');
end;

end.
