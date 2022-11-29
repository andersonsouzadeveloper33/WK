unit Clientes.Model;

interface

uses FireDAC.Comp.Client, System.SysUtils, FireDac.Stan.Param, UntFuncoes;

Type
  TClienteModel = class
    private
      FNome: String;
      FCidade: String;
      FUF: String;
    public
      Constructor Create;
      Destructor Destroy;override;
      function BuscarCliente(Codigo: Integer): Boolean;

      property Nome: String read FNome;
      property Cidade: String read FCidade;
      property UF: String read FUF;
  end;

implementation

uses untDmPrincipal;

{ TClienteModel }

function TClienteModel.BuscarCliente(Codigo: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  CriaQry(Qry);
  try
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('select nome, cidade, uf from clientes where codigo = :codigo');
    Qry.ParamByName('codigo').AsInteger := Codigo;
    Qry.Open;

    if Qry.RecordCount > 0 then
    begin
      Result := True;
      FNome := Qry.FieldByName('nome').AsString;
      FCidade := Qry.FieldByName('cidade').AsString;
      FUF := Qry.FieldByName('uf').AsString;
    end;

  finally
    FreeAndNil(Qry);
  end;
end;

constructor TClienteModel.Create;
begin
end;

destructor TClienteModel.Destroy;
begin

  inherited;
end;

end.
