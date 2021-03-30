unit GuideFrm;

{$mode objfpc}{$H+}

interface

uses
  GuideFrame,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus;

type

  { TfrmGuide }

  TfrmGuide = class(TForm)
    mmiCloseFrame: TMenuItem;
    mmiGetMessage: TMenuItem;
    mmiLoadFrame: TMenuItem;
    mm: TMainMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mmiCloseFrameClick(Sender: TObject);
    procedure mmiGetMessageClick(Sender: TObject);
    procedure mmiLoadFrameClick(Sender: TObject);
  private
    fr: TframeGuide;
  public

  end;

var
  frmGuide: TfrmGuide;

implementation

{$R *.lfm}

{ TfrmGuide }

procedure TfrmGuide.FormCreate(Sender: TObject);
begin
  //
end;

procedure TfrmGuide.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TfrmGuide.mmiLoadFrameClick(Sender: TObject);
begin
  if not assigned(fr) then begin
    fr:=TframeGuide.Create(self);
    fr.Parent:=self;
  end;
  fr.SetFocus;
end;

procedure TfrmGuide.mmiCloseFrameClick(Sender: TObject);
begin
  // Уничтожаем фрэйм
  fr.Free; //fr.Destroy;
  // Отмечаем, что фрэйм уже не назначен
  fr:=NIL;
end;

procedure TfrmGuide.mmiGetMessageClick(Sender: TObject);
begin
  if assigned(fr)
  then Showmessage('fr.Notice')
  else ShowMessage('Фрэйм не установлен!');
end;

end.

