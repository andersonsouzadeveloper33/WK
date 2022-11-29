unit Produtos.Model;

interface

uses FireDAC.Comp.Client, System.SysUtils, FireDac.Stan.Param;

Type
  TProdutoModel = class
    private
      FDescricao: String;
      FPrecoVenda: Double;
    public
      Constructor Create;
      Destructor Destroy;override;
      function BuscarProduto(Codigo: Integer): Boolean;

      property Descricao: String read FDescricao;
      property PrecoVenda: Double read FPrecoVenda;

  end;

implementation

uses
  untDmPrincipal;

{ TProdutoModel }

function TProdutoModel.BuscarProduto(Codigo: Integer): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DataModule1.Conexao;
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('select descricao, preco_venda from produtos where codigo = :codigo');
    Qry.ParamByName('codigo').AsInteger := Codigo;
    Qry.Open;

    if Qry.RecordCount > 0 then
    begin
      Result := True;
      FDescricao := Qry.FieldByName('descricao').AsString;
      FPrecoVenda := Qry.FieldByName('preco_venda').AsFloat;
    end;

  finally
    FreeAndNil(Qry);
  end;
end;

constructor TProdutoModel.Create;
begin

end;

destructor TProdutoModel.Destroy;
begin

  inherited;
end;

end.
