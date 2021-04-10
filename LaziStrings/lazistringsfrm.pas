unit LaziStringsFrm;

{$mode objfpc}{$H+}

interface

uses
  lazutf8,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmLaziStrings }

  TfrmLaziStrings = class(TForm)
		btnWideStringV1: TButton;
		btnClose: TButton;
		btnWideStringV2: TButton;
		btnWhereString: TButton;
		Button1: TButton;
		Button2: TButton;
		Button3: TButton;
		Button4: TButton;
		Button5: TButton;
		lblSecond: TLabel;
		lblFirst: TLabel;
	  procedure btnCloseClick(Sender: TObject);
    procedure btnWideStringV1Click(Sender: TObject);
	  procedure btnWideStringV2Click(Sender: TObject);
	  procedure btnWhereStringClick(Sender: TObject);
		procedure Button1Click(Sender: TObject);
		procedure Button2Click(Sender: TObject);
		procedure Button3Click(Sender: TObject);
		procedure Button4Click(Sender: TObject);
		procedure Button5Click(Sender: TObject);
	  procedure FormCreate(Sender: TObject);
    private

  public

  end;

var
  frmLaziStrings: TfrmLaziStrings;

implementation

{$R *.lfm}

{ TfrmLaziStrings }

// Особенности работы с WideString
procedure TfrmLaziStrings.btnWideStringV1Click(Sender: TObject);
var
  w: widestring;
begin
  // FPC преобразовывает системную кодовую страницу в UTF16 = UnicodeString
  w:='Рус10-Rus';
  // FPC в Caption вкладывает как AnsiString (поэтому выводит неправильно)
  lblFirst.Caption:=w;
  // AnsiString преобразоваем в UnicodeString
  w:=UTF8ToUTF16('Рус10-Rus');
  // UnicodeString преобразовываем в AnsiString и вкладываем в Caption
  lblSecond.Caption:=UTF16ToUTF8(w);
end;

procedure TfrmLaziStrings.btnWideStringV2Click(Sender: TObject);
var
  w: widestring;
begin
  w:='Рус10-Rus';
  // Неправильно
  lblFirst.Caption:=UTF16ToUTF8(w);
  // Неправильно
  w:='Рус10-Rus';
  w:=UTF8ToUTF16(w);
  lblSecond.Caption:=UTF16ToUTF8(w);
end;


// Найти подстроку (String::=AnsiString)
function Where(SearchFor,aText:string):String;
var
  BytePos: LongInt;
  CharacterPos: LongInt;
begin
  BytePos:=Pos(SearchFor,aText);
  CharacterPos:=UTF8Length(PChar(aText),BytePos-1);
  Result:=
    'Подстрока "'+SearchFor+'" начинается в тексте "'+aText+'"'+
    ' с байта '+IntToStr(BytePos)+', с символа '+IntToStr(CharacterPos);
end;
procedure TfrmLaziStrings.btnWhereStringClick(Sender: TObject);
begin
  lblFirst.Caption:=Where('Рус','Рус10-Rus');
  lblSecond.Caption:=Where('Rus','Рус10-Rus');
end;

procedure DoSomethingWithString(AnUTF8String: string);
var
  p: PChar;
  CharLen: integer;
  FirstByte, SecondByte, ThirdByte: Char;
