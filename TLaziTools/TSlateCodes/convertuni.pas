// LAZARUS, WIN-8\XP                                     *** СonvertUni.pas ***

// ****************************************************************************
// * TD7PROWN:                  Выполнить разноформатные преобразования строк *
// ****************************************************************************

//                                          Авторы: Хлыстов О.В., Труфанов В.Е.
// Copyright © 2014 tve                     Дата создания:           15.09.2014
// Copyright © 2014 hovadur                 Посл.изменение:          24.09.2014

unit convertuni;

interface

function  UTF8StringToWideString(const S: AnsiString): WideString;
function  WideStringToUTF8String(const S: WideString): AnsiString;
function  _UW(const S: AnsiString): WideString;
function  _WU(const S: WideString): AnsiString;
function UTF8ToCP1251(const s: string): string;
function CP1251ToUTF8(const s: string): string;

function PUtf8ToA(const s: String; IsParadox: Boolean): String;
function AToUtf8P(const s: String; IsParadox: Boolean): String;
function Utf8ToAP(const s: String; IsParadox: Boolean): String;
function PAToUtf8(const s: String; IsParadox: Boolean): String;
function Utf8ToA(const s: AnsiString): String;
function AToUtf8(const s: String): AnsiString;
function _AW(const s: AnsiString): String;
function _WA(const s: String): AnsiString;

implementation

uses
  SysUtils;

resourcestring
  SInvalidCodePoint        = '$%x is not a valid %s code point';
  SLongStringConvertError  = 'Long string conversion error';

{                                                                              }
{ US-ASCII String functions                                                    }
{                                                                              }
function IsUSASCIIString(const S: AnsiString): Boolean;
var I : Integer;
    P : PAnsiChar;
begin
  P := Pointer(S);
  For I := 1 to Length(S) do
    if Ord(P^) >= $80 then
      begin
        Result := False;
        exit;
      end
    else
      Inc(P);
  Result := True;
end;

{                                                                              }
{ UTF-8 character conversion functions                                         }
{                                                                              }

type
  TUTF8Error = (
      UTF8ErrorNone,
      UTF8ErrorInvalidEncoding,
      UTF8ErrorIncompleteEncoding,
      UTF8ErrorInvalidBuffer,
      UTF8ErrorOutOfRange );

  TUnicodeToCharID = function(Unicode: cardinal): integer;
  TCharToUTF8Table = array[ansichar] of PAnsiChar;
  {$IFNDEF FPC}
  DWord   = LongWord;
  PtrUInt = DWord;
  {$ENDIF FPC}


{ UTF8ToUCS4Char returns UTF8ErrorNone if a valid UTF-8 sequence was decoded   }
{ (and Ch contains the decoded UCS4 character and SeqSize contains the size    }
{ of the UTF-8 sequence). If an incomplete UTF-8 sequence is encountered, the  }
{ function returns UTF8ErrorIncompleteEncoding and SeqSize > Size. If an       }
{ invalid UTF-8 sequence is encountered, the function returns                  }
{ UTF8ErrorInvalidEncoding and SeqSize (<= Size) is the size of the            }
{ invalid sequence, and Ch may be the intended character.                      }
function UTF8ToUCS4Char(const P: PAnsiChar; const Size: Integer;
    out SeqSize: Integer; out Ch: UCS4Char): TUTF8Error;
var C, D : Byte;
    V    : LongWord;
    I    : Integer;
