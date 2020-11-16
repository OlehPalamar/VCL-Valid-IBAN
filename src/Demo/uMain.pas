unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TfrmMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    edtCountryCode: TEdit;
    btnGenerateIBAN: TButton;
    TabSheet2: TTabSheet;
    btnValidate: TButton;
    edtIBAN_valid: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    edtMFO: TEdit;
    Label8: TLabel;
    edtAccount: TEdit;
    Label9: TLabel;
    edtIBANFullElect: TEdit;
    Label10: TLabel;
    edtIBANFullPrint: TEdit;
    procedure btnGenerateIBANClick(Sender: TObject);
    procedure btnValidateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses IBAN;

{$R *.dfm}

procedure TfrmMain.btnGenerateIBANClick(Sender: TObject);
var s : string;
begin
  s := TIBAN.GetIBAN(edtAccount.Text, edtMFO.Text, edtCountryCode.Text);
  edtIBANFullElect.Text := s;
  edtIBANFullPrint.Text := s
end;

procedure TfrmMain.btnValidateClick(Sender: TObject);
begin
  if TIBAN.Validate(edtIBAN_valid.Text) then
    ShowMessage('OK')
  else
    ShowMessage('Fail!!!');
end;

end.
