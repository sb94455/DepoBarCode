unit uSplitQty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGrid, StdCtrls, DBClient;

type
  Tfrm_split = class(TForm)
    btnOk: TButton;
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    ds2: TDataSource;
    cxGrid1DBTableView1qty: TcxGridDBColumn;
    btnCancel: TButton;
    cxGrid1DBTableView1autoid: TcxGridDBColumn;
    ds1: TClientDataSet;
    ds1autoid: TIntegerField;
    ds1qty: TFloatField;
    procedure btnOkClick(Sender: TObject);
    procedure ds1BeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
    ftotalqty: double;
    Fstrjson: string;
    Fautoid: Integer;
    Fok: Boolean;
    procedure Settotalqty(const Value: Double);
  public
    { Public declarations }
    property autoid: Integer read Fautoid write Fautoid;
    property totalqty: Double read Ftotalqty write Settotalqty;
    property strjson: string read Fstrjson;
  property ok :Boolean  read Fok write Fok;
  end;

var
  frm_split: Tfrm_split;

implementation

{$R *.dfm}
uses
  uPublic;

procedure Tfrm_split.btnOkClick(Sender: TObject);
var
  a: Double;
begin
  if cxGrid1DBTableView1.NavigatorButtons.Post.Enabled then
    cxGrid1DBTableView1.NavigatorButtons.Post.Click;
  if ds1.RecordCount <= 1 then
  begin
    MessageBox(Application.Handle, PChar('拆分后的行数至少为2行'), '错误', MB_ICONERROR);
    Abort;
  end;

  with ds1.Aggregates.Add do
  begin
    name := 'sumqty';
    Expression := 'sum(qty)';
//     IndexName := edtAggIndexName.Text;
    Active := True;
  end;
  if VarIsNull(ds1.Aggregates[0].Value) then
    a := 0
  else
    a := ds1.Aggregates[0].Value;
  ds1.Aggregates[0].Free;
  if a <> ftotalqty then
  begin
    MessageBox(Application.Handle, PChar('拆分后的数量合计不等于总数'), '错误', MB_ICONERROR);
    Abort;
  end
  else
  begin
    Fstrjson := DataSetToJson(ds1);
    ok:=True;
  end;
end;

procedure Tfrm_split.Settotalqty(const Value: Double);
begin
  Ftotalqty := Value;
//  ds1.EmptyDataSet;
  ds1.Append;
  ds1.FieldByName('autoid').Value := autoid;
  ds1.FieldByName('qty').Value := ftotalqty;
  ds1.Post;
  self.Caption := Format('拆分总数:%s', [floattostr(ftotalqty)]);
end;

procedure Tfrm_split.ds1BeforeDelete(DataSet: TDataSet);
begin
  if DataSet.FieldByName('autoid').AsInteger > 0 then
  begin
    MessageBox(Application.Handle, PChar('原始记录不能删除'), '错误', MB_ICONERROR);
    Abort;
  end;
end;

end.

