unit UnitDB;

interface

uses
  System.SysUtils, System.Classes, Vcl.Dialogs, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf;

type
  TModulDB = class(TDataModule)
    Koneksi: TFDConnection;
    QBarang: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ModulDB: TModulDB;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TModulDB.DataModuleCreate(Sender: TObject);
var
  ExeDir, DbPath: string;
begin
  ExeDir := ExtractFilePath(ParamStr(0));

  // 1. Cek di folder tempat Exe berada (Win32\Debug)
  if FileExists(ExeDir + 'DatabaseDLH.db') then
    DbPath := ExeDir + 'DatabaseDLH.db'
  // 2. Cek 2 tingkat ke atas (Folder Utama Proyek)
  else if FileExists(ExpandFileName(ExeDir + '..\..\DatabaseDLH.db')) then
    DbPath := ExpandFileName(ExeDir + '..\..\DatabaseDLH.db')
  // 3. Cek 1 tingkat ke atas
  else if FileExists(ExpandFileName(ExeDir + '..\DatabaseDLH.db')) then
    DbPath := ExpandFileName(ExeDir + '..\DatabaseDLH.db')
  else
    DbPath := ExpandFileName('DatabaseDLH.db');

  Koneksi.Connected := False;
  Koneksi.Params.Values['Database'] := DbPath;
  Koneksi.Params.Values['BusyTimeout'] := '10000';
  Koneksi.Params.Values['JournalMode'] := 'WAL';
  Koneksi.Params.Values['LockingMode'] := 'Normal';

  try
    Koneksi.Connected := True;

    // Auto Migrasi Kolom jika belum ada
    try
      Koneksi.ExecSQL('ALTER TABLE Tabel_Keluar ADD COLUMN No_Pengajuan VARCHAR(50)');
    except
    end;

    try
      Koneksi.ExecSQL('ALTER TABLE Tabel_Pengajuan ADD COLUMN Bukti_Foto VARCHAR(255)');
    except
    end;

    try
      Koneksi.ExecSQL('ALTER TABLE Tabel_Barang ADD COLUMN Harga_Satuan REAL DEFAULT 0');
    except
    end;

    if not QBarang.Active then
      QBarang.Open;
  except
    on E: Exception do
      ShowMessage('Gagal terhubung ke database inventaris. Silakan periksa ketersediaan file DatabaseDLH.db.');
  end;
end;

end.
