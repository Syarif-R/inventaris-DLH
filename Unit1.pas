unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, IniFiles,
  VCLTee.Chart, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm1 = class(TForm)
    PnlAtas: TPanel;
    LblLogo: TLabel;
    LblAppTitle: TLabel;
    LblAppSubtitle: TLabel;
    LblDashboardTitle: TLabel;
    LblDashboardSub: TLabel;
    EdCari: TEdit;
    BtnSetting: TButton;
    PnlKiri: TPanel;
    BtnMasuk: TButton;
    BtnPengajuan: TButton;
    BtnValidasi: TButton;
    BtnArsipValidasi: TButton;
    BtnHistory: TButton;
    BtnStockOpname: TButton;
    BtnBackup: TButton;
    PnlAlertBox: TPanel;
    LblAlertJudul: TLabel;
    BtnAlertStok: TButton;
    BtnRefreshDashboard: TButton;
    PnlUtama: TPanel;
    PnlStatCards: TPanel;
    LblStatJenisTitle: TLabel;
    LblStatJenisValue: TLabel;
    LblStatStokTitle: TLabel;
    LblStatStokValue: TLabel;
    LblStatKritisTitle: TLabel;
    LblStatKritisValue: TLabel;
    LblStatTrxTitle: TLabel;
    LblStatTrxValue: TLabel;
    PnlCharts: TGridPanel;
    ChartKategori: TChart;
    ChartTopStok: TChart;
    PnlSpacer: TPanel;
    PnlCari: TPanel;
    LblDaftarPersediaan: TLabel;
    LblKategori: TLabel;
    LblPetunjukGrid: TLabel;
    CmbKategori: TComboBox;
    ChkHideZero: TCheckBox;
    BtnTambahBarang: TButton;
    BtnDownload: TButton;
    BtnEditBarang: TButton;
    BtnHapusBarang: TButton;
    BtnPenyesuaianStok: TButton;
    BtnToggleChart: TButton;
    GridStok: TStringGrid;
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnMasukClick(Sender: TObject);
    procedure BtnPengajuanClick(Sender: TObject);
    procedure BtnValidasiClick(Sender: TObject);
    procedure BtnArsipValidasiClick(Sender: TObject);
    procedure BtnHistoryClick(Sender: TObject);
    procedure BtnStockOpnameClick(Sender: TObject);
    procedure BtnBackupClick(Sender: TObject);
    procedure BtnSettingClick(Sender: TObject);
    procedure BtnAlertStokClick(Sender: TObject);
    procedure BtnRefreshDashboardClick(Sender: TObject);
    procedure BtnToggleChartClick(Sender: TObject);
    procedure EdCariChange(Sender: TObject);
    procedure CmbKategoriChange(Sender: TObject);
    procedure ChkHideZeroClick(Sender: TObject);
    procedure BtnDownloadClick(Sender: TObject);
    procedure BtnTambahBarangClick(Sender: TObject);
    procedure BtnEditBarangClick(Sender: TObject);
    procedure BtnHapusBarangClick(Sender: TObject);
    procedure BtnPenyesuaianStokClick(Sender: TObject);
    procedure GridStokDblClick(Sender: TObject);
    procedure GridStokDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
  private
    SeriesKategori: TBarSeries;
    SeriesTopStok: TBarSeries;
    FFilterKritisOnly: Boolean;
    FChartModeBidang: Boolean;
    procedure InitCharts;
    procedure UpdateStatCards;
  public
    procedure TampilDataAwal;
    procedure LoadKategoriCombo;
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit3, Unit4, Unit5, Unit6, Unit7, Unit8, Unit9, Unit10, Unit11, UnitDB;

{$R *.dfm}

const
  BAR_PALETTE: array[0..6] of TColor = (
    $00328E2E,
    $00469646,
    $00609E60,
    $0084B684,
    $0040A5E0,
    $00A3822B,
    $005A5AE9
  );

