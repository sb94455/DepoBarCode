unit VoucherBtnPlugins_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2019-07-25 18:38:22 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\VoucherBtnPlugins\VoucherBtnPlugins.tlb (1)
// LIBID: {FCC0959C-66F8-44DB-B26D-E2FC006FF593}
// LCID: 0
// Helpfile: 
// HelpString: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  VoucherBtnPluginsMajorVersion = 1;
  VoucherBtnPluginsMinorVersion = 0;

  LIBID_VoucherBtnPlugins: TGUID = '{FCC0959C-66F8-44DB-B26D-E2FC006FF593}';

  IID_IPrintRd01BarCode: TGUID = '{2D5DAB61-3E54-4EB5-90EE-430227F6692C}';
  CLASS_PrintRd01BarCode: TGUID = '{4EA112E3-8BBE-4625-A88E-3CE79C25F8CB}';
  IID_IPrintRd10BarCode: TGUID = '{B80023F4-D59C-4DD6-81E4-74B6C4B75EDB}';
  CLASS_PrintRd10BarCode: TGUID = '{80DAF8E2-7239-4A3C-B9FC-276D03F855E0}';
  IID_IPrintDispatchlist: TGUID = '{F13BEAB9-70FF-4057-B4E1-3F361B2B543B}';
  CLASS_PrintDispatchlist: TGUID = '{C6467B94-9147-48CF-A758-5EFD0E0F8C5A}';
  IID_IwwBarCode: TGUID = '{2E7D2DBB-CAAB-465C-BBEE-B69BDF29E6F6}';
  CLASS_wwBarCode: TGUID = '{248BE6FA-2806-41FD-B177-67D02FEA86F1}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IPrintRd01BarCode = interface;
  IPrintRd01BarCodeDisp = dispinterface;
  IPrintRd10BarCode = interface;
  IPrintRd10BarCodeDisp = dispinterface;
  IPrintDispatchlist = interface;
  IPrintDispatchlistDisp = dispinterface;
  IwwBarCode = interface;
  IwwBarCodeDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  PrintRd01BarCode = IPrintRd01BarCode;
  PrintRd10BarCode = IPrintRd10BarCode;
  PrintDispatchlist = IPrintDispatchlist;
  wwBarCode = IwwBarCode;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  POleVariant1 = ^OleVariant; {*}
  PWordBool1 = ^WordBool; {*}


// *********************************************************************//
// Interface: IPrintRd01BarCode
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2D5DAB61-3E54-4EB5-90EE-430227F6692C}
// *********************************************************************//
  IPrintRd01BarCode = interface(IDispatch)
    ['{2D5DAB61-3E54-4EB5-90EE-430227F6692C}']
    procedure RunCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                         var objVoucher: OleVariant; const sKey: WideString; 
                         VarentValue: OleVariant; const other: WideString); safecall;
    procedure Init(var objLogin: OleVariant; var objForm: OleVariant; var objVoucher: OleVariant; 
                   var msBar: OleVariant); safecall;
    procedure BeforeRunSysCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                                  var objVoucher: OleVariant; const sKey: WideString; 
                                  VarentValue: OleVariant; var Cancel: WordBool; 
                                  const other: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IPrintRd01BarCodeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2D5DAB61-3E54-4EB5-90EE-430227F6692C}
// *********************************************************************//
  IPrintRd01BarCodeDisp = dispinterface
    ['{2D5DAB61-3E54-4EB5-90EE-430227F6692C}']
    procedure RunCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                         var objVoucher: OleVariant; const sKey: WideString; 
                         VarentValue: OleVariant; const other: WideString); dispid 201;
    procedure Init(var objLogin: OleVariant; var objForm: OleVariant; var objVoucher: OleVariant; 
                   var msBar: OleVariant); dispid 202;
    procedure BeforeRunSysCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                                  var objVoucher: OleVariant; const sKey: WideString; 
                                  VarentValue: OleVariant; var Cancel: WordBool; 
                                  const other: WideString); dispid 203;
  end;

