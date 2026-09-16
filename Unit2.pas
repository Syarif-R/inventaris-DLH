unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet, FireDAC.DApt, FireDAC.Stan.Param;

type
  TForm2 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    BtnKembali: TButton;
    PnlKiri: TPanel;
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
    GridMasuk: TStringGrid;
    BtnSimpan: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EdCariBarangChange(Sender: TObject);
    procedure CboBarangChange(Sender: TObject);
    procedure EdtJumlahKeyPress(Sender: TObject; var Key: Char);
    procedure BtnTambahClick(Sender: TObject);
    procedure BtnHapusItemClick(Sender: TObject);
    procedure GridMasukDblClick(Sender: TObject);
    procedure BtnSimpanClick(Sender: TObject);
    procedure BtnKembaliClick(Sender: TObject);
  private
    BarisKeranjang: Integer;
    procedure LoadBarangCombo;
  public
  end;

var
  Form2: TForm2;

implementation

uses UnitDB;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  Self.Caption := 'Input Barang Masuk - DLH Banjarmasin';
  Self.WindowState := wsMaximized;

  GridMasuk.ColCount := 4;
  GridMasuk.Cells[0, 0] := 'No';
  GridMasuk.Cells[1, 0] := 'Nama Barang';
  GridMasuk.Cells[2, 0] := 'Jumlah';
  GridMasuk.Cells[3, 0] := 'Satuan';

  BarisKeranjang := 1;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  EdCariBarang.Clear;
  LoadBarangCombo;
  CboBarang.ItemIndex := -1; // Dikoisongkan terlebih dahulu saat form dibuka!
  EdtJumlah.Clear;
  EdtSatuan.Text := '-';
end;

procedure TForm2.FormResize(Sender: TObject);
var
  SisaLebar: Integer;
begin
  SisaLebar := GridMasuk.ClientWidth - 50 - 100 - 100 - 20;
  if SisaLebar > 150 then
  begin
    GridMasuk.ColWidths[0] := 50;
    GridMasuk.ColWidths[1] := SisaLebar;
    GridMasuk.ColWidths[2] := 100;
    GridMasuk.ColWidths[3] := 100;
  end;
end;

procedure TForm2.LoadBarangCombo;
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

procedure TForm2.EdCariBarangChange(Sender: TObject);
begin
  LoadBarangCombo;
end;

procedure TForm2.CboBarangChange(Sender: TObject);
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
    LblStokInfo.Caption := 'Stok Saat Ini: -';
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
        LblStokInfo.Caption := 'Stok Saat Ini: ' + IntToStr(StokSisa) + ' ' + EdtSatuan.Text;
      end
      else
      begin
        LblStokInfo.Font.Color := clRed;
        LblStokInfo.Caption := 'STOK SAAT INI HABIS (0 ' + EdtSatuan.Text + ')';
      end;
    end
    else
    begin
      EdtSatuan.Text := '-';
      LblHasilCari.Caption := '[Info] Barang terpilih: ' + CboBarang.Text;
      LblStokInfo.Font.Color := clGray;
      LblStokInfo.Caption := 'Stok Saat Ini: -';
    end;
  finally
    Q.Free;
  end;
end;

procedure TForm2.EdtJumlahKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', '.', #8]) then
    Key := #0;
end;

procedure TForm2.BtnTambahClick(Sender: TObject);
var
  Jml: Integer;
begin
  Jml := StrToIntDef(EdtJumlah.Text, 0);

  if (CboBarang.Text = '') or (Jml <= 0) then
  begin
    ShowMessage('VALIDASI GAGAL: Pilih barang dan isi jumlah masuk (angka positif > 0) terlebih dahulu!');
    Exit;
  end;

  GridMasuk.RowCount := BarisKeranjang + 1;
  GridMasuk.Cells[0, BarisKeranjang] := IntToStr(BarisKeranjang);
  GridMasuk.Cells[1, BarisKeranjang] := CboBarang.Text;
  GridMasuk.Cells[2, BarisKeranjang] := EdtJumlah.Text;
  GridMasuk.Cells[3, BarisKeranjang] := EdtSatuan.Text;

  Inc(BarisKeranjang);

  CboBarang.ItemIndex := -1;
  EdtJumlah.Clear;
  EdtSatuan.Text := '-';
