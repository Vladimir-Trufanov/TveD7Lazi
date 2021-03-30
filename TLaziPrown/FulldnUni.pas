// LAZARUS [DELPHI7], WIN10\XP                            *** FullDnUni.pas ***

// ****************************************************************************
// * TLaziPrown [1300]       ������������� ����� ������������� ����� � ������ *
// *      � �������� ������ ��������, ����������� ����� ��������-������������ *
// * (�� ���������  ���������� �����, ����������� �������� ��� �������������) *
// ****************************************************************************

//                                                   �����:       �������� �.�.
//                                                   ���� ��������:  26.03.2003
// Copyright � 2003 TVE                              ����.���������: 26.01.2006

// ���������
//
//   function FullDn(nNumber:Integer;
//     nLength:Integer=2; cFill:Char=' '):String; safecall;
//
// ���������
//
//   nNumber - �����, �������������� ��� ��������������
//   nLength - ���������� ��������, ������������ ������
//   cFill - ������-�����������

// ������������ �������� �������� nLength "���������", ���� ����� �����������
//   � ��������� ������������� �������� ����� ��������

unit FulldnUni;

interface

uses Math,SysUtils,Windows;

function
FullDn(nNumber:Integer; nLength:Integer=2; cFill:Char='0'):String; safecall;

implementation

function
FullDn(nNumber:Integer; nLength:Integer=2; cFill:Char='0'):String; safecall;
var
  cBuffer: String;
begin
  // ���� ����� ��������� �������� ������, �� ���������� "���������"
  if nNumber>(IntPower(10,nLength)-1) then begin
    FullDn:=StringOfChar('*',nLength);
  end

  else begin
    cBuffer:=StringOfChar(cFill,nLength);
    cBuffer:=cBuffer+IntToStr(nNumber);
    FullDn:=copy(cBuffer,Length(cBuffer)-nLength+1,nLength);
  end;
end;
end.

// ********************************************************** FullDnUni.pas ***
