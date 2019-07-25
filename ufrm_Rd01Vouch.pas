unit ufrm_Rd01Vouch;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  RdVouch, System.Rtti, FMX.Grid.Style, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid,
  System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Ani, FMX.Edit, FMX.Memo, FMX.ScrollBox, FMX.Grid,
  FMX.TabControl, FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  Tfrm_Rd01Vouch = class(Tfrm_RdVouch)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Rd01Vouch: Tfrm_Rd01Vouch;

implementation

{$R *.fmx}

end.
