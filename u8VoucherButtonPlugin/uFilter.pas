unit uFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, DB,
  ADODB, Dialogs, cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxButtonEdit, StdCtrls, ExtCtrls, cxLabel, cxDropDownEdit, cxCalendar,
  ComCtrls, cxCalc;

type
  Tfrm_Filter = class(TForm)
    btn_OK: TButton;
    btn_Exit: TButton;
    pnl1: TPanel;
    ScrollBox1: TScrollBox;
    lv1: TListView;
    cxLabel1: TcxLabel;
    cxButtonEdit1: TcxButtonEdit;
    cxTextEdit1: TcxTextEdit;
    cxCalcEdit1: TcxCalcEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_OKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    fstrWhere: TStringList;
  public
    { Public declarations }
    strTBName: string;
    strWhere: string;
  end;

var
  frm_Filter: Tfrm_Filter;
  intLabelWidth, intControlWidth, intLeftSplit, intRightSplit, intRowHight: Integer;

procedure showRefControl(own: TWinControl; lvObjects: TListView; qry: TADOQuery; var topSeq, leftSeq: Integer);

procedure drawLabel(own: TWinControl; lvObjects: TListView; intTop, intLeft, intWidth: Integer; strCaption: string);

function getPosX(own: TWinControl; leftSeq: Integer): Integer;

procedure drawControl(own: TWinControl; lvObjects: TListView; intTop, intLeft, intWidth: Integer; EditType: string; FilterId: integer; var ctName: string);

implementation

{$R *.dfm}
uses
  ufmPub, uClassDefine;

procedure Tfrm_Filter.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  for i := 0 to ScrollBox1.ControlCount - 1 do
  begin
    ScrollBox1.Controls[0].Free;
  end;
  FreeAndNil(fstrWhere);
  Action := caFree;
end;

procedure Tfrm_Filter.btn_OKClick(Sender: TObject);
var
  i, j: Integer;
begin
//  lv1.Clear;
  fstrWhere.Clear;
  for i := 0 to ScrollBox1.ControlCount - 1 do
  begin
    if not ScrollBox1.Controls[i].Visible then
      Continue;
    if ScrollBox1.Controls[i].Tag = 0 then
      Continue;
    j := findInListViewByCaption(lv1, TRIM(ScrollBox1.Controls[i].Name));
    if j < 0 then
      Continue;
