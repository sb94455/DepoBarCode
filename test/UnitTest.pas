unit UnitTest;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Rtti,
  FMX.Grid.Style, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.StdCtrls, FMX.ScrollBox,
  FMX.Grid, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.DateTimeCtrls;

type
  TfrmTest = class(TForm)
    Edit1: TEdit;
    StringGrid1: TStringGrid;
    Button1: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Edit2: TEdit;
    BindSourceDB1: TBindSourceDB;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    BindingsList1: TBindingsList;
    Layout1: TLayout;
    Edit3: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Layout2: TLayout;
    GridPanelLayout1: TGridPanelLayout;
    DateEdit1: TDateEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure clearAllControls(Layout: TControl);
  public
    { Public declarations }
  end;

var
  frmTest: TfrmTest;

implementation
//         uses Data.Bind.Components;
{$R *.fmx}

procedure TfrmTest.Button1Click(Sender: TObject);
var
  l1: TLinkControlToField;
begin
  inherited;
//BindingsList1.
  with TLinkControlToField.Create(self) do
  begin
    DataSource := BindSourceDB1;
    FieldName := 'cWhCode'; //U8DM.fdm_Dict.Fields[0].FieldName;
    Control := Edit1;
    Active := True;
  end;
  with TLinkControlToField.Create(self) do
  begin
    DataSource := BindSourceDB1;
    FieldName := 'cWhName'; //U8DM.fdm_Dict.Fields[0].FieldName;
    Control := Edit2;
    Active := True;
  end;

//   BindingsList1.
end;

procedure TfrmTest.Button2Click(Sender: TObject);
begin
  clearAllControls(Layout1);
end;

procedure TfrmTest.clearAllControls(Layout: TControl);
var
  I: Integer;
  c1:TControl;
begin
  for I := 0 to Layout.ControlsCount - 1 do
  begin
    if ((Layout.Controls.Items[I] is TControl)and(Layout.Controls.Items[I].Name<>'')) then
    begin
          ShowMessage(Layout.Controls.Items[I].ClassName + '---------->' + Layout.Controls.Items[I].Name);
          c1:=       Layout.Controls.Items[I];
          c1.Visible:=False;
    end;

    clearAllControls(Layout.Controls.Items[I]);
  end;

end;

end.

