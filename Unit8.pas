unit Unit8;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.ComCtrls, FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm8 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    BtnKembali: TButton;
    PnlFilter: TPanel;
    LblBulan: TLabel;
    CboBulan: TComboBox;
    LblTahun: TLabel;
    EdtTahun: TEdit;
    LblDari: TLabel;
    DTPDari: TDateTimePicker;
    LblSampai: TLabel;
    DTPSampai: TDateTimePicker;
    ChkFilterTanggal: TCheckBox;
    LblBidang: TLabel;
    CboBidang: TComboBox;
    LblCari: TLabel;
    EdCari: TEdit;
    PnlKonten: TPanel;
    PnlDaftar: TPanel;
    LblDaftar: TLabel;
    GridArsip: TStringGrid;
    PnlFooterDaftar: TPanel;
    LblTotalRecord: TLabel;
    PnlPreview: TPanel;
    LblJudulPreview: TLabel;
    PnlInfoDoc: TPanel;
    LblNoDoc: TLabel;
    LblBidangDoc: TLabel;
    LblTglDoc: TLabel;
    LblFileDoc: TLabel;
    ImgPreview: TImage;
    PnlAksi: TPanel;
    BtnBukaFile: TButton;
    BtnBukaFolder: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
    procedure CboBulanChange(Sender: TObject);
    procedure EdtTahunChange(Sender: TObject);
    procedure DTPDariChange(Sender: TObject);
    procedure DTPSampaiChange(Sender: TObject);
    procedure ChkFilterTanggalClick(Sender: TObject);
    procedure CboBidangChange(Sender: TObject);
    procedure EdCariChange(Sender: TObject);
    procedure GridArsipClick(Sender: TObject);
    procedure GridArsipDblClick(Sender: TObject);
    procedure ImgPreviewClick(Sender: TObject);
    procedure BtnBukaFileClick(Sender: TObject);
    procedure BtnBukaFolderClick(Sender: TObject);
  private
    SelectedFilePath: string;
    procedure LoadBidangCombo;
    procedure TampilDataArsip;
    procedure RenderPDFPreview(const AFilePath: string);
    procedure MuatPratinjau(const AFilePath: string);
  public
  end;

var
  Form8: TForm8;

implementation

uses UnitDB;

{ *.dfm}

procedure TForm8.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Arsip Dokumen Bukti Validasi - DLH Banjarmasin';
  Self.WindowState := wsMaximized;

  GridArsip.ColCount := 7;
  GridArsip.Cells[0, 0] := 'No';
  GridArsip.Cells[1, 0] := 'Tanggal';
  GridArsip.Cells[2, 0] := 'No. Pengajuan';
  GridArsip.Cells[3, 0] := 'Bidang Pemohon';
  GridArsip.Cells[4, 0] := 'Tipe';
  GridArsip.Cells[5, 0] := 'Nama Berkas Bukti';
  GridArsip.Cells[6, 0] := 'File Path';

  DTPDari.Date := Now;
  DTPSampai.Date := Now;
  EdtTahun.Text := FormatDateTime('yyyy', Now);
end;

procedure TForm8.FormShow(Sender: TObject);
begin
  LoadBidangCombo;
  TampilDataArsip;
end;

procedure TForm8.FormResize(Sender: TObject);
var
  SisaLebar: Integer;
begin
  GridArsip.ColWidths[6] := 0;

  SisaLebar := GridArsip.ClientWidth - 40 - 90 - 150 - 180 - 70 - 20;
  if SisaLebar > 150 then
  begin
    GridArsip.ColWidths[0] := 40;
    GridArsip.ColWidths[1] := 90;
    GridArsip.ColWidths[2] := 150;
    GridArsip.ColWidths[3] := 180;
    GridArsip.ColWidths[4] := 70;
    GridArsip.ColWidths[5] := SisaLebar;
  end;
end;

procedure TForm8.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm8.LoadBidangCombo;
var
  Q: TFDQuery;
  Curr: string;
