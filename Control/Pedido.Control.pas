unit Pedido.Control;

interface

uses Pedido.Model, System.SysUtils, System.Generics.Collections, Data.DB, Datasnap.DBClient;

type
  TPedidoControl = class
    private
      FPedido: TPedidoModel;
    public
      Constructor Create;
      Destructor Destroy;override;

      function AdicionarPedidoItem(codigo_produto, quantidade: Integer; unitario,
        total: Double): Boolean;
      function FinalizarPedido(IdCliente: Integer; Data: TDate; Total: Double): Boolean;
      function ConsultarPedido(Numero: Integer;
                                var CodigoCliente: Integer;
                                var NomeCliente: String;
                                var Total: Double;
                                var CdsItens: TClientDataSet): Boolean;
      function CancelarPedido(Numero: Integer): Boolean;
  end;

implementation

{ TPedidoControl }

function TPedidoControl.AdicionarPedidoItem(codigo_produto, quantidade: Integer;
  unitario, total: Double): Boolean;
var
  I: integer;
begin
  FPedido.AdicionarPedidoItem(codigo_produto, quantidade, unitario, total);
end;

function TPedidoControl.CancelarPedido(Numero: Integer): Boolean;
begin
  Result := FPedido.CancelarPedido(Numero);
end;

function TPedidoControl.ConsultarPedido(Numero: Integer; var CodigoCliente: Integer;
  var NomeCliente: String; var Total: Double; var CdsItens: TClientDataSet): Boolean;
var
  ListaItens: TObjectList<TPedidoItem>;
  i: Integer;
begin
  Result := FPedido.ConsultarPedido(Numero, CodigoCliente, NomeCliente, Total, ListaItens);

  if Result then
  begin
    for i := 0 to ListaItens.Count -1 do
    begin
      CdsItens.Append;
      CdsItens.FieldByName('codigo').AsInteger := ListaItens[i].CodigoProduto;
      CdsItens.FieldByName('descricao').AsString := ListaItens[i].Descricao;
      CdsItens.FieldByName('quantidade').AsInteger := ListaItens[i].Quantidade;
      CdsItens.FieldByName('unitario').AsFloat := ListaItens[i].Unitario;
      CdsItens.FieldByName('total').AsFloat := ListaItens[i].Total;
      CdsItens.Post;
    end;
  end;
end;

constructor TPedidoControl.Create;
begin
  FPedido := TPedidoModel.Create;
end;

destructor TPedidoControl.Destroy;
begin
  FreeAndNil(FPedido);
  inherited;
end;

function TPedidoControl.FinalizarPedido(IdCliente: Integer; Data: TDate; Total: Double): Boolean;
begin
  FPedido.IdCliente := IdCliente;
  FPedido.Data := Data;
  FPedido.Total := Total;
  Result := FPedido.FinalizarPedido;
end;

end.
