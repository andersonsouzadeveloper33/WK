unit Pedido.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Clientes.Control, Produtos.Control,
  Pedido.Control, Vcl.ExtCtrls;

type
  TfrmVenda = class(TForm)
    edtCodCliente: TEdit;
    Label1: TLabel;
    edtNomeCliente: TEdit;
    DbgItens: TDBGrid;
    cds: TClientDataSet;
    ds: TDataSource;
    cdsdescricao: TStringField;
    cdscodigo: TIntegerField;
    cdsunitario: TFloatField;
    cdstotal: TFloatField;
    BtnGravarPedido: TButton;
    lbTotalPedido: TLabel;
    cdsitem: TIntegerField;
    cdsquantidade: TIntegerField;
    BtnBuscarPedido: TButton;
    edtNumeroPedido: TEdit;
    Label6: TLabel;
    Bevel1: TBevel;
    btnCancelarPedido: TButton;
    PnAddProduto: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtCodProduto: TEdit;
    edtDescricao: TEdit;
    btnAdicionar: TButton;
    edtUnitario: TMaskEdit;
    edtTotal: TMaskEdit;
    edtQtd: TEdit;
    procedure edtUnitarioChange(Sender: TObject);
    procedure edtTotalChange(Sender: TObject);
    procedure edtQtdExit(Sender: TObject);
    procedure edtUnitarioExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure DbgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtCodClienteExit(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure edtCodProdutoKeyPress(Sender: TObject; var Key: Char);
    procedure edtCodClienteKeyPress(Sender: TObject; var Key: Char);
    procedure edtQtdKeyPress(Sender: TObject; var Key: Char);
    procedure BtnGravarPedidoClick(Sender: TObject);
    procedure BtnBuscarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
  private
    { Private declarations }
    ItemAlt: Integer;
    UltimoItem: Integer;
    FClienteControl: TClienteControl;
    FProdutoControl: TProdutoControl;
    FPedidoControl: TPedidoControl;
    FConsultandoPedido: Boolean;

    function CalculaTotalItem(Qtd, Unitario: Double) : Double;
    function CalculaTotalPedido : Double;
    procedure TotalizaItem;
    procedure AdicionarItem;
    procedure TotalizaPedido;
    procedure DeletarItem;
    procedure LimparAddItem;
    procedure LimparCliente;
    procedure AlterarItem;
    procedure ReordenarItem;
    procedure BuscarProduto(Codigo: Integer);
    procedure BuscarCliente(Codigo: Integer);
    function ValidaBuscarProduto: Boolean;
    function ValidaBuscarCliente: Boolean;
    procedure LimparPedido;
    function ValidaInformouCliente: Boolean;
    function ValidaInformouProdutos: Boolean;
    procedure LimpaBuscaPedido;
  public
    { Public declarations }
  end;

var
  frmVenda: TfrmVenda;

implementation

{$R *.dfm}

uses UntFuncoes;

{ TfrmVenda }

procedure TfrmVenda.AdicionarItem;
begin
  if ItemAlt > 0 then
  begin
    cds.Locate('item', ItemAlt, []);
    cds.Edit;
  end
  else
  begin
    UltimoItem := UltimoItem + 1;

    cds.Append;
    cdsitem.AsInteger := UltimoItem;
    cdscodigo.AsInteger := StrToInt(edtCodProduto.Text);
    cdsdescricao.AsString := edtDescricao.Text;
  end;
  cdsquantidade.AsFloat := StrToInt(edtQtd.Text);
  cdsunitario.AsFloat := StrToFloat(edtUnitario.Text);
  cdstotal.AsFloat := cdsquantidade.AsFloat * cdsunitario.AsFloat;
  cds.Post;
end;

procedure TfrmVenda.AlterarItem;
begin
  edtCodProduto.Text := cdscodigo.AsString;
  edtDescricao.Text := cdsdescricao.AsString;
  edtQtd.Text := IntToStr(cdsquantidade.AsInteger);
  edtUnitario.Text := FloatToStr(cdsunitario.AsFloat * 100);
  edtTotal.Text := FloatToStr(cdstotal.AsFloat * 100);
  edtCodProduto.ReadOnly := True;

  ItemAlt := cdsitem.AsInteger;
end;

procedure TfrmVenda.btnAdicionarClick(Sender: TObject);
begin
  AdicionarItem;
  TotalizaPedido;
  LimparAddItem;
  edtCodProduto.SetFocus;
end;

procedure TfrmVenda.BuscarCliente(Codigo: Integer);
begin
  if not FClienteControl.BuscarCliente(Codigo) then
  begin
    ShowMessage('Cliente não existe. Verifique!');
    edtCodCliente.SetFocus;
    edtNomeCliente.Clear;
    Exit;
  end;

  edtNomeCliente.Text := FClienteControl.Nome;
end;

procedure TfrmVenda.BuscarProduto(Codigo: Integer);
begin
  if not FProdutoControl.BuscarProduto(Codigo) then
  begin
    ShowMessage('Produto não existe. Verifique!');
    edtCodProduto.SetFocus;
    LimparAddItem;
    Exit;
  end;

  edtDescricao.Text := FProdutoControl.Descricao;
  edtUnitario.Text := FloatToStr(FProdutoControl.PrecoVenda * 100);
end;

function TfrmVenda.ValidaInformouCliente: Boolean;
begin
  Result := True;

  if edtCodCliente.Text = '' then
    Result := False;

  if edtCodCliente.Text = '0' then
    Result := False;
end;

function TfrmVenda.ValidaInformouProdutos: Boolean;
begin
  Result := True;

  if cds.Recordcount = 0 then
    Result := False;
end;

procedure TfrmVenda.BtnGravarPedidoClick(Sender: TObject);
begin
  if not ValidaInformouCliente then
  begin
    ShowMessage('Informe um cliente!');
    edtCodCliente.SetFocus;
    Exit;
  end;

  if not ValidaInformouProdutos then
  begin
    ShowMessage('Não tem nenhum item inserido no pedido. Verifique!');
    edtCodProduto.SetFocus;
    Exit;
  end;

  cds.First;
  while not cds.Eof do
  begin
    FPedidoControl.AdicionarPedidoItem(cdscodigo.AsInteger, cdsquantidade.AsInteger,
      cdsunitario.AsFloat, cdstotal.AsFloat);

    cds.next;
  end;

  if FPedidoControl.FinalizarPedido(StrToInt(edtCodCliente.Text), Date, CalculaTotalPedido) then
  begin
    ShowMessage('Pedido finalizado!');
    LimparPedido;
  end;
end;

procedure TfrmVenda.BtnBuscarPedidoClick(Sender: TObject);
var
  CodigoCliente: Integer;
  NomeCliente: String;
  Total: Double;
begin
  cds.EmptyDataSet;
  if not FPedidoControl.ConsultarPedido(StrToInt(edtNumeroPedido.Text),
    CodigoCliente, NomeCliente, Total, cds) then
  begin
    ShowMessage('Pedido não existe. Verifique!');
    FConsultandoPedido := False;
    Exit;
  end;

  edtNumeroPedido.ReadOnly := True;

  ReordenarItem;

  edtCodCliente.Text := IntToStr(CodigoCliente);
  edtNomeCliente.Text := NomeCliente;
  lbTotalPedido.Caption := 'Total do Pedido: '+FloatToStrF(Total, ffNumber, 10,2);

  btnCancelarPedido.Visible := True;
  BtnGravarPedido.Enabled := False;
  PnAddProduto.Visible := False;

  FConsultandoPedido := True;
end;

procedure TfrmVenda.btnCancelarPedidoClick(Sender: TObject);
begin
  if FPedidoControl.CancelarPedido(StrToInt(edtNumeroPedido.Text)) then
  begin
    ShowMessage('Pedido cancelado com sucesso!');
    LimpaBuscaPedido;
  end;
end;

function TfrmVenda.CalculaTotalItem(Qtd, Unitario: Double): Double;
begin
  Result := Qtd * Unitario;
end;

function TfrmVenda.CalculaTotalPedido: Double;
var
  Total: Double;
begin
  Total := 0;
  cds.First;
  while not cds.Eof do
  begin
    Total := Total + cdstotal.AsFloat;
    cds.Next;
  end;

  Result := Total;
end;

procedure TfrmVenda.DbgItensKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = Vk_Delete then
    if Application.MessageBox('ATENÇÃO: Deseja realmente deletar o item selecionado? ',
      'Confirmação', MB_yesno + MB_iconInformation) = mrYes then
    begin
      DeletarItem;
      TotalizaPedido;
    end;

  if Key = VK_RETURN then
  begin
    if cds.RecordCount = 0 then
      Exit;

    AlterarItem;
    TotalizaPedido;
  end;
end;

procedure TfrmVenda.DeletarItem;
begin
  cds.Delete;
  ReordenarItem;
end;

procedure TfrmVenda.edtCodClienteExit(Sender: TObject);
begin
  if ValidaBuscarCliente then
  begin
    BuscarCliente(StrToInt(edtCodCliente.Text));
    BtnBuscarPedido.Enabled := False;
  end
  else
    LimparCliente;
end;

procedure TfrmVenda.edtCodClienteKeyPress(Sender: TObject; var Key: Char);
begin
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back)) then
    key := #0;
end;

procedure TfrmVenda.edtCodProdutoExit(Sender: TObject);
begin
  if ValidaBuscarProduto then
    BuscarProduto(StrToInt(edtCodProduto.Text))
  else
    LimparAddItem;
end;

procedure TfrmVenda.edtCodProdutoKeyPress(Sender: TObject; var Key: Char);
begin
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back)) then
    key := #0;
end;

procedure TfrmVenda.edtQtdExit(Sender: TObject);
begin
  TotalizaItem;
end;

procedure TfrmVenda.edtQtdKeyPress(Sender: TObject; var Key: Char);
begin
  if ((key in ['0'..'9'] = false) and (word(key) <> vk_back)) then
    key := #0;
end;

procedure TfrmVenda.edtTotalChange(Sender: TObject);
begin
  edtTotal.Text := FormatarMoeda(edtTotal.Text);
  edtTotal.SelStart := Length(edtTotal.Text);
end;

procedure TfrmVenda.edtUnitarioChange(Sender: TObject);
begin
  edtUnitario.Text := FormatarMoeda(edtUnitario.Text);
  edtUnitario.SelStart := Length(edtUnitario.Text);
end;

procedure TfrmVenda.edtUnitarioExit(Sender: TObject);
begin
  TotalizaItem;
end;