begin
  if not Assigned(P) or (Size <= 0) then
    begin
      SeqSize := 0;
      Ch := 0;
      Result := UTF8ErrorInvalidBuffer;
      exit;
    end;
  C := Ord(P^);
  if C < $80 then
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorNone;
      exit;
    end;
  // multi-byte characters always start with 11xxxxxx ($C0)
  // following bytes always start with 10xxxxxx ($80)
  if C and $C0 = $80 then
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorInvalidEncoding;
      exit;
    end;
  if C and $20 = 0 then // 2-byte sequence
    begin
      SeqSize := 2;
      V := C and $1F;
    end else
  if C and $10 = 0 then // 3-byte sequence
    begin
      SeqSize := 3;
      V := C and $0F;
    end else
  if C and $08 = 0 then // 4-byte sequence (max needed for Unicode $0-$1FFFFF)
    begin
      SeqSize := 4;
      V := C and $07;
    end else
    begin
      SeqSize := 1;
      Ch := C;
      Result := UTF8ErrorInvalidEncoding;
      exit;
    end;
  if Size < SeqSize then // incomplete
    begin
      Ch := C;
      Result := UTF8ErrorIncompleteEncoding;
      exit;
    end;
  For I := 1 to SeqSize - 1 do
    begin
      D := Ord(P[I]);
      if D and $C0 <> $80 then // following byte must start with 10xxxxxx
        begin
          SeqSize := 1;
          Ch := C;
          Result := UTF8ErrorInvalidEncoding;
          exit;
        end;
      V := (V shl 6) or (D and $3F); // decode 6 bits
    end;
  Ch := V;
  Result := UTF8ErrorNone;
end;

function UTF8ToWideChar(const P: PAnsiChar; const Size: Integer;
    out SeqSize: Integer; out Ch: WideChar): TUTF8Error;
var Ch4 : UCS4Char;
begin
  Result := UTF8ToUCS4Char(P, Size, SeqSize, Ch4);
  if Ch4 > $FFFF then
    begin
      Result := UTF8ErrorOutOfRange;
      Ch := #$0000;
    end else
    Ch := WideChar(Ch4);
end;

{ UCS4CharToUTF8 transforms the UCS4 char Ch to UTF-8 encoding. SeqSize        }
{ returns the number of bytes needed to transform Ch. Up to DestSize           }
{ bytes of the UTF-8 encoding will be placed in Dest.                          }
procedure UCS4CharToUTF8(const Ch: UCS4Char; const Dest: Pointer;
    const DestSize: Integer; out SeqSize: Integer);
var P : PByte;
begin
  P := Dest;
  if Ch < $80 then // US-ASCII (1-byte sequence)
    begin
      SeqSize := 1;
      if not Assigned(P) or (DestSize <= 0) then
        exit;
      P^ := Byte(Ch);
    end else
  if Ch < $800 then // 2-byte sequence
    begin
      SeqSize := 2;
      if not Assigned(P) or (DestSize <= 0) then
        exit;
      P^ := $C0 or Byte(Ch shr 6);
      if DestSize = 1 then
        exit;
      Inc(P);
      P^ := $80 or (Ch and $3F);
    end else
  if Ch < $10000 then // 3-byte sequence
    begin
      SeqSize := 3;
      if not Assigned(P) or (DestSize <= 0) then
        exit;
      P^ := $E0 or Byte(Ch shr 12);
      if DestSize = 1 then
        exit;
      Inc(P);
      P^ := $80 or ((Ch shr 6) and $3F);
      if DestSize = 2 then
        exit;
      Inc(P);
      P^ := $80 or (Ch and $3F);
    end else
  if Ch < $200000 then // 4-byte sequence
    begin
      SeqSize := 4;
      if not Assigned(P) or (DestSize <= 0) then
        exit;
      P^ := $F0 or Byte(Ch shr 18);
      if DestSize = 1 then
        exit;
      Inc(P);
      P^ := $80 or ((Ch shr 12) and $3F);
      if DestSize = 2 then
        exit;
      Inc(P);
      P^ := $80 or ((Ch shr 6) and $3F);
      if DestSize = 3 then
        exit;
      Inc(P);
      P^ := $80 or (Ch and $3F);
    end
  else
    raise EConvertError.CreateFmt(SInvalidCodePoint, [Ord(Ch), 'Unicode']);
end;

function WideBufToUTF8Size(const Buf: PWideChar; const Len: Integer): Integer;
var P : PWideChar;
    I : Integer;
    C : UCS4Char;
