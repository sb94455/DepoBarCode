unit UnitLib;

interface

uses System.SysUtils,
  System.Types,
  System.UITypes,
  FMX.Edit,
  System.IOUtils,
  StrUtils,
  FMX.Header,
  Data.DB,
  Data.Bind.Components,
  Data.Bind.Grid,
  Data.Bind.DBScope,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls,
  FMX.DateTimeCtrls,
  FMX.Types,
  FireDAC.Comp.Client,
  uSZHLFMXEdit,
  FMX.Objects,
  System.classes,
  FMX.Dialogs,
  System.Threading,
  FMX.Grid,
{$IFDEF MSWINDOWS} Windows, {$ENDIF} FMX.Forms;

type
  TVouchArrow = (vhBlue, vhRed);

  TSZHL_Vouch = class(TObject)
    ListTable, ListTableDef: string;
    DesMainKey, DesMainTable, DesMainTableDef, DesMainKeyField: string;
    DesSubKey, DesSubTable, DesSubTableDef, DesSubKeyField, DesSubLinkSrcFeild, DesSubLinkMainFeild, DesSubQtyField: string;
    SrcTable, SrcTableDef, SrcKeyField, SrcLinkMainField, SrcLinkDesSubField: string;
    // SrcMainTable,SrcMainCodeField,SrcMainKeyField,SrcMainLinkSubField:string;
    SrcQtyField, SrcRmtQtyField, SrcQty_AmtField: string;
    VouchArrow: TVouchArrow;
  public
    function Prepared: Boolean;
    procedure btn1Click(Sender: TObject);
  end;

  TFrmField = class(TObject)
    TableName: string;
    DisplayControlClassName: string;
    FieldName: string;
  end;

  TVouchFrmLayConst = record
  const
    LabelSplitHeader = 5;
    LabelSplit = 2;
    HeightUnit = 32; // 25;  //行高
    EmptyRowHeightUnit = 5; // 行间隔
    labelWidthUnit = 60;
  end;

  TLoginInfo = record
    logined: Boolean;
    UserID: string;
    UserName: string;
    PassWord: string;
    SaveName: Boolean;
  end;

procedure ShowMessage_debug(const AMessage: string);

procedure getWareHouse(Sender: TForm; txtEdit: TEdit);

procedure getInventory(Sender: TForm; txtEdit: TEdit);

procedure getVendor(Sender: TForm; txtEdit: TEdit);

procedure getCustomer(Sender: TForm; txtEdit: TEdit);

procedure getDepartment(Sender: TForm; txtEdit: TEdit);

procedure getPostion(Sender: TForm; txtEdit: TEdit; cWhCode: string);

procedure ShowForm(TopForm: TForm; NewForm: TForm);

function GetValueByKey(aString: string; aKey: string): string;

procedure Delay(dwMilliseconds: DWORD);

function GetIniFileName: string;

procedure ClearChildCtrl(Layout: TControl; Shown: Boolean = True);

procedure AlignHeaders(aGrid: TStringGrid);

procedure CreateADCtrl(strTableDef: string; parentLay: TLayout; fdm_table: TFDMemTable; bindSource: TBindSourceDB; isFilter: Boolean = False);

procedure LinkControlToField(Sender: TComponent; BindSourceDB1: TBindSourceDB; FieldName: string; Edit2: TComponent);

function GetFirstParentControl(Sender: TObject; strClassName: string): TFmxObject;

function Get_FirstParent_TSZHL_Edit(Sender: TObject): TSZHL_Edit;

function Get_FirstParent_TSZHL_ComboBox(Sender: TObject): TSZHL_ComboBox;

function Get_FirstParent_TForm(Sender: TObject): TForm;

function DrawSZHL_Edit(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: Integer = 1): TSZHL_Edit;

function DrawSZHL_ComboBox(FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: Integer = 1): TSZHL_ComboBox;

function DrawSZHL_DateEdit(FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: Integer = 1): TSZHL_DateEdit;

function DrawSZHL_Label(FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; LabelSplit1: Extended; strDefault: string = '';
  ConditionPos: Integer = 1): TSZHL_Label;

function GetColumnStyle(fdPara: TField): string;

function GetFieldInfoByFieldName(strTableName, strFieldName: string): TSZHL_FieldDict;