procedure TForm1.InitCharts;
begin
  ChartKategori.View3D := False;
  ChartKategori.Color := clWhite;
  ChartKategori.BackWall.Color := clWhite;
  ChartKategori.BackWall.Visible := False;
  ChartKategori.Legend.Visible := False;
  ChartKategori.Title.Font.Name := 'Segoe UI';
  ChartKategori.Title.Font.Size := 10;
  ChartKategori.Title.Font.Style := [fsBold];
  ChartKategori.Title.Font.Color := $00333333;
  ChartKategori.Axes.Bottom.Grid.Visible := False;
  ChartKategori.Axes.Bottom.LabelsFont.Name := 'Segoe UI';
  ChartKategori.Axes.Bottom.LabelsFont.Size := 8;
  ChartKategori.Axes.Left.Grid.Color := $00F2F2F2;
  ChartKategori.Axes.Left.LabelsFont.Name := 'Segoe UI';
  ChartKategori.Axes.Left.LabelsFont.Size := 8;
  ChartKategori.MarginTop := 6;
  ChartKategori.MarginBottom := 6;
  ChartKategori.MarginLeft := 6;
  ChartKategori.MarginRight := 6;
  ChartKategori.FreeAllSeries;
  SeriesKategori := TBarSeries.Create(ChartKategori);
  SeriesKategori.ParentChart := ChartKategori;
  SeriesKategori.ColorEachPoint := True;
  SeriesKategori.Marks.Visible := True;
  SeriesKategori.Marks.Style := smsValue;
  SeriesKategori.Marks.BackColor := $00E8F8FF;
  SeriesKategori.Marks.Frame.Color := $00C0D4DC;
  SeriesKategori.Marks.Font.Name := 'Segoe UI';
  SeriesKategori.Marks.Font.Size := 8;
  SeriesKategori.Marks.Font.Style := [fsBold];
  SeriesKategori.Marks.Font.Color := $00202020;
  SeriesKategori.Marks.Transparent := False;
  SeriesKategori.Marks.Arrow.Visible := False;
  SeriesKategori.BarWidthPercent := 55;
  SeriesKategori.ValueFormat := '#,##0';

  ChartTopStok.View3D := False;
  ChartTopStok.Color := clWhite;
  ChartTopStok.BackWall.Color := clWhite;
  ChartTopStok.BackWall.Visible := False;
  ChartTopStok.Legend.Visible := False;
  ChartTopStok.Title.Font.Name := 'Segoe UI';
  ChartTopStok.Title.Font.Size := 10;
  ChartTopStok.Title.Font.Style := [fsBold];
  ChartTopStok.Title.Font.Color := $00333333;
  ChartTopStok.Axes.Bottom.Grid.Visible := False;
  ChartTopStok.Axes.Bottom.LabelsFont.Name := 'Segoe UI';
  ChartTopStok.Axes.Bottom.LabelsFont.Size := 8;
  ChartTopStok.Axes.Left.Grid.Color := $00F2F2F2;
  ChartTopStok.Axes.Left.LabelsFont.Name := 'Segoe UI';
  ChartTopStok.Axes.Left.LabelsFont.Size := 8;
  ChartTopStok.MarginTop := 6;
  ChartTopStok.MarginBottom := 6;
  ChartTopStok.MarginLeft := 6;
  ChartTopStok.MarginRight := 6;
  ChartTopStok.FreeAllSeries;
  SeriesTopStok := TBarSeries.Create(ChartTopStok);
  SeriesTopStok.ParentChart := ChartTopStok;
  SeriesTopStok.ColorEachPoint := True;
  SeriesTopStok.Marks.Visible := True;
  SeriesTopStok.Marks.Style := smsValue;
  SeriesTopStok.Marks.BackColor := $00E8F8FF;
  SeriesTopStok.Marks.Frame.Color := $00C0D4DC;
  SeriesTopStok.Marks.Font.Name := 'Segoe UI';
  SeriesTopStok.Marks.Font.Size := 8;
  SeriesTopStok.Marks.Font.Style := [fsBold];
  SeriesTopStok.Marks.Font.Color := $00202020;
  SeriesTopStok.Marks.Transparent := False;
  SeriesTopStok.Marks.Arrow.Visible := False;
  SeriesTopStok.BarWidthPercent := 55;
  SeriesTopStok.ValueFormat := '#,##0';
