unit VouRd01;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  StrUtils, Xml.XMLDoc, Xml.XMLIntf, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, Soap.SOAPHTTPClient, BaseForm, FMX.Layouts, FMX.DateTimeCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Ani, FMX.ListBox,
  FMX.Edit, FMX.ScrollBox, FMX.Memo, System.Rtti, PurchaseInService, FMX.Grid.Style,
  FMX.Grid, UnitLib, WareHouseForm, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Fmx.Bind.Grid, Data.Bind.Grid, FMX.TabControl;

type
  Tfrm_Rd01 = class(TBaseFrm)
    DetailLay: TLayout;
    BillCodeLay: TLayout;
    edt_QRCode: TEdit;
    txt_QRCodeLabe: TText;
    stringGrid_sub: TStringGrid;
    btn_Save: TButton;
    fdm_Main: TFDMemTable;
    fdm_Sub: TFDMemTable;
    fdm_Detail: TFDMemTable;
    stringGrid_Detail: TStringGrid;
    BindSourceDB_Main: TBindSourceDB;
    BindingsList1: TBindingsList;
    lyt_Main: TLayout;
    ClearEditButton1: TClearEditButton;
    BindSourceDB_Detail: TBindSourceDB;
    LinkGridToData_Detail: TLinkGridToDataSource;
    LinkGridToData_Sub: TLinkGridToDataSource;
    BindSourceDB_Sub: TBindSourceDB;
    TabControl1: TTabControl;
    TabItem_Detail: TTabItem;
    TabItem_Group: TTabItem;
    SearchEditButton1: TSearchEditButton;
    lblPosition: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fdm_MainAfterOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure SearchEditButton1Click(Sender: TObject);
    procedure fdm_DetailAfterInsert(DataSet: TDataSet);
    procedure btn_SaveClick(Sender: TObject);
    procedure fdm_SubAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
    //FVouchObj: TSZHL_Vouch;
    FQRCode: string;
    FDefault_cPosition: string;
    FcWhCode: string;
    function GetPostXML(): string;
    procedure setDefaulPosition(Value: string);
    procedure GroupDetails;
  protected
    procedure InitData; override;
  public
    procedure RefreshData; override;
    property Default_cPosition: string read FcWhCode write setDefaulPosition;
    property QRCode: string read FQRCode write FQRCode;
    //property VouchObj: TSZHL_Vouch read FVouchObj write FVouchObj;
//    procedure GroupDetail(FDM_detail1, FDM_Group1: TFDMemTable; strTableName: string);
  end;

var
  frm_Rd01: Tfrm_Rd01;

implementation

{$R *.fmx}

uses
  UnitU8DM;

procedure Tfrm_Rd01.btn_SaveClick(Sender: TObject);

  procedure MyProcedure();
  var
    tmpHTTPRIO: THTTPRIO;
    Service_Data: PurchaseInServiceSoap;
    strReturn, strPostXML: string;
  begin
    try
      try
        strPostXML := GetPostXML();
        tmpHTTPRIO := THTTPRIO.Create(Nil);
        Service_Data := GetPurchaseInServiceSoap(False, AppServer + Const_Url_Def_PurchaseIn, tmpHTTPRIO);
        strReturn := Service_Data.Insert(strPostXML);
      except
        on E: Exception do
        begin
          ShowMessage(E.Message);
        end;
      end;
    finally
      tmpHTTPRIO.Free;
    end;
  end;

begin
  inherited;
  if fdm_Main.State in [dsEdit, dsInsert] then
    fdm_Main.Post;

  if fdm_Detail.State in [dsEdit, dsInsert] then
    fdm_Detail.Post;
end;

procedure Tfrm_Rd01.fdm_DetailAfterInsert(DataSet: TDataSet);
var
  fdm_tmp1: TFDMemTable;
