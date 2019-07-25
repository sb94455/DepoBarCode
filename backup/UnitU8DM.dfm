object U8DM: TU8DM
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 369
  Width = 384
  object HTTPRIO1: THTTPRIO
    HTTPWebNode.UseUTF8InHeader = True
    HTTPWebNode.InvokeOptions = [soIgnoreInvalidCerts, soAutoCheckAccessPointViaUDDI]
    HTTPWebNode.WebNodeOptions = []
    Converter.Options = [soSendMultiRefObj, soTryAllSchema, soRootRefNodesToBody, soCacheMimeResponse, soUTF8EncodeXML]
    Left = 64
    Top = 112
  end
  object fdm_Dict: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 152
    Top = 232
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=DS'
      'User_Name=admin'
      'Server=DEPOKS.SZHLRJ.COM'
      'Password=123'
      'Port=985')
    LoginPrompt = False
    Left = 232
    Top = 224
  end
  object FDStoredProc1: TFDStoredProc
    Connection = FDConnection1
    Left = 296
    Top = 192
  end
  object ds_Dict: TDataSource
    DataSet = fdm_Dict
    Left = 208
    Top = 320
  end
end
