unit uSZHLFMXEdit;

interface

uses
  FMX.DateTimeCtrls, FMX.Edit, FMX.Text, FMX.types, FireDAC.Comp.Client, System.SysUtils,
  StrUtils, System.classes, FMX.ListBox, Data.Bind.Grid, FMX.NumberBox, FMX.StdCtrls;

type
  TSZHL_FieldDict = class(TObject)
    FDMDataSet: TFDMemTable;
    ConditionPos: Integer;
    Autoid: Integer;
    FieldKind: string;
    EditStyle: string;
    FieldName: string;
    FieldDef: string;
    FieldType: string;
    Seq: Integer;
    iVisible: Boolean;
    Width: Integer;
    Editing: Boolean;
    // Filtering: Boolean;
    // Sorting: Boolean;
    // Grouping: Boolean;
    isFilter: Boolean;
    iFilterVisible: Boolean;
    AllowEmpty: Boolean;
    Ref_RelationField: string;
    Ref_Table: string;
    Ref_KeyField: string;
    Ref_ReturnField: string;
    Lookup_RelationField: string;
    Lookup_Table: string;
    Lookup_KeyField: string;
    Lookup_ReturnField: string;

    // Group_Visible: Boolean;
    // Group_Width: Integer;
    LabelWidth: Integer;
    isBetween: Boolean;
    strValue: string;
    // refValue:TStringList;
    // public       constructor Create; override;
  end;

  TSZHL_LinkGridToDataSourceColumn = class(TLinkGridToDataSourceColumn)
    FieldDict: TSZHL_FieldDict;
  private
    // FSeq: Integer;
  protected
  public
    // property Seq: Integer read FSeq write FSeq;
    constructor Create(Collection: TCollection); override;
    procedure SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
  end;

  TSZHL_Edit = class(TEdit)
    FieldDict: TSZHL_FieldDict;
  private
    FRefValue: string;
    // protected
    // procedure onChange(Sender: TObject);
  public
    property RefValue: string read FRefValue write FRefValue;
    constructor Create(AOwner: TComponent); override;
    procedure SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
  end;

  TSZHL_DateEdit = class(TDateEdit)
    FieldDict: TSZHL_FieldDict;
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
  end;

  TSZHL_NumberBox = class(TEdit)
    FieldDict: TSZHL_FieldDict;
  private
    FValueType: TNumValueType;
    procedure edt1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
  public
    property ValueType: TNumValueType read FValueType write FValueType;
    constructor Create(AOwner: TComponent); override;
    procedure SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
  end;

  TSZHL_Label = class(TLabel)
    FieldDict: TSZHL_FieldDict;
  private
    // FSeq: Integer;
  public
    // property Seq: Integer read FSeq write FSeq;
    constructor Create(AOwner: TComponent); override;
    procedure SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
  end;

  TSZHL_ComboBox = class(TComboBox)
    FieldDict: TSZHL_FieldDict;
  private
    // FSeq: Integer;
    FRefValue: TStringList;
    // function TStringList: TStringList;
  public
    // property Seq: Integer read FSeq write FSeq;
    property RefValue: TStringList read FRefValue write FRefValue;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
  end;

implementation

{ TSZHL_Edit }

constructor TSZHL_Edit.Create(AOwner: TComponent);
begin
  inherited;
  FieldDict := TSZHL_FieldDict.Create;
end;

// procedure TSZHL_Edit.onChange(Sender: TObject);
// begin
// inherited;
// self.RefValue := self.Text;
// end;                 /

