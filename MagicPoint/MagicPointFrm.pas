unit MagicPointFrm;

// http://www.win-ni.narod.ru/lect/progListView.htm

{$mode objfpc}{$H+}

interface

uses
  Loger, Windows,
  FilesFrm, RamFrm,
  Math,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

			{ TfrmMagicPoint }

      TfrmMagicPoint = class(TForm)
        btnFiles: TButton;
				btnRam: TButton;
				btnExit: TButton;
				lblMess: TLabel;
				pnlTop: TPanel;
				pnlButtom: TPanel;
				procedure btnExitClick(Sender: TObject);
				procedure btnFilesClick(Sender: TObject);
				procedure btnRamClick(Sender: TObject);
        procedure FormCreate(Sender: TObject);
      private
        oLog: TLoger;
      public
      end;

var
      frmMagicPoint: TfrmMagicPoint;

implementation


// Получить наименование каталога,
// с которого запущена программа
function ExePath(): widestring;
var Str: widestring;
  I: Integer;
begin
  Str := ParamStr (0);
  for I := Length (Str) downto 1 do
    if Str[I] = '\' then
    begin
      Str := Copy (Str, 1, I);
      Break;
    end; {if}
  Result := Str;
end;


{$R *.lfm}

{ TfrmMagicPoint }

procedure TfrmMagicPoint.FormCreate(Sender: TObject);
var
  nButLen:Integer=200;  // длина кнопки
  nDelta:Integer;       // длина промежутка между кнопками
  iStr: widestring;

  h: HWnd;
  cStr: Pwidechar;//PChar;
begin
  iStr:=ExePath();
  //lblMess.Caption:=iStr;
  //oLog:=TLoger.Create(PChar(iStr));
  oLog:=TLoger.Create();
  nDelta:=Floor((770-80-600)/2);  // длина промежутка между кнопками
  Width:=770;
  Height:=440;
  Position:=poScreenCenter;
  pnlTop.Width:=Width-8;
  pnlTop.Left:=8;
  pnlTop.Top:=0;
  pnlButtom.Left:=0;
  pnlButtom.Width:=Width;
  pnlButtom.Height:=33;
  btnFiles.Width:=nButlen;
  btnFiles.Left:=40;
  btnRam.Width:=nButlen;
  btnRam.Left:=40+nButlen+nDelta;
  btnExit.Width:=nButlen;
  btnExit.Left:=40+nButlen+nButlen+nDelta+nDelta;
  {$IFDEF wince}
    BorderStyle:=bsNone;
  {$ELSE}
    BorderStyle:=bsSizeable;
  {$ENDIF}

  oLog.Log('Новое сообщение!');
  oLog.Destroy;


  h:=GetActiveWindow;
  GetWindowText(h,cStr,100);
  //cStr:='qwer';
  //ShowMessage('UTF16ToUTF8(sei.lpFile)');
  //ShowMessage(cStr);
  //MessageBox(h,'Txt','Caption',1);
  MessageBox(h,cStr,'Caption',1);
  //iStr:=string(cStr);
  //lblMess.Caption:=cStr;
end;

procedure TfrmMagicPoint.btnExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMagicPoint.btnFilesClick(Sender: TObject);
begin
  frmFiles.ShowModal
end;

procedure TfrmMagicPoint.btnRamClick(Sender: TObject);
begin
  //frmRam.ShowModal;
  lblMess.Caption:=ExePath();
  //Caption:=GetCurrentDir;
end;

end.

