program BarCode;

uses
  System.StartUpCopy,
  FMX.Forms,
  LoginForm in 'LoginForm.pas' {LoginFrm},
  MainForm in 'MainForm.pas' {MainFrm},
  ArrivalVouchService in 'WebService\ArrivalVouchService.pas',
  BaseDataService in 'WebService\BaseDataService.pas',
  LoginService in 'WebService\LoginService.pas',
  MaterialOutService in 'WebService\MaterialOutService.pas',
  OMOrderService in 'WebService\OMOrderService.pas',
  OtherQueryService in 'WebService\OtherQueryService.pas',
  ProduceOrderService in 'WebService\ProduceOrderService.pas',
  ProductInService in 'WebService\ProductInService.pas',
  PurchaseInService in 'WebService\PurchaseInService.pas',
  SaleOutService in 'WebService\SaleOutService.pas',
  AboutForm in 'AboutForm.pas' {AboutFrm},
  testFrm in 'TEST\testFrm.pas' {frmTest},
  untGlobal in 'comm\untGlobal.pas',
  uServerMethods1Client in 'comm\uServerMethods1Client.pas',
  uSZHLFMXEdit in 'comm\uSZHLFMXEdit.pas',
  BaseForm in 'pub\BaseForm.pas' {BaseFrm},
  UnitU8DM in 'pub\UnitU8DM.pas' {U8DM: TDataModule},
  UnitLib in 'pub\UnitLib.pas',
  StockForm in 'StockForm.pas' {StockFrm},
  InventoryForm in 'comm\ref\InventoryForm.pas' {InventoryFrm},
  PositionForm in 'comm\ref\PositionForm.pas' {PositionFrm},
  VendorForm in 'comm\ref\VendorForm.pas' {VendorFrm},
  WareHouseForm in 'comm\ref\WareHouseForm.pas' {WareHouseFrm},
  DeptForm in 'comm\ref\DeptForm.pas' {DeptFrm},
  CustomerForm in 'comm\ref\CustomerForm.pas' {CustomerFrm},
  uRdVouch01 in 'RdVouch\rd01\uRdVouch01.pas' {frm_RdVouch01},
  uRdVouchList01 in 'RdVouch\rd01\uRdVouchList01.pas' {frm_RdVouchList01},
  uRdVouch11 in 'RdVouch\rd11\uRdVouch11.pas' {frm_RdVouch11},
  uRdVouchList11 in 'RdVouch\rd11\uRdVouchList11.pas' {frm_RdVouchList11},
  uRdVouch10 in 'RdVouch\rd10\uRdVouch10.pas' {frm_RdVouch10},
  uRdVouchList10 in 'RdVouch\rd10\uRdVouchList10.pas' {frm_RdVouchList10},
  uRdVouch32 in 'RdVouch\rd32\uRdVouch32.pas' {frm_RdVouch32},
  uRdVouchList32 in 'RdVouch\rd32\uRdVouchList32.pas' {frm_RdVouchList32},
  uRdVouchWW11 in 'RdVouch\rdWW11\uRdVouchWW11.pas' {frm_RdVouchWW11},
  uRdVouchListWW11 in 'RdVouch\rdWW11\uRdVouchListWW11.pas' {frm_RdVouchListWW11},
  uRdVouchListWW01 in 'RdVouch\rdWW01\uRdVouchListWW01.pas' {frm_RdVouchListWW01},
  uRdVouchWW01 in 'RdVouch\rdWW01\uRdVouchWW01.pas' {frm_RdVouchWW01},
  PersonForm in 'comm\ref\PersonForm.pas' {personFrm},
  uRdVouchList08 in 'RdVouch\rd08\uRdVouchList08.pas' {frm_RdVouchList08},
  uRdVouch08 in 'RdVouch\rd08\uRdVouch08.pas' {frm_RdVouch08},
  uRdVouchList09 in 'RdVouch\rd09\uRdVouchList09.pas' {frm_RdVouchList09},
  uRdVouch09 in 'RdVouch\rd09\uRdVouch09.pas' {frm_RdVouch09};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TU8DM, U8DM);
  Application.CreateForm(TMainFrm, MainFrm);
  Application.Run;
end.
