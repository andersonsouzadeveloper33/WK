unit Pedido.Model;

interface

uses FireDAC.Comp.Client, System.SysUtils, FireDac.Stan.Param,
  System.Generics.Collections, UntFuncoes;

Type
  TPedidoItem = class
    private
      FCodigoProduto: Integer;
      FDescricao: String;
      FQuantidade: Integer;
      FUnitario: Double;
      FTotal: Double;
    public
      property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;
      property Descricao: String read FDescricao write FDescricao;
      property Quantidade: Integer read FQuantidade write FQuantidade;
      property Unitario: Double read FUnitario write FUnitario;
      property Total: Double read FTotal write FTotal;
  end;

Type
  TPedidoModel = class
    private
      FIdCliente: Integer;
      FData: TDate;
      FTotal: Double;
      FListaPedidoItem: TObjectList<TPedidoItem>;
      function getNumero: Integer;
      procedure GravarItem(numero_pedido, codigo, quantidade: Integer;
        unitario, total: Double);
      function getIdPedidoItem: Integer;
      function GravarPedido: Integer;
      function ConsultarItensPedido(Numero: Integer): TObjectList<TPedidoItem>;
      procedure CancelarPedidoDetalhes(Numero: Integer);
      procedure CancelarPedidoProdutos(Numero: Integer);
    public
      constructor Create;
      destructor Destroy; override;
      function FinalizarPedido: Boolean;
      procedure AdicionarPedidoItem(codigo_produto, quantidade: Integer; unitario,
        total: Double);
      function ConsultarPedido(Numero: Integer;
                               var CodigoCliente: Integer;
                               var NomeCliente: String;
                               var Total: Double;
                               var ListaItens: TObjectList<TPedidoItem>): Boolean;
      function CancelarPedido(Numero: Integer): Boolean;

      property IdCliente: Integer read FIdCliente write FIdCliente;
      property Data: TDate read FData write FData;
      property Total: Double read FTotal write FTotal;

  end;

implementation

{ TVendaModel }

uses untDmPrincipal, Data.DBXCommon;

procedure TPedidoModel.AdicionarPedidoItem(codigo_produto, quantidade: Integer; unitario,
  total: Double);
var
  I: integer;
begin
  FListaPedidoItem.Add(TPedidoItem.Create);
  I := FListaPedidoItem.Count - 1;
  FListaPedidoItem[I].CodigoProduto := codigo_produto;
  FListaPedidoItem[I].Quantidade := quantidade;
  FListaPedidoItem[I].Total := total;
  FListaPedidoItem[I].Unitario := unitario;
end;

function TPedidoModel.CancelarPedido(Numero: Integer): Boolean;
begin
  Result := False;

  if not DataModule1.Conexao.InTransaction then
  begin
    Try
      DataModule1.Conexao.StartTransaction;

      CancelarPedidoDetalhes(Numero);
      CancelarPedidoProdutos(Numero);

      DataModule1.Conexao.Commit;

      Result := True;
    Except
      on E : Exception do
      begin
        Result := False;
        DataModule1.Conexao.Rollback;
        Abort;
      end;
    end;
  end;
end;

procedure TPedidoModel.CancelarPedidoDetalhes(Numero: Integer);
var
  Qry: TFDQuery;
begin
  CriaQry(Qry);
  try
    Qry.SQL.Clear;
    Qry.SQL.Add('delete from pedidos where numero_pedido = :numero');
    Qry.ParamByName('numero').AsInteger := Numero;
    Qry.ExecSQL;
    Qry.SQL.Clear
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TPedidoModel.CancelarPedidoProdutos(Numero: Integer);
var
  Qry: TFDQuery;
begin
  CriaQry(Qry);
  try
    Qry.SQL.Clear;
    Qry.SQL.Add('delete from pedidos_produtos where numero_pedido = :numero');
    Qry.ParamByName('numero').AsInteger := Numero;
    Qry.ExecSQL;
    Qry.SQL.Clear
  finally
    FreeAndNil(Qry);
  end;
end;

function TPedidoModel.ConsultarItensPedido(Numero: Integer): TObjectList<TPedidoItem>;
var
  Qry: TFDQuery;
  I: integer;
begin
  CriaQry(Qry);
  try
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('select p.codigo_produto, ');
    Qry.SQL.Add('       po.descricao, ');
    Qry.SQL.Add('       p.quantidade, ');
    Qry.SQL.Add('       p.valor_unitario, ');
    Qry.SQL.Add('       p.valor_total ');
    Qry.SQL.Add(' from pedidos_produtos p ');
    Qry.SQL.Add(' inner join produtos po on(po.codigo = p.codigo_produto)');
    Qry.SQL.Add('where p.numero_pedido = :numero');
    Qry.ParamByName('numero').AsInteger := Numero;
    Qry.Open;

    Result := TObjectList<TPedidoItem>.Create;

    for i := 0 to Qry.RecordCount -1 do
    begin
      Result.Add(TPedidoItem.Create);
      Result[I].CodigoProduto := Qry.FieldByName('codigo_produto').AsInteger;
      Result[I].Descricao := Qry.FieldByName('descricao').AsString;
      Result[I].Quantidade := Qry.FieldByName('quantidade').AsInteger;
      Result[I].Total := Qry.FieldByName('valor_total').AsFloat;
      Result[I].Unitario := Qry.FieldByName('valor_unitario').AsFloat;
    end;

  finally
    FreeAndNil(Qry);
  end;
end;

function TPedidoModel.ConsultarPedido(Numero: Integer; var CodigoCliente: Integer;
  var NomeCliente: String; var Total: Double; var ListaItens: TObjectList<TPedidoItem>): Boolean;
var
  Qry: TFDQuery;
begin
  Result := False;

  CriaQry(Qry);
  try
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('select p.codigo_cliente, ');
    Qry.SQL.Add('       p.valor_total, ');
    Qry.SQL.Add('       c.nome ');
    Qry.SQL.Add('from pedidos p inner join clientes c on(c.codigo = p.codigo_cliente) ');
    Qry.SQL.Add('where p.numero_pedido = :numero; ');
    Qry.ParamByName('numero').AsInteger := Numero;
    Qry.Open;

    if Qry.RecordCount > 0 then
    begin
      Result := True;

      CodigoCliente := Qry.FieldByName('codigo_cliente').AsInteger;
      NomeCliente := Qry.FieldByName('nome').AsString;
      Total := Qry.FieldByName('valor_total').AsFloat;

      ListaItens := ConsultarItensPedido(Numero);
    end;
  finally
    FreeAndNil(Qry);
  end;
end;

constructor TPedidoModel.Create;
begin
  FListaPedidoItem := TObjectList<TPedidoItem>.Create;
end;

destructor TPedidoModel.Destroy;
begin
  FreeAndNil(FListaPedidoItem);
  inherited;
end;

function TPedidoModel.getNumero: Integer;
var
  Qry: TFDQuery;
begin
  CriaQry(Qry);
  try
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('select coalesce(max(numero_pedido), 0) + 1 as numero from pedidos');
    Qry.Open;

    Result := Qry.FieldByName('numero').AsInteger;
  finally
    FreeAndNil(Qry);
  end;
end;

function TPedidoModel.getIdPedidoItem: Integer;
var
  Qry: TFDQuery;
begin
  CriaQry(Qry);
  try
    Qry.Close;
    Qry.SQL.Clear;
    Qry.SQL.Add('select coalesce(max(id), 0) + 1 as id from pedidos_produtos');
    Qry.Open;

    Result := Qry.FieldByName('id').AsInteger;
  finally
    FreeAndNil(Qry);
  end;
end;

procedure TPedidoModel.GravarItem(numero_pedido, codigo, quantidade: Integer;
  unitario, total: Double);
var
  Qry: TFDQuery;
begin
  CriaQry(Qry);
  try
    Qry.SQL.Clear;
    Qry.SQL.Add('insert into pedidos_produtos(id, ');
    Qry.SQL.Add('                             numero_pedido, ');
    Qry.SQL.Add('                             codigo_produto, ');
    Qry.SQL.Add('                             quantidade, ');
    Qry.SQL.Add('                             valor_unitario, ');
    Qry.SQL.Add('                             valor_total) ');
    Qry.SQL.Add('                     values (:id, ');
    Qry.SQL.Add('                             :numero_pedido, ');
    Qry.SQL.Add('                             :codigo_produto, ');
    Qry.SQL.Add('                             :quantidade, ');
    Qry.SQL.Add('                             :valor_unitario, ');
    Qry.SQL.Add('                             :valor_total);');
    Qry.ParamByName('id').AsInteger := getIdPedidoItem;
    Qry.ParamByName('numero_pedido').AsInteger := numero_pedido;
    Qry.ParamByName('codigo_produto').AsInteger := codigo;
    Qry.ParamByName('quantidade').AsInteger := quantidade;
    Qry.ParamByName('valor_unitario').AsFloat := unitario;
    Qry.ParamByName('valor_total').AsFloat := total;
    Qry.ExecSQL;
  finally
    FreeAndNil(Qry);
  end;
end;

function TPedidoModel.GravarPedido: Integer;
var
  Qry: TFDQuery;
begin
  CriaQry(Qry);
  try
    Result := getNumero;

    Qry.SQL.Clear;
    Qry.SQL.Add('insert into pedidos(numero_pedido, ');
    Qry.SQL.Add('                    data_emissao, ');
    Qry.SQL.Add('                    codigo_cliente, ');
    Qry.SQL.Add('                    valor_total) ');
    Qry.SQL.Add('            values (:numero, ');
    Qry.SQL.Add('                    :data, ');
    Qry.SQL.Add('                    :cliente, ');
    Qry.SQL.Add('                    :total);');
    Qry.ParamByName('numero').AsInteger := Result;
    Qry.ParamByName('data').AsDate := Data;
    Qry.ParamByName('cliente').AsInteger := IdCliente;
    Qry.ParamByName('total').AsFloat := Total;
    Qry.ExecSQL;
  finally
    FreeAndNil(Qry);
  end;
end;

function TPedidoModel.FinalizarPedido: Boolean;
var
  Qry: TFDQuery;
  PedidoItem: TPedidoItem;
  Numero: Integer;
  Transacao : TDBXTransaction;
  S : String;
begin
  Result := False;

  if not DataModule1.Conexao.InTransaction then
    begin
      try
        DataModule1.Conexao.StartTransaction;

        Numero := GravarPedido;

        for PedidoItem in FListaPedidoItem do
            GravarItem(Numero,
                       PedidoItem.CodigoProduto,
                       PedidoItem.Quantidade,
                       PedidoItem.Unitario,
                       PedidoItem.FTotal);

        Result := True;

        DataModule1.Conexao.Commit;
      Except
        on E : Exception do
        begin
          Result := False;
          DataModule1.Conexao.Rollback;
          Abort;
        end;
      end;
    end;
end;

end.
