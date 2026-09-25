unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  VCLTee.Chart, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm1 = class(TForm)
    PnlAtas: TPanel;
    PnlKiri: TPanel;
    BtnMasuk: TButton;
    BtnPengajuan: TButton;
    BtnValidasi: TButton;
    BtnArsipValidasi: TButton;
    BtnHistory: TButton;
    BtnStockOpname: TButton;
    BtnBackup: TButton;
    PnlAlertBox: TPanel;
    LblAlertJudul: TLabel;
    BtnAlertStok: TButton;
    BtnRefreshDashboard: TButton;
    PnlUtama: TPanel;
    PnlCharts: TGridPanel;
    ChartKategori: TChart;
    ChartTopStok: TChart;
    PnlSpacer: TPanel;
    PnlCari: TPanel;
    LblCari: TLabel;
    EdCari: TEdit;
    LblKategori: TLabel;
    CmbKategori: TComboBox;
    ChkHideZero: TCheckBox;
    BtnDownload: TButton;
    BtnTambahBarang: TButton;
    BtnEditBarang: TButton;
    BtnHapusBarang: TButton;
    LblPetunjukGrid: TLabel;
    GridStok: TStringGrid;
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnMasukClick(Sender: TObject);
    procedure BtnPengajuanClick(Sender: TObject);
    procedure BtnValidasiClick(Sender: TObject);
    procedure BtnArsipValidasiClick(Sender: TObject);
    procedure BtnHistoryClick(Sender: TObject);
    procedure BtnStockOpnameClick(Sender: TObject);
    procedure BtnBackupClick(Sender: TObject);
    procedure BtnAlertStokClick(Sender: TObject);
    procedure BtnRefreshDashboardClick(Sender: TObject);
    procedure EdCariChange(Sender: TObject);
    procedure CmbKategoriChange(Sender: TObject);
    procedure ChkHideZeroClick(Sender: TObject);
    procedure BtnDownloadClick(Sender: TObject);
    procedure BtnTambahBarangClick(Sender: TObject);
    procedure BtnEditBarangClick(Sender: TObject);
    procedure BtnHapusBarangClick(Sender: TObject);
    procedure GridStokDblClick(Sender: TObject);
  private
    SeriesKategori: TBarSeries;
    SeriesTopStok: TBarSeries;
    FFilterKritisOnly: Boolean;
    procedure InitCharts;
    procedure TampilDataAwal;
    procedure LoadKategoriCombo;
  public
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit7, Unit8, Unit9, UnitDB;

{$R *.dfm}

procedure TForm1.InitCharts;
begin
  // Chart 1: Total Stok per Kategori Persediaan
  ChartKategori.Legend.Visible := False;
  ChartKategori.FreeAllSeries;
  SeriesKategori := TBarSeries.Create(ChartKategori);
  SeriesKategori.ParentChart := ChartKategori;
  SeriesKategori.ColorEachPoint := True;
  SeriesKategori.Marks.Visible := True;
  SeriesKategori.Marks.Style := smsValue;
  SeriesKategori.ValueFormat := '0';

  // Chart 2: Top Barang Stok Terbanyak (Stok > 0)
  ChartTopStok.Legend.Visible := False;
  ChartTopStok.FreeAllSeries;
  SeriesTopStok := TBarSeries.Create(ChartTopStok);
  SeriesTopStok.ParentChart := ChartTopStok;
  SeriesTopStok.ColorEachPoint := True;
  SeriesTopStok.Marks.Visible := True;
  SeriesTopStok.Marks.Style := smsValue;
  SeriesTopStok.ValueFormat := '0';
end;

procedure TForm1.LoadKategoriCombo;
var
  Q: TFDQuery;
  CurrKat: string;
