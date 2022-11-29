unit Clientes.Control;

interface

uses Clientes.Model, System.SysUtils;

type
  TClienteControl = class
    private
      FClientesModel: TClienteModel;
      function FNome: String;
      function FCidade: String;
      function FUF: String;

    public
      constructor Create;
      destructor Destroy;override;
      function BuscarCliente(Codigo: Integer): Boolean;

      property Nome: String read FNome;
      property Cidade: String read FCidade;
      property UF: String read FUF;
  end;

implementation

{ TClienteControl }

function TClienteControl.BuscarCliente(Codigo: Integer): Boolean;
begin
  Result := FClientesModel.BuscarCliente(Codigo);
end;

constructor TClienteControl.Create;
begin
  FClientesModel := TClienteModel.Create;
end;

destructor TClienteControl.Destroy;
begin
  FreeAndNil(FClientesModel);
  inherited;
end;

function TClienteControl.FCidade: String;
begin
  Result := FClientesModel.Cidade;
end;

function TClienteControl.FNome: String;
begin
  Result := FClientesModel.Nome;
end;

function TClienteControl.FUF: String;
begin
  Result := FClientesModel.UF;
end;

end.