// function GetFieldInfoByAutoId(intAutoid: Integer): TSZHL_FieldDict;

var
  PubVar_AppServer: string = 'http://depoks.szhlrj.com:280';
  PubVar_LoginInfo: TLoginInfo;
  // fdFieldInfo1: TSZHL_FieldDict;

const
  Const_AccNo = '0';
  VirtualPath = '/SZHLBarCode';
  Const_Url_Def_Login: string = VirtualPath + '/Login.asmx?wsdl';
  Const_Url_Def_Arrival: string = VirtualPath + '/ArrivalVouchService.asmx?wsdl';
  Const_Url_Def_BaseData: string = VirtualPath + '/BaseDataService.asmx?wsdl';
  Const_Url_Def_PurchaseIn: string = VirtualPath + '/PurchaseInService.asmx?wsdl';
  Const_Url_Def_ProduceOrderPart: string = VirtualPath + '/ProduceOrderService.asmx?wsdl';
  Const_Url_Def_MaterialOut: string = VirtualPath + '/MaterialOutService.asmx?wsdl';
  Const_Url_Def_ProductIn: string = VirtualPath + '/ProductInService.asmx?wsdl';
  Const_Url_Def_OutOrder: string = VirtualPath + '/OMOrderService.asmx?wsdl';
  Const_Url_Def_CheckVouch: string = VirtualPath + '/CheckVouchService.asmx?wsdl';
  Const_Url_Def_SaleOut: string = VirtualPath + '/SaleOutService.asmx?wsdl';

implementation

uses MainForm,
  UnitU8DM,
  BaseForm,
  AboutForm,
  InventoryForm,
  StockForm,
  VendorForm,
  CustomerForm,
  PositionForm,
  WareHouseForm,
  DeptForm,
  LoginForm;

function GetColumnStyle(fdPara: TField): string;
begin

  if fdPara is TStringField then
  begin
    Result := 'StringColumn';
  end else if fdPara is TDateField then
  begin
    Result := 'DateColumn';
  end else if fdPara is TBooleanField then
  begin
    Result := 'CheckColumn';
  end else if fdPara is TFloatField then
  begin
    Result := 'FloatColumn';
  end else if fdPara is TIntegerField then
  begin
    Result := 'IntegerColumn';
  end else if fdPara is TBCDField then
  begin
    Result := 'FloatColumn';
  end else if fdPara is TFMTBCDField then
  begin
    Result := 'FloatColumn';
  end else if True then
  begin
    Result := 'StringColumn';
  end;
end;

procedure AlignHeaders(aGrid: TStringGrid);
var
  tmpInt: Integer;
  Header: THeader;
begin
  // aGrid.StyledSettings := [];
  Header := THeader(aGrid.FindStyleResource('header'));
  if Assigned(Header) then
  begin
    for tmpInt := 0 to Header.Count - 1 do
    begin
      Header.Items[tmpInt].TextAlign := TTextAlign(0);
      Header.Items[tmpInt].StyledSettings := [];
      with Header.Items[tmpInt].Font do
      begin
        Size := 12;
        Style := [TFontStyle.fsBold];
      end;
    end;
    Header.Height := 28;
  end;
  aGrid.RealignContent;
end;

function GetIniFileName: string;
begin
  Result := System.IOUtils.TPath.GetHomePath + '\U8AndServer.ini'
end;

procedure Delay(dwMilliseconds: DWORD);
var
  iStart, iStop: DWORD;
begin
{$IFDEF ANDROID}
  iStart := TThread.GetTickCount;
  repeat
    iStop := TThread.GetTickCount;
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
{$ELSE}
  iStart := GetTickCount;
  repeat
    iStop := GetTickCount;
    Application.ProcessMessages;
  until (iStop - iStart) >= dwMilliseconds;
{$ENDIF}
end;

function GetValueByKey(aString: string; aKey: string): string;
var
  i    : Integer;
  aList: TStringList;
begin
  Result := '';

  aList := TStringList.Create;
  with aList do
    try
      aList.Delimiter := ';';
      aList.DelimitedText := aString.Trim;
      for i := 0 to aList.Count - 1 do
      begin
        if SameText(aList.Names[i], aKey.Trim) = True then
        begin
          Result := Trim(aList.ValueFromIndex[i]);
          Break;
        end;
      end;
    finally
      free
    end;
end;