procedure TSZHL_Edit.SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
begin
  if FDM_DictMemTalbe.eof then
    exit;

  with FieldDict do
  begin
    Autoid := FDM_DictMemTalbe.FieldByName('Autoid').AsInteger;
    FieldKind := FDM_DictMemTalbe.FieldByName('FieldKind').AsString;
    EditStyle := FDM_DictMemTalbe.FieldByName('EditStyle').AsString;
    FieldName := FDM_DictMemTalbe.FieldByName('FieldName').AsString;
    FieldDef := FDM_DictMemTalbe.FieldByName('FieldDef').AsString;
    FieldType := FDM_DictMemTalbe.FieldByName('FieldType').AsString;
    Seq := FDM_DictMemTalbe.FieldByName('Seq').AsInteger;
    iVisible := FDM_DictMemTalbe.FieldByName('iVisible').AsBoolean;
    Width := FDM_DictMemTalbe.FieldByName('Width').AsInteger;
    Editing := FDM_DictMemTalbe.FieldByName('Editing').AsBoolean;
    // Filtering := FDM_DictMemTalbe.FieldByName('Filtering').AsBoolean;
    // Sorting := FDM_DictMemTalbe.FieldByName('Sorting').AsBoolean;
    // Grouping := FDM_DictMemTalbe.FieldByName('Grouping').AsBoolean;
    isFilter := FDM_DictMemTalbe.FieldByName('isFilter').AsBoolean;
    iFilterVisible := FDM_DictMemTalbe.FieldByName('iFilterVisible').AsBoolean;
    AllowEmpty := FDM_DictMemTalbe.FieldByName('AllowEmpty').AsBoolean;

    // Group_Visible := FDM_DictMemTalbe.FieldByName('Group_Visible').AsBoolean;
    // Group_Width := FDM_DictMemTalbe.FieldByName('Group_Width').AsInteger;
    LabelWidth := FDM_DictMemTalbe.FieldByName('LabelWidth').AsInteger;
    isBetween := FDM_DictMemTalbe.FieldByName('isBetween').AsBoolean;

    Ref_RelationField := FDM_DictMemTalbe.FieldByName('Ref_RelationField').AsString;
    Ref_Table := FDM_DictMemTalbe.FieldByName('Ref_Table').AsString;
    Ref_KeyField := FDM_DictMemTalbe.FieldByName('Ref_KeyField').AsString;
    Ref_ReturnField := FDM_DictMemTalbe.FieldByName('Ref_ReturnField').AsString;

    Lookup_RelationField := FDM_DictMemTalbe.FieldByName('Lookup_RelationField').AsString;
    Lookup_Table := FDM_DictMemTalbe.FieldByName('Lookup_Table').AsString;
    Lookup_KeyField := FDM_DictMemTalbe.FieldByName('Lookup_KeyField').AsString;
    Lookup_ReturnField := FDM_DictMemTalbe.FieldByName('Lookup_ReturnField').AsString;

  end;
end;

{ TSZHL_DateEdit }

constructor TSZHL_DateEdit.Create(AOwner: TComponent);
begin
  inherited;
  FieldDict := TSZHL_FieldDict.Create;
end;

procedure TSZHL_DateEdit.SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
begin
  with FieldDict do
  begin
    Autoid := FDM_DictMemTalbe.FieldByName('Autoid').AsInteger;
    FieldKind := FDM_DictMemTalbe.FieldByName('FieldKind').AsString;
    EditStyle := FDM_DictMemTalbe.FieldByName('EditStyle').AsString;
    FieldName := FDM_DictMemTalbe.FieldByName('FieldName').AsString;
    FieldDef := FDM_DictMemTalbe.FieldByName('FieldDef').AsString;
    FieldType := FDM_DictMemTalbe.FieldByName('FieldType').AsString;
    Seq := FDM_DictMemTalbe.FieldByName('Seq').AsInteger;
    iVisible := FDM_DictMemTalbe.FieldByName('iVisible').AsBoolean;
    Width := FDM_DictMemTalbe.FieldByName('Width').AsInteger;
    Editing := FDM_DictMemTalbe.FieldByName('Editing').AsBoolean;
    // Filtering := FDM_DictMemTalbe.FieldByName('Filtering').AsBoolean;
    // Sorting := FDM_DictMemTalbe.FieldByName('Sorting').AsBoolean;
    // Grouping := FDM_DictMemTalbe.FieldByName('Grouping').AsBoolean;
    isFilter := FDM_DictMemTalbe.FieldByName('isFilter').AsBoolean;
    iFilterVisible := FDM_DictMemTalbe.FieldByName('iFilterVisible').AsBoolean;
    AllowEmpty := FDM_DictMemTalbe.FieldByName('AllowEmpty').AsBoolean;

    // Group_Visible := FDM_DictMemTalbe.FieldByName('Group_Visible').AsBoolean;
    // Group_Width := FDM_DictMemTalbe.FieldByName('Group_Width').AsInteger;
    LabelWidth := FDM_DictMemTalbe.FieldByName('LabelWidth').AsInteger;
    isBetween := FDM_DictMemTalbe.FieldByName('isBetween').AsBoolean;

    Ref_RelationField := FDM_DictMemTalbe.FieldByName('Ref_RelationField').AsString;
    Ref_Table := FDM_DictMemTalbe.FieldByName('Ref_Table').AsString;
    Ref_KeyField := FDM_DictMemTalbe.FieldByName('Ref_KeyField').AsString;
    Ref_ReturnField := FDM_DictMemTalbe.FieldByName('Ref_ReturnField').AsString;

    Lookup_RelationField := FDM_DictMemTalbe.FieldByName('Lookup_RelationField').AsString;
    Lookup_Table := FDM_DictMemTalbe.FieldByName('Lookup_Table').AsString;
    Lookup_KeyField := FDM_DictMemTalbe.FieldByName('Lookup_KeyField').AsString;
    Lookup_ReturnField := FDM_DictMemTalbe.FieldByName('Lookup_ReturnField').AsString;
  end;
end;

{ TSZHL_Label }

constructor TSZHL_Label.Create(AOwner: TComponent);
begin
  inherited;
  FieldDict := TSZHL_FieldDict.Create;
end;

procedure TSZHL_Label.SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
begin
  with FieldDict do
  begin
    Autoid := FDM_DictMemTalbe.FieldByName('Autoid').AsInteger;
    FieldKind := FDM_DictMemTalbe.FieldByName('FieldKind').AsString;
    EditStyle := FDM_DictMemTalbe.FieldByName('EditStyle').AsString;
    FieldName := FDM_DictMemTalbe.FieldByName('FieldName').AsString;
    FieldDef := FDM_DictMemTalbe.FieldByName('FieldDef').AsString;
    FieldType := FDM_DictMemTalbe.FieldByName('FieldType').AsString;
    Seq := FDM_DictMemTalbe.FieldByName('Seq').AsInteger;
    iVisible := FDM_DictMemTalbe.FieldByName('iVisible').AsBoolean;
    Width := FDM_DictMemTalbe.FieldByName('Width').AsInteger;
    Editing := FDM_DictMemTalbe.FieldByName('Editing').AsBoolean;
    // Filtering := FDM_DictMemTalbe.FieldByName('Filtering').AsBoolean;
    // Sorting := FDM_DictMemTalbe.FieldByName('Sorting').AsBoolean;
    // Grouping := FDM_DictMemTalbe.FieldByName('Grouping').AsBoolean;
    isFilter := FDM_DictMemTalbe.FieldByName('isFilter').AsBoolean;
    iFilterVisible := FDM_DictMemTalbe.FieldByName('iFilterVisible').AsBoolean;
    AllowEmpty := FDM_DictMemTalbe.FieldByName('AllowEmpty').AsBoolean;

    // Group_Visible := FDM_DictMemTalbe.FieldByName('Group_Visible').AsBoolean;
    // Group_Width := FDM_DictMemTalbe.FieldByName('Group_Width').AsInteger;
    LabelWidth := FDM_DictMemTalbe.FieldByName('LabelWidth').AsInteger;
    isBetween := FDM_DictMemTalbe.FieldByName('isBetween').AsBoolean;

    Ref_RelationField := FDM_DictMemTalbe.FieldByName('Ref_RelationField').AsString;
    Ref_Table := FDM_DictMemTalbe.FieldByName('Ref_Table').AsString;
    Ref_KeyField := FDM_DictMemTalbe.FieldByName('Ref_KeyField').AsString;
    Ref_ReturnField := FDM_DictMemTalbe.FieldByName('Ref_ReturnField').AsString;

    Lookup_RelationField := FDM_DictMemTalbe.FieldByName('Lookup_RelationField').AsString;
    Lookup_Table := FDM_DictMemTalbe.FieldByName('Lookup_Table').AsString;
    Lookup_KeyField := FDM_DictMemTalbe.FieldByName('Lookup_KeyField').AsString;
    Lookup_ReturnField := FDM_DictMemTalbe.FieldByName('Lookup_ReturnField').AsString;
  end;
