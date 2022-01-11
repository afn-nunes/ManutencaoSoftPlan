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
  inherited Create('Não foi possível deletar os arquivos gerados. Verifique se o registro está em uso');
end;

constructor ENenhumArquivoGerado.Create;
begin
  inherited Create('A criação dos arquivos foi abortada. Ocorreu um erro inesperado.');
end;

end.
