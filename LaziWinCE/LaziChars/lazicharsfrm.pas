unit LaziCharsFrm;

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lconvencoding,
  LaziCharsLib;

type

  { TfrmLaziChars }

  TfrmLaziChars = class(TForm)
    btnInfo: TButton;
    btnClose: TButton;
    Button1: TButton;
    lblInfo: TLabel;
    mem: TMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  frmLaziChars: TfrmLaziChars;

implementation

{$R *.lfm}

{ TfrmLaziChars }

procedure TfrmLaziChars.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLaziChars.Button1Click(Sender: TObject);
var
  l:Integer;
  cl:String;
  c:String='Rus10-Рус';
  cw:WideString='Rus10-Рус';
begin
  mem.Clear;
  mem.Append(c+' cp='+IntToStr(StringCodePage(c)));
  l:=length(c);
  mem.Append(ViewChar(@c[1],l+1));

  cl:='Rus10-Рус';
  mem.Append(cl+' cp='+IntToStr(StringCodePage(cl)));
  l:=length(cl);
  mem.Append(ViewChar(@cl[1],l+1));

  mem.Append(cw+' cp='+IntToStr(StringCodePage(cw)));
  l:=length(cw);
  mem.Append(ViewChar(@cw[1],l*2+2));

  cw:=ExePath;
  mem.Append(cw+' cp='+IntToStr(StringCodePage(cw)));
  l:=length(cw);
  mem.Append(ViewChar(@cw[1],l*2+2));
end;

end.

