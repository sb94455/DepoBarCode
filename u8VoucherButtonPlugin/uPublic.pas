unit uPublic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, cxStyles, cxGraphics, cxDataStorage, cxEdit, cxDBData,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, ExtCtrls, Buttons, ComCtrls,
  frxClass, frxExportPDF, frxGradient, frxBarcode, frxOLE, frxDesgn, xmldom,
  msxmldom, cxContainer, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxDBLookupComboBox, ActnList, Menus;

function DataSetToJson(ADataset: TDataSet; fields: string = ''): string;

implementation

function DataSetToJson(ADataset: TDataSet; fields: string = ''): string;
// [{"CityId":"18","CityName":"西安"},{"CityId":"53","CityName":"广州"}]
var
  LRecord: string;
  LField: TField;
  i: integer;
  fieldList: TStringList;
begin
  Result := '';
  if (not ADataset.Active) or (ADataset.IsEmpty) then
    Exit;
  Result := '[';
  ADataset.DisableControls;
  ADataset.First;

  fields := trim(fields);
  if trim(fields) <> '' then
  begin
    fieldList := TStringList.Create;
    fieldList.Delimiter := ',';
    fieldList.DelimitedText := fields;
  end;
  while not ADataset.Eof do
  begin
    for i := 0 to ADataset.FieldCount - 1 do
    begin

      LField := ADataset.Fields[i];
      if trim(fields) <> '' then
        if fieldList.IndexOf(LField.FieldName) < 0 then
        begin
          Continue;
        end;

      if LRecord = '' then
        LRecord := '{"' + LField.FieldName + '":"' + LField.Text + '"'
      else
        LRecord := LRecord + ',"' + LField.FieldName + '":"' + LField.Text + '"';
//      if i = ADataset.FieldCount - 1 then
//      begin
//        LRecord := LRecord + '}';
//        if Result = '[' then
//          Result := Result + LRecord
//        else
//          Result := Result + ',' + LRecord;
//        LRecord := '';
//      end;
    end;
    LRecord := LRecord + '}';
    if Result = '[' then
      Result := Result + LRecord
    else
      Result := Result + ',' + LRecord;
    LRecord := '';

    ADataset.Next;
  end;
  ADataset.EnableControls;
  Result := Result + ']';
  FreeAndNil(fieldList);
end;

end.

