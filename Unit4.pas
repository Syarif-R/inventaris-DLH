unit Unit4;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
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
  private
    SelectedFilePath: string;
    procedure LoadPendingPengajuan;
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

procedure TForm4.BtnUploadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    SelectedFilePath := OpenDialog1.FileName;
    ImgBukti.Picture.LoadFromFile(SelectedFilePath);
  end;
end;

procedure TForm4.BtnResetFotoClick(Sender: TObject);
begin
  ImgBukti.Picture := nil;
  SelectedFilePath := '';
  ShowMessage('Foto/scan bukti fisik telah dibatalkan / dihapus.');
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

    // 1. Update Status Pengajuan ke DIVALIDASI
    Q.SQL.Text := 'UPDATE Tabel_Pengajuan SET Status = ''DIVALIDASI'' WHERE No_Pengajuan = :no';
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
