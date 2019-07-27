unit ufmPub;

interface

uses
//  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
//  Dialogs, cxStyles, cxClasses, cxGridTableView, cxLookAndFeels;

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, cxStyles, cxGraphics, cxDataStorage, cxEdit, cxDBData,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView, WinSock,
  cxGridTableView, cxGridDBTableView, cxGrid, ExtCtrls, Buttons, ComCtrls,
  frxExportPDF, frxGradient, frxBarcode, frxOLE, frxDesgn, xmldom, msxmldom,
  cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookAndFeelPainters,
  cxDBLookupComboBox, ActnList, Menus, cxLookAndFeels, cxCustomData, cxFilter,
  cxData, cxCheckBox, cxGridLevel;

type
  TfrmPub = class(TForm)
    cxlkndflcntrlr1: TcxLookAndFeelController;
    cxstylrpstry1: TcxStyleRepository;
    cxgrdtblvwstylshtGridTableViewStyleSheetDevExpress: TcxGridTableViewStyleSheet;
    cxstyl1: TcxStyle;
    cxstyl2: TcxStyle;
    cxstyl3: TcxStyle;
    cxstyl4: TcxStyle;
    cxstyl5: TcxStyle;
    cxstyl6: TcxStyle;
    cxstyl7: TcxStyle;
    cxstyl8: TcxStyle;
    cxstyl9: TcxStyle;
    cxstyl10: TcxStyle;
    cxstyl11: TcxStyle;
    cxstyl12: TcxStyle;
    cxstyl13: TcxStyle;
    cxstyl14: TcxStyle;
    cxgrdtblvwstylshtGridTableViewStyleSheetRedWhiteandBlueVGA: TcxGridTableViewStyleSheet;
    cxstyl15: TcxStyle;
    cxstyl16: TcxStyle;
    cxstyl17: TcxStyle;
    cxstyl18: TcxStyle;
    cxstyl19: TcxStyle;
    cxstyl20: TcxStyle;
    cxstyl21: TcxStyle;
    cxstyl22: TcxStyle;
    cxstyl23: TcxStyle;
    cxstyl24: TcxStyle;
    cxstyl25: TcxStyle;
    cxgrdtblvwstylshtGridTableViewStyleSheetHighContrastWhite: TcxGridTableViewStyleSheet;
    cxstyl26: TcxStyle;
    cxstyl27: TcxStyle;
    cxstyl28: TcxStyle;
    cxstyl29: TcxStyle;
    cxstyl30: TcxStyle;
    cxstyl31: TcxStyle;
    cxstyl32: TcxStyle;
    cxstyl33: TcxStyle;
    cxstyl34: TcxStyle;
    cxstyl35: TcxStyle;
    cxstyl36: TcxStyle;
    cxgrdbtblvwGrid1DBTableView1: TcxGridDBTableView;
    cxgrdlvlGrid1Level1: TcxGridLevel;
    cxgrd1: TcxGrid;
    cxgrdbclmnGrid1DBTableView1Column1: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TGridHelp = class(TObject)
  public
    class procedure tvCustomDrawIndicatorCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
  end;

function GetBaseFile(RptID: Integer; var ms: TMemoryStream): Boolean;

function GetKeyValueFromXML(strXml, strkeyName: string): string;

function SaveBaseFile(RptID: Integer; VouchType: string; var ms: TMemoryStream): Boolean;

function FillGridViewColumns(gvView: TcxGridDBTableView; strTBName: string; Clear: Boolean = True): Boolean;

procedure SaveGridViewColumns(gvView: TcxGridDBTableView);

procedure FillGridSelColumn(View_up: TcxGridDBTableView; keyFieldName: string);

procedure FormatDBGridView(gvView: TcxGridDBTableView; ReadOnly: Boolean = True);

function findInListViewByCaption(lv1: TListView; strCaption: string): Integer;

procedure CreateQR;

function GetHostIP: string; //获取IP

function GetComputerName: string; //获取计算机名称

