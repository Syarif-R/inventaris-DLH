unit Unit11;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm11 = class(TForm)
    PnlHeader: TPanel;
    LblJudul: TLabel;
    PnlKonten: TPanel;
    LblKode: TLabel;
    EdtKode: TEdit;
    LblNama: TLabel;
    EdtNama: TEdit;
    LblStok: TLabel;
    EdtStok: TEdit;
    LblJenis: TLabel;
    CboJenis: TComboBox;
    LblJumlah: TLabel;
    EdtJumlah: TEdit;
    LblSatuanInfo: TLabel;
    LblKeterangan: TLabel;
    EdtKeterangan: TEdit;
    PnlPeringatan: TPanel;
    LblPeringatan: TLabel;
    BtnSimpan: TButton;
    BtnBatal: TButton;

    procedure FormCreate(Sender: TObject);
    procedure BtnSimpanClick(Sender: TObject);
    procedure BtnBatalClick(Sender: TObject);
  private
    FSatuan: string;
    FStokAwal: Integer;
  public
    procedure BukaPenyesuaian(const AKode, ANama, ASatuan: string; AStok: Integer);
  end;

var
  Form11: TForm11;

implementation

uses
  UnitDB;

{$R *.dfm}

procedure TForm11.FormCreate(Sender: TObject);
begin
  FSatuan := '';
  FStokAwal := 0;
end;

procedure TForm11.BukaPenyesuaian(const AKode, ANama, ASatuan: string; AStok: Integer);
begin
  EdtKode.Text := AKode;
  EdtNama.Text := ANama;
  FSatuan := ASatuan;
  FStokAwal := AStok;
  EdtStok.Text := IntToStr(AStok) + ' ' + ASatuan;
  LblSatuanInfo.Caption := ASatuan;
  CboJenis.ItemIndex := 0;
  EdtJumlah.Text := '1';
  EdtKeterangan.Text := '';
  ShowModal;
end;

procedure TForm11.BtnSimpanClick(Sender: TObject);
var
  Kode, Nama, Jenis, Alasan, NoAdj, TglNow: string;
  JumlahUnit: Integer;
  IsPengurangan: Boolean;
  Q: TFDQuery;