// *********************************************************************//
// Interface: IPrintRd10BarCode
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B80023F4-D59C-4DD6-81E4-74B6C4B75EDB}
// *********************************************************************//
  IPrintRd10BarCode = interface(IDispatch)
    ['{B80023F4-D59C-4DD6-81E4-74B6C4B75EDB}']
    procedure RunCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                         var objVoucher: OleVariant; const sKey: WideString; 
                         VarentValue: OleVariant; const other: WideString); safecall;
    procedure Init(var objLogin: OleVariant; var objForm: OleVariant; var objVoucher: OleVariant; 
                   var msBar: OleVariant); safecall;
    procedure BeforeRunSysCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                                  var objVoucher: OleVariant; const sKey: WideString; 
                                  VarentValue: OleVariant; var Cancel: WordBool; 
                                  const other: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IPrintRd10BarCodeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B80023F4-D59C-4DD6-81E4-74B6C4B75EDB}
// *********************************************************************//
  IPrintRd10BarCodeDisp = dispinterface
    ['{B80023F4-D59C-4DD6-81E4-74B6C4B75EDB}']
    procedure RunCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                         var objVoucher: OleVariant; const sKey: WideString; 
                         VarentValue: OleVariant; const other: WideString); dispid 201;
    procedure Init(var objLogin: OleVariant; var objForm: OleVariant; var objVoucher: OleVariant; 
                   var msBar: OleVariant); dispid 202;
    procedure BeforeRunSysCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                                  var objVoucher: OleVariant; const sKey: WideString; 
                                  VarentValue: OleVariant; var Cancel: WordBool; 
                                  const other: WideString); dispid 203;
  end;

// *********************************************************************//
// Interface: IPrintDispatchlist
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F13BEAB9-70FF-4057-B4E1-3F361B2B543B}
// *********************************************************************//
  IPrintDispatchlist = interface(IDispatch)
    ['{F13BEAB9-70FF-4057-B4E1-3F361B2B543B}']
    procedure RunCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                         var objVoucher: OleVariant; const sKey: WideString; 
                         VarentValue: OleVariant; const other: WideString); safecall;
    procedure Init(var objLogin: OleVariant; var objForm: OleVariant; var objVoucher: OleVariant; 
                   var msBar: OleVariant); safecall;
    procedure BeforeRunSysCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                                  var objVoucher: OleVariant; const sKey: WideString; 
                                  VarentValu: OleVariant; var Cancel: WordBool; 
                                  const other: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IPrintDispatchlistDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F13BEAB9-70FF-4057-B4E1-3F361B2B543B}
// *********************************************************************//
  IPrintDispatchlistDisp = dispinterface
    ['{F13BEAB9-70FF-4057-B4E1-3F361B2B543B}']
    procedure RunCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                         var objVoucher: OleVariant; const sKey: WideString; 
                         VarentValue: OleVariant; const other: WideString); dispid 201;
    procedure Init(var objLogin: OleVariant; var objForm: OleVariant; var objVoucher: OleVariant; 
                   var msBar: OleVariant); dispid 202;
    procedure BeforeRunSysCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                                  var objVoucher: OleVariant; const sKey: WideString; 
                                  VarentValu: OleVariant; var Cancel: WordBool; 
                                  const other: WideString); dispid 203;
  end;

// *********************************************************************//
// Interface: IwwBarCode
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2E7D2DBB-CAAB-465C-BBEE-B69BDF29E6F6}
// *********************************************************************//
  IwwBarCode = interface(IDispatch)
    ['{2E7D2DBB-CAAB-465C-BBEE-B69BDF29E6F6}']
    procedure RunCommand(var objLogin: OleVariant; var objFrom: OleVariant; 
                         var objVoucher: OleVariant; const sKey: WideString; 
                         VarentValue: OleVariant; const other: WideString); safecall;
    procedure Init(var objLogin: OleVariant; var objForm: OleVariant; var objVoucher: OleVariant; 
                   var msBar: OleVariant); safecall;
    procedure BeforeRunSysCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                                  var objVoucher: OleVariant; const sKey: WideString; 
                                  VarentValue: OleVariant; var Cancel: WordBool; 
                                  const other: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IwwBarCodeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {2E7D2DBB-CAAB-465C-BBEE-B69BDF29E6F6}