end;

{ TSZHL_LinkGridToDataSourceColumn }

constructor TSZHL_LinkGridToDataSourceColumn.Create(Collection: TCollection);
begin
  inherited;
  FieldDict := TSZHL_FieldDict.Create;
end;

procedure TSZHL_LinkGridToDataSourceColumn.SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
begin
  with FieldDict do
  begin
    Autoid := FDM_DictMemTalbe.FieldByName('Autoid').AsInteger;
    EditStyle := FDM_DictMemTalbe.FieldByName('EditStyle').AsString;
    FieldName := FDM_DictMemTalbe.FieldByName('FieldName').AsString;
    FieldDef := FDM_DictMemTalbe.FieldByName('FieldDef').AsString;
    FieldType := FDM_DictMemTalbe.FieldByName('FieldType').AsString;
    Seq := FDM_DictMemTalbe.FieldByName('Seq').AsInteger;
    iVisible := FDM_DictMemTalbe.FieldByName('iVisible').AsBoolean;
    Width := FDM_DictMemTalbe.FieldByName('Width').AsInteger;
    Editing := FDM_DictMemTalbe.FieldByName('Editing').AsBoolean;
    // Filtering := FDM_DictMemTalbe.FieldByName('Filtering').AsBoolean;
    // Sorting := FDM_DictMemTalbe.FieldByName('Sorting').AsBoolean;
    // Grouping := FDM_DictMemTalbe.FieldByName('Grouping').AsBoolean;
    isFilter := FDM_DictMemTalbe.FieldByName('isFilter').AsBoolean;
    iFilterVisible := FDM_DictMemTalbe.FieldByName('iFilterVisible').AsBoolean;

    AllowEmpty := FDM_DictMemTalbe.FieldByName('AllowEmpty').AsBoolean;

    // Group_Visible := FDM_DictMemTalbe.FieldByName('Group_Visible').AsBoolean;
    // Group_Width := FDM_DictMemTalbe.FieldByName('Group_Width').AsInteger;
    LabelWidth := FDM_DictMemTalbe.FieldByName('LabelWidth').AsInteger;
    isBetween := FDM_DictMemTalbe.FieldByName('isBetween').AsBoolean;

    Ref_RelationField := FDM_DictMemTalbe.FieldByName('Ref_RelationField').AsString;
    Ref_Table := FDM_DictMemTalbe.FieldByName('Ref_Table').AsString;
    Ref_KeyField := FDM_DictMemTalbe.FieldByName('Ref_KeyField').AsString;
    Ref_ReturnField := FDM_DictMemTalbe.FieldByName('Ref_ReturnField').AsString;

    Lookup_RelationField := FDM_DictMemTalbe.FieldByName('Lookup_RelationField').AsString;
    Lookup_Table := FDM_DictMemTalbe.FieldByName('Lookup_Table').AsString;
    Lookup_KeyField := FDM_DictMemTalbe.FieldByName('Lookup_KeyField').AsString;
    Lookup_ReturnField := FDM_DictMemTalbe.FieldByName('Lookup_ReturnField').AsString;
  end;
