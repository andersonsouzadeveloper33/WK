object frmVenda: TfrmVenda
  Left = 0
  Top = 0
  Caption = 'Vendas'
  ClientHeight = 358
  ClientWidth = 622
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 424
    Top = 6
    Width = 185
    Height = 50
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 12
    Top = 18
    Width = 87
    Height = 13
    Caption = 'Informe o Cliente:'
  end
  object lbTotalPedido: TLabel
    Left = 12
    Top = 324
    Width = 257
    Height = 23
    AutoSize = False
    Caption = '0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 432
    Top = 13
    Width = 47
    Height = 13
    Caption = 'N'#186' Pedido'
  end
  object edtCodCliente: TEdit
    Left = 12
    Top = 35
    Width = 51
    Height = 21
    TabOrder = 0
    OnExit = edtCodClienteExit
    OnKeyPress = edtCodClienteKeyPress
  end
  object edtNomeCliente: TEdit
    Left = 66
    Top = 35
    Width = 352
    Height = 21
    TabStop = False
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object DbgItens: TDBGrid
    Left = 12
    Top = 109
    Width = 597
    Height = 205
    DataSource = ds
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnKeyDown = DbgItensKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'item'
        Title.Caption = 'Item'
        Width = 37
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'codigo'
        ReadOnly = True
        Title.Caption = 'C'#243'digo'
        Width = 49
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'descricao'
        ReadOnly = True
        Title.Caption = 'Descri'#231#227'o'
        Width = 280
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'quantidade'
        ReadOnly = True
        Title.Caption = 'Quantidade'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'unitario'
        ReadOnly = True
        Title.Caption = 'Unit'#225'rio'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'total'
        ReadOnly = True
        Title.Caption = 'Total'
        Visible = True
      end>
  end
  object BtnGravarPedido: TButton
    Left = 456
    Top = 320
    Width = 153
    Height = 33
    Cursor = crHandPoint
    Caption = 'GRAVAR PEDIDO'
    TabOrder = 4
    OnClick = BtnGravarPedidoClick
  end
  object BtnBuscarPedido: TButton
    Left = 522
    Top = 27
    Width = 83
    Height = 23
    Cursor = crHandPoint
    Caption = 'BUSCAR'
    TabOrder = 5
    OnClick = BtnBuscarPedidoClick
  end
  object edtNumeroPedido: TEdit
    Left = 432
    Top = 29
    Width = 77
    Height = 21
    TabOrder = 6
    OnExit = edtCodClienteExit
    OnKeyPress = edtCodClienteKeyPress
  end
  object btnCancelarPedido: TButton
    Left = 298
    Top = 320
    Width = 153
    Height = 33
    Cursor = crHandPoint
    Caption = 'CANCELAR PEDIDO'
    TabOrder = 7
    Visible = False
    OnClick = btnCancelarPedidoClick
  end
  object PnAddProduto: TPanel
    Left = 12
    Top = 60
    Width = 597
    Height = 45
    BevelKind = bkFlat
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object Label2: TLabel
      Left = 4
      Top = 2
      Width = 88
      Height = 13
      Caption = 'Informe o Produto'
    end
    object Label3: TLabel
      Left = 290
      Top = 2
      Width = 56
      Height = 13
      Caption = 'Quantidade'
    end
    object Label4: TLabel
      Left = 352
      Top = 2
      Width = 53
      Height = 13
      Caption = 'R$ Unit'#225'rio'
    end
    object Label5: TLabel
      Left = 430
      Top = 2
      Width = 40
      Height = 13
      Caption = 'R$ Total'
    end
    object edtCodProduto: TEdit
      Left = 4
      Top = 16
      Width = 51
      Height = 21
      TabOrder = 0
      OnExit = edtCodProdutoExit
      OnKeyPress = edtCodProdutoKeyPress
    end
    object edtDescricao: TEdit
      Left = 58
      Top = 16
      Width = 226
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object btnAdicionar: TButton
      Left = 505
      Top = 14
      Width = 86
      Height = 23
      Cursor = crHandPoint
      Caption = 'ADICIONAR'
      TabOrder = 5
      OnClick = btnAdicionarClick
    end
    object edtUnitario: TMaskEdit
      Left = 352
      Top = 16
      Width = 72
      Height = 21
      TabOrder = 3
      Text = ''
      OnChange = edtUnitarioChange
      OnExit = edtUnitarioExit
    end
    object edtTotal: TMaskEdit
      Left = 430
      Top = 16
      Width = 71
      Height = 21
      TabStop = False
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
      Text = ''
      OnChange = edtTotalChange
    end
    object edtQtd: TEdit
      Left = 290
      Top = 16
      Width = 56
      Height = 21
      TabOrder = 2
      OnExit = edtQtdExit
      OnKeyPress = edtQtdKeyPress
    end
  end
  object cds: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 306
    Top = 198
    object cdsdescricao: TStringField
      FieldName = 'descricao'
      Size = 60
    end
    object cdscodigo: TIntegerField
      FieldName = 'codigo'
    end
    object cdsunitario: TFloatField
      FieldName = 'unitario'
      DisplayFormat = ',#0.00'
      EditFormat = '0.00'
    end
    object cdstotal: TFloatField
      FieldName = 'total'
      DisplayFormat = ',#0.00'
      EditFormat = '0.00'
    end
    object cdsitem: TIntegerField
      FieldName = 'item'
    end
    object cdsquantidade: TIntegerField
      FieldName = 'quantidade'
    end
  end
  object ds: TDataSource
    DataSet = cds
    Left = 340
    Top = 200
  end
end