end;

procedure TForm1.UpdateStatCards;
var
  Q: TFDQuery;
begin
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Barang';
    Q.Open;
    LblStatJenisValue.Caption := FormatFloat('#,##0', Q.Fields[0].AsInteger);

    Q.SQL.Text := 'SELECT COALESCE(SUM(Stok_Sisa),0) FROM Tabel_Barang';
    Q.Open;
    LblStatStokValue.Caption := FormatFloat('#,##0', Q.Fields[0].AsInteger);

    Q.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Barang WHERE Stok_Sisa <= 5 AND Stok_Sisa > 0';
    Q.Open;
    LblStatKritisValue.Caption := IntToStr(Q.Fields[0].AsInteger);

    Q.SQL.Text := 'SELECT ' +
      '(SELECT COUNT(*) FROM Tabel_Masuk WHERE strftime(''%Y-%m'', Tanggal) = strftime(''%Y-%m'', ''now'')) + ' +
      '(SELECT COUNT(*) FROM Tabel_Pengajuan WHERE strftime(''%Y-%m'', Tanggal) = strftime(''%Y-%m'', ''now''))';
    Q.Open;
    LblStatTrxValue.Caption := IntToStr(Q.Fields[0].AsInteger);
  finally
    Q.Free;
  end;
end;

procedure TForm1.LoadKategoriCombo;
var
  Q: TFDQuery;
  CurrKat: string;
