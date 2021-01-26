unit IBAN;

{
Максимальний розмір IBAN може досягати 34 символів.
IBAN в Україні складається з 29 літерно-цифрових символів.

Серед них перші 10 знаків — код країни, контрольне число і код банку.
Зокрема, перші дві літери UA вказують код України, наступні два символи — контрольні,
вони призначені для перевірки достовірності рахунку та захищають інформацію від
помилок. Наступні шість цифр — код МФО банку.

Друга група символів із 19 знаків — безпосередньо номер рахунку клієнта банку.
До того ж перші в цій групі п'ять нулів, як правило, доповнюють IBAN до 29 знаків,
а останні 14 символів є безпосередньо номером рахунку
}

interface

type
  TcharSet = set of AnsiChar;

  TIBAN = class
  public
    // Створити IBAN
    class function GetIBAN(AnAccount, AMFO: string; ACountryCode : string = 'UA'): string;
    // Перевірити IBAN
    class function Validate(AnIBAN: String): Boolean;
    class function SilentValidate(AnIBAN: String): Boolean;
  end;

  TIBANUtils= class
  public
   class procedure AddLeadingZero(Count : integer; var AValue : string);
   class function CheckSymbols(AValue : string; charSet : TcharSet) : boolean;
   class function Mod97(value: String): Integer;
  end;

const
  DigitSet : TcharSet = ['0'..'9'];
  AlphaSet : TcharSet = ['A'..'Z'];

implementation

uses SysUtils;

class procedure TIBANUtils.AddLeadingZero(Count : integer; var AValue : string);
var i : integer;
begin
  if Length(AValue) < 19 then
  begin
    for I := 1 to 19 - Length(AValue) do
      AValue := '0' + AValue;
  end
end;

class function TIBANUtils.CheckSymbols(AValue : string; charSet : TcharSet) : boolean;
var i : integer;
begin
  Result := True;
  for i := 1 to Length(AValue) do
    if not CharInSet(AValue[i], charSet) then
    begin
      Result := False;
      break;
    end;
end;

class function TIBANUtils.Mod97(value: String): Integer;
begin
  Result := 0;
  while Length(value) > 0 do
  begin
     Result := StrToIntDef(IntToStr(Result) + Copy(value,1,6), 0) mod 97;
     Delete(value,1,6);
  end;
end;

type
  TIBANRecord = record
  private
    DC          : string;
    FValid      : boolean;
    IBAN        : string;
    procedure CheckFields;
    procedure CalcDC;
    procedure Build;
    function Validate : boolean;
    function CountryToIBANTable: string;
  public
    Silent      : boolean;
    CountryCode : string;
    MFO         : string;
    Account     : string;
    constructor Init(AnAccount, AMFO: string; ACountryCode : string = 'UA'); overload;
    constructor Init(AnIBAN: string); overload;
    function toString : string;
    function isValid : boolean;
  end;

{ TIBAN }

class function TIBAN.GetIBAN(AnAccount, AMFO: string; ACountryCode : string = 'UA'): string;
var Rec : TIBANRecord;
begin
  Rec.Init(AnAccount, AMFO, ACountryCode);
  Result := Rec.toString;
end;

class function TIBAN.SilentValidate(AnIBAN: String): Boolean;
var Rec : TIBANRecord;
begin
  Rec.Silent := True;
  Rec.Init(AnIBAN);
  Result := Rec.isValid;
end;

class function TIBAN.Validate(AnIBAN: String): Boolean;
var Rec : TIBANRecord;
begin
  Rec.Silent := False;
  Rec.Init(AnIBAN);
  Result := Rec.isValid;
end;

{ TIBANRecord }

constructor TIBANRecord.Init(AnAccount, AMFO, ACountryCode: string);
begin
  Self.CountryCode := UpperCase(ACountryCode);
  Self.DC          := '00';
  Self.MFO         := AMFO;
  Self.Account     := AnAccount;
  CheckFields;
  CalcDC;
  Build;
end;

constructor TIBANRecord.Init(AnIBAN: string);
begin
  Self.IBAN := UpperCase(AnIBAN);
  FValid := Validate;
end;

function TIBANRecord.isValid: boolean;
begin
  Result := Self.FValid;
end;

function TIBANRecord.toString: string;
begin
  Result := Self.IBAN;