end;

{ TSZHL_TComboBox }

constructor TSZHL_ComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FieldDict := TSZHL_FieldDict.Create;
  FRefValue := TStringList.Create;
end;

destructor TSZHL_ComboBox.Destroy;
begin
  FreeAndNil(FRefValue);
  inherited;
end;

procedure TSZHL_ComboBox.SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
begin
  with FieldDict do
  begin
    Autoid := FDM_DictMemTalbe.FieldByName('Autoid').AsInteger;
    FieldKind := FDM_DictMemTalbe.FieldByName('FieldKind').AsString;
    EditStyle := FDM_DictMemTalbe.FieldByName('EditStyle').AsString;
    FieldName := FDM_DictMemTalbe.FieldByName('FieldName').AsString;
    FieldDef := FDM_DictMemTalbe.FieldByName('FieldDef').AsString;
    FieldType := FDM_DictMemTalbe.FieldByName('FieldType').AsString;
    Seq := FDM_DictMemTalbe.FieldByName('Seq').AsInteger;
    iVisible := FDM_DictMemTalbe.FieldByName('iVisible').AsBoolean;
    Width := FDM_DictMemTalbe.FieldByName('Width').AsInteger;
    Editing := FDM_DictMemTalbe.FieldByName('Editing').AsBoolean;
    // Filtering := FDM_DictMemTalbe.FieldByName('Filtering').AsBoolean;
    // Sorting := FDM_DictMemTalbe.FieldByName('Sorting').AsBoolean;
    // Grouping := FDM_DictMemTalbe.FieldByName('Grouping').AsBoolean;
    isFilter := FDM_DictMemTalbe.FieldByName('isFilter').AsBoolean;
    iFilterVisible := FDM_DictMemTalbe.FieldByName('iFilterVisible').AsBoolean;
    AllowEmpty := FDM_DictMemTalbe.FieldByName('AllowEmpty').AsBoolean;

    // Group_Visible := FDM_DictMemTalbe.FieldByName('Group_Visible').AsBoolean;
    // Group_Width := FDM_DictMemTalbe.FieldByName('Group_Width').AsInteger;
    LabelWidth := FDM_DictMemTalbe.FieldByName('LabelWidth').AsInteger;
    isBetween := FDM_DictMemTalbe.FieldByName('isBetween').AsBoolean;

    Ref_RelationField := FDM_DictMemTalbe.FieldByName('Ref_RelationField').AsString;
    Ref_Table := FDM_DictMemTalbe.FieldByName('Ref_Table').AsString;
    Ref_KeyField := FDM_DictMemTalbe.FieldByName('Ref_KeyField').AsString;
    Ref_ReturnField := FDM_DictMemTalbe.FieldByName('Ref_ReturnField').AsString;

    Lookup_RelationField := FDM_DictMemTalbe.FieldByName('Lookup_RelationField').AsString;
    Lookup_Table := FDM_DictMemTalbe.FieldByName('Lookup_Table').AsString;
    Lookup_KeyField := FDM_DictMemTalbe.FieldByName('Lookup_KeyField').AsString;
    Lookup_ReturnField := FDM_DictMemTalbe.FieldByName('Lookup_ReturnField').AsString;
  end;
end;

{ TSZHL_FieldDict }

{ TSZHL_NumberBox }

constructor TSZHL_NumberBox.Create(AOwner: TComponent);
begin
  inherited;
  FieldDict := TSZHL_FieldDict.Create;
  KeyboardType := TVirtualKeyboardType.NumberPad;
  ValueType := TNumValueType.Float;
  self.OnKeyDown := edt1KeyDown;
end;

procedure TSZHL_NumberBox.edt1KeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  edt: TEdit;
  str, strL, strR: string;
  p: integer;
