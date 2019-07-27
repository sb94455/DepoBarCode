unit uRef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, ImgList,
  ComCtrls, ToolWin, ExtCtrls, ADODB, Grids, StdCtrls, DB, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, cxDBData, cxGridLevel, cxClasses, cxControls,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid;

//type

    //  TRefType = (EumInventory, EumInventoryClass, EumWareHouse, EumCustomer, EumVendor, EumDepartment,
//    EumItem);

type
  TRefStyle = (fLeft, fRight, fAll, fFill);

type
  TRefFace = set of (EumRefListGrid, EumRefListTree);

type
  PMyRec = ^TMyRec;

  TMyRec = record
    jc: Integer;
    cCode: string;
    cName: string;
  end;

type
  TfmRef = class(TForm)
    tvTree: TTreeView;
    Splitter1: TSplitter;
    fmInvRef: TCoolBar;
    tbr1: TToolBar;
    btbtRefesh: TToolButton;
    tbtBack: TToolButton;
    ImageList1: TImageList;
    tbLeft: TToolButton;
    tbRight: TToolButton;
    edtInv: TEdit;
    tbtexit: TToolButton;
    tbAll: TToolButton;
    tbFill: TToolButton;
    ToolButton6: TToolButton;
    StatusBar1: TStatusBar;
    ListSource: TDataSource;
    qryTree: TADOQuery;
    ClassSource: TDataSource;
    qryList: TADOQuery;
    cxgrdbtblvw1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    cxgrdbtblvw1cInvCode: TcxGridDBColumn;
    cxgrdbclmncxgrdbtblvw1cInvName: TcxGridDBColumn;
    cxgrdbclmncxgrdbtblvw1cInvStd: TcxGridDBColumn;
    cxgrdbclmncxgrdbtblvw1Column1: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure tbtexitClick(Sender: TObject);
    procedure edtInvChange(Sender: TObject);
    procedure tbr1Click(Sender: TObject);
    procedure tbLeftClick(Sender: TObject);
    procedure tbRightClick(Sender: TObject);
    procedure tbAllClick(Sender: TObject);
    procedure tbFillClick(Sender: TObject);
    procedure dbgListDblClick(Sender: TObject);
    procedure tbtBackClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tvTreeChange(Sender: TObject; Node: TTreeNode);
    procedure ListGridEhDblClick(Sender: TObject);
    procedure tvTreeDblClick(Sender: TObject);
    procedure cxgrdbtblvw1CellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo:
      TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled:
      Boolean);
    procedure qryListAfterOpen(DataSet: TDataSet);
  private
        { Private declarations }
    TreeStr: string;
    HFilterString: string;
    HrefType: string;
    HrefStyle: TrefStyle;
    HrefFace: TRefFace;
    HrefTitle: string;
    ListSqlString: TStringList;
    TreeSQLString: TStringList;
    ListRelationFieldName: string;
    HSender: TObject;
    function GetfiterString: string;
    procedure SetFilterString(Value: string);
    procedure setRefType(Value: string);
    procedure SetRefStyle(Value: TrefStyle);
    procedure SetRefFace(Value: TRefFace);
    procedure SetRefTitle(Value: string);
    procedure _EumRefFilterDataSet(_pRefType: string; _pfilterStyle: TrefStyle; pfilterString:
      string; _Sender: TObject);
  public
    BackFieldTH: Integer;
    keyField, DisplayField, GradeField: string;
    function GetRefDataSet: string;
  published
    property filterString: string read GetfiterString write SetFilterString;
    property refType: string read HrefType write setRefType;
    property refStyle: TrefStyle read HrefStyle write SetRefStyle;
    property refFace: TRefFace read HrefFace write SetRefFace;
    property refTitle: string read HrefTitle write SetRefTitle;
    procedure EumRefFilterDataSet(pRefType: string; pfilterStyle: TrefStyle; pfilterString: string;
      pSender: TObject);
  end;

