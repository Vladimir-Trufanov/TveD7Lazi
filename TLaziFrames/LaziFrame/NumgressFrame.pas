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
    StaticText1: TStaticText;
    procedure FrameClick(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
    procedure stClick(Sender: TObject);
  private

  public

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

end.