begin
  P := Buf;
  Result := 0;
  For I := 1 to Len do
    begin
      C := UCS4Char(P^);
      Inc(Result);
      if C >= $80 then
        if C >= $800 then
          Inc(Result, 2) else
          Inc(Result);
      Inc(P);
    end;
end;

function WideToLongString(const P: PWideChar; const Len: Integer): AnsiString;
var I : Integer;
    S : PWideChar;
    Q : PAnsiChar;
    V : WideChar;
begin
  if Len <= 0 then
    begin
      Result := '';
      exit;
    end;
  SetLength(Result, Len);
  S := P;
  Q := Pointer(Result);
  For I := 1 to Len do
    begin
      V := S^;
      if Ord(V) > $FF then
        raise EConvertError.Create(SLongStringConvertError);
      Q^ := AnsiChar(Byte(V));
      Inc(S);
      Inc(Q);
    end;
end;

function WideBufToUTF8String(const Buf: PWideChar; const Len: Integer): AnsiString;
var P     : PWideChar;
    Q     : PAnsiChar;
    I, M,
    N, J  : Integer;
begin
  if Len = 0 then
    begin
      Result := '';
      exit;
    end;
  N := WideBufToUTF8Size(Buf, Len);
  if N = Len then // optimize for US-ASCII strings
    begin
      Result := WideToLongString(Buf, Len);
      exit;
    end;
  SetLength(Result, N);
  P := Buf;
  Q := Pointer(Result);
  M := 0;
  For I := 1 to Len do
    begin
      UCS4CharToUTF8(UCS4Char(P^), Q, N, J);
      Inc(P);
      Inc(Q, J);
      Dec(N, J);
      Inc(M, J);
    end;
  SetLength(Result, M); // actual size
end;

{                                                                              }
{ Long string functions                                                        }
{                                                                              }
procedure LongToWide(const Buf: Pointer; const BufSize: Integer;
    const DestBuf: Pointer);
var I : Integer;
    P : Pointer;
    Q : Pointer;
    V : LongWord;
begin
  if BufSize <= 0 then
    exit;
  P := Buf;
  Q := DestBuf;
  For I := 1 to BufSize div 4 do
    begin
      // convert 4 characters per iteration
      V := PLongWord(P)^;
      Inc(PLongWord(P));
      PLongWord(Q)^ := (V and $FF) or ((V and $FF00) shl 8);
      Inc(PLongWord(Q));
      V := V shr 16;
      PLongWord(Q)^ := (V and $FF) or ((V and $FF00) shl 8);
      Inc(PLongWord(Q));
    end;
  // convert remaining (<4)
  For I := 1 to BufSize mod 4 do
    begin
      PWord(Q)^ := PByte(P)^;
      Inc(PByte(P));
      Inc(PWord(Q));
    end;
end;

function LongStringToWideString(const S: AnsiString): WideString;
var L : Integer;
begin
  L := Length(S);
  SetLength(Result, L);
  if L = 0 then
    exit;
  LongToWide(Pointer(S), L, Pointer(Result));
end;

function UTF8StringToWideString(const S: AnsiString): WideString;
var P       : PAnsiChar;
    Q       : PWideChar;
    L, M, I : Integer;
    C       : WideChar;
begin
  L := Length(S);
  if L = 0 then
    begin
      Result := '';
      exit;
    end;
  if IsUSASCIIString(S) then // optimize for US-ASCII strings
    begin
      Result := LongStringToWideString(S);
      exit;
    end;
  // Decode UTF-8
  P := Pointer(S);
  SetLength(Result, L); // maximum size
  Q := Pointer(Result);
  M := 0;
  Repeat
    UTF8ToWideChar(P, L, I, C);
    Assert(I > 0, 'I > 0');
    Q^ := C;
    Inc(Q);
    Inc(M);
    Inc(P, I);
    Dec(L, I);
  Until L <= 0;
  SetLength(Result, M); // actual size
end;

function WideStringToUTF8String(const S: WideString): AnsiString;
begin
  Result := WideBufToUTF8String(Pointer(S), Length(S));
end;

function _UW(const S: AnsiString): WideString;
begin
  Result := UTF8StringToWideString(S);
