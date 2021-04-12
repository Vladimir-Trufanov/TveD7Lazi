unit SirSergeFrm;

// http://sirserge.altai.info/articles/?id=45

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  MyPPunit1,
  lazutf8,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  AAB=array [0..65535] of byte;
  PAAB=^AAB;

	{ TfrmSirSerge }

  TfrmSirSerge = class(TForm)
		Button1: TButton;
		Button2: TButton;
		Button3: TButton;
		Button4: TButton;
		Button5: TButton;
		Button6: TButton;
		lblInfo: TLabel;
		Memo1: TMemo;
		procedure Button1Click(Sender: TObject);
		procedure Button2Click(Sender: TObject);
		procedure Button3Click(Sender: TObject);
		procedure Button4Click(Sender: TObject);
		procedure Button5Click(Sender: TObject);
		procedure Button6Click(Sender: TObject);
  private
  public
  end;

var
  frmSirSerge: TfrmSirSerge;

implementation

function PrintByte(p:PAAB; len:integer):string;
Var i:integer;
begin
  Result:='';
  for i:=0 to len-1 do begin
    Result+=Format('%2.2x ',[p^[i]]);
  end;
  Result:=Trim(Result);
end;

{$R *.lfm}

{ TfrmSirSerge }

procedure TfrmSirSerge.Button1Click(Sender: TObject);
var
  su:UnicodeString;
begin
  Memo1.Clear;
  su:=RUnicodeString('АПРОЛ');
  Memo1.Append('su CodePage:'+IntToStr(StringCodePage(su)));
  Memo1.Append(UTF16toUTF8(su));
  Memo1.Append('su:'+PrintByte(@su[1],10));
end;

procedure TfrmSirSerge.Button2Click(Sender: TObject);
Var rb0: RawByteString;
begin
  Memo1.Clear;
  rb0:=RUnicodeString;
  Memo1.Append('rb0 перед конверсией:'+PrintByte(@rb0[1],8));
  Memo1.Append('rb0 CodePage:'+IntToStr(StringCodePage(rb0)));
  SetCodePage(rb0,CP_UTF8,TRUE);
  Memo1.Append('rb0 после конверсии:'+PrintByte(@rb0[1],8));
  SetCodePage(rb0,0,FALSE);
  Memo1.Append(rb0);
end;

procedure TfrmSirSerge.Button3Click(Sender: TObject);
Var
  u8: UTF8String;
  rb0: RawByteString;
begin
  Memo1.Clear;
  u8:=RUnicodeString;
  rb0:=u8;
  Memo1.Append('rb0 перед конверсией:'+PrintByte(@rb0[1],8));
  Memo1.Append('rb0 CodePage:'+IntToStr(StringCodePage(rb0)));
  SetCodePage(rb0,0,FALSE);
  Memo1.Append(rb0);
end;

procedure TfrmSirSerge.Button4Click(Sender: TObject);
Var rb1:RawByteString;
begin
  Memo1.Clear;
  rb1:=RUTF8Str;
  Memo1.Append('rb1 CodePage:'+IntToStr(StringCodePage(rb1)));
  SetCodePage(rb1,0,FALSE);
  Memo1.Append('rb1:'+PrintByte(@rb1[1],8));
  Memo1.Append(rb1);
end;

procedure TfrmSirSerge.Button5Click(Sender: TObject);
Var ss:ShortString;
begin
  Memo1.Clear;
  ss:=RUTF8Str;
  Memo1.Append('ss CodePage:'+IntToStr(StringCodePage(ss)));
  Memo1.Append('ss:'+PrintByte(@ss[1],8));
  Memo1.Append(ss);
end;

procedure TfrmSirSerge.Button6Click(Sender: TObject);
Var
  s:string;
  su:UnicodeString='Rus10-Рус';
begin
  Memo1.Clear;
  Memo1.Append(UTF16toUTF8('Добавляемая строка'));
  Memo1.Append('Добавляемая строка');
  s:=UTF16ToUTF8('Строка для инициализации переменной');
  Memo1.Append(s);
  s:='Строка для инициализации переменной';
  Memo1.Append(s);
  Memo1.Append(su);
  s:=UTF16ToUTF8(su);
  Memo1.Append(s);
end;

end.

