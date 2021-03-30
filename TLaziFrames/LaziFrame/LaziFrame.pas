unit LaziFrame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, ComCtrls, ExtCtrls, Dialogs;

type

  { TframeLazi }

  TframeLazi = class(TFrame)
    Panel1: TPanel;
    procedure FrameEnter(Sender: TObject);
    procedure FrameExit(Sender: TObject);
  private

  public
    procedure ObjectsFree;
  end;

implementation

{$R *.lfm}

{ TframeLazi }

procedure TframeLazi.FrameEnter(Sender: TObject);
begin

end;

procedure TframeLazi.FrameExit(Sender: TObject);
begin
end;

procedure TframeLazi.ObjectsFree;
begin
  //ShowMessage(Self.Name);
  // if assigned(fl) then begin

  {fl.ObjectsFree;} Self.Free; Self:=NIL;

  // end;


end;


end.

