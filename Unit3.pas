unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, System.UITypes, System.NetEncoding, Vcl.Graphics,
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
    LblStokInfo: TLabel;
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
    SaveDialog1: TSaveDialog;

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
    LblStokInfo.Font.Color := clGray;
    LblStokInfo.Caption := 'Sisa Stok Gudang: -';
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
      LblHasilCari.Caption := '[Cari] Ditemukan: ' + IntToStr(CboBarang.Items.Count) + ' item ("' + NamaBrg + '")';
      if StokSisa > 0 then
      begin
        LblStokInfo.Font.Color := clGreen;
        LblStokInfo.Caption := 'Sisa Stok Gudang: ' + IntToStr(StokSisa) + ' ' + EdtSatuan.Text;
      end
      else
      begin
        LblStokInfo.Font.Color := clRed;
        LblStokInfo.Caption := 'STOK GUDANG HABIS (0 ' + EdtSatuan.Text + ')';
      end;
    end
    else
    begin
      EdtSatuan.Text := '-';
      LblHasilCari.Caption := '[Info] Barang terpilih: ' + CboBarang.Text;
      LblStokInfo.Font.Color := clGray;
      LblStokInfo.Caption := 'Sisa Stok Gudang: -';
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
  LblStokInfo.Font.Color := clGray;
  LblStokInfo.Caption := 'Sisa Stok Gudang: -';
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

function GetLogoBase64: string;
var
  ExeDir, LogoPath: string;
  FS: TFileStream;
  SS: TStringStream;
begin
  Result := '';
  ExeDir := ExtractFilePath(ParamStr(0));

  if FileExists(ExeDir + 'logo_banjarmasin.jpg') then
    LogoPath := ExeDir + 'logo_banjarmasin.jpg'
  else if FileExists(ExpandFileName(ExeDir + '..\..\logo_banjarmasin.jpg')) then
    LogoPath := ExpandFileName(ExeDir + '..\..\logo_banjarmasin.jpg')
  else if FileExists(ExpandFileName('logo_banjarmasin.jpg')) then
    LogoPath := ExpandFileName('logo_banjarmasin.jpg')
  else
    Exit;

  try
    FS := TFileStream.Create(LogoPath, fmOpenRead or fmShareDenyNone);
    try
      SS := TStringStream.Create('');
      try
        TNetEncoding.Base64.Encode(FS, SS);
        Result := SS.DataString;
      finally
        SS.Free;
      end;
    finally
      FS.Free;
    end;
  except
    Result := '';
  end;
end;

