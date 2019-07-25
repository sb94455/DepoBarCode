unit UnitBaseFun;

interface
     uses System.SysUtils,FireDAC.Comp.Client,Xml.XMLDoc, Xml.XMLIntf,Data.DB,FMX.Dialogs;
     procedure iniFdmemtable(grid:TFDMemTable);
     function GetPostXML(mainName:string;mainMemtable:TFDMemTable;mainDetailListName:string;DetailListName:string;Detailmemtable:TFDMemTable): string;
     procedure copyDataset(FDMsource:TFDMemTable;FDM:TFDMemTable);
     implementation
     uses  BaseForm;
 procedure iniFdmemtable(grid:TFDMemTable);
 begin
     if not grid.Active then
     begin
        grid.Active;
        grid.Close;
        grid.Open;
     end;
 end;
 procedure WriteChildNodeByDataSet(xmlDoc: TXMLDocument; nsParent: IXMLNode; dstSource: TDataSet);
var
  ndTmp: IXMLNode;
  fdTmp: TField;
  i:Integer;
  fieldname:string;
begin
   dstSource.First;
   while not dstSource.Eof do
   begin
       for i:=0 to   dstSource.FieldCount-1 do
       begin
          fieldname:=trim( dstSource.Fields[i].FieldName);
          ndTmp := xmlDoc.CreateNode(fieldname);
          nsParent.ChildNodes.Add(ndTmp);
          ndTmp.Text := dstSource.FieldByName(fieldname).AsString;
       end;
    dstSource.Next;
   end;
end;
function GetPostXML(mainName:string;mainMemtable:TFDMemTable;mainDetailListName:string;DetailListName:string;Detailmemtable:TFDMemTable): string;
var
  FXmlDoc: TXMLDocument;
  LoopInt, tmpInt: Integer;
  ndVouchHead, tmpListRootNode, ndVouchBody,ndVouchDetailBody: IXMLNode;
  bkm_Detail: TBookmark;
begin
  try
    FXmlDoc := TXMLDocument.Create(nil);
    FXmlDoc.Active := True;
    FXmlDoc.Version := '1.0';
    FXmlDoc.Encoding := 'UTF-8';  //加入版本信息 ‘<?xml version="1.0" encoding="GB2312" ?> ’
    //表头
    ndVouchHead := FXmlDoc.CreateNode(mainName);  //主单根结点
    FXmlDoc.DocumentElement := ndVouchHead;
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, mainMemtable);
    //表体
    ndVouchBody := FXmlDoc.CreateNode(mainDetailListName);        //子表根结点
    ndVouchHead.ChildNodes.Add(ndVouchBody);
    bkm_Detail := Detailmemtable.GetBookmark;
    Detailmemtable.DisableControls;
    Detailmemtable.First;
    while not Detailmemtable.Eof do
    begin
      ndVouchDetailBody  := FXmlDoc.CreateNode(DetailListName);
      ndVouchBody.ChildNodes.Add(ndVouchDetailBody);
      WriteChildNodeByDataSet(FXmlDoc, ndVouchDetailBody, Detailmemtable);
      Detailmemtable.Next;
    end;
    Detailmemtable.Bookmark := bkm_Detail;
    Detailmemtable.EnableControls;
    Result := FXmlDoc.XML.Text;
  finally
    FXmlDoc.Active := False;
    FXmlDoc.Free;
  end;
end;
procedure copyDataset(FDMsource:TFDMemTable;FDM:TFDMemTable);
var
I:Integer;
fieldname:string;
begin
   FDM.Close;
   FDM.Open;
   FDMsource.First;
   while not FDMsource.eof do
   begin
     FDM.Append;
     for I := 0 to FDMsource.FieldCount-1 do
     begin
        fieldname:=FDMsource.Fields[I].FieldName;
        if FDM.FieldList.IndexOf(fieldname)>=0 then
        begin
          FDM.Edit;
          FDM.FieldByName(fieldname).Value:= FDMsource.FieldByName(fieldname).Value;
        end;
     end;
     FDM.Post;
     FDMsource.Next;
   end;
end;
end.