procedure ShowForm(TopForm: TForm; NewForm: TForm);
begin
  TBaseFrm(NewForm).TopForm := TopForm;
  TBaseFrm(NewForm).Parent := TopForm;
  TBaseFrm(NewForm).Width := TopForm.Width;
  TBaseFrm(NewForm).Height := TopForm.Height;
  NewForm.Show;
end;

procedure LinkControlToField(Sender: TComponent; BindSourceDB1: TBindSourceDB; FieldName: string; Edit2: TComponent);
var
  l1: TLinkControlToField;
begin
  l1 := TLinkControlToField.Create(Sender);
  l1.DataSource := BindSourceDB1;
  l1.FieldName := FieldName;
  l1.Control := Edit2;
  l1.Active := True;
end;

function DrawSZHL_Edit(fdm_table, FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: Integer = 1): TSZHL_Edit;
begin
  Result := TSZHL_Edit.Create(nil);
  with Result do
  begin
    SetValueByDictMemTalbe(FDM_Dict1);
    FieldDict.ConditionPos := ConditionPos;
    FieldDict.FDMDataSet := fdm_table;
    Parent := lyLine;
    Position.X := 5 + xpos;
    Width := FieldDict.Width;
    xpos := Position.X + Width;
    Height := lyLine.Height;
    // Tag := U8DM.FDM_SZHL_ItmDef.FieldByName('autoid').AsInteger;
    Anchors := [TAnchorKind.akLeft];
    // TextSettings.HorzAlign := TTextAlign.Leading;
    // StyledSettings := [];
    // TextSettings.Font.Family := '宋体';
    // TextSettings.Font.Size := 12;
    // seq := seq1;
  end;

end;

function DrawSZHL_ComboBox( { seq1: Integer; } FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: Integer = 1)
  : TSZHL_ComboBox;
var
  // fd: TFDMemTable;
  fdm_ComboBox: TFDMemTable;
  strSql      : string;
begin
  Result := TSZHL_ComboBox.Create(nil);
  with Result do
  begin
    SetValueByDictMemTalbe(FDM_Dict1);
    FieldDict.ConditionPos := ConditionPos;
    Parent := lyLine;
    Position.X := 0 + xpos;

    Width := FieldDict.Width;
    xpos := Position.X + Width;
    Height := lyLine.Height;
    // Tag := U8DM.FDM_SZHL_ItmDef.FieldByName('autoid').AsInteger;
    Anchors := [TAnchorKind.akLeft];
    //
    // TextSettings.HorzAlign := TTextAlign.Leading;
    // StyledSettings := [];
    // TextSettings.Font.Family := '宋体';
    // TextSettings.Font.Size := 12;
    // seq := seq1;

    if SameText(Result.FieldDict.Lookup_Table, 'RdStyleIn') then
    begin
      strSql := 'select ''[''+cRdCode+'']''+cRdName DisplayValue,cRdCode Value from rd_style where bRdFlag=1 and bRdEnd=1';
    end;
    if SameText(Result.FieldDict.Lookup_Table, 'RdStyleOut') then
    begin
      strSql := 'select ''[''+cRdCode+'']''+cRdName DisplayValue,cRdCode Value from rd_style where bRdFlag=0 and bRdEnd=1';
    end;
    if SameText(Result.FieldDict.Lookup_Table, 'WareHouse') then
    begin
      strSql := 'select ''[''+cWhCode+'']''+cWhName DisplayValue,cWhCode value from WareHouse';
    end;
    if SameText(Result.FieldDict.Lookup_Table, 'bRdFlagIn') then
    begin
      strSql := ' select ''蓝单(正)'' DisplayValue,1 as Value union select ''红单(负)'',0 ';
    end;
    if SameText(Result.FieldDict.Lookup_Table, 'bRdFlagOut') then
    begin
      strSql := ' select ''蓝单(正)'' DisplayValue,0 as Value union select ''红单(负)'',1 ';
    end;
    if strSql = '' then
      Exit;

    fdm_ComboBox := TFDMemTable.Create(nil);
    try
      Result.Clear;
      Result.RefValue.Clear;
      U8DM.ExecSql(fdm_ComboBox, strSql);
      while not fdm_ComboBox.Eof do
      begin
        Result.Items.Add(fdm_ComboBox.FieldByName('DisplayValue').AsString);
        Result.RefValue.Add(fdm_ComboBox.FieldByName('Value').AsString);
        fdm_ComboBox.Next;
      end;
    finally
      fdm_ComboBox.free;
    end;
    // ShowMessage(Result.Width.ToString);
  end;

