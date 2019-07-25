unit Udelivery;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  BaseForm, FMX.Ani, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, FMX.Edit,UnitLib,Soap.SOAPHTTPClient,OMOrderService,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.Grid, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.Bind.DBScope,System.StrUtils,UnitBaseFun,MaterialOutService,
  FMX.TMSLiveGridDataBinding, FMX.TMSBaseControl, FMX.TMSGridCell,
  FMX.TMSGridOptions, FMX.TMSGridData, FMX.TMSCustomGrid, FMX.TMSLiveGrid;

type
  Tfrm_delivery = class(TBaseFrm)
    btn_Save: TButton;
    VertScrollBox1: TVertScrollBox;
    Layout1: TLayout;
    DetailLay: TLayout;
    BillCodeLay: TLayout;
    edt_QRCode: TEdit;
    ClearEditButton1: TClearEditButton;
    SearchEditButton1: TSearchEditButton;
    txt_QRCodeLabe: TText;
    StringGrid_OrderDetail: TStringGrid;
    StringGrid_StockDetail: TStringGrid;
    Text2: TText;
    BindingsList1: TBindingsList;
    FD_StockDetail: TFDMemTable;
    BSD_StockDetail: TBindSourceDB;
    LinkGridToDataSourceBSD_OrderDetail: TLinkGridToDataSource;
    LinkGridToDataSourceBSD_StockDetail: TLinkGridToDataSource;
    FD_MaterialDetailOutBill: TFDMemTable;
    FD_MaterialSubOutBill: TFDMemTable;
    FD_StockDetailcInvCode: TWideStringField;
    FD_StockDetailcInvName: TWideStringField;
    FD_StockDetailcBatch: TWideStringField;
    FD_StockDetailcWhName: TWideStringField;
    FD_StockDetailiQuantity: TFMTBCDField;
    FD_StockDetaildDate: TSQLTimeStampField;
    FD_MaterialSubOutBillcCode: TWideStringField;
    FD_MaterialSubOutBilldDate: TSQLTimeStampField;
    FD_MaterialSubOutBillcWhCode: TWideStringField;
    FD_MaterialSubOutBillcWhName: TWideStringField;
    FD_MaterialSubOutBillcMemo: TWideStringField;
    FD_MaterialSubOutBillcDepCode: TWideStringField;
    FD_MaterialSubOutBillcMaker: TWideStringField;
    FD_MaterialSubOutBillcrdcode: TWideStringField;
    FD_MaterialSubOutBillcMPoCode: TWideStringField;
    FD_MaterialDetailOutBillcInvCode: TWideStringField;
    FD_MaterialDetailOutBillcInvName: TWideStringField;
    FD_MaterialDetailOutBillcBatch: TWideStringField;
    FD_MaterialDetailOutBilliMPoIds: TIntegerField;
    FD_MaterialDetailOutBillcmocode: TWideStringField;
    FD_MaterialDetailOutBillimoseq: TWideStringField;
    FD_MaterialDetailOutBilliQuantity: TFMTBCDField;
    FD_MaterialDetailOutBilliUnitCost: TFMTBCDField;
    FD_MaterialDetailOutBilliPrice: TFMTBCDField;
    Text1: TText;
    Layout2: TLayout;
    Edit1: TEdit;
    ClearEditButton2: TClearEditButton;
    SearchEditButton2: TSearchEditButton;
    Text3: TText;
    FD_StockDetailcWhCode: TWideStringField;
    FD_OrderDetailDelivery: TFDMemTable;
    WideStringField1: TWideStringField;
    WideStringField2: TWideStringField;
    FMTBCDField1: TFMTBCDField;
    FMTBCDField2: TFMTBCDField;
    FMTBCDField3: TFMTBCDField;
    FMTBCDField4: TFMTBCDField;
    BSD_OrderDetailDelivery: TBindSourceDB;
    TMSFMXLiveGrid1: TTMSFMXLiveGrid;
    LinkGridToDataSourceBSD_OrderDetailDelivery: TLinkGridToDataSource;
    TMSFMXLiveGrid2: TTMSFMXLiveGrid;
    LinkGridToDataSourceBSD_StockDetail2: TLinkGridToDataSource;
    procedure SearchEditButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FD_MaterialDetailOutBillAfterInsert(DataSet: TDataSet);
    procedure FD_MaterialSubOutBillAfterInsert(DataSet: TDataSet);
    procedure FD_OrderDetailDeliveryAfterPost(DataSet: TDataSet);
    procedure TMSFMXLiveGrid1CellClick(Sender: TObject; ACol, ARow: Integer);
  private
    { Private declarations }
    FQRCode,MoDid,cBatch,MoCode: string;
    Service_Data: OMOrderServiceSoap;
    tmpHTTPRIO: THTTPRIO;
    function ClickOneOrder(orderStr:string):string;
    procedure saveBill;
    function checkSaveData:Boolean;override;
    function getQty(tempCurrentQty:string=''):Double;
  protected
    procedure InitData; override;
  public
    { Public declarations }
  end;

var
  frm_delivery: Tfrm_delivery;

implementation

{$R *.fmx}

procedure Tfrm_delivery.saveBill;
var
  tmpHTTPRIO: THTTPRIO;
  Service_Data: MaterialOutServiceSoap;
  strReturn, strPostXML: string;
begin
  if not checkSaveData then
  begin
    Exit;
  end;
  try
    try
      strPostXML := GetPostXML('XMaterialOutInfo',FD_MaterialSubOutBill,'XMaterialOutsInfos','XMaterialOutsInfo',FD_MaterialDetailOutBill);
      tmpHTTPRIO := THTTPRIO.Create(Nil);
      Service_Data := GetMaterialOutServiceSoap(False, AppServer + Const_Url_Def_OutOrder, tmpHTTPRIO);
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
function Tfrm_delivery.checkSaveData:Boolean;
begin
   inherited;
   result:=True;
end;
function Tfrm_delivery.ClickOneOrder(orderStr:string):string;
var
  cmd,FListTableName,ordersql: string;
  tempMemtable:TFDMemTable;
begin
       //获取对应的子件信息
    FD_MaterialSubOutBill.Close;
    FD_MaterialSubOutBill.Open;
    FListTableName:='WssBC_V_ProduceOrderPart';
    MoDid:= Trim(GetValueByKey(orderStr, 'MoDId'));
    cBatch:= Trim(GetValueByKey(orderStr, 'cBatch'));
    MoCode:= Trim(GetValueByKey(orderStr, 'cBatch'));
    ordersql:=Format('select * from %s where MoDid=''%s''  ', [FListTableName,MoDid,cBatch]);
    //and cBatch=''%s''
    try
      tempMemtable:= TFDMemTable.Create(Self);
      DM_Global.ExecSql(tempMemtable, ordersql);
      copyDataset(tempMemtable,FD_OrderDetailDelivery);
    finally
       tempMemtable.Free;
    end;


end;
procedure Tfrm_delivery.FD_MaterialDetailOutBillAfterInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('cmocode').Value :=  MoCode;
  DataSet.FieldByName('cInvCode').Value := FD_OrderDetailDelivery.FieldByName('cInvCode').Value;
  DataSet.FieldByName('cInvName').Value := FD_OrderDetailDelivery.FieldByName('cInvName').Value;
  DataSet.FieldByName('iQuantity').Value:=FD_OrderDetailDelivery.FieldByName('currentQty').Value;    //本次领料数量
  DataSet.FieldByName('iMPoIds').Value:=MoDid;
  DataSet.FieldByName('cBatch').Value:=cBatch;
end;

procedure Tfrm_delivery.FD_MaterialSubOutBillAfterInsert(DataSet: TDataSet);
begin
  inherited;
//   	dDate			日期
//	cWhCode			仓库编码
//	cWhName			仓库名称



  //MoCode=MO2017120001;MoDId=1000158158;cInvCode=1SG-20012;cBatch=MO2017120001-1;iQty=300
  DataSet.FieldByName('dDate').Value :=  FD_StockDetail.FieldByName('dDate').Value;
  DataSet.FieldByName('cWhCode').AsString := FD_StockDetail.FieldByName('cWhCode').Value;
  DataSet.FieldByName('cWhName').Value := FD_StockDetail.FieldByName('cWhName').Value;

end;


procedure Tfrm_delivery.FD_OrderDetailDeliveryAfterPost(DataSet: TDataSet);
begin
  inherited;
  if  StrToFloatDef(DataSet.FieldByName('currentQty').AsString,0)>0  then
  begin
      if   getQty( DataSet.FieldByName('currentQty').asstring)=0 then
      begin
        Abort;
      end;
  end;
end;

function Tfrm_delivery.getQty(tempCurrentQty:string=''):Double;
var
  qty:Double;
begin
      FD_StockDetail.First;
     while not FD_StockDetail.Eof do
     begin
        qty:=qty+FD_StockDetail.FieldByName('iQuantity').AsFloat;
        FD_StockDetail.Next;
     end;
     if StrToFloatDef(tempCurrentQty,0)>qty  then
     begin
         Result:=0;
     end
     else
     begin
       if tempCurrentQty<>'' then
        begin
          Result:=StrToFloatDef(tempCurrentQty,0);
        end
        else
        begin
          Result:=qty;
        end;

       if FD_MaterialSubOutBill.RecordCount=0  then
       begin
         FD_MaterialSubOutBill.Append;
       end;

     end;
end;

procedure Tfrm_delivery.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  frm_delivery := nil;
end;

procedure Tfrm_delivery.FormShow(Sender: TObject);
var
    strVouchsSql, strVouchsSql_sub: string;
begin
  inherited;
  tmpHTTPRIO := THTTPRIO.Create(Nil);
  Service_Data := GetOMOrderServiceSoap(False, AppServer + Const_Url_Def_OutOrder, tmpHTTPRIO);
//  LinkGridToDataSourceBSD_OrderDetail.Columns.Clear;
//  strVouchsSql := Format('select * from %s where %s=''%s''', [VouchObj.VouchsTableName, VouchObj.VouchsKeyFieldName, VouchObj.VouchId]);
//  DM_Global.ExecSql(FD_OrderDetail, strVouchsSql);
//  DM_Global.FormatGrid_byAD(VouchObj.VouchsTableName, '', FD_OrderDetail, LinkGridToDataSourceBSD_OrderDetail);
//  if VouchObj.VouchId = '-' then
//  begin
//    FD_OrderDetail.EmptyDataSet;
//    FD_StockDetail.EmptyDataSet;
//  end;
end;

procedure Tfrm_delivery.InitData;
begin
  inherited;
//  iniFdmemtable(FD_OrderDetail);
  iniFdmemtable(FD_OrderDetailDelivery);
  iniFdmemtable(FD_MaterialDetailOutBill);
  iniFdmemtable(FD_MaterialSubOutBill);
end;

procedure Tfrm_delivery.SearchEditButton1Click(Sender: TObject);
var
  cmd: string;
begin

  ClickOneOrder(edt_QRCode.Text);
end;

procedure Tfrm_delivery.TMSFMXLiveGrid1CellClick(Sender: TObject; ACol,
  ARow: Integer);
  var
  materialsql,cInvCode:string;
  qty:Double;
begin
  inherited;
  cInvCode:=Trim(FD_OrderDetailDelivery.FieldByName('cInvCode').AsString);
  materialsql:=Format('select distinct  b.cInvCode,b.cInvName,a.cBatch,c.cInvCCode,c.cWhCode,c.cWhName,c.iQuantity,a.dDate from WssBC_V_ProduceOrderPart b left join WssBC_V_CurrentStock  c on b.cInvCode=c.cInvCode '+
  'left join WssBC_V_Inv_BatchDate a  on a.cInvCode=c.cInvCode and a.cBatch=c.cBatch  where b.MoDid=''%s'' and b.cInvCode=''%s''  order by a.dDate desc',[MoDid,cInvCode]);
  DM_Global.ExecSql(FD_StockDetail, materialsql);
  FD_OrderDetailDelivery.Edit;
  FD_OrderDetailDelivery.FieldByName('currentQty').AsFloat:=getQty;
  FD_MaterialDetailOutBill.Append;
end;

end.
