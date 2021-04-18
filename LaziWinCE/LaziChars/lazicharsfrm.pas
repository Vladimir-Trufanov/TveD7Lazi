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
    Button2: TButton;
    lblInfo: TLabel;
    mem: TMemo;
    procedure btnCloseClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

procedure TfrmLaziChars.Button2Click(Sender: TObject);
var
  l,i:Integer;
  aCharString: array of char;
  pch: PChar;
  cs: String;
  len: Integer;
begin
  SetLength(aCharString,13);
  aCharString[0]:='R';
  aCharString[1]:='u';
  aCharString[2]:='s';
  aCharString[3]:='1';
  aCharString[4]:='0';
  aCharString[5]:='-';
  aCharString[6]:=chr(208); aCharString[7]:=chr(160);   // 'Р'
  aCharString[8]:=chr(209); aCharString[9]:=chr(131);   // 'у'
  aCharString[10]:=chr(209); aCharString[11]:=chr(129); // 'с'
  aCharString[12]:=chr(0);
  pch:=@aCharString[0];
  //cs:=pch^;
  len:=strlen(pch);
  cs:='';
  for i:=1 to len do begin
    cs:=cs+pch^;
    inc(pch);
  end;


  mem.Clear;
  mem.Append(IntToStr(len));
  mem.Append(cs+' cp='+IntToStr(StringCodePage(cs)));
  l:=length(aCharString);
  mem.Append(ViewChar(@aCharString[0],l));
end;

end.