end;

procedure TIBANRecord.Build;
begin
  Self.IBAN := Self.CountryCode + Self.DC + Self.MFO + Self.Account;
  Self.FValid := True;
end;

procedure TIBANRecord.CheckFields;
begin
  if Length(Self.CountryCode) <> 2 then
    raise Exception.Create('Невірний код країни : повинно бути 2 символи');
  if not TIBANUtils.CheckSymbols(Self.CountryCode, AlphaSet) then
    raise Exception.Create('Невірний код країни : невірний символ');

  if Length(Self.DC) <> 2 then
    raise Exception.Create('Невірні контрольні цифри : повинно бути 2 цифри');
  if not TIBANUtils.CheckSymbols(Self.DC, DigitSet) then
    raise Exception.Create('Невірний контрольні цифри : невірний символ');

  if Length(Self.MFO) <> 6 then
    raise Exception.Create('Невірний МФО : повинно бути 6 цифр');
  if not TIBANUtils.CheckSymbols(Self.MFO, DigitSet) then
    raise Exception.Create('Невірний МФО : невірний символ');

  if Length(Self.Account) < 19 then
    TIBANUtils.AddLeadingZero(19, Self.Account)
  else
  if Length(Self.Account) > 19 then
    raise Exception.Create('Невірний рахунок : повинно бути 19 цифр');
  if not TIBANUtils.CheckSymbols(Self.Account, DigitSet) then
    raise Exception.Create('Невірний рахунок : невірний символ');
end;

procedure TIBANRecord.CalcDC;
var
  AValidator : string;
  NewDV      : Integer;
begin
  {$REGION 'Doc_Calc_DC_IBAN'}
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /// Calculo del DC del IBAN
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //   1) Tomas el numero de cuenta sin espacios ni guiones ni nada (ejemplo aleman, sin digitos de control) :
  //      370400440532013000
  //
  //   2) A�ades al final el pais y digitos de control vacios 00 ('ES00' � 'DE00' en el ejemplo):
  //      370400440532013000DE00
  //
  //   3) Cambias las letras que queden a numeros segun esta tabla:
  //      A=10, B=11, C=12, D=13, E=14, F=15, G=16, H=17, I=18, J=19, K=20, L=21, M=22,
  //      N=23, O=24, P=25, Q=26, R=27, S=28, T=29, U=30, V=31, W=32, X=33, Y=34, Z=35
  //
  //      370400440532013000DE00 se convierte en 370400440532013000131400
  //
  //   4) 370400440532013000131400 mod 97 = 9
  //
  //   5) 98 - 9 = 89
  //      Al final quedaria asi: DE89 37040044 0532013000
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  {$ENDREGION}

  AValidator := Self.MFO + Self.Account + Self.CountryToIBANTable + Self.DC;
  NewDV      := 98 - TIBANUtils.Mod97(AValidator);

  if NewDV < 10 then
     Self.DC := '0' + IntToStr(NewDV)
  else
     Self.DC := IntToStr(NewDV);
end;

function TIBANRecord.CountryToIBANTable: string;
  function CharToDigitTable(const Value: Char): string;
  const Initial_A: char = 'A';
  var  iValue: byte;
  begin
    Result := Value;
    if CharInSet(Value, ['A'..'Z']) then
    begin
       iValue := (byte(Value) - byte(Initial_A)) + 10;
       result := IntToStr(iValue);
    end;
  end;

var
  i: Integer;
  Valor: string;
begin
  Result := '';
  for i:=1 to Length(Self.CountryCode) do
  begin
     Valor  := CharToDigitTable(Self.CountryCode[i]);
     Result := Result + Valor;
  end;
end;

function TIBANRecord.Validate: boolean;
var
  AValidator: string;
begin
  Self.FValid := False;
  Self.CountryCode := UpperCase(Copy(Self.IBAN, 1,2));
  Self.DC          := Copy(Self.IBAN, 3,2);
  Self.MFO         := Copy(Self.IBAN, 5,6);
  Self.Account     := Copy(Self.IBAN, 11);
  if not Silent then
    CheckFields;
  AValidator := Self.MFO + Self.Account + Self.CountryToIBANTable + Self.DC;
  FValid := TIBANUtils.Mod97(AValidator) = 1;
  Result := FValid;
end;

end.