begin
  p := PChar(AnUTF8String);
  repeat
    CharLen := UTF8CharacterLength(p);

    // У нас есть указатель на символ и его длина
    // Для побайтного доступа к UTF-8 символу:
    if CharLen >= 1 then FirstByte := P[0];
    if CharLen >= 2 then SecondByte := P[1];
    if CharLen >= 3 then ThirdByte := P[2];

    inc(p,CharLen);
  until (CharLen=0) or (p^ = #0);
end;

function Char_SomethingString(AnUTF8String:string):String;
var
  p: PChar;
  CharLen: integer;
  FirstByte, SecondByte, ThirdByte: Char;
begin
  Result:='-';
  p := PChar(AnUTF8String);
  repeat
    CharLen := UTF8CodepointSize(p);

    // У нас есть указатель на символ и его длина
    // Для побайтного доступа к UTF-8 символу:
    if CharLen >= 1 then begin
      FirstByte := P[0];
      Result:=Result+FirstByte;
    end;
		if CharLen >= 2 then begin
      SecondByte := P[1];
      Result:=Result+SecondByte;
    end;
		if CharLen >= 3 then begin
      ThirdByte := P[2];
      Result:=Result+ThirdByte;
		end;
    Result:=Result+'-';
    inc(p,CharLen);
  until (CharLen=0) or (p^ = #0);
end;


procedure TfrmLaziStrings.Button1Click(Sender: TObject);
begin
  lblFirst.Caption:=Char_SomethingString('Рус10-Rus');
end;


function IterateUTF8Characters(const AnUTF8String:string):String;
var
  p: PChar;
  unicode: Cardinal;
  CharLen: integer;
begin
  Result:='';
  p:=PChar(AnUTF8String);
  repeat
    unicode:=UTF8CodepointToUnicode(p,CharLen);
    Result:=Result+IntToStr(unicode)+' ';
    inc(p,CharLen);
  until (CharLen=0) or (unicode=0);
end;


procedure TfrmLaziStrings.Button2Click(Sender: TObject);
var
  c:String='Рус10-Rus';
begin
  lblFirst.Caption:=c;
  lblSecond.Caption:=IterateUTF8Characters(c);
end;

procedure TfrmLaziStrings.Button3Click(Sender: TObject);
var
  p: Pointer;
  s: String='Рус10-Rus';
  //pch: Pchar='Рус10-Rus';
  n,I: Integer;

begin
  //GetMem(p,128);
  I := 2004;
  p := @I; { point to I }
  n:=SizeOf(I);
  lblFirst.Caption:=IntToStr(n);
  p := @s;
  n:=SizeOf(s);
  lblSecond.Caption:=IntToStr(n);
  //FreeMem(p,128);
end;

procedure TfrmLaziStrings.Button4Click(Sender: TObject);
var
I: Integer;
C: Char;
P: Pointer; { untyped pointer }
begin
I := 2004;
C := 'd';
P := @I; { point to I }
{ typecast to an integer pointer, dereference and increment }
Inc(PInteger(P)^);
lblFirst.Caption:='I = '+IntToStr(PInteger(P)^);
P := @C; { point to C }
{ typecast to a char pointer, dereference and convert to 'D' }
PChar(P)^ := Chr(Ord(PChar(P)^) - 32);
lblSecond.Caption:='C = '+PChar(P)^;
end;

procedure TfrmLaziStrings.Button5Click(Sender: TObject);
var
  pI: ^Integer;
  pR: ^Real;
  p: Pointer;
begin
  New(pI);
  New(pR);
  GetMem(p,128);

  pI^:=2;
  lblFirst.Caption:='pI^ = '+IntToStr(pI^);
  pR^:=2*3.1415926;
  lblSecond.Caption:='pR^ = '+FloatToStrF(pR^,ffGeneral,12,8);

  p:=pI;
  pR:=p;
  //lblSecond.Caption:='pR^ = '+FloatToStrF(pR^,ffGeneral,12,8);

  FreeMem(p,128);
  Dispose(pR);
  Dispose(pI);
end;

procedure TfrmLaziStrings.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLaziStrings.FormCreate(Sender: TObject);
begin
  {$IFDEF wince}
    BorderStyle:=bsNone;
    Width:=800;
    Height:=480;
    Top:=0;
    Left:=0;
  {$ELSE}
    Width:=800;
    Height:=480;
    Position:=poScreenCenter;
  {$ENDIF}
  lblFirst.Top:=11;
  lblFirst.Left:=14;
  lblSecond.Top:=48;
  lblSecond.Left:=14;
end;

end.