procedure TfrmVenda.FormCreate(Sender: TObject);
begin
  LimparCliente;
  cds.CreateDataSet;
  LimparAddItem;
  UltimoItem := 0;
  FClienteControl := TClienteControl.Create;
  FProdutoControl := TProdutoControl.Create;
  FPedidoControl := TPedidoControl.Create;
end;

procedure TfrmVenda.LimpaBuscaPedido;
begin
  LimparPedido;
  LimparCliente;
  LimparAddItem;
  BtnGravarPedido.Enabled := True;
  btnCancelarPedido.Visible := False;
  PnAddProduto.Visible := True;
  edtNumeroPedido.Clear;
  edtNumeroPedido.ReadOnly := False;
end;

procedure TfrmVenda.LimparAddItem;
begin
  ItemAlt := 0;
  edtCodProduto.Text := '0';
  edtDescricao.Clear;
  edtQtd.Text := '0';
  edtUnitario.Text := '0.00';
  edtTotal.Text := 'Total do Pedido: 0.00';
  edtCodProduto.ReadOnly := False;
  edtCodProduto.Color := clWhite;
end;

procedure TfrmVenda.LimparCliente;
begin
  edtCodCliente.Text := '0';
  edtNomeCliente.Clear;
  BtnBuscarPedido.Enabled := True;
end;

procedure TfrmVenda.LimparPedido;
begin
  edtCodCliente.Text := '0';
  edtNomeCliente.Text := '';
  lbTotalPedido.Caption := 'Total do Pedido: 0,00';
  cds.EmptyDataSet;
end;

procedure TfrmVenda.ReordenarItem;
var
  Item: Integer;
begin
  cds.First;
  Item := 0;
  while not cds.Eof do
  begin
    Item := Item + 1;
    cds.Edit;
    cdsitem.AsInteger := Item;
    cds.Post;

    cds.Next;
  end;

  UltimoItem := Item;
end;

procedure TfrmVenda.TotalizaItem;
begin
  edtTotal.Text := FloatToStr(
    CalculaTotalItem(StrToInt(edtQtd.Text), StrToFloat(edtUnitario.Text)) * 100);
end;

procedure TfrmVenda.TotalizaPedido;
var
  BookMark: TBookmark;
begin
  BookMark := cds.GetBookmark;
  lbTotalPedido.Caption := 'Total do Pedido: '+ FloatToStrF(CalculaTotalPedido, ffNumber, 12,2);
  cds.GotoBookmark(BookMark);
end;

function TfrmVenda.ValidaBuscarCliente: Boolean;
begin
  Result := True;

  if edtCodCliente.Text = '' then
    Result := False;

  if edtCodCliente.Text = '0' then
    Result := False;
end;

function TfrmVenda.ValidaBuscarProduto: Boolean;
begin
  Result := True;

  if edtCodProduto.Text = '' then
    Result := False;

  if edtCodProduto.Text = '0' then
    Result := False;
end;

end.