procedure ShowTreeView(strRoot: string; tvTree: TTreeView; dsTree: TDataSet; keyField, DisplayField,
  GradeField: string);

var
  fmRef: TfmRef;

implementation

uses
  ufmPub;
{$R *.dfm}

procedure ShowTreeView(strRoot: string; tvTree: TTreeView; dsTree: TDataSet; keyField, DisplayField,
  GradeField: string);

  procedure addChildNode(ntFather: TTreeNode; runBytop: boolean{; dsTree: TDataSet; keyField, DisplayField, GradeField:
  string});
  var
    newNode: TTreeNode;
    jc, jc2: integer;
    cCode, cCode2, cName2: string;
    pKey: PMyRec;
    bmSave: TBookmarkStr;
  begin

    if runBytop then
    begin
      jc := 0;
      cCode := '';
      if not dsTree.Eof then
        dsTree.First;

      while not dsTree.Eof do
      begin
        cCode2 := Trim((dsTree as TADOQuery).FieldByName(keyField).AsString);
        cName2 := '[' + cCode2 + ']' + Trim((dsTree as TADOQuery).FieldByName(DisplayField).AsString);
        jc2 := (dsTree as TADOQuery).FieldByName(GradeField).AsInteger;
        if (jc2 = jc + 1) then
        begin
          New(pKey);
          pKey.jc := jc2;
          pKey.cCode := cCode2;
          pKey.cName := cName2;
          newNode := tvTree.Items.AddChildObjectFirst(ntFather, cName2, pKey);
//        tvTree.Items.a
          bmSave := dsTree.Bookmark;
          addChildNode(newNode, false{, dsTree, keyField, DisplayField, GradeField});
          dsTree.Bookmark := bmSave;
        end;
        dsTree.Next;
      end;
    end
    else
    begin
      jc := PMyRec(ntFather.Data)^.jc;
      cCode := PMyRec(ntFather.Data)^.cCode;

      if not dsTree.Eof then
        dsTree.First;

      while not dsTree.Eof do
      begin
        cCode2 := Trim((dsTree as TADOQuery).FieldByName(keyField).AsString);
        cName2 := '[' + cCode2 + ']' + Trim((dsTree as TADOQuery).FieldByName(DisplayField).AsString);
        jc2 := (dsTree as TADOQuery).FieldByName(GradeField).AsInteger;

        if (jc2 = jc + 1) and (Pos(cCode, cCode2) = 1) then
        begin
          New(pKey);
          pKey.jc := jc2;
          pKey.cCode := cCode2;
          pKey.cName := cName2;
          newNode := tvTree.Items.AddChildObjectFirst(ntFather, cName2, pKey);
          bmSave := dsTree.Bookmark;
          addChildNode(newNode, false{, dsTree, keyField, DisplayField, GradeField});
          dsTree.Bookmark := bmSave;
        end;
        dsTree.Next;
      end;
    end;
  end;

var
  ntRoot: TTreeNode;
begin
  tvTree.Items.Clear;
  if Length(Trim(strRoot)) > 0 then
  begin
    ntRoot := tvTree.Items.Add(nil, strRoot);
  end
  else
  begin
    ntRoot := nil;
  end;
  tvTree.Items.BeginUpdate;
  addChildNode(ntRoot, true{, dsTree, keyField, DisplayField, GradeField});
  tvTree.Items.EndUpdate;
  if tvTree.Items.Count > 0 then
    tvTree.Items[0].Expand(TRUE);
end;

procedure TfmRef.SetRefTitle(Value: string);
begin

  HrefTitle := Value;
end;

procedure TfmRef.SetRefFace(Value: TRefFace);
begin
  HrefFace := Value;
  if not (EumRefListGrid in Value) then
  begin
    Width := cxGrid1.Width;
    tvTree.Align := alClient;
  end;
  tvTree.Visible := EumRefListTree in Value;
  cxGrid1.Visible := EumRefListGrid in Value;
