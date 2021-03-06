program Foo;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fMain},
  DatasetLoop in 'DatasetLoop.pas' {fDatasetLoop},
  ClienteServidor in 'ClienteServidor.pas' {fClienteServidor},
  GerenciamentoDeArquivosExcecoes in 'GerenciamentoDeArquivosExcecoes.pas',
  GeracaoArquivosThread in 'GeracaoArquivosThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  AApplication.CreateForm(TfMain, fMain);
  AApplication.CreateForm(TfDatasetLoop, fDatasetLoop);
  Application.CreateForm(TfClienteServidor, fClienteServidor);
  plication.Run;
end.