end;

function _WU(const S: WideString): AnsiString;
begin
  Result := WideStringToUTF8String(S);
end;

function UnicodeToCP1251(Unicode: cardinal): integer;
begin
  case Unicode of
  0..127: Result:=Unicode;
  160: Result:=160;
  164: Result:=164;
  166..167: Result:=Unicode;
  169: Result:=169;
  171..174: Result:=Unicode;
  176..177: Result:=Unicode;
  181..183: Result:=Unicode;
  187: Result:=187;
  1025: Result:=168;
  1026..1027: Result:=Unicode-898;
  1028: Result:=170;
  1029: Result:=189;
  1030: Result:=178;
  1031: Result:=175;
  1032: Result:=163;
  1033: Result:=138;
  1034: Result:=140;
  1035: Result:=142;
  1036: Result:=141;
  1038: Result:=161;
  1039: Result:=143;
  1040..1103: Result:=Unicode-848;
  1105: Result:=184;
  1106: Result:=144;
  1107: Result:=131;
  1108: Result:=186;
  1109: Result:=190;
  1110: Result:=179;
  1111: Result:=191;
  1112: Result:=188;
  1113: Result:=154;
  1114: Result:=156;
  1115: Result:=158;
  1116: Result:=157;
  1118: Result:=162;
  1119: Result:=159;
  1168: Result:=165;
  1169: Result:=180;
  8211..8212: Result:=Unicode-8061;
  8216..8217: Result:=Unicode-8071;
  8218: Result:=130;
  8220..8221: Result:=Unicode-8073;
  8222: Result:=132;
  8224..8225: Result:=Unicode-8090;
  8226: Result:=149;
  8230: Result:=133;
  8240: Result:=137;
  8249: Result:=139;
  8250: Result:=155;
  8364: Result:=136;
  8470: Result:=185;
  8482: Result:=153;
  else Result:=-1;
  end;
end;

function UTF8CharacterToUnicode(p: PChar; out CharLen: integer): Cardinal;
begin
  if p<>nil then begin
    if ord(p^)<192 then begin
      // regular single byte character (#0 is a normal char, this is pascal ;)
      Result:=ord(p^);
      CharLen:=1;
    end
    else if ((ord(p^) and 224) = 192) then begin
      // could be double byte character
      if (ord(p[1]) and 192) = 128 then begin
        Result:=((ord(p^) and 31) shl 6)
                or (ord(p[1]) and 63);
        CharLen:=2;
      end else begin
        Result:=ord(p^);
        CharLen:=1;
      end;
    end
    else if ((ord(p^) and 240) = 224) then begin
      // could be triple byte character
      if ((ord(p[1]) and 192) = 128)
      and ((ord(p[2]) and 192) = 128) then begin
        Result:=((ord(p^) and 31) shl 12)
                or ((ord(p[1]) and 63) shl 6)
                or (ord(p[2]) and 63);
        CharLen:=3;
      end else begin
        Result:=ord(p^);
        CharLen:=1;
      end;
    end
    else if ((ord(p^) and 248) = 240) then begin
      // could be 4 byte character
      if ((ord(p[1]) and 192) = 128)
      and ((ord(p[2]) and 192) = 128)
      and ((ord(p[3]) and 192) = 128) then begin
        Result:=((ord(p^) and 15) shl 18)
                or ((ord(p[1]) and 63) shl 12)
                or ((ord(p[2]) and 63) shl 6)
                or (ord(p[3]) and 63);
        CharLen:=4;
      end else begin
        Result:=ord(p^);
        CharLen:=1;
      end;
    end
    else begin
      // invalid character
      Result:=ord(p^);
      CharLen:=1;
    end;
  end else begin
    Result:=0;
    CharLen:=0;
  end;
end;

function UTF8ToSingleByte(const s: string;
  const UTF8CharConvFunc: TUnicodeToCharID): string;
var
  len: Integer;
  Src: PChar;
  Dest: PChar;
  c: Char;
  Unicode: LongWord;
  CharLen: integer;
  i: integer;