var
  frmPub: TfrmPub;
  strDBConnectString: string;
  login_cUserId, Login_cUserName, login_cUserPassWord, login_cAcc_Id: string;

implementation

{$R *.dfm}
class procedure TGridHelp.tvCustomDrawIndicatorCell(Sender: TcxGridTableView; ACanvas: TcxCanvas; AViewInfo: TcxCustomGridIndicatorItemViewInfo; var ADone: Boolean);
var
  AIndicatorViewInfo: TcxGridIndicatorRowItemViewInfo;
  ATextRect: TRect;
  AFont: TFont;
  AFontTextColor, AColor: TColor;
begin
  AFont := ACanvas.Font;
  AColor := clBtnFace;
  AFontTextColor := clWindowText;
  if (AViewInfo is TcxGridIndicatorHeaderItemViewInfo) then
  begin
    ATextRect := AViewInfo.Bounds;
    InflateRect(ATextRect, -1, -1);
    Sender.LookAndFeelPainter.DrawHeader(ACanvas, AViewInfo.Bounds, ATextRect, [], cxBordersAll, cxbsNormal, taCenter, vaCenter, False, False, '行号', AFont, AFontTextColor, AColor);
    ADone := True;
  end;
  if not (AViewInfo is TcxGridIndicatorRowItemViewInfo) then
    Exit;
  ATextRect := AViewInfo.ContentBounds;
  AIndicatorViewInfo := AViewInfo as TcxGridIndicatorRowItemViewInfo;
  InflateRect(ATextRect, -1, -1);

  if AIndicatorViewInfo.GridRecord.Selected then
  // 这个if段是为了在行号处把把选中的行号跟别的区分开，可不用
  begin
    AFont.Style := ACanvas.Font.Style + [fsBold];
    ACanvas.Font.Color := clRed;
  end
  else
  begin
    AFont.Style := ACanvas.Font.Style - [fsBold];
    ACanvas.Font.Color := ACanvas.Font.Color;
  end;

  Sender.LookAndFeelPainter.DrawHeader(ACanvas, AViewInfo.ContentBounds, ATextRect, [], cxBordersAll, cxbsNormal, taCenter, vaCenter, False, False, IntToStr(AIndicatorViewInfo.GridRecord.Index + 1), ACanvas.Font, ACanvas.Font.Color, ACanvas.Brush.Color);
  ADone := True;

end;

function GetComputerName: string; //获取计算机名称
var
  wVersionRequested: WORD;
  wsaData: TWSAData;
  p: PHostEnt;
  s: array[0..128] of char;
begin
  try
    wVersionRequested := MAKEWORD(1, 1); //创建 WinSock
    WSAStartup(wVersionRequested, wsaData); //创建 WinSock
    GetHostName(@s, 128);
    p := GetHostByName(@s);
    Result := p^.h_Name;
  finally
    WSACleanup; //释放 WinSock
  end;
end;

function GetHostIP: string; //获取IP
var
  wVersionRequested: WORD;
  wsaData: TWSAData;
  p: PHostEnt;
  s: array[0..128] of char;
  p2: pchar;
begin
  try
    wVersionRequested := MAKEWORD(1, 1); //创建 WinSock
    WSAStartup(wVersionRequested, wsaData); //创建 WinSock
    GetHostName(@s, 128);
    p := GetHostByName(@s);
    p2 := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    Result := p2;
  finally
    WSACleanup; //释放 WinSock
  end;
end;

procedure CreateQR;
begin
  with TADOStoredProc.Create(nil) do
  try
    ConnectionString := strDBConnectString;
    ProcedureName := 'SZHL_CreateQR';
    ExecProc;
  finally
    Free
  end;
end;

function findInListViewByCaption(lv1: TListView; strCaption: string): Integer;
var
  i, j: Integer;
begin
  j := -1;
  for i := 0 to lv1.Items.Count - 1 do
  begin
    if lv1.Items[i].SubItems[4] = strCaption then
    begin
      j := i;
    end
  end;
  Result := j;
end;

procedure SaveGridViewColumns(gvView: TcxGridDBTableView);
var
  i: Integer;
  strFldName: string;
