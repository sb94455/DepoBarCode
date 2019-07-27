unit uClassDefine;

interface

uses
  Classes, DB, ADODB, Controls, Dialogs, SysUtils, cxEdit, cxTextEdit, Forms, cxMaskEdit,
  cxButtonEdit, cxCalendar, cxLabel;

type
  TcxButtonEdit_SZHL = class(TcxButtonEdit)
  private
    { Private declarations }
    procedure cxButtonEditPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
  published
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; FilterID: Integer); overload;
  end;

implementation

uses
  uRef, ufmPub;

constructor TcxButtonEdit_SZHL.Create(AOwner: TComponent; FilterID: Integer);
begin
  inherited Create(AOwner);
  Tag := FilterID;
  Properties.OnButtonClick := cxButtonEditPropertiesButtonClick;
end;

procedure TcxButtonEdit_SZHL.cxButtonEditPropertiesButtonClick(Sender: TObject; AButtonIndex:
  Integer);
var
  qryRef: TADOQuery;
  strRefType: string;
begin
  qryRef := TADOQuery.Create(Self);
  try
    qryRef.ConnectionString := strDBConnectString;
    qryRef.SQL.Text := 'select * from SZHL_FltDef where autoid=:autoid';
    qryRef.Parameters.ParamByName('autoid').Value := Tag;
    qryRef.Open;
    if qryRef.Eof then
      Exit;

    strRefType := Trim(qryRef.FieldByName('RefType').AsString);
    if strRefType = '' then
      exit;
    with TfmRef.Create(Self) do
    try
      EumRefFilterDataSet(strRefType, fAll, Self.Text, Self);
      if ShowModal = mrOK then
      begin
        Self.Text := GetRefDataSet;
        Self.SetFocus;
      end;
    finally
      Free
    end;
  finally
    FreeAndNil(qryRef);
  end;

end;

end.