// *********************************************************************//
  IwwBarCodeDisp = dispinterface
    ['{2E7D2DBB-CAAB-465C-BBEE-B69BDF29E6F6}']
    procedure RunCommand(var objLogin: OleVariant; var objFrom: OleVariant; 
                         var objVoucher: OleVariant; const sKey: WideString; 
                         VarentValue: OleVariant; const other: WideString); dispid 201;
    procedure Init(var objLogin: OleVariant; var objForm: OleVariant; var objVoucher: OleVariant; 
                   var msBar: OleVariant); dispid 202;
    procedure BeforeRunSysCommand(var objLogin: OleVariant; var objForm: OleVariant; 
                                  var objVoucher: OleVariant; const sKey: WideString; 
                                  VarentValue: OleVariant; var Cancel: WordBool; 
                                  const other: WideString); dispid 203;
  end;

// *********************************************************************//
// The Class CoPrintRd01BarCode provides a Create and CreateRemote method to          
// create instances of the default interface IPrintRd01BarCode exposed by              
// the CoClass PrintRd01BarCode. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPrintRd01BarCode = class
    class function Create: IPrintRd01BarCode;
    class function CreateRemote(const MachineName: string): IPrintRd01BarCode;
  end;

// *********************************************************************//
// The Class CoPrintRd10BarCode provides a Create and CreateRemote method to          
// create instances of the default interface IPrintRd10BarCode exposed by              
// the CoClass PrintRd10BarCode. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPrintRd10BarCode = class
    class function Create: IPrintRd10BarCode;
    class function CreateRemote(const MachineName: string): IPrintRd10BarCode;
  end;

// *********************************************************************//
// The Class CoPrintDispatchlist provides a Create and CreateRemote method to          
// create instances of the default interface IPrintDispatchlist exposed by              
// the CoClass PrintDispatchlist. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoPrintDispatchlist = class
    class function Create: IPrintDispatchlist;
    class function CreateRemote(const MachineName: string): IPrintDispatchlist;
  end;

// *********************************************************************//
// The Class CowwBarCode provides a Create and CreateRemote method to          
// create instances of the default interface IwwBarCode exposed by              
// the CoClass wwBarCode. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CowwBarCode = class
    class function Create: IwwBarCode;
    class function CreateRemote(const MachineName: string): IwwBarCode;
  end;

implementation

uses ComObj;

class function CoPrintRd01BarCode.Create: IPrintRd01BarCode;
begin
  Result := CreateComObject(CLASS_PrintRd01BarCode) as IPrintRd01BarCode;
end;

class function CoPrintRd01BarCode.CreateRemote(const MachineName: string): IPrintRd01BarCode;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PrintRd01BarCode) as IPrintRd01BarCode;
end;

class function CoPrintRd10BarCode.Create: IPrintRd10BarCode;
begin
  Result := CreateComObject(CLASS_PrintRd10BarCode) as IPrintRd10BarCode;
end;

class function CoPrintRd10BarCode.CreateRemote(const MachineName: string): IPrintRd10BarCode;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PrintRd10BarCode) as IPrintRd10BarCode;
end;

class function CoPrintDispatchlist.Create: IPrintDispatchlist;
begin
  Result := CreateComObject(CLASS_PrintDispatchlist) as IPrintDispatchlist;
end;

class function CoPrintDispatchlist.CreateRemote(const MachineName: string): IPrintDispatchlist;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_PrintDispatchlist) as IPrintDispatchlist;
end;

class function CowwBarCode.Create: IwwBarCode;
begin
  Result := CreateComObject(CLASS_wwBarCode) as IwwBarCode;
end;

class function CowwBarCode.CreateRemote(const MachineName: string): IwwBarCode;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_wwBarCode) as IwwBarCode;
end;

end.