begin
   // 获取当前文本内容, 注意要去掉选中部分(因为会被改写).
  edt := TEdit(Sender);
  str := edt.text;
  if Length(edt.SelText) <> 0 then
  begin
    strL := LeftStr(edt.text, edt.SelStart);
    strR := RightStr(edt.text, Length(edt.text) - edt.SelStart - edt.SelLength);
    str := strL + strR;
  end;
   // 限制输入数字/小数点/退格键
  if not (KeyChar in [#8, #13, #127, '.', '-', '0'..'9']) then
    KeyChar := #0;
   //限制只能输入一个小数点
  if KeyChar = '.' then
  begin
    p := Pos('.', edt.Text);
    if p > 0 then
      KeyChar := #0;
  end;
   //限制只能在第一位输入且只能输入一个'-'号
  if KeyChar = '-' then
  begin
    if edt.SelStart > 0 then
      KeyChar := #0;
    p := Pos('-', edt.Text);
    if p > 0 then
      KeyChar := #0;
  end;
end;

procedure TSZHL_NumberBox.SetValueByDictMemTalbe(FDM_DictMemTalbe: TFDMemTable);
begin
  with FieldDict do
  begin
    Autoid := FDM_DictMemTalbe.FieldByName('Autoid').AsInteger;
    FieldKind := FDM_DictMemTalbe.FieldByName('FieldKind').AsString;
    EditStyle := FDM_DictMemTalbe.FieldByName('EditStyle').AsString;
    FieldName := FDM_DictMemTalbe.FieldByName('FieldName').AsString;
    FieldDef := FDM_DictMemTalbe.FieldByName('FieldDef').AsString;
    FieldType := FDM_DictMemTalbe.FieldByName('FieldType').AsString;
    Seq := FDM_DictMemTalbe.FieldByName('Seq').AsInteger;
    iVisible := FDM_DictMemTalbe.FieldByName('iVisible').AsBoolean;
    Width := FDM_DictMemTalbe.FieldByName('Width').AsInteger;
    Editing := FDM_DictMemTalbe.FieldByName('Editing').AsBoolean;
    // Filtering := FDM_DictMemTalbe.FieldByName('Filtering').AsBoolean;
    // Sorting := FDM_DictMemTalbe.FieldByName('Sorting').AsBoolean;
    // Grouping := FDM_DictMemTalbe.FieldByName('Grouping').AsBoolean;
    isFilter := FDM_DictMemTalbe.FieldByName('isFilter').AsBoolean;
    iFilterVisible := FDM_DictMemTalbe.FieldByName('iFilterVisible').AsBoolean;
    AllowEmpty := FDM_DictMemTalbe.FieldByName('AllowEmpty').AsBoolean;

    // Group_Visible := FDM_DictMemTalbe.FieldByName('Group_Visible').AsBoolean;
    // Group_Width := FDM_DictMemTalbe.FieldByName('Group_Width').AsInteger;
    LabelWidth := FDM_DictMemTalbe.FieldByName('LabelWidth').AsInteger;
    isBetween := FDM_DictMemTalbe.FieldByName('isBetween').AsBoolean;

    Ref_RelationField := FDM_DictMemTalbe.FieldByName('Ref_RelationField').AsString;
    Ref_Table := FDM_DictMemTalbe.FieldByName('Ref_Table').AsString;
    Ref_KeyField := FDM_DictMemTalbe.FieldByName('Ref_KeyField').AsString;
    Ref_ReturnField := FDM_DictMemTalbe.FieldByName('Ref_ReturnField').AsString;

    Lookup_RelationField := FDM_DictMemTalbe.FieldByName('Lookup_RelationField').AsString;
    Lookup_Table := FDM_DictMemTalbe.FieldByName('Lookup_Table').AsString;
    Lookup_KeyField := FDM_DictMemTalbe.FieldByName('Lookup_KeyField').AsString;
    Lookup_ReturnField := FDM_DictMemTalbe.FieldByName('Lookup_ReturnField').AsString;
  end;
end;

end.