begin
  fdm_tmp1 := TFDMemTable.Create(self);
  DM_Global.ExecSql(fdm_tmp1, Format('select * from WssBC_ArrivalVouchs_NotIn where cCode=''%s'' and cInvCode=''%s''', [Trim(GetValueByKey(FQRCode, 'cCode')), Trim(GetValueByKey(FQRCode, 'cInvCode'))]));
  if fdm_tmp1.Eof then
    Exit;
  DataSet.FieldByName('cdefine34').Value := StrToInt(Trim(GetValueByKey(FQRCode, 'AutoId')));
  DataSet.FieldByName('cInvCode').AsString := fdm_tmp1.FieldByName('cInvCode').Value;
  DataSet.FieldByName('iQuantity').Value := StrToFloat(IfThen(Trim(GetValueByKey(FQRCode, 'iQuantity')) = '', '0', Trim(GetValueByKey(FQRCode, 'iQuantity'))));
  DataSet.FieldByName('cBatch').AsString := Trim(GetValueByKey(FQRCode, 'cBatch'));
  DataSet.FieldByName('iArrsId').AsString := fdm_tmp1.FieldByName('Autoid').Value;
  DataSet.FieldByName('cPosition').AsString := Default_cPosition;
end;

procedure Tfrm_Rd01.fdm_MainAfterOpen(DataSet: TDataSet);
var
  strVouchsSql, strVouchsSql_sub: string;
begin
  inherited;

  //子表
  LinkGridToData_Detail.Columns.Clear;
  strVouchsSql := Format('select * from %s where %s=''%s''', [VouchObj.VouchsTableName, vouchobj.VouchsRelationVouchFieldName, vouchobj.VouchId]);
  DM_Global.ExecSql(fdm_Detail, strVouchsSql);
  DM_Global.FormatGrid_byAD(vouchobj.VouchsTableName, '', fdm_Detail, LinkGridToData_Detail);

  //来源（汇总)表
  LinkGridToData_Sub.Columns.Clear;
  strVouchsSql_sub := Format('select %s from %s where %s =''%s''', [vouchobj.VouchsRelationSourceFieldName, vouchobj.VouchsTableName, vouchobj.VouchsRelationVouchFieldName, vouchobj.VouchId]);
  strVouchsSql := Format('select * from %s where %s in (%s)', [vouchobj.SourceVouchTableName, vouchobj.SourceVouchKeyFieldName, strVouchsSql_sub]);
  DM_Global.ExecSql(fdm_sub, strVouchsSql);
end;

procedure Tfrm_Rd01.fdm_SubAfterOpen(DataSet: TDataSet);
begin
  inherited;
  LinkGridToData_Sub.Columns.Clear;
  DM_Global.FormatGrid_byAD(vouchobj.SourceVouchTableName, '', fdm_Sub, LinkGridToData_Sub, True);
end;

procedure Tfrm_Rd01.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frm_Rd01 := nil;
end;

procedure Tfrm_Rd01.FormCreate(Sender: TObject);
begin
  inherited;
  ClearChildCtrl(lyt_Main, False);                                              //隐藏原控件
  TabControl1.ActiveTab := TabControl1.Tabs[0];
end;

procedure Tfrm_Rd01.FormShow(Sender: TObject);
begin
  inherited;
  if VouchObj.VouchId = '-' then
  begin
    fdm_Main.Append;
    fdm_Sub.EmptyDataSet;
    fdm_Detail.EmptyDataSet;
  end;
end;

procedure Tfrm_Rd01.InitData;
begin
inherited;
end;

procedure Tfrm_Rd01.RefreshData;
var
  strVouchSql: string;
begin
  inherited;
  if VouchObj.Prepared then
  begin
    //打开主表
    strVouchSql := Format('select * from %s where %s=''%s''', [VouchObj.VouchTableName, VouchObj.VouchKeyFieldName, VouchObj.VouchId]);
    DM_Global.ExecSql(fdm_Main, strVouchSql);
    CreateADCtrl(VouchObj.VouchTableName, lyt_Main, fdm_Main, BindSourceDB_Main);
  end;
end;

procedure Tfrm_Rd01.SearchEditButton1Click(Sender: TObject);
var
  cmd: string;
begin
  FQRCode := edt_QRCode.Text;
  cmd := Trim(GetValueByKey(FQRCode, 'c'));
  if SameText(cmd, 'A') = true then
  begin
    if (fdm_Detail.State in [dsEdit, dsInsert]) then
    begin
      fdm_Detail.Post;
    end
    else
    begin
      fdm_Detail.Append;
    end
  end;
  if SameText(cmd, 'P') = true then
  begin
    Default_cPosition := Trim(GetValueByKey(FQRCode, 'pos'));
  end;