begin
  if gvView.Tag <= 0 then
    Exit;
  with TADOQuery.Create(nil) do
  try
    ConnectionString := strDBConnectString;
    LockType := ltBatchOptimistic;
    SQL.Text := 'select * from SZHL_ItmDef where tableid=:tableid order by seq';
    Parameters.ParamByName('tableid').Value := gvView.Tag;
    Open;
    while not Eof do
    begin
      strFldName := FieldByName('FieldName').AsString;
      for i := 0 to gvView.ColumnCount - 1 do
      begin
        if trim(UpperCase(gvView.Columns[i].DataBinding.FieldName)) = Trim(UpperCase(strFldName)) then
        begin
          Edit;
          FieldByName('Width').Value := gvView.Columns[i].Width;
          Post;
        end;
      end;
      Next;
    end;
    UpdateBatch(arAll);
  finally
    Free
  end;
end;

procedure FillGridSelColumn(View_up: TcxGridDBTableView; keyFieldName: string);
begin
  View_up.ClearItems;
  View_up.CreateColumn; //建立一个没绑定的列
  View_up.Columns[0].Caption := '选择';
  View_up.Columns[0].Options.Filtering := False;
    //View_up.DataController.CreateAllItems; //建立所有绑定的列
  View_up.Columns[0].Width := 36;

    //下列5行语句是为了让没绑定列成为 CheckBox ：
  View_up.DataController.KeyFieldNames := keyFieldName;
  View_up.DataController.DataModeController.SmartRefresh := true;
  View_up.Columns[0].DataBinding.ValueType := 'Boolean';
  View_up.Columns[0].PropertiesClass := TcxCheckBoxProperties;
  (View_up.Columns[0].Properties as TcxCheckBoxProperties).ValueGrayed := False;
  (View_up.Columns[0].Properties as TcxCheckBoxProperties).NullStyle := nssUnchecked;
    //由于CheckBox列是动态列，所以需要给其关联一个OnChange的事件：
    //(View_up.Columns[0].Properties as TcxCheckBoxProperties).OnChange := View_UpCheckBoxColumnPropertiesChange; //关联事件
end;

function FillGridViewColumns(gvView: TcxGridDBTableView; strTBName: string; Clear: Boolean = True): Boolean;
var
  I, intTbId: Integer;
  blReturn: Boolean;
  cxcolCurrent: TcxGridDBColumn;
begin
  blReturn := false;
  if Clear = True then
    gvView.ClearItems;

  with TADOQuery.Create(nil) do
  try
    ConnectionString := strDBConnectString;
    SQL.Text := 'select * from SZHL_TableDef where Name=:Name';
    Parameters.ParamByName('Name').Value := strTBName;
    Open;
    if Eof then
    begin
      MessageBox(Application.Handle, PChar('表(' + strTBName + ')格式模板加载失败.'), '错误', MB_ICONERROR);
      Result := blReturn;
      Exit;
    end
    else
    begin
      intTbId := FieldByName('TableId').AsInteger;
      gvView.Tag := intTbId;
    end;
  finally
    Free;
  end;

  with TADOQuery.Create(nil) do
  begin
    try
      ConnectionString := strDBConnectString;
      SQL.Text := 'select * from SZHL_ItmDef where tableid=:tableid order by seq';
      Parameters.ParamByName('tableid').Value := intTbId;
      Open;
      while not Eof do
      begin
        cxcolCurrent := gvView.CreateColumn;
        cxcolCurrent.DataBinding.FieldName := Trim(FieldByName('FieldName').AsString);
        cxcolCurrent.Caption := Trim(FieldByName('FieldDef').AsString);
        cxcolCurrent.Options.Filtering := FieldByName('Filtering').AsBoolean;
        cxcolCurrent.Options.Editing := FieldByName('Editing').AsBoolean;
        cxcolCurrent.Options.Sorting := FieldByName('Sorting').AsBoolean;
        cxcolCurrent.Options.Grouping := FieldByName('Grouping').AsBoolean;
        if FieldByName('iVisible').AsBoolean then
        begin
          cxcolCurrent.Visible := True;
          cxcolCurrent.HeaderAlignmentHorz := taCenter;
          if FieldByName('Width').AsInteger = 0 then
            cxcolCurrent.ApplyBestFit()
          else
            cxcolCurrent.Width := FieldByName('Width').AsInteger;
        end
        else
        begin
          cxcolCurrent.Visible := False;
        end;
        Next;
      end;
    finally
      Free;
    end;
  end;
  Result := blReturn;