end;

function DrawSZHL_Label( { seq1: Integer; } FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; LabelSplit1: Extended;
  strDefault: string = ''; ConditionPos: Integer = 1): TSZHL_Label;
var
  l1: TSZHL_Label;
begin

  l1 := TSZHL_Label.Create(nil);
  l1.SetValueByDictMemTalbe(FDM_Dict1);
  l1.FieldDict.ConditionPos := ConditionPos;
  // if isSencondCondition = True then
  // l1.FieldDict.posY = 2;

  if Length(Trim(strDefault)) > 0 then
    l1.Text := strDefault
  else
    if ConditionPos = 2 then
      l1.Text := '  至  '
    else
      l1.Text := l1.FieldDict.FieldDef + ':';
  l1.Parent := lyLine;
  l1.Position.X := LabelSplit1 + xpos;
  l1.Width := l1.FieldDict.LabelWidth;
  // ShowMessage('Draw '+l1.FieldDict.FieldName+' label xpos='+l1.Position.X .ToString+' width='+l1.Width.ToString);
  xpos := l1.Position.X + l1.Width;
  l1.Height := lyLine.Height;
  l1.Anchors := [TAnchorKind.akLeft];
  // l1.TextSettings.VertAlign := TTextAlign.Trailing;
  // l1.StyledSettings := [];
  // l1.TextSettings.Font.Family := '宋体';
  // l1.TextSettings.Font.Size := 12;
  if l1.FieldDict.AllowEmpty = False then
  begin
    l1.TextSettings.FontColor := TAlphaColorRec.Red;
  end;
  // l1.seq := seq1;

  Result := l1;
end;

function DrawSZHL_DateEdit( { seq1: Integer; } FDM_Dict1: TFDMemTable; lyLine: TControl; var xpos: Extended; ConditionPos: Integer = 1)
  : TSZHL_DateEdit;
begin
  Result := TSZHL_DateEdit.Create(nil);
  with Result do
  begin
    SetValueByDictMemTalbe(FDM_Dict1);
    FieldDict.ConditionPos := ConditionPos;
    Parent := lyLine;
    Position.X := 0 + xpos;
    Width := FieldDict.Width;
    xpos := Position.X + Width;
    format := 'YYYY-MM-DD';
    Height := lyLine.Height;
    Anchors := [TAnchorKind.akLeft];
    TextSettings.HorzAlign := TTextAlign.Leading;
    // StyledSettings := [];
    // TextSettings.Font.Family := '宋体';
    // TextSettings.Font.Size := 12;
    // seq := seq1;
  end;
  if ConditionPos = 1 then
  begin
    if Result.FieldDict.isFilter = True then
    begin
      Result.Date := strtodate('2018-01-01', dateFmtSet);
    end;
  end;
end;

function Get_FirstParent_TSZHL_Edit(Sender: TObject): TSZHL_Edit;
var
  iCompe: TFmxObject;
begin
  Result := nil;
  if (Sender is TFmxObject) then
  begin
    iCompe := Sender as TFmxObject;
    while True do
    begin
      if iCompe is TSZHL_Edit then
      begin
        Result := (iCompe as TSZHL_Edit);
        Exit;
      end;
      iCompe := iCompe.Parent;
    end;
  end;
end;

// function Get_cVenCode_TSZHL_Edit(Sender: TObject): TSZHL_Edit;
// var
// iCompe: TFmxObject;
// begin
// Result := nil;
// if (Sender is TFmxObject) then
// begin
// iCompe := Sender as TFmxObject;
// while True do
// begin
// if iCompe is TSZHL_Edit then
// begin
// if (iCompe as TSZHL_Edit).FieldDict.Lookup_Table='Vendor' and (iCompe as TSZHL_Edit).FieldDict.FieldName='cVenCode' then
//
// Result := (iCompe as TSZHL_Edit);
// Exit;
// end;
// iCompe := iCompe.Parent;
// end;
// end;
// end;
function Get_FirstParent_TForm(Sender: TObject): TForm;
var
  iCompe: TFmxObject;
