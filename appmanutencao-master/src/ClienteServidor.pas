unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB;

type
  TServidor = class
    private
      FPathServidor: string;
    procedure PreencherListaDeArquivos(var pLista: TStringlist);
    procedure DeletaArquivos(pListaDeArquivos: TStringList);
    procedure CriarArquivos(cds: TClientDataSet);
    public
      constructor Create;
      //Tipo do parâmetro não pode ser alterado
      function SalvarArquivos(AData: OleVariant): Boolean;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FPathCliente: string;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
    procedure DestroyDataset(pDataset: TClientDataset);
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
  lNmArquivo: string;
begin
  cds := InitDataset;
  cds.DisableControls();
  try
    lNmArquivo := ExtractFileName(FPathCliente);
    for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      cds.Append;
      cds.FieldByName('Arquivo').AsString := lNmArquivo;
      cds.Post;

      {$REGION Simulação de erro, não alterar}
      if i = (QTD_ARQUIVOS_ENVIAR/2) then
        FServidor.SalvarArquivos(NULL);
      {$ENDREGION}
    end;

    FServidor.SalvarArquivos(cds.Data);
  finally
    cds.EnableControls();
    DestroyDataset(cds);
  end;
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
  lNmArquivo: string;
begin
  cds := InitDataset;
  cds.DisableControls();
  try
    lNmArquivo := ExtractFileName(FPathCliente);
    for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      cds.Append;
      cds.FieldByName('Arquivo').AsString := lNmArquivo;
      cds.Post;
    end;
    FServidor.SalvarArquivos(cds.Data);
  finally
    cds.EnableControls();
  end;
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPathCliente := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
  FServidor := TServidor.Create;
end;


procedure TfClienteServidor.FormDestroy(Sender: TObject);
begin
 FServidor.Free();
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

procedure TfClienteServidor.DestroyDataset(pDataset: TClientDataset);
begin
  pDataset.Free();
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPathServidor := ExtractFilePath(ParamStr(0)) + 'Servidor\';
  if not TDirectory.Exists(FPathServidor) then
    TDirectory.CreateDirectory(FPathServidor);
end;

procedure TServidor.PreencherListaDeArquivos(var pLista: TStringlist);
var
  I: Integer;
  SR: TSearchRec;
begin
  I := FindFirst(FPathServidor + '*.pdf', faAnyFile, SR);
  while I = 0 do
  begin
    pLista.Add(FPathServidor + sr.Name);
    I := FindNext(SR);
  end;
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataSet;
  lListaDeArquivos: TStringList;
begin
  Result := False;
  lListaDeArquivos := TStringList.Create;
  cds := TClientDataset.Create(nil);
  try
    try
      cds.Data := AData;

      PreencherListaDeArquivos(lListaDeArquivos);

      {$REGION Simulação de erro, não alterar}
      if cds.RecordCount = 0 then
        Exit;

      CriarArquivos(cds);
    finally
      cds.Free();
    end;

    Exit(True);

  except
    DeletaArquivos(lListaDeArquivos);
    lListaDeArquivos.Free();
    raise;
  end;
end;



procedure TServidor.CriarArquivos(cds: TClientDataSet);
var
  FileName: string;
begin
  cds.First;
  while not cds.Eof do
  begin
    FileName := FPathServidor + cds.RecNo.ToString + '.pdf';
    if TFile.Exists(FileName) then
      TFile.Delete(FileName);
    TFile.Create(FileName);
    cds.Next;
  end;
end;

procedure TServidor.DeletaArquivos(pListaDeArquivos: TStringList);
var
  lFileName: string;
begin
  for lFileName in pListaDeArquivos do
  begin
    if TFile.Exists(lFileName) then
      TFile.Delete(lFileName);
  end;
end;end.
