unit LaziStringsFrm;

{$mode objfpc}{$H+}{$codepage UTF8}

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
		btnViewCodes: TButton;
		btnPointer: TButton;
		lblSecond: TLabel;
		lblFirst: TLabel;
	  procedure btnCloseClick(Sender: TObject);
    // Учесть особенности обмена AnsiString с WideString
    procedure btnWideStringV1Click(Sender: TObject);
	  procedure btnWideStringV2Click(Sender: TObject);
    // Найти подстроку (String::=AnsiString)
	  procedure btnWhereStringClick(Sender: TObject);
    // Обработать нетипизированный указатель
    procedure btnPointerClick(Sender: TObject);
    // Получить коды символов
    procedure btnViewCodesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  frmLaziStrings: TfrmLaziStrings;

implementation

{$R *.lfm}

{ TfrmLaziStrings }

// Учесть особенности обмена AnsiString с WideString
procedure TfrmLaziStrings.btnWideStringV1Click(Sender: TObject);
var
  w: widestring;
begin
  // FPC преобразовывает системную кодовую страницу в UTF16 = UnicodeString
  w:='Рус10-Rus';
  // FPC в Caption вкладывает как AnsiString
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
  lblFirst.Caption:=UTF16ToUTF8(w);
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
// Обработать нетипизированный указатель
procedure TfrmLaziStrings.btnPointerClick(Sender: TObject);
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
// Получить коды символов
procedure TfrmLaziStrings.btnViewCodesClick(Sender: TObject);
var
  c: String;
  cs: String    ='Рус10-Rus';
  cws: WideString ='Рус10-Rus';
  c4s: UCS4String;

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

begin
  lblFirst.Caption:=cs;
  lblSecond.Caption:=IterateUTF8Characters(cs);
end;
//
procedure TfrmLaziStrings.btnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;
//
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

