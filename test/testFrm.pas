unit testFrm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  Generics.Collections, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Rtti, FMX.Grid.Style, Data.DB, Datasnap.DBClient, FMX.Grid, BaseForm,
  UnitU8DM, FMX.Controls.Presentation, FMX.ScrollBox, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, System.Bindings.Helper, FMX.StdCtrls, FMX.Edit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FMX.TabControl, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Layouts, FMX.Objects, Data.Bind.Controls, Fmx.Bind.Navigator,
  FMX.ListBox;

type
  TfrmTest = class(TBaseFrm)
    BindSourceDB_tabledef: TBindSourceDB;
    BindingsList1: TBindingsList;
    btn_FindParent: TButton;
    btn_ClearColumns: TButton;
    BindNavigator1: TBindNavigator;
    btn_DynamicControl: TButton;
    stringGrid_tabledef: TStringGrid;
    stringGrid_ItmDef: TStringGrid;
    BindSourceDB_ItmDef: TBindSourceDB;
    LinkGridToData_itmDef: TLinkGridToDataSource;
    NavigatorBindSourceDB2: TBindNavigator;
    LinkGridToData_tabledef: TLinkGridToDataSource;
    Lay_Frm: TLayout;
    Layout2: TLayout;
    btn_SetColumnEditStyle: TButton;
    Layout3: TLayout;
    Edit1: TEdit;
    Edit2: TEdit;
    btn_CreateSubControl: TButton;
    btn_List: TButton;
    btn_findSubControl: TButton;
    EditButton1: TEditButton;
    ClearEditButton1: TClearEditButton;
    EditButton2: TEditButton;
    Button1: TButton;
    DropDownEditButton1: TDropDownEditButton;
    btn1: TSearchEditButton;
    ComboBox1: TComboBox;
    LinkControlToFieldName: TLinkControlToField;
    LinkFillControlToFieldDef: TLinkFillControlToField;
    procedure FormDestroy(Sender: TObject);
    procedure btn_DynamicControlClick(Sender: TObject);
    procedure btn_SetColumnEditStyleClick(Sender: TObject);
    procedure btn_FindParentClick(Sender: TObject);
    procedure btn_ClearColumnsClick(Sender: TObject);
    procedure btn_CreateSubControlClick(Sender: TObject);
    procedure btn_ListClick(Sender: TObject);
    procedure btn_findSubControlClick(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTest: TfrmTest;

implementation

uses
  UnitLib;
{$R *.fmx}

procedure TfrmTest.btn_FindParentClick(Sender: TObject);
var
  i: Integer;
  iCompe: TFmxObject;
  msg: string;
begin
  inherited;
//  t1 := Sender as TSearchEditButton;
  if (Sender is TFmxObject) then
  begin
    i := 1;
    iCompe := Sender as TFmxObject;
    while True do
    begin
      msg := msg + Format('往上%d级,类型:%s,名称%s', [i, iCompe.ClassName, iCompe.Name]) + #13;
      if iCompe.Parent = nil then
      begin
        msg := msg + '--------无------------';
        Break;
      end;

      inc(i);
      iCompe := iCompe.Parent;
    end;
    ShowMessage(msg);
  end;
end;

procedure TfrmTest.btn_findSubControlClick(Sender: TObject);
var
  i: Integer;
  iCompe: TFmxObject;
  msg: string;
  c1: TControl;

  procedure FindSpecialChildrenObject(Sender: TFmxObject; ClassName1: string);
  var
    i: Integer;
    ChildObject: TFmxObject;
  begin
//    if True then
//    ShowMessage('Sender:' + Sender.Name + ':' + Sender.ClassName + ',共' + inttostr(Sender.Children.Count));
    for i := 0 to Sender.Children.Count - 1 do
    begin
      ChildObject := Sender.Children[i];
      if SameText(ChildObject.ClassName, ClassName1) = TRUE then
      begin
        ShowMessage('Found>>>>>>>>>' + ChildObject.Name + '      :' + ChildObject.ClassName + '           .');
        (ChildObject as TEditButton).OnClick := EditButton1Click;
      end;
      if ChildObject.ChildrenCount > 0 then
        FindSpecialChildrenObject(ChildObject, 'TEditButton');
    end;
  end;

begin
  inherited;
  FindSpecialChildrenObject(Edit2, 'TClearEditButton');
  Exit;
  for c1 in Edit2.Controls do
  begin
    ShowMessage('Found>>>>>>>>>' + c1.Name + ':' + c1.ClassName);
  end;
end;

procedure TfrmTest.btn_ListClick(Sender: TObject);
var
  list: TList<Integer>;
  i: integer;
begin
  list := TList<Integer>.Create;
  list.Add(1);
  list.Add(2);
  list.Add(3);
  list.Items[2] := 8;

//  for i := 0 to list.Count - 1 do
//    ShowMessage(IntToStr(list.Items[i]));
  for i in list do
  begin
    ShowMessage(IntToStr(i));
  end;
  list.Free;
end;

procedure TfrmTest.btn_ClearColumnsClick(Sender: TObject);
begin
  inherited;
  while stringGrid_tabledef.ColumnCount > 0 do
    stringGrid_tabledef.Columns[0].Destroy;
  while stringGrid_ItmDef.ColumnCount > 0 do
    stringGrid_ItmDef.Columns[0].Destroy;
end;

procedure TfrmTest.btn_DynamicControlClick(Sender: TObject);
var
  lyField: TLayout;
  txt1: TText;
  i, j: Integer;

  function getNewLay(parentLay: TLayout): TLayout;
  begin
    Result := TLayout.Create(parentLay);
    Result.Height := 20;
    Result.Align := TAlignLayout.Top;
    Result.Parent := parentLay;
  end;

begin
  inherited;
  Lay_Frm.Controls.Clear;
  for i := 0 to U8DM.FDM_SZHL_ItmDef.RecordCount - 1 do
  begin
    if U8DM.FDM_SZHL_ItmDef.FieldDefs.Find('FieldDef') <> nil then
    begin
      lyField := getNewLay(Lay_Frm);
      with TText.Create(self) do
      begin
        Text := U8DM.FDM_SZHL_ItmDef.Table.Rows[i].ValueS['FieldDef'] + ':';
        Parent := lyField;
        Position.X := 0;
        Width := 100;
        Align := TAlignLayout.Left;
        TextSettings.HorzAlign := TTextAlign.Leading;
      end;
    end;
  end;
end;

procedure TfrmTest.btn_SetColumnEditStyleClick(Sender: TObject);
var
  I: Integer;
  linkCol: TLinkGridToDataSourceColumn;
  bindSource1: TBindSourceDB;
  dataset1: TDataSet;
  Field1: TField;
begin
  inherited;
  bindSource1 := LinkGridToData_itmDef.DataSource as TBindSourceDB;

  if bindSource1 = nil then
    exit;
  dataset1 := bindSource1.DataSet;
  if dataset1 = nil then
    exit;
  LinkGridToData_itmDef.Columns.Clear;
  bindSource1.DataSet := nil;         //先断开，否则只要增加列就报错。
  for I := 0 to dataset1.FieldCount - 1 do
  begin
    linkCol := LinkGridToData_itmDef.Columns.Add;

    Field1 := dataset1.Fields[I];
    linkCol.Header := Field1.FieldName;
    linkCol.MemberName := Field1.FieldName;
    linkCol.Width := 100;
    if Field1 <> nil then
    begin
      if Field1 is TDateField then
      begin
        linkCol.ColumnStyle := 'DateColumn';
      end;
      if Field1 is TBooleanField then
      begin
        linkCol.ColumnStyle := 'CheckColumn';
      end;
      if Field1 is TIntegerField then
      begin
        linkCol.ColumnStyle := 'IntegerColumn';
      end;
      if Field1 is TNumericField then
      begin
        linkCol.ColumnStyle := 'FloatColumn';
      end;
      if Field1 is TTimeField then
      begin
        linkCol.ColumnStyle := 'TimeColumn';
      end;
    end;
  end;
  bindSource1.DataSet := dataset1;
end;

procedure TfrmTest.Button1Click(Sender: TObject);
begin
  inherited;
  with TEditButton.Create(Self) do
    Parent := Edit2;
end;

procedure TfrmTest.EditButton1Click(Sender: TObject);
var
  A: TEdit;
  object1: TObject;
begin
  inherited;
  if Sender is TEditButton then
  begin
    object1 := GetFirstParentControl(Sender, 'tEDIT');
    if object1 <> nil then
      if object1 is TEdit then
      begin
        A := object1 as TEdit;
        if A <> NIL then
        begin
          A.Text := (Sender as TEditButton).Name + ' Click!';
        end;
      end;
  end;
end;

procedure TfrmTest.btn_CreateSubControlClick(Sender: TObject);
begin
  inherited;
  with TClearEditButton.Create(Self) do
    Parent := Edit2;
end;

procedure TfrmTest.FormDestroy(Sender: TObject);
begin
  inherited;
  frmTest := nil;
end;

procedure TfrmTest.FormShow(Sender: TObject);
begin
  inherited;
// self.ComboBox1.ListBox
end;

end.