//    ShowMessage('ScrollBox1.Controls[i].ClassName:' + ScrollBox1.Controls[i].ClassName + ',j=' +
//      inttostr(j));
    if Pos('TcxDateEdit', ScrollBox1.Controls[i].ClassName) > 0 then
    begin
      if trim((ScrollBox1.Controls[i] as TcxDateEdit).Text) <> '' then
      begin
        lv1.Items[j].SubItems[3] := DateTimeToStr((ScrollBox1.Controls[i] as TcxDateEdit).Date);
        fstrWhere.Add(' and ' + lv1.Items[j].SubItems[0] + ' ' + lv1.Items[j].SubItems[2] + ' ''' + lv1.Items[j].SubItems[3] + '''');
      end;
    end;
    if Pos('TcxTextEdit', ScrollBox1.Controls[i].ClassName) > 0 then
    begin
      if trim((ScrollBox1.Controls[i] as TcxTextEdit).Text) <> '' then
      begin
        lv1.Items[j].SubItems[3] := (ScrollBox1.Controls[i] as TcxTextEdit).Text;
        fstrWhere.Add(' and ' + lv1.Items[j].SubItems[0] + ' ' + lv1.Items[j].SubItems[2] + ' ''' + lv1.Items[j].SubItems[3] + '''');
      end;
    end;
    if Pos('TcxButtonEdit', ScrollBox1.Controls[i].ClassName) > 0 then
    begin
      if trim((ScrollBox1.Controls[i] as TcxButtonEdit).Text) <> '' then
      begin
        lv1.Items[j].SubItems[3] := trim((ScrollBox1.Controls[i] as TcxButtonEdit).Text);
        fstrWhere.Add(' and ' + lv1.Items[j].SubItems[0] + ' ' + lv1.Items[j].SubItems[2] + ' ''' + lv1.Items[j].SubItems[3] + '''');
      end
    end;
    if Pos('TcxCalcEdit', ScrollBox1.Controls[i].ClassName) > 0 then
    begin
      if trim((ScrollBox1.Controls[i] as TcxCalcEdit).Text) <> '' then
      begin
        lv1.Items[j].SubItems[3] := FloatToStr((ScrollBox1.Controls[i] as TcxCalcEdit).Value);
        fstrWhere.Add(' and ' + lv1.Items[j].SubItems[0] + ' ' + lv1.Items[j].SubItems[2] + ' ' + lv1.Items[j].SubItems[3]);
      end;
    end;
  end;
  strWhere := fstrWhere.Text;
  if lv1.Visible then
    ShowMessage(strWhere);
end;

procedure Tfrm_Filter.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssctrl in Shift) and (Key = 112) then
  begin
    lv1.Visible := not lv1.Visible;
  end;
end;

procedure Tfrm_Filter.FormShow(Sender: TObject);
var
  i: Integer; //, intTBid: integer;
  qryControls: TADOQuery;
  topSeq, leftSeq: Integer;
begin
//  with TADOQuery.Create(self) do
//  begin
//    try
//      ConnectionString := UfCurrentDbConnectionString;
//      SQL.Text := 'SELECT * FROM SZHL_TableDef WHERE Name=:name';
//      Parameters.ParamByName('name').Value := strTBName;
//      Open;
//      if Eof then
//        Exit;
//      intTBid := FieldByName('TableId').AsInteger;
//    finally
//      Free
//    end;
//  end;

  fstrWhere := TStringList.Create;
  for i := 0 to ScrollBox1.ControlCount - 1 do
  begin
    ScrollBox1.Controls[i].Visible := False;
  end;
  intRowHight := 25;
  intLeftSplit := 15;
  intRightSplit := 15;
  intLabelWidth := (Self.Width - intLeftSplit - intRightSplit) div 2 * 1 div 4;
  intControlWidth := (Self.Width - intLeftSplit - intRightSplit) div 2 * 5 div 8;

  topSeq := 0;
  leftSeq := 0;
  qryControls := TADOQuery.Create(Self);
  try
    with qryControls do
    begin
      ConnectionString := strDBConnectString;
      SQL.Text := 'select * from SZHL_FltDef where tbName=:name and  visiable=1';
      Parameters.ParamByName('name').Value := strTBName;
      Open;
      while not Eof do
      begin
        showRefControl(ScrollBox1, lv1, qryControls, topSeq, leftSeq);
        Next;
      end;
    end;
  finally
    FreeAndNil(qryControls);
  end;

end;

procedure drawLabel(own: TWinControl; lvObjects: TListView; intTop, intLeft, intWidth: Integer; strCaption: string);
begin
  with TcxLabel.Create(own) do
  begin
    Name := ClassName + '_' + TRIM(inttostr(own.ControlCount));
    Parent := own;
    Caption := strCaption;
    Top := intTop;
    Left := intLeft;
    AutoSize := False;
    Width := intWidth;
    Properties.Alignment.Horz := taRightJustify;
  end;
end;

function getPosX(own: TWinControl; leftSeq: Integer): Integer;
begin
  if leftSeq = 0 then
    Result := intLeftSplit;
  if leftSeq = 1 then
    Result := intLeftSplit + intLabelWidth;
  if leftSeq = 2 then
    Result := intLeftSplit + intLabelWidth + intControlWidth;
  if leftSeq = 3 then
    Result := intLeftSplit + intLabelWidth + intControlWidth + intLabelWidth;
end;

procedure drawControl(own: TWinControl; lvObjects: TListView; intTop, intLeft, intWidth: Integer; EditType: string; FilterId: integer; var ctName: string);
begin
  EditType := Trim(EditType);
  if EditType = 'date' then
    with TcxDateEdit.Create(own) do
    begin
      Name := ClassName + '_' + TRIM(inttostr(own.ControlCount));
      ctName := Name;
      Parent := own;
      Top := intTop;
      Left := intLeft;
      Width := intWidth;
      Text := '';
      Tag := FilterId;
    end;
  if EditType = 'text' then
    with TcxTextEdit.Create(own) do
    begin
      Name := ClassName + '_' + TRIM(inttostr(own.ControlCount));
      ctName := Name;
      Parent := own;
      Top := intTop;
      Left := intLeft;
      Width := intWidth;
      Text := '';
      Tag := FilterId;
    end;
  if EditType = 'ref' then
    with TcxButtonEdit_SZHL.Create(own, FilterId) do
    begin
      Name := ClassName + '_' + TRIM(inttostr(own.ControlCount));
      ctName := Name;
      Parent := own;
      Top := intTop;
      Left := intLeft;
      Width := intWidth;
      Text := '';
      Tag := FilterId;
    end;
end;

procedure showRefControl(own: TWinControl; lvObjects: TListView; qry: TADOQuery; var topSeq, leftSeq: Integer);

  procedure addItem(strSeq, controlName: string);
  begin//  beign
    with lvObjects.Items.Add do
    begin
      Caption := qry.FieldByName('autoid').AsString;
      SubItems.Add(qry.FieldByName('FdName').AsString);
      SubItems.Add(qry.FieldByName('EditType').AsString);
      SubItems.Add(strSeq);
      SubItems.Add('');
      SubItems.Add(controlName);
    end;
  end;

var
  strControlName: string;
begin
  if qry.Active <> True then
    Exit;
  if leftSeq = 0 then
  begin

    if (qry.FieldByName('isBetween').AsBoolean = True) then
    begin
      drawLabel(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intLabelWidth, qry.FieldByName('caption').AsString);
      leftSeq := leftSeq + 1;
      drawControl(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intControlWidth, qry.FieldByName('EditType').AsString, qry.FieldByName('autoid').AsInteger, strControlName);
      addItem('>=', strControlName);
      Inc(leftSeq);

      drawLabel(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intLabelWidth, '-');
      leftSeq := leftSeq + 1;
      drawControl(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intControlWidth, qry.FieldByName('EditType').AsString, qry.FieldByName('autoid').AsInteger, strControlName);
      addItem('<=', strControlName);
      leftSeq := 0;
      Inc(topSeq)
    end
    else
    begin
      drawLabel(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intLabelWidth, qry.FieldByName('caption').AsString);
      leftSeq := leftSeq + 1;
      drawControl(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intControlWidth, qry.FieldByName('EditType').AsString, qry.FieldByName('autoid').AsInteger, strControlName);
      addItem('=', strControlName);
      Inc(leftSeq);
    end;
  end
  else if leftSeq = 2 then
  begin
    if (qry.FieldByName('isBetween').AsBoolean = True) then
    begin
      leftSeq := 0;
      Inc(topSeq);
      drawLabel(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intLabelWidth, qry.FieldByName('caption').AsString);
      leftSeq := leftSeq + 1;
      drawControl(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intControlWidth, qry.FieldByName('EditType').AsString, qry.FieldByName('autoid').AsInteger, strControlName);
      Inc(leftSeq);
      addItem('>=', strControlName);

      drawLabel(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intLabelWidth, '-');
      leftSeq := leftSeq + 1;
      drawControl(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intControlWidth, qry.FieldByName('EditType').AsString, qry.FieldByName('autoid').AsInteger, strControlName);
      leftSeq := 0;
      Inc(topSeq);
      addItem('<=', strControlName);
    end
    else
    begin
      drawLabel(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intLabelWidth, qry.FieldByName('caption').AsString);
      leftSeq := leftSeq + 1;
      drawControl(own, lvObjects, 10 + topSeq * intRowHight, getPosX(own, leftSeq), intControlWidth, qry.FieldByName('EditType').AsString, qry.FieldByName('autoid').AsInteger, strControlName);
      leftSeq := 0;
      addItem('=', strControlName);
    end;
  end;
end;

end.

