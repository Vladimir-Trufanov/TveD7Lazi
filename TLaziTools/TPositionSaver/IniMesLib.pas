// DELPHI7, WIN98\XP                                      *** IniMesLib.pas ***

// ****************************************************************************
// *      ������� ��������� �� ������/�������������� �� ������ ����������     *
// ****************************************************************************

//                                                   �����:       �������� �.�.
//                                                   ���� ��������:  28.12.2004
// Copyright � 2004 TVE                              ����.���������: 26.10.2005

// ���������
//
//   function IniMessage(nNumber:Integer; cMessage,cModulName:String): Byte;

// ���������
//
//   nNumber - ����� ��������� (������ 3 ���������: 1<=nnn<500,  ��������������
// ��� ���������� ����������; 500<=nnn<=999, ������ � ����������� ����������)
//   cMessage - ����� ���������
//   cModulName - ������������ ������, ��������������� ���������

// ������������ ��������
//
//   Result = 0, ������� ��������� �������

unit IniMesLib;

interface

uses
  Dialogs,Forms,SysUtils;

function IniMessage(nNumber:Integer; cMessage,cModulName:String): Byte;

implementation

// ****************************************************************************
// *         ������� ��������� � ��������/���������� ������ ����������        *
// ****************************************************************************

function IniMessage(nNumber:Integer; cMessage,cModulName:String): Byte;

begin
  Result:=0;
  MessageDlg(cModulName+' ['+IntToStr(nNumber)+'] '+chr(13)+chr(10)+
    cMessage+'!',mtError,[mbOk],0);
  if nNumber>=500 then begin
    Application.Terminate;
  end;
end;

end.

// ********************************************************** IniMesLib.pas ***
