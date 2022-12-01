object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 228
  Width = 316
  object Conexao: TFDConnection
    Params.Strings = (
      'Database=wkdatabase'
      'User_Name=root'
      'Password=1234'
      'DriverID=MySQL')
    LoginPrompt = False
    Left = 56
    Top = 28
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Windows\SysWOW64\libmysql.dll'
    Left = 148
    Top = 32
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 142
    Top = 98
  end
end
