// LAZARUS[DELPHI7], WIN10\XP                                 *** AtUni.pas ***

// ****************************************************************************
// * TLaziPrown [1200]                      ����� ������� ��������� ��������� *
// *                                            ����� ������� � ������ ������ *
// ****************************************************************************

//                                   ������: ����������� �������, �������� �.�.
//                                   ���� ��������:                  19.04.2004
// Copyright � 2004 TVE              ����.���������:                 28.01.2017

// ���������
//
//   function
//     At(cSubStrSeek:string; cFromStr:string; nNumber:integer=1): integer;
//
//   function
//     RAt(cSubStrSeek:string; cFromStr:string; nNumber:integer=1):integer;
//
// ���������
//
//   cSubStrSeek - ������� ���������,
//   cFromStr - �������� ������,
//   nNumber - ����� ���������

// ������������ �������� �������� ������� ��������� �� ������ ���������
//   ���������. � ������, ���� ��������� �� �������, ������������ 0.

unit AtUni;

interface

function At(cSubStrSeek:string; cFromStr:string; nNumber:integer=1):integer;
function RAt(cSubStrSeek:string; cFromStr:string; nNumber:integer=1):integer;

implementation

// ****************************************************************************
// *   ����� ������� ��������� (�� ��������� - �������) ��������� ���������   *
// *    ����� �������. � ������, ���� ��������� �� �������, ������������ 0.   *
// ****************************************************************************

function At(cSubStrSeek:string; cFromStr:string; nNumber:integer):integer;
var
  tmp: string;  // �������� ������
  n: integer;   // ����� ���������
  p: integer;   // ������� �������� ���������
begin
  if nNumber<1 then begin
    Result := 0;
    exit;
  end;
  tmp := cFromStr;
  n := 1;
  p := pos(cSubStrSeek, tmp);  // ������ ��������� ���������
  Result := p;
  // ���� ������� ��������� ��������� � ��� �� ������ ��� �����
  while (p <> 0) and (n <> nNumber) do  begin
    // ������� ��� �� 2-�� ���������� ���������,
    // ����� � ������ "1231231" ������� 2 ��������� "1231".
    tmp := copy(tmp, p + 1, length(tmp) - p);
    {���� ������ ���������� ������ ��������� ���������,
    ����� ������� ��� ��������� � �������� ������ 1 ��������� "1231".
    tmp := copy(tmp, p + length(cSubStrSeek),
      length(tmp) + 1 - p - length(cSubStrSeek));}
    p := pos(cSubStrSeek, tmp);  // ������� ���������� ���������
    inc(n);
    if p > 0 then  // ���� ���� ��������� ���������
      // ������� ������� ���������� ���������
      Result := Result + p;  // ���� ������������ 1-� ������� ��������
                             // ��������� ��������� (������ �� 2-�� �� �������)
      {���� ������������ 2-� ������� (��� ��������� ��������)
      Result := Result + p + length(cSubStrSeek) - 1;}
  end;
  // ���� ���������� ������������ ��������� �� ����, ��������� ����� 0
  if p = 0 then
    Result := 0;
end;

// ****************************************************************************
// *   ����� ������� ��������� (�� ��������� - �������) ��������� ���������   *
// *    ������ ������. � ������, ���� ��������� �� �������, ������������ 0.   *
// ****************************************************************************

function RAt(cSubStrSeek:string; cFromStr:string; nNumber:integer): integer;
var
  From, Sub: string;  // �������� � ������� ������
  c: char;  // ��������� ������
  i: word;  // ������� ������� � ������
  l: word;  // ����� ������
begin
  From := cFromStr;
  Sub := cSubStrSeek;
  // ���������� ������
  l := length(Sub);
  i := l div 2;
  while i > 0 do begin
    c := Sub[i];
    Sub[i] := Sub[l + 1 - i];
    Sub[l + 1 - i] := c;
    dec(i);
  end;
  l := length(From);
  i := l div 2;
  while i > 0 do begin
    c := From[i];
    From[i] := From[l + 1 - i];
    From[l + 1 - i] := c;
    dec(i);
  end;
  // ������� ������� ��� ������������ �����
  Result := At(Sub, From, nNumber);
  if Result <> 0 then  // ���� ���� ��������� � ������������ ������,
    Result := l + 2 - Result - length(Sub);  // �������� �� ����� � ��������
end;

end.

// ************************************************************** AtUni.pas ***
