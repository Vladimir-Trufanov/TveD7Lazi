unit ModeLessFrm;

{$mode objfpc}{$H+}{$codepage UTF8}

interface

uses
  Windows,
      Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls;

type

			{ TfrmModeless }

      TfrmModeless = class(TForm)
						Button1: TButton;
						ListView1: TListView;
						procedure Button1Click(Sender: TObject);
      private
            function GetTitle: String;

      public

      end;

var
      frmModeless: TfrmModeless;

implementation

{$R *.lfm}

{ TfrmModeless }

function TfrmModeless.GetTitle: String;
var
  l: Integer;
  AnsiBuffer: string;
  WideBuffer: WideString;
begin

{$ifdef WindowsUnicodeSupport}

if UnicodeEnabledOS then
begin
  l := Windows.GetWindowTextLengthW(Handle);
  SetLength(WideBuffer, l);
  l := Windows.GetWindowTextW(Handle, @WideBuffer[1], l);
  SetLength(WideBuffer, l);
  Result := Utf8Encode(WideBuffer);
end
else
begin
  l := Windows.GetWindowTextLength(Handle);
  SetLength(AnsiBuffer, l);
  l := Windows.GetWindowText(Handle, @AnsiBuffer[1], l);
  SetLength(AnsiBuffer, l);
  Result := AnsiToUtf8(AnsiBuffer);
end;

{$else}

   l := Windows.GetWindowTextLength(Handle);
   SetLength(Result, l);
   Windows.GetWindowText(Handle, @Result[1], l+6);

{$endif}

end;

procedure TfrmModeless.Button1Click(Sender: TObject);
var
  l:integer;
  cs:String;
  Form: HWnd;
  {$IFDEF wince}
  WindowCaption: PWideChar;
  {$ELSE}
  WindowCaption: PChar;
  {$ENDIF}
begin
  //caption:='***'+GetTitle+'***';
  WindowCaption:='frmLaziWinCEрус';
  Form := FindWindow (nil, WindowCaption);
  if Form <> 0 then begin

  
   l := Windows.GetWindowTextLength(Form);
   SetLength(cs, l);
   Windows.GetWindowText(Form, @cs[1], l);
   Caption:=WindowCaption+' exist';


     //GetWindowText(Form,WindowCaption,100);
    //Caption:=WindowCaption+' exist';

    //ShowWindow (Form, SW_SHOW);
    //SetForegroundWindow (Form);
    //ExitProcess (0);
  end;
end;

end.

