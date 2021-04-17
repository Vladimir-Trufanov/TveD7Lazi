unit ModalFrm;

{$mode objfpc}

interface

uses
  Windows,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

			{ TfrmModal }

      TfrmModal = class(TForm)
						Button1: TButton;
						Button2: TButton;
						Memo1: TMemo;
						procedure Button1Click(Sender: TObject);
						procedure Button2Click(Sender: TObject);
      private

      public

      end;

var
      frmModal: TfrmModal;

implementation

{$R *.lfm}

{ TfrmModal }

procedure TfrmModal.Button1Click(Sender: TObject);
var
  p : array[0 .. 255] of WideChar;
begin
  if IsWindowVisible(Handle) and (GetParent(Handle) = 0)then
  begin
    GetWindowTextW(Handle, p, 256);
    if Length(Trim(StrPas(p))) > 0
    then frmModal.Memo1.Lines.Add(IntToStr(Handle) + ' -> ' + p);
  end;
end;

// Получить наименование каталога, с которого запущена программа
function ExePath(): widestring;
var
  Str: widestring;
  I: Integer;
begin
  Str := ParamStr (0);
  for I := Length (Str) downto 1 do
  if Str[I] = '\' then begin
    Str := Copy (Str, 1, I);
    Break;
  end;
  Result := Str;
end;

procedure TfrmModal.Button2Click(Sender: TObject);
type
  // Кодовая страница для ANSI-кириллицы - 1251
  CyrillicString = type AnsiString(1251);
var
  cLine: String;
  cPChar: PChar;
  cwch: WideChar;
  A: AnsiString;
  U: UnicodeString;
  U8: UTF8String;
  C: CyrillicString;
begin
  cLine:=ExePath()+': CodePage='+IntToStr(StringCodePage(ExePath()));
  frmModal.Memo1.Clear;
  frmModal.Memo1.Lines.Add(cLine);
  frmModal.Memo1.Lines.Add(ExePath()+': CodePage='+IntToStr(StringCodePage(ExePath())));
  //cPChar:=cLine;
  //frmModal.Memo1.Lines.Add(cPChar);
  //cwch:=cLine;
  //frmModal.Memo1.Lines.Add(cwch);

  A := 'This is an AnsiString';
  frmModal.Memo1.Lines.Add('AnsiString Codepage: ' + IntToStr(StringCodePage(A)));
  U := 'This is a UnicodeString';
  frmModal.Memo1.Lines.Add('UnicodeString Codepage: ' + IntToStr(StringCodePage(U)));
  U8 := 'This is a UTF8string';
  frmModal.Memo1.Lines.Add('UTF8string Codepage: ' + IntToStr(StringCodePage(U8)));
  C := 'This is a CyrillicString';
  frmModal.Memo1.Lines.Add('CyrillicString Codepage: ' + IntToStr(StringCodePage(C)));

end;

end.

