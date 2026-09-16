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
    BtnHistory: TButton;
    BtnMaster: TButton;
    PnlUtama: TPanel;
    PnlCharts: TGridPanel;
    ChartTanaman: TChart;
    ChartATK: TChart;
    ChartKertas: TChart;
    ChartKomputer: TChart;
    PnlSpacer: TPanel;
    PnlCari: TPanel;
    LblCari: TLabel;
    EdCari: TEdit;
    LblKategori: TLabel;
    CmbKategori: TComboBox;
    ChkHideZero: TCheckBox;
    BtnDownload: TButton;
    GridStok: TStringGrid;
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnMasukClick(Sender: TObject);
    procedure BtnPengajuanClick(Sender: TObject);
    procedure BtnValidasiClick(Sender: TObject);
    procedure BtnHistoryClick(Sender: TObject);
    procedure BtnMasterClick(Sender: TObject);
    procedure EdCariChange(Sender: TObject);
    procedure CmbKategoriChange(Sender: TObject);
    procedure ChkHideZeroClick(Sender: TObject);
    procedure BtnDownloadClick(Sender: TObject);
  private
    SeriesTanaman: TBarSeries;
    SeriesATK: TBarSeries;
    SeriesKertas: TBarSeries;
    SeriesKomputer: TBarSeries;
    procedure InitCharts;
    procedure TampilDataAwal;
    procedure LoadKategoriCombo;
  public
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3, Unit4, Unit5, Unit6, UnitDB;

{$R *.dfm}

procedure TForm1.InitCharts;
begin
  // Sembunyikan legenda samping yang menutupi/memotong angka besar
  ChartTanaman.Legend.Visible := False;
  ChartTanaman.FreeAllSeries;
  SeriesTanaman := TBarSeries.Create(ChartTanaman);
  SeriesTanaman.ParentChart := ChartTanaman;
  SeriesTanaman.ColorEachPoint := True;
  SeriesTanaman.Marks.Visible := True;
  SeriesTanaman.Marks.Style := smsValue;
  SeriesTanaman.ValueFormat := '0'; // Format angka bulat murni tanpa titik pemisah ribuan

  ChartATK.Legend.Visible := False;
  ChartATK.FreeAllSeries;
  SeriesATK := TBarSeries.Create(ChartATK);
  SeriesATK.ParentChart := ChartATK;
  SeriesATK.ColorEachPoint := True;
  SeriesATK.Marks.Visible := True;
  SeriesATK.Marks.Style := smsValue;
  SeriesATK.ValueFormat := '0';

  ChartKertas.Legend.Visible := False;
  ChartKertas.FreeAllSeries;
  SeriesKertas := TBarSeries.Create(ChartKertas);
  SeriesKertas.ParentChart := ChartKertas;
  SeriesKertas.ColorEachPoint := True;
  SeriesKertas.Marks.Visible := True;
  SeriesKertas.Marks.Style := smsValue;
  SeriesKertas.ValueFormat := '0';

  ChartKomputer.Legend.Visible := False;
  ChartKomputer.FreeAllSeries;
  SeriesKomputer := TBarSeries.Create(ChartKomputer);
  SeriesKomputer.ParentChart := ChartKomputer;
  SeriesKomputer.ColorEachPoint := True;
  SeriesKomputer.Marks.Visible := True;
  SeriesKomputer.Marks.Style := smsValue;
  SeriesKomputer.ValueFormat := '0';
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

  InitCharts;
  LoadKategoriCombo;
  TampilDataAwal;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LoadKategoriCombo;
  TampilDataAwal;
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
  StokSisa: Integer;
  Q: TFDQuery;
  MatchSearch, MatchKat, MatchStok: Boolean;
begin
  SeriesTanaman.Clear;
  SeriesATK.Clear;
  SeriesKertas.Clear;
  SeriesKomputer.Clear;

  GridStok.RowCount := 2;
  GridStok.Rows[1].Clear;
  BarisTabel := 1;

  SearchKey := LowerCase(Trim(EdCari.Text));
  SelectedKat := Trim(CmbKategori.Text);

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT Kode_Rekening, Nama_Barang, Kategori, Satuan, Stok_Sisa FROM Tabel_Barang ORDER BY Nama_Barang ASC';
    Q.Open;

    while not Q.Eof do
    begin
      Kat := Q.FieldByName('Kategori').AsString;
      StokSisa := Q.FieldByName('Stok_Sisa').AsInteger;

      MatchSearch := (SearchKey = '') or
                     (Pos(SearchKey, LowerCase(Q.FieldByName('Kode_Rekening').AsString)) > 0) or
                     (Pos(SearchKey, LowerCase(Q.FieldByName('Nama_Barang').AsString)) > 0);

      MatchKat := (SelectedKat = '') or (SelectedKat = 'Semua Kategori') or (Kat = SelectedKat);

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

        if Kat = 'Bibit Tanaman' then
          SeriesTanaman.Add(StokSisa, Q.FieldByName('Nama_Barang').AsString)
        else if Kat = 'ATK' then
          SeriesATK.Add(StokSisa, Q.FieldByName('Nama_Barang').AsString)
        else if Kat = 'Kertas & Cover' then
          SeriesKertas.Add(StokSisa, Q.FieldByName('Nama_Barang').AsString)
        else if Kat = 'Bahan Komputer' then
          SeriesKomputer.Add(StokSisa, Q.FieldByName('Nama_Barang').AsString);

        Inc(BarisTabel);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
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

procedure TForm1.BtnHistoryClick(Sender: TObject);
begin
  Form5.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnMasterClick(Sender: TObject);
begin
  Form6.ShowModal;
  TampilDataAwal;
end;

end.