begin
  Result := nil;
  if (Sender is TFmxObject) then
  begin
    iCompe := Sender as TFmxObject;
    while True do
    begin
      if iCompe is TForm then
      begin
        Result := (iCompe as TForm);
        Exit;
      end;
      iCompe := iCompe.Parent;
    end;
  end;
end;

function Get_FirstParent_TSZHL_ComboBox(Sender: TObject): TSZHL_ComboBox;
var
  iCompe: TFmxObject;
begin
  Result := nil;
  if (Sender is TFmxObject) then
  begin
    iCompe := Sender as TFmxObject;
    while True do
    begin
      if iCompe is TSZHL_ComboBox then
      begin
        Result := (iCompe as TSZHL_ComboBox);
        Exit;
      end;
      iCompe := iCompe.Parent;
    end;
  end;
end;

procedure CreateADCtrl(strTableDef: string; parentLay: TLayout; fdm_table: TFDMemTable; bindSource: TBindSourceDB; isFilter: Boolean = False);
// 根据AD动态显示字段标题（label)及控件,并绑定FDMemTable
var
  strTableName           : string;
  i                      : Integer;
  lyLine                 : TLayout;
  xpos, yPos, LabelSplit1: Extended;
  ConditionPos           : Integer;
  tsEdt                  : TSZHL_Edit;
  dateEdtControl         : TSZHL_DateEdit;
  tsb1                   : TSearchEditButton;
  tscb                   : TSZHL_ComboBox;
  isSencondCondition     : Boolean; // 区间条件第2栏目标志
  function GetNewLayWithBlankRow(lay1: TLayout; PreEmptyRow: Boolean = True): TLayout;
  var
    emptyRowlay: TLayout;
  begin
    if PreEmptyRow = True then
    begin
      emptyRowlay := TLayout.Create(parentLay);
      emptyRowlay.Parent := parentLay;
      emptyRowlay.Height := TVouchFrmLayConst.EmptyRowHeightUnit;
      emptyRowlay.Width := lay1.Width;
      emptyRowlay.Position.Y := yPos;
      yPos := yPos + TVouchFrmLayConst.EmptyRowHeightUnit;
    end;

    Result := TLayout.Create(parentLay);
    Result.Parent := parentLay;
    Result.Height := TVouchFrmLayConst.HeightUnit;
    Result.Width := lay1.Width;
    Result.Position.Y := yPos;
    yPos := yPos + TVouchFrmLayConst.HeightUnit;
  end;