end;

procedure TForm2.BtnHapusItemClick(Sender: TObject);
var
  SelRow, I: Integer;
begin
  SelRow := GridMasuk.Row;
  if (SelRow < 1) or (SelRow >= BarisKeranjang) or (GridMasuk.Cells[1, SelRow] = '') then
  begin
    ShowMessage('Pilih baris barang di tabel keranjang yang ingin dihapus terlebih dahulu!');
    Exit;
  end;

  for I := SelRow to BarisKeranjang - 2 do
  begin
    GridMasuk.Cells[0, I] := IntToStr(I);
    GridMasuk.Cells[1, I] := GridMasuk.Cells[1, I + 1];
    GridMasuk.Cells[2, I] := GridMasuk.Cells[2, I + 1];
    GridMasuk.Cells[3, I] := GridMasuk.Cells[3, I + 1];
  end;

  GridMasuk.Rows[BarisKeranjang - 1].Clear;
  Dec(BarisKeranjang);
  if BarisKeranjang < 1 then BarisKeranjang := 1;

  if BarisKeranjang = 1 then
    GridMasuk.RowCount := 2
  else
    GridMasuk.RowCount := BarisKeranjang;
end;

procedure TForm2.GridMasukDblClick(Sender: TObject);
begin
  BtnHapusItemClick(Self);
end;

procedure TForm2.BtnSimpanClick(Sender: TObject);
var
  I, Jml, PosDash: Integer;
  KodeRek, TglNow: string;
  Q: TFDQuery;
begin
  if BarisKeranjang = 1 then
  begin
    ShowMessage('VALIDASI GAGAL: Daftar barang masuk masih kosong!');
    Exit;
  end;

  if MessageDlg('KONFIRMASI PENYIMPANAN:' + sLineBreak + sLineBreak +
                'Apakah Anda yakin ingin menyimpan ' + IntToStr(BarisKeranjang - 1) + ' jenis barang masuk ini ke Stok Gudang?',
                mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  TglNow := FormatDateTime('yyyy-mm-dd', Now);
  ModulDB.Koneksi.StartTransaction;
  Q := TFDQuery.Create(nil);
  try
    Q.Connection := ModulDB.Koneksi;

    for I := 1 to BarisKeranjang - 1 do
    begin
      PosDash := Pos(' - ', GridMasuk.Cells[1, I]);
      if PosDash > 0 then
        KodeRek := Trim(Copy(GridMasuk.Cells[1, I], 1, PosDash - 1))
      else
        KodeRek := Trim(GridMasuk.Cells[1, I]);

      Jml := StrToIntDef(GridMasuk.Cells[2, I], 0);

      // Insert ke Tabel_Masuk
      Q.SQL.Text := 'INSERT INTO Tabel_Masuk (Tanggal, Kode_Rekening, Jumlah) VALUES (:tgl, :kode, :jml)';
      Q.ParamByName('tgl').AsString := TglNow;
      Q.ParamByName('kode').AsString := KodeRek;
      Q.ParamByName('jml').AsInteger := Jml;
      Q.ExecSQL;

      // Update Tambah Stok di Tabel_Barang (Kolom Stok_Sisa)
      Q.SQL.Text := 'UPDATE Tabel_Barang SET Stok_Sisa = Stok_Sisa + :jml WHERE Kode_Rekening = :kode';
      Q.ParamByName('jml').AsInteger := Jml;
      Q.ParamByName('kode').AsString := KodeRek;
      Q.ExecSQL;
    end;

    ModulDB.Koneksi.Commit;
    ShowMessage('PENYIMPANAN BERHASIL!' + sLineBreak +
                IntToStr(BarisKeranjang - 1) + ' jenis barang masuk telah ditambahkan ke Stok Gudang.');

    // Reset Form
    BarisKeranjang := 1;
    GridMasuk.RowCount := 2;
    GridMasuk.Rows[1].Clear;
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

procedure TForm2.BtnKembaliClick(Sender: TObject);
begin
  Self.Close;
end;

end.