begin
  if s='' then begin
    Result:='';
    exit;
  end;
  len:=length(s);
  SetLength(Result,len);
  Src:=PChar(s);
  Dest:=PChar(Result);
  while len>0 do begin
    c:=Src^;
    if c<#128 then begin
      Dest^:=c;
      inc(Dest);
      inc(Src);
      dec(len);
    end else begin
      Unicode:=UTF8CharacterToUnicode(Src,CharLen);
      inc(Src,CharLen);
      dec(len,CharLen);
      i:=UTF8CharConvFunc(Unicode);
      if i>=0 then begin
        Dest^:=chr(i);
        inc(Dest);
      end;
    end;
  end;
  SetLength(Result,Dest-PChar(Result));
end;

function UTF8ToCP1251(const s: string): string;
begin
  Result:=UTF8ToSingleByte(s,@UnicodeToCP1251);
end;

const
  ArrayCP1251ToUTF8: TCharToUTF8Table = (
    #0,                 // #0
    #1,                 // #1
    #2,                 // #2
    #3,                 // #3
    #4,                 // #4
    #5,                 // #5
    #6,                 // #6
    #7,                 // #7
    #8,                 // #8
    #9,                 // #9
    #10,                // #10
    #11,                // #11
    #12,                // #12
    #13,                // #13
    #14,                // #14
    #15,                // #15
    #16,                // #16
    #17,                // #17
    #18,                // #18
    #19,                // #19
    #20,                // #20
    #21,                // #21
    #22,                // #22
    #23,                // #23
    #24,                // #24
    #25,                // #25
    #26,                // #26
    #27,                // #27
    #28,                // #28
    #29,                // #29
    #30,                // #30
    #31,                // #31
    ' ',                // ' '
    '!',                // '!'
    '"',                // '"'
    '#',                // '#'
    '$',                // '$'
    '%',                // '%'
    '&',                // '&'
    '''',               // ''''
    '(',                // '('
    ')',                // ')'
    '*',                // '*'
    '+',                // '+'
    ',',                // ','
    '-',                // '-'
    '.',                // '.'
    '/',                // '/'
    '0',                // '0'
    '1',                // '1'
    '2',                // '2'
    '3',                // '3'
    '4',                // '4'
    '5',                // '5'
    '6',                // '6'
    '7',                // '7'
    '8',                // '8'
    '9',                // '9'
    ':',                // ':'
    ';',                // ';'
    '<',                // '<'
    '=',                // '='
    '>',                // '>'
    '?',                // '?'
    '@',                // '@'
    'A',                // 'A'
    'B',                // 'B'
    'C',                // 'C'
    'D',                // 'D'
    'E',                // 'E'
    'F',                // 'F'
    'G',                // 'G'
    'H',                // 'H'
    'I',                // 'I'
    'J',                // 'J'
    'K',                // 'K'
    'L',                // 'L'
    'M',                // 'M'
    'N',                // 'N'
    'O',                // 'O'
    'P',                // 'P'
    'Q',                // 'Q'
    'R',                // 'R'
    'S',                // 'S'
    'T',                // 'T'
    'U',                // 'U'
    'V',                // 'V'
    'W',                // 'W'
    'X',                // 'X'
    'Y',                // 'Y'
    'Z',                // 'Z'
    '[',                // '['
    '\',                // '\'
    ']',                // ']'
    '^',                // '^'
    '_',                // '_'
    '`',                // '`'
    'a',                // 'a'
    'b',                // 'b'
    'c',                // 'c'
    'd',                // 'd'
    'e',                // 'e'
    'f',                // 'f'
    'g',                // 'g'
    'h',                // 'h'
    'i',                // 'i'
    'j',                // 'j'
    'k',                // 'k'
    'l',                // 'l'
    'm',                // 'm'
    'n',                // 'n'
    'o',                // 'o'
    'p',                // 'p'
    'q',                // 'q'
    'r',                // 'r'
    's',                // 's'
    't',                // 't'
    'u',                // 'u'
    'v',                // 'v'
    'w',                // 'w'
    'x',                // 'x'
    'y',                // 'y'
    'z',                // 'z'
    '{',                // '{'
    '|',                // '|'
    '}',                // '}'
    '~',                // '~'
    #127,               // #127
    #208#130,           // #128
    #208#131,           // #129
    #226#128#154,       // #130
    #209#147,           // #131
    #226#128#158,       // #132
    #226#128#166,       // #133
    #226#128#160,       // #134
    #226#128#161,       // #135
    #226#130#172,       // #136
    #226#128#176,       // #137
    #208#137,           // #138
    #226#128#185,       // #139
    #208#138,           // #140
    #208#140,           // #141
    #208#139,           // #142
    #208#143,           // #143
    #209#146,           // #144
    #226#128#152,       // #145
    #226#128#153,       // #146
    #226#128#156,       // #147
    #226#128#157,       // #148
    #226#128#162,       // #149
    #226#128#147,       // #150
    #226#128#148,       // #151
    '',                 // #152
    #226#132#162,       // #153
    #209#153,           // #154
    #226#128#186,       // #155
    #209#154,           // #156
    #209#156,           // #157
    #209#155,           // #158
    #209#159,           // #159
    #194#160,           // #160
    #208#142,           // #161
    #209#158,           // #162
    #208#136,           // #163
    #194#164,           // #164
    #210#144,           // #165
    #194#166,           // #166
    #194#167,           // #167
    #208#129,           // #168
    #194#169,           // #169
    #208#132,           // #170
    #194#171,           // #171
    #194#172,           // #172
    #194#173,           // #173
    #194#174,           // #174
    #208#135,           // #175
    #194#176,           // #176
    #194#177,           // #177
    #208#134,           // #178
    #209#150,           // #179
    #210#145,           // #180
    #194#181,           // #181
    #194#182,           // #182
    #194#183,           // #183
    #209#145,           // #184
    #226#132#150,       // #185
    #209#148,           // #186
    #194#187,           // #187
    #209#152,           // #188
    #208#133,           // #189
    #209#149,           // #190
    #209#151,           // #191
    #208#144,           // #192
    #208#145,           // #193
    #208#146,           // #194
    #208#147,           // #195
    #208#148,           // #196
    #208#149,           // #197
    #208#150,           // #198
    #208#151,           // #199
    #208#152,           // #200
    #208#153,           // #201
    #208#154,           // #202
    #208#155,           // #203
    #208#156,           // #204
    #208#157,           // #205
    #208#158,           // #206
    #208#159,           // #207
    #208#160,           // #208
    #208#161,           // #209
    #208#162,           // #210
    #208#163,           // #211
    #208#164,           // #212
    #208#165,           // #213
    #208#166,           // #214
    #208#167,           // #215
    #208#168,           // #216
    #208#169,           // #217
    #208#170,           // #218
    #208#171,           // #219
    #208#172,           // #220
    #208#173,           // #221
    #208#174,           // #222
    #208#175,           // #223
    #208#176,           // #224
    #208#177,           // #225
    #208#178,           // #226
    #208#179,           // #227
    #208#180,           // #228
    #208#181,           // #229
    #208#182,           // #230
    #208#183,           // #231
    #208#184,           // #232
    #208#185,           // #233
    #208#186,           // #234
    #208#187,           // #235
    #208#188,           // #236
    #208#189,           // #237
    #208#190,           // #238
    #208#191,           // #239
    #209#128,           // #240
    #209#129,           // #241
    #209#130,           // #242
    #209#131,           // #243
    #209#132,           // #244
    #209#133,           // #245
    #209#134,           // #246
    #209#135,           // #247
    #209#136,           // #248
    #209#137,           // #249
    #209#138,           // #250
    #209#139,           // #251
    #209#140,           // #252
    #209#141,           // #253
    #209#142,           // #254
    #209#143            // #255
  );

