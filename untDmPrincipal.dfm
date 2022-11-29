object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 228
  Width = 316
  object Conexao: TFDConnection
    Params.Strings = (
      'Database=E:\Teste WK\BD\bd.db'
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 56
    Top = 28
  end
end
