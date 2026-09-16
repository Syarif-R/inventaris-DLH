object ModulDB: TModulDB
  OnCreate = DataModuleCreate
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object Koneksi: TFDConnection
    Params.Strings = (
      'Database=DatabaseDLH.db'
      'DriverID=SQLite'
      'BusyTimeout=10000'
      'JournalMode=WAL'
      'LockingMode=Normal')
    Left = 488
    Top = 216
  end
  object QBarang: TFDQuery
    Connection = Koneksi
    SQL.Strings = (
      'SELECT * FROM Tabel_Barang')
    Left = 352
    Top = 352
  end
end
