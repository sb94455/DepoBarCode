--到货单，原料入库使用
delete AA_CustomerButton where [cProjectNO]='U8CustDef' and cVoucherKey='26'
go
INSERT INTO [AA_CustomerButton]
	([cButtonID], 	[cButtonKey], 	[cButtonType], 	[cProjectNO], 	[cFormKey], 
	[cVoucherKey], 	[cKeyBefore], 	[iOrder], 	[cGroup], 	[cCustomerObjectName], 
	[cCaption], 	[cLocaleID], 	[cImage], 	[cToolTip], 	[cHotKey], 
	[bInneralCommand], [cVariant], 	[cVisibleAsKey], [cEnableAsKey])
VALUES	
	(newid(), 	'Print',	'default', 	'U8CustDef', 	'26', 
	'26',		'Print', 	'0', 		'IEDIT',	'VoucherBtnPlugins.PrintRd01BarCode',	
	'到货单条码(F3)',	'zh-cn',	'',		'到货单条码(F3)',	'F3',
	1,		'到货单条码(F3)',	'Print',	'Print')
GO


--生产订单 ，领料、入库使用
delete AA_CustomerButton where [cProjectNO]='U8CustDef' and cVoucherKey='MO21'
go
INSERT INTO [AA_CustomerButton]
	([cButtonID], 	[cButtonKey], 	[cButtonType], 	[cProjectNO], 	[cFormKey], 
	[cVoucherKey], 	[cKeyBefore], 	[iOrder], 	[cGroup], 	[cCustomerObjectName], 
	[cCaption], 	[cLocaleID], 	[cImage], 	[cToolTip], 	[cHotKey], 
	[bInneralCommand], [cVariant], 	[cVisibleAsKey], [cEnableAsKey])
VALUES	
	(newid(), 	'tlbPrint',	'default', 	'U8CustDef', 	'MO21', 
	'MO21',		'tlbPrint', 	'0', 		'IEDIT',	'VoucherBtnPlugins.PrintRd10BarCode',	
	'生产订单条码(F3)',	'zh-cn',	'',		'生产订单条码(F3)',	'F3',
	1,		'生产订单条码(F3)',	'tlbPrint',	'tlbPrint')
GO

--销售发货单 ，销售出库使用
delete AA_CustomerButton where [cProjectNO]='U8CustDef' and cVoucherKey='01'
go
INSERT INTO [AA_CustomerButton]
	([cButtonID], 	[cButtonKey], 	[cButtonType], 	[cProjectNO], 	[cFormKey], 
	[cVoucherKey], 	[cKeyBefore], 	[iOrder], 	[cGroup], 	[cCustomerObjectName], 
	[cCaption], 	[cLocaleID], 	[cImage], 	[cToolTip], 	[cHotKey], 
	[bInneralCommand], [cVariant], 	[cVisibleAsKey], [cEnableAsKey])
VALUES	
	(newid(), 	'print',	'default', 	'U8CustDef', 	'01', 
	'01',		'print', 	'0', 		'IEDIT',	'VoucherBtnPlugins.PrintDispatchlist',	
	'发货单条码(F3)',	'zh-cn',	'',		'发货单条码F3)',	'F3',
	1,		'发货单条码(F3)',	'print',	'print')
GO

--委外订单 ，领料、入库使用
delete AA_CustomerButton where [cProjectNO]='U8CustDef' and cVoucherKey='OM01'
go
INSERT INTO [AA_CustomerButton]
	([cButtonID], 	[cButtonKey], 	[cButtonType], 	[cProjectNO], 	[cFormKey], 
	[cVoucherKey], 	[cKeyBefore], 	[iOrder], 	[cGroup], 	[cCustomerObjectName], 
	[cCaption], 	[cLocaleID], 	[cImage], 	[cToolTip], 	[cHotKey], 
	[bInneralCommand], [cVariant], 	[cVisibleAsKey], [cEnableAsKey])
VALUES	
	(newid(), 	'print',	'default', 	'U8CustDef', 	'OM01', 
	'OM01',		'print', 	'0', 		'IEDIT',	'VoucherBtnPlugins.wwBarCode',	
	'委外订单条码(F3)',	'zh-cn',	'',		'委外订单条码(F3)',	'F3',
	1,		'委外订单条码(F3)',	'print',	'print')
GO