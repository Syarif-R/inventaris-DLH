unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm3 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    BtnKembali: TButton;
    PnlKiri: TPanel;
    LblBidang: TLabel;
    CboBidang: TComboBox;
    LblCariBarang: TLabel;
    EdCariBarang: TEdit;
    LblBarang: TLabel;
    CboBarang: TComboBox;
    LblHasilCari: TLabel;
    LblJumlah: TLabel;
    EdtJumlah: TEdit;
    LblSatuan: TLabel;
    EdtSatuan: TEdit;
    BtnTambah: TButton;
    BtnHapusItem: TButton;
    PnlKanan: TPanel;
    LblDaftar: TLabel;
    GridKeranjang: TStringGrid;
    BtnSimpanCetak: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CboBidangChange(Sender: TObject);
    procedure EdCariBarangChange(Sender: TObject);
    procedure CboBarangChange(Sender: TObject);
    procedure EdtJumlahKeyPress(Sender: TObject; var Key: Char);
    procedure BtnTambahClick(Sender: TObject);
    procedure BtnHapusItemClick(Sender: TObject);
    procedure GridKeranjangDblClick(Sender: TObject);
    procedure BtnSimpanCetakClick(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
  private
    BarisKeranjang: Integer;
    procedure LoadBidangCombo;
    procedure LoadBarangCombo;
  public
  end;

var
  Form3: TForm3;

implementation

uses UnitDB;

{$R *.dfm}

procedure TForm3.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Pengajuan & Distribusi Barang (Outbound) - DLH Banjarmasin';
  Self.WindowState := wsMaximized;

  GridKeranjang.ColCount := 4;
  GridKeranjang.Cells[0, 0] := 'No';
  GridKeranjang.Cells[1, 0] := 'Nama Barang';
  GridKeranjang.Cells[2, 0] := 'Jumlah';
  GridKeranjang.Cells[3, 0] := 'Satuan';

  BarisKeranjang := 1;
end;

procedure TForm3.LoadBidangCombo;
var
  Q: TFDQuery;
  CurrBidang: string;
  DefaultBidang: array[0..6] of string;
  I: Integer;
begin
  CurrBidang := CboBidang.Text;

  DefaultBidang[0] := 'Bidang Tata Lingkungan';
  DefaultBidang[1] := 'Bidang Pengawasan';
  DefaultBidang[2] := 'Bidang Kebersihan';
  DefaultBidang[3] := 'Bidang Pertamanan';
  DefaultBidang[4] := 'Laboratorium DLH';
  DefaultBidang[5] := 'UPTD TPA';
  DefaultBidang[6] := 'Sekretariat';

  CboBidang.Items.BeginUpdate;
  try
    CboBidang.Items.Clear;

    for I := Low(DefaultBidang) to High(DefaultBidang) do
    begin
      if CboBidang.Items.IndexOf(DefaultBidang[I]) < 0 then
        CboBidang.Items.Add(DefaultBidang[I]);
    end;

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := ModulDB.Koneksi;
      Q.SQL.Text := 'SELECT DISTINCT Bidang FROM Tabel_Pengajuan WHERE Bidang IS NOT NULL AND Bidang <> '''' ORDER BY Bidang ASC';
      Q.Open;
      while not Q.Eof do
      begin
        if CboBidang.Items.IndexOf(Q.Fields[0].AsString) < 0 then
          CboBidang.Items.Add(Q.Fields[0].AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;

    CboBidang.Items.Add('[ + Tambah Bidang Pemohon Baru... ]');
  finally
    CboBidang.Items.EndUpdate;
  end;

  if (CurrBidang <> '') and (CboBidang.Items.IndexOf(CurrBidang) >= 0) then
    CboBidang.ItemIndex := CboBidang.Items.IndexOf(CurrBidang)
  else
    CboBidang.ItemIndex := -1; // Dikoisongkan dlu sebagai default!
end;

procedure TForm3.CboBidangChange(Sender: TObject);
var
  BidangBaru: string;
  Idx: Integer;
begin
  if CboBidang.ItemIndex = CboBidang.Items.Count - 1 then
  begin
    BidangBaru := Trim(InputBox('Tambah Bidang Baru', 'Masukkan Nama Bidang Pemohon Baru:', ''));
    if BidangBaru <> '' then
    begin
      Idx := CboBidang.Items.IndexOf(BidangBaru);
      if Idx < 0 then
      begin
        CboBidang.Items.Insert(CboBidang.Items.Count - 1, BidangBaru);
        Idx := CboBidang.Items.IndexOf(BidangBaru);
      end;
      CboBidang.ItemIndex := Idx;
    end
    else
    begin
      CboBidang.ItemIndex := -1;
    end;
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  LoadBidangCombo;
  CboBidang.ItemIndex := -1; // Dikoisongkan terlebih dahulu saat form dibuka!
  LoadBarangCombo;
  CboBarang.ItemIndex := -1; // Dikoisongkan terlebih dahulu saat form dibuka!
  EdtJumlah.Clear;
  EdtSatuan.Text := '-';
end;

procedure TForm3.FormResize(Sender: TObject);
var
  SisaLebar: Integer;
begin
  SisaLebar := GridKeranjang.ClientWidth - 50 - 100 - 100 - 20;
  if SisaLebar > 150 then
  begin
    GridKeranjang.ColWidths[0] := 50;
    GridKeranjang.ColWidths[1] := SisaLebar;
    GridKeranjang.ColWidths[2] := 100;
    GridKeranjang.ColWidths[3] := 100;
  end;
end;

procedure TForm3.LoadBarangCombo;
var
  Q: TFDQuery;
  SearchKey: string;
begin
  CboBarang.Items.Clear;
  SearchKey := LowerCase(Trim(EdCariBarang.Text));

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT Kode_Rekening, Nama_Barang, Satuan FROM Tabel_Barang ORDER BY Nama_Barang ASC';
    Q.Open;

    while not Q.Eof do
    begin
      if (SearchKey = '') or
         (Pos(SearchKey, LowerCase(Q.FieldByName('Kode_Rekening').AsString)) > 0) or
         (Pos(SearchKey, LowerCase(Q.FieldByName('Nama_Barang').AsString)) > 0) then
      begin
        CboBarang.Items.Add(Q.FieldByName('Kode_Rekening').AsString + ' - ' + Q.FieldByName('Nama_Barang').AsString);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  if SearchKey <> '' then
  begin
    if CboBarang.Items.Count > 0 then
    begin
      CboBarang.ItemIndex := 0;
      CboBarangChange(Self);
    end
    else
    begin
      CboBarang.ItemIndex := -1;
      EdtSatuan.Text := '-';
      LblHasilCari.Caption := '[Peringatan] Barang "' + EdCariBarang.Text + '" tidak ditemukan!';
    end;
  end
  else
  begin
    CboBarang.ItemIndex := -1; // Dikoisongkan terlebih dahulu jika pencarian kosong!
    EdtSatuan.Text := '-';
    LblHasilCari.Caption := '[Info] Ketik nama/kode barang di atas untuk mencari.';
  end;
end;

procedure TForm3.EdCariBarangChange(Sender: TObject);
begin
  LoadBarangCombo;
end;

procedure TForm3.CboBarangChange(Sender: TObject);
var
  KodeRek, NamaBrg: string;
  Q: TFDQuery;
  PosDash, StokSisa: Integer;
begin
  if CboBarang.ItemIndex = -1 then
  begin
    EdtSatuan.Text := '-';
    LblHasilCari.Caption := '[Info] Ketik nama/kode barang di atas untuk mencari.';
    Exit;
  end;

  PosDash := Pos(' - ', CboBarang.Text);
  if PosDash > 0 then
  begin
    KodeRek := Trim(Copy(CboBarang.Text, 1, PosDash - 1));
    NamaBrg := Trim(Copy(CboBarang.Text, PosDash + 3, Length(CboBarang.Text)));
  end
  else
  begin
    KodeRek := Trim(CboBarang.Text);
    NamaBrg := CboBarang.Text;
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT Satuan, Stok_Sisa FROM Tabel_Barang WHERE Kode_Rekening = :kode';
    Q.ParamByName('kode').AsString := KodeRek;
    Q.Open;

    if not Q.Eof then
    begin
      EdtSatuan.Text := Q.FieldByName('Satuan').AsString;
      StokSisa := Q.FieldByName('Stok_Sisa').AsInteger;
      LblHasilCari.Caption := '[Cari] Ditemukan: ' + IntToStr(CboBarang.Items.Count) + ' item ("' + NamaBrg + '") | Stok Gudang: ' + IntToStr(StokSisa) + ' ' + EdtSatuan.Text;
    end
    else
    begin
      EdtSatuan.Text := '-';
      LblHasilCari.Caption := '[Info] Barang terpilih: ' + CboBarang.Text;
    end;
  finally
    Q.Free;
  end;
end;

procedure TForm3.EdtJumlahKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', '.', #8]) then
    Key := #0;
end;

procedure TForm3.BtnTambahClick(Sender: TObject);
var
  Jml, StokAda, PosDash, PosDashGrid, SudahDiKeranjang, StokTersisaRiil, I: Integer;
  KodeRek, KodeGrid: string;
  Q: TFDQuery;
begin
  Jml := StrToIntDef(EdtJumlah.Text, 0);

  if (CboBarang.Text = '') or (Jml <= 0) then
  begin
    ShowMessage('VALIDASI GAGAL: Pilih barang dan isi jumlah pengajuan (angka positif > 0) terlebih dahulu!');
    Exit;
  end;

  PosDash := Pos(' - ', CboBarang.Text);
  if PosDash > 0 then
    KodeRek := Trim(Copy(CboBarang.Text, 1, PosDash - 1))
  else
    KodeRek := Trim(CboBarang.Text);

  // Hitung jumlah yang sudah dimasukkan ke keranjang untuk barang ini
  SudahDiKeranjang := 0;
  for I := 1 to BarisKeranjang - 1 do
  begin
    PosDashGrid := Pos(' - ', GridKeranjang.Cells[1, I]);
    if PosDashGrid > 0 then
      KodeGrid := Trim(Copy(GridKeranjang.Cells[1, I], 1, PosDashGrid - 1))
    else
      KodeGrid := Trim(GridKeranjang.Cells[1, I]);

    if KodeGrid = KodeRek then
      SudahDiKeranjang := SudahDiKeranjang + StrToIntDef(GridKeranjang.Cells[2, I], 0);
  end;

  // Cek stok fisik yang tersedia di database
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT Stok_Sisa FROM Tabel_Barang WHERE Kode_Rekening = :kode';
    Q.ParamByName('kode').AsString := KodeRek;
    Q.Open;

    if not Q.Eof then
    begin
      StokAda := Q.FieldByName('Stok_Sisa').AsInteger;
      StokTersisaRiil := StokAda - SudahDiKeranjang;

      if StokTersisaRiil <= 0 then
      begin
        ShowMessage('STOK KOSONG: Stok barang "' + CboBarang.Text + '" yang tersisa saat ini adalah 0 unit (sudah dimasukkan ke keranjang / stok gudang kosong). Tidak dapat mengajukan barang ini!');
        Exit;
      end;

      if Jml > StokTersisaRiil then
      begin
        Jml := StokTersisaRiil;
        EdtJumlah.Text := IntToStr(StokTersisaRiil);
        ShowMessage('PENYESUAIAN MAKSIMAL STOK: Jumlah pengajuan barang telah otomatis disesuaikan ke sisa stok maksimal yang tersedia (' + IntToStr(StokTersisaRiil) + ' ' + EdtSatuan.Text + ') agar stok gudang tidak minus.');
      end;
    end;
  finally
    Q.Free;
  end;

  GridKeranjang.RowCount := BarisKeranjang + 1;
  GridKeranjang.Cells[0, BarisKeranjang] := IntToStr(BarisKeranjang);
  GridKeranjang.Cells[1, BarisKeranjang] := CboBarang.Text;
  GridKeranjang.Cells[2, BarisKeranjang] := IntToStr(Jml);
  GridKeranjang.Cells[3, BarisKeranjang] := EdtSatuan.Text;

  Inc(BarisKeranjang);

  CboBarang.ItemIndex := -1;
  EdtJumlah.Clear;
  EdtSatuan.Text := '-';
  LblHasilCari.Caption := '[Info] Ketik nama/kode barang di atas untuk mencari.';
end;

procedure TForm3.BtnHapusItemClick(Sender: TObject);
var
  SelRow, I: Integer;
begin
  SelRow := GridKeranjang.Row;
  if (SelRow < 1) or (SelRow >= BarisKeranjang) or (GridKeranjang.Cells[1, SelRow] = '') then
  begin
    ShowMessage('Pilih baris barang di tabel keranjang yang ingin dihapus terlebih dahulu!');
    Exit;
  end;

  for I := SelRow to BarisKeranjang - 2 do
  begin
    GridKeranjang.Cells[0, I] := IntToStr(I);
    GridKeranjang.Cells[1, I] := GridKeranjang.Cells[1, I + 1];
    GridKeranjang.Cells[2, I] := GridKeranjang.Cells[2, I + 1];
    GridKeranjang.Cells[3, I] := GridKeranjang.Cells[3, I + 1];
  end;

  GridKeranjang.Rows[BarisKeranjang - 1].Clear;
  Dec(BarisKeranjang);
  if BarisKeranjang < 1 then BarisKeranjang := 1;

  if BarisKeranjang = 1 then
    GridKeranjang.RowCount := 2
  else
    GridKeranjang.RowCount := BarisKeranjang;
end;

procedure TForm3.GridKeranjangDblClick(Sender: TObject);
begin
  BtnHapusItemClick(Self);
end;

procedure TForm3.BtnSimpanCetakClick(Sender: TObject);
var
  I, Jml, PosDash: Integer;
  KodeRek, NamaBrg, NoPengajuan, TglNow: string;
  Q: TFDQuery;
begin
  if CboBidang.Text = '' then
  begin
    ShowMessage('VALIDASI GAGAL: Pilih bidang pemohon terlebih dahulu!');
    Exit;
  end;

  if BarisKeranjang = 1 then
  begin
    ShowMessage('VALIDASI GAGAL: Keranjang permintaan barang masih kosong!');
    Exit;
  end;

  if MessageDlg('KONFIRMASI PENGAJUAN BARANG:' + sLineBreak + sLineBreak +
                'Bidang Pemohon: ' + CboBidang.Text + sLineBreak +
                'Jumlah Jenis Barang: ' + IntToStr(BarisKeranjang - 1) + ' item' + sLineBreak + sLineBreak +
                'Apakah Anda yakin data pengajuan ini sudah benar dan siap disimpan?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  TglNow := FormatDateTime('yyyy-mm-dd', Now);
  NoPengajuan := 'PGJ-' + FormatDateTime('yyyymmdd-hhnnss', Now);

  ModulDB.Koneksi.StartTransaction;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;

    // Header Pengajuan
    Q.SQL.Text := 'INSERT INTO Tabel_Pengajuan (No_Pengajuan, Tanggal, Bidang, Status) VALUES (:no, :tgl, :bidang, ''PENDING'')';
    Q.ParamByName('no').AsString := NoPengajuan;
    Q.ParamByName('tgl').AsString := TglNow;
    Q.ParamByName('bidang').AsString := CboBidang.Text;
    Q.ExecSQL;

    // Detail Pengajuan
    for I := 1 to BarisKeranjang - 1 do
    begin
      PosDash := Pos(' - ', GridKeranjang.Cells[1, I]);
      if PosDash > 0 then
      begin
        KodeRek := Trim(Copy(GridKeranjang.Cells[1, I], 1, PosDash - 1));
        NamaBrg := Trim(Copy(GridKeranjang.Cells[1, I], PosDash + 3, Length(GridKeranjang.Cells[1, I])));
      end
      else
      begin
        KodeRek := Trim(GridKeranjang.Cells[1, I]);
        NamaBrg := GridKeranjang.Cells[1, I];
      end;

      Jml := StrToIntDef(GridKeranjang.Cells[2, I], 0);

      Q.SQL.Text := 'INSERT INTO Tabel_Pengajuan_Detail (No_Pengajuan, Kode_Rekening, Nama_Barang, Jumlah, Satuan) ' +
                    'VALUES (:no, :kode, :nama, :jml, :satuan)';
      Q.ParamByName('no').AsString := NoPengajuan;
      Q.ParamByName('kode').AsString := KodeRek;
      Q.ParamByName('nama').AsString := NamaBrg;
      Q.ParamByName('jml').AsInteger := Jml;
      Q.ParamByName('satuan').AsString := GridKeranjang.Cells[3, I];
      Q.ExecSQL;
    end;

    ModulDB.Koneksi.Commit;

    ShowMessage('PENGAJUAN BERHASIL DISIMPAN!' + sLineBreak +
                'No. Pengajuan: ' + NoPengajuan + sLineBreak +
                'Status: PENDING (Menunggu Validasi Bukti TTD Fisik)' + sLineBreak + sLineBreak +
                'Silakan selesaikan pengambilan barang & upload bukti fisik pada Menu Validasi.');

    // Reset Form
    BarisKeranjang := 1;
    GridKeranjang.RowCount := 2;
    GridKeranjang.Rows[1].Clear;
    Self.Close;
  except
    on E: Exception do
    begin
      ModulDB.Koneksi.Rollback;
      ShowMessage('Gagal menyimpan pengajuan barang: ' + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TForm3.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
end;

end.
