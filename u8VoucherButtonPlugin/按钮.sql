--��������ԭ�����ʹ��
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
	'����������(F3)',	'zh-cn',	'',		'����������(F3)',	'F3',
	1,		'����������(F3)',	'Print',	'Print')
GO


--�������� �����ϡ����ʹ��
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
	'������������(F3)',	'zh-cn',	'',		'������������(F3)',	'F3',
	1,		'������������(F3)',	'tlbPrint',	'tlbPrint')
GO

--���۷����� �����۳���ʹ��
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
	'����������(F3)',	'zh-cn',	'',		'����������F3)',	'F3',
	1,		'����������(F3)',	'print',	'print')
GO

--ί�ⶩ�� �����ϡ����ʹ��
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
	'ί�ⶩ������(F3)',	'zh-cn',	'',		'ί�ⶩ������(F3)',	'F3',
	1,		'ί�ⶩ������(F3)',	'print',	'print')
GO