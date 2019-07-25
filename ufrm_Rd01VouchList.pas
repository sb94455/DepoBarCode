unit ufrm_Rd01VouchList;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  RdVouchList, System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.Bind.Components, Data.Bind.DBScope, Data.Bind.Grid,
  FMX.Ani, FMX.ScrollBox, FMX.Grid, FMX.Layouts, FMX.Objects,
  FMX.Controls.Presentation;

type
  Tfrm_Rd01VouchList = class(Tfrm_RdVouchList)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Rd01VouchList: Tfrm_Rd01VouchList;

implementation

{$R *.fmx}

end.
