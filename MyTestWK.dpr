program MyTestWK;

uses
  Vcl.Forms,
  Pedido.View in 'View\Pedido.View.pas' {frmVenda},
  UntFuncoes in 'Utils\UntFuncoes.pas',
  Clientes.Model in 'Model\Clientes.Model.pas',
  untDmPrincipal in 'untDmPrincipal.pas' {DataModule1: TDataModule},
  Clientes.Control in 'Control\Clientes.Control.pas',
  Produtos.Model in 'Model\Produtos.Model.pas',
  Produtos.Control in 'Control\Produtos.Control.pas',
  Pedido.Model in 'Model\Pedido.Model.pas',
  Pedido.Control in 'Control\Pedido.Control.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfrmVenda, frmVenda);
  Application.Run;
end.