end;

procedure Tfrm_Rd01.setDefaulPosition(Value: string);
begin
  FDefault_cPosition := Value;
  lblPosition.Text := Format('当前货位:%s', [Value])
end;

function Tfrm_Rd01.GetPostXML(): string;
var
  FXmlDoc: TXMLDocument;
  LoopInt, tmpInt: Integer;
  ndVouchHead, tmpListRootNode, ndVouchBody: IXMLNode;
  bkm_Detail: TBookmark;

  procedure WriteChildNodeByDataSet(xmlDoc: TXMLDocument; nsParent: IXMLNode; dstSource: TDataSet; strNodeName, strFieldName: string);
  var
    ndTmp: IXMLNode;
    fdTmp: TField;
  begin
    strFieldName := Trim(strFieldName);
    fdTmp := dstSource.Fields.FindField(strFieldName);

    if fdTmp = nil then
    begin
      ShowMessage(format('%s表生成提交soap所需要的XML时错误，未发现字段%s', [vouchobj.VouchTableName, strFieldName]));
      Abort;
    end;
    if dstSource.FieldByName(strFieldName).AsString = '' then
    begin
      ShowMessage(format('%s表提交soap生成XML时错误，字段%s内容为空', [vouchobj.VouchTableName, strFieldName]));
      Abort;
    end;
    ndTmp := xmlDoc.CreateNode(strNodeName);
    nsParent.ChildNodes.Add(ndTmp);
    ndTmp.Text := dstSource.FieldByName(strFieldName).AsString;
  end;

begin
  try

    FXmlDoc := TXMLDocument.Create(Self);
    FXmlDoc.Active := True;
    FXmlDoc.Version := '1.0';
    FXmlDoc.Encoding := 'UTF-8';  //加入版本信息 ‘<?xml version="1.0" encoding="GB2312" ?> ’

    //表头
    ndVouchHead := FXmlDoc.CreateNode('XPurchaseInInfo');  //主单根结点
    FXmlDoc.DocumentElement := ndVouchHead;

    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cCode', 'cOrderCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cOrderCode', 'cOrderCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cARVCode', 'cARVCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'ipurarriveid', 'ipurarriveid');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'dDate', 'dDate');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cWhCode', 'cWhCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cVenCode', 'cVenCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMemo', 'cMemo');
//    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cWhName', 'cWhName');

    //表体
    ndVouchBody := FXmlDoc.CreateNode('XPurchaseInsInfos');        //子表根结点
    ndVouchHead.ChildNodes.Add(ndVouchBody);

    bkm_Detail := fdm_Detail.GetBookmark;
    fdm_Detail.DisableControls;
    fdm_Detail.First;
    while not fdm_Detail.Eof do
    begin
      WriteChildNodeByDataSet(FXmlDoc, ndVouchBody, fdm_Detail, 'cInvCode', 'cInvCode');
      WriteChildNodeByDataSet(FXmlDoc, ndVouchBody, fdm_Detail, 'iQuantity', 'iQuantity');
      WriteChildNodeByDataSet(FXmlDoc, ndVouchBody, fdm_Detail, 'cBatch', 'cBatch');
      WriteChildNodeByDataSet(FXmlDoc, ndVouchBody, fdm_Detail, 'cPosition', 'cPosition');
      WriteChildNodeByDataSet(FXmlDoc, ndVouchBody, fdm_Detail, 'iPOsID', 'iPOsID');
      WriteChildNodeByDataSet(FXmlDoc, ndVouchBody, fdm_Detail, 'iArrsId', 'iArrsId');
      fdm_Detail.Next;
    end;
    fdm_Detail.Bookmark := bkm_Detail;
    fdm_Detail.EnableControls;
    Result := FXmlDoc.XML.Text;
  finally
    FXmlDoc.Active := False;
    FXmlDoc.Free;
  end;
end;

procedure Tfrm_Rd01.GroupDetails;
begin

end;

end.

