unit FidirtestFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls,Variants, types;

type

  { TfrmFidirTest }

  TfrmFidirTest = class(TForm)
    btnLoadDir: TButton;
    btnGetArray: TButton;
    btnPutArray: TButton;
    btnAll: TButton;
    GroupBox1: TGroupBox;
    mem: TMemo;
    odLoadDir: TSelectDirectoryDialog;
    procedure btnAllClick(Sender: TObject);
    procedure btnGetArrayClick(Sender: TObject);
    procedure btnPutArrayClick(Sender: TObject);
    procedure btnLoadDirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public

  end;

var
  frmFidirTest: TfrmFidirTest;

implementation

uses
  ArrayFrm,gaFileNamesUni,FidirCheckClass;

var
  FidirCheck: TFidirCheck;

{$R *.lfm}

{ TfrmFidirTest }



procedure TfrmFidirTest.btnLoadDirClick(Sender: TObject);
begin
  if odLoadDir.Execute then begin
    FidirCheck.CheckDir:=odLoadDir.FileName;
    Caption:='FidirCheck "'+FidirCheck.CheckDir+'"';
  end;
end;

procedure TfrmFidirTest.btnGetArrayClick(Sender: TObject);
begin
  FidirCheck.Make;
  FidirCheck.View;
end;

procedure TfrmFidirTest.btnAllClick(Sender: TObject);
begin
  FidirCheck.CheckDir:='c:\res\';
  FidirCheck.Make;
  FidirCheck.View;
  btnPutArrayClick(Sender);
end;

procedure TfrmFidirTest.btnPutArrayClick(Sender: TObject);
  const
    C_FNAME = 'binarydata.bin';
  var
    a: Variant;
    fsOut    : TFileStream;
    ChrBuffer: array[0..255] of char;
    i: Integer;
  begin
    a:=FidirCheck.FilesDir;
    // Перехват ошибок в случае, если файл не может быть создан
    try
      // Создать экземпляр потока файла, записать в него данные и уничтожить его, чтобы предотвратить утечки памяти
      fsOut := TFileStream.Create( C_FNAME, fmCreate);
      for i:=1 to aLen(a) do begin
         ChrBuffer:=String(a[i]);
         fsOut.Write(ChrBuffer,length(String(a[i])));

         {fsOut.Write(ChrBuffer,sizeof(ChrBuffer));
         ShowMessage('iii: '+IntTostr(length(String(a[i])))+
           ' ii: '+IntTostr(length(ChrBuffer))+
           ' ii: '+IntTostr(sizeof(ChrBuffer)));}
      end;
      fsOut.Free;
    // Обработка ошибки
    except
      on E:Exception do
        Showmessage('Файл '+C_FNAME+' не создан, так как: '+E.Message);
    end;
    // Выводим результат операции
    Showmessage('Файл '+C_FNAME+' создан!');
  end;

procedure TfrmFidirTest.FormCreate(Sender: TObject);
begin
  FidirCheck:=TFidirCheck.Create;
  FidirCheck.CheckDir:='c:\TVED7\TLaziPrown\';
  Caption:='FidirCheck "'+FidirCheck.CheckDir+'"';
end;

procedure TfrmFidirTest.FormDestroy(Sender: TObject);
begin
  FidirCheck.Destroy;
end;

end.

