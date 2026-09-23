unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes, System.UITypes,
  System.NetEncoding, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm2 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    BtnKembali: TButton;
    PnlFilter: TPanel;
    LblCari: TLabel;
    EdCari: TEdit;
    LblKategori: TLabel;
    CboKategori: TComboBox;
    BtnResetCari: TButton;
    LblPetunjukCepat: TLabel;
    LblNoDokumen: TLabel;
    EdtNoDokumen: TEdit;
    LblAsalBarang: TLabel;
    EdtAsalBarang: TEdit;
    SaveDialog1: TSaveDialog;
    PnlBawah: TPanel;
    LblRingkasanMasuk: TLabel;
    BtnResetSemua: TButton;
    BtnSimpan: TButton;
    PnlTengah: TPanel;
    PnlKontrolKanan: TPanel;
    LblPanelKananJudul: TLabel;
    PnlCardBarang: TPanel;
    LblNamaBarangPilih: TLabel;
    LblKodeRekPilih: TLabel;
    LblStokSaatIni: TLabel;
    LblInputManual: TLabel;
    PnlInputBaris: TPanel;
    BtnKurang1: TButton;
    EdtJumlahMasuk: TEdit;
    BtnTambah1: TButton;
    PnlTombolNominal: TPanel;
    BtnPlus5: TButton;
    BtnPlus10: TButton;
    BtnPlus50: TButton;
    BtnPlus100: TButton;
    BtnResetBarang: TButton;
    PnlInfoBantuan: TPanel;
    LblBantuan: TLabel;
    PnlTabel: TPanel;
    LblJudulTabel: TLabel;
    GridBarang: TStringGrid;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
    procedure EdCariChange(Sender: TObject);
    procedure CboKategoriChange(Sender: TObject);
    procedure BtnResetCariClick(Sender: TObject);
    procedure GridBarangClick(Sender: TObject);
    procedure GridBarangDblClick(Sender: TObject);
    procedure GridBarangSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
    procedure GridBarangSetEditText(Sender: TObject; ACol, ARow: Longint; const Value: string);
    procedure GridBarangDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
    procedure EdtJumlahMasukChange(Sender: TObject);
    procedure EdtJumlahMasukKeyPress(Sender: TObject; var Key: Char);
    procedure BtnKurang1Click(Sender: TObject);
    procedure BtnTambah1Click(Sender: TObject);
    procedure BtnPlus5Click(Sender: TObject);
    procedure BtnPlus10Click(Sender: TObject);
    procedure BtnPlus50Click(Sender: TObject);
    procedure BtnPlus100Click(Sender: TObject);
    procedure BtnResetBarangClick(Sender: TObject);
    procedure BtnResetSemuaClick(Sender: TObject);
    procedure BtnSimpanClick(Sender: TObject);
  private
    FJumlahMasukList: TStringList; // Menyimpan JumlahMasuk per KodeRekening (agar filter tidak menghilangkan data)
    FUpdatingUI: Boolean;
    procedure LoadKategoriCombo;
    procedure MuatSemuaBarang;
    procedure UpdateBarangTerpilih;
    procedure UpdateTotalRingkasan;
    procedure TerapkanJumlahKeGrid(const AKode: string; AJumlah: Integer);
  public
  end;

var
  Form2: TForm2;

implementation

uses UnitDB;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Penerimaan Barang Masuk (Inbound dari Pusat) - DLH Banjarmasin';
  Self.WindowState := wsMaximized;

  FJumlahMasukList := TStringList.Create;
  FUpdatingUI := False;

  GridBarang.ColCount := 7;
  GridBarang.Cells[0, 0] := 'No';
  GridBarang.Cells[1, 0] := 'Kode Rekening';
  GridBarang.Cells[2, 0] := 'Nama Barang / Persediaan';
  GridBarang.Cells[3, 0] := 'Kategori';
  GridBarang.Cells[4, 0] := 'Satuan';
  GridBarang.Cells[5, 0] := 'Stok Sisa';
  GridBarang.Cells[6, 0] := 'Jumlah Masuk';
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  FJumlahMasukList.Clear;
  LoadKategoriCombo;
  EdCari.Clear;
  EdtNoDokumen.Clear;
  EdtAsalBarang.Clear;
  MuatSemuaBarang;
