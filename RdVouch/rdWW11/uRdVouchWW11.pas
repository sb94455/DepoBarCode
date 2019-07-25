unit uRdVouchWW11;

interface

uses System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  StrUtils,
  Xml.XMLDoc,
  Xml.XMLIntf,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  Soap.SOAPHTTPClient,
  BaseForm,
  FMX.Layouts,
  FMX.DateTimeCtrls,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Ani,
  FMX.ListBox,
  FMX.Edit,
  FMX.ScrollBox,
  FMX.Memo,
  System.Rtti,
  MaterialOutService,
  FMX.Grid.Style,
  FMX.Grid,
  UnitLib,
  WareHouseForm,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  Data.Bind.Components,
  Data.Bind.DBScope,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  FMX.Bind.Grid,
  Data.Bind.Grid,
  FMX.TabControl;

type
  Tfrm_RdVouchWW11 = class(TBaseFrm)
    DetailLay: TLayout;
    BillCodeLay: TLayout;
    edt_QRCode: TEdit;
    btn_Save: TButton;
    fdm_Main: TFDMemTable;
    fdm_Sub: TFDMemTable;
    fdm_Detail: TFDMemTable;
    BindSourceDB_Main: TBindSourceDB;
    BindingsList1: TBindingsList;
    lyt_Main: TLayout;
    ClearEditButton1: TClearEditButton;
    BindSourceDB_Detail: TBindSourceDB;
    BindSourceDB_Sub: TBindSourceDB;
    TabControl1: TTabControl;
    Tab_Sub: TTabItem;
    Tab_Detail: TTabItem;
    LinkGridToData_Sub: TLinkGridToDataSource;
    StringGrid_Sub: TStringGrid;
    StringGrid_Detail: TStringGrid;
    LinkGridToData_Detail: TLinkGridToDataSource;
    btn_ClearDetail: TButton;
    lbl_txt_QRCodeLabe: TLabel;
    EllipsesEditButton1: TEllipsesEditButton;
    TabItem1: TTabItem;
    Memo1: TMemo;
    cbRed: TCheckBox;
    fdm_SubDetail: TFDMemTable;
    StringGrid_SubDetail: TStringGrid;
    BindSourceDB_SubDetail: TBindSourceDB;
    LinkGridToData_SubDetail: TLinkGridToDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fdm_MainAfterOpen(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure btn_SaveClick(Sender: TObject);
    procedure fdm_SubAfterOpen(DataSet: TDataSet);
    procedure fdm_DetailAfterOpen(DataSet: TDataSet);
    procedure fdm_DetailAfterPost(DataSet: TDataSet);
    procedure fdm_MainAfterInsert(DataSet: TDataSet);
    procedure fdm_MainBeforePost(DataSet: TDataSet);
    procedure fdm_DetailBeforePost(DataSet: TDataSet);
    procedure btn_ClearDetailClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure cbRedClick(Sender: TObject);
    procedure fdm_SubDetailAfterOpen(DataSet: TDataSet);
    procedure StringGrid_SubCellDblClick(const Column: TColumn;
      const Row: Integer);

  private
    { Private declarations }
    dosub     : Boolean;
    FVouchObj : TSZHL_Vouch;
    FRdFlag   : Boolean;
    FQRCode   : string;
    FPosition : string;
    fdm_append: TFDMemTable;
    // FcWhCode: string;
    function GetPostXML(): string;
    procedure DecryptQRCode;
    procedure setDefaulPosition(Value: string);
    function GetcWhCode: string;
    procedure ShowSubDetail;
  protected
  public
    procedure InitData; override;
    procedure RefreshData; override;
    property Position: string read FPosition write setDefaulPosition;
    property cWhCode: string read GetcWhCode;
    property QRCode: string read FQRCode write FQRCode;
    property VouObj: TSZHL_Vouch read FVouchObj write FVouchObj;
    property RdFlag: Boolean read FRdFlag write FRdFlag;
  end;

var
  frm_RdVouchWW11: Tfrm_RdVouchWW11;

implementation

{$R *.fmx}

uses UnitU8DM;

procedure Tfrm_RdVouchWW11.btn_ClearDetailClick(Sender: TObject);
begin
  if fdm_Main.State in [dsInsert, dsEdit] then
    fdm_Main.Cancel;
  ClearChildCtrl(lyt_Main, true); // 清空&显示/隐藏
  fdm_Main.Append;
  fdm_Detail.EmptyDataSet;
  fdm_Sub.EmptyDataSet;
end;

procedure Tfrm_RdVouchWW11.btn_SaveClick(Sender: TObject);
  procedure HttpPost();
  var
    tmpHTTPRIO           : THTTPRIO;
    Service_Data         : MaterialOutServiceSoap;
    strReturn, strPostXML: string;
  begin
    try
      if Memo1.Text.Trim.IsEmpty then
        Memo1.Text := GetPostXML();
      Service_Data := GetMaterialOutServiceSoap(False, PubVar_WebServiceUrl + Const_Url_Def_MaterialOut, tmpHTTPRIO);
      strReturn := Service_Data.InsertOut(Memo1.Text.Trim);

      if not SameText(strReturn, 'OK') then
      begin
        showmessage(format('单据%s保存失败.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));
      end
      else
        showmessage(format('单据%s保存成功.'#10#13'%s', [fdm_Main.FieldByName('cCode').AsString, strReturn]));

    except
      on E: Exception do
      begin
        showmessage(E.Message);
      end;
    end;

  end;

begin
  inherited;
  if fdm_Main.State in [dsEdit, dsInsert] then
    fdm_Main.Post;
  if fdm_Detail.State in [dsEdit, dsInsert] then
    fdm_Detail.Post;
  HttpPost;
end;

procedure Tfrm_RdVouchWW11.cbRedClick(Sender: TObject);
begin
  if cbRed.IsChecked = false then
    VouObj.VouchArrow := vhRed
  else
    VouObj.VouchArrow := vhBlue;

end;

procedure Tfrm_RdVouchWW11.DecryptQRCode;
var
  cmd, strVouchsSql, strDesInvCode: string;
  fdm_Ref  ,fdm_Detail_Copy       : TFDMemTable;
  SubQty, SubQtyRmt, SubQtyAmt,iQuantity,copyQty   : double;
  SN : Integer;
  label loopstart;
  label loopstart1;
  label loopstart2;

  function GetSourceVouchKeyValue(): string;
  begin
    Result := GetValueByKey(FQRCode, FVouchObj.SrcKeyField);
  end;

begin
  FQRCode := edt_QRCode.Text;

  cmd := Trim(GetValueByKey(FQRCode, 'c'));
  if SameText(cmd, 'W') = True then
  begin
    fdm_Main.FieldByName('cWhCode').Value := Trim(GetValueByKey(FQRCode, 'cWhCode'));
    edt_QRCode.Text := '';
  end;
  if SameText(cmd, 'P') = True then
  begin
    Position := Trim(GetValueByKey(FQRCode, 'cPosition'));
    edt_QRCode.Text := '';
  end;
  if SameText(cmd, 'S') = True then // 来源，暂时只允许一个单据来源，且不允许物料重复。
  begin
    if fdm_append = nil then
      fdm_append := TFDMemTable.Create(nil);
    if fdm_Sub.RecordCount > 0 then
      exit;

    //strVouchsSql := format('select *,0.00 as %s  from %s where %s = (''%s'')', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable,
    //  FVouchObj.SrcLinkMainField, GetValueByKey(FQRCode, VouObj.SrcLinkMainField)]);
    strVouchsSql := format('select *,0.00 as %s  from %s where %s = (''%s'') order by cInvCode,MOMaterialsID', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, 'cCode',
      GetValueByKey(FQRCode, 'cCode')]);
    DM_Global.ExecSql(fdm_append, strVouchsSql);
    fdm_Sub.AppendData(fdm_append);
    if fdm_Sub.RecordCount > 0 then
      if fdm_Main.State in [dsInsert, dsEdit] then
        if fdm_Main.FieldByName('cDepCode').AsString.Trim = '' then
        begin
          fdm_Main.FieldByName('cDepCode').Value := fdm_append.FieldByName('cDepCode').AsString.Trim;
          fdm_Main.FieldByName('cVenCode').Value := fdm_append.FieldByName('cVenCode').AsString.Trim;
          fdm_Main.FieldByName('cPsPcode').Value := fdm_append.FieldByName('InvCode').AsString.Trim;
          fdm_Main.FieldByName('cMPoCode').Value := fdm_append.FieldByName('cCode').AsString.Trim;
          fdm_Main.FieldByName('iproorderid').Value := fdm_append.FieldByName('MOID').AsString.Trim;
        end;
    showsubdetail;
    edt_QRCode.Text := '';
  end;

  if SameText(cmd, 'A') = true then
  begin
    SN := StrToInt(GetValueByKey(FQRCode,'SN'));              //获取条码信息
    strDesInvCode := GetValueByKey(FQRCode,'cInvCode');
//    ID := StrToInt(GetValueByKey(FQRCode,'VouchId'));
//    AutoId := StrToInt(GetValueByKey(FQRCode,'VouchsId'));
    iQuantity := strToFloat(GetValueByKey(FQRCode,'iQuantity'));

    if (fdm_Detail.State in [dsEdit, dsInsert]) then
    begin
      fdm_Detail.Post;
    end;
    if fdm_detail.Locate('cDefine33;cInvCode', VarArrayOf([SN,strDesInvCode]), [loPartialKey]) then
    begin
      showmessage('不允许重复扫码。');
      Abort;
    end;
    if fdm_Main.FieldByName('cWhCode').AsString.Trim.IsEmpty then
    begin
      showmessage('请选择仓库后再试。');
      Abort;
    end;
//    if DM_Global.CheckSnUsed('11', GetValueByKey(FQRCode, 'SN')) then //与数据库已有比对，按单据类型
//    begin
//      showmessage('该条码已经使用，不允许重复扫码。');
//      Abort;
//    end;
    fdm_Detail_Copy := TFDMemTable.Create(nil);        //创建中间表，根据条码信息同时更新fdm_sub和fdm_subdetail时使用
    fdm_Detail_Copy.FieldDefs := fdm_detail.FieldDefs;
    fdm_Detail_Copy.CreateDataSet;
    if VouObj.VouchArrow = vhBlue then
    begin

      if fdm_Sub.Locate('cInvCode', VarArrayOf([strDesInvCode]), [loPartialKey]) then    //定位条码物料的第一行
      begin
        loopstart:
        if fdm_sub.FieldByName('cInvCode').AsString = strDesInvCode then
        begin
          SubQty := fdm_Sub.FieldByName(VouObj.SrcQtyField).AsFloat;                  //成品总量
          SubQtyRmt := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat;       //成品已入库量
          SubQtyAmt := SubQty - SubQtyRmt;
          if SubQtyAmt = 0 then
          begin
            fdm_sub.Next;
            goto loopstart;
          end
          else if iQuantity > SubQtyAmt then
          begin
            fdm_Detail_Copy.Append;
            fdm_Detail_Copy.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdm_Sub.FieldByName(VouObj.SrcLinkDesSubField).AsString;
            fdm_Detail_Copy.FieldByName('cDefine33').Value := GetValueByKey(FQRCode, 'SN');
            fdm_Detail_Copy.FieldByName('iQuantity').Value := SubQtyAmt;
            fdm_Detail_Copy.FieldByName('cBatch').Value := GetValueByKey(FQRCode, 'cBatch');
            fdm_Detail_Copy.FieldByName('cPosition').Value := Position;
            fdm_Detail_Copy.FieldByName('cInvCode').Value := strDesInvCode;
            fdm_Detail_Copy.FieldByName('iOMoDID').Value := fdm_Sub.FieldByName('MODetailsID').Value;
            fdm_Detail_Copy.FieldByName('iOMoMID').Value := fdm_Sub.FieldByName('MOMaterialsID').Value;
            fdm_Detail_Copy.FieldByName('ipesodid').Value := fdm_Sub.FieldByName('MOMaterialsID').Value;
            fdm_Detail_Copy.FieldByName('cpesocode').Value := fdm_Sub.FieldByName('cCode').Value;
            fdm_Detail_Copy.FieldByName('comcode').Value := fdm_Sub.FieldByName('cCode').AsString.Trim;
            fdm_Detail_Copy.FieldByName('invcode').Value := fdm_Sub.FieldByName('InvCode').AsString.Trim;
            fdm_Detail_Copy.FieldByName('iNQuantity').Value := fdm_Sub.FieldByName('iQuantity').AsString.Trim;
            // fdm_Detail.FieldByName('cpesocode').Value := fdm_append.FieldByName('cCode').AsString.Trim;
            // fdm_Detail.FieldByName('ipesodid').Value := fdm_append.FieldByName('MODetailsID').AsString.Trim;
            fdm_Detail_Copy.FieldByName('iUnitCost').Value := 0; // XML不能为空
            fdm_Detail_Copy.FieldByName('iPrice').Value := 0; // XML不能为空
            fdm_Detail_Copy.Post;

//            fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat + fdm_Detail_Copy.FieldByName(VouObj.DesSubQtyField).AsFloat;
//            fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat - fdm_Detail_Copy.FieldByName(VouObj.DesSubQtyField).AsFloat;
//            //fdm_Sub.FieldByName(VouObj.SrcQtyField).AsFloat := fdm_Sub.FieldByName(VouObj.SrcQtyField).AsFloat - fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
//            fdm_sub.FieldByName('NowQty').Value := fdm_sub.FieldByName('NowQty').Value +  fdm_Detail_Copy.FieldByName(VouObj.DesSubQtyField).AsFloat;
//            fdm_sub.Post;
            iQuantity := iQuantity - SubQtyAmt;
            fdm_sub.Next;
            goto loopstart;
          end
          else
          begin
            fdm_Detail_Copy.Append;
            fdm_Detail_Copy.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdm_Sub.FieldByName(VouObj.SrcLinkDesSubField).AsString;
            fdm_Detail_Copy.FieldByName('cDefine33').Value := GetValueByKey(FQRCode, 'SN');
            fdm_Detail_Copy.FieldByName('iQuantity').Value := iQuantity;
            fdm_Detail_Copy.FieldByName('cBatch').Value := GetValueByKey(FQRCode, 'cBatch');
            fdm_Detail_Copy.FieldByName('cPosition').Value := Position;
            fdm_Detail_Copy.FieldByName('cInvCode').Value := strDesInvCode;
            fdm_Detail_Copy.FieldByName('iOMoDID').Value := fdm_Sub.FieldByName('MODetailsID').Value;
            fdm_Detail_Copy.FieldByName('iOMoMID').Value := fdm_Sub.FieldByName('MOMaterialsID').Value;
            fdm_Detail_Copy.FieldByName('ipesodid').Value := fdm_Sub.FieldByName('MOMaterialsID').Value;
            fdm_Detail_Copy.FieldByName('cpesocode').Value := fdm_Sub.FieldByName('cCode').Value;
            fdm_Detail_Copy.FieldByName('comcode').Value := fdm_Sub.FieldByName('cCode').AsString.Trim;
            fdm_Detail_Copy.FieldByName('invcode').Value := fdm_Sub.FieldByName('InvCode').AsString.Trim;
            fdm_Detail_Copy.FieldByName('iNQuantity').Value := fdm_Sub.FieldByName('iQuantity').AsString.Trim;
            // fdm_Detail.FieldByName('cpesocode').Value := fdm_append.FieldByName('cCode').AsString.Trim;
            // fdm_Detail.FieldByName('ipesodid').Value := fdm_append.FieldByName('MODetailsID').AsString.Trim;
            fdm_Detail_Copy.FieldByName('iUnitCost').Value := 0; // XML不能为空
            fdm_Detail_Copy.FieldByName('iPrice').Value := 0; // XML不能为空
            fdm_Detail_Copy.Post;
//            fdm_sub.Edit;
//            fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat + fdm_Detail_Copy.FieldByName(VouObj.DesSubQtyField).AsFloat;
//            fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat - fdm_Detail_Copy.FieldByName(VouObj.DesSubQtyField).AsFloat;
//            //fdm_Sub.FieldByName(VouObj.SrcQtyField).AsFloat := fdm_Sub.FieldByName(VouObj.SrcQtyField).AsFloat - fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
//            fdm_sub.FieldByName('NowQty').Value := fdm_sub.FieldByName('NowQty').Value +  fdm_Detail_Copy.FieldByName(VouObj.DesSubQtyField).AsFloat;
//            fdm_sub.Post;
          end
        end;
        fdm_Detail_Copy.First;
        while not fdm_detail_copy.Eof do
        begin
          copyQty := fdm_Detail_Copy.FieldByName('iQuantity').AsFloat;
          fdm_subdetail.First;
          loopstart1:

          while not fdm_subdetail.Eof do
          begin

            if (fdm_subdetail.FieldByName('cInvCode').AsString = fdm_detail_copy.FieldByName('cInvCode').AsString) and
               (fdm_subdetail.FieldByName('cWhCode').AsString = fdm_main.FieldByName('cWhCode').AsString)  then
            begin
              if fdm_subdetail.FieldByName('iQuantity').AsFloat = fdm_subdetail.FieldByName('iQuantity_Amt').AsFloat then
              begin
                fdm_subdetail.Next;
                continue;
              end
              else if copyQty > (fdm_subdetail.FieldByName('iQuantity').AsFloat - fdm_subdetail.FieldByName('iQuantity_Amt').AsFloat) then
              begin
                fdm_Detail.Append;
                fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdm_Detail_Copy.FieldByName(VouObj.DesSubLinkSrcFeild).AsString;
                fdm_Detail.FieldByName('cDefine33').Value := fdm_Detail_Copy.FieldByName('cDefine33').Value;
                fdm_Detail.FieldByName('iQuantity').Value := fdm_subdetail.FieldByName('iQuantity').AsFloat - fdm_subdetail.FieldByName('iQuantity_Amt').AsFloat;
                fdm_Detail.FieldByName('cBatch').Value := fdm_subDetail.FieldByName('cBatch').Value;
                fdm_Detail.FieldByName('cPosition').Value := fdm_subDetail.FieldByName('cPosCode').Value;
                fdm_Detail.FieldByName('cInvCode').Value := fdm_Detail_copy.FieldByName('cInvCode').Value;
                fdm_Detail.FieldByName('iOMoDID').Value := fdm_Detail_Copy.FieldByName('iOMoDID').Value;
                fdm_Detail.FieldByName('iOMoMID').Value := fdm_Detail_Copy.FieldByName('iOMoMID').Value ;
                fdm_Detail.FieldByName('ipesodid').Value := fdm_Detail_Copy.FieldByName('ipesodid').Value;
                fdm_Detail.FieldByName('cpesocode').Value := fdm_Detail_Copy.FieldByName('cpesocode').Value;
                fdm_Detail.FieldByName('comcode').Value := fdm_Detail_Copy.FieldByName('comcode').Value;
                fdm_Detail.FieldByName('invcode').Value := fdm_Detail_Copy.FieldByName('invcode').Value;
                fdm_Detail.FieldByName('iNQuantity').Value := fdm_Detail_Copy.FieldByName('iNQuantity').Value ;
                // fdm_Detail.FieldByName('cpesocode').Value := fdm_append.FieldByName('cCode').AsString.Trim;
                // fdm_Detail.FieldByName('ipesodid').Value := fdm_append.FieldByName('MODetailsID').AsString.Trim;
                fdm_Detail.FieldByName('iUnitCost').Value := 0; // XML不能为空
                fdm_Detail.FieldByName('iPrice').Value := 0; // XML不能为空
                fdm_Detail.Post;
                copyQty := copyQty - (fdm_subdetail.FieldByName('iQuantity').AsFloat - fdm_subdetail.FieldByName('iQuantity_Amt').AsFloat) ;
                fdm_subdetail.Edit;
                fdm_subDetail.FieldByName('iQuantity_Amt').Value := fdm_subDetail.FieldByName('iQuantity_Amt').Value + fdm_Detail.FieldByName('iQuantity').Value;
                fdm_subdetail.Post;

                fdm_subdetail.Next;
                goto loopstart1;
              end
              else
              begin
                fdm_Detail.Append;
                fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdm_Detail_Copy.FieldByName(VouObj.DesSubLinkSrcFeild).AsString;
                fdm_Detail.FieldByName('cDefine33').Value := fdm_Detail_Copy.FieldByName('cDefine33').Value;
                fdm_Detail.FieldByName('iQuantity').Value := copyQty;
                fdm_Detail.FieldByName('cBatch').Value := fdm_subDetail.FieldByName('cBatch').Value;
                fdm_Detail.FieldByName('cPosition').Value := fdm_subDetail.FieldByName('cPosCode').Value;
                fdm_Detail.FieldByName('cInvCode').Value := fdm_Detail_copy.FieldByName('cInvCode').Value;
                fdm_Detail.FieldByName('iOMoDID').Value := fdm_Detail_Copy.FieldByName('iOMoDID').Value;
                fdm_Detail.FieldByName('iOMoMID').Value := fdm_Detail_Copy.FieldByName('iOMoMID').Value;
                fdm_Detail.FieldByName('ipesodid').Value := fdm_Detail_Copy.FieldByName('ipesodid').Value;
                fdm_Detail.FieldByName('cpesocode').Value := fdm_Detail_Copy.FieldByName('cpesocode').Value;
                fdm_Detail.FieldByName('comcode').Value := fdm_Detail_Copy.FieldByName('comcode').Value;
                fdm_Detail.FieldByName('invcode').Value := fdm_Detail_Copy.FieldByName('invcode').Value;
                fdm_Detail.FieldByName('iNQuantity').Value := fdm_Detail_Copy.FieldByName('iNQuantity').Value;
                // fdm_Detail.FieldByName('cpesocode').Value := fdm_append.FieldByName('cCode').AsString.Trim;
                // fdm_Detail.FieldByName('ipesodid').Value := fdm_append.FieldByName('MODetailsID').AsString.Trim;
                fdm_Detail.FieldByName('iUnitCost').Value := 0; // XML不能为空
                fdm_Detail.FieldByName('iPrice').Value := 0; // XML不能为空
                fdm_Detail.Post;
                fdm_subdetail.Edit;
                fdm_subDetail.FieldByName('iQuantity_Amt').Value := fdm_subDetail.FieldByName('iQuantity_Amt').Value + fdm_Detail.FieldByName('iQuantity').Value;
                fdm_subdetail.Post;
                break;
              end

            end;
            fdm_subdetail.Next;
          end;
          fdm_detail_copy.Next;
        end;
        fdm_detail_copy.EmptyDataSet;    //释放临时内存表
        freeandnil(fdm_detail_copy);
      end
      else
      begin
        showmessage(format('物料%s不在来源单据范围。', [strDesInvCode]));
        Abort;
      end

    end;

    if VouObj.VouchArrow = vhRed then     //退料
    begin
      if fdm_Sub.Locate('cInvCode', VarArrayOf([strDesInvCode]), [loPartialKey]) then
      begin
        loopstart2:
        if fdm_sub.FieldByName('cInvCode').AsString = strDesInvCode  then
        begin
          SubQty := fdm_Sub.FieldByName(VouObj.SrcQtyField).AsFloat;
          SubQtyRmt := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat;
          SubQtyAmt := SubQty - SubQtyRmt;
          if SubQtyRmt = 0 then
          begin
            fdm_sub.Next;
            goto loopstart2;
          end
          else if iQuantity > SubQtyRmt then      //判断条码数量 是否小于等于 剩余量  是 则生成fdm_detail数据
          begin
            fdm_Detail.Append;
            fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdm_Sub.FieldByName(VouObj.SrcLinkDesSubField).AsString;
            fdm_Detail.FieldByName('cDefine33').Value := GetValueByKey(FQRCode, 'SN');
            fdm_Detail.FieldByName('iQuantity').Value := -1*SubQtyRmt;
            fdm_Detail.FieldByName('cBatch').Value := FormatDateTime('yyyymmdd',Date());
            fdm_Detail.FieldByName('cPosition').Value := Position;
            fdm_Detail.FieldByName('cInvCode').Value := strDesInvCode;
            fdm_Detail.FieldByName('iOMoDID').Value := fdm_Sub.FieldByName('MODetailsID').Value;
            fdm_Detail.FieldByName('iOMoMID').Value := fdm_Sub.FieldByName('MOMaterialsID').Value;
            fdm_Detail.FieldByName('ipesodid').Value := fdm_Sub.FieldByName('MOMaterialsID').Value;
            fdm_Detail.FieldByName('cpesocode').Value := fdm_Sub.FieldByName('cCode').Value;
            fdm_Detail.FieldByName('comcode').Value := fdm_Sub.FieldByName('cCode').AsString.Trim;
            fdm_Detail.FieldByName('invcode').Value := fdm_Sub.FieldByName('InvCode').AsString.Trim;
            fdm_Detail.FieldByName('iNQuantity').Value := fdm_Sub.FieldByName('iQuantity').AsString.Trim;
            // fdm_Detail.FieldByName('cpesocode').Value := fdm_append.FieldByName('cCode').AsString.Trim;
            // fdm_Detail.FieldByName('ipesodid').Value := fdm_append.FieldByName('MODetailsID').AsString.Trim;
            fdm_Detail.FieldByName('iUnitCost').Value := 0; // XML不能为空
            fdm_Detail.FieldByName('iPrice').Value := 0; // XML不能为空
            fdm_Detail.Post;
            iQuantity := iQuantity - SubQtyRmt;
            fdm_sub.Next;
            goto loopstart2;
          end
          else
          begin
            fdm_Detail.Append;
            fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString := fdm_Sub.FieldByName(VouObj.SrcLinkDesSubField).AsString;
            fdm_Detail.FieldByName('cDefine33').Value := GetValueByKey(FQRCode, 'SN');
            fdm_Detail.FieldByName('iQuantity').Value := -1*iQuantity;
            fdm_Detail.FieldByName('cBatch').Value := FormatDateTime('yyyymmdd',Date());
            fdm_Detail.FieldByName('cPosition').Value := Position;
            fdm_Detail.FieldByName('cInvCode').Value := strDesInvCode;
            fdm_Detail.FieldByName('iOMoDID').Value := fdm_Sub.FieldByName('MODetailsID').Value;
            fdm_Detail.FieldByName('iOMoMID').Value := fdm_Sub.FieldByName('MOMaterialsID').Value;
            fdm_Detail.FieldByName('ipesodid').Value := fdm_Sub.FieldByName('MOMaterialsID').Value;
            fdm_Detail.FieldByName('cpesocode').Value := fdm_Sub.FieldByName('cCode').Value;
            fdm_Detail.FieldByName('comcode').Value := fdm_Sub.FieldByName('cCode').AsString.Trim;
            fdm_Detail.FieldByName('invcode').Value := fdm_Sub.FieldByName('InvCode').AsString.Trim;
            fdm_Detail.FieldByName('iNQuantity').Value := fdm_Sub.FieldByName('iQuantity').AsString.Trim;
            // fdm_Detail.FieldByName('cpesocode').Value := fdm_append.FieldByName('cCode').AsString.Trim;
            // fdm_Detail.FieldByName('ipesodid').Value := fdm_append.FieldByName('MODetailsID').AsString.Trim;
            fdm_Detail.FieldByName('iUnitCost').Value := 0; // XML不能为空
            fdm_Detail.FieldByName('iPrice').Value := 0; // XML不能为空
            fdm_Detail.Post;
          end
        end;
      end
      else // 不在参照表的存货范围；
      begin
        showmessage(format('物料%s不在来源单据范围。', [strDesInvCode]));
        Abort;
      end
    end;
    edt_QRCode.Text := '';
  end;
end;

procedure Tfrm_RdVouchWW11.edt_QRCodeKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = 13 then
    try
      SZHL_ComboBoxSyncToDB(lyt_Main, fdm_Main);
      DecryptQRCode;
      edt_QRCode.SetFocus;
    finally
      DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
    end;
end;

procedure Tfrm_RdVouchWW11.fdm_DetailAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouchWW11.fdm_DetailAfterPost(DataSet: TDataSet);
begin
  inherited;
  RefreshData;
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouchWW11.fdm_DetailBeforePost(DataSet: TDataSet);
var
  strErrMsg: string;
begin
  inherited;
  strErrMsg := DM_Global.CheckAllowEmptys(DataSet, VouObj.DesSubTableDef);
  if strErrMsg <> '' then
  begin
    showmessage(strErrMsg);
    Abort;
  end;
  if cWhCode <> '' then
  begin
    // showmessage('请选择仓库');
    if DM_Global.CheckWareHousePos(cWhCode) = True then
    begin
      if DataSet.FieldByName('cposition').AsString = '' then
      begin
        showmessage('当前仓库有货位管理，请指定货位。');
        // exit;
      end;
    end;
  end;
  if DM_Global.CheckInvBatch(DataSet.FieldByName('cInvCode').AsString) = True then
  begin
    if DataSet.FieldByName('cBatch').AsString = '' then
    begin
      showmessage('当前存货有批次管理，请指定批次。');
      // exit;
    end;
  end
  else
    DataSet.FieldByName('cBatch').Value := ''; // 无批次管理清除批次。
end;

procedure Tfrm_RdVouchWW11.fdm_MainAfterInsert(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('dDate').Value := DateToStr(DATE());
  DataSet.FieldByName('cMaker').Value := PubVar_LoginInfo.UserName;
  DataSet.FieldByName('cBusType').Value := '委外发料';

end;

procedure Tfrm_RdVouchWW11.fdm_MainAfterOpen(DataSet: TDataSet);
var
  strVouchsSql, strVouchsSql_sub: string;
begin
  inherited;

  // 子表（来源展开）表 ,初次随表头打开，用来处理打开已经有的单据。
  LinkGridToData_Sub.Columns.Clear;
  strVouchsSql_sub := format('select %s from %s where %s =''%s''', [FVouchObj.DesSubLinkSrcFeild, FVouchObj.DesSubTable, FVouchObj.DesMainKeyField,
    FVouchObj.DesMainKey]);
  strVouchsSql := format('select *,0.00 %s from %s where %s in (%s)', [FVouchObj.SrcQty_AmtField, FVouchObj.SrcTable, FVouchObj.SrcLinkDesSubField,
    strVouchsSql_sub]);
  DM_Global.ExecSql(fdm_Sub, strVouchsSql);

  // 明细表
  LinkGridToData_Detail.Columns.Clear;
  strVouchsSql := format('select * from %s where %s=''%s''', [FVouchObj.DesSubTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  DM_Global.ExecSql(fdm_Detail, strVouchsSql);

end;

procedure Tfrm_RdVouchWW11.fdm_MainBeforePost(DataSet: TDataSet); // 保存前检查主表必输入项
var
  strErrMsg: string;
begin
  inherited;
  SZHL_ComboBoxSyncToDB(lyt_Main, fdm_Main);
  strErrMsg := DM_Global.CheckAllowEmptys(DataSet, VouObj.DesMainTableDef);
  if strErrMsg <> '' then
  begin
    showmessage(strErrMsg);
    Abort;
  end;

end;

procedure Tfrm_RdVouchWW11.fdm_SubAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, True);

end;



procedure Tfrm_RdVouchWW11.fdm_SubDetailAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DM_Global.FormatGrid_byAD('材料出库单参照生产订单用料表明细视图', '', fdm_SubDetail, LinkGridToData_SubDetail, true);
end;

procedure Tfrm_RdVouchWW11.ShowSubDetail;       //显示subdetail数据
var
  strVouchSql, strWhCode, strcInvCode: string;
begin
  strWhCode := fdm_Main.FieldByName('cWhCode').AsString.Trim;
  if strWhCode.IsEmpty = true then
  begin
    exit;
    showmessage('请选择仓库后重试');
  end;
  strcInvCode := fdm_Sub.FieldByName('cInvCode').AsString.Trim;
  strVouchSql := Format('select *  from InvPositionSum where 1=1 and cinvcode=''%s'' and cWhCode= ''%s'' order by cBatch ',[strcInvCode,strWhCode]);
  DM_Global.ExecSql(fdm_SubDetail, strVouchSql);
end;

procedure Tfrm_RdVouchWW11.StringGrid_SubCellDblClick(const Column: TColumn;
  const Row: Integer);
begin
  inherited;
  ShowSubDetail;
end;

procedure Tfrm_RdVouchWW11.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  frm_RdVouchWW11 := nil;
end;

procedure Tfrm_RdVouchWW11.FormCreate(Sender: TObject);
begin
  inherited;

  FRdFlag := True; // 默认正数(兰字)单据
  ClearChildCtrl(lyt_Main, False); // 隐藏原控件
  TabControl1.ActiveTab := TabControl1.Tabs[0]; // 默认页签
end;

procedure Tfrm_RdVouchWW11.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  inherited;
  if Key = vkF11 then
    edt_QRCode.Text := 'C=A;SN=10978;cPOID=0000000001;cCode=PR18020001;cInvCode=01-113-4003LR;Autoid=1000000001;cBatch=batch1;iQty=2';
end;

procedure Tfrm_RdVouchWW11.FormShow(Sender: TObject);
begin
  inherited;
  txt_BaseTitle.Text := VouObj.DesMainTableDef;

  TabItem1.Visible := False;
{$IFDEF DEBUG}
  Position := '18042';
  TabItem1.Visible := True;
{$ENDIF}
  if FVouchObj.DesMainKey.Trim <> '' then
  begin
    btn_Save.Visible := False;
    btn_ClearDetail.Visible := False;
    BillCodeLay.Visible := False;
    // fdm_Main.Append;
    // if fdm_Sub.Active = True then
    // fdm_Sub.EmptyDataSet;
    // fdm_Detail.EmptyDataSet;
  end;
  self.edt_QRCode.SetFocus;
end;

procedure Tfrm_RdVouchWW11.RefreshData; // 根据Detail汇总到Sub
var
  strVouchsSql: string;

  bkTmp: TBookmark;
begin
  inherited;
  if fdm_Detail.eof then
    exit;

  // 子表（来源展开）表 ,初次随表头打开，用来处理打开已经有的单据。
  bkTmp := fdm_Detail.Bookmark;
  fdm_Detail.DisableControls;
  // fdm_Sub.EmptyDataSet;
  fdm_Detail.last;
  //while not fdm_Detail.eof do
 // begin
    // if fdm_Sub.Locate(VouObj.SrcLinkDesSubField, VarArrayOf([Trim(fdm_Detail.FieldByName(VouObj.DesSubLinkSrcFeild).AsString)])) = False then
    // begin
    // try
    // fdm_Sub.AppendData(fdm_sub_append);
    // finally
    // fdm_sub_append.EmptyDataSet;
    // end;
    // end;
    if fdm_Sub.Locate('cInvCode', VarArrayOf([fdm_Detail.FieldByName('cInvCode').AsString.Trim])) = True then
    begin
      fdm_Sub.Edit;
      fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).Value := fdm_Sub.FieldByName(VouObj.SrcRmtQtyField).AsFloat +
        fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
      fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).Value := fdm_Sub.FieldByName(VouObj.SrcQty_AmtField).AsFloat -
        fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
      fdm_sub.FieldByName('NowQty').Value := fdm_sub.FieldByName('NowQty').Value +  fdm_Detail.FieldByName(VouObj.DesSubQtyField).AsFloat;
      fdm_Sub.Post;
      fdm_append.EmptyDataSet;
    end;
   // fdm_Detail.Next;
  //end;
  fdm_Detail.EnableControls;
  DM_Global.FormatGrid_byAD(FVouchObj.SrcTableDef, '', fdm_Sub, LinkGridToData_Sub, True);
  DM_Global.FormatGrid_byAD(FVouchObj.DesSubTableDef, '', fdm_Detail, LinkGridToData_Detail);
end;

procedure Tfrm_RdVouchWW11.setDefaulPosition(Value: string);
begin
  FPosition := Value;
  txt_BaseTitle.Text := format('%s  P:%s', [VouObj.DesMainTableDef, Value])
end;

function Tfrm_RdVouchWW11.GetcWhCode: string;
begin
  Result := '';
  if (not fdm_Main.eof) or (fdm_Main.State in [dsEdit, dsInsert]) then
    Result := fdm_Main.FieldByName('cWhCode').AsString.Trim;
end;

function Tfrm_RdVouchWW11.GetPostXML(): string;
var
  FXmlDoc                     : TXMLDocument;
  LoopInt, tmpInt             : Integer;
  ndVouchHead, tmpListRootNode: IXMLNode;
  ndVouchBody, ndProduct      : IXMLNode;
  bkm_Detail                  : TBookmark;

  procedure WriteChildNodeByDataSet(XMLDoc: TXMLDocument; nsParent: IXMLNode; dstSource: TDataSet; strNodeName, strFieldName: string);
  var
    ndTmp: IXMLNode;
    fdTmp: TField;
  begin
    strFieldName := Trim(strFieldName);
    fdTmp := dstSource.Fields.FindField(strFieldName);

    if fdTmp = nil then
    begin
      showmessage(format('%s表生成提交soap所需要的XML时错误，未发现字段%s', [VouObj.DesMainTable, strFieldName]));
      Abort;
    end;
    // if dstSource.FieldByName(strFieldName).AsString = '' then
    // begin
    // showmessage(format('%s表提交soap生成XML时错误，字段%s内容为空', [VouObj.MainTable, strFieldName]));
    // Abort;
    // end;
    ndTmp := XMLDoc.CreateNode(strNodeName);
    nsParent.ChildNodes.Add(ndTmp);
    ndTmp.Text := dstSource.FieldByName(strFieldName).AsString;
  end;

begin
  try

    FXmlDoc := TXMLDocument.Create(self);
    FXmlDoc.Active := True;
    FXmlDoc.Version := '1.0';
    FXmlDoc.Encoding := 'UTF-8';
    // 加入版本信息 ‘<?xml version="1.0" encoding="GB2312" ?> ’

    // 表头
    ndVouchHead := FXmlDoc.CreateNode('XMaterialOutInfo'); // 主单根结点
    FXmlDoc.DocumentElement := ndVouchHead;

    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cCode', 'cCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'dDate', 'dDate');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cWhCode', 'cWhCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMemo', 'cMemo');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cDepCode', 'cDepCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMaker', 'cMaker');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cVenCode', 'cVenCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cMPoCode', 'cMPoCode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cPsPcode', 'cPsPcode');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'iproorderid', 'iproorderid');
    // WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'cBusType', 'cBusType');
    WriteChildNodeByDataSet(FXmlDoc, ndVouchHead, fdm_Main, 'crdcode', 'cRdCode');

    // 下级
    ndVouchBody := FXmlDoc.CreateNode('XMaterialOutsInfos'); // 子表根结点
    ndVouchHead.ChildNodes.Add(ndVouchBody);
    bkm_Detail := fdm_Detail.GetBookmark;
    fdm_Detail.DisableControls;
    fdm_Detail.First;
    while not fdm_Detail.eof do
    begin
      // 表体
      ndProduct := FXmlDoc.CreateNode('XMaterialOutsInfo'); // 子表根结点
      ndVouchBody.ChildNodes.Add(ndProduct);
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cInvCode', 'cInvCode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cBatch', 'cBatch');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'iOMoDID', 'iOMoDID');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'iOMomID', 'iOMomID');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'comcode', 'comcode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'invcode', 'invcode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'ipesodid', 'ipesodid');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cpesocode', 'cpesocode');
      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'iQuantity', 'iQuantity');
     // WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'iNQuantity', 'iNuantity');


      WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, 'cposition', 'cPosition');

      // WriteChildNodeByDataSet(FXmlDoc, ndProduct, fdm_Detail, VouObj.DesSubLinkSrcFeild, VouObj.DesSubLinkSrcFeild); // iOMoMID

      fdm_Detail.Next;
    end;
    fdm_Detail.Bookmark := bkm_Detail;
    fdm_Detail.EnableControls;
    Result := FXmlDoc.Xml.Text;
  finally
    FXmlDoc.Active := False;
    FXmlDoc.Free;
  end;
end;

procedure Tfrm_RdVouchWW11.InitData;
var
  strVouchSql: string;
begin
  inherited;

  // 打开主表
  strVouchSql := format('select * from %s where %s=''%s''', [FVouchObj.DesMainTable, FVouchObj.DesMainKeyField, FVouchObj.DesMainKey]);
  DM_Global.ExecSql(fdm_Main, strVouchSql);
  if fdm_Main.eof then
    fdm_Main.Append;

  CreateADCtrl(FVouchObj.DesMainTableDef, lyt_Main, fdm_Main, BindSourceDB_Main);
  //SZHL_ComboBoxSyncToControl(lyt_Main, fdm_Main);

end;

end.