end;

procedure TfmRef.SetRefStyle(Value: TrefStyle);
begin
  if HrefStyle <> Value then
  begin
    HrefStyle := Value;
  end;
  tbLeft.Down := (Value = fLeft);
  tbRight.Down := (Value = fRight);
  tbAll.Down := (Value = fAll);
  tbFill.Down := (Value = fFill);
  _EumRefFilterDataSet(refType, refStyle, filterString, HSender);
end;

procedure TfmRef._EumRefFilterDataSet(_pRefType: string; _pfilterStyle: TrefStyle; pfilterString:
  string; _Sender: TObject);
var
  i: integer;
  bLeft, bRight: string;
begin
  if EumRefListGrid in refFace then
  begin
    cxGrid1.Visible := true;
    qryList.ConnectionString := strDBConnectString;
    qryList.SQL := ListSqlString;
        //根据过滤类型(左,右,包含,完全匹配)设置参数字符串
    if (refStyle = fLeft) or (refStyle = fAll) then
      bRight := '%'
    else
      bRight := '';
    if (refStyle = fRight) or (refStyle = fAll) then
      bLeft := '%'
    else
      bLeft := '';

        //打开列表数据集
    for i := 0 to qryList.Parameters.Count - 1 do
    begin
      qryList.Parameters[i].Value := bleft + Trim(filterString) + bRight;
    end;
    qryList.Open;
    for i := 0 to cxgrdbtblvw1.ColumnCount - 1 do
    begin
            //      cxgrdbtblvw1.Columns[i].Title.Alignment := taCenter;
            //      cxgrdbtblvw1.Columns[i].Title.Font.Style :=
            //        cxgrdbtblvw1.Columns[i].Title.Font.Style + [fsBold];
    end;
  end
  else
  begin
    cxGrid1.Visible := false;
  end;

end;

procedure TfmRef.EumRefFilterDataSet(pRefType: string; pfilterStyle: TrefStyle; pfilterString:
  string; pSender: TObject);
begin
  refType := pRefType;
  refStyle := pfilterStyle;
  filterString := pfilterString;
  HSender := pSender;
  _EumRefFilterDataSet(pRefType, pFilterStyle, pFilterString, pSender);
  if EumRefListTree in refFace then
  begin
    tvTree.Visible := true;
    qryTree.ConnectionString := strDBConnectString;
    qryTree.SQL := TreeSQLString;
    qryTree.Open;
    ShowTreeView(refTitle, tvTree, qryTree, keyField, DisplayField, GradeField);
  end
  else
  begin
    tvTree.Visible := false;
  end;
end;
//
//procedure TfmRef.EumRefFilterDataSet(pRefType: string; pfilterStyle: TrefStyle; pfilterString:
//  string; pSender: TObject);
//begin
//  refType := pRefType;
//  refStyle := pfilterStyle;
//  filterString := pfilterString;
//  HSender := pSender;
//  _EumRefFilterDataSet(pRefType, pFilterStyle, pFilterString, pSender);
//  if EumRefListTree in refFace then
//  begin
//    tvTree.Visible := true;
//    qryTree.ConnectionString := UfCurrentDbConnectionString;
//    qryTree.SQL := TreeSQLString;
//    qryTree.Open;
//    ShowTreeView(refTitle, tvTree, qryTree, keyField, DisplayField, GradeField);
//  end
//  else
//  begin
//    tvTree.Visible := false;
//  end;
//end;

function TfmRef.GetRefDataSet: string;
var
  BackValue: string;
begin
  Result := '';
  if refFace = [EumRefListTree] then
  begin
    Result := TreeStr;
    Exit;
  end;
  if not (BackFieldTH > 0) then
    BackFieldTH := 0;
  if qryList.Fields[BackFieldTH].Value = Null then
    BackValue := ''
  else
    BackValue := qryList.Fields[BackFieldTH].Value;
  GetRefDataSet := BackValue;
end;

