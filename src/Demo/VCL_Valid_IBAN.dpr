program VCL_Valid_IBAN;

uses
  Forms,
  uMain in 'uMain.pas' {frmMain},
  IBAN in '..\IBAN.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
