unit Pedido.Model;

interface

uses FireDAC.Comp.Client, System.SysUtils, FireDac.Stan.Param,
  System.Generics.Collections;

Type
  TPedidoItem = class
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
    public
      constructor Create;
      destructor Destroy; override;
      function GravarPedido: Boolean;
      procedure AdicionarPedidoItem(codigo_produto, quantidade: Integer; unitario,
        total: Double);

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
  FListaPedidoItem[I].FTotal := total;
  FListaPedidoItem[I].Unitario := unitario;
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
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DataModule1.Conexao;
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
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DataModule1.Conexao;
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
  Qry := TFDQuery.Create(nil);
  try
    Qry.Connection := DataModule1.Conexao;
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

function TPedidoModel.GravarPedido: Boolean;
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

        Qry := TFDQuery.Create(nil);
        try
          Qry.Connection := DataModule1.Conexao;

          Numero := getNumero;

          Qry.SQL.Clear;
          Qry.SQL.Add('insert into pedidos(numero_pedido, ');
          Qry.SQL.Add('                    data_emissao, ');
          Qry.SQL.Add('                    codigo_cliente, ');
          Qry.SQL.Add('                    valor_total) ');
          Qry.SQL.Add('            values (:numero, ');
          Qry.SQL.Add('                    :data, ');
          Qry.SQL.Add('                    :cliente, ');
          Qry.SQL.Add('                    :total);');
          Qry.ParamByName('numero').AsInteger := Numero;
          Qry.ParamByName('data').AsDate := Data;
          Qry.ParamByName('cliente').AsInteger := IdCliente;
          Qry.ParamByName('total').AsFloat := Total;
          Qry.ExecSQL;

          for PedidoItem in FListaPedidoItem do
            GravarItem(Numero,
                       PedidoItem.CodigoProduto,
                       PedidoItem.Quantidade,
                       PedidoItem.Unitario,
                       PedidoItem.FTotal);

          Result := True;
        finally
          FreeAndNil(Qry);
        end;

        DataModule1.Conexao.Commit;
      Except
        on E : Exception do
        begin
          S:= E.Message;
          Result := False;
          DataModule1.Conexao.Rollback;
          Abort;
        end;
      end;
    end;
end;

end.