begin
  Kode := Trim(EdtKode.Text);
  Nama := Trim(EdtNama.Text);
  Jenis := CboJenis.Text;
  Alasan := Trim(EdtKeterangan.Text);
  JumlahUnit := StrToIntDef(Trim(EdtJumlah.Text), 0);

  if (Kode = '') or (Nama = '') then
  begin
    ShowMessage('Data barang belum lengkap!');
    Exit;
  end;

  if JumlahUnit <= 0 then
  begin
    ShowMessage('Jumlah penyesuaian harus lebih dari 0!');
    Exit;
  end;

  if Alasan = '' then
  begin
    ShowMessage('Harap isi keterangan rinci / alasan penyesuaian untuk Berita Acara!');
    Exit;
  end;

  // Cek apakah jenis penyesuaian adalah Pengurangan atau Penambahan
  IsPengurangan := (CboJenis.ItemIndex in [0, 1, 2]);

  if IsPengurangan and (JumlahUnit > FStokAwal) then
  begin
    ShowMessage('VALIDASI GAGAL: Jumlah pengurangan (' + IntToStr(JumlahUnit) + ' ' + FSatuan +
                ') melebihi sisa stok yang ada (' + IntToStr(FStokAwal) + ' ' + FSatuan + ')!');
    Exit;
  end;

  if MessageDlg('KONFIRMASI PENYESUAIAN STOK:' + sLineBreak + sLineBreak +
                'Barang: ' + Nama + ' (' + Kode + ')' + sLineBreak +
                'Jenis: ' + Jenis + sLineBreak +
                'Jumlah: ' + IntToStr(JumlahUnit) + ' ' + FSatuan + sLineBreak +
                'Keterangan: ' + Alasan + sLineBreak + sLineBreak +
                'Apakah Anda yakin data penyesuaian sudah benar?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    Exit;

  NoAdj := 'ADJ-' + FormatDateTime('yyyymmdd-hhnnss', Now);
  TglNow := FormatDateTime('yyyy-mm-dd', Now);

  ModulDB.Koneksi.StartTransaction;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;

    if IsPengurangan then
    begin
      // 1. Kurangi Stok
      Q.SQL.Text := 'UPDATE Tabel_Barang SET Stok_Sisa = Stok_Sisa - :jml WHERE Kode_Rekening = :kode';
      Q.ParamByName('jml').AsInteger := JumlahUnit;
      Q.ParamByName('kode').AsString := Kode;
      Q.ExecSQL;

      // 2. Catat ke Tabel_Pengajuan (sebagai riwayat resmi penyesuaian)
      Q.Close;
      Q.SQL.Text := 'INSERT INTO Tabel_Pengajuan (No_Pengajuan, Tanggal, Bidang, Status, Bukti_Foto) ' +
                    'VALUES (:no, :tgl, :bidang, ''DIVALIDASI'', ''PENYESUAIAN_STOK'')';
      Q.ParamByName('no').AsString := NoAdj;
      Q.ParamByName('tgl').AsString := TglNow;
      Q.ParamByName('bidang').AsString := 'PENYESUAIAN: ' + Copy(Jenis, 4, 30) + ' (' + Alasan + ')';
      Q.ExecSQL;

      // 3. Catat ke Tabel_Pengajuan_Detail
      Q.Close;
      Q.SQL.Text := 'INSERT INTO Tabel_Pengajuan_Detail (No_Pengajuan, Kode_Rekening, Nama_Barang, Jumlah, Satuan) ' +
                    'VALUES (:no, :kode, :nama, :jml, :sat)';
      Q.ParamByName('no').AsString := NoAdj;
      Q.ParamByName('kode').AsString := Kode;
      Q.ParamByName('nama').AsString := Nama;
      Q.ParamByName('jml').AsInteger := JumlahUnit;
      Q.ParamByName('sat').AsString := FSatuan;
      Q.ExecSQL;

      // 4. Catat ke Tabel_Keluar
      Q.Close;
      Q.SQL.Text := 'INSERT INTO Tabel_Keluar (Tanggal, Kode_Rekening, Jumlah, No_Pengajuan) ' +
                    'VALUES (:tgl, :kode, :jml, :no)';
      Q.ParamByName('tgl').AsString := TglNow;
      Q.ParamByName('kode').AsString := Kode;
      Q.ParamByName('jml').AsInteger := JumlahUnit;
      Q.ParamByName('no').AsString := NoAdj;
      Q.ExecSQL;
    end
    else
    begin
      // Penambahan Stok (Selisih Lebih)
      // 1. Tambah Stok
      Q.SQL.Text := 'UPDATE Tabel_Barang SET Stok_Sisa = Stok_Sisa + :jml WHERE Kode_Rekening = :kode';
      Q.ParamByName('jml').AsInteger := JumlahUnit;
      Q.ParamByName('kode').AsString := Kode;
      Q.ExecSQL;

      // 2. Catat ke Tabel_Masuk
      Q.Close;
      Q.SQL.Text := 'INSERT INTO Tabel_Masuk (Tanggal, Kode_Rekening, Jumlah, No_Penerimaan, Asal_Barang) ' +
                    'VALUES (:tgl, :kode, :jml, :no, :asal)';
      Q.ParamByName('tgl').AsString := TglNow;
      Q.ParamByName('kode').AsString := Kode;
      Q.ParamByName('jml').AsInteger := JumlahUnit;
      Q.ParamByName('no').AsString := NoAdj;
      Q.ParamByName('asal').AsString := 'Penyesuaian Fisik Lebih: ' + Alasan;
      Q.ExecSQL;
    end;

    ModulDB.Koneksi.Commit;
    ShowMessage('BERHASIL! Penyesuaian stok untuk barang "' + Nama + '" telah disimpan.');
    ModalResult := mrOk;
  except
    on E: Exception do
    begin
      ModulDB.Koneksi.Rollback;
      ShowMessage('GAGAL MENYIMPAN: ' + E.Message);
    end;
  end;
  Q.Free;
end;

procedure TForm11.BtnBatalClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.