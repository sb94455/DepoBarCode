unit uRepView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, frxClass, frxPreview;

type
  TfrmRepView = class(TForm)
    frxprvw1: TfrxPreview;
    tlb1: TToolBar;
    btn1: TToolButton;
    btn2: TToolButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PrintFlag: Boolean;
  end;

var
  frmRepView: TfrmRepView;

implementation

{$R *.dfm}

procedure TfrmRepView.btn1Click(Sender: TObject);
begin
  frxprvw1.Print;
  PrintFlag := True;
end;

procedure TfrmRepView.btn2Click(Sender: TObject);
begin
  close;
end;

procedure TfrmRepView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  Action := caFree;
end;

procedure TfrmRepView.FormDestroy(Sender: TObject);
begin
//  FreeAndNil(frmRepView);
end;

end.