begin
  CurrKat := CmbKategori.Text;
  CmbKategori.Items.BeginUpdate;
  try
    CmbKategori.Items.Clear;
    CmbKategori.Items.Add('Semua Kategori');
    Q := TFDQuery.Create(nil);
    try
      Q.Connection := ModulDB.Koneksi;
      Q.SQL.Text := 'SELECT DISTINCT Kategori FROM Tabel_Barang WHERE Kategori IS NOT NULL AND Kategori <> '''' ORDER BY Kategori ASC';
      Q.Open;
      while not Q.Eof do
      begin
        CmbKategori.Items.Add(Q.Fields[0].AsString);
        Q.Next;
      end;
    finally
      Q.Free;
    end;
  finally
    CmbKategori.Items.EndUpdate;
  end;
  if (CurrKat <> '') and (CmbKategori.Items.IndexOf(CurrKat) >= 0) then
    CmbKategori.ItemIndex := CmbKategori.Items.IndexOf(CurrKat)
  else
    CmbKategori.ItemIndex := 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Aplikasi Inventaris DLH - Dashboard Utama';
  GridStok.Cells[0, 0] := 'No';
  GridStok.Cells[1, 0] := 'Kode Rekening';
  GridStok.Cells[2, 0] := 'Nama Persediaan';
  GridStok.Cells[3, 0] := 'Kategori';
  GridStok.Cells[4, 0] := 'Satuan';
  GridStok.Cells[5, 0] := 'Status';
  GridStok.Cells[6, 0] := 'Stok';
  ChkHideZero.Checked := True;
  FFilterKritisOnly := False;
  FChartModeBidang := False;
  BtnSetting.Caption := 'Setting';
  InitCharts;
  LoadKategoriCombo;
  TampilDataAwal;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  LoadKategoriCombo;
  TampilDataAwal;
  Form9.AutoBackupIfNeeded;
end;

procedure TForm1.FormResize(Sender: TObject);
var
  LebarTersisa: Integer;
begin
  if Assigned(BtnSetting) then
    BtnSetting.Left := PnlAtas.ClientWidth - BtnSetting.Width - 25;

  // Fixed widths: Col0=40, Col1=170, Col3=140, Col4=70, Col5=80, Col6=90 -> total fixed=590
  LebarTersisa := GridStok.ClientWidth - 590;
  if LebarTersisa < 200 then LebarTersisa := 200;
  GridStok.ColWidths[0] := 40;
  GridStok.ColWidths[1] := 170;
  GridStok.ColWidths[2] := LebarTersisa;
  GridStok.ColWidths[3] := 140;
  GridStok.ColWidths[4] := 70;
  GridStok.ColWidths[5] := 80;
  GridStok.ColWidths[6] := 90;
end;

procedure TForm1.GridStokDrawCell(Sender: TObject; ACol, ARow: Longint; Rect: TRect; State: TGridDrawState);
var
  SisaStok: Integer;
  CellText: string;
  TextFlags: Cardinal;
  R: TRect;
begin
  R := Rect;
  CellText := GridStok.Cells[ACol, ARow];

  if ARow = 0 then
  begin
    GridStok.Canvas.Brush.Color := $00ECECEC;
    GridStok.Canvas.FillRect(R);
    GridStok.Canvas.Pen.Color := $00D0D0D0;
    GridStok.Canvas.MoveTo(R.Left, R.Bottom - 1);
    GridStok.Canvas.LineTo(R.Right, R.Bottom - 1);
    GridStok.Canvas.MoveTo(R.Right - 1, R.Top);
    GridStok.Canvas.LineTo(R.Right - 1, R.Bottom);
    GridStok.Canvas.Font.Name := 'Segoe UI';
    GridStok.Canvas.Font.Size := 9;
    GridStok.Canvas.Font.Style := [fsBold];
    GridStok.Canvas.Font.Color := $002A2A2A;
    TextFlags := DT_SINGLELINE or DT_VCENTER;
    if (ACol = 0) or (ACol >= 4) then
      TextFlags := TextFlags or DT_CENTER
    else
      TextFlags := TextFlags or DT_LEFT;
    InflateRect(R, -6, 0);
    DrawText(GridStok.Canvas.Handle, PChar(CellText), -1, R, TextFlags);
    Exit;
  end;

  SisaStok := StrToIntDef(GridStok.Cells[6, ARow], -1);

  if gdSelected in State then
  begin
    GridStok.Canvas.Brush.Color := $00E8F0E4;
    GridStok.Canvas.Font.Color := clBlack;
    GridStok.Canvas.Font.Style := [fsBold];
  end
  else
  begin
    if (SisaStok >= 0) and (SisaStok <= 5) then
      GridStok.Canvas.Brush.Color := $00E0F3FF
    else if (ARow mod 2 = 0) then
      GridStok.Canvas.Brush.Color := $00FAFAFA
    else
      GridStok.Canvas.Brush.Color := clWhite;
    GridStok.Canvas.Font.Color := $00202020;
    GridStok.Canvas.Font.Style := [];
  end;

  GridStok.Canvas.FillRect(R);
  GridStok.Canvas.Pen.Color := $00F0F0F0;
  GridStok.Canvas.MoveTo(R.Left, R.Bottom - 1);
  GridStok.Canvas.LineTo(R.Right, R.Bottom - 1);
  GridStok.Canvas.Font.Name := 'Segoe UI';
  GridStok.Canvas.Font.Size := 9;

  // Status column (ACol=5) - colored badge text
  if ACol = 5 then
  begin
    GridStok.Canvas.Font.Style := [fsBold];
    if CellText = 'Kritis' then
      GridStok.Canvas.Font.Color := $000000D0
    else if CellText = 'Menipis' then
      GridStok.Canvas.Font.Color := $000080FF
    else if CellText = 'Aman' then
      GridStok.Canvas.Font.Color := $00328E2E
    else
      GridStok.Canvas.Font.Color := clGray;
  end;

  // Stok column (ACol=6) - red bold + warning for critical
  if (ACol = 6) and (SisaStok >= 0) and (SisaStok <= 5) then
  begin
    GridStok.Canvas.Font.Color := $000000D0;
    GridStok.Canvas.Font.Style := [fsBold];
    CellText := #$26A0 + ' ' + GridStok.Cells[6, ARow];
  end;

  TextFlags := DT_SINGLELINE or DT_VCENTER;
  if (ACol = 0) or (ACol >= 4) then
    TextFlags := TextFlags or DT_CENTER
  else
    TextFlags := TextFlags or DT_LEFT;
  InflateRect(R, -6, 0);
  DrawText(GridStok.Canvas.Handle, PChar(CellText), -1, R, TextFlags);
end;

procedure TForm1.TampilDataAwal;
var
  BarisTabel, ColorIdx: Integer;
  SearchKey, SelectedKat, Kat, StatusStr: string;
  StokSisa, CountKritis, CountPending: Integer;
  Q, QKat, QTop, QAlert: TFDQuery;
  MatchSearch, MatchKat, MatchStok: Boolean;
begin
  UpdateStatCards;

  QAlert := TFDQuery.Create(nil);
  try
    QAlert.Connection := ModulDB.Koneksi;
    QAlert.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Barang WHERE Stok_Sisa <= 5 AND Stok_Sisa > 0';
    QAlert.Open;
    CountKritis := QAlert.Fields[0].AsInteger;

    QAlert.SQL.Text := 'SELECT COUNT(*) FROM Tabel_Pengajuan WHERE Status = ''PENDING''';
    QAlert.Open;
    CountPending := QAlert.Fields[0].AsInteger;

    if CountPending > 0 then
      BtnValidasi.Caption := 'Validasi Pengajuan (' + IntToStr(CountPending) + ')'
    else
      BtnValidasi.Caption := 'Validasi Pengajuan';
    BtnArsipValidasi.Caption := 'Arsip Dokumen Fisik';

    if FFilterKritisOnly then
      BtnAlertStok.Caption := IntToStr(CountKritis) + ' Barang Kritis (Filter ON)'
    else if CountKritis > 0 then
      BtnAlertStok.Caption := IntToStr(CountKritis) + ' Barang Kritis'
    else
      BtnAlertStok.Caption := 'Semua Stok Aman';

    BtnRefreshDashboard.Caption := 'Segarkan Status';
  finally
    QAlert.Free;
  end;

  GridStok.RowCount := 2;
  GridStok.Rows[1].Clear;
  BarisTabel := 1;
  SearchKey := LowerCase(Trim(EdCari.Text));
  SelectedKat := Trim(CmbKategori.Text);

  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;
    Q.SQL.Text := 'SELECT Kode_Rekening, Nama_Barang, Kategori, Satuan, Stok_Sisa FROM Tabel_Barang ' +
                  'ORDER BY CASE WHEN Stok_Sisa > 0 THEN 0 ELSE 1 END, Nama_Barang ASC';
    Q.Open;
    while not Q.Eof do
    begin
      Kat := Q.FieldByName('Kategori').AsString;
      StokSisa := Q.FieldByName('Stok_Sisa').AsInteger;

      MatchSearch := (SearchKey = '') or
                     (Pos(SearchKey, LowerCase(Q.FieldByName('Kode_Rekening').AsString)) > 0) or
                     (Pos(SearchKey, LowerCase(Q.FieldByName('Nama_Barang').AsString)) > 0);
      MatchKat := (SelectedKat = '') or (SelectedKat = 'Semua Kategori') or (Kat = SelectedKat);
      if FFilterKritisOnly then
        MatchStok := (StokSisa <= 5) and (StokSisa > 0)
      else
        MatchStok := not (ChkHideZero.Checked and (StokSisa <= 0));

      if MatchSearch and MatchKat and MatchStok then
      begin
        if BarisTabel >= GridStok.RowCount then
          GridStok.RowCount := BarisTabel + 1;

        if StokSisa <= 0 then StatusStr := '-'
        else if StokSisa <= 5 then StatusStr := 'Kritis'
        else if StokSisa <= 15 then StatusStr := 'Menipis'
        else StatusStr := 'Aman';

        GridStok.Cells[0, BarisTabel] := IntToStr(BarisTabel);
        GridStok.Cells[1, BarisTabel] := Q.FieldByName('Kode_Rekening').AsString;
        GridStok.Cells[2, BarisTabel] := Q.FieldByName('Nama_Barang').AsString;
        GridStok.Cells[3, BarisTabel] := Kat;
        GridStok.Cells[4, BarisTabel] := Q.FieldByName('Satuan').AsString;
        GridStok.Cells[5, BarisTabel] := StatusStr;
        GridStok.Cells[6, BarisTabel] := IntToStr(StokSisa);
        Inc(BarisTabel);
      end;
      Q.Next;
    end;
  finally
    Q.Free;
  end;

  SeriesKategori.Clear;
  QKat := TFDQuery.Create(nil);
  try
    QKat.Connection := ModulDB.Koneksi;
    QKat.SQL.Text := 'SELECT Kategori, SUM(Stok_Sisa) AS TotalStok FROM Tabel_Barang ' +
                     'WHERE Kategori IS NOT NULL AND Kategori <> '''' ' +
                     'GROUP BY Kategori ORDER BY TotalStok DESC';
    QKat.Open;
    ColorIdx := 0;
    while not QKat.Eof do
    begin
      if not (ChkHideZero.Checked and (QKat.FieldByName('TotalStok').AsInteger <= 0)) then
      begin
        SeriesKategori.Add(QKat.FieldByName('TotalStok').AsInteger,
          QKat.FieldByName('Kategori').AsString,
          BAR_PALETTE[ColorIdx mod 7]);
        Inc(ColorIdx);
      end;
      QKat.Next;
    end;
  finally
    QKat.Free;
  end;

  SeriesTopStok.Clear;
  QTop := TFDQuery.Create(nil);
  try
    QTop.Connection := ModulDB.Koneksi;
    if FChartModeBidang then
    begin
      ChartTopStok.Title.Text.Text := 'Penggunaan Barang per Bidang (Bulan Ini)';
      QTop.SQL.Text := 'SELECT P.Bidang, SUM(D.Jumlah) AS TotalKeluar ' +
                       'FROM Tabel_Pengajuan P ' +
                       'JOIN Tabel_Pengajuan_Detail D ON P.No_Pengajuan = D.No_Pengajuan ' +
                       'WHERE P.Status = ''DIVALIDASI'' ' +
                       '  AND strftime(''%Y-%m'', P.Tanggal) = strftime(''%Y-%m'', ''now'') ' +
                       'GROUP BY P.Bidang ORDER BY TotalKeluar DESC LIMIT 7';
      QTop.Open;
      if QTop.IsEmpty then
      begin
        QTop.Close;
        ChartTopStok.Title.Text.Text := 'Penggunaan Barang per Bidang (Total)';
        QTop.SQL.Text := 'SELECT P.Bidang, SUM(D.Jumlah) AS TotalKeluar ' +
                         'FROM Tabel_Pengajuan P ' +
                         'JOIN Tabel_Pengajuan_Detail D ON P.No_Pengajuan = D.No_Pengajuan ' +
                         'WHERE P.Status = ''DIVALIDASI'' ' +
                         'GROUP BY P.Bidang ORDER BY TotalKeluar DESC LIMIT 7';
        QTop.Open;
      end;
      ColorIdx := 0;
      while not QTop.Eof do
      begin
        SeriesTopStok.Add(QTop.FieldByName('TotalKeluar').AsInteger,
          QTop.FieldByName('Bidang').AsString,
          BAR_PALETTE[ColorIdx mod 7]);
        Inc(ColorIdx);
        QTop.Next;
      end;
    end
    else
    begin
      if (SelectedKat = '') or (SelectedKat = 'Semua Kategori') then
      begin
        ChartTopStok.Title.Text.Text := 'Top 7 Barang Stok Terbanyak (Stok > 0)';
        QTop.SQL.Text := 'SELECT Nama_Barang, Stok_Sisa FROM Tabel_Barang ' +
                         'WHERE Stok_Sisa > 0 ORDER BY Stok_Sisa DESC LIMIT 7';
      end
      else
      begin
        ChartTopStok.Title.Text.Text := 'Top Stok: ' + UpperCase(SelectedKat);
        QTop.SQL.Text := 'SELECT Nama_Barang, Stok_Sisa FROM Tabel_Barang ' +
                         'WHERE Stok_Sisa > 0 AND Kategori = :kat ORDER BY Stok_Sisa DESC LIMIT 7';
        QTop.ParamByName('kat').AsString := SelectedKat;
      end;
      QTop.Open;
      ColorIdx := 0;
      while not QTop.Eof do
      begin
        SeriesTopStok.Add(QTop.FieldByName('Stok_Sisa').AsInteger,
          QTop.FieldByName('Nama_Barang').AsString,
          BAR_PALETTE[ColorIdx mod 7]);
        Inc(ColorIdx);
        QTop.Next;
      end;
    end;
  finally
    QTop.Free;
  end;
end;

procedure TForm1.EdCariChange(Sender: TObject);
begin
  TampilDataAwal;
end;

procedure TForm1.CmbKategoriChange(Sender: TObject);
begin
  TampilDataAwal;
end;

procedure TForm1.ChkHideZeroClick(Sender: TObject);
begin
  TampilDataAwal;
end;

procedure TForm1.BtnDownloadClick(Sender: TObject);
var
  DataExcel: TStringList;
  Kolom, Baris: Integer;
  BarisTeks, NilaiCell: string;
begin
  SaveDialog1.Title := 'Simpan Laporan Inventaris';
  SaveDialog1.Filter := 'File Excel (CSV)|*.csv';
  SaveDialog1.DefaultExt := 'csv';
  SaveDialog1.FileName := 'Laporan_Inventaris_DLH.csv';
  if SaveDialog1.Execute then
  begin
    DataExcel := TStringList.Create;
    try
      for Baris := 0 to GridStok.RowCount - 1 do
      begin
        if (Baris > 0) and (GridStok.Cells[1, Baris] = '') then Continue;
        BarisTeks := '';
        for Kolom := 0 to GridStok.ColCount - 1 do
        begin
          NilaiCell := GridStok.Cells[Kolom, Baris];
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
      ShowMessage('Sukses! Laporan berhasil diunduh.');
    finally
      DataExcel.Free;
    end;
  end;
end;

procedure TForm1.BtnMasukClick(Sender: TObject);
begin
  Form2.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnPengajuanClick(Sender: TObject);
begin
  Form3.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnValidasiClick(Sender: TObject);
begin
  Form4.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnArsipValidasiClick(Sender: TObject);
begin
  Form8.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnHistoryClick(Sender: TObject);
begin
  Form5.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnTambahBarangClick(Sender: TObject);
begin
  Form6.BukaTambahBarang;
  LoadKategoriCombo;
  TampilDataAwal;
end;

procedure TForm1.BtnEditBarangClick(Sender: TObject);
var
  RowIdx: Integer;
  Kode: string;
begin
  RowIdx := GridStok.Row;
  if (RowIdx <= 0) or (GridStok.Cells[1, RowIdx] = '') then
  begin
    MessageDlg('Pilih salah satu baris barang pada tabel terlebih dahulu untuk diedit.', mtInformation, [mbOK], 0);
    Exit;
  end;
  Kode := GridStok.Cells[1, RowIdx];
  Form6.BukaEditBarang(Kode);
  LoadKategoriCombo;
  TampilDataAwal;
end;

procedure TForm1.GridStokDblClick(Sender: TObject);
begin
  BtnEditBarangClick(Sender);
end;

procedure TForm1.BtnHapusBarangClick(Sender: TObject);
var
  RowIdx: Integer;
  Kode, NamaBarang: string;
  QCheck: TFDQuery;
  CountTrx: Integer;
begin
  RowIdx := GridStok.Row;
  if (RowIdx <= 0) or (GridStok.Cells[1, RowIdx] = '') then
  begin
    MessageDlg('Pilih salah satu baris barang pada tabel terlebih dahulu untuk dihapus.', mtInformation, [mbOK], 0);
    Exit;
  end;
  Kode := GridStok.Cells[1, RowIdx];
  NamaBarang := GridStok.Cells[2, RowIdx];

  QCheck := TFDQuery.Create(nil);
  try
    QCheck.Connection := ModulDB.Koneksi;
    QCheck.SQL.Text := 'SELECT ' +
                       '(SELECT COUNT(*) FROM Tabel_Masuk WHERE Kode_Rekening = :k1) + ' +
                       '(SELECT COUNT(*) FROM Tabel_Keluar WHERE Kode_Rekening = :k2) + ' +
                       '(SELECT COUNT(*) FROM Tabel_Pengajuan_Detail WHERE Kode_Rekening = :k3)';
    QCheck.ParamByName('k1').AsString := Kode;
    QCheck.ParamByName('k2').AsString := Kode;
    QCheck.ParamByName('k3').AsString := Kode;
    QCheck.Open;
    CountTrx := QCheck.Fields[0].AsInteger;

    if CountTrx > 0 then
    begin
      MessageDlg('Barang "' + NamaBarang + '" (' + Kode + ') TIDAK DAPAT DIHAPUS' + sLineBreak +
                 'karena sudah memiliki riwayat transaksi.', mtWarning, [mbOK], 0);
      Exit;
    end;

    if MessageDlg('Hapus barang ini dari katalog inventaris?' + sLineBreak + sLineBreak +
                  'Kode: ' + Kode + sLineBreak +
                  'Nama: ' + NamaBarang, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      QCheck.Close;
      QCheck.SQL.Text := 'DELETE FROM Tabel_Barang WHERE Kode_Rekening = :k';
      QCheck.ParamByName('k').AsString := Kode;
      QCheck.ExecSQL;
      ShowMessage('Barang "' + NamaBarang + '" berhasil dihapus.');
      LoadKategoriCombo;
      TampilDataAwal;
    end;
  finally
    QCheck.Free;
  end;
end;

procedure TForm1.BtnStockOpnameClick(Sender: TObject);
begin
  Form7.ShowModal;
  TampilDataAwal;
end;

procedure TForm1.BtnBackupClick(Sender: TObject);
begin
  Form9.ShowModal;
end;

procedure TForm1.BtnSettingClick(Sender: TObject);
begin
  Form10.ShowModal;
end;

procedure TForm1.BtnToggleChartClick(Sender: TObject);
begin
  FChartModeBidang := not FChartModeBidang;
  if FChartModeBidang then
    BtnToggleChart.Caption := 'Grafik: Top Stok Barang'
  else
    BtnToggleChart.Caption := 'Grafik: Penggunaan Bidang';
  TampilDataAwal;
end;

procedure TForm1.BtnPenyesuaianStokClick(Sender: TObject);
var
  RowIdx, Stok: Integer;
  Kode, Nama, Satuan: string;
begin
  RowIdx := GridStok.Row;
  if (RowIdx <= 0) or (GridStok.Cells[1, RowIdx] = '') then
  begin
    MessageDlg('Pilih salah satu baris barang yang ingin disesuaikan stoknya.', mtInformation, [mbOK], 0);
    Exit;
  end;
  Kode := GridStok.Cells[1, RowIdx];
  Nama := GridStok.Cells[2, RowIdx];
  Satuan := GridStok.Cells[4, RowIdx];
  Stok := StrToIntDef(GridStok.Cells[6, RowIdx], 0);
  Form11.BukaPenyesuaian(Kode, Nama, Satuan, Stok);
  TampilDataAwal;
end;

procedure TForm1.BtnAlertStokClick(Sender: TObject);
begin
  FFilterKritisOnly := not FFilterKritisOnly;
  TampilDataAwal;
end;

procedure TForm1.BtnRefreshDashboardClick(Sender: TObject);
begin
  FFilterKritisOnly := False;
  LoadKategoriCombo;
  TampilDataAwal;
end;

end.
