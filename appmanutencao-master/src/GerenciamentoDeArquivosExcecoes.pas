unit GerenciamentoDeArquivosExcecoes;


interface

uses
  AltLibTypes;

type
  EFalhaAoDeletarArquivo = class(EAltException)
  public
    constructor Create();
  end;

  ENenhumArquivoGerado = class(EAltException)
  public
    constructor Create();
  end;

implementation

constructor EFalhaAoDeletarArquivo.Create;
begin
  inherited Create('N�o foi poss�vel deletar os arquivos gerados. Verifique se o registro est� em uso');
end;

constructor ENenhumArquivoGerado.Create;
begin
  inherited Create('A cria��o dos arquivos foi abortada. Ocorreu um erro inesperado.');
end;

end.
