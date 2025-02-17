program Chatbot;

uses
  Vcl.Forms,
  Principal in 'Principal.pas' {p},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tp, p);
  Application.Run;
end.
