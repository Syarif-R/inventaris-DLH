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
    PnlFilter: TPanel;
    LblBidang: TLabel;
    CboBidang: TComboBox;
    LblCari: TLabel;
    EdCari: TEdit;
    LblKategori: TLabel;
    CboKategori: TComboBox;
    BtnResetCari: TButton;
    LblPetunjukCepat: TLabel;
    PnlBawah: TPanel;
    LblRingkasanPengajuan: TLabel;
    BtnResetSemua: TButton;
    BtnSimpanCetak: TButton;
    PnlTengah: TPanel;
    PnlKontelKanan: TPanel;
    LblPanelKananJudul: TLabel;
    PnlCardBarang: TPanel;
    LblNamaBarangPilih: TLabel;
    LblKodeRekPilih: TLabel;
    LblStokSaatIni: TLabel;
    LblInputManual: TLabel;
    PnlInputBaris: TPanel;
    BtnKurang1: TButton;
    EdtJumlahDiajukan: TEdit;
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
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
    procedure CboBidangChange(Sender: TObject);
    procedure EdCariChange(Sender: TObject);
    procedure CboKategoriChange(Sender: TObject);
    procedure BtnResetCariClick(Sender: TObject);
    procedure GridBarangClick(Sender: TObject);
    procedure GridBarangDblClick(Sender: TObject);
    procedure GridBarangSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
    procedure GridBarangSetEditText(Sender: TObject; ACol, ARow: Longint; const Value: string);
    procedure GridBarangDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
    procedure EdtJumlahDiajukanChange(Sender: TObject);
    procedure EdtJumlahDiajukanKeyPress(Sender: TObject; var Key: Char);
    procedure BtnKurang1Click(Sender: TObject);
    procedure BtnTambah1Click(Sender: TObject);
    procedure BtnPlus5Click(Sender: TObject);
    procedure BtnPlus10Click(Sender: TObject);
    procedure BtnPlus50Click(Sender: TObject);
    procedure BtnPlus100Click(Sender: TObject);
    procedure BtnResetBarangClick(Sender: TObject);
    procedure BtnResetSemuaClick(Sender: TObject);
    procedure BtnSimpanCetakClick(Sender: TObject);
  private
    FJumlahDiajukanList: TStringList;
    FUpdatingUI: Boolean;
    procedure LoadBidangCombo;
    procedure LoadKategoriCombo;
    procedure MuatSemuaBarang;
    procedure UpdateBarangTerpilih;
    procedure UpdateTotalRingkasan;
    procedure TerapkanJumlahKeGrid(const AKode: string; AJumlah: Integer);
    function GetStokBarang(const AKode: string; var ASatuan, ANama: string): Integer;
  public
  end;

var
  Form3: TForm3;

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

procedure TForm3.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Pengajuan & Permintaan Barang (Outbound Bidang) - DLH Banjarmasin';
  Self.WindowState := wsMaximized;

  FJumlahDiajukanList := TStringList.Create;
  FUpdatingUI := False;

  GridBarang.ColCount := 7;
  GridBarang.Cells[0, 0] := 'No';
  GridBarang.Cells[1, 0] := 'Kode Rekening';
  GridBarang.Cells[2, 0] := 'Nama Barang / Persediaan';
  GridBarang.Cells[3, 0] := 'Kategori';
  GridBarang.Cells[4, 0] := 'Satuan';
  GridBarang.Cells[5, 0] := 'Stok Sisa';
  GridBarang.Cells[6, 0] := 'Jumlah Diajukan';
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  FJumlahDiajukanList.Clear;
  LoadBidangCombo;
  LoadKategoriCombo;
  EdCari.Clear;
  MuatSemuaBarang;
end;

procedure TForm3.FormResize(Sender: TObject);
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

procedure TForm3.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
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
    CboBidang.ItemIndex := -1;
end;

procedure TForm3.CboBidangChange(Sender: TObject);
var
  BidangBaru: string;
  Idx: Integer;
begin
  if (CboBidang.Items.Count > 0) and (CboBidang.ItemIndex = CboBidang.Items.Count - 1) then
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

procedure TForm3.LoadKategoriCombo;
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

