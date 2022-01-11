unit GeracaoArquivosThread;


interface

uses
  System.Classes, Vcl.ComCtrls, ClienteServidor;

type
 TThreadGeracaoArquivos = class(TThread)
  private
    FHandleToMessage: THandle;
    FQuantidadeArquivos: Integer;
    FPathClient: String;
    FServidor: TServidor;
    procedure SetHandleToMessage(const Value: THandle);
  protected
    procedure Execute; override;
  public
    property HandleToMessage: THandle read FHandleToMessage write SetHandleToMessage;
    property FileQuantity: Integer read FQuantidadeArquivos write FQuantidadeArquivos;
    property PathClient: String read FPathClient write FPathClient;
    property Servidor: TServidor read FServidor write FServidor;
    constructor Create(
      pHandleToMessage: THandle;
      pQuantidadeArquivos: integer;
      FPathClient: string);
 end;

implementation

uses
  Datasnap.DBClient, System.SysUtils, Winapi.ActiveX;

{ TThreadGeracaoArquivos }

constructor TThreadGeracaoArquivos.Create(
  pHandleToMessage: THandle;
  pQuantidadeArquivos: integer);
begin
  Priority:= tpLower;
  FreeOnTerminate:= True;
  FHandleToMessage:= pHandleToMessage;
  FQuantidadeArquivos := FileQuantity;
  FPathClient := PathClient;
end;

procedure TThreadGeracaoArquivos.Execute;
var
  cds: TClientDataset;
  i: Integer;
  lNmArquivo: string;
begin
  CoInitialize(nil);
  cds := TClientDataSet.Create(nil);
  cds.DisableControls();
  try
    lNmArquivo := ExtractFileName(PathClient);

    for i := 0 to FQuantidadeArquivos do
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

procedure TThreadGeracaoArquivos.SetHandleToMessage(const Value: THandle);
begin
  FHandleToMessage := Value;
end;

end.