begin
  Curr := CboBidang.Text;
  CboBidang.Items.BeginUpdate;
  try
    CboBidang.Items.Clear;
    CboBidang.Items.Add('Semua Bidang');

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := ModulDB.Koneksi;
      Q.SQL.Text := 'SELECT DISTINCT Bidang FROM Tabel_Pengajuan WHERE Bidang IS NOT NULL AND Bidang <> '''' ORDER BY Bidang ASC';
      Q.Open;
      while not Q.Eof do
      begin
        CboBidang.Items.Add(Q.Fields[0].AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    CboBidang.Items.EndUpdate;
  end;

  if (Curr <> '') and (CboBidang.Items.IndexOf(Curr) >= 0) then
    CboBidang.ItemIndex := CboBidang.Items.IndexOf(Curr)
  else
    CboBidang.ItemIndex := 0;
end;

procedure TForm8.TampilDataArsip;
var
  Q: TFDQuery;
  Baris: Integer;
  SearchKey, SelBidang, TglAwal, TglAkhir, FileExt, NamaFile, FPath: string;
  BulanIndex: Integer;
  BulanStr, TahunStr: string;
  WhereClause: string;
begin
  GridArsip.RowCount := 2;
  GridArsip.Rows[1].Clear;
  Baris := 1;

  SearchKey := LowerCase(Trim(EdCari.Text));
  SelBidang := Trim(CboBidang.Text);
  BulanIndex := CboBulan.ItemIndex;
  TahunStr := Trim(EdtTahun.Text);

  WhereClause := 'WHERE Status = ''DIVALIDASI'' AND Bukti_Foto IS NOT NULL AND Bukti_Foto <> '''' ';

  if (BulanIndex > 0) and (TahunStr <> '') then
  begin
    BulanStr := Format('%.2d', [BulanIndex]);
    WhereClause := WhereClause + 'AND strftime(''%Y-%m'', Tanggal) = ''' + TahunStr + '-' + BulanStr + ''' ';
  end
  else if TahunStr <> '' then
  begin
    WhereClause := WhereClause + 'AND strftime(''%Y'', Tanggal) = ''' + TahunStr + ''' ';
  end;

  if ChkFilterTanggal.Checked then
  begin
    TglAwal := FormatDateTime('yyyy-mm-dd', DTPDari.Date);
    TglAkhir := FormatDateTime('yyyy-mm-dd', DTPSampai.Date);
    WhereClause := WhereClause + 'AND Tanggal >= ''' + TglAwal + ''' AND Tanggal <= ''' + TglAkhir + ''' ';
  end;

  if (SelBidang <> '') and (SelBidang <> 'Semua Bidang') then
  begin
    WhereClause := WhereClause + 'AND Bidang = :bidang ';
  end;

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT No_Pengajuan, Tanggal, Bidang, Status, Bukti_Foto FROM Tabel_Pengajuan ' +
                  WhereClause + 'ORDER BY Tanggal DESC, No_Pengajuan DESC';

    if (SelBidang <> '') and (SelBidang <> 'Semua Bidang') then
      Q.ParamByName('bidang').AsString := SelBidang;

    Q.Open;

    while not Q.Eof do
    begin
      FPath := Q.FieldByName('Bukti_Foto').AsString;
      NamaFile := ExtractFileName(FPath);

      if (SearchKey = '') or
         (Pos(SearchKey, LowerCase(Q.FieldByName('No_Pengajuan').AsString)) > 0) or
         (Pos(SearchKey, LowerCase(Q.FieldByName('Bidang').AsString)) > 0) or
         (Pos(SearchKey, LowerCase(NamaFile)) > 0) then
      begin
        if Baris >= GridArsip.RowCount then
          GridArsip.RowCount := Baris + 1;

        FileExt := UpperCase(ExtractFileExt(FPath));
        if (FileExt <> '') and (FileExt[1] = '.') then
          Delete(FileExt, 1, 1);

        GridArsip.Cells[0, Baris] := IntToStr(Baris);
        GridArsip.Cells[1, Baris] := Q.FieldByName('Tanggal').AsString;
        GridArsip.Cells[2, Baris] := Q.FieldByName('No_Pengajuan').AsString;
        GridArsip.Cells[3, Baris] := Q.FieldByName('Bidang').AsString;
        GridArsip.Cells[4, Baris] := FileExt;
        GridArsip.Cells[5, Baris] := NamaFile;
        GridArsip.Cells[6, Baris] := FPath;

        Inc(Baris);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  LblTotalRecord.Caption := 'Total Berkas Arsip Ditemukan: ' + IntToStr(Baris - 1) + ' Dokumen';

  if Baris > 1 then
  begin
    GridArsip.Row := 1;
    GridArsipClick(Self);
  end
  else
  begin
    SelectedFilePath := '';
    ImgPreview.Picture := nil;
    LblNoDoc.Caption := 'No. Pengajuan: -';
    LblBidangDoc.Caption := 'Bidang: -';
    LblTglDoc.Caption := 'Tanggal: -';
    LblFileDoc.Caption := 'Berkas: (Tidak ada berkas)';
  end;
end;

procedure TForm8.RenderPDFPreview(const AFilePath: string);
var
  Bmp: TBitmap;
  W, H, CenterX: Integer;
  R: TRect;
  FileNameStr, SizeStr: string;
  F: TFileStream;
  FSize: Int64;
begin
  FileNameStr := ExtractFileName(AFilePath);
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

  W := ImgPreview.Width;
  H := ImgPreview.Height;
  if (W <= 50) or (H <= 50) then
  begin
    W := 380;
    H := 400;
  end;

  Bmp := TBitmap.Create;
  try
    Bmp.PixelFormat := pf24bit;
    Bmp.SetSize(W, H);

    Bmp.Canvas.Brush.Color := RGB(248, 249, 250);
    Bmp.Canvas.FillRect(Rect(0, 0, W, H));

    Bmp.Canvas.Pen.Color := RGB(220, 225, 232);
    Bmp.Canvas.Pen.Width := 1;
    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.RoundRect(10, 10, W - 10, H - 10, 12, 12);

    Bmp.Canvas.Brush.Color := RGB(217, 48, 37);
    Bmp.Canvas.Pen.Color := RGB(217, 48, 37);
    Bmp.Canvas.RoundRect(20, 20, W - 20, 65, 8, 8);

    Bmp.Canvas.Font.Name := 'Segoe UI';
    Bmp.Canvas.Font.Size := 11;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := clWhite;
    R := Rect(24, 30, W - 24, 58);
    DrawText(Bmp.Canvas.Handle, PChar('DOKUMEN SCAN / PDF TERARSIP'), -1, R, DT_CENTER or DT_SINGLELINE);

    CenterX := W div 2;
    Bmp.Canvas.Pen.Color := RGB(180, 185, 195);
    Bmp.Canvas.Pen.Width := 2;
    Bmp.Canvas.Brush.Color := RGB(250, 251, 253);
    Bmp.Canvas.Rectangle(CenterX - 50, 80, CenterX + 50, 180);

    Bmp.Canvas.Pen.Color := RGB(217, 48, 37);
    Bmp.Canvas.Pen.Width := 3;
    Bmp.Canvas.MoveTo(CenterX - 30, 105);
    Bmp.Canvas.LineTo(CenterX + 30, 105);
    Bmp.Canvas.Pen.Color := RGB(200, 205, 215);
    Bmp.Canvas.Pen.Width := 2;
    Bmp.Canvas.MoveTo(CenterX - 30, 125);
    Bmp.Canvas.LineTo(CenterX + 30, 125);
    Bmp.Canvas.MoveTo(CenterX - 30, 145);
    Bmp.Canvas.LineTo(CenterX + 30, 145);

    Bmp.Canvas.Brush.Color := RGB(217, 48, 37);
    Bmp.Canvas.Font.Size := 8;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := clWhite;
    Bmp.Canvas.TextOut(CenterX - 14, 86, 'PDF');

    Bmp.Canvas.Brush.Color := clWhite;
    Bmp.Canvas.Font.Name := 'Segoe UI';
    Bmp.Canvas.Font.Size := 10;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := RGB(33, 37, 41);
    R := Rect(20, 195, W - 20, 245);
    DrawText(Bmp.Canvas.Handle, PChar(FileNameStr), -1, R, DT_CENTER or DT_WORDBREAK or DT_NOPREFIX);

    if SizeStr <> '' then
    begin
      Bmp.Canvas.Font.Size := 9;
      Bmp.Canvas.Font.Style := [];
      Bmp.Canvas.Font.Color := RGB(108, 117, 125);
      R := Rect(20, 248, W - 20, 268);
      DrawText(Bmp.Canvas.Handle, PChar('Ukuran Berkas: ' + SizeStr), -1, R, DT_CENTER or DT_SINGLELINE);
    end;

    Bmp.Canvas.Font.Size := 10;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := RGB(25, 135, 84);
    R := Rect(20, 275, W - 20, 295);
    DrawText(Bmp.Canvas.Handle, PChar('TERARSIP RESMI DLH BANJARMASIN'), -1, R, DT_CENTER or DT_SINGLELINE);

    Bmp.Canvas.Brush.Color := RGB(13, 110, 253);
    Bmp.Canvas.Pen.Color := RGB(13, 110, 253);
    Bmp.Canvas.RoundRect(30, 310, W - 30, 350, 8, 8);

    Bmp.Canvas.Font.Size := 9;
    Bmp.Canvas.Font.Style := [fsBold];
    Bmp.Canvas.Font.Color := clWhite;
    R := Rect(34, 320, W - 34, 342);
    DrawText(Bmp.Canvas.Handle, PChar('👉 Klik di sini untuk Membuka Dokumen'), -1, R, DT_CENTER or DT_SINGLELINE);

    ImgPreview.Picture.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TForm8.MuatPratinjau(const AFilePath: string);
var
  Ext: string;
begin
  SelectedFilePath := AFilePath;

  if (AFilePath = '') or not FileExists(AFilePath) then
  begin
    ImgPreview.Picture := nil;
    Exit;
  end;

  Ext := LowerCase(ExtractFileExt(AFilePath));
  if Ext = '.pdf' then
  begin
    RenderPDFPreview(AFilePath);
  end
  else
  begin
    try
      ImgPreview.Picture.LoadFromFile(AFilePath);
    except
      ImgPreview.Picture := nil;
    end;
  end;
end;

procedure TForm8.GridArsipClick(Sender: TObject);
var
  RowIdx: Integer;
  FPath: string;
begin
  RowIdx := GridArsip.Row;
  if (RowIdx >= 1) and (RowIdx < GridArsip.RowCount) and (GridArsip.Cells[2, RowIdx] <> '') then
  begin
    LblTglDoc.Caption := 'Tanggal: ' + GridArsip.Cells[1, RowIdx];
    LblNoDoc.Caption := 'No. Pengajuan: ' + GridArsip.Cells[2, RowIdx];
    LblBidangDoc.Caption := 'Bidang: ' + GridArsip.Cells[3, RowIdx];
    LblFileDoc.Caption := 'Berkas: ' + GridArsip.Cells[5, RowIdx];

    FPath := GridArsip.Cells[6, RowIdx];
    MuatPratinjau(FPath);
  end;
end;

procedure TForm8.GridArsipDblClick(Sender: TObject);
begin
  BtnBukaFileClick(Self);
end;

procedure TForm8.ImgPreviewClick(Sender: TObject);
begin
  BtnBukaFileClick(Self);
end;

procedure TForm8.BtnBukaFileClick(Sender: TObject);
begin
  if (SelectedFilePath <> '') and FileExists(SelectedFilePath) then
  begin
    ShellExecute(0, 'open', PChar(SelectedFilePath), nil, nil, SW_SHOWNORMAL);
  end
  else
  begin
    ShowMessage('Peringatan: Berkas fisik tidak ditemukan di lokasi penyimpanan:' + sLineBreak + SelectedFilePath);
  end;
end;

procedure TForm8.BtnBukaFolderClick(Sender: TObject);
var
  Dir: string;
begin
  if SelectedFilePath <> '' then
    Dir := ExtractFilePath(SelectedFilePath)
  else
    Dir := ExtractFilePath(ParamStr(0)) + 'arsip_bukti';

  if DirectoryExists(Dir) then
    ShellExecute(0, 'open', PChar(Dir), nil, nil, SW_SHOWNORMAL)
  else
    ShowMessage('Folder arsip belum tersedia.');
end;

procedure TForm8.CboBulanChange(Sender: TObject);
begin
  TampilDataArsip;
end;

procedure TForm8.EdtTahunChange(Sender: TObject);
begin
  TampilDataArsip;
end;

procedure TForm8.DTPDariChange(Sender: TObject);
begin
  if ChkFilterTanggal.Checked then
    TampilDataArsip;
end;

procedure TForm8.DTPSampaiChange(Sender: TObject);
begin
  if ChkFilterTanggal.Checked then
    TampilDataArsip;
end;

procedure TForm8.ChkFilterTanggalClick(Sender: TObject);
begin
  TampilDataArsip;
end;

procedure TForm8.CboBidangChange(Sender: TObject);
begin
  TampilDataArsip;
end;

procedure TForm8.EdCariChange(Sender: TObject);
begin
  TampilDataArsip;
end;

end.
