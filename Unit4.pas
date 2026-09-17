unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage,
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

procedure TForm4.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Validasi Arsip & Pemotongan Stok Fisik - DLH Banjarmasin';
  Self.WindowState := wsMaximized;
  SelectedFilePath := '';
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
  TargetDir := ExtractFilePath(ParamStr(0)) + 'arsip_bukti'' + FormatDateTime('yyyy-mm', Now);
  if not DirectoryExists(TargetDir) then
    ForceDirectories(TargetDir);

  Ext := ExtractFileExt(SelectedFilePath);
  TargetFile := TargetDir + ''' + NoPengajuan + '_' + FormatDateTime('hhnnss', Now) + Ext;

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
