// LAZARUS [DELPHI7], WIN10\XP                            *** SubStrUni.pas ***

// ****************************************************************************
// * Td7Prown [1400]                    �������� ��������� �� �������� ������ *
// ****************************************************************************

//                                   ������: ����������� �������, �������� �.�.
//                                   ���� ��������:                  20.04.2004
// Copyright � 2004 TVE              ����.���������:                 26.08.2017

// ���������
//
// function SubStr(cFromStr:string; nPoint:integer; nWidth:integer=0):string;
//
// ���������
//
//   cFromStr - �������� ������,
//   nPoint - ������� ������ ���������,
//   nWidth - ����� ���������.

unit SubstrUni;

interface

function SubStr(cFromStr: string; nPoint: integer; nWidth: integer = 0): string;

implementation

function SubStr(cFromStr: string; nPoint: integer; nWidth: integer): string;
begin
  if (nPoint < 1) or (nWidth < 0) then begin
    Result := '';
    exit;
  end;
  if nWidth > 0 then  // ���� ������ ����� ���������
    Result := copy(cFromStr, nPoint, nWidth)
  else  // ��� �� ����� ������
    Result := copy(cFromStr, nPoint, length(cFromStr) + 1 - nPoint);
end;

end.

// ********************************************************** SubStrUni.pas ***
