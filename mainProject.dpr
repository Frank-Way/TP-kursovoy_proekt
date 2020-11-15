program mainProject;

uses
  Vcl.Forms,
  mainUnit in 'mainUnit.pas' {mainForm},
  authUnit in 'authUnit.pas' {authForm},
  globalObjects in 'globalObjects.pas',
  CRUDunit in 'CRUDunit.pas' {CRUDform},
  consultUnit in 'consultUnit.pas' {consultForm},
  searchUnit in 'searchUnit.pas' {searchForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TauthForm, authForm);
  Application.Run;
end.
