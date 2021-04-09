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
						Button1: TButton;
						lblSecond: TLabel;
						lblFirst: TLabel;
						procedure btnCloseClick(Sender: TObject);
      procedure btnWideStringV1Click(Sender: TObject);
						procedure btnWideStringV2Click(Sender: TObject);
						procedure Button1Click(Sender: TObject);
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
  w:='РусRus';
  // FPC в Caption вкладывает как AnsiString (поэтому выводит неправильно)
  lblFirst.Caption:=w;
  // AnsiString преобразоваем в UnicodeString
  w:=UTF8ToUTF16('РусRus');
  // UnicodeString преобразовываем в AnsiString и вкладываем в Caption
  lblSecond.Caption:=UTF16ToUTF8(w);
end;

procedure TfrmLaziStrings.btnWideStringV2Click(Sender: TObject);
var
  w: widestring;
begin
  w:='РусRus';
  // Неправильно
  lblFirst.Caption:=UTF16ToUTF8(w);
  // Неправильно
  w:='РусRus';
  w:=UTF8ToUTF16(w);
  lblSecond.Caption:=UTF16ToUTF8(w);
end;

procedure TfrmLaziStrings.Button1Click(Sender: TObject);
var
  c: PChar='РусRus';
  w: PWideChar='РусRus';
begin
  lblFirst.Caption:=c;
  lblSecond.Caption:=UTF16ToUTF8(UTF8ToUTF16(UTF16ToUTF8(w,6)));
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

