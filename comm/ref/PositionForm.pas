unit PositionForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, BaseForm,
  System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Edit, FMX.StdCtrls,
  FMX.Ani, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FMX.ListBox;

type
  TPositionFrm = class(TBaseFrm)
    cCodeLay: TLayout;
    cInvAddCodeText: TText;
    edt_Search: TEdit;
    DetailLay: TLayout;
    DetailText: TText;
    stringGrid_Position: TStringGrid;
    Confirm: TButton;
    FDM_Position: TFDMemTable;
    BindSourceDB_Position: TBindSourceDB;
    LinkGridToData_Position: TLinkGridToDataSource;
    BindingsList_Position: TBindingsList;
    clsBtn_1: TClearEditButton;
    srhBtn_1: TSearchEditButton;
    procedure ConfirmClick(Sender: TObject);
    procedure edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure stringGrid_PositionCellDblClick(const Column: TColumn; const Row: Integer);            //双击有效
    procedure FormCreate(Sender: TObject);
    procedure srhBtn_1Click(Sender: TObject);
  private
    FcWhCode: string;
    FDefModalResult: TModalResult;
    procedure setFcWhCode(Value: string);
  protected

  public
   procedure InitData; override;
    procedure RefreshData; override;
    property DefModalResult: TModalResult read FDefModalResult write FDefModalResult;
    property cWhCode: string read FcWhCode write FcWhCode;
  end;

var
  PositionFrm: TPositionFrm;

implementation

uses
  UnitU8DM, UnitLib;

{$R *.fmx}

{ TPositionFrm }
procedure TPositionFrm.setFcWhCode(Value: string);
begin
  if (Length(Trim(Value)) <= 0) then
  begin
    txt_BaseMsg.Text := '仓库不能为空！';
    Close;
  end;
end;

procedure TPositionFrm.srhBtn_1Click(Sender: TObject);

begin
  inherited;
  if (Length(Trim(cwhcode)) <=0) then
  begin
    Self.txt_BaseMsg.Text := '请先选择仓库！';
    Exit;
  end;
      initdata;
end;

procedure TPositionFrm.ConfirmClick(Sender: TObject);
begin
  inherited;
  DefModalResult := mrOk;
  btn_BaseBackClick(Sender);
end;

procedure TPositionFrm.stringGrid_PositionCellDblClick(const Column: TColumn; const Row: Integer);
begin
  inherited;
  ConfirmClick(Self);
end;

procedure TPositionFrm.FormCreate(Sender: TObject);
begin
  inherited;
  Confirm.ModalResult := mrOk;
end;

procedure TPositionFrm.edt_SearchKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    srhBtn_1.OnClick(srhBtn_1);
end;

procedure TPositionFrm.InitData;
var
  strSqlText: string;
begin
strSqlText := Format('select * from Position where cWhcode=''%s'' and (cPosCode like ''%%%s%%'' or cPosName like ''%%%s%%'')', [cWhCode, Trim(edt_Search.Text), Trim(edt_Search.Text)]);
  U8DM.ExecSql(FDM_Position, strSqlText);
  U8DM.FormatGrid_byAD('货位档案参照', '',FDM_Position, LinkGridToData_Position);
end;

procedure TPositionFrm.RefreshData;
begin

end;

end.