end;

procedure FormatDBGridView(gvView: TcxGridDBTableView; ReadOnly: Boolean = True);
begin
  gvView.OptionsView.GroupByBox := False;
  gvView.OptionsView.Indicator := True;
  gvView.OptionsView.IndicatorWidth := 40;
  gvView.OptionsView.HeaderHeight := 22;
//  gvView.OptionsSelection.CellSelect := not ReadOnly;
//  gvView.OptionsData.Editing := not ReadOnly;
  gvView.OptionsData.Appending := not ReadOnly;
  gvView.OptionsData.Deleting := not ReadOnly;
  gvView.OnCustomDrawIndicatorCell := TGridHelp.tvCustomDrawIndicatorCell;
end;

function GetKeyValueFromXML(strXml, strkeyName: string): string;
var
  substr1, substr2, strReturn: string;
  strLeftChar, strRightChar: string;
  intPos: Integer;
begin
  strReturn := '';
  strLeftChar := '"';
  strRightChar := '"';
  intPos := Pos('<rs:data>', strXml);
  if intPos > 0 then
  begin
    strXml := Copy(strXml, intPos, Length(strXml));
  end;

  substr1 := Format(' %s=%s', [strkeyName, strLeftChar]);

  intPos := Pos(UpperCase(substr1), UpperCase(strXml));
  if intPos > 0 then
  begin
    substr2 := Copy(strXml, intPos + Length(substr1), Length(strXml));
    intPos := Pos(UpperCase(strRightChar), UpperCase(substr2));
    if intPos > 0 then
    begin
      strReturn := Copy(substr2, 1, intPos - Length(strRightChar));
    end;
  end;
  Result := strReturn;
end;

function GetBaseFile(RptID: Integer; var ms: TMemoryStream): Boolean;
var
  returnValue: Boolean;
begin
  returnValue := false;
  with TADOQuery.Create(nil) do
  try
    begin
      ConnectionString := strDBConnectString;
      SQL.Text := 'select * from SZHL_Report where id=:id';
      Parameters.ParseSQL(SQL.Text, True);
      Parameters.ParamByName('id').Value := RptID;
      Open;
      if not Eof then
      begin
        if ms = nil then
          ms := TMemoryStream.Create;
        TBlobField(FieldByName('Template')).SaveToStream(ms);
//        ms := CreateBlobStream(FieldByName('Template'), bmRead);
        if ms.Size > 0 then
        begin
          ms.Position := 0;
          returnValue := true;
        end;
      end;
    end;
  finally
    Result := returnValue;
    Free;
  end;
end;

function SaveBaseFile(RptID: Integer; VouchType: string; var ms: TMemoryStream): Boolean;
var
  returnValue: Boolean;
begin
  returnValue := false;
  with TADOQuery.Create(nil) do
  try
    begin
      ConnectionString := strDBConnectString;
      SQL.Text := 'Select * from SZHL_Report where id=:id';
      Parameters.ParseSQL(SQL.Text, True);
      Parameters.ParamByName('id').Value := RptID;
      Open;
      if Recordset.RecordCount <= 0 then
      begin
        Result := returnValue;
        Exit;
      end
      else
      begin
        Edit;
        FieldByName('id').Value := RptID;
        FieldByName('VouchType').Value := VouchType;
        TBlobField(FieldByName('Template')).LoadFromStream(ms);
        Post;
      end;
      returnValue := true;
    end;
  finally
    Result := returnValue;
    Free;
  end;
end;

end.