begin
  if not U8DM.SetADTableByDef(strTableDef) then
    Exit;
  // if U8DM.FDM_SZHL_ItmDef.RecordCount = 0 then
  // Exit;
  strTableName := U8DM.FDM_SZHL_TableDef.FieldByName('Name').AsString.Trim;

  xpos := 0;
  yPos := 0;
  isSencondCondition := False;

  U8DM.FDM_SZHL_ItmDef.Filtered := False;

  if isFilter = True then
    U8DM.FDM_SZHL_ItmDef.Filter := 'iFilterVisible=True and isFilter=True'
  else
    U8DM.FDM_SZHL_ItmDef.Filter := 'iVisible=True'; // or isFilter=True';
  U8DM.FDM_SZHL_ItmDef.Filtered := True;

  U8DM.FDM_SZHL_ItmDef.FindFirst;
  while U8DM.FDM_SZHL_ItmDef.Found do
  begin

    // if U8DM.FDM_SZHL_ItmDef.FieldByName('iVisible').AsBoolean = False then
    // begin
    // U8DM.FDM_SZHL_ItmDef.Next;
    // Continue;
    // end;
    if fdm_table.Active = True then
      if fdm_table.Fields.FindField(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldName').AsString) = nil then
      begin
        U8DM.FDM_SZHL_ItmDef.Next;
        Continue;
      end;

    if yPos = 0 then
    begin
      lyLine := GetNewLayWithBlankRow(parentLay);
    end;

    // 计算当前控件组合位置   xPos
    // 1.如果计算现有X坐标+将要画的控件宽度大于屏幕宽度
    if xpos + U8DM.FDM_SZHL_ItmDef.FieldByName('Width').AsInteger + TVouchFrmLayConst.LabelSplitHeader +
      U8DM.FDM_SZHL_ItmDef.FieldByName('LabelWidth').AsInteger > parentLay.Width then
    begin
      xpos := 0;
      lyLine := GetNewLayWithBlankRow(parentLay);
    end;

    // 2.区间过滤条件的第一个
    if (isSencondCondition = False) and (U8DM.FDM_SZHL_ItmDef.FieldByName('isBetween').AsBoolean = True) and (isFilter = True) then
    begin
      xpos := 0;
      lyLine := GetNewLayWithBlankRow(parentLay);
    end;

    if xpos = 0 then // 第一个控件caption前面留的距离 与后面标题离左面的距离 不一样，可以分隔开，
    begin
      LabelSplit1 := TVouchFrmLayConst.LabelSplitHeader;
    end else begin
      LabelSplit1 := TVouchFrmLayConst.LabelSplit;
    end;

    if isFilter then
      if isSencondCondition = True then
        ConditionPos := 2
      else
        ConditionPos := 1
    else
      ConditionPos := 1;

    DrawSZHL_Label( { 1, } U8DM.FDM_SZHL_ItmDef, lyLine, xpos, LabelSplit1, '', ConditionPos);

    if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'String') = True then // 根据类型画控件，字符型对应TEdit
    begin
      if (SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldKind').AsString, 'ComboBox') = True) then
      begin
        tscb := DrawSZHL_ComboBox( { 1, } U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
        tscb.OnChange := U8DM.cbb_EvenChange;
      end else begin
        tsEdt := DrawSZHL_Edit(fdm_table, U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);
        if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldKind').AsString, 'ref') = True then
        begin
          tsb1 := TSearchEditButton.Create(nil);
          tsb1.Parent := tsEdt;
          tsb1.OnClick := U8DM.btnSrh_EvenClick;
        end;

        if not isFilter then // 过滤条件下fdm_table可能没打开，所以得放在前面
          if fdm_table.FieldDefs.Find(tsEdt.FieldDict.FieldName) <> nil then
            LinkControlToField(parentLay, bindSource, tsEdt.FieldDict.FieldName, tsEdt);
      end
    end;
    if SameText(U8DM.FDM_SZHL_ItmDef.FieldByName('FieldType').AsString, 'date') = True then // 根据类型画控件，日期型对应TDateEdit
    begin
      dateEdtControl := DrawSZHL_DateEdit( { 1, } U8DM.FDM_SZHL_ItmDef, lyLine, xpos, ConditionPos);

      if not isFilter then // 过滤条件下fdm_table可能没打开，所以得放在前面
        if fdm_table.FieldDefs.Find(dateEdtControl.FieldDict.FieldName) <> nil then // 数据字典当前行，数据集中也找到此列，才关联
          LinkControlToField(parentLay, bindSource, dateEdtControl.FieldDict.FieldName, dateEdtControl);

      if isSencondCondition = True then
        isSencondCondition := False
      else
        if (U8DM.FDM_SZHL_ItmDef.FieldByName('isBetween').AsBoolean = True) and (isFilter = True) then
        begin
          isSencondCondition := True;
          Continue
        end;
    end;
    U8DM.FDM_SZHL_ItmDef.FindNext;

  end;

  U8DM.FDM_SZHL_ItmDef.Filtered := False;
  U8DM.FDM_SZHL_ItmDef.Filter := '';
end;

procedure ClearChildCtrl(Layout: TControl; Shown: Boolean = True);
var
  i : Integer;
  c1: TControl;
  // strDefString:string;
begin
  for i := 0 to Layout.ControlsCount - 1 do
  begin
    // if Layout.Controls.Items[i].Name <> '' then
    // begin

    // Layout.Controls.Items[i].Visible := Shown;
    if (Layout.Controls.Items[i] is TEdit) then
    begin
      (Layout.Controls.Items[i] as TEdit).Text := '';
    end;
    if (Layout.Controls.Items[i] is TDateEdit) then
    begin
      (Layout.Controls.Items[i] as TDateEdit).Date := Now;
    end;
    if (Layout.Controls.Items[i] is TSZHL_ComboBox) then
    begin
      // (Layout.Controls.Items[i] as TSZHL_ComboBox).FieldDict.
      (Layout.Controls.Items[i] as TSZHL_ComboBox).ItemIndex := -1; // (Layout.Controls.Items[i] as TSZHL_ComboBox).Items.IndexOf('');
    end;

    // end;
    ClearChildCtrl(Layout.Controls.Items[i], Shown);
  end;

end;

procedure ShowMessage_debug(const AMessage: string);
begin
{$IFDEF DEBUG}
  ShowMessage(AMessage);
{$ENDIF}
  Exit;
end;

procedure getWareHouse(Sender: TForm; txtEdit: TEdit);
begin
  WareHouseFrm := TWareHouseFrm.Create(Application);
  WareHouseFrm.Parent := Sender;
  WareHouseFrm.Position := TFormPosition.MainFormCenter;
  WareHouseFrm.TopForm := Sender;
  WareHouseFrm.edt_search.Text := txtEdit.Text;
  WareHouseFrm.InitData;
  WareHouseFrm.ShowModal(procedure(ModalResult: TModalResult)
    begin
      if WareHouseFrm.DefModalResult = mrOk then
      begin
        if not WareHouseFrm.FDM_WareHouse.Eof then
          txtEdit.Text := WareHouseFrm.FDM_WareHouse.FieldByName('cWhCode').AsString;
        Sender.Show;
        WareHouseFrm.Focused := nil;
        WareHouseFrm := nil;
      end;
    end);
  // WareHouseFrm := TWareHouseFrm.Create(Application);
  // WareHouseFrm.TopForm := Sender;
  // WareHouseFrm.ShowModal(
  // procedure(ModalResult: TModalResult)
  // begin
  // if ModalResult = mrOk then
  // begin
  // if WareHouseFrm.strngrdWareHouse.RowCount > 0 then
  // txtEdit.Text := WareHouseFrm.strngrdWareHouse.Cells[0, WareHouseFrm.strngrdWareHouse.Row];
  // end;
  // TTask.Run( // 释放此窗体的必要代码
  // procedure
  // begin
  // TThread.Synchronize(nil,
  // procedure
  // begin
  // WareHouseFrm.Focused := nil; // 防止键盘的出现导致的异常
  // WareHouseFrm.DisposeOf; // 释放此窗体
  // WareHouseFrm := nil; // 释放此窗体
  // end);
  // end);
  // end);
end;

procedure getInventory(Sender: TForm; txtEdit: TEdit);
begin
  InventoryFrm := TInventoryFrm.Create(Application);
  InventoryFrm.Parent := Sender;
  InventoryFrm.TopForm := Sender;
  InventoryFrm.edt_search.Text := txtEdit.Text;
  InventoryFrm.InitData;
  InventoryFrm.ShowModal(procedure(ModalResult: TModalResult)
    begin
      if InventoryFrm.DefModalResult = mrOk then
      begin
        if not InventoryFrm.FDM_Inventory.Eof then
          txtEdit.Text := InventoryFrm.FDM_Inventory.FieldByName('cInvCode').AsString;
        Sender.Show;
        InventoryFrm.Focused := nil;
        InventoryFrm := nil;
      end;

    end);
end;

procedure getVendor(Sender: TForm; txtEdit: TEdit);
begin
  VendorFrm := TVendorFrm.Create(Application);
  VendorFrm.Parent := Sender;
  VendorFrm.TopForm := Sender;
  VendorFrm.edt_search.Text := txtEdit.Text;
  VendorFrm.InitData;
  VendorFrm.ShowModal(procedure(ModalResult: TModalResult)
    begin
      if VendorFrm.DefModalResult = mrOk then
      begin
        if not VendorFrm.FDM_Vendor.Eof then
          txtEdit.Text := VendorFrm.FDM_Vendor.FieldByName('cVenCode').AsString;
        Sender.Show;
        VendorFrm.Focused := nil;
        VendorFrm := nil;
      end;

    end);
end;

procedure getCustomer(Sender: TForm; txtEdit: TEdit);
begin
  CustomerFrm := TCustomerFrm.Create(Application);
  CustomerFrm.Parent := Sender;
  CustomerFrm.TopForm := Sender;
  CustomerFrm.edt_search.Text := txtEdit.Text;
  CustomerFrm.InitData;
  CustomerFrm.ShowModal(procedure(ModalResult: TModalResult)
    begin
      if CustomerFrm.DefModalResult = mrOk then
      begin
        if not CustomerFrm.FDM_Customer.Eof then
          txtEdit.Text := CustomerFrm.FDM_Customer.FieldByName('cVenCode').AsString;
        Sender.Show;
        CustomerFrm.Focused := nil;
        CustomerFrm := nil;
      end;

    end);
end;

procedure getDepartment(Sender: TForm; txtEdit: TEdit);
begin
  DeptFrm := TDeptFrm.Create(Application);
  DeptFrm.Parent := Sender;
  DeptFrm.TopForm := Sender;
  DeptFrm.edt_search.Text := txtEdit.Text;
  DeptFrm.InitData;
  DeptFrm.ShowModal(procedure(ModalResult: TModalResult)
    begin
      if DeptFrm.DefModalResult = mrOk then
      begin
        if not DeptFrm.FDM_Dept.Eof then
          txtEdit.Text := DeptFrm.FDM_Dept.FieldByName('cDepCode').AsString;
        Sender.Show;
        DeptFrm.Focused := nil;
        DeptFrm := nil;
      end;

    end);
end;

procedure getPostion(Sender: TForm; txtEdit: TEdit; cWhCode: string);
begin
  PositionFrm := TPositionFrm.Create(Application);
  PositionFrm.Parent := Sender;
  PositionFrm.TopForm := Sender;
  PositionFrm.cWhCode := cWhCode;
  PositionFrm.edt_search.Text := txtEdit.Text;
  PositionFrm.srhBtn_1Click(Sender);
  PositionFrm.ShowModal(procedure(ModalResult: TModalResult)
    begin
      if PositionFrm.DefModalResult = mrOk then
      begin
        if not PositionFrm.FDM_Position.Eof then
          txtEdit.Text := PositionFrm.FDM_Position.FieldByName('cPosCode').AsString;
        Sender.Show;
        PositionFrm.Focused := nil;
        PositionFrm := nil;
      end;

    end);
end;

function GetFirstParentControl(Sender: TObject; strClassName: string): TFmxObject;
var
  ParentObject: TFmxObject;
begin
  Result := nil;
  if (Sender is TFmxObject) then
  begin
    ParentObject := Sender as TFmxObject;
    while True do
    begin
      if ParentObject = nil then
      begin
        Exit;
      end;
      if SameText(ParentObject.ClassName, strClassName) = True then
      begin
        Result := ParentObject;
        Exit;
      end;
      ParentObject := ParentObject.Parent;
    end;
  end;
end;

{ TSZHL_Vouch }

procedure TSZHL_Vouch.btn1Click(Sender: TObject);
begin

end;

function TSZHL_Vouch.Prepared: Boolean;

  function GetString(blInit: Boolean; str: string): Boolean;
  begin
    if blInit = True then
      Result := Length(Trim(str)) > 0;
  end;

begin
  Result := True;
  VouchArrow := vhBlue;
  Result := GetString(Result, ListTable);
  Result := GetString(Result, ListTableDef);

  // Result := GetString(Result, MainKey);               //新建是空值
  Result := GetString(Result, DesMainTable);
  Result := GetString(Result, DesMainTableDef);
  Result := GetString(Result, DesMainKeyField);

  // Result := GetString(Result, DesKey);                 //新建是空值
  Result := GetString(Result, DesSubTable);
  Result := GetString(Result, DesSubTableDef);
  Result := GetString(Result, DesSubKeyField);
  Result := GetString(Result, DesSubLinkSrcFeild);
  Result := GetString(Result, DesSubQtyField);

  Result := GetString(Result, SrcTable);
  Result := GetString(Result, SrcTableDef);
  Result := GetString(Result, SrcKeyField);
  Result := GetString(Result, SrcLinkDesSubField);
  Result := GetString(Result, SrcQtyField);
  Result := GetString(Result, SrcRmtQtyField);
  Result := GetString(Result, SrcLinkMainField);

end;

function GetFieldInfoByFieldName(strTableName, strFieldName: string): TSZHL_FieldDict;
begin

end;

// function GetFieldInfoByAutoId(intAutoid: Integer): TSZHL_FieldDict;
// begin
// if fdFieldInfo1 = nil then
// fdFieldInfo1 := TSZHL_FieldDict.Create;
//
// Result := fdFieldInfo1;
// end;

// function Replicate(pcChar: Char; piCount: integer): string;
// begin
// Result := '';
// SetLength(Result, piCount);
// fillChar(Pointer(Result)^, piCount, pcChar)
// end;

end.
