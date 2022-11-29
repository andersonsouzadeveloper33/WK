unit Produtos.Control;

interface

uses Produtos.Model, System.SysUtils;

Type
  TProdutoControl = class
    private
      FProdutoModel: TProdutoModel;
      function getDescricao: String;
      function getPrecoVenda: Double;
    public
      Constructor Create;
      Destructor Destroy;override;
      function BuscarProduto(Codigo: Integer): Boolean;

      property Descricao: String read getDescricao;
      property PrecoVenda: Double read getPrecoVenda;
  end;

implementation

{ TProdutoControl }

function TProdutoControl.BuscarProduto(Codigo: Integer): Boolean;
begin
  Result := FProdutoModel.BuscarProduto(Codigo);
end;

constructor TProdutoControl.Create;
begin
  FProdutoModel := TProdutoModel.Create;
end;

destructor TProdutoControl.Destroy;
begin
  FreeAndNil(FProdutoModel);
  inherited;
end;

function TProdutoControl.getDescricao: String;
begin
  Result := FProdutoModel.Descricao;
end;

function TProdutoControl.getPrecoVenda: Double;
begin
  Result := FProdutoModel.PrecoVenda;
end;

end.
