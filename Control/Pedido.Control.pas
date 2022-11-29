unit Pedido.Control;

interface

uses Pedido.Model, System.SysUtils, System.Generics.Collections;

Type
  TPedidoItemControl = class
    private
      FCodigoProduto: Integer;
      FQuantidade: Integer;
      FUnitario: Double;
      FTotal: Double;
    public
      property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
      property Quantidade: Integer read FQuantidade write FQuantidade;
      property Unitario: Double read FUnitario write FUnitario;
      property Total: Double read FTotal write FTotal;
  end;

type
  TPedidoControl = class
    private
      FPedido: TPedidoModel;
      FListaPedidoItem: TObjectList<TPedidoItemControl>;
    public
      Constructor Create;
      Destructor Destroy;override;

      function AdicionarPedidoItem(codigo_produto, quantidade: Integer; unitario,
        total: Double): Boolean;
      function GravarPedido(IdCliente: Integer; Data: TDate; Total: Double): Boolean;
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

constructor TPedidoControl.Create;
begin
  FPedido := TPedidoModel.Create;
  FListaPedidoItem := TObjectList<TPedidoItemControl>.Create;
end;

destructor TPedidoControl.Destroy;
begin
  FreeAndNil(FPedido);
  FreeAndNil(FListaPedidoItem);
  inherited;
end;

function TPedidoControl.GravarPedido(IdCliente: Integer; Data: TDate; Total: Double): Boolean;
begin
  FPedido.IdCliente := IdCliente;
  FPedido.Data := Data;
  FPedido.Total := Total;
  Result := FPedido.GravarPedido;
end;

end.