begin
  CurrKat := CmbKategori.Text;
  CmbKategori.Items.BeginUpdate;
  try
    CmbKategori.Items.Clear;
    CmbKategori.Items.Add('Semua Kategori');

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := ModulDB.Koneksi;
      Q.SQL.Text := 'SELECT DISTINCT Kategori FROM Tabel_Barang WHERE Kategori IS NOT NULL AND Kategori <> '''' ORDER BY Kategori ASC';
      Q.Open;
      while not Q.Eof do
      begin
        CmbKategori.Items.Add(Q.Fields[0].AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    CmbKategori.Items.EndUpdate;
  end;

  if (CurrKat <> '') and (CmbKategori.Items.IndexOf(CurrKat) >= 0) then
    CmbKategori.ItemIndex := CmbKategori.Items.IndexOf(CurrKat)
  else
    CmbKategori.ItemIndex := 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Aplikasi Inventaris DLH - Dashboard Utama';
  Self.WindowState := wsMaximized;

  GridStok.Cells[0, 0] := 'No';
  GridStok.Cells[1, 0] := 'Kode Rekening';
  GridStok.Cells[2, 0] := 'Nama Persediaan';
  GridStok.Cells[3, 0] := 'Kategori';
  GridStok.Cells[4, 0] := 'Satuan';
  GridStok.Cells[5, 0] := 'Sisa Stok';

  ChkHideZero.Checked := True;
  FFilterKritisOnly := False;
  InitCharts;
  LoadKategoriCombo;
  TampilDataAwal;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LoadKategoriCombo;
  TampilDataAwal;
  Form9.AutoBackupIfNeeded;
end;

procedure TForm1.FormResize(Sender: TObject);
var
  LebarTersisa: Integer;
begin
  LebarTersisa := GridStok.ClientWidth - 40 - 80 - 100;

  if LebarTersisa > 0 then
  begin
    GridStok.ColWidths[0] := 40;
    GridStok.ColWidths[1] := Trunc(LebarTersisa * 0.25);
    GridStok.ColWidths[2] := Trunc(LebarTersisa * 0.50);
    GridStok.ColWidths[3] := Trunc(LebarTersisa * 0.25);
    GridStok.ColWidths[4] := 80;
    GridStok.ColWidths[5] := 100;
  end;
end;

procedure TForm1.TampilDataAwal;
var
  BarisTabel: Integer;
  SearchKey, SelectedKat, Kat, SisaStokStr: string;
  StokSisa, CountKritis, CountPending: Integer;
  Q, QKat, QTop, QAlert: TFDQuery;
  MatchSearch, MatchKat, MatchStok: Boolean;
begin
  // 0. Update Alert Box Status & Peringatan
  QAlert := TFDQuery.Create(nil);
  try
    QAlert.Connection := ModulDB.Koneksi;
    QAlert.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Barang WHERE Stok_Sisa <= 5 AND Stok_Sisa > 0';
    QAlert.Open;
    CountKritis := QAlert.Fields[0].AsInteger;

    QAlert.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Pengajuan WHERE Status = ''PENDING''';
    QAlert.Open;
    CountPending := QAlert.Fields[0].AsInteger;

    // Tampilkan tanda / badge jumlah pending langsung di tombol menu Validasi Pengajuan
    if CountPending > 0 then
      BtnValidasi.Caption := 'Validasi Pengajuan (' + IntToStr(CountPending) + ')'
    else
      BtnValidasi.Caption := 'Validasi Pengajuan';

    BtnArsipValidasi.Caption := 'Arsip Dokumen Fisik';

    if FFilterKritisOnly then
      BtnAlertStok.Caption := 'Filter Kritis (' + IntToStr(CountKritis) + ' Item)'
    else if CountKritis > 0 then
      BtnAlertStok.Caption := '⚠️ ' + IntToStr(CountKritis) + ' Barang Kritis (<= 5)'
    else
      BtnAlertStok.Caption := '✅ Semua Stok Aman';

    BtnRefreshDashboard.Caption := #$21BB + '  Segarkan Status';
  finally
    QAlert.Free;
  end;

  // 1. Tampilkan Data Grid Stok (Prioritaskan stok > 0 terlebih dahulu)
  GridStok.RowCount := 2;
  GridStok.Rows[1].Clear;
  BarisTabel := 1;

  SearchKey := LowerCase(Trim(EdCari.Text));
  SelectedKat := Trim(CmbKategori.Text);

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    // ORDER BY CASE WHEN Stok_Sisa > 0 THEN 0 ELSE 1 END -> barang bersaldo 0 tidak akan muncul pertama
    Q.SQL.Text := 'SELECT Kode_Rekening, Nama_Barang, Kategori, Satuan, Stok_Sisa FROM Tabel_Barang ' +
                  'ORDER BY CASE WHEN Stok_Sisa > 0 THEN 0 ELSE 1 END, Nama_Barang ASC';
    Q.Open;

    while not Q.Eof do
    begin
      Kat := Q.FieldByName('Kategori').AsString;
      StokSisa := Q.FieldByName('Stok_Sisa').AsInteger;

      MatchSearch := (SearchKey = '') or
                     (Pos(SearchKey, LowerCase(Q.FieldByName('Kode_Rekening').AsString)) > 0) or
                     (Pos(SearchKey, LowerCase(Q.FieldByName('Nama_Barang').AsString)) > 0);

      MatchKat := (SelectedKat = '') or (SelectedKat = 'Semua Kategori') or (Kat = SelectedKat);

      if FFilterKritisOnly then
        MatchStok := (StokSisa <= 5) and (StokSisa > 0)
      else
        MatchStok := not (ChkHideZero.Checked and (StokSisa <= 0));

      if MatchSearch and MatchKat and MatchStok then
      begin
        if BarisTabel >= GridStok.RowCount then
          GridStok.RowCount := BarisTabel + 1;

        SisaStokStr := IntToStr(StokSisa);

        GridStok.Cells[0, BarisTabel] := IntToStr(BarisTabel);
        GridStok.Cells[1, BarisTabel] := Q.FieldByName('Kode_Rekening').AsString;
        GridStok.Cells[2, BarisTabel] := Q.FieldByName('Nama_Barang').AsString;
        GridStok.Cells[3, BarisTabel] := Kat;
        GridStok.Cells[4, BarisTabel] := Q.FieldByName('Satuan').AsString;
        GridStok.Cells[5, BarisTabel] := SisaStokStr;

        Inc(BarisTabel);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  // 2. Tampilkan Chart 1: Ringkasan Total Stok per Kategori (Rapi, Hanya 5 Baris Kategori)
  SeriesKategori.Clear;
  QKat := TFDQuery.Create(nil);
  try
    QKat.Connection := ModulDB.Koneksi;
    QKat.SQL.Text := 'SELECT Kategori, SUM(Stok_Sisa) AS TotalStok FROM Tabel_Barang ' +
                     'WHERE Kategori IS NOT NULL AND Kategori <> '''' ' +
                     'GROUP BY Kategori ORDER BY TotalStok DESC';
    QKat.Open;
    while not QKat.Eof do
    begin
      if not (ChkHideZero.Checked and (QKat.FieldByName('TotalStok').AsInteger <= 0)) then
        SeriesKategori.Add(QKat.FieldByName('TotalStok').AsInteger, QKat.FieldByName('Kategori').AsString);
      QKat.Next;
    end;
  finally
    QKat.Free;
  end;

  // 3. Tampilkan Chart 2: Top Barang Stok Terbanyak (Hanya Stok > 0, Max 7 Item Agar Tidak Penuh)
  SeriesTopStok.Clear;
  QTop := TFDQuery.Create(nil);
  try
    QTop.Connection := ModulDB.Koneksi;
    if (SelectedKat = '') or (SelectedKat = 'Semua Kategori') then
    begin
      ChartTopStok.Title.Text.Text := 'TOP 7 BARANG STOK TERBANYAK (STOK > 0)';
      QTop.SQL.Text := 'SELECT Nama_Barang, Stok_Sisa FROM Tabel_Barang ' +
                       'WHERE Stok_Sisa > 0 ORDER BY Stok_Sisa DESC LIMIT 7';
    end
    else
    begin
      ChartTopStok.Title.Text.Text := 'TOP STOK: ' + UpperCase(SelectedKat) + ' (STOK > 0)';
      QTop.SQL.Text := 'SELECT Nama_Barang, Stok_Sisa FROM Tabel_Barang ' +
                       'WHERE Stok_Sisa > 0 AND Kategori = :kat ORDER BY Stok_Sisa DESC LIMIT 7';
      QTop.ParamByName('kat').AsString := SelectedKat;
    end;
    QTop.Open;
    while not QTop.Eof do
    begin
      SeriesTopStok.Add(QTop.FieldByName('Stok_Sisa').AsInteger, QTop.FieldByName('Nama_Barang').AsString);
      QTop.Next;
    end;
  finally
    QTop.Free;
  end;
end;

procedure TForm1.EdCariChange(Sender: TObject);
begin
  TampilDataAwal;
end;

procedure TForm1.CmbKategoriChange(Sender: TObject);
begin
  TampilDataAwal;
end;

procedure TForm1.ChkHideZeroClick(Sender: TObject);
begin
  TampilDataAwal;
end;

procedure TForm1.BtnDownloadClick(Sender: TObject);
var
  DataExcel: TStringList;
  Kolom, Baris: Integer;
  BarisTeks, NilaiCell: string;
begin
  SaveDialog1.Title := 'Simpan Laporan Stock Opname';
  SaveDialog1.Filter := 'File Excel (CSV)|*.csv';
  SaveDialog1.DefaultExt := 'csv';
  SaveDialog1.FileName := 'Laporan_Opname_DLH.csv';

  if SaveDialog1.Execute then
  begin
    DataExcel := TStringList.Create;
    try
      for Baris := 0 to GridStok.RowCount - 1 do
      begin
        if (Baris > 0) and (GridStok.Cells[1, Baris] = '') then Continue;

        BarisTeks := '';
        for Kolom := 0 to GridStok.ColCount - 1 do
        begin
          NilaiCell := GridStok.Cells[Kolom, Baris];
          if Pos(';', NilaiCell) > 0 then
            NilaiCell := '"' + NilaiCell + '"';

          if Kolom = 0 then
            BarisTeks := NilaiCell
          else
            BarisTeks := BarisTeks + ';' + NilaiCell;
        end;
        DataExcel.Add(BarisTeks);
      end;

      DataExcel.SaveToFile(SaveDialog1.FileName, TEncoding.UTF8);
      ShowMessage('Sukses! Laporan berhasil diunduh ke Excel.');
    finally
      DataExcel.Free;
    end;
  end;
end;

procedure TForm1.BtnMasukClick(Sender: TObject);
begin
  Form2.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnPengajuanClick(Sender: TObject);
begin
  Form3.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnValidasiClick(Sender: TObject);
begin
  Form4.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnArsipValidasiClick(Sender: TObject);
begin
  Form8.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnHistoryClick(Sender: TObject);
begin
  Form5.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnTambahBarangClick(Sender: TObject);
begin
  Form6.BukaTambahBarang;
  LoadKategoriCombo;
  TampilDataAwal;
end;

procedure TForm1.BtnEditBarangClick(Sender: TObject);
var
  RowIdx: Integer;
  Kode: string;
begin
  RowIdx := GridStok.Row;
  if (RowIdx <= 0) or (GridStok.Cells[1, RowIdx] = '') then
  begin
    MessageDlg('Pilih salah satu baris barang pada tabel terlebih dahulu untuk diedit.', mtInformation, [mbOK], 0);
    Exit;
  end;

  Kode := GridStok.Cells[1, RowIdx];
  Form6.BukaEditBarang(Kode);
  LoadKategoriCombo;
  TampilDataAwal;
end;

procedure TForm1.GridStokDblClick(Sender: TObject);
begin
  BtnEditBarangClick(Sender);
end;

procedure TForm1.BtnHapusBarangClick(Sender: TObject);
var
  RowIdx: Integer;
  Kode, NamaBarang: string;
  QCheck: TFDQuery;
  CountTrx: Integer;
begin
  RowIdx := GridStok.Row;
  if (RowIdx <= 0) or (GridStok.Cells[1, RowIdx] = '') then
  begin
    MessageDlg('Pilih salah satu baris barang pada tabel terlebih dahulu untuk dihapus.', mtInformation, [mbOK], 0);
    Exit;
  end;

  Kode := GridStok.Cells[1, RowIdx];
  NamaBarang := GridStok.Cells[2, RowIdx];

  // Periksa apakah barang sudah pernah memiliki transaksi (Tabel_Masuk atau Tabel_Detail_Pengajuan)
  QCheck := TFDQuery.Create(nil);
  try
    QCheck.Connection := ModulDB.Koneksi;
    QCheck.SQL.Text := 'SELECT ' +
                       '(SELECT COUNT(*) FROM Tabel_Masuk WHERE Kode_Rekening = :k1) + ' +
                       '(SELECT COUNT(*) FROM Tabel_Detail_Pengajuan WHERE Kode_Rekening = :k2)';
    QCheck.ParamByName('k1').AsString := Kode;
    QCheck.ParamByName('k2').AsString := Kode;
    QCheck.Open;
    CountTrx := QCheck.Fields[0].AsInteger;

    if CountTrx > 0 then
    begin
      MessageDlg('Barang "' + NamaBarang + '" (' + Kode + ') TIDAK DAPAT DIHAPUS' + sLineBreak +
                 'karena sudah memiliki riwayat transaksi penerimaan / pengajuan di database.' + sLineBreak +
                 'Hanya barang yang belum memiliki riwayat transaksi yang aman dihapus.', mtWarning, [mbOK], 0);
      Exit;
    end;

    if MessageDlg('Apakah Anda yakin ingin menghapus barang master ini dari katalog inventaris?' + sLineBreak + sLineBreak +
                  'Kode Rekening: ' + Kode + sLineBreak +
                  'Nama Persediaan: ' + NamaBarang, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      QCheck.Close;
      QCheck.SQL.Text := 'DELETE FROM Tabel_Barang WHERE Kode_Rekening = :k';
      QCheck.ParamByName('k').AsString := Kode;
      QCheck.ExecSQL;

      ShowMessage('Barang "' + NamaBarang + '" berhasil dihapus dari sistem.');
      LoadKategoriCombo;
      TampilDataAwal;
    end;
  finally
    QCheck.Free;
  end;
end;

procedure TForm1.BtnStockOpnameClick(Sender: TObject);
begin
  Form7.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnBackupClick(Sender: TObject);
begin
  Form9.ShowModal;
end;

procedure TForm1.BtnAlertStokClick(Sender: TObject);
begin
  FFilterKritisOnly := not FFilterKritisOnly;
  TampilDataAwal;
end;

procedure TForm1.BtnRefreshDashboardClick(Sender: TObject);
begin
  FFilterKritisOnly := False;
  LoadKategoriCombo;
  TampilDataAwal;
end;

end.
