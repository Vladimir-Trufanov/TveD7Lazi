// Индикатор событий и процессов
unit NumgressFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls;

type

  { TframeNumgress }

  TframeNumgress = class(TFrame)
    pnlText: TPanel;
    pnlBar: TPanel;
    pbar: TProgressBar;
    stat: TStaticText;
    st: TStaticText;
    procedure FrameClick(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
    procedure stClick(Sender: TObject);
  private
    // Обеспечить доступ к свойству "Заголовок события/сообщение"
    procedure SetCaption(Value:String);
    function GetCaption:String;
  public
  published
    // Свойство "Заголовок события/сообщение"
    property Caption:String read GetCaption write SetCaption;
  end;

implementation

{$R *.lfm}

{ TframeNumgress }

procedure TframeNumgress.FrameEnter(Sender: TObject);
begin
  // Настраиваем компоненты изображения
  pnlBar.Height:=20;
  stat.Width:=50;
  stat.Caption:=' ';
  stat.Align:=alLeft;
  pbar.Align:=alClient;
  pnlText.Height:=pnlBar.Height;
end;

procedure TframeNumgress.FrameClick(Sender: TObject);
begin

end;

procedure TframeNumgress.FrameExit(Sender: TObject);
begin
  //
end;

procedure TframeNumgress.stClick(Sender: TObject);
begin

end;


{  ............................ ДОСТУП К СВОЙСТВАМ ...........................}

// Обеспечить доступ к свойству "Заголовок события/сообщение"
procedure TframeNumgress.SetCaption(Value:String);
begin
  Self.st.Caption:=Value;
end;
function TframeNumgress.GetCaption:String;
begin
  Result:=Self.st.Caption;
end;


end.
