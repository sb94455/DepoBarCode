unit BaseForm;

interface

uses System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FireDAC.Comp.Client,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Edit,
  FMX.Memo,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls.Presentation,
  UnitU8DM,
  FMX.Ani,
  FMX.Grid,
  FMX.Header,
  System.Messaging,
  uSZHLFMXEdit,
  FMX.ListBox;

type
  TBaseFrm = class(TForm)
    TitleRet: TRectangle;
    btn_BaseBack: TButton;
    txt_BaseTitle: TText;
    txt_BaseMsg: TText;
    ClientSCB: TVertScrollBox;
    ClientLyt: TLayout;
    MsgRec: TRectangle;
    MsgCA: TColorAnimation;
    AniIndicator: TAniIndicator;
    procedure btn_BaseBackClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    // procedure btnSrh_EvenClick(Sender: TObject);
    procedure ClientLytClick(Sender: TObject);
  private
    { Private declarations }
    FTopForm  : TForm;
    FExeStatus: TExeStatus;
    function GetDm: TU8DM;
    function GetFDM_ADDict: TFDMemTable;
    // function Get_FirstParent_TSZHL_Edit(Sender: TObject): TSZHL_Edit;
    // function Get_FirstParent_TSZHL_ComboBox(Sender: TObject): TSZHL_ComboBox;
    // function Get_FirstParent_TForm(Sender: TObject): TForm;
    procedure SetExeStatus(const aValue: TExeStatus);
  protected
    MessageManager: TMessageManager;
    procedure ReadyLayout; virtual;
    procedure ReadLayout; virtual;
    procedure UpdateLayout; virtual;
    procedure UpdateExLayout; virtual;
    procedure WaitingLayout; virtual;
    procedure SetTopForm(const aValue: TForm); virtual;
    procedure SZHL_ComboBoxSyncToControl(layParent: TFmxObject; fmMain: TFDMemTable);
    procedure SZHL_ComboBoxSyncToDB(layParent: TFmxObject; fmMain: TFDMemTable);
    procedure ListenerMethod(const Sender: TObject; const M: TMessage); virtual;
    property FDM_ADDict: TFDMemTable read GetFDM_ADDict;
  public
    { Public declarations }
    FCanUpdate: Boolean;
    procedure InitData; virtual;
    procedure RefreshData; virtual;
    property TopForm: TForm read FTopForm write SetTopForm;
    property DM_Global: TU8DM read GetDm;
    procedure SetLayout(ExeStatus: TExeStatus); virtual;
    property ExeStatus: TExeStatus read FExeStatus write SetExeStatus;
  end;

var
  BaseFrm: TBaseFrm;

implementation

uses UnitLib;
{$R *.fmx}
// procedure TBaseFrm.btnSrh_EvenClick(Sender: TObject);
// var
// objEdit: TSZHL_Edit;
// objForm: TForm;
// msg: string;
// begin
// inherited;
// objEdit := Get_FirstParent_TSZHL_Edit(Sender);
// objForm := Get_FirstParent_TForm(Sender);
//
// if (objForm = nil) or (objEdit = nil) then exit;
// if SameText(objEdit.FieldDict.Lookup_Table, 'Inventory') = True then getInventory(objForm, objEdit);
// if SameText(objEdit.FieldDict.Lookup_Table, 'Warehouse') = True then getWareHouse(objForm, objEdit);
// if SameText(objEdit.FieldDict.Lookup_Table, 'Vendor') = True then getVendor(objForm, objEdit);
//
// if SameText(objEdit.FieldDict.Lookup_Table, 'Department') = True then getDepartment(objForm, objEdit);
// if SameText(objEdit.FieldDict.Lookup_Table, 'Customer') = True then getDepartment(objForm, objEdit);
//
// end;

procedure TBaseFrm.btn_BaseBackClick(Sender: TObject);
begin
  if Assigned(self.Focused) then // 如果你的该页面有编辑控件，一定要加上这个，按返回键可以去掉键盘框
  begin
    if ((self.Focused.GetObject is TEdit) or (self.Focused.GetObject is TMemo)) then
    begin
      Focused := nil; // 退出键盘显示

    end;
  end;
  Close;
