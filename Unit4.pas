unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, System.UITypes,
  System.NetEncoding, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs,
  Vcl.Grids, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm4 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    BtnKembali: TButton;
    PnlKiri: TPanel;
    LblPengajuan: TLabel;
    CboPengajuan: TComboBox;
    LblDetailJudul: TLabel;
    GridDetailPengajuan: TStringGrid;
    LblRingkasanDetail: TLabel;
    BtnCetakUlangSurat: TButton;
    BtnTolakPengajuan: TButton;
    LblUpload: TLabel;
    BtnUpload: TButton;
    BtnResetFoto: TButton;
    PnlStatus: TPanel;
    LblInfo: TLabel;
    PnlKanan: TPanel;
    LblPreview: TLabel;
    ImgBukti: TImage;
    BtnValidasi: TButton;
    OpenDialog1: TOpenDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CboPengajuanChange(Sender: TObject);
    procedure BtnCetakUlangSuratClick(Sender: TObject);
    procedure BtnTolakPengajuanClick(Sender: TObject);
    procedure BtnUploadClick(Sender: TObject);
    procedure BtnResetFotoClick(Sender: TObject);
    procedure BtnValidasiClick(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
    procedure ImgBuktiClick(Sender: TObject);
  private
    SelectedFilePath: string;
    procedure LoadPendingPengajuan;
    procedure RenderPDFPreview(const AFilePath: string);
  public
  end;

var
  Form4: TForm4;

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

procedure TForm4.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Validasi Arsip & Pemotongan Stok Fisik - DLH Banjarmasin';
  Self.WindowState := wsMaximized;
  SelectedFilePath := '';

  GridDetailPengajuan.ColCount := 5;
  GridDetailPengajuan.Cells[0, 0] := 'No';
  GridDetailPengajuan.Cells[1, 0] := 'Nama Barang';
  GridDetailPengajuan.Cells[2, 0] := 'Jumlah';
  GridDetailPengajuan.Cells[3, 0] := 'Satuan';
  GridDetailPengajuan.Cells[4, 0] := 'Sisa Stok';
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  LoadPendingPengajuan;
  ImgBukti.Picture := nil;
  SelectedFilePath := '';
end;

procedure TForm4.LoadPendingPengajuan;
var
  Q: TFDQuery;
begin
  CboPengajuan.Items.Clear;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT No_Pengajuan, Bidang FROM Tabel_Pengajuan WHERE Status = ''PENDING'' ORDER BY No_Pengajuan DESC';
    Q.Open;

    while not Q.Eof do
    begin
      CboPengajuan.Items.Add(Q.FieldByName('No_Pengajuan').AsString + ' - ' + Q.FieldByName('Bidang').AsString);
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  if CboPengajuan.Items.Count > 0 then
    CboPengajuan.ItemIndex := 0
  else
    CboPengajuan.Text := '';

  CboPengajuanChange(Self);
end;

procedure TForm4.CboPengajuanChange(Sender: TObject);
var
  NoPengajuan: string;
  PosDash, Baris, TotalJenis, TotalUnit: Integer;
  Q: TFDQuery;
begin
  GridDetailPengajuan.RowCount := 2;
  GridDetailPengajuan.Rows[1].Clear;
  Baris := 1;
  TotalJenis := 0;
  TotalUnit := 0;

  if CboPengajuan.Text <> '' then
  begin
    PosDash := Pos(' - ', CboPengajuan.Text);
    if PosDash > 0 then
      NoPengajuan := Trim(Copy(CboPengajuan.Text, 1, PosDash - 1))
    else
      NoPengajuan := Trim(CboPengajuan.Text);

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := ModulDB.Koneksi;
      Q.SQL.Text := 'SELECT D.Kode_Rekening, D.Nama_Barang, D.Jumlah, D.Satuan, COALESCE(B.Stok_Sisa, 0) AS Stok_Sisa ' +
                    'FROM Tabel_Pengajuan_Detail D ' +
                    'LEFT JOIN Tabel_Barang B ON D.Kode_Rekening = B.Kode_Rekening ' +
                    'WHERE D.No_Pengajuan = :no ORDER BY D.ID ASC';
      Q.ParamByName('no').AsString := NoPengajuan;
      Q.Open;

      while not Q.Eof do
      begin
        if Baris >= GridDetailPengajuan.RowCount then
          GridDetailPengajuan.RowCount := Baris + 1;

        GridDetailPengajuan.Cells[0, Baris] := IntToStr(Baris);
        GridDetailPengajuan.Cells[1, Baris] := Q.FieldByName('Nama_Barang').AsString;
        GridDetailPengajuan.Cells[2, Baris] := Q.FieldByName('Jumlah').AsString;
        GridDetailPengajuan.Cells[3, Baris] := Q.FieldByName('Satuan').AsString;
        GridDetailPengajuan.Cells[4, Baris] := Q.FieldByName('Stok_Sisa').AsString;

        Inc(TotalJenis);
        TotalUnit := TotalUnit + Q.FieldByName('Jumlah').AsInteger;
        Inc(Baris);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  end;

  if TotalJenis > 0 then
    LblRingkasanDetail.Caption := 'Total: ' + IntToStr(TotalJenis) + ' Jenis Barang (' + FormatFloat('#,##0', TotalUnit) + ' Unit Fisik)'
  else
    LblRingkasanDetail.Caption := 'Total: 0 Jenis Barang (0 Unit Fisik)';
end;

procedure TForm4.BtnTolakPengajuanClick(Sender: TObject);
var
  NoPengajuan: string;
  PosDash: Integer;
  Q: TFDQuery;
begin
  if CboPengajuan.Text = '' then
  begin
    ShowMessage('Pilih pengajuan yang ingin ditolak / dibatalkan terlebih dahulu.');
    Exit;
  end;

  PosDash := Pos(' - ', CboPengajuan.Text);
  if PosDash > 0 then
    NoPengajuan := Trim(Copy(CboPengajuan.Text, 1, PosDash - 1))
  else
    NoPengajuan := Trim(CboPengajuan.Text);

  if MessageDlg('KONFIRMASI PEMBATALAN PENGAJUAN:' + sLineBreak + sLineBreak +
                'No. Pengajuan: ' + NoPengajuan + sLineBreak +
                'Keterangan: ' + CboPengajuan.Text + sLineBreak + sLineBreak +
                'Apakah Anda yakin ingin MENOLAK / MEMBATALKAN pengajuan ini?' + sLineBreak +
                '(Status pengajuan akan diubah menjadi DITOLAK dan tidak memotong stok)',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'UPDATE Tabel_Pengajuan SET Status = ''DITOLAK'' WHERE No_Pengajuan = :no';
    Q.ParamByName('no').AsString := NoPengajuan;
    Q.ExecSQL;

    ShowMessage('Pengajuan ' + NoPengajuan + ' berhasil DIBATALKAN / DITOLAK.');
    LoadPendingPengajuan;
    ImgBukti.Picture := nil;
    SelectedFilePath := '';
  finally
    Q.Free;
  end;
end;

procedure TForm4.BtnCetakUlangSuratClick(Sender: TObject);
var
  NoPengajuan, TglPengajuan, Bidang, OutDir, OutPath: string;
  PosDash, ItemNo: Integer;
  QPengajuan, QDetail: TFDQuery;
  SuratText: TStringList;
  LogoB64, TglFormat: string;
begin
  if CboPengajuan.Text = '' then
  begin
    ShowMessage('Pilih pengajuan yang ingin dicetak suratnya terlebih dahulu.');
    Exit;
  end;

  PosDash := Pos(' - ', CboPengajuan.Text);
  if PosDash > 0 then
    NoPengajuan := Trim(Copy(CboPengajuan.Text, 1, PosDash - 1))
  else
    NoPengajuan := Trim(CboPengajuan.Text);

  QPengajuan := TFDQuery.Create(nil);
  QDetail := TFDQuery.Create(nil);
  try
    QPengajuan.Connection := ModulDB.Koneksi;
    QDetail.Connection := ModulDB.Koneksi;

    QPengajuan.SQL.Text := 'SELECT Tanggal, Bidang FROM Tabel_Pengajuan WHERE No_Pengajuan = :no';
    QPengajuan.ParamByName('no').AsString := NoPengajuan;
    QPengajuan.Open;

    if QPengajuan.Eof then
    begin
      ShowMessage('Data pengajuan tidak ditemukan di database.');
      Exit;
    end;

    TglPengajuan := QPengajuan.FieldByName('Tanggal').AsString;
    Bidang := QPengajuan.FieldByName('Bidang').AsString;

    QDetail.SQL.Text := 'SELECT Kode_Rekening, Nama_Barang, Jumlah, Satuan FROM Tabel_Pengajuan_Detail WHERE No_Pengajuan = :no ORDER BY ID ASC';
    QDetail.ParamByName('no').AsString := NoPengajuan;
    QDetail.Open;

    OutDir := ExtractFilePath(ParamStr(0)) + 'arsip_surat';
    if not DirectoryExists(OutDir) then
      ForceDirectories(OutDir);

    OutPath := OutDir + '\Surat_Pengajuan_' + NoPengajuan + '.html';

    LogoB64 := GetLogoBase64;
    TglFormat := TglPengajuan;

    SuratText := TStringList.Create;
    try
      SuratText.Add('<!DOCTYPE html>');
      SuratText.Add('<html><head><meta charset="utf-8">');
      SuratText.Add('<title>SURAT IZIN &amp; TANDA TERIMA PENGAJUAN BARANG GUDANG</title>');
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
      SuratText.Add('</head><body>');

      SuratText.Add('<table class="kop-table"><tr>');
      if LogoB64 <> '' then
        SuratText.Add('  <td style="width: 2.5cm; vertical-align: middle;"><img class="kop-logo" src="data:image/jpeg;base64,' + LogoB64 + '" alt="Logo Banjarmasin"></td>')
      else
        SuratText.Add('  <td style="width: 2.5cm; vertical-align: middle;"><img class="kop-logo" src="logo_banjarmasin.jpg" alt="Logo Banjarmasin"></td>');

      SuratText.Add('  <td class="kop-text-container">');
      SuratText.Add('    <div class="kop-h1">PEMERINTAH KOTA BANJARMASIN</div>');
      SuratText.Add('    <div class="kop-h1">DINAS LINGKUNGAN HIDUP</div>');
      SuratText.Add('    <div class="kop-sub">Jalan R.E. Martadinata No.1 Gedung Blok D Banjarmasin 70111</div>');
      SuratText.Add('    <div class="kop-sub">Telp. (0511) 3363811, Fax. 3363811</div>');
      SuratText.Add('    <div class="kop-city">BANJARMASIN</div>');
      SuratText.Add('  </td></tr></table>');

      SuratText.Add('<div class="date-right">Banjarmasin, ' + TglFormat + '</div>');
      SuratText.Add('<div class="doc-title">SURAT IZIN &amp; TANDA TERIMA PENGAJUAN BARANG GUDANG</div>');

      SuratText.Add('<table class="meta-table">');
      SuratText.Add('  <tr><td class="meta-label">No. Pengajuan</td><td>: ' + NoPengajuan + '</td></tr>');
      SuratText.Add('  <tr><td class="meta-label">Tanggal</td><td>: ' + TglPengajuan + '</td></tr>');
      SuratText.Add('  <tr><td class="meta-label">Bidang Pemohon</td><td>: ' + Bidang + '</td></tr>');
      SuratText.Add('</table>');

      SuratText.Add('<table class="item-table"><thead><tr>');
      SuratText.Add('  <th style="width: 40px;">No</th><th style="width: 180px;">Kode Rekening</th><th>Nama Barang</th><th style="width: 130px;">Jumlah &amp; Satuan</th>');
      SuratText.Add('</tr></thead><tbody>');

      ItemNo := 0;
      while not QDetail.Eof do
      begin
        Inc(ItemNo);
        SuratText.Add('  <tr>');
        SuratText.Add('    <td class="center">' + IntToStr(ItemNo) + '</td>');
        SuratText.Add('    <td>' + QDetail.FieldByName('Kode_Rekening').AsString + '</td>');
        SuratText.Add('    <td>' + QDetail.FieldByName('Nama_Barang').AsString + '</td>');
        SuratText.Add('    <td class="center">' + QDetail.FieldByName('Jumlah').AsString + ' ' + QDetail.FieldByName('Satuan').AsString + '</td>');
        SuratText.Add('  </tr>');
        QDetail.Next;
      end;

      SuratText.Add('</tbody></table>');

      SuratText.Add('<div class="notes">');
      SuratText.Add('  <b>Catatan &amp; Ketentuan:</b>');
      SuratText.Add('  <ol>');
      SuratText.Add('    <li>Barang yang telah diterima harap diperiksa kondisi fisik dan jumlahnya secara seksama.</li>');
      SuratText.Add('    <li>Tanda terima fisik ini wajib ditandatangani basah dan distempel oleh pejabat/staf penerima yang sah.</li>');
      SuratText.Add('    <li>Bukti fisik bertanda tangan diserahkan/diunggah kembali ke sistem inventaris gudang untuk pemotongan stok resmi.</li>');
      SuratText.Add('  </ol>');
      SuratText.Add('</div>');

      SuratText.Add('<table class="sig-table"><tr>');
      SuratText.Add('  <td>Petugas Pengurus Barang / Gudang<br><b>Dinas Lingkungan Hidup</b><div class="sig-space"></div><div class="sig-name">( .................................................... )</div></td>');
      SuratText.Add('  <td>Pemohon / Penanggung Jawab<br><b>' + Bidang + '</b><div class="sig-space"></div><div class="sig-name">( .................................................... )</div></td>');
      SuratText.Add('</tr></table>');

      SuratText.Add('</body></html>');

      SuratText.SaveToFile(OutPath, TEncoding.UTF8);
      ShellExecute(0, 'open', PChar(OutPath), nil, nil, SW_SHOWNORMAL);
    finally
      SuratText.Free;
    end;
  finally
    QDetail.Free;
    QPengajuan.Free;
  end;
end;

procedure TForm4.RenderPDFPreview(const AFilePath: string);
var
  Bmp: TBitmap;
  FSize: Int64;
  SizeStr, FileNameStr: string;
  F: TFileStream;
  R: TRect;
  W, H, CenterX: Integer;
begin
  FileNameStr := ExtractFileName(AFilePath);
  SizeStr := '';
  try
    if FileExists(AFilePath) then
    begin
      F := TFileStream.Create(AFilePath, fmOpenRead or fmShareDenyNone);
      try
        FSize := F.Size;
        if FSize < 1024 then
          SizeStr := IntToStr(FSize) + ' B'
        else if FSize < 1024 * 1024 then
          SizeStr := FormatFloat('0.0 KB', FSize / 1024)
        else
          SizeStr := FormatFloat('0.00 MB', FSize / (1024 * 1024));
      finally
        F.Free;
      end;
    end;
  except
    SizeStr := '';
  end;

  W := ImgBukti.Width;
  H := ImgBukti.Height;
  if (W <= 50) or (H <= 50) then
  begin
    W := 400;
    H := 430;
  end;

  Bmp := TBitmap.Create;
  try
    Bmp.PixelFormat := pf24bit;
    Bmp.SetSize(W, H);

    // 1. Latar Belakang Kartu
    Bmp.Canvas.Brush.Color := RGB(248, 249, 250);
    Bmp.Canvas.FillRect(Rect(0, 0, W, H));

    // 2. Kontainer Kartu Dokumen Putih
    Bmp.Canvas.Pen.Color := RGB(220, 225, 232);
    Bmp.Canvas.Pen.Width := 1;
    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.RoundRect(12, 12, W - 12, H - 12, 12, 12);

    // 3. Header Badge Merah Khas Dokumen PDF
    Bmp.Canvas.Brush.Color := RGB(217, 48, 37); // Adobe/Chrome PDF Red
    Bmp.Canvas.Pen.Color := RGB(217, 48, 37);
    Bmp.Canvas.RoundRect(24, 24, W - 24, 72, 8, 8);

    Bmp.Canvas.Font.Name := 'Segoe UI';
    Bmp.Canvas.Font.Size := 12;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := clWhite;
    R := Rect(28, 36, W - 28, 64);
    DrawText(Bmp.Canvas.Handle, PChar('DOKUMEN SCAN / PDF TERPILIH'), -1, R, DT_CENTER or DT_SINGLELINE);

    // 4. Ikon Dokumen Kertas
    CenterX := W div 2;
    Bmp.Canvas.Pen.Color := RGB(180, 185, 195);
    Bmp.Canvas.Pen.Width := 2;
    Bmp.Canvas.Brush.Color := RGB(250, 251, 253);
    Bmp.Canvas.Rectangle(CenterX - 55, 90, CenterX + 55, 195);

    // Garis lipatan / ilustrasi tulisan pada lembaran berkas
    Bmp.Canvas.Pen.Color := RGB(217, 48, 37);
    Bmp.Canvas.Pen.Width := 3;
    Bmp.Canvas.MoveTo(CenterX - 35, 115);
    Bmp.Canvas.LineTo(CenterX + 35, 115);
    Bmp.Canvas.Pen.Color := RGB(200, 205, 215);
    Bmp.Canvas.Pen.Width := 2;
    Bmp.Canvas.MoveTo(CenterX - 35, 135);
    Bmp.Canvas.LineTo(CenterX + 35, 135);
    Bmp.Canvas.MoveTo(CenterX - 35, 155);
    Bmp.Canvas.LineTo(CenterX + 35, 155);
    Bmp.Canvas.MoveTo(CenterX - 35, 175);
    Bmp.Canvas.LineTo(CenterX + 10, 175);

    // Teks label PDF di atas kertas
    Bmp.Canvas.Brush.Color := RGB(217, 48, 37);
    Bmp.Canvas.Font.Size := 8;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := clWhite;
    Bmp.Canvas.TextOut(CenterX - 14, 96, 'PDF');

    // 5. Nama Berkas PDF
    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.Font.Name := 'Segoe UI';
    Bmp.Canvas.Font.Size := 11;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := RGB(33, 37, 41);
    R := Rect(24, 212, W - 24, 260);
    DrawText(Bmp.Canvas.Handle, PChar(FileNameStr), -1, R, DT_CENTER or DT_WORDBREAK or DT_NOPREFIX);

    // 6. Ukuran Berkas
    if SizeStr <> '' then
    begin
      Bmp.Canvas.Font.Size := 9;
      Bmp.Canvas.Font.Style := [];
      Bmp.Canvas.Font.Color := RGB(108, 117, 125);
      R := Rect(24, 264, W - 24, 284);
      DrawText(Bmp.Canvas.Handle, PChar('Ukuran Berkas: ' + SizeStr), -1, R, DT_CENTER or DT_SINGLELINE);
    end;

    // 7. Status Valid & Siap Arsip
    Bmp.Canvas.Font.Size := 10;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := RGB(25, 135, 84); // Hijau Sukses
    R := Rect(24, 292, W - 24, 314);
    DrawText(Bmp.Canvas.Handle, PChar('Siap Divalidasi & Diarsipkan'), -1, R, DT_CENTER or DT_SINGLELINE);

    // 8. Tombol Ajakan Interaktif di Bawah (Bisa Diklik untuk Membuka PDF)
    Bmp.Canvas.Pen.Color := RGB(13, 110, 253);
    Bmp.Canvas.Pen.Width := 1;
    Bmp.Canvas.Brush.Color := RGB(235, 243, 255);
    Bmp.Canvas.RoundRect(24, H - 65, W - 24, H - 24, 8, 8);

    Bmp.Canvas.Font.Size := 9;
    Bmp.Canvas.Font.Style := [fsBold, fsUnderline];
    Bmp.Canvas.Font.Color := RGB(13, 110, 253);
    R := Rect(28, H - 55, W - 28, H - 32);
    DrawText(Bmp.Canvas.Handle, PChar('Klik di sini untuk Membuka / Membaca PDF'), -1, R, DT_CENTER or DT_SINGLELINE);

    ImgBukti.Picture.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TForm4.BtnUploadClick(Sender: TObject);
var
  Ext: string;
begin
  if OpenDialog1.Execute then
  begin
    SelectedFilePath := OpenDialog1.FileName;
    Ext := LowerCase(ExtractFileExt(SelectedFilePath));
    if Ext = '.pdf' then
    begin
      RenderPDFPreview(SelectedFilePath);
    end
    else
    begin
      try
        ImgBukti.Picture.LoadFromFile(SelectedFilePath);
      except
        on E: Exception do
        begin
          ShowMessage('Gagal memuat gambar bukti: ' + E.Message);
          SelectedFilePath := '';
          ImgBukti.Picture := nil;
        end;
      end;
    end;
  end;
end;

procedure TForm4.ImgBuktiClick(Sender: TObject);
begin
  if (SelectedFilePath <> '') and FileExists(SelectedFilePath) then
  begin
    ShellExecute(0, 'open', PChar(SelectedFilePath), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TForm4.BtnResetFotoClick(Sender: TObject);
begin
  ImgBukti.Picture := nil;
  SelectedFilePath := '';
  ShowMessage('Berkas bukti fisik (PDF/Foto) telah dibatalkan / dihapus.');
end;

procedure TForm4.BtnValidasiClick(Sender: TObject);
var
  NoPengajuan, TargetDir, TargetFile, Ext, TglNow, KodeRek: string;
  PosDash, Jml: Integer;
  Q, QDetail: TFDQuery;
begin
  if CboPengajuan.Text = '' then
  begin
    ShowMessage('VALIDASI GAGAL: Pilih pengajuan yang akan divalidasi!');
    Exit;
  end;

  if SelectedFilePath = '' then
  begin
    ShowMessage('VALIDASI GAGAL: Unggah foto/scan bukti tanda terima fisik terlebih dahulu!');
    Exit;
  end;

  PosDash := Pos(' - ', CboPengajuan.Text);
  if PosDash > 0 then
    NoPengajuan := Trim(Copy(CboPengajuan.Text, 1, PosDash - 1))
  else
    NoPengajuan := Trim(CboPengajuan.Text);

  if MessageDlg('KONFIRMASI VALIDASI & PEMOTONGAN STOK:' + sLineBreak + sLineBreak +
                'No. Pengajuan: ' + NoPengajuan + sLineBreak +
                'File Bukti: ' + ExtractFileName(SelectedFilePath) + sLineBreak + sLineBreak +
                'Apakah Anda yakin dokumen tanda terima fisik sudah sah dan ingin memotong stok fisik gudang sekarang?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  // Buat Subfolder Arsip Bukti Per Bulan (format: arsip_bukti\YYYY-MM)
  TargetDir := ExtractFilePath(ParamStr(0)) + 'arsip_bukti\' + FormatDateTime('yyyy-mm', Now);
  if not DirectoryExists(TargetDir) then
    ForceDirectories(TargetDir);

  Ext := ExtractFileExt(SelectedFilePath);
  TargetFile := TargetDir + '\' + NoPengajuan + '_' + FormatDateTime('hhnnss', Now) + Ext;

  TglNow := FormatDateTime('yyyy-mm-dd', Now);

  ModulDB.Koneksi.StartTransaction;
  Q := TFDQuery.Create(nil);
  QDetail := TFDQuery.Create(nil);
  try
    // Copy Foto ke Folder Arsip
    CopyFile(PChar(SelectedFilePath), PChar(TargetFile), False);

    Q.Connection := ModulDB.Koneksi;
    QDetail.Connection := ModulDB.Koneksi;

    // 1. Update Status Pengajuan ke DIVALIDASI dan Simpan Lokasi Bukti Foto
    Q.SQL.Text := 'UPDATE Tabel_Pengajuan SET Status = ''DIVALIDASI'', Bukti_Foto = :foto WHERE No_Pengajuan = :no';
    Q.ParamByName('foto').AsString := TargetFile;
    Q.ParamByName('no').AsString := NoPengajuan;
    Q.ExecSQL;

    // 2. Baca Detail Pengajuan
    QDetail.SQL.Text := 'SELECT Kode_Rekening, Jumlah FROM Tabel_Pengajuan_Detail WHERE No_Pengajuan = :no';
    QDetail.ParamByName('no').AsString := NoPengajuan;
    QDetail.Open;

    while not QDetail.Eof do
    begin
      KodeRek := QDetail.FieldByName('Kode_Rekening').AsString;
      Jml := QDetail.FieldByName('Jumlah').AsInteger;

      // Insert ke Tabel_Keluar
      Q.SQL.Text := 'INSERT INTO Tabel_Keluar (Tanggal, Kode_Rekening, Jumlah, No_Pengajuan) ' +
                    'VALUES (:tgl, :kode, :jml, :no)';
      Q.ParamByName('tgl').AsString := TglNow;
      Q.ParamByName('kode').AsString := KodeRek;
      Q.ParamByName('jml').AsInteger := Jml;
      Q.ParamByName('no').AsString := NoPengajuan;
      Q.ExecSQL;

      // Update Potong Stok di Tabel_Barang (Kolom Stok_Sisa) - Garansi Stok Tidak Pernah Minus
      Q.SQL.Text := 'UPDATE Tabel_Barang SET Stok_Sisa = MAX(0, Stok_Sisa - :jml) WHERE Kode_Rekening = :kode';
      Q.ParamByName('jml').AsInteger := Jml;
      Q.ParamByName('kode').AsString := KodeRek;
      Q.ExecSQL;

      QDetail.Next;
    end;

    ModulDB.Koneksi.Commit;
    ShowMessage('VALIDASI BERHASIL!' + sLineBreak +
                'Bukti fisik telah diarsipkan ke: ' + TargetFile + sLineBreak +
                'Stok gudang telah terpotong secara otomatis.');

    // Refresh & Reset Form
    LoadPendingPengajuan;
    ImgBukti.Picture := nil;
    SelectedFilePath := '';
  except
    on E: Exception do
    begin
      ModulDB.Koneksi.Rollback;
      ShowMessage('Gagal melakukan validasi & pemotongan stok: ' + E.Message);
    end;
  end;

  QDetail.Free;
  Q.Free;
end;

procedure TForm4.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
end;

end.