procedure TForm3.BtnSimpanCetakClick(Sender: TObject);
var
  I, Jml, PosDash: Integer;
  KodeRek, NamaBrg, NoPengajuan, TglNow, TglFormat, LogoB64, ExtFile: string;
  Q: TFDQuery;
  SuratText: TStringList;
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

    // Pengarah Download dengan Dialog Pemilih Tempat Penyimpanan File Surat Izin Cetak
    SaveDialog1.Title := 'Pilih Lokasi Penyimpanan Surat Izin Pengajuan Barang (Dokumen Web / PDF)';
    SaveDialog1.Filter := 'Dokumen Cetak / Web (*.html)|*.html|Dokumen Web (*.htm)|*.htm|Semua File (*.*)|*.*';
    SaveDialog1.DefaultExt := 'html';
    SaveDialog1.FileName := 'Surat_Izin_Pengajuan_' + NoPengajuan + '.html';

    if SaveDialog1.Execute then
    begin
      ExtFile := LowerCase(ExtractFileExt(SaveDialog1.FileName));

      if (ExtFile <> '.html') and (ExtFile <> '.htm') then
      begin
        SaveDialog1.FileName := ChangeFileExt(SaveDialog1.FileName, '.html');
        ExtFile := '.html';
      end;

      if (ExtFile = '.html') or (ExtFile = '.htm') then
      begin
        LogoB64 := GetLogoBase64;
        TglFormat := FormatDateTime('dd mmmm yyyy', Now);
        SuratText := TStringList.Create;
        try
          SuratText.Add('<!DOCTYPE html>');
          SuratText.Add('<html>');
          SuratText.Add('<head>');
          SuratText.Add('<meta charset="utf-8">');
          SuratText.Add('<title>SURAT IZIN & TANDA TERIMA PENGAJUAN BARANG GUDANG</title>');
          SuratText.Add('<style>');
          SuratText.Add('  @page { size: A4 portrait; margin: 1.5cm; }');
          SuratText.Add('  body { font-family: Arial, sans-serif; color: #000; background: #fff; margin: 0; padding: 25px; }');
          SuratText.Add('  .kop-table { width: 100%; border-collapse: collapse; border-bottom: 3.5px solid #000; padding-bottom: 8px; margin-bottom: 12px; }');
          SuratText.Add('  .kop-logo { width: 2.31cm; height: 3.3cm; object-fit: contain; }');
          SuratText.Add('  .kop-text-container { text-align: center; vertical-align: middle; }');
          SuratText.Add('  .kop-h1 { font-family: Arial, sans-serif; font-size: 18pt; font-weight: bold; margin: 0; line-height: 1.2; text-transform: uppercase; }');
          SuratText.Add('  .kop-sub { font-family: Arial, sans-serif; font-size: 12pt; font-weight: normal; margin: 3px 0 0 0; line-height: 1.3; }');
          SuratText.Add('  .kop-city { font-family: Arial, sans-serif; font-size: 12pt; font-weight: bold; margin: 3px 0 0 0; }');
          SuratText.Add('  .date-right { text-align: right; font-family: Arial, sans-serif; font-size: 11pt; margin-top: 10px; margin-bottom: 20px; }');
          SuratText.Add('  .doc-title { text-align: center; font-family: Arial, sans-serif; font-size: 14pt; font-weight: bold; text-decoration: underline; margin-bottom: 25px; text-transform: uppercase; }');
          SuratText.Add('  .meta-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 11pt; }');
          SuratText.Add('  .meta-table td { padding: 5px 0; vertical-align: top; }');
          SuratText.Add('  .meta-label { width: 150px; font-weight: bold; }');
          SuratText.Add('  .item-table { width: 100%; border-collapse: collapse; margin-bottom: 25px; font-size: 11pt; }');
          SuratText.Add('  .item-table th, .item-table td { border: 1px solid #000; padding: 8px 10px; text-align: left; }');
          SuratText.Add('  .item-table th { background-color: #f2f2f2; font-weight: bold; text-align: center; }');
          SuratText.Add('  .item-table td.center { text-align: center; }');
          SuratText.Add('  .notes { font-size: 10.5pt; margin-bottom: 35px; line-height: 1.5; }');
          SuratText.Add('  .notes ol { margin: 5px 0 0 20px; padding: 0; }');
          SuratText.Add('  .sig-table { width: 100%; border-collapse: collapse; margin-top: 30px; font-size: 11pt; }');
          SuratText.Add('  .sig-table td { width: 50%; text-align: center; vertical-align: top; }');
          SuratText.Add('  .sig-space { height: 85px; }');
          SuratText.Add('  .sig-name { font-weight: bold; text-decoration: underline; }');
          SuratText.Add('</style>');
          SuratText.Add('</head>');
          SuratText.Add('<body>');

          // Header Kop Surat Resmi
          SuratText.Add('<table class="kop-table">');
          SuratText.Add('  <tr>');
          if LogoB64 <> '' then
            SuratText.Add('    <td style="width: 2.5cm; vertical-align: middle;"><img class="kop-logo" src="data:image/jpeg;base64,' + LogoB64 + '" alt="Logo Banjarmasin"></td>')
          else
            SuratText.Add('    <td style="width: 2.5cm; vertical-align: middle;"><img class="kop-logo" src="logo_banjarmasin.jpg" alt="Logo Banjarmasin"></td>');

          SuratText.Add('    <td class="kop-text-container">');
          SuratText.Add('      <div class="kop-h1">PEMERINTAH KOTA BANJARMASIN</div>');
          SuratText.Add('      <div class="kop-h1">DINAS LINGKUNGAN HIDUP</div>');
          SuratText.Add('      <div class="kop-sub">Jalan R.E. Martadinata No.1 Gedung Blok D Banjarmasin 70111</div>');
          SuratText.Add('      <div class="kop-sub">Telp. (0511) 3363811, Fax. 3363811</div>');
          SuratText.Add('      <div class="kop-city">BANJARMASIN</div>');
          SuratText.Add('    </td>');
          SuratText.Add('  </tr>');
          SuratText.Add('</table>');

          // Tanggal Surat Right Aligned
          SuratText.Add('<div class="date-right">Banjarmasin, ' + TglFormat + '</div>');

          // Judul Surat
          SuratText.Add('<div class="doc-title">SURAT IZIN &amp; TANDA TERIMA PENGAJUAN BARANG GUDANG</div>');

          // Informasi Metadata (Status Hilangkan sesuai instruksi!)
          SuratText.Add('<table class="meta-table">');
          SuratText.Add('  <tr><td class="meta-label">No. Pengajuan</td><td>: ' + NoPengajuan + '</td></tr>');
          SuratText.Add('  <tr><td class="meta-label">Tanggal</td><td>: ' + TglNow + '</td></tr>');
          SuratText.Add('  <tr><td class="meta-label">Bidang Pemohon</td><td>: ' + CboBidang.Text + '</td></tr>');
          SuratText.Add('</table>');

          // Tabel Daftar Barang
          SuratText.Add('<table class="item-table">');
          SuratText.Add('  <thead>');
          SuratText.Add('    <tr><th style="width: 40px;">No</th><th style="width: 180px;">Kode Rekening</th><th>Nama Barang</th><th style="width: 130px;">Jumlah &amp; Satuan</th></tr>');
          SuratText.Add('  </thead>');
          SuratText.Add('  <tbody>');

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

            SuratText.Add('    <tr>');
            SuratText.Add('      <td class="center">' + IntToStr(I) + '</td>');
            SuratText.Add('      <td>' + KodeRek + '</td>');
            SuratText.Add('      <td>' + NamaBrg + '</td>');
            SuratText.Add('      <td class="center">' + GridKeranjang.Cells[2, I] + ' ' + GridKeranjang.Cells[3, I] + '</td>');
            SuratText.Add('    </tr>');
          end;

          SuratText.Add('  </tbody>');
          SuratText.Add('</table>');

          // TTD Pemohon (Ditulis Bidang Mewakilkan / Penanggung Jawab) & Petugas Gudang
          SuratText.Add('<table class="sig-table">');
          SuratText.Add('  <tr>');
          SuratText.Add('    <td>Petugas Gudang DLH,<div class="sig-space"></div><div class="sig-name">( .................................................... )</div></td>');
          SuratText.Add('    <td>Pemohon / Penanggung Jawab<br><b>' + CboBidang.Text + '</b><div class="sig-space"></div><div class="sig-name">( .................................................... )</div></td>');
          SuratText.Add('  </tr>');
          SuratText.Add('</table>');

          SuratText.Add('<script>window.onload = function() { window.print(); };</script>');
          SuratText.Add('</body>');
          SuratText.Add('</html>');

          SuratText.SaveToFile(SaveDialog1.FileName, TEncoding.UTF8);
          ShellExecute(0, 'open', PChar(SaveDialog1.FileName), nil, nil, SW_SHOWNORMAL);

          ShowMessage('PENGAJUAN BERHASIL DISIMPAN & SURAT IZIN TERUNDUH!' + sLineBreak + sLineBreak +
                      'No. Pengajuan: ' + NoPengajuan + sLineBreak +
                      'File Surat Izin: ' + SaveDialog1.FileName);
        finally
          SuratText.Free;
        end;
      end;
    end
    else
    begin
      ShowMessage('PENGAJUAN BERHASIL DISIMPAN!' + sLineBreak +
                  'No. Pengajuan: ' + NoPengajuan);
    end;

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
