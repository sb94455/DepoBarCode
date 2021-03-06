/****** Script for SelectTopNRows command from SSMS  ******/
--delete szhl_tabledef where name='RdRecords1'
--delete szhl_itmdef where tableid not in (select tableid from szhl_tabledef)
SELECT *  FROM SZHL_TableDef where Name='SZHL_Wss_V_WWMaterialOut_List'
select *from SZHL_ItmDef where TableId=25
  select *from SZHL_MoOrderVouchView
select * from SZHL_Wss_V_MaterialOutList

EXEC SZHL_CopyItemDef '材料出库单子表','委外材料出库单子表'

update SZHL_TableDef set mobile=1 where Name like 'SZHL_WSS%' OR Name LIKE 'RDRE%'
select cPTCode,ipurarriveid,* from rdrecord01 where cdep

SELECT  * FROM Rpt_ItmDEF WHERE tablename='rdrecords11'
select * from rdrecords32 where idl


select * from ufsystem..ua_user where cUser_id like 'demo' or cUser_Name like 'demo'
update ufsystem..ua_user  set cUser_Name='demo用户名' where cUser_id like 'demo' or cUser_Name like 'demo'


select * from Department where bDepEnd=1 and (cdepcode like '%采购%' or cdepname like '%采购%')

select *from Rpt_ItmDEF where  Tablename like 'mom_moallocate'
select *from Rd_Style where cRdName like '%费用%'
select *from rdrecords11 WHERE iOMoDID=1 AND iOMoMID AND cmocode AND invcode
select *,0.00 as Qty_Amt  from SZHL_Wss_V_MaterialOut_Src where Modid = ('1000158158')


SELECT * FROM SZHL_Wss_V_MaterialOut_List
SELECT * FROM SZHL_Wss_V_WWMaterialOut_SRC
select *  from rpt_itmdef where tabledef like '%委外订单%' and tablename='OM_MOMaterials'
create view SZHL_Wss_V_WWMaterialOut_SRC as
select ddate,ccode,OM_MOMain.MOID, OM_MOdetails.MODetailsID,OM_MOMaterials.cInvCode,OM_MOMaterials.iQuantity, iSendQTY
 from OM_MOMain inner join OM_MOdetails  on OM_MOMain.moid=OM_MOdetails.moid
INNER JOIN OM_MOMaterials ON OM_MOdetails.modetailsid=OM_MOMaterials.modetailsid