end;

procedure TBaseFrm.ClientLytClick(Sender: TObject);
begin

end;

// procedure TBaseFrm.cbb_EvenPopup(Sender: TObject);
// var
// cbSelf: TSZHL_ComboBox;
// fdm_ComboBox: TFDMemTable;
// strSql: string;
// begin
// cbSelf := Get_FirstParent_TSZHL_ComboBox(Sender);
// if cbSelf = nil then
// Exit;
// if cbSelf.Items.Count > 0 then
// exit;
//
// if cbSelf.FieldDict.Lookup_Table = '' then
// Exit;
// if SameText(cbSelf.FieldDict.Lookup_Table, 'RdStyleIn') then
// begin
// strSql := 'select ''[''+cRdCode+'']''+cRdName from rd_style where bRdFlag=1 and bRdEnd=1';
// end;
// if SameText(cbSelf.FieldDict.Lookup_Table, 'WareHouse') then
// begin
// strSql := 'select ''[''+cWhCode+'']''+cWhName from WareHouse';
// end;
// if SameText(cbSelf.FieldDict.Lookup_Table, 'VouchType') then
// begin
// strSql := ' select ''蓝单(正)'' union select ''红单(负)'' ';
// end;
// if strSql = '' then
// Exit;
//
// fdm_ComboBox := TFDMemTable.Create(nil);
// try
// cbSelf.Clear;
// U8DM.ExecSql(fdm_ComboBox, strSql);
// while not fdm_ComboBox.Eof do
// begin
// cbSelf.Items.Add(fdm_ComboBox.Fields[0].AsString);
// fdm_ComboBox.Next;
// end;
// finally
// fdm_ComboBox.Free;
// end;
//
//
/// /    with
/// /  cbSelf.FieldDict do
/// /  begin
/// /    strSql:=Format('select %s from %s where %s=''%s''',[Lookup_ValueField,Lookup_Table)
/// /  end;
// end;

procedure TBaseFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  if (TopForm is TForm) then
  begin
    TopForm.Show;
  end;
end;

procedure TBaseFrm.FormCreate(Sender: TObject);
begin
  // edt_Even.Visible := False;
  // cbb_Even.Visible := False;

  if Sender is TForm then // 如果是派生窗口类
    TopForm := Sender as TForm;
  Position := TFormPosition.OwnerFormCenter;
end;

procedure TBaseFrm.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then // 如果按了返回键
  begin
    Key := 0;
    btn_BaseBackClick(Sender);
  end;
end;

function TBaseFrm.GetDm: TU8DM;
begin
  Result := U8DM;
end;

function TBaseFrm.GetFDM_ADDict: TFDMemTable;
begin
  Result := U8DM.FDM_SZHL_ItmDef;
end;
//
// function TBaseFrm.Get_FirstParent_TSZHL_Edit(Sender: TObject): TSZHL_Edit;
// var
// iCompe: TFmxObject;
// begin
// Result := nil;
// if (Sender is TFmxObject) then begin
// iCompe := Sender as TFmxObject;
// while True do begin
// if iCompe is TSZHL_Edit then begin
// Result := (iCompe as TSZHL_Edit);
// exit;
// end;
// iCompe := iCompe.Parent;
// end;
// end;
// end;
//
// function TBaseFrm.Get_FirstParent_TForm(Sender: TObject): TForm;
// var
// iCompe: TFmxObject;
// begin
// Result := nil;
// if (Sender is TFmxObject) then begin
// iCompe := Sender as TFmxObject;
// while True do begin
// if iCompe is TForm then begin
// Result := (iCompe as TForm);
// exit;
// end;
// iCompe := iCompe.Parent;
// end;
// end;
// end;
//
// function TBaseFrm.Get_FirstParent_TSZHL_ComboBox(Sender: TObject): TSZHL_ComboBox;
// var
// iCompe: TFmxObject;
// begin
// Result := nil;
// if (Sender is TFmxObject) then begin
// iCompe := Sender as TFmxObject;
// while True do begin
// if iCompe is TSZHL_ComboBox then begin
// Result := (iCompe as TSZHL_ComboBox);
// exit;
// end;
// iCompe := iCompe.Parent;
// end;
// end;
// end;

procedure TBaseFrm.InitData;
begin
end;

procedure TBaseFrm.ListenerMethod(const Sender: TObject; const M: TMessage);
begin

end;

procedure TBaseFrm.ReadLayout;
begin

end;

procedure TBaseFrm.ReadyLayout;
begin

end;

procedure TBaseFrm.RefreshData;
begin

end;

procedure TBaseFrm.SetExeStatus(const aValue: TExeStatus);
begin
  FExeStatus := aValue;
  case aValue of
  esReady: ReadyLayout;
  esWaiting: ReadyLayout;
  end;
end;

procedure TBaseFrm.SetLayout(ExeStatus: TExeStatus);
begin
  case ExeStatus of
  esReady: ReadyLayout;
  esWaiting: WaitingLayout;
  end;
end;

procedure TBaseFrm.SetTopForm(const aValue: TForm);
begin
  FTopForm := aValue;
end;

procedure TBaseFrm.SZHL_ComboBoxSyncToControl(layParent: TFmxObject; fmMain: TFDMemTable);

  procedure FindSZHL_ComboBox(Sender: TFmxObject);
  var
    i          : Integer;
    ChildObject: TFmxObject;
    cbbObj     : TSZHL_ComboBox;
    ctrlObj    : TControl;
    strDebug   : string;
  begin
    if Sender.Children <> nil then
      for i := 0 to Sender.Children.Count - 1 do
      begin
        ChildObject := Sender.Children[i];
        if ChildObject is TControl then
        begin
          ctrlObj := ChildObject as TControl;
          strDebug := ctrlObj.Name + ':' + ctrlObj.ClassName + '[' + Sender.ClassName + ']';
        end;

        if ChildObject is TSZHL_ComboBox then
        begin
          cbbObj := ChildObject as TSZHL_ComboBox;
          cbbObj.ItemIndex := cbbObj.RefValue.IndexOf(fmMain.FieldByName(cbbObj.FieldDict.FieldName).AsString.Trim);
        end;
        if ChildObject.ChildrenCount > 0 then
          FindSZHL_ComboBox(ChildObject);
      end;
  end;

begin
  FindSZHL_ComboBox(layParent);
end;

procedure TBaseFrm.SZHL_ComboBoxSyncToDB(layParent: TFmxObject; fmMain: TFDMemTable);

  procedure FindSZHL_ComboBox(Sender: TFmxObject);
  var
    i          : Integer;
    ChildObject: TFmxObject;
    cbbObj     : TSZHL_ComboBox;
    ctrlObj    : TControl;
    strDebug   : string;
  begin
    if Sender.Children <> nil then
      for i := 0 to Sender.Children.Count - 1 do
      begin
        ChildObject := Sender.Children[i];
        if ChildObject is TControl then
        begin
          ctrlObj := ChildObject as TControl;
          strDebug := ctrlObj.Name + ':' + ctrlObj.ClassName + '[' + Sender.ClassName + ']';
        end;

        if ChildObject is TSZHL_ComboBox then
        begin
          cbbObj := ChildObject as TSZHL_ComboBox;
          if cbbObj.ItemIndex < 0 THEN
            fmMain.FieldByName(cbbObj.FieldDict.FieldName).Value := NULL
          else
          begin
            fmMain.FieldByName(cbbObj.FieldDict.FieldName).Value := cbbObj.RefValue.Strings[cbbObj.ItemIndex];
//            showmessage(format('SetValue!Field:%s,Value:%s', [cbbObj.FieldDict.FieldName, cbbObj.RefValue.Strings[cbbObj.ItemIndex]]));
          end;
        end;
        if ChildObject.ChildrenCount > 0 then
          FindSZHL_ComboBox(ChildObject);
      end;
  end;

begin
  FindSZHL_ComboBox(layParent);
end;

procedure TBaseFrm.UpdateExLayout;
begin

end;

procedure TBaseFrm.UpdateLayout;
begin

end;

procedure TBaseFrm.WaitingLayout;
begin

end;

end.
