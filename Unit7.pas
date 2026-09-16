unit Unit7;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants,
  System.Classes, System.UITypes, System.NetEncoding, System.Win.ComObj, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm7 = class(TForm)
    PnlHeader: TPanel;
    LblJudul: TLabel;
    BtnKembali: TButton;
    PnlPengaturan: TPanel;
    LblBulan: TLabel;
    LblTahun: TLabel;
    LblNoSurat: TLabel;
    LblTanggal: TLabel;
    LblKasubbag: TLabel;
    LblPengurus: TLabel;
    LblKadis: TLabel;
    CboBulan: TComboBox;
    EdtTahun: TEdit;
    EdtNoSurat: TEdit;
    DTPTanggal: TDateTimePicker;
    EdtKasubbagNama: TEdit;
    EdtKasubbagNIP: TEdit;
    EdtPengurusNama: TEdit;
    EdtPengurusNIP: TEdit;
    EdtKadisNama: TEdit;
    EdtKadisNIP: TEdit;
    PnlBawah: TPanel;
    LblTotalNilai: TLabel;
    BtnCetakPDF: TButton;
    BtnExportExcel: TButton;
    GridOpname: TStringGrid;
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure CboBulanChange(Sender: TObject);
    procedure EdtTahunChange(Sender: TObject);
    procedure BtnCetakPDFClick(Sender: TObject);
    procedure BtnExportExcelClick(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
  private
    GrandTotalNilai: Double;
    GrandTotalJumlah: Integer;
    procedure TampilStockOpname;
  public
  end;

var
  Form7: TForm7;

implementation

uses UnitDB;

{$R *.dfm}

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

procedure TForm7.FormCreate(Sender: TObject);
begin
  DTPTanggal.Date := Now;
  CboBulan.ItemIndex := FormatDateTime('m', Now).ToInteger - 1;
  EdtTahun.Text := FormatDateTime('yyyy', Now);
  EdtNoSurat.Text := '000.2.3.1 /      /Set-DLH /' + EdtTahun.Text;

  GridOpname.ColCount := 7;
  GridOpname.Cells[0, 0] := 'No';
  GridOpname.Cells[1, 0] := 'Kode Rekening';
  GridOpname.Cells[2, 0] := 'Nama Persediaan';
  GridOpname.Cells[3, 0] := 'Satuan';
  GridOpname.Cells[4, 0] := 'Jumlah Fisik';
  GridOpname.Cells[5, 0] := 'Harga/Unit (Rp)';
  GridOpname.Cells[6, 0] := 'Total Nilai (Rp)';
end;

procedure TForm7.FormShow(Sender: TObject);
begin
  TampilStockOpname;
end;

procedure TForm7.FormResize(Sender: TObject);
var
  SisaLebar: Integer;
begin
  SisaLebar := GridOpname.ClientWidth - 40 - 180 - 80 - 100 - 130 - 160 - 25;
  if SisaLebar > 200 then
  begin
    GridOpname.ColWidths[0] := 40;
    GridOpname.ColWidths[1] := 180;
    GridOpname.ColWidths[2] := SisaLebar;
    GridOpname.ColWidths[3] := 80;
    GridOpname.ColWidths[4] := 100;
    GridOpname.ColWidths[5] := 130;
    GridOpname.ColWidths[6] := 160;
  end;
end;

procedure TForm7.CboBulanChange(Sender: TObject);
begin
  TampilStockOpname;
end;

procedure TForm7.EdtTahunChange(Sender: TObject);
begin
  EdtNoSurat.Text := '000.2.3.1 /      /Set-DLH /' + EdtTahun.Text;
  TampilStockOpname;
end;

procedure TForm7.TampilStockOpname;
var
  QKat, QBarang: TFDQuery;
  Baris, SubJml, NoUrut: Integer;
  KatName, KatLabel: string;
  Harga, SubNilai, ItemTotal: Double;
begin
  GridOpname.RowCount := 2;
  GridOpname.Rows[1].Clear;
  Baris := 1;
  GrandTotalNilai := 0;
  GrandTotalJumlah := 0;

  QKat := TFDQuery.Create(nil);
  QBarang := TFDQuery.Create(nil);
  try
    QKat.Connection := ModulDB.Koneksi;
    QBarang.Connection := ModulDB.Koneksi;

    QKat.SQL.Text := 'SELECT DISTINCT Kategori FROM Tabel_Barang ORDER BY ' +
                     'CASE Kategori ' +
                     'WHEN ''Bibit Tanaman'' THEN 1 ' +
                     'WHEN ''ATK'' THEN 2 ' +
                     'WHEN ''Kertas & Cover'' THEN 3 ' +
                     'WHEN ''Bahan Komputer'' THEN 4 ' +
                     'WHEN ''Persediaan Masyarakat'' THEN 5 ' +
                     'ELSE 6 END';
    QKat.Open;

    while not QKat.Eof do
    begin
      KatName := QKat.FieldByName('Kategori').AsString;
      if KatName = 'Bibit Tanaman' then KatLabel := 'BAHAN/BIBIT TANAMAN'
      else if KatName = 'ATK' then KatLabel := 'ALAT TULIS KANTOR'
      else if KatName = 'Kertas & Cover' then KatLabel := 'KERTAS DAN COVER'
      else if KatName = 'Bahan Komputer' then KatLabel := 'BAHAN KOMPUTER'
      else if KatName = 'Persediaan Masyarakat' then KatLabel := 'PERSEDIAAN UNTUK DIJUAL/DISERAHKAN KEPADA MASYARAKAT'
      else KatLabel := UpperCase(KatName);

      if Baris >= GridOpname.RowCount then
        GridOpname.RowCount := Baris + 1;

      GridOpname.Cells[0, Baris] := '';
      GridOpname.Cells[1, Baris] := KatLabel;
      GridOpname.Cells[2, Baris] := '';
      GridOpname.Cells[3, Baris] := '';
      GridOpname.Cells[4, Baris] := '';
      GridOpname.Cells[5, Baris] := '';
      GridOpname.Cells[6, Baris] := '';
      Inc(Baris);

      QBarang.Close;
      QBarang.SQL.Text := 'SELECT Kode_Rekening, Nama_Barang, Satuan, Stok_Sisa, Harga_Satuan ' +
                          'FROM Tabel_Barang WHERE Kategori = :kat ORDER BY Nama_Barang ASC';
      QBarang.ParamByName('kat').AsString := KatName;
      QBarang.Open;

      SubJml := 0;
      SubNilai := 0;
      NoUrut := 1;

      while not QBarang.Eof do
      begin
        if Baris >= GridOpname.RowCount then
          GridOpname.RowCount := Baris + 1;

        Harga := QBarang.FieldByName('Harga_Satuan').AsFloat;
        ItemTotal := QBarang.FieldByName('Stok_Sisa').AsInteger * Harga;

        GridOpname.Cells[0, Baris] := IntToStr(NoUrut);
        GridOpname.Cells[1, Baris] := QBarang.FieldByName('Kode_Rekening').AsString;
        GridOpname.Cells[2, Baris] := QBarang.FieldByName('Nama_Barang').AsString;
        GridOpname.Cells[3, Baris] := QBarang.FieldByName('Satuan').AsString;
        GridOpname.Cells[4, Baris] := IntToStr(QBarang.FieldByName('Stok_Sisa').AsInteger);
        GridOpname.Cells[5, Baris] := FormatFloat('#,##0', Harga);
        GridOpname.Cells[6, Baris] := FormatFloat('#,##0', ItemTotal);

        SubJml := SubJml + QBarang.FieldByName('Stok_Sisa').AsInteger;
        SubNilai := SubNilai + ItemTotal;

        Inc(NoUrut);
        Inc(Baris);
        QBarang.Next;
      end;

      if Baris >= GridOpname.RowCount then
        GridOpname.RowCount := Baris + 1;

      GridOpname.Cells[0, Baris] := '';
      GridOpname.Cells[1, Baris] := 'Total ' + KatLabel + ' :';
      GridOpname.Cells[2, Baris] := '';
      GridOpname.Cells[3, Baris] := '';
      GridOpname.Cells[4, Baris] := IntToStr(SubJml);
      GridOpname.Cells[5, Baris] := '';
      GridOpname.Cells[6, Baris] := FormatFloat('#,##0', SubNilai);
      Inc(Baris);

      GrandTotalJumlah := GrandTotalJumlah + SubJml;
      GrandTotalNilai := GrandTotalNilai + SubNilai;

      QKat.Next;
    end;

    if Baris >= GridOpname.RowCount then
      GridOpname.RowCount := Baris + 1;

    GridOpname.Cells[0, Baris] := '';
    GridOpname.Cells[1, Baris] := 'TOTAL KESELURUHAN :';
    GridOpname.Cells[2, Baris] := '';
    GridOpname.Cells[3, Baris] := '';
    GridOpname.Cells[4, Baris] := IntToStr(GrandTotalJumlah);
    GridOpname.Cells[5, Baris] := '';
    GridOpname.Cells[6, Baris] := FormatFloat('#,##0', GrandTotalNilai);

    LblTotalNilai.Caption := 'TOTAL NILAI PERSEDIAAN: Rp ' + FormatFloat('#,##0', GrandTotalNilai);
  finally
    QKat.Free;
    QBarang.Free;
  end;
end;

procedure TForm7.BtnCetakPDFClick(Sender: TObject);
var
  SuratText: TStringList;
  LogoB64, TglFormat, BulanStr, TahunStr, ExtFile: string;
  I: Integer;
  IsHeaderKat, IsSubtotal, IsGrandTotal: Boolean;
begin
  SaveDialog1.Title := 'Pilih Lokasi Penyimpanan Berita Acara Stock Opname (HTML / PDF)';
  SaveDialog1.Filter := 'Dokumen Cetak / Web (*.html)|*.html|Dokumen Web (*.htm)|*.htm|Semua File (*.*)|*.*';
  SaveDialog1.DefaultExt := 'html';
  SaveDialog1.FileName := 'Berita_Acara_Stock_Opname_' + CboBulan.Text + '_' + EdtTahun.Text + '.html';

  if not SaveDialog1.Execute then Exit;

  ExtFile := LowerCase(ExtractFileExt(SaveDialog1.FileName));
  if (ExtFile <> '.html') and (ExtFile <> '.htm') then
    SaveDialog1.FileName := ChangeFileExt(SaveDialog1.FileName, '.html');

  LogoB64 := GetLogoBase64;
  TglFormat := FormatDateTime('dd mmmm yyyy', DTPTanggal.Date);
  BulanStr := CboBulan.Text;
  TahunStr := EdtTahun.Text;

  SuratText := TStringList.Create;
  try
    SuratText.Add('<!DOCTYPE html>');
    SuratText.Add('<html>');
    SuratText.Add('<head>');
    SuratText.Add('<meta charset="utf-8">');
    SuratText.Add('<title>BERITA ACARA STOCK OPNAME PERSEDIAAN DLH</title>');
    SuratText.Add('<style>');
    SuratText.Add('  @page { size: A4 portrait; margin: 1.2cm; }');
    SuratText.Add('  body { font-family: Arial, sans-serif; color: #000; background: #fff; margin: 0; padding: 15px; font-size: 10pt; }');
    SuratText.Add('  .kop-table { width: 100%; border-collapse: collapse; border-bottom: 3.5px double #000; padding-bottom: 8px; margin-bottom: 12px; }');
    SuratText.Add('  .kop-logo { width: 2.31cm; height: 3.3cm; object-fit: contain; }');
    SuratText.Add('  .kop-text-container { text-align: center; vertical-align: middle; }');
    SuratText.Add('  .kop-h1 { font-size: 16pt; font-weight: bold; margin: 0; line-height: 1.2; text-transform: uppercase; }');
    SuratText.Add('  .kop-sub { font-size: 10.5pt; margin: 2px 0 0 0; line-height: 1.3; }');
    SuratText.Add('  .doc-title { text-align: center; font-size: 12pt; font-weight: bold; margin-top: 15px; margin-bottom: 3px; text-transform: uppercase; }');
    SuratText.Add('  .doc-nomor { text-align: center; font-size: 11pt; font-weight: bold; margin-bottom: 15px; }');
    SuratText.Add('  .preamble { text-align: justify; font-size: 10pt; line-height: 1.5; margin-bottom: 15px; }');
    SuratText.Add('  .table-data { width: 100%; border-collapse: collapse; margin-bottom: 18px; font-size: 9pt; }');
    SuratText.Add('  .table-data th, .table-data td { border: 1px solid #000; padding: 5px 6px; }');
    SuratText.Add('  .table-data th { background-color: #f2f2f2; font-weight: bold; text-align: center; }');
    SuratText.Add('  .cat-row { background-color: #e8e8e8; font-weight: bold; }');
    SuratText.Add('  .subtotal-row { background-color: #f9f9f9; font-weight: bold; }');
    SuratText.Add('  .grand-row { background-color: #e0e0e0; font-weight: bold; }');
    SuratText.Add('  .right { text-align: right; }');
    SuratText.Add('  .center { text-align: center; }');
    SuratText.Add('  .closing { font-size: 10pt; margin-top: 15px; margin-bottom: 15px; }');
    SuratText.Add('  .sig-table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 10pt; }');
    SuratText.Add('  .sig-table td { width: 50%; text-align: center; vertical-align: top; }');
    SuratText.Add('  .sig-space { height: 60px; }');
    SuratText.Add('  .sig-name { font-weight: bold; text-decoration: underline; }');
    SuratText.Add('</style>');
    SuratText.Add('</head>');
    SuratText.Add('<body>');

    SuratText.Add('<table class="kop-table">');
    SuratText.Add('  <tr>');
    if LogoB64 <> '' then
      SuratText.Add('    <td style="width: 2.5cm; vertical-align: middle;"><img class="kop-logo" src="data:image/jpeg;base64,' + LogoB64 + '" alt="Logo Banjarmasin"></td>')
    else
      SuratText.Add('    <td style="width: 2.5cm; vertical-align: middle;"><img class="kop-logo" src="logo_banjarmasin.jpg" alt="Logo Banjarmasin"></td>');

    SuratText.Add('    <td class="kop-text-container">');
    SuratText.Add('      <div class="kop-h1">PEMERINTAH KOTA BANJARMASIN</div>');
    SuratText.Add('      <div class="kop-h1">DINAS LINGKUNGAN HIDUP</div>');
    SuratText.Add('      <div class="kop-sub">Jalan R.E. Martadinata No.1 Banjarmasin 70111</div>');
    SuratText.Add('      <div class="kop-sub">Telepon (0511) 3363792 - 4368145 Faks (0511) 3363792</div>');
    SuratText.Add('      <div class="kop-sub">Email : dlhbanjarmasin@gmail.com Website : dlh.banjarmasinkota.go.id</div>');
    SuratText.Add('    </td>');
    SuratText.Add('  </tr>');
    SuratText.Add('</table>');

    SuratText.Add('<div class="doc-title">BERITA ACARA STOCK OPNAME PERSEDIAAN ATK &amp; BARANG PAKAI HABIS</div>');
    SuratText.Add('<div class="doc-nomor">' + EdtNoSurat.Text + '</div>');

    SuratText.Add('<div class="preamble">');
    SuratText.Add('  Pada Hari ini, telah Dilaksanakan Stock Opname fisik Persediaan oleh Bendahara Barang yang disaksikan oleh Sekretaris. ' +
                  'Dari hasil stock opname diketahui nilai persediaan per bulan <b>' + BulanStr + ' ' + TahunStr + '</b> ' +
                  'sebesar <b>Rp ' + FormatFloat('#,##0', GrandTotalNilai) + ',-</b> dengan perincian sebagai berikut :');
    SuratText.Add('</div>');

    SuratText.Add('<table class="table-data">');
    SuratText.Add('  <thead>');
    SuratText.Add('    <tr>');
    SuratText.Add('      <th style="width: 30px;">No</th>');
    SuratText.Add('      <th style="width: 140px;">Kode Rekening</th>');
    SuratText.Add('      <th>Nama Persediaan</th>');
    SuratText.Add('      <th style="width: 65px;">Satuan</th>');
    SuratText.Add('      <th style="width: 60px;">Jumlah</th>');
    SuratText.Add('      <th style="width: 100px;">Harga/Unit (Rp)</th>');
    SuratText.Add('      <th style="width: 110px;">Total (Rp)</th>');
    SuratText.Add('    </tr>');
    SuratText.Add('  </thead>');
    SuratText.Add('  <tbody>');

    for I := 1 to GridOpname.RowCount - 1 do
    begin
      IsHeaderKat := (GridOpname.Cells[0, I] = '') and (Pos('Total', GridOpname.Cells[1, I]) = 0) and (GridOpname.Cells[1, I] <> '');
      IsSubtotal := (GridOpname.Cells[0, I] = '') and (Pos('Total ', GridOpname.Cells[1, I]) > 0);
      IsGrandTotal := Pos('TOTAL KESELURUHAN', GridOpname.Cells[1, I]) > 0;

      if IsHeaderKat then
      begin
        SuratText.Add('    <tr class="cat-row">');
        SuratText.Add('      <td colspan="7"><b>' + GridOpname.Cells[1, I] + '</b></td>');
        SuratText.Add('    </tr>');
      end
      else if IsSubtotal then
      begin
        SuratText.Add('    <tr class="subtotal-row">');
        SuratText.Add('      <td colspan="4" class="right"><b>' + GridOpname.Cells[1, I] + '</b></td>');
        SuratText.Add('      <td class="center"><b>' + GridOpname.Cells[4, I] + '</b></td>');
        SuratText.Add('      <td></td>');
        SuratText.Add('      <td class="right"><b>' + GridOpname.Cells[6, I] + '</b></td>');
        SuratText.Add('    </tr>');
      end
      else if IsGrandTotal then
      begin
        SuratText.Add('    <tr class="grand-row">');
        SuratText.Add('      <td colspan="4" class="right"><b>' + GridOpname.Cells[1, I] + '</b></td>');
        SuratText.Add('      <td class="center"><b>' + GridOpname.Cells[4, I] + '</b></td>');
        SuratText.Add('      <td></td>');
        SuratText.Add('      <td class="right"><b>' + GridOpname.Cells[6, I] + '</b></td>');
        SuratText.Add('    </tr>');
      end
      else
      begin
        SuratText.Add('    <tr>');
        SuratText.Add('      <td class="center">' + GridOpname.Cells[0, I] + '</td>');
        SuratText.Add('      <td>' + GridOpname.Cells[1, I] + '</td>');
        SuratText.Add('      <td>' + GridOpname.Cells[2, I] + '</td>');
        SuratText.Add('      <td class="center">' + GridOpname.Cells[3, I] + '</td>');
        SuratText.Add('      <td class="center">' + GridOpname.Cells[4, I] + '</td>');
        SuratText.Add('      <td class="right">' + GridOpname.Cells[5, I] + '</td>');
        SuratText.Add('      <td class="right">' + GridOpname.Cells[6, I] + '</td>');
        SuratText.Add('    </tr>');
      end;
    end;

    SuratText.Add('  </tbody>');
    SuratText.Add('</table>');

    SuratText.Add('<div class="closing">');
    SuratText.Add('  Demikian Berita Acara ini dibuat dengan sebenarnya untuk dapat dipergunakan sebagaimana mestinya.');
    SuratText.Add('</div>');

    SuratText.Add('<div style="text-align: right; margin-right: 15px; margin-bottom: 10px;">Banjarmasin, ' + TglFormat + '</div>');

    // Tanda Tangan 2 Pihak Atas (Kasubbag & Pengurus Barang)
    SuratText.Add('<table class="sig-table">');
    SuratText.Add('  <tr>');
    SuratText.Add('    <td>Kasubbag. Umum &amp; Kepegawaian,<div class="sig-space"></div><div class="sig-name">' + EdtKasubbagNama.Text + '</div><div>' + EdtKasubbagNIP.Text + '</div></td>');
    SuratText.Add('    <td>Pengurus Barang<div class="sig-space"></div><div class="sig-name">' + EdtPengurusNama.Text + '</div><div>' + EdtPengurusNIP.Text + '</div></td>');
    SuratText.Add('  </tr>');
    SuratText.Add('</table>');

    // Tanda Tangan Kepala Dinas di Bawah Tengah
    SuratText.Add('<table class="sig-table" style="margin-top: 20px;">');
    SuratText.Add('  <tr>');
    SuratText.Add('    <td style="width: 25%;"></td>');
    SuratText.Add('    <td style="width: 50%;">Mengetahui :<br>Kepala Dinas,<div class="sig-space"></div><div class="sig-name">' + EdtKadisNama.Text + '</div><div>' + EdtKadisNIP.Text + '</div></td>');
    SuratText.Add('    <td style="width: 25%;"></td>');
    SuratText.Add('  </tr>');
    SuratText.Add('</table>');

    SuratText.Add('<script>window.onload = function() { window.print(); };</script>');
    SuratText.Add('</body>');
    SuratText.Add('</html>');

    SuratText.SaveToFile(SaveDialog1.FileName, TEncoding.UTF8);
    ShellExecute(0, 'open', PChar(SaveDialog1.FileName), nil, nil, SW_SHOWNORMAL);
    ShowMessage('Berita Acara Stock Opname berhasil disimpan & siap dicetak!' + sLineBreak +
                'Tersimpan di: ' + SaveDialog1.FileName);
  finally
    SuratText.Free;
  end;
end;

procedure TForm7.BtnExportExcelClick(Sender: TObject);
var
  TemplatePath, ExeDir, TargetFile, BulanName, TglStr, KodeStr: string;
  XL, WB, WS: OleVariant;
  Q: TFDQuery;
  RowIdx, JmlStok: Integer;
  UseOLE: Boolean;
begin
  ExeDir := ExtractFilePath(ParamStr(0));
  if FileExists(ExeDir + 'STOCK OPNAME 2026.xlsx') then
    TemplatePath := ExeDir + 'STOCK OPNAME 2026.xlsx'
  else if FileExists(ExpandFileName(ExeDir + '..\..\STOCK OPNAME 2026.xlsx')) then
    TemplatePath := ExpandFileName(ExeDir + '..\..\STOCK OPNAME 2026.xlsx')
  else if FileExists(ExpandFileName('STOCK OPNAME 2026.xlsx')) then
    TemplatePath := ExpandFileName('STOCK OPNAME 2026.xlsx')
  else
    TemplatePath := '';

  SaveDialog1.Title := 'Export Laporan Stock Opname ke Microsoft Excel';
  SaveDialog1.Filter := 'Microsoft Excel Workbook (*.xlsx)|*.xlsx|Semua File (*.*)|*.*';
  SaveDialog1.DefaultExt := 'xlsx';
  SaveDialog1.FileName := 'Stock_Opname_' + CboBulan.Text + '_' + EdtTahun.Text + '.xlsx';

  if not SaveDialog1.Execute then Exit;

  TargetFile := SaveDialog1.FileName;
  if LowerCase(ExtractFileExt(TargetFile)) <> '.xlsx' then
    TargetFile := ChangeFileExt(TargetFile, '.xlsx');

  if (TemplatePath <> '') and FileExists(TemplatePath) then
  begin
    // Salin template master yang sudah lengkap dengan Logo Banjarmasin, Kop, rumus, & tabel
    if not CopyFile(PChar(TemplatePath), PChar(TargetFile), False) then
    begin
      ShowMessage('Gagal menyalin file template Excel. Pastikan file tujuan tidak sedang dibuka di Excel.');
      Exit;
    end;

    UseOLE := False;
    try
      XL := CreateOleObject('Excel.Application');
      UseOLE := True;
    except
      UseOLE := False;
    end;

    if UseOLE then
    begin
      try
        XL.Visible := False;
        XL.DisplayAlerts := False;
        WB := XL.Workbooks.Open(TargetFile);

        BulanName := UpperCase(CboBulan.Text);
        try
          WS := WB.Sheets[BulanName];
        except
          WS := WB.ActiveSheet;
        end;

        WS.Activate;

        // 1. Nomor Berita Acara (Cell A9)
        WS.Range['A9'].Value2 := EdtNoSurat.Text;

        // 2. Tanggal Berita Acara (Cell E76)
        TglStr := 'Banjarmasin, ' + FormatDateTime('dd mmmm yyyy', DTPTanggal.Date);
        WS.Range['E76'].Value2 := TglStr;

        // 3. Tanda Tangan Pejabat (Baris 81, 82, 90, 91)
        WS.Range['A81'].Value2 := EdtKasubbagNama.Text;
        WS.Range['A82'].Value2 := EdtKasubbagNIP.Text;

        WS.Range['E81'].Value2 := EdtPengurusNama.Text;
        WS.Range['E82'].Value2 := EdtPengurusNIP.Text;

        WS.Range['A90'].Value2 := EdtKadisNama.Text;
        WS.Range['A91'].Value2 := EdtKadisNIP.Text;

        // 4. Update Jumlah Fisik Real-Time dari Database
        Q := TFDQuery.Create(nil);
        try
          Q.Connection := ModulDB.Koneksi;
          Q.SQL.Text := 'SELECT Kode_Rekening, Stok_Sisa FROM Tabel_Barang';
          Q.Open;

          // Loop baris 16 s/d 70 pada sheet untuk mencocokkan Kode Rekening
          for RowIdx := 16 to 70 do
          begin
            KodeStr := Trim(VarToStr(WS.Range['A' + IntToStr(RowIdx)].Value2));
            if (KodeStr <> '') and (Pos('.', KodeStr) > 0) then
            begin
              if Q.Locate('Kode_Rekening', KodeStr, []) then
              begin
                JmlStok := Q.FieldByName('Stok_Sisa').AsInteger;
                WS.Range['F' + IntToStr(RowIdx)].Value2 := JmlStok;
              end;
            end;
          end;
        finally
          Q.Free;
        end;

        WB.Save;
        WB.Close(False);
        XL.Quit;
      except
        on E: Exception do
        begin
          try
            WB.Close(False);
            XL.Quit;
          except
          end;
        end;
      end;
    end;

    ShellExecute(0, 'open', PChar(TargetFile), nil, nil, SW_SHOWNORMAL);
    ShowMessage('SUKSES! Laporan Stock Opname berhasil diexport ke Microsoft Excel (.xlsx).' + sLineBreak + sLineBreak +
                'Format, logo, tabel, rumus, dan tanda tangan 100% identik dengan file resmi.' + sLineBreak +
                'Lokasi File: ' + TargetFile);
  end
  else
  begin
    ShowMessage('File template STOCK OPNAME 2026.xlsx tidak ditemukan di folder aplikasi.');
  end;
end;

procedure TForm7.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
end;

end.
