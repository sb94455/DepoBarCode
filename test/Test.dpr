program Test;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitTest in 'UnitTest.pas' {frmTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmTest, frmTest);
  Application.Run;
end.
