unit Unit6;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm6 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    BtnKembali: TButton;
    PnlKiri: TPanel;
    LblKode: TLabel;
    EdtKode: TEdit;
    LblNama: TLabel;
    EdtNama: TEdit;
    LblKategori: TLabel;
    CboKategori: TComboBox;
    LblSatuan: TLabel;
    EdtSatuan: TEdit;
    LblStok: TLabel;
    EdtStok: TEdit;
    BtnTambah: TButton;
    BtnEdit: TButton;
    BtnHapus: TButton;
    BtnBatal: TButton;
    PnlKanan: TPanel;
    PnlCariMaster: TPanel;
    LblCariMaster: TLabel;
    EdCariMaster: TEdit;
    LblKatFilterMaster: TLabel;
    CmbKatFilterMaster: TComboBox;
    ChkHideZeroMaster: TCheckBox;
    GridMaster: TStringGrid;

    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EdCariMasterChange(Sender: TObject);
    procedure CmbKatFilterMasterChange(Sender: TObject);
    procedure ChkHideZeroMasterClick(Sender: TObject);
    procedure GridMasterClick(Sender: TObject);
    procedure CboKategoriChange(Sender: TObject);
    procedure EdtKodeKeyPress(Sender: TObject; var Key: Char);
    procedure BtnTambahClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnHapusClick(Sender: TObject);
    procedure BtnBatalClick(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
  private
    procedure LoadKategoriCombo;
    procedure LoadMasterData;
    procedure ResetInputForm;
  public
  end;

var
  Form6: TForm6;

implementation

uses UnitDB;

{$R *.dfm}

procedure TForm6.LoadKategoriCombo;
var
  Q: TFDQuery;
  CurrKatInput, CurrKatFilter: string;
begin
  CurrKatInput := CboKategori.Text;
  CurrKatFilter := CmbKatFilterMaster.Text;

  CboKategori.Items.BeginUpdate;
  CmbKatFilterMaster.Items.BeginUpdate;
  try
    CboKategori.Items.Clear;
    CmbKatFilterMaster.Items.Clear;

    CmbKatFilterMaster.Items.Add('Semua Kategori');

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := ModulDB.Koneksi;
      Q.SQL.Text := 'SELECT DISTINCT Kategori FROM Tabel_Barang WHERE Kategori IS NOT NULL AND Kategori <> '''' ORDER BY Kategori ASC';
      Q.Open;
      while not Q.Eof do
      begin
        CboKategori.Items.Add(Q.Fields[0].AsString);
        CmbKatFilterMaster.Items.Add(Q.Fields[0].AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;

    CboKategori.Items.Add('[ + Tambah Kategori Baru... ]');
  finally
    CboKategori.Items.EndUpdate;
    CmbKatFilterMaster.Items.EndUpdate;
  end;

  if (CurrKatInput <> '') and (CboKategori.Items.IndexOf(CurrKatInput) >= 0) then
    CboKategori.ItemIndex := CboKategori.Items.IndexOf(CurrKatInput)
  else if CboKategori.Items.Count > 0 then
    CboKategori.ItemIndex := 0;

  if (CurrKatFilter <> '') and (CmbKatFilterMaster.Items.IndexOf(CurrKatFilter) >= 0) then
    CmbKatFilterMaster.ItemIndex := CmbKatFilterMaster.Items.IndexOf(CurrKatFilter)
  else if CmbKatFilterMaster.Items.Count > 0 then
    CmbKatFilterMaster.ItemIndex := 0;
end;

procedure TForm6.CboKategoriChange(Sender: TObject);
var
  KatBaru: string;
  Idx: Integer;
begin
  if CboKategori.ItemIndex = CboKategori.Items.Count - 1 then
  begin
    KatBaru := Trim(InputBox('Tambah Kategori Baru', 'Masukkan Nama Kategori Baru:', ''));
    if KatBaru <> '' then
    begin
      Idx := CboKategori.Items.IndexOf(KatBaru);
      if Idx < 0 then
      begin
        CboKategori.Items.Insert(CboKategori.Items.Count - 1, KatBaru);
        Idx := CboKategori.Items.IndexOf(KatBaru);
      end;
      CboKategori.ItemIndex := Idx;
    end
    else
    begin
      if CboKategori.Items.Count > 0 then
        CboKategori.ItemIndex := 0;
    end;
  end;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Kelola Master Data Barang - DLH Banjarmasin';
  Self.WindowState := wsMaximized;

  GridMaster.ColCount := 6;
  GridMaster.Cells[0, 0] := 'No';
  GridMaster.Cells[1, 0] := 'Kode Rekening';
  GridMaster.Cells[2, 0] := 'Nama Persediaan';
  GridMaster.Cells[3, 0] := 'Kategori';
  GridMaster.Cells[4, 0] := 'Satuan';
  GridMaster.Cells[5, 0] := 'Stok Sisa';

  LoadKategoriCombo;
end;

procedure TForm6.FormShow(Sender: TObject);
begin
  LoadKategoriCombo;
  LoadMasterData;
  ResetInputForm;
end;

procedure TForm6.FormResize(Sender: TObject);
var
  SisaLebar: Integer;
begin
  SisaLebar := GridMaster.ClientWidth - 40 - 150 - 120 - 80 - 80 - 30;
  if SisaLebar > 150 then
  begin
    GridMaster.ColWidths[0] := 40;
    GridMaster.ColWidths[1] := 150;
    GridMaster.ColWidths[2] := SisaLebar;
    GridMaster.ColWidths[3] := 120;
    GridMaster.ColWidths[4] := 80;
    GridMaster.ColWidths[5] := 80;
  end;
end;

procedure TForm6.LoadMasterData;
var
  Q: TFDQuery;
  Baris: Integer;
  SearchKey, SelectedKat, Kat: string;
  StokSisa: Integer;
  MatchSearch, MatchKat, MatchStok: Boolean;
begin
  GridMaster.RowCount := 2;
  GridMaster.Rows[1].Clear;
  Baris := 1;

  SearchKey := LowerCase(Trim(EdCariMaster.Text));
  SelectedKat := Trim(CmbKatFilterMaster.Text);

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

      MatchStok := not (ChkHideZeroMaster.Checked and (StokSisa <= 0));

      if MatchSearch and MatchKat and MatchStok then
      begin
        if Baris >= GridMaster.RowCount then
          GridMaster.RowCount := Baris + 1;

        GridMaster.Cells[0, Baris] := IntToStr(Baris);
        GridMaster.Cells[1, Baris] := Q.FieldByName('Kode_Rekening').AsString;
        GridMaster.Cells[2, Baris] := Q.FieldByName('Nama_Barang').AsString;
        GridMaster.Cells[3, Baris] := Kat;
        GridMaster.Cells[4, Baris] := Q.FieldByName('Satuan').AsString;
        GridMaster.Cells[5, Baris] := IntToStr(StokSisa);

        Inc(Baris);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;
end;

procedure TForm6.ResetInputForm;
begin
  EdtKode.Clear;
  EdtKode.Enabled := True;
  EdtNama.Clear;
  CboKategori.ItemIndex := 0;
  EdtSatuan.Clear;
  EdtStok.Text := '0';
end;

procedure TForm6.GridMasterClick(Sender: TObject);
var
  RowIdx: Integer;
begin
  RowIdx := GridMaster.Row;
  if (RowIdx > 0) and (GridMaster.Cells[1, RowIdx] <> '') then
  begin
    EdtKode.Text := GridMaster.Cells[1, RowIdx];
    EdtKode.Enabled := False; // Kunci Primary Key saat mode Edit
    EdtNama.Text := GridMaster.Cells[2, RowIdx];
    CboKategori.Text := GridMaster.Cells[3, RowIdx];
    EdtSatuan.Text := GridMaster.Cells[4, RowIdx];
    EdtStok.Text := GridMaster.Cells[5, RowIdx];
  end;
end;

procedure TForm6.EdCariMasterChange(Sender: TObject);
begin
  LoadMasterData;
end;

procedure TForm6.CmbKatFilterMasterChange(Sender: TObject);
begin
  LoadMasterData;
end;

procedure TForm6.ChkHideZeroMasterClick(Sender: TObject);
begin
  LoadMasterData;
end;

{ --- FITUR TAMBAH BARANG BARU DENGAN VALIDASI KETAT --- }
procedure TForm6.EdtKodeKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', '.', #8]) then
    Key := #0;
end;

procedure TForm6.BtnTambahClick(Sender: TObject);
var
  Q: TFDQuery;
  Kode, Nama, Kat, Satuan: string;
  Stok: Integer;
begin
  Kode := Trim(EdtKode.Text);
  Nama := Trim(EdtNama.Text);
  Kat := CboKategori.Text;
  Satuan := Trim(EdtSatuan.Text);
  Stok := StrToIntDef(EdtStok.Text, -1);

  // 1. Validasi Input Kosong
  if (Kode = '') or (Nama = '') or (Kat = '') or (Satuan = '') or (Stok < 0) then
  begin
    ShowMessage('VALIDASI GAGAL: Semua kolom (Kode, Nama, Kategori, Satuan, Stok Sisa) wajib diisi dengan benar!');
    Exit;
  end;

  // 2. Konfirmasi Penyimpanan
  if MessageDlg('Apakah Anda yakin ingin menambahkan barang baru ini?' + sLineBreak + sLineBreak +
                'Kode: ' + Kode + sLineBreak +
                'Nama: ' + Nama + sLineBreak +
                'Kategori: ' + Kat + sLineBreak +
                'Satuan: ' + Satuan + sLineBreak +
                'Stok Awal: ' + IntToStr(Stok),
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;

    // 3. Cek Duplikasi Kode Rekening
    Q.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Barang WHERE Kode_Rekening = :kode';
    Q.ParamByName('kode').AsString := Kode;
    Q.Open;

    if Q.Fields[0].AsInteger > 0 then
    begin
      ShowMessage('VALIDASI GAGAL: Kode Rekening "' + Kode + '" sudah ada di database!');
      Exit;
    end;
    Q.Close;

    // 4. Insert Barang Baru
    Q.SQL.Text := 'INSERT INTO Tabel_Barang (Kode_Rekening, Nama_Barang, Kategori, Satuan, Stok_Sisa) ' +
                  'VALUES (:kode, :nama, :kat, :satuan, :stok)';
    Q.ParamByName('kode').AsString := Kode;
    Q.ParamByName('nama').AsString := Nama;
    Q.ParamByName('kat').AsString := Kat;
    Q.ParamByName('satuan').AsString := Satuan;
    Q.ParamByName('stok').AsInteger := Stok;
    Q.ExecSQL;

    ShowMessage('BERHASIL! Barang baru "' + Nama + '" telah ditambahkan ke Master Data.');
    ResetInputForm;
    LoadKategoriCombo;
    LoadMasterData;
  finally
    Q.Free;
  end;
end;

{ --- FITUR EDIT BARANG DENGAN VALIDASI KETAT --- }
procedure TForm6.BtnEditClick(Sender: TObject);
var
  Q: TFDQuery;
  Kode, Nama, Kat, Satuan: string;
  Stok: Integer;
begin
  Kode := Trim(EdtKode.Text);
  Nama := Trim(EdtNama.Text);
  Kat := CboKategori.Text;
  Satuan := Trim(EdtSatuan.Text);
  Stok := StrToIntDef(EdtStok.Text, -1);

  if (Kode = '') or (Nama = '') or (Kat = '') or (Satuan = '') or (Stok < 0) then
  begin
    ShowMessage('VALIDASI GAGAL: Pilih barang dari tabel yang ingin di-edit terlebih dahulu!');
    Exit;
  end;

  if MessageDlg('Simpan perubahan data barang "' + Nama + '" (' + Kode + ')?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'UPDATE Tabel_Barang SET Nama_Barang = :nama, Kategori = :kat, Satuan = :satuan, Stok_Sisa = :stok ' +
                  'WHERE Kode_Rekening = :kode';
    Q.ParamByName('nama').AsString := Nama;
    Q.ParamByName('kat').AsString := Kat;
    Q.ParamByName('satuan').AsString := Satuan;
    Q.ParamByName('stok').AsInteger := Stok;
    Q.ParamByName('kode').AsString := Kode;
    Q.ExecSQL;

    ShowMessage('BERHASIL! Perubahan data barang "' + Nama + '" telah disimpan.');
    ResetInputForm;
    LoadKategoriCombo;
    LoadMasterData;
  finally
    Q.Free;
  end;
end;

{ --- FITUR HAPUS BARANG DENGAN VALIDASI KEAMANAN TRANSAKSI --- }
procedure TForm6.BtnHapusClick(Sender: TObject);
var
  Q: TFDQuery;
  Kode, Nama: string;
  TotalMasuk, TotalKeluar, TotalPGJ: Integer;
begin
  Kode := Trim(EdtKode.Text);
  Nama := Trim(EdtNama.Text);

  if Kode = '' then
  begin
    ShowMessage('VALIDASI GAGAL: Pilih barang dari tabel yang ingin dihapus terlebih dahulu!');
    Exit;
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;

    // 1. Cek apakah barang memiliki riwayat transaksi di Tabel_Masuk, Tabel_Keluar, atau Tabel_Pengajuan_Detail
    Q.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Masuk WHERE Kode_Rekening = :kode';
    Q.ParamByName('kode').AsString := Kode;
    Q.Open;
    TotalMasuk := Q.Fields[0].AsInteger;
    Q.Close;

    Q.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Keluar WHERE Kode_Rekening = :kode';
    Q.ParamByName('kode').AsString := Kode;
    Q.Open;
    TotalKeluar := Q.Fields[0].AsInteger;
    Q.Close;

    Q.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Pengajuan_Detail WHERE Kode_Rekening = :kode';
    Q.ParamByName('kode').AsString := Kode;
    Q.Open;
    TotalPGJ := Q.Fields[0].AsInteger;
    Q.Close;

    if (TotalMasuk > 0) or (TotalKeluar > 0) or (TotalPGJ > 0) then
    begin
      ShowMessage('DILARANG MENGHAPUS: Barang "' + Nama + '" (' + Kode + ') sudah memiliki riwayat transaksi!' + sLineBreak +
                  'Detail Transaksi: Masuk (' + IntToStr(TotalMasuk) + '), Keluar (' + IntToStr(TotalKeluar) + '), Pengajuan (' + IntToStr(TotalPGJ) + ').');
      Exit;
    end;

    // 2. Konfirmasi Hapus
    if MessageDlg('PERINGATAN HAPUS: Apakah Anda benar-benar yakin ingin menghapus barang "' + Nama + '" (' + Kode + ') secara permanen?',
                  mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;

    Q.SQL.Text := 'DELETE FROM Tabel_Barang WHERE Kode_Rekening = :kode';
    Q.ParamByName('kode').AsString := Kode;
    Q.ExecSQL;

    ShowMessage('SUKSES: Barang "' + Nama + '" telah dihapus dari Master Data.');
    ResetInputForm;
    LoadMasterData;
  finally
    Q.Free;
  end;
end;

procedure TForm6.BtnBatalClick(Sender: TObject);
begin
  ResetInputForm;
end;

procedure TForm6.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
end;

end.
