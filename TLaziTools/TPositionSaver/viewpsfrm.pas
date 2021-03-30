unit ViewPSfrm;

{$mode objfpc}{$H+}

interface

uses
  PositionSaver, Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, DbCtrls;

type

  { TfrmViewPS }

  TfrmViewPS = class(TForm)
    Button1: TButton;
    dbn: TDBNavigator;
    pnlRight: TPanel;
    pnlLeft: TPanel;
    spl: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    ps: TPositionSaver;
    { private declarations }
  public
    { public declarations }
  end;

var
  frmViewPS: TfrmViewPS;

implementation

{$R *.lfm}

{ TfrmViewPS }

procedure TfrmViewPS.FormCreate(Sender: TObject);
begin
  ps:=TPositionSaver.Create(Self);
end;

procedure TfrmViewPS.Button1Click(Sender: TObject);
begin
  ShowMessage(
    'ps.Form='+ps.Form.Name+': '+
    'Width='+IntToStr(ps.Form.Width));
end;

procedure TfrmViewPS.FormDestroy(Sender: TObject);
begin
  ps.Destroy;
end;

end.

