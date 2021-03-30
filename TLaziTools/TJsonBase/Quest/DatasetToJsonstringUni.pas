// LAZARUS, WIN-10\XP                                      *** UtilsUni.pas ***

// ****************************************************************************
// * SENSERVER:                           Блок обслуживающих Senserver утилит *
// ****************************************************************************

//                                                   Дата создания:  15.09.2014
// Copyright © 2014 ООО "РИЦ ЖХ"                     Посл.изменение: 14.04.2016

unit DatasetToJsonStringUni;

interface

uses
  Classes,SysUtils,db,superobject;

function DatasetToJsonString(Q: TDataset): String;

implementation

uses
  TypInfo;

function IniDateToStr(Value: TDateTime): String;
var
  FS: TFormatSettings;
begin
  FS := DefaultFormatSettings;
  FS.DateSeparator := '-';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.ShortTimeFormat := 'hh:nn:ss,zzz';
  FS.TimeSeparator := ':';
  Result := FormatDateTime('yyyy-mm-dd', Value, FS);
end;

function IniDateTimeToStr(Value: TDateTime): String;
var
  FS: TFormatSettings;
begin
  FS := DefaultFormatSettings;
  FS.DateSeparator := '-';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.ShortTimeFormat := 'hh:nn:ss,zzz';
  FS.TimeSeparator := ':';
  Result := FormatDateTime('yyyy-mm-dd', Value, FS) +
    'T' + FormatDateTime('hh:nn:ss,zzz', Value, FS);
end;

function QuotedStr(const S: String): String;
var
  i, j, Count: Integer;
begin
  Result := '';
  Count := Length(s);
  i := 0; j := 0;
  while i < count do begin
    i := i + 1;
    case S[i] of
      '"', '\': begin
        result := result + copy(S, 1 + j, i - j - 1) + '\' + S[i];
        j := i;
      end;
    end;
  end;
  if i <> j then
    result := result + copy(S, 1 + j, i - j);
end;

// ****************************************************************************
// *               Переложить выбранный набор данных в JSON - строку          *
// ****************************************************************************
function DatasetToJsonString(Q: TDataset): String;
var
  i, j: Integer;
  s, Data: String;
  FS: TFormatSettings;
begin
  FS := DefaultFormatSettings;
  FS.DateSeparator := '-';
  FS.ShortDateFormat := 'yyyy-mm-dd';
  FS.ShortTimeFormat := 'hh:nn:ss,zzz';
  FS.TimeSeparator := ':';
  FS.DecimalSeparator := '.';
  for i := 0 to Q.FieldDefs.Count - 1 do begin
    Data := Format('"%s":["%s",%d,%s,%d]', [Q.FieldDefs[i].Name,
      GetEnumName(TypeInfo(TFieldType), Ord(Q.FieldDefs[i].DataType)),
      Q.FieldDefs[i].Size,
      LowerCase(BoolToStr(Q.FieldDefs[i].Required, True)),
      Q.Fields[i].DisplayWidth]);
    if i = 0 then
      Result := '[{' + Data
    else
      Result := Result + ',' + Data;
  end;
  Result := Result + '}';
  Q.First;
  while not Q.Eof do begin
    j := 0;
    for i := 0 to Q.FieldDefs.Count - 1 do begin
      if not Q.Fields[i].IsNull then begin
        case Q.Fields[i].DataType of
          ftDate:
            Data := IniDateToStr(Q.Fields[i].AsDateTime);
          ftDateTime:
            Data := IniDateTimeToStr(Q.Fields[i].AsDateTime);
          ftCurrency:
            Data := CurrToStr(Q.Fields[i].AsCurrency, FS);
          ftFloat:
            Data := FloatToStr(Q.Fields[i].AsFloat, FS);
          ftInteger:
            Data := IntToStr(Q.Fields[i].AsInteger);
          ftLargeint:
            Data := IntToStr(Q.Fields[i].AsLargeInt);
        else
          Data := QuotedStr(Q.Fields[i].AsString);
        end;
        Data := Format('"%s":"%s"', [Q.FieldDefs[i].Name, Data]);
        if j = 0 then
          s := Data
        else
          s := s + ',' + Data;
        Inc(j);
      end;
    end;
    if s <> '' then
      Result := Result + Format(',{%s}', [s]);
    Q.Next;
  end;
  Result := Result + ']';
end;

end.

// *********************************************************** UtilsUni.pas ***