end;

procedure TForm2.FormResize(Sender: TObject);
var
  SisaLebar: Integer;
begin
  SisaLebar := GridBarang.ClientWidth - 40 - 140 - 110 - 80 - 80 - 110 - 20;
  if SisaLebar > 150 then
  begin
    GridBarang.ColWidths[0] := 40;
    GridBarang.ColWidths[1] := 140;
    GridBarang.ColWidths[2] := SisaLebar;
    GridBarang.ColWidths[3] := 110;
    GridBarang.ColWidths[4] := 80;
    GridBarang.ColWidths[5] := 80;
    GridBarang.ColWidths[6] := 110;
  end;
end;

procedure TForm2.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TForm2.LoadKategoriCombo;
var
  Q: TFDQuery;
  Curr: string;
begin
  Curr := CboKategori.Text;
  CboKategori.Items.BeginUpdate;
  try
    CboKategori.Items.Clear;
    CboKategori.Items.Add('Semua Kategori');

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := ModulDB.Koneksi;
      Q.SQL.Text := 'SELECT DISTINCT Kategori FROM Tabel_Barang WHERE Kategori IS NOT NULL AND Kategori <> '''' ORDER BY Kategori ASC';
      Q.Open;
      while not Q.Eof do
      begin
        CboKategori.Items.Add(Q.Fields[0].AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    CboKategori.Items.EndUpdate;
  end;

  if (Curr <> '') and (CboKategori.Items.IndexOf(Curr) >= 0) then
    CboKategori.ItemIndex := CboKategori.Items.IndexOf(Curr)
  else
    CboKategori.ItemIndex := 0;
end;

procedure TForm2.MuatSemuaBarang;
var
  Q: TFDQuery;
  Baris: Integer;
  SearchKey, SelKat, Kat, KodeRek, NamaBrg: string;
  StokSisa, JmlMasuk: Integer;
  WhereClause: string;
begin
  FUpdatingUI := True;
  try
    GridBarang.RowCount := 2;
    GridBarang.Rows[1].Clear;
    Baris := 1;

    SearchKey := LowerCase(Trim(EdCari.Text));
    SelKat := Trim(CboKategori.Text);

    WhereClause := 'WHERE 1=1 ';
    if (SelKat <> '') and (SelKat <> 'Semua Kategori') then
      WhereClause := WhereClause + 'AND Kategori = :kat ';

    Q := TFDQuery.Create(nil);
    try
      Q.Connection := ModulDB.Koneksi;
      Q.SQL.Text := 'SELECT Kode_Rekening, Nama_Barang, Kategori, Satuan, Stok_Sisa FROM Tabel_Barang ' +
                    WhereClause + 'ORDER BY Nama_Barang ASC';

      if (SelKat <> '') and (SelKat <> 'Semua Kategori') then
        Q.ParamByName('kat').AsString := SelKat;

      Q.Open;

      while not Q.Eof do
      begin
        KodeRek := Q.FieldByName('Kode_Rekening').AsString;
        NamaBrg := Q.FieldByName('Nama_Barang').AsString;
        Kat := Q.FieldByName('Kategori').AsString;
        StokSisa := Q.FieldByName('Stok_Sisa').AsInteger;

        if (SearchKey = '') or
           (Pos(SearchKey, LowerCase(KodeRek)) > 0) or
           (Pos(SearchKey, LowerCase(NamaBrg)) > 0) then
        begin
          if Baris >= GridBarang.RowCount then
            GridBarang.RowCount := Baris + 1;

          JmlMasuk := StrToIntDef(FJumlahMasukList.Values[KodeRek], 0);

          GridBarang.Cells[0, Baris] := IntToStr(Baris);
          GridBarang.Cells[1, Baris] := KodeRek;
          GridBarang.Cells[2, Baris] := NamaBrg;
          GridBarang.Cells[3, Baris] := Kat;
          GridBarang.Cells[4, Baris] := Q.FieldByName('Satuan').AsString;
          GridBarang.Cells[5, Baris] := IntToStr(StokSisa);
          GridBarang.Cells[6, Baris] := IntToStr(JmlMasuk);

          Inc(Baris);
        end;
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    FUpdatingUI := False;
  end;

  if Baris > 1 then
  begin
    if GridBarang.Row < 1 then GridBarang.Row := 1;
    UpdateBarangTerpilih;
  end
  else
  begin
    LblNamaBarangPilih.Caption := '(Tidak ada barang yang cocok)';
    LblKodeRekPilih.Caption := 'Kode: -';
    LblStokSaatIni.Caption := 'Stok Gudang: -';
    EdtJumlahMasuk.Text := '0';
  end;

  UpdateTotalRingkasan;
end;

procedure TForm2.UpdateBarangTerpilih;
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    LblNamaBarangPilih.Caption := GridBarang.Cells[2, RowIdx];
    LblKodeRekPilih.Caption := 'Kode: ' + KodeRek + ' (' + GridBarang.Cells[3, RowIdx] + ')';
    LblStokSaatIni.Caption := 'Stok Saat Ini: ' + GridBarang.Cells[5, RowIdx] + ' ' + GridBarang.Cells[4, RowIdx];

    Jml := StrToIntDef(FJumlahMasukList.Values[KodeRek], 0);
    FUpdatingUI := True;
    try
      EdtJumlahMasuk.Text := IntToStr(Jml);
    finally
      FUpdatingUI := False;
    end;
  end;
end;

procedure TForm2.UpdateTotalRingkasan;
var
  I, Val, TotalJenis, TotalUnit: Integer;
begin
  TotalJenis := 0;
  TotalUnit := 0;

  for I := 0 to FJumlahMasukList.Count - 1 do
  begin
    Val := StrToIntDef(FJumlahMasukList.ValueFromIndex[I], 0);
    if Val > 0 then
    begin
      Inc(TotalJenis);
      TotalUnit := TotalUnit + Val;
    end;
  end;

  LblRingkasanMasuk.Caption := 'Total Barang Masuk yang Diisi: ' + IntToStr(TotalJenis) +
                               ' Jenis Barang (Total: ' + FormatFloat('#,##0', TotalUnit) + ' Unit Fisik)';
  if TotalJenis > 0 then
    LblRingkasanMasuk.Font.Color := RGB(25, 135, 84) // Hijau Sukses
  else
    LblRingkasanMasuk.Font.Color := RGB(108, 117, 125); // Abu-abu
end;

procedure TForm2.TerapkanJumlahKeGrid(const AKode: string; AJumlah: Integer);
var
  I: Integer;
begin
  if AJumlah < 0 then AJumlah := 0;

  FJumlahMasukList.Values[AKode] := IntToStr(AJumlah);

  for I := 1 to GridBarang.RowCount - 1 do
  begin
    if GridBarang.Cells[1, I] = AKode then
    begin
      GridBarang.Cells[6, I] := IntToStr(AJumlah);
      Break;
    end;
  end;

  UpdateTotalRingkasan;
end;

procedure TForm2.GridBarangClick(Sender: TObject);
begin
  UpdateBarangTerpilih;
end;

procedure TForm2.GridBarangDblClick(Sender: TObject);
begin
  EdtJumlahMasuk.SetFocus;
  EdtJumlahMasuk.SelectAll;
end;

procedure TForm2.GridBarangSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
begin
  CanSelect := True;
  // Memungkinkan editing jika user klik kolom Jumlah Masuk (Col 6)
  if ACol = 6 then
    GridBarang.Options := GridBarang.Options + [goEditing]
  else
    GridBarang.Options := GridBarang.Options - [goEditing];
end;

procedure TForm2.GridBarangSetEditText(Sender: TObject; ACol, ARow: Longint; const Value: string);
var
  Jml: Integer;
  KodeRek: string;
begin
  if (ACol = 6) and (ARow >= 1) and (ARow < GridBarang.RowCount) and not FUpdatingUI then
  begin
    KodeRek := GridBarang.Cells[1, ARow];
    if KodeRek <> '' then
    begin
      Jml := StrToIntDef(Trim(Value), 0);
      if Jml < 0 then Jml := 0;
      FJumlahMasukList.Values[KodeRek] := IntToStr(Jml);

      if GridBarang.Row = ARow then
      begin
        FUpdatingUI := True;
        try
          EdtJumlahMasuk.Text := IntToStr(Jml);
        finally
          FUpdatingUI := False;
        end;
      end;
      UpdateTotalRingkasan;
    end;
  end;
end;

procedure TForm2.GridBarangDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
var
  ValStr: string;
  ValInt: Integer;
  TxtStyle: Cardinal;
begin
  if (ARow > 0) and (ACol = 6) then
  begin
    ValStr := GridBarang.Cells[ACol, ARow];
    ValInt := StrToIntDef(ValStr, 0);

    if ValInt > 0 then
    begin
      // Sorot baris yang diisi dengan latar hijau lembut dan teks tebal
      if not (gdSelected in State) then
      begin
        GridBarang.Canvas.Brush.Color := RGB(220, 245, 230);
        GridBarang.Canvas.FillRect(Rect);
      end;
      GridBarang.Canvas.Font.Style := [fsBold];
      GridBarang.Canvas.Font.Color := RGB(15, 115, 60);
    end;

    TxtStyle := DT_RIGHT or DT_VCENTER or DT_SINGLELINE;
    InflateRect(Rect, -6, 0);
    DrawText(GridBarang.Canvas.Handle, PChar(ValStr), -1, Rect, TxtStyle);
  end;
end;

procedure TForm2.EdtJumlahMasukChange(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  if FUpdatingUI then Exit;

  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(Trim(EdtJumlahMasuk.Text), 0);
    TerapkanJumlahKeGrid(KodeRek, Jml);
  end;
end;

procedure TForm2.EdtJumlahMasukKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TForm2.BtnKurang1Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahMasukList.Values[KodeRek], 0);
    if Jml > 0 then Dec(Jml);
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm2.BtnTambah1Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahMasukList.Values[KodeRek], 0);
    Inc(Jml);
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm2.BtnPlus5Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahMasukList.Values[KodeRek], 0) + 5;
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm2.BtnPlus10Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahMasukList.Values[KodeRek], 0) + 10;
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm2.BtnPlus50Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahMasukList.Values[KodeRek], 0) + 50;
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm2.BtnPlus100Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahMasukList.Values[KodeRek], 0) + 100;
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm2.BtnResetBarangClick(Sender: TObject);
var
  RowIdx: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    TerapkanJumlahKeGrid(KodeRek, 0);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm2.BtnResetSemuaClick(Sender: TObject);
var
  I: Integer;
begin
  if FJumlahMasukList.Count = 0 then Exit;

  if MessageDlg('Apakah Anda yakin ingin mereset seluruh jumlah barang masuk menjadi 0 kembali?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FJumlahMasukList.Clear;
    for I := 1 to GridBarang.RowCount - 1 do
      GridBarang.Cells[6, I] := '0';
    UpdateBarangTerpilih;
    UpdateTotalRingkasan;
  end;
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

procedure TForm2.BtnSimpanClick(Sender: TObject);
var
  I, Jml, TotalJenis, TotalUnit, StokLama, StokBaru, ItemNo: Integer;
  KodeRek, NamaBrg, Satuan, PesanKonfirmasi, TglNow: string;
  NoPenerimaan, NoDokumen, AsalBarang, OutDir, OutPath, LogoB64, TglFormat: string;
  Q, QItem: TFDQuery;
  BastText: TStringList;
begin
  // 1. Validasi: Hitung apakah ada barang yang diisi > 0
  TotalJenis := 0;
  TotalUnit := 0;
  NoDokumen := Trim(EdtNoDokumen.Text);
  if NoDokumen = '' then NoDokumen := '-';
  AsalBarang := Trim(EdtAsalBarang.Text);
  if AsalBarang = '' then AsalBarang := 'Pusat / Pengadaan';

  PesanKonfirmasi := '===================================================' + sLineBreak +
                     'VALIDASI RINCIAN BARANG MASUK (MOHON DIPERIKSA):' + sLineBreak +
                     'No. Dokumen/BAST : ' + NoDokumen + sLineBreak +
                     'Asal Rekanan    : ' + AsalBarang + sLineBreak +
                     '===================================================' + sLineBreak + sLineBreak;

  QItem := TFDQuery.Create(nil);
  try
    QItem.Connection := ModulDB.Koneksi;

    for I := 0 to FJumlahMasukList.Count - 1 do
    begin
      Jml := StrToIntDef(FJumlahMasukList.ValueFromIndex[I], 0);
      if Jml > 0 then
      begin
        KodeRek := FJumlahMasukList.Names[I];

        QItem.SQL.Text := 'SELECT Nama_Barang, Satuan, Stok_Sisa FROM Tabel_Barang WHERE Kode_Rekening = :k';
        QItem.ParamByName('k').AsString := KodeRek;
        QItem.Open;

        if not QItem.Eof then
        begin
          NamaBrg := QItem.FieldByName('Nama_Barang').AsString;
          Satuan := QItem.FieldByName('Satuan').AsString;
          StokLama := QItem.FieldByName('Stok_Sisa').AsInteger;
          StokBaru := StokLama + Jml;

          Inc(TotalJenis);
          TotalUnit := TotalUnit + Jml;

          PesanKonfirmasi := PesanKonfirmasi + IntToStr(TotalJenis) + '. ' + NamaBrg + sLineBreak +
                             '    Jumlah Masuk : ' + IntToStr(Jml) + ' ' + Satuan +
                             ' (Stok Lama: ' + IntToStr(StokLama) + ' -> Stok Baru: ' + IntToStr(StokBaru) + ')' + sLineBreak + sLineBreak;
        end;
        QItem.Close;
      end;
    end;
  finally
    QItem.Free;
  end;

  if TotalJenis = 0 then
  begin
    ShowMessage('VALIDASI GAGAL: Belum ada barang yang diisi jumlah masuknya (> 0)!' + sLineBreak +
                'Silakan isi jumlah masuk pada barang yang diterima dari Pusat terlebih dahulu.');
    Exit;
  end;

  PesanKonfirmasi := PesanKonfirmasi + '===================================================' + sLineBreak +
                     'TOTAL ITEM MASUK : ' + IntToStr(TotalJenis) + ' Jenis Barang' + sLineBreak +
                     'TOTAL FISIK UNIT : ' + FormatFloat('#,##0', TotalUnit) + ' Unit Fisik' + sLineBreak +
                     '===================================================' + sLineBreak + sLineBreak +
                     'Apakah rincian barang masuk di atas SUDAH BENAR dan ingin dimasukkan ke Stok Fisik Gudang sekarang?';

  // 2. Dialog Validasi & Konfirmasi Pra-Simpan Sesuai Permintaan User
  if MessageDlg(PesanKonfirmasi, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  // 3. Simpan ke Database
  TglNow := FormatDateTime('yyyy-mm-dd', Now);
  NoPenerimaan := 'MSK-' + FormatDateTime('yyyymmdd-hhnnss', Now);

  ModulDB.Koneksi.StartTransaction;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;

    for I := 0 to FJumlahMasukList.Count - 1 do
    begin
      Jml := StrToIntDef(FJumlahMasukList.ValueFromIndex[I], 0);
      if Jml > 0 then
      begin
        KodeRek := FJumlahMasukList.Names[I];

        // Insert ke Tabel_Masuk dengan No_Penerimaan, No_Dokumen, dan Asal_Barang
        Q.SQL.Text := 'INSERT INTO Tabel_Masuk (Tanggal, Kode_Rekening, Jumlah, No_Penerimaan, No_Dokumen, Asal_Barang) ' +
                      'VALUES (:tgl, :kode, :jml, :no_msk, :no_dok, :asal)';
        Q.ParamByName('tgl').AsString := TglNow;
        Q.ParamByName('kode').AsString := KodeRek;
        Q.ParamByName('jml').AsInteger := Jml;
        Q.ParamByName('no_msk').AsString := NoPenerimaan;
        Q.ParamByName('no_dok').AsString := NoDokumen;
        Q.ParamByName('asal').AsString := AsalBarang;
        Q.ExecSQL;

        // Update Tambah Stok di Tabel_Barang (Kolom Stok_Sisa)
        Q.SQL.Text := 'UPDATE Tabel_Barang SET Stok_Sisa = Stok_Sisa + :jml WHERE Kode_Rekening = :kode';
        Q.ParamByName('jml').AsInteger := Jml;
        Q.ParamByName('kode').AsString := KodeRek;
        Q.ExecSQL;
      end;
    end;

    ModulDB.Koneksi.Commit;

    // 4. Tanya Cetak BAST Inbound
    if MessageDlg('PENYIMPANAN BERHASIL!' + sLineBreak + sLineBreak +
                  'No. Penerimaan : ' + NoPenerimaan + sLineBreak +
                  'No. Dokumen/BAST: ' + NoDokumen + sLineBreak +
                  'Asal Rekanan   : ' + AsalBarang + sLineBreak +
                  IntToStr(TotalJenis) + ' jenis barang masuk (' + FormatFloat('#,##0', TotalUnit) +
                  ' unit) telah resmi ditambahkan ke Stok Gudang DLH.' + sLineBreak + sLineBreak +
                  'Apakah Anda ingin mencetak Berita Acara Penerimaan Barang Masuk (BAST Inbound)?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      OutDir := ExtractFilePath(ParamStr(0)) + 'arsip_surat';
      if not DirectoryExists(OutDir) then
        ForceDirectories(OutDir);

      OutPath := OutDir + '\BAST_Penerimaan_' + NoPenerimaan + '.html';
      LogoB64 := GetLogoBase64;
      TglFormat := FormatDateTime('dd mmmm yyyy', Now);

      BastText := TStringList.Create;
      try
        BastText.Add('<!DOCTYPE html>');
        BastText.Add('<html><head><meta charset="utf-8">');
        BastText.Add('<title>BERITA ACARA PENERIMAAN BARANG MASUK GUDANG</title>');
        BastText.Add('<style>');
        BastText.Add('  @page { size: A4 portrait; margin: 1.5cm; }');
        BastText.Add('  body { font-family: Arial, sans-serif; color: #000; background: #fff; margin: 0; padding: 25px; }');
        BastText.Add('  .kop-table { width: 100%; border-collapse: collapse; border-bottom: 3.5px solid #000; padding-bottom: 8px; margin-bottom: 12px; }');
        BastText.Add('  .kop-logo { width: 2.31cm; height: 3.3cm; object-fit: contain; }');
        BastText.Add('  .kop-text-container { text-align: center; vertical-align: middle; }');
        BastText.Add('  .kop-h1 { font-family: Arial, sans-serif; font-size: 18pt; font-weight: bold; margin: 0; line-height: 1.2; text-transform: uppercase; }');
        BastText.Add('  .kop-sub { font-family: Arial, sans-serif; font-size: 12pt; font-weight: normal; margin: 3px 0 0 0; line-height: 1.3; }');
        BastText.Add('  .kop-city { font-family: Arial, sans-serif; font-size: 12pt; font-weight: bold; margin: 3px 0 0 0; }');
        BastText.Add('  .date-right { text-align: right; font-family: Arial, sans-serif; font-size: 11pt; margin-top: 10px; margin-bottom: 20px; }');
        BastText.Add('  .doc-title { text-align: center; font-family: Arial, sans-serif; font-size: 14pt; font-weight: bold; text-decoration: underline; margin-bottom: 25px; text-transform: uppercase; }');
        BastText.Add('  .meta-table { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 11pt; }');
        BastText.Add('  .meta-table td { padding: 5px 0; vertical-align: top; }');
        BastText.Add('  .meta-label { width: 190px; font-weight: bold; }');
        BastText.Add('  .item-table { width: 100%; border-collapse: collapse; margin-bottom: 25px; font-size: 11pt; }');
        BastText.Add('  .item-table th, .item-table td { border: 1px solid #000; padding: 8px 10px; text-align: left; }');
        BastText.Add('  .item-table th { background-color: #f2f2f2; font-weight: bold; text-align: center; }');
        BastText.Add('  .item-table td.center { text-align: center; }');
        BastText.Add('  .notes { font-size: 10.5pt; margin-bottom: 35px; line-height: 1.5; }');
        BastText.Add('  .sig-table { width: 100%; border-collapse: collapse; margin-top: 30px; font-size: 11pt; }');
        BastText.Add('  .sig-table td { width: 50%; text-align: center; vertical-align: top; }');
        BastText.Add('  .sig-space { height: 85px; }');
        BastText.Add('  .sig-name { font-weight: bold; text-decoration: underline; }');
        BastText.Add('</style>');
        BastText.Add('</head><body>');

        BastText.Add('<table class="kop-table"><tr>');
        if LogoB64 <> '' then
          BastText.Add('  <td style="width: 2.5cm; vertical-align: middle;"><img class="kop-logo" src="data:image/jpeg;base64,' + LogoB64 + '" alt="Logo Banjarmasin"></td>')
        else
          BastText.Add('  <td style="width: 2.5cm; vertical-align: middle;"><img class="kop-logo" src="logo_banjarmasin.jpg" alt="Logo Banjarmasin"></td>');

        BastText.Add('  <td class="kop-text-container">');
        BastText.Add('    <div class="kop-h1">PEMERINTAH KOTA BANJARMASIN</div>');
        BastText.Add('    <div class="kop-h1">DINAS LINGKUNGAN HIDUP</div>');
        BastText.Add('    <div class="kop-sub">Jalan R.E. Martadinata No.1 Gedung Blok D Banjarmasin 70111</div>');
        BastText.Add('    <div class="kop-sub">Telp. (0511) 3363811, Fax. 3363811</div>');
        BastText.Add('    <div class="kop-city">BANJARMASIN</div>');
        BastText.Add('  </td></tr></table>');

        BastText.Add('<div class="date-right">Banjarmasin, ' + TglFormat + '</div>');
        BastText.Add('<div class="doc-title">BERITA ACARA PENERIMAAN BARANG MASUK GUDANG (BAST)</div>');

        BastText.Add('<table class="meta-table">');
        BastText.Add('  <tr><td class="meta-label">No. Penerimaan</td><td>: ' + NoPenerimaan + '</td></tr>');
        BastText.Add('  <tr><td class="meta-label">No. Surat Jalan / BAST</td><td>: ' + NoDokumen + '</td></tr>');
        BastText.Add('  <tr><td class="meta-label">Asal Rekanan / Pengadaan</td><td>: ' + AsalBarang + '</td></tr>');
        BastText.Add('  <tr><td class="meta-label">Tanggal Penerimaan</td><td>: ' + TglNow + '</td></tr>');
        BastText.Add('</table>');

        BastText.Add('<table class="item-table"><thead><tr>');
        BastText.Add('  <th style="width: 40px;">No</th><th style="width: 180px;">Kode Rekening</th><th>Nama Barang / Persediaan</th><th style="width: 130px;">Jumlah Masuk</th>');
        BastText.Add('</tr></thead><tbody>');

        ItemNo := 0;
        QItem := TFDQuery.Create(nil);
        try
          QItem.Connection := ModulDB.Koneksi;
          for I := 0 to FJumlahMasukList.Count - 1 do
          begin
            Jml := StrToIntDef(FJumlahMasukList.ValueFromIndex[I], 0);
            if Jml > 0 then
            begin
              Inc(ItemNo);
              KodeRek := FJumlahMasukList.Names[I];
              QItem.SQL.Text := 'SELECT Nama_Barang, Satuan FROM Tabel_Barang WHERE Kode_Rekening = :k';
              QItem.ParamByName('k').AsString := KodeRek;
              QItem.Open;
              if not QItem.Eof then
              begin
                NamaBrg := QItem.FieldByName('Nama_Barang').AsString;
                Satuan := QItem.FieldByName('Satuan').AsString;
              end
              else
              begin
                NamaBrg := KodeRek;
                Satuan := 'Unit';
              end;
              QItem.Close;

              BastText.Add('  <tr>');
              BastText.Add('    <td class="center">' + IntToStr(ItemNo) + '</td>');
              BastText.Add('    <td>' + KodeRek + '</td>');
              BastText.Add('    <td>' + NamaBrg + '</td>');
              BastText.Add('    <td class="center">' + IntToStr(Jml) + ' ' + Satuan + '</td>');
              BastText.Add('  </tr>');
            end;
          end;
        finally
          QItem.Free;
        end;

        BastText.Add('</tbody></table>');

        BastText.Add('<div class="notes">');
        BastText.Add('  <b>Catatan:</b> Barang-barang di atas telah diperiksa kondisi fisik, spesifikasi, dan kuantitasnya, serta telah dicatat secara resmi ke dalam Buku Persediaan Gudang DLH Kota Banjarmasin.');
        BastText.Add('</div>');

        BastText.Add('<table class="sig-table"><tr>');
        BastText.Add('  <td>Pihak yang Menyerahkan (Rekanan/Pengirim)<br><b>' + AsalBarang + '</b><div class="sig-space"></div><div class="sig-name">( .................................................... )</div></td>');
        BastText.Add('  <td>Pihak yang Menerima (Petugas Gudang)<br><b>Dinas Lingkungan Hidup</b><div class="sig-space"></div><div class="sig-name">( .................................................... )</div></td>');
        BastText.Add('</tr></table>');

        BastText.Add('</body></html>');

        BastText.SaveToFile(OutPath, TEncoding.UTF8);
        ShellExecute(0, 'open', PChar(OutPath), nil, nil, SW_SHOWNORMAL);
      finally
        BastText.Free;
      end;
    end;

    FJumlahMasukList.Clear;
    Self.Close;
  except
    on E: Exception do
    begin
      ModulDB.Koneksi.Rollback;
      ShowMessage('Gagal menyimpan data barang masuk: ' + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TForm2.EdCariChange(Sender: TObject);
begin
  MuatSemuaBarang;
end;

procedure TForm2.CboKategoriChange(Sender: TObject);
begin
  MuatSemuaBarang;
end;

procedure TForm2.BtnResetCariClick(Sender: TObject);
begin
  EdCari.Clear;
  CboKategori.ItemIndex := 0;
  MuatSemuaBarang;
end;

end.