function SingleByteToUTF8(const s: string; const Table: TCharToUTF8Table
  ): string;
var
  len: Integer;
  i: Integer;
  Src: PAnsiChar;
  Dest: PAnsiChar;
  p: PAnsiChar;
  c: AnsiChar;
begin
  if s='' then begin
    Result:=s;
    exit;
  end;
  len:=length(s);
  SetLength(Result,len*4);// UTF-8 is at most 4 bytes
  Src:=PAnsiChar(s);
  Dest:=PAnsiChar(Result);
  for i:=1 to len do begin
    c:=Src^;
    inc(Src);
    if ord(c)<128 then begin
      Dest^:=c;
      inc(Dest);
    end else begin
      p:=Table[c];
      if p<>nil then begin
        while p^<>#0 do begin
          Dest^:=p^;
          inc(p);
          inc(Dest);
        end;
      end;
    end;
  end;
  SetLength(Result,PtrUInt(Dest)-PtrUInt(Result));
end;

function CP1251ToUTF8(const s: string): string;
begin
  Result:=SingleByteToUTF8(s,ArrayCP1251ToUTF8);
end;

// Конвертирует строку из Utf8 в Ascii для тех строк,
// которые были получены из TReportQuery
function PUtf8ToA(const s: String; IsParadox: Boolean): String;
begin
{$IFNDEF UNICODE}
  if IsParadox then
    Result := Utf8ToAnsi(s)
  else
{$ENDIF}
  begin
    Result := s;
  end;
