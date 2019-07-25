use ufdata_700_2011
select * from szhl_tabledef
select * from position
Select * from CurrentStock where 1=1  and cWhCode='1' and cPosCode LIKE '11%'

SELECT * FROM SYSOBJECTS WHERE NAME LIKE '%SUM' and xtype='u'

select * from C InvPositionSum

SELECT * FROM UFDATA_700_2011.dbo.SZHL_TableDef where name='rdrecords01'
select * from UFDATA_700_2011.DBO.SZHL_ItmDef where tableid=12


select top 10 * from WssBC_ArrivalVouchs_NotIn

INSERT INTO [SZHL_ItmDef]
           ([TableId]
           ,[FieldKind]
           ,[FieldName]
           ,[FieldDef]
           ,[FieldType]
           ,[Seq]
           ,[iVisible]
           ,[labelWidth]
           ,[isBetween]
           ,[Width]
           ,[DefaultValue]
           ,[Editing]
           ,[Filtering]
           ,[Sorting]
           ,[Grouping]
           ,[AllowEmpty]
           ,[LookupRefKeyFieldName]
           ,[LookupRefFieldName]
           ,[LookupRefTableName]
           ,[LookupKeyFieldName]
           ,[Group_Visible]
           ,[Group_Width]
           ,[XMLNodeName]
           ,[isXML])
    select [TableId]
           ,[FieldKind]
           ,[FieldName]
           ,[FieldDef]
           ,[FieldType]
           ,[Seq]
           ,[iVisible]
           ,[labelWidth]
           ,[isBetween]
           ,[Width]
           ,[DefaultValue]
           ,[Editing]
           ,[Filtering]
           ,[Sorting]
           ,[Grouping]
           ,[AllowEmpty]
           ,[LookupRefKeyFieldName]
           ,[LookupRefFieldName]
           ,[LookupRefTableName]
           ,[LookupKeyFieldName]
           ,[Group_Visible]
           ,[Group_Width]
           ,[XMLNodeName]
           ,[isXML]
            from szhl_itmdef  where tableid =17