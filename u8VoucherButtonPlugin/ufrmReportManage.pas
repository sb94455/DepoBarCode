unit ufrmReportManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, ADODB, ComCtrls, ToolWin, ActnList, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, frxClass, frxDesgn,
  cxInplaceContainer, cxVGrid, cxOI;

type
  TfrmReportManage = class(TForm)
    cxgrdbtblvwReport: TcxGridDBTableView;
    cxgrdlvlReport: TcxGridLevel;
    cxgrd1: TcxGrid;
    actlst1: TActionList;
    actADD: TAction;
    actModify: TAction;
    actDel: TAction;
    tlb1: TToolBar;
    btnADD: TToolButton;
    btnModify: TToolButton;
    btnSave: TToolButton;
    dsReport: TADODataSet;
    ds_Report: TDataSource;
    frxrprtReport: TfrxReport;
    actSave: TAction;
    btnDel: TToolButton;
    btnDesign: TToolButton;
    btn2: TToolButton;
    actDesign: TAction;
    frxdsgnr1: TfrxDesigner;
    actExit: TAction;
    btnExit: TToolButton;
    actCancel: TAction;
    btnCancel: TToolButton;
    cxgrdbclmnReportColumn1: TcxGridDBColumn;
    procedure FormShow(Sender: TObject);
    procedure dsReportBeforeOpen(DataSet: TDataSet);
    procedure dsReportAfterOpen(DataSet: TDataSet);
    procedure dsReportAfterInsert(DataSet: TDataSet);
    procedure actADDExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actDelExecute(Sender: TObject);
    procedure actDesignExecute(Sender: TObject);
    function frxdsgnr1SaveReport(Report: TfrxReport; SaveAs: Boolean): Boolean;
    procedure actExitExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actModifyExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    { Private declarations }
    FEditStatus: string;
    procedure setBtnStatue(Value: string);
  public
    { Public declarations }
    ReportClass: string;
    property EditStatus: string read FEditStatus write setBtnStatue;
  end;

var
  frmReportManage: TfrmReportManage;

implementation

uses
  ufmPub;
{$R *.dfm}

procedure TfrmReportManage.FormShow(Sender: TObject);
begin
  FormatDBGridView(cxgrdbtblvwReport, False);
  dsReport.Open;
  EditStatus := 'Show';
end;

procedure TfrmReportManage.dsReportBeforeOpen(DataSet: TDataSet);
begin
  with DataSet as TADODataSet do
  begin
    ConnectionString := strDBConnectString;
    CommandText := 'select * from SZHL_Report where Vouchtype=:VouchType';
    Parameters.ParamByName('VouchType').Value := ReportClass;
  end;
end;

procedure TfrmReportManage.dsReportAfterOpen(DataSet: TDataSet);
begin
  FillGridViewColumns(cxgrdbtblvwReport, 'SZHL_Report');
end;

procedure TfrmReportManage.dsReportAfterInsert(DataSet: TDataSet);
var
  ms: TMemoryStream;
begin
  with DataSet as TADODataSet do
  begin
    FieldByName('VouchType').Value := ReportClass;
    ms := TMemoryStream.Create;
    frxrprtReport.Clear;
    frxrprtReport.SaveToStream(ms);
    TBlobField(FieldByName('Template')).LoadFromStream(ms);
    FieldByName('Caption').Value := '*新建报表模板*';
  end;
end;

procedure TfrmReportManage.actADDExecute(Sender: TObject);
begin
  dsReport.Append;
  EditStatus := 'ADD';
end;

procedure TfrmReportManage.actSaveExecute(Sender: TObject);
begin
  dsReport.Post;
  EditStatus := 'Save';
end;

procedure TfrmReportManage.actDelExecute(Sender: TObject);
var
  strReportName: string;
begin
  if dsReport.Eof then
    Exit;
  strReportName := dsReport.FieldByName('Caption').AsString;
  if MessageBox(Handle, PChar(Format('您确定要删除报表模板[%s]?', [strReportName])), '请确认', MB_ICONQUESTION + MB_YESNOCANCEL) = IDYES then
    dsReport.Delete;
  EditStatus := 'Del';
end;

procedure TfrmReportManage.actDesignExecute(Sender: TObject);
var
  ms: TMemoryStream;
begin
  ms := TMemoryStream.Create;
  TBlobField(dsReport.FieldByName('Template')).SaveToStream(ms);
  if ms.Size > 0 then
    ms.Position := 0;
  frxrprtReport.LoadFromStream(ms);
  frxrprtReport.DesignReport();

end;

function TfrmReportManage.frxdsgnr1SaveReport(Report: TfrxReport; SaveAs: Boolean): Boolean;
var
  ms: TMemoryStream;
begin
  try
    begin
//    dsReport.Edit;
      ms := TMemoryStream.Create;
      frxrprtReport.SaveToStream(ms);
      TBlobField(dsReport.FieldByName('Template')).LoadFromStream(ms);
//    dsReport.Post;
      MessageBox(handle, '报表模板保存成功！', '提示', MB_ICONINFORMATION + MB_OK);
    end;
  finally
    FreeAndNil(ms);
  end;
end;

procedure TfrmReportManage.actExitExecute(Sender: TObject);
begin
  if (dsReport.State = dsInsert) or (dsReport.State = dsEdit) then
  begin
    case MessageBox(Handle, '当前数据编辑中，是否需要保存 ？', '', MB_YESNOCANCEL + MB_ICONQUESTION) of
      ID_YES:
        actSave.Execute;
      ID_NO:
        actCancel.Execute;
      ID_CANCEL:
        Abort;
    end;
  end;
  Close;
end;

procedure TfrmReportManage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmReportManage.setBtnStatue(Value: string);
begin
  FEditStatus := Value;

  if Value = 'Show' then
  begin
    actADD.Enabled := True;
    actModify.Enabled := True;
    actSave.Enabled := not True;
    actCancel.Enabled := not True;
    actDel.Enabled := True;
    actDesign.Enabled := not True;
  end;
  if (Value = 'ADD') or (Value = 'Modify') then
  begin
    actADD.Enabled := not True;
    actModify.Enabled := not True;
    actSave.Enabled := True;
    actCancel.Enabled := True;
    actDel.Enabled := not True;
    actDesign.Enabled := True;
  end;
  if (Value = 'Save') or (Value = 'Cancel') then
  begin
    actADD.Enabled := True;
    actModify.Enabled := True;
    actSave.Enabled := not True;
    actCancel.Enabled := not True;
    actDel.Enabled := True;
    actDesign.Enabled := not True;
  end;
  if (dsReport.Eof) and (dsReport.State <> dsInsert) then
  begin
    actADD.Enabled := True;
    actModify.Enabled := not True;
    actSave.Enabled := not True;
    actCancel.Enabled := not True;
    actDel.Enabled := not True;
    actDesign.Enabled := not True;
  end;
end;

procedure TfrmReportManage.actModifyExecute(Sender: TObject);
begin
  dsReport.Edit;
  EditStatus := 'Modify';
end;

procedure TfrmReportManage.actCancelExecute(Sender: TObject);
begin
  dsReport.Cancel;
  EditStatus := 'Cancel';
end;

end.