end;

// Конвертирует строку из Ascii в Utf8 для тех строк,
// которые отправляются в TReportQuery
function AToUtf8P(const s: String; IsParadox: Boolean): String;
begin
{$IFNDEF UNICODE}
  if IsParadox then
    Result := AnsiToUtf8(s)
  else
{$ENDIF}
  begin
    Result := s;
  end;
end;

// Конвертирует строку из Utf8 в Ascii для тех строк,
// которые были получены из TReportQuery
function Utf8ToAP(const s: String; IsParadox: Boolean): String;
begin
  if IsParadox then
    Result := s
  else
  begin
{$IFNDEF UNICODE}
    Result := Utf8ToAnsi(s);
{$ENDIF}
  end;
end;

// Конвертирует строку из Ascii в Utf8 для тех строк,
// которые отправляются в TReportQuery
function PAToUtf8(const s: String; IsParadox: Boolean): String;
begin
  if IsParadox then
    Result := s
  else
  begin
{$IFNDEF UNICODE}
    Result := AnsiToUtf8(s);
{$ENDIF}
  end;
end;

{$IFNDEF FPC}
{$IFNDEF UNICODE}
{$DEFINE NOFPCANDUNICODE}
{$ENDIF}
{$ENDIF}

function Utf8ToA(const s: AnsiString): String;
begin
{$IFDEF FPC}
  Result := s;
{$ENDIF}
{$IFDEF UNICODE}
  Result := _UW(s);
{$ENDIF}
{$IFDEF NOFPCANDUNICODE}
  Result := Utf8ToAnsi(s);
{$ENDIF}
end;

function AToUtf8(const s: String): AnsiString;
begin
{$IFDEF FPC}
  Result := s;
{$ENDIF}
{$IFDEF UNICODE}
  Result := _WU(s);
{$ENDIF}
{$IFDEF NOFPCANDUNICODE}
  Result := AnsiToUtf8(s);
{$ENDIF}
end;

function _AW(const s: AnsiString): String;
begin
{$IFDEF FPC}
  Result := s;
{$ENDIF}
{$IFDEF UNICODE}
  Result := _UW(s);
{$ENDIF}
{$IFDEF NOFPCANDUNICODE}
  Result := s;
{$ENDIF}
end;

function _WA(const s: String): AnsiString;
begin
{$IFDEF FPC}
  Result := s;
{$ENDIF}
{$IFDEF UNICODE}
  Result := _WU(s);
{$ENDIF}
{$IFDEF NOFPCANDUNICODE}
  Result := s;
{$ENDIF}
end;

end.

// ********************************************************* ConvertUni.pas ***