procedure TForm3.MuatSemuaBarang;
var
  Q: TFDQuery;
  Baris: Integer;
  SearchKey, SelKat, Kat, KodeRek, NamaBrg: string;
  StokSisa, JmlDiajukan: Integer;
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

          JmlDiajukan := StrToIntDef(FJumlahDiajukanList.Values[KodeRek], 0);

          GridBarang.Cells[0, Baris] := IntToStr(Baris);
          GridBarang.Cells[1, Baris] := KodeRek;
          GridBarang.Cells[2, Baris] := NamaBrg;
          GridBarang.Cells[3, Baris] := Kat;
          GridBarang.Cells[4, Baris] := Q.FieldByName('Satuan').AsString;
          GridBarang.Cells[5, Baris] := IntToStr(StokSisa);
          GridBarang.Cells[6, Baris] := IntToStr(JmlDiajukan);

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
    LblStokSaatIni.Caption := 'Sisa Stok: -';
    EdtJumlahDiajukan.Text := '0';
  end;

  UpdateTotalRingkasan;
end;

function TForm3.GetStokBarang(const AKode: string; var ASatuan, ANama: string): Integer;
var
  Q: TFDQuery;
begin
  Result := 0;
  ASatuan := '';
  ANama := '';
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT Nama_Barang, Satuan, Stok_Sisa FROM Tabel_Barang WHERE Kode_Rekening = :k';
    Q.ParamByName('k').AsString := AKode;
    Q.Open;
    if not Q.Eof then
    begin
      ANama := Q.FieldByName('Nama_Barang').AsString;
      ASatuan := Q.FieldByName('Satuan').AsString;
      Result := Q.FieldByName('Stok_Sisa').AsInteger;
    end;
  finally
    Q.Free;
  end;
end;

procedure TForm3.UpdateBarangTerpilih;
var
  RowIdx, Jml, StokSisa: Integer;
  KodeRek, Satuan, NamaBrg: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    NamaBrg := GridBarang.Cells[2, RowIdx];
    Satuan := GridBarang.Cells[4, RowIdx];
    StokSisa := StrToIntDef(GridBarang.Cells[5, RowIdx], 0);

    LblNamaBarangPilih.Caption := NamaBrg;
    LblKodeRekPilih.Caption := 'Kode: ' + KodeRek + ' (' + GridBarang.Cells[3, RowIdx] + ')';

    if StokSisa > 0 then
    begin
      LblStokSaatIni.Font.Color := RGB(25, 135, 84);
      LblStokSaatIni.Caption := 'Sisa Stok Gudang: ' + IntToStr(StokSisa) + ' ' + Satuan;
    end
    else
    begin
      LblStokSaatIni.Font.Color := RGB(220, 53, 69);
      LblStokSaatIni.Caption := 'STOK GUDANG HABIS (0 ' + Satuan + ')';
    end;

    Jml := StrToIntDef(FJumlahDiajukanList.Values[KodeRek], 0);
    FUpdatingUI := True;
    try
      EdtJumlahDiajukan.Text := IntToStr(Jml);
    finally
      FUpdatingUI := False;
    end;
  end;
end;

procedure TForm3.UpdateTotalRingkasan;
var
  I, Val, TotalJenis, TotalUnit: Integer;
begin
  TotalJenis := 0;
  TotalUnit := 0;

  for I := 0 to FJumlahDiajukanList.Count - 1 do
  begin
    Val := StrToIntDef(FJumlahDiajukanList.ValueFromIndex[I], 0);
    if Val > 0 then
    begin
      Inc(TotalJenis);
      TotalUnit := TotalUnit + Val;
    end;
  end;

  LblRingkasanPengajuan.Caption := 'Total Barang Diajukan: ' + IntToStr(TotalJenis) +
                                   ' Jenis Barang (Total: ' + FormatFloat('#,##0', TotalUnit) + ' Unit Fisik)';
  if TotalJenis > 0 then
    LblRingkasanPengajuan.Font.Color := RGB(25, 135, 84)
  else
    LblRingkasanPengajuan.Font.Color := RGB(108, 117, 125);
end;

procedure TForm3.TerapkanJumlahKeGrid(const AKode: string; AJumlah: Integer);
var
  I, StokSisa: Integer;
  Satuan, NamaBrg: string;