procedure TfmRef.setRefType(Value: string);
var
  strItemClass: string;
begin
  HrefType := Value;
  if Value = 'Inventory' then
  begin
    if ListSqlString = nil then
      ListSqlString := TStringList.Create;
    ListSqlString.Clear;
    ListSqlString.Add('SELECT cInvCode , cInvName ,cInvStd,cInvCCode from Inventory ');
    ListSqlString.Add('where cInvCode like :filter or cInvName like :filter');
    if TreeSQLString = nil then
      TreeSQLString := TStringList.Create;
    TreeSQLString.Clear;
    TreeSQLString.Add('SELECT cInvCCode, [cInvCCode]+SPACE(2)+[cInvCName] cInvCCName, [iInvCGrade], [bInvCEnd], [cEcoCode], [cBarCode]FROM InventoryClass');
    keyField := 'cInvCCode';
    DisplayField := 'cInvCCName';
    GradeField := 'iInvCGrade';

    refTitle := '存货档案';
    ListRelationFieldName := 'cInvCCode';
    refFace := [EumRefListGrid, EumRefListTree];
  end;
  if Value = 'InventoryClass' then
  begin
    if TreeSQLString = nil then
      TreeSQLString := TStringList.Create;
    TreeSQLString.Clear;
    TreeSQLString.Add('SELECT [cInvCCode], [cInvCCode]+SPACE(2)+[cInvCName], [iInvCGrade], [bInvCEnd], [cEcoCode], [cBarCode]FROM InventoryClass');
    refTitle := '存货分类档案';
    refFace := [EumRefListTree];
  end;
  if Value = 'WareHouse' then
  begin
    if ListSqlString = nil then
      ListSqlString := TStringList.Create;
    ListSqlString.Clear;
    ListSqlString.Add('SELECT cWhCode AS  仓库编码, cWhName AS 仓库名称 from wareHouse ');
    ListSqlString.Add('where cWhCode like :filter or cWhName like :filter');
    refTitle := '仓库档案';
    refFace := [EumRefListGrid];
  end;

  if Value = 'Customer' then
  begin
    if ListSqlString = nil then
      ListSqlString := TStringList.Create;
    ListSqlString.Clear;
    ListSqlString.Add('SELECT cCusCode AS 客户编码, cCusName AS 客户名称, cCusAbbName AS 客户简称,');
    ListSqlString.Add('cCCCode AS 客户分类, cDCCode AS 地址分类, cCusAddress AS 地址, ');
    ListSqlString.Add('cCusPostCode AS 邮编, cCusPhone AS 电话 FROM Customer ');
    ListSqlString.Add('where cCusCode like :filter or cCusName like :filter');
    if TreeSQLString = nil then
      TreeSQLString := TStringList.Create;
    TreeSQLString.Clear;
    TreeSQLString.Add('SELECT cCCCode, cCCName FROM CustomerClass');
    refTitle := '客户档案';
    ListRelationFieldName := '客户分类';
    refFace := [EumRefListGrid, EumRefListTree];
  end;

  if Pos('fItems', Value) > 0 then
  begin
    strItemClass := trim(StringReplace(Value, 'fItems', '', [rfIgnoreCase]));
    if ListSqlString = nil then
      ListSqlString := TStringList.Create;
    ListSqlString.Clear;
    ListSqlString.Add('SELECT [citemcode] 项目编码,[citemname] 项目名称,[bclose] 是否关闭,');
    ListSqlString.Add('citemccode AS 项目大类');
    ListSqlString.Add('from ' + Value);
    ListSqlString.Add('where citemcode like :filter or citemname like :filter');
    if TreeSQLString = nil then
      TreeSQLString := TStringList.Create;
    keyField := 'cItemCCode';
    DisplayField := 'cItemCname';
    GradeField := 'iItemCgrade';

    TreeSQLString.Clear;
    TreeSQLString.Add('SELECT * FROM ' + Value + 'class');
    refTitle := '项目档案';
    ListRelationFieldName := '项目大类';
    refFace := [EumRefListGrid, EumRefListTree];
  end;
