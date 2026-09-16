unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm5 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    BtnKembali: TButton;
    PnlFilter: TPanel;
    LblKategori: TLabel;
    CboJenisHistory: TComboBox;
    LblCari: TLabel;
    EdCariHistory: TEdit;
    LblDari: TLabel;
    DTPDari: TDateTimePicker;
    LblSampai: TLabel;
    DTPSampai: TDateTimePicker;
    ChkFilterTanggal: TCheckBox;
    BtnCetak: TButton;
    GridHistory: TStringGrid;
    PnlFooter: TPanel;
    LblTotalRecord: TLabel;
    LblPetunjuk: TLabel;
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CboJenisHistoryChange(Sender: TObject);
    procedure EdCariHistoryChange(Sender: TObject);
    procedure DTPDariChange(Sender: TObject);
    procedure DTPSampaiChange(Sender: TObject);
    procedure ChkFilterTanggalClick(Sender: TObject);
    procedure BtnCetakClick(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
    procedure GridHistoryDblClick(Sender: TObject);
  private
    procedure TampilHistory;
  public
  end;

var
  Form5: TForm5;

implementation

uses UnitDB;

{$R *.dfm}

procedure TForm5.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Riwayat Transaksi & Audit Log - DLH Banjarmasin';
  Self.WindowState := wsMaximized;

  // Set default Tanggal Filter: 1 bulan lalu s/d hari ini
  DTPDari.Date := IncMonth(Date, -1);
  DTPSampai.Date := Date;

  // Header Tabel History
  GridHistory.ColCount := 7;
  GridHistory.Cells[0, 0] := 'No';
  GridHistory.Cells[1, 0] := 'Tanggal';
  GridHistory.Cells[2, 0] := 'Jenis Transaksi';
  GridHistory.Cells[3, 0] := 'Kode Rek / No PGJ';
  GridHistory.Cells[4, 0] := 'Nama Barang / Bidang';
  GridHistory.Cells[5, 0] := 'Jumlah';
  GridHistory.Cells[6, 0] := 'Status / Keterangan';

  CboJenisHistory.ItemIndex := 0;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  TampilHistory;
end;

procedure TForm5.FormResize(Sender: TObject);
var
  SisaLebar: Integer;
begin
  SisaLebar := GridHistory.ClientWidth - 50 - 100 - 180 - 160 - 110 - 230 - 30;
  if SisaLebar > 150 then
  begin
    GridHistory.ColWidths[0] := 50;  // No
    GridHistory.ColWidths[1] := 100; // Tanggal
    GridHistory.ColWidths[2] := 180; // Jenis Transaksi
    GridHistory.ColWidths[3] := 160; // Kode Rek / No PGJ
    GridHistory.ColWidths[4] := SisaLebar; // Nama Barang / Bidang
    GridHistory.ColWidths[5] := 110; // Jumlah
    GridHistory.ColWidths[6] := 230; // Status / Keterangan
  end;
end;

procedure TForm5.TampilHistory;
var
  Q: TFDQuery;
  Baris, TotalInbound, TotalOutbound: Integer;
  FilterKind, SearchKey, TglAwal, TglAkhir, SqlMasuk, SqlPengajuan: string;
  UseDateFilter: Boolean;
begin
  FilterKind := CboJenisHistory.Text;
  SearchKey := LowerCase(Trim(EdCariHistory.Text));
  UseDateFilter := ChkFilterTanggal.Checked;

  TglAwal := FormatDateTime('yyyy-mm-dd', DTPDari.Date);
  TglAkhir := FormatDateTime('yyyy-mm-dd', DTPSampai.Date);

  GridHistory.RowCount := 2;
  GridHistory.Rows[1].Clear;
  Baris := 1;
  TotalInbound := 0;
  TotalOutbound := 0;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;

    // 1. Tampilkan Barang Masuk (Inbound)
    if (FilterKind = 'Semua Riwayat') or (FilterKind = 'Barang Masuk (Inbound)') then
    begin
      SqlMasuk := 'SELECT M.Tanggal, M.Kode_Rekening, B.Nama_Barang, M.Jumlah, B.Satuan ' +
                  'FROM Tabel_Masuk M LEFT JOIN Tabel_Barang B ON M.Kode_Rekening = B.Kode_Rekening ';

      if UseDateFilter then
        SqlMasuk := SqlMasuk + 'WHERE M.Tanggal >= :tglAwal AND M.Tanggal <= :tglAkhir ';

      SqlMasuk := SqlMasuk + 'ORDER BY M.Tanggal DESC, M.ID_Masuk DESC';

      Q.SQL.Text := SqlMasuk;
      if UseDateFilter then
      begin
        Q.ParamByName('tglAwal').AsString := TglAwal;
        Q.ParamByName('tglAkhir').AsString := TglAkhir;
      end;

      Q.Open;

      while not Q.Eof do
      begin
        if (SearchKey = '') or
           (Pos(SearchKey, LowerCase(Q.FieldByName('Kode_Rekening').AsString)) > 0) or
           (Pos(SearchKey, LowerCase(Q.FieldByName('Nama_Barang').AsString)) > 0) then
        begin
          if Baris >= GridHistory.RowCount then
            GridHistory.RowCount := Baris + 1;

          GridHistory.Cells[0, Baris] := IntToStr(Baris);
          GridHistory.Cells[1, Baris] := Q.FieldByName('Tanggal').AsString;
          GridHistory.Cells[2, Baris] := 'BARANG MASUK';
          GridHistory.Cells[3, Baris] := Q.FieldByName('Kode_Rekening').AsString;
          GridHistory.Cells[4, Baris] := Q.FieldByName('Nama_Barang').AsString;
          GridHistory.Cells[5, Baris] := Q.FieldByName('Jumlah').AsString + ' ' + Q.FieldByName('Satuan').AsString;
          GridHistory.Cells[6, Baris] := 'Telah Ditambah ke Gudang';

          Inc(Baris);
          Inc(TotalInbound);
        end;
        Q.Next;
      end;
      Q.Close;
    end;

    // 2. Tampilkan Pengajuan & Barang Keluar (Outbound)
    if (FilterKind = 'Semua Riwayat') or (FilterKind = 'Pengajuan & Barang Keluar (Outbound)') then
    begin
      SqlPengajuan := 'SELECT P.No_Pengajuan, P.Tanggal, P.Bidang, P.Status, D.Kode_Rekening, D.Nama_Barang, D.Jumlah, D.Satuan ' +
                      'FROM Tabel_Pengajuan P INNER JOIN Tabel_Pengajuan_Detail D ON P.No_Pengajuan = D.No_Pengajuan ';

      if UseDateFilter then
        SqlPengajuan := SqlPengajuan + 'WHERE P.Tanggal >= :tglAwal AND P.Tanggal <= :tglAkhir ';

      SqlPengajuan := SqlPengajuan + 'ORDER BY P.Tanggal DESC, P.No_Pengajuan DESC';

      Q.SQL.Text := SqlPengajuan;
      if UseDateFilter then
      begin
        Q.ParamByName('tglAwal').AsString := TglAwal;
        Q.ParamByName('tglAkhir').AsString := TglAkhir;
      end;

      Q.Open;

      while not Q.Eof do
      begin
        if (SearchKey = '') or
           (Pos(SearchKey, LowerCase(Q.FieldByName('No_Pengajuan').AsString)) > 0) or
           (Pos(SearchKey, LowerCase(Q.FieldByName('Bidang').AsString)) > 0) or
           (Pos(SearchKey, LowerCase(Q.FieldByName('Nama_Barang').AsString)) > 0) then
        begin
          if Baris >= GridHistory.RowCount then
            GridHistory.RowCount := Baris + 1;

          GridHistory.Cells[0, Baris] := IntToStr(Baris);
          GridHistory.Cells[1, Baris] := Q.FieldByName('Tanggal').AsString;
          GridHistory.Cells[2, Baris] := 'PENGAJUAN (' + Q.FieldByName('Bidang').AsString + ')';
          GridHistory.Cells[3, Baris] := Q.FieldByName('No_Pengajuan').AsString;
          GridHistory.Cells[4, Baris] := Q.FieldByName('Nama_Barang').AsString;
          GridHistory.Cells[5, Baris] := Q.FieldByName('Jumlah').AsString + ' ' + Q.FieldByName('Satuan').AsString;
          GridHistory.Cells[6, Baris] := Q.FieldByName('Status').AsString;

          Inc(Baris);
          Inc(TotalOutbound);
        end;
        Q.Next;
      end;
      Q.Close;
    end;

    LblTotalRecord.Caption := 'Total Riwayat Ditemukan: ' + IntToStr(Baris - 1) + ' Transaksi ' +
                              '(Masuk: ' + IntToStr(TotalInbound) + ' | Pengajuan: ' + IntToStr(TotalOutbound) + ')';

  finally
    Q.Free;
  end;
end;

procedure TForm5.GridHistoryDblClick(Sender: TObject);
var
  RowIdx: Integer;
  NoPGJ, BuktiFile, Msg: string;
  Q: TFDQuery;
begin
  RowIdx := GridHistory.Row;
  if (RowIdx > 0) and (GridHistory.Cells[3, RowIdx] <> '') then
  begin
    Msg := 'RINCIAN DETAIL TRANSAKSI:' + sLineBreak + sLineBreak +
           'Tanggal: ' + GridHistory.Cells[1, RowIdx] + sLineBreak +
           'Kategori Transaksi: ' + GridHistory.Cells[2, RowIdx] + sLineBreak +
           'Kode / No Pengajuan: ' + GridHistory.Cells[3, RowIdx] + sLineBreak +
           'Nama Barang / Subjek: ' + GridHistory.Cells[4, RowIdx] + sLineBreak +
           'Jumlah Transaksi: ' + GridHistory.Cells[5, RowIdx] + sLineBreak +
           'Status Database: ' + GridHistory.Cells[6, RowIdx];

    NoPGJ := GridHistory.Cells[3, RowIdx];
    BuktiFile := '';

    if Pos('PENGAJUAN', GridHistory.Cells[2, RowIdx]) > 0 then
    begin
      Q := TFDQuery.Create(nil);
      try
        Q.Connection := ModulDB.Koneksi;
        Q.SQL.Text := 'SELECT Bukti_Foto FROM Tabel_Pengajuan WHERE No_Pengajuan = :no';
        Q.ParamByName('no').AsString := NoPGJ;
        Q.Open;
        if not Q.Eof then
          BuktiFile := Q.FieldByName('Bukti_Foto').AsString;
      finally
        Q.Free;
      end;
    end;

    if (BuktiFile <> '') and FileExists(BuktiFile) then
    begin
      Msg := Msg + sLineBreak + sLineBreak +
             'Berkas Bukti Fisik: ' + ExtractFileName(BuktiFile) + sLineBreak +
             'Apakah Anda ingin membuka berkas dokumen bukti ini sekarang?';
      if MessageDlg(Msg, mtInformation, [mbYes, mbNo], 0) = mrYes then
        ShellExecute(0, 'open', PChar(BuktiFile), nil, nil, SW_SHOWNORMAL);
    end
    else
      ShowMessage(Msg);
  end;
end;

procedure TForm5.CboJenisHistoryChange(Sender: TObject);
begin
  TampilHistory;
end;

procedure TForm5.EdCariHistoryChange(Sender: TObject);
begin
  TampilHistory;
end;

procedure TForm5.DTPDariChange(Sender: TObject);
begin
  if ChkFilterTanggal.Checked then
    TampilHistory;
end;

procedure TForm5.DTPSampaiChange(Sender: TObject);
begin
  if ChkFilterTanggal.Checked then
    TampilHistory;
end;

procedure TForm5.ChkFilterTanggalClick(Sender: TObject);
begin
  TampilHistory;
end;

procedure TForm5.BtnCetakClick(Sender: TObject);
var
  DataExcel: TStringList;
  Kolom, Baris: Integer;
  BarisTeks, NilaiCell: string;
begin
  SaveDialog1.Title := 'Export Riwayat Transaksi Inventaris';
  SaveDialog1.Filter := 'File Excel (CSV)|*.csv';
  SaveDialog1.DefaultExt := 'csv';
  SaveDialog1.FileName := 'Riwayat_Transaksi_DLH.csv';

  if SaveDialog1.Execute then
  begin
    DataExcel := TStringList.Create;
    try
      for Baris := 0 to GridHistory.RowCount - 1 do
      begin
        if (Baris > 0) and (GridHistory.Cells[1, Baris] = '') then Continue;

        BarisTeks := '';
        for Kolom := 0 to GridHistory.ColCount - 1 do
        begin
          NilaiCell := GridHistory.Cells[Kolom, Baris];
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
      ShowMessage('Sukses! Riwayat transaksi berhasil diekspor ke Excel.' + sLineBreak +
                  'Tersimpan di: ' + SaveDialog1.FileName);
    finally
      DataExcel.Free;
    end;
  end;
end;

procedure TForm5.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
end;

end.