begin
  if AJumlah < 0 then AJumlah := 0;

  StokSisa := GetStokBarang(AKode, Satuan, NamaBrg);

  if (StokSisa <= 0) and (AJumlah > 0) then
  begin
    ShowMessage('STOK KOSONG: Stok barang "' + NamaBrg + '" di gudang saat ini adalah 0 unit.' + sLineBreak +
                'Barang ini tidak dapat diajukan!');
    AJumlah := 0;
  end
  else if AJumlah > StokSisa then
  begin
    ShowMessage('BATAS MAKSIMAL STOK: Jumlah pengajuan barang "' + NamaBrg + '" melebihi stok yang tersedia!' + sLineBreak +
                'Jumlah pengajuan otomatis disesuaikan ke stok maksimal: ' + IntToStr(StokSisa) + ' ' + Satuan + '.');
    AJumlah := StokSisa;
  end;

  FJumlahDiajukanList.Values[AKode] := IntToStr(AJumlah);

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

procedure TForm3.GridBarangClick(Sender: TObject);
begin
  UpdateBarangTerpilih;
end;

procedure TForm3.GridBarangDblClick(Sender: TObject);
begin
  EdtJumlahDiajukan.SetFocus;
  EdtJumlahDiajukan.SelectAll;
end;

procedure TForm3.GridBarangSelectCell(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean);
begin
  CanSelect := True;
  if ACol = 6 then
    GridBarang.Options := GridBarang.Options + [goEditing]
  else
    GridBarang.Options := GridBarang.Options - [goEditing];
end;

procedure TForm3.GridBarangSetEditText(Sender: TObject; ACol, ARow: Longint; const Value: string);
var
  Jml, StokSisa: Integer;
  KodeRek, Satuan, NamaBrg: string;
begin
  if (ACol = 6) and (ARow >= 1) and (ARow < GridBarang.RowCount) and not FUpdatingUI then
  begin
    KodeRek := GridBarang.Cells[1, ARow];
    if KodeRek <> '' then
    begin
      Jml := StrToIntDef(Trim(Value), 0);
      if Jml < 0 then Jml := 0;
      StokSisa := GetStokBarang(KodeRek, Satuan, NamaBrg);

      if (StokSisa <= 0) and (Jml > 0) then
      begin
        ShowMessage('STOK KOSONG: Stok barang "' + NamaBrg + '" di gudang kosong. Tidak dapat diajukan!');
        Jml := 0;
      end
      else if Jml > StokSisa then
      begin
        ShowMessage('BATAS MAKSIMAL STOK: Melebihi sisa stok gudang (' + IntToStr(StokSisa) + ' ' + Satuan + ')! Otomatis disesuaikan.');
        Jml := StokSisa;
      end;

      FJumlahDiajukanList.Values[KodeRek] := IntToStr(Jml);

      if GridBarang.Row = ARow then
      begin
        FUpdatingUI := True;
        try
          EdtJumlahDiajukan.Text := IntToStr(Jml);
        finally
          FUpdatingUI := False;
        end;
      end;
      UpdateTotalRingkasan;
    end;
  end;
end;

procedure TForm3.GridBarangDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
var
  ValStr: string;
  ValInt: Integer;
  TxtStyle: Cardinal;
begin
  if (ARow > 0) and (ACol = 5) then
  begin
    ValStr := GridBarang.Cells[ACol, ARow];
    ValInt := StrToIntDef(ValStr, 0);
    if ValInt = 0 then
    begin
      if not (gdSelected in State) then
      begin
        GridBarang.Canvas.Brush.Color := RGB(254, 237, 237);
        GridBarang.Canvas.FillRect(Rect);
      end;
      GridBarang.Canvas.Font.Style := [fsBold];
      GridBarang.Canvas.Font.Color := RGB(220, 53, 69);
    end;
    TxtStyle := DT_RIGHT or DT_VCENTER or DT_SINGLELINE;
    InflateRect(Rect, -6, 0);
    DrawText(GridBarang.Canvas.Handle, PChar(ValStr), -1, Rect, TxtStyle);
    Exit;
  end;

  if (ARow > 0) and (ACol = 6) then
  begin
    ValStr := GridBarang.Cells[ACol, ARow];
    ValInt := StrToIntDef(ValStr, 0);

    if ValInt > 0 then
    begin
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
    Exit;
  end;
end;

procedure TForm3.EdtJumlahDiajukanChange(Sender: TObject);
var
  RowIdx, Jml, StokSisa: Integer;
  KodeRek, Satuan, NamaBrg: string;
begin
  if FUpdatingUI then Exit;

  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(Trim(EdtJumlahDiajukan.Text), 0);
    StokSisa := GetStokBarang(KodeRek, Satuan, NamaBrg);

    if (StokSisa <= 0) and (Jml > 0) then
    begin
      ShowMessage('STOK KOSONG: Stok barang "' + NamaBrg + '" di gudang kosong. Tidak dapat diajukan!');
      FUpdatingUI := True;
      try
        EdtJumlahDiajukan.Text := '0';
      finally
        FUpdatingUI := False;
      end;
      TerapkanJumlahKeGrid(KodeRek, 0);
      Exit;
    end;

    if Jml > StokSisa then
    begin
      ShowMessage('BATAS MAKSIMAL STOK: Jumlah pengajuan barang "' + NamaBrg + '" melebihi stok yang tersedia (' + IntToStr(StokSisa) + ' ' + Satuan + ')!' + sLineBreak +
                  'Jumlah otomatis disesuaikan ke stok maksimal.');
      Jml := StokSisa;
      FUpdatingUI := True;
      try
        EdtJumlahDiajukan.Text := IntToStr(Jml);
      finally
        FUpdatingUI := False;
      end;
    end;

    TerapkanJumlahKeGrid(KodeRek, Jml);
  end;
end;

procedure TForm3.EdtJumlahDiajukanKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TForm3.BtnKurang1Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahDiajukanList.Values[KodeRek], 0);
    if Jml > 0 then Dec(Jml);
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm3.BtnTambah1Click(Sender: TObject);
var
  RowIdx, Jml, StokSisa: Integer;
  KodeRek, Satuan, NamaBrg: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    StokSisa := GetStokBarang(KodeRek, Satuan, NamaBrg);

    if StokSisa <= 0 then
    begin
      ShowMessage('STOK KOSONG: Stok barang "' + NamaBrg + '" di gudang kosong (0 ' + Satuan + '). Tidak dapat diajukan!');
      Exit;
    end;

    Jml := StrToIntDef(FJumlahDiajukanList.Values[KodeRek], 0);
    if Jml >= StokSisa then
    begin
      ShowMessage('BATAS MAKSIMAL: Jumlah pengajuan sudah mencapai seluruh sisa stok gudang (' + IntToStr(StokSisa) + ' ' + Satuan + ')!');
      Exit;
    end;

    Inc(Jml);
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm3.BtnPlus5Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahDiajukanList.Values[KodeRek], 0) + 5;
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm3.BtnPlus10Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahDiajukanList.Values[KodeRek], 0) + 10;
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm3.BtnPlus50Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahDiajukanList.Values[KodeRek], 0) + 50;
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm3.BtnPlus100Click(Sender: TObject);
var
  RowIdx, Jml: Integer;
  KodeRek: string;
begin
  RowIdx := GridBarang.Row;
  if (RowIdx >= 1) and (RowIdx < GridBarang.RowCount) and (GridBarang.Cells[1, RowIdx] <> '') then
  begin
    KodeRek := GridBarang.Cells[1, RowIdx];
    Jml := StrToIntDef(FJumlahDiajukanList.Values[KodeRek], 0) + 100;
    TerapkanJumlahKeGrid(KodeRek, Jml);
    UpdateBarangTerpilih;
  end;
end;

procedure TForm3.BtnResetBarangClick(Sender: TObject);
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

procedure TForm3.BtnResetSemuaClick(Sender: TObject);
var
  I: Integer;
begin
  if MessageDlg('Apakah Anda yakin ingin mereset semua jumlah pengajuan barang menjadi 0?',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FJumlahDiajukanList.Clear;
    for I := 1 to GridBarang.RowCount - 1 do
      GridBarang.Cells[6, I] := '0';
    UpdateBarangTerpilih;
    UpdateTotalRingkasan;
  end;
end;

procedure TForm3.BtnSimpanCetakClick(Sender: TObject);
var
  I, Jml, TotalJenis, TotalUnit, StokSisaDb, ItemNo: Integer;
  KodeRek, NamaBrg, Satuan, TglNow, TglFormat, NoPengajuan, LogoB64, ExtFile, PesanKonfirmasi: string;
  Q, QItem: TFDQuery;
  SuratText: TStringList;
begin
  if (CboBidang.ItemIndex < 0) or (Trim(CboBidang.Text) = '') then
  begin
    ShowMessage('VALIDASI GAGAL: Silakan pilih Bidang Pemohon terlebih dahulu!');
    CboBidang.SetFocus;
    Exit;
  end;

  TotalJenis := 0;
  TotalUnit := 0;
  PesanKonfirmasi := '===================================================' + sLineBreak +
                     'RINCIAN PENGAJUAN BARANG BIDANG' + sLineBreak +
                     'Bidang Pemohon: ' + CboBidang.Text + sLineBreak +
                     '===================================================' + sLineBreak + sLineBreak;

  QItem := TFDQuery.Create(nil);
  try
    QItem.Connection := ModulDB.Koneksi;

    for I := 0 to FJumlahDiajukanList.Count - 1 do
    begin
      Jml := StrToIntDef(FJumlahDiajukanList.ValueFromIndex[I], 0);
      if Jml > 0 then
      begin
        KodeRek := FJumlahDiajukanList.Names[I];

        QItem.SQL.Text := 'SELECT Nama_Barang, Satuan, Stok_Sisa FROM Tabel_Barang WHERE Kode_Rekening = :k';
        QItem.ParamByName('k').AsString := KodeRek;
        QItem.Open;

        if not QItem.Eof then
        begin
          NamaBrg := QItem.FieldByName('Nama_Barang').AsString;
          Satuan := QItem.FieldByName('Satuan').AsString;
          StokSisaDb := QItem.FieldByName('Stok_Sisa').AsInteger;

          if Jml > StokSisaDb then
          begin
            ShowMessage('STOK TIDAK MENCUKUPI: Pengajuan barang "' + NamaBrg + '" sejumlah ' +
                        IntToStr(Jml) + ' ' + Satuan + ' melebihi sisa stok gudang (' +
                        IntToStr(StokSisaDb) + ' ' + Satuan + ')!' + sLineBreak +
                        'Silakan sesuaikan jumlah terlebih dahulu.');
            Exit;
          end;

          Inc(TotalJenis);
          TotalUnit := TotalUnit + Jml;

          PesanKonfirmasi := PesanKonfirmasi + IntToStr(TotalJenis) + '. ' + NamaBrg + sLineBreak +
                             '    Jumlah Diajukan : ' + IntToStr(Jml) + ' ' + Satuan +
                             ' (Sisa Stok Gudang: ' + IntToStr(StokSisaDb) + ')' + sLineBreak + sLineBreak;
        end;
        QItem.Close;
      end;
    end;
  finally
    QItem.Free;
  end;

  if TotalJenis = 0 then
  begin
    ShowMessage('VALIDASI GAGAL: Belum ada barang yang diajukan (jumlah > 0)!' + sLineBreak +
                'Silakan isi jumlah pengajuan pada barang yang dibutuhkan terlebih dahulu.');
    Exit;
  end;

  PesanKonfirmasi := PesanKonfirmasi + '===================================================' + sLineBreak +
                     'TOTAL PENGAJUAN : ' + IntToStr(TotalJenis) + ' Jenis Barang (' + FormatFloat('#,##0', TotalUnit) + ' Unit Fisik)' + sLineBreak +
                     '===================================================' + sLineBreak + sLineBreak +
                     'Apakah data pengajuan di atas SUDAH BENAR dan ingin disimpan serta dicetak suratnya?';

  if MessageDlg(PesanKonfirmasi, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  TglNow := FormatDateTime('yyyy-mm-dd', Now);
  NoPengajuan := 'PGJ-' + FormatDateTime('yyyymmdd-hhnnss', Now);

  ModulDB.Koneksi.StartTransaction;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;

    Q.SQL.Text := 'INSERT INTO Tabel_Pengajuan (No_Pengajuan, Tanggal, Bidang, Status) VALUES (:no, :tgl, :bidang, ''PENDING'')';
    Q.ParamByName('no').AsString := NoPengajuan;
    Q.ParamByName('tgl').AsString := TglNow;
    Q.ParamByName('bidang').AsString := CboBidang.Text;
    Q.ExecSQL;

    QItem := TFDQuery.Create(nil);
    try
      QItem.Connection := ModulDB.Koneksi;
      for I := 0 to FJumlahDiajukanList.Count - 1 do
      begin
        Jml := StrToIntDef(FJumlahDiajukanList.ValueFromIndex[I], 0);
        if Jml > 0 then
        begin
          KodeRek := FJumlahDiajukanList.Names[I];

          QItem.SQL.Text := 'SELECT Nama_Barang, Satuan FROM Tabel_Barang WHERE Kode_Rekening = :k';
          QItem.ParamByName('k').AsString := KodeRek;
          QItem.Open;
          if not QItem.Eof then
          begin
            NamaBrg := QItem.FieldByName('Nama_Barang').AsString;
            Satuan := QItem.FieldByName('Satuan').AsString;

            Q.SQL.Text := 'INSERT INTO Tabel_Pengajuan_Detail (No_Pengajuan, Kode_Rekening, Nama_Barang, Jumlah, Satuan) ' +
                          'VALUES (:no, :kode, :nama, :jml, :satuan)';
            Q.ParamByName('no').AsString := NoPengajuan;
            Q.ParamByName('kode').AsString := KodeRek;
            Q.ParamByName('nama').AsString := NamaBrg;
            Q.ParamByName('jml').AsInteger := Jml;
            Q.ParamByName('satuan').AsString := Satuan;
            Q.ExecSQL;
          end;
          QItem.Close;
        end;
      end;
    finally
      QItem.Free;
    end;

    ModulDB.Koneksi.Commit;

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

          SuratText.Add('<div class="date-right">Banjarmasin, ' + TglFormat + '</div>');
          SuratText.Add('<div class="doc-title">SURAT IZIN &amp; TANDA TERIMA PENGAJUAN BARANG GUDANG</div>');

          SuratText.Add('<table class="meta-table">');
          SuratText.Add('  <tr><td class="meta-label">No. Pengajuan</td><td>: ' + NoPengajuan + '</td></tr>');
          SuratText.Add('  <tr><td class="meta-label">Tanggal</td><td>: ' + TglNow + '</td></tr>');
          SuratText.Add('  <tr><td class="meta-label">Bidang Pemohon</td><td>: ' + CboBidang.Text + '</td></tr>');
          SuratText.Add('</table>');

          SuratText.Add('<table class="item-table">');
          SuratText.Add('  <thead>');
          SuratText.Add('    <tr><th style="width: 40px;">No</th><th style="width: 180px;">Kode Rekening</th><th>Nama Barang</th><th style="width: 130px;">Jumlah &amp; Satuan</th></tr>');
          SuratText.Add('  </thead>');
          SuratText.Add('  <tbody>');

          ItemNo := 0;
          QItem := TFDQuery.Create(nil);
          try
            QItem.Connection := ModulDB.Koneksi;
            for I := 0 to FJumlahDiajukanList.Count - 1 do
            begin
              Jml := StrToIntDef(FJumlahDiajukanList.ValueFromIndex[I], 0);
              if Jml > 0 then
              begin
                Inc(ItemNo);
                KodeRek := FJumlahDiajukanList.Names[I];

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

                SuratText.Add('    <tr>');
                SuratText.Add('      <td class="center">' + IntToStr(ItemNo) + '</td>');
                SuratText.Add('      <td>' + KodeRek + '</td>');
                SuratText.Add('      <td>' + NamaBrg + '</td>');
                SuratText.Add('      <td class="center">' + IntToStr(Jml) + ' ' + Satuan + '</td>');
                SuratText.Add('    </tr>');
              end;
            end;
          finally
            QItem.Free;
          end;

          SuratText.Add('  </tbody>');
          SuratText.Add('</table>');

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

    FJumlahDiajukanList.Clear;
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

procedure TForm3.EdCariChange(Sender: TObject);
begin
  MuatSemuaBarang;
end;

procedure TForm3.CboKategoriChange(Sender: TObject);
begin
  MuatSemuaBarang;
end;

procedure TForm3.BtnResetCariClick(Sender: TObject);
begin
  EdCari.Clear;
  CboKategori.ItemIndex := 0;
  MuatSemuaBarang;
end;

end.