end;

function TfmRef.GetfiterString: string;
begin
  result := HFilterString;
end;

procedure TfmRef.SetFilterString(Value: string);
begin
  HFilterString := Value;
  edtInv.Text := Value;
  _EumRefFilterDataSet(refType, refStyle, filterString, HSender);
end;

procedure TfmRef.FormCreate(Sender: TObject);
begin
//  bClose := false;
  tvTree.Items.Clear;
   //cxgrdbtblvw1.ClearItems;
end;

procedure TfmRef.tbtexitClick(Sender: TObject);
begin
//  bClose := true;
  Close;
end;

procedure TfmRef.edtInvChange(Sender: TObject);
begin
  filterString := edtInv.Text;
end;

procedure TfmRef.tbr1Click(Sender: TObject);
begin
  if tbLeft.Down then
    refStyle := fLeft;
  if tbRight.Down then
    refStyle := fRight;
  if tbAll.Down then
    refStyle := fAll;
  if tbFill.Down then
    refStyle := fFill;
end;

procedure TfmRef.tbLeftClick(Sender: TObject);
begin
  tbr1Click(Sender);
end;

procedure TfmRef.tbRightClick(Sender: TObject);
begin
  tbr1Click(Sender);
end;

procedure TfmRef.tbAllClick(Sender: TObject);
begin
  tbr1Click(Sender);
end;

procedure TfmRef.tbFillClick(Sender: TObject);
begin
  tbr1Click(Sender);
end;

procedure TfmRef.dbgListDblClick(Sender: TObject);
begin
//  bclose := false;
  Close;
end;

procedure TfmRef.tbtBackClick(Sender: TObject);
begin
  ModalResult := mrOk;
//  bclose := false;
//  close;
end;

procedure TfmRef.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then
  begin
//    bClose := true;
    Close;
  end;
end;

procedure TfmRef.tvTreeChange(Sender: TObject; Node: TTreeNode);
var
  pKey: PMyRec;
begin
  TreeStr := '';
  if Node.IsFirstNode = true then
  begin
    qryList.Filtered := false;
    Exit;
  end;
  if Node.HasChildren = true then
    Exit;

  if refFace = [EumRefListTree] then
    Exit;
  pKey := Node.Data;
  qryList.Filter := ListRelationFieldName + '=' + '''' + Trim(pKey.cCode) + '''';
  qryList.Filtered := true;
end;

procedure TfmRef.ListGridEhDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
//  bclose := false;
//  Close;
end;

procedure TfmRef.tvTreeDblClick(Sender: TObject);
begin
  if refFace = [EumRefListTree] then
  begin
    ModalResult := mrOk;
  end;
end;

procedure TfmRef.cxgrdbtblvw1CellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo:
  TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  ModalResult := mrOk;
end;

procedure TfmRef.qryListAfterOpen(DataSet: TDataSet);
var
  qryDataSetProx: TADOQuery;
  i: Integer;
begin
  qryDataSetProx := DataSet as TADOQuery;
  cxgrdbtblvw1.ClearItems;
  if qryDataSetProx.Eof then
    Exit;

  for i := 0 to qryDataSetProx.FieldCount - 1 do
  begin
    cxgrdbtblvw1.BeginUpdate;
    with cxgrdbtblvw1.CreateColumn do
    begin
      Name := 'Field_' + TRIM(IntToStr(i));
      DataBinding.FieldName := qryDataSetProx.Fields[i].FieldName;
      Caption := qryDataSetProx.Fields[i].FieldName;
      Options.Editing := False;
      HeaderAlignmentHorz := taCenter;
      Options.Filtering := False;
//      ApplyBestFit();
    end;

    cxgrdbtblvw1.EndUpdate;
        cxgrdbtblvw1.ApplyBestFit;

  end;
end;

end.

