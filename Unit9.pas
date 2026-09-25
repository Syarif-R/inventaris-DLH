unit Unit9;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants, System.Classes,
  System.IniFiles, System.Net.HttpClient, System.Net.HttpClientComponent, System.Net.URLClient,
  System.NetEncoding, System.Zip,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Comp.Client;

type
  TForm9 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    PnlKonten: TPanel;
    PnlInfo: TPanel;
    LblPenjelasan: TLabel;
    LblStatusTerakhir: TLabel;
    PnlConfig: TPanel;
    LblUrl: TLabel;
    EdtUrl: TEdit;
    LblToken: TLabel;
    EdtToken: TEdit;
    ChkAutoBackup: TCheckBox;
    PnlLog: TPanel;
    LblLog: TLabel;
    MemoLog: TMemo;
    PnlAksi: TPanel;
    BtnBackupCloud: TButton;
    BtnExportZip: TButton;
    BtnTutup: TButton;
    SaveDialog1: TSaveDialog;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnBackupCloudClick(Sender: TObject);
    procedure BtnExportZipClick(Sender: TObject);
    procedure BtnTutupClick(Sender: TObject);
    procedure ChkAutoBackupClick(Sender: TObject);
    procedure EdtUrlChange(Sender: TObject);
    procedure EdtTokenChange(Sender: TObject);
  private
    FConfigFile: string;
    procedure LoadConfig;
    procedure SaveConfig;
    procedure TambahLog(const Pesan: string);
    function FileToBase64(const AFilePath: string): string;
    function EscapeJson(const S: string): string;
    function KirimJson(const AUrl, AJson: string): string;
  public
    function LakukanBackupCloud(const Silent: Boolean = False): Boolean;
    procedure AutoBackupIfNeeded;
  end;

var
  Form9: TForm9;

implementation

uses UnitDB;

{$R *.dfm}

const
  DEFAULT_WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbwPWaY_f2nxGMmB9yqTKGJ2P3JZu7OFF_WdU5i7HjCGp534MPP0FxVgp0Jftyzn0AJ_/exec';
  DEFAULT_SECRET_TOKEN = 'DLH_INVENTARIS_2026_SECRET';

procedure TForm9.FormCreate(Sender: TObject);
begin
  FConfigFile := ExtractFilePath(ParamStr(0)) + 'Config.ini';
  LoadConfig;
end;

procedure TForm9.FormShow(Sender: TObject);
begin
  LoadConfig;
end;

procedure TForm9.LoadConfig;
var
  Ini: TIniFile;
  Url, Token, LastDate, LastTime, LastStatus: string;
  AutoB: Boolean;
begin
  Ini := TIniFile.Create(FConfigFile);
  try
    Url := Ini.ReadString('GoogleDrive', 'WebhookUrl', DEFAULT_WEBHOOK_URL);
    Token := Ini.ReadString('GoogleDrive', 'SecretToken', DEFAULT_SECRET_TOKEN);
    AutoB := Ini.ReadBool('GoogleDrive', 'AutoBackup', True);
    LastDate := Ini.ReadString('GoogleDrive', 'LastBackupDate', '');
    LastTime := Ini.ReadString('GoogleDrive', 'LastBackupTime', '');
    LastStatus := Ini.ReadString('GoogleDrive', 'LastBackupStatus', 'Belum pernah dicadangkan');

    EdtUrl.Text := Url;
    EdtToken.Text := Token;
    ChkAutoBackup.Checked := AutoB;

    if LastDate <> '' then
      LblStatusTerakhir.Caption := 'Status Terakhir: ' + LastDate + ' ' + LastTime + ' (' + LastStatus + ')'
    else
      LblStatusTerakhir.Caption := 'Status Terakhir: ' + LastStatus;
  finally
    Ini.Free;
  end;
end;

procedure TForm9.SaveConfig;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FConfigFile);
  try
    Ini.WriteString('GoogleDrive', 'WebhookUrl', Trim(EdtUrl.Text));
    Ini.WriteString('GoogleDrive', 'SecretToken', Trim(EdtToken.Text));
    Ini.WriteBool('GoogleDrive', 'AutoBackup', ChkAutoBackup.Checked);
  finally
    Ini.Free;
  end;
end;

procedure TForm9.EdtUrlChange(Sender: TObject);
begin
  SaveConfig;
end;

procedure TForm9.EdtTokenChange(Sender: TObject);
begin
  SaveConfig;
end;

procedure TForm9.ChkAutoBackupClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TForm9.BtnTutupClick(Sender: TObject);
begin
  Close;
end;

procedure TForm9.TambahLog(const Pesan: string);
begin
  MemoLog.Lines.Add('[' + FormatDateTime('hh:nn:ss', Now) + '] ' + Pesan);
  MemoLog.Perform(EM_SCROLLCARET, 0, 0);
  Application.ProcessMessages;
end;

function TForm9.EscapeJson(const S: string): string;
begin
  Result := S;
  Result := StringReplace(Result, '\', '\\', [rfReplaceAll]);
  Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
  Result := StringReplace(Result, #13#10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #13, '\n', [rfReplaceAll]);
  Result := StringReplace(Result, #9, '\t', [rfReplaceAll]);
end;

function TForm9.FileToBase64(const AFilePath: string): string;
var
  FS: TFileStream;
  SS: TStringStream;
begin
  Result := '';
  if not FileExists(AFilePath) then Exit;
  FS := TFileStream.Create(AFilePath, fmOpenRead or fmShareDenyNone);
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
end;

function TForm9.KirimJson(const AUrl, AJson: string): string;
var
  Client: TNetHTTPClient;
  SourceStream, ResponseStream: TStringStream;
  Resp: IHTTPResponse;
begin
  Client := TNetHTTPClient.Create(nil);
  SourceStream := TStringStream.Create(AJson, TEncoding.UTF8);
  ResponseStream := TStringStream.Create('', TEncoding.UTF8);
  try
    Client.ConnectionTimeout := 30000;
    Client.ResponseTimeout := 60000;
    Client.ContentType := 'application/json';
    Client.Accept := 'application/json';
    Resp := Client.Post(AUrl, SourceStream, ResponseStream);
    if Assigned(Resp) then
      Result := ResponseStream.DataString
    else
      Result := '';
  finally
    ResponseStream.Free;
    SourceStream.Free;
    Client.Free;
  end;
end;

function TForm9.LakukanBackupCloud(const Silent: Boolean = False): Boolean;
var
  Url, Token, ExeDir, DbSource, TempDbCopy, DbB64, JsonPayload, Resp: string;
  ArsipBuktiDir, MonthDir, MonthName, PhotoPath, PhotoB64, PhotoFileName: string;
  SRMonth, SRFile: TSearchRec;
  TotalUploadedPhotos, TotalSkippedPhotos: Integer;
  SuccessDb: Boolean;
  Ini: TIniFile;
begin
  Result := False;
  Url := Trim(EdtUrl.Text);
  Token := Trim(EdtToken.Text);

  if Url = '' then
  begin
    if not Silent then ShowMessage('URL Web App Google Drive belum diisi!');
    Exit;
  end;

  SaveConfig;
  MemoLog.Clear;
  TambahLog('=== MEMULAI SINKRONISASI BACKUP GOOGLE DRIVE ===');
  TambahLog('Menghubungkan ke Google Apps Script Dinas...');

  ExeDir := ExtractFilePath(ParamStr(0));
  DbSource := ExeDir + 'DatabaseDLH.db';

  if not FileExists(DbSource) then
    DbSource := ExpandFileName('DatabaseDLH.db');

  if not FileExists(DbSource) then
  begin
    TambahLog('ERROR: File DatabaseDLH.db tidak ditemukan!');
    Exit;
  end;

  // 1. Upload Database Inventaris
  TempDbCopy := ExeDir + 'TempBackupDb.db';
  try
    CopyFile(PChar(DbSource), PChar(TempDbCopy), False);
    DbB64 := FileToBase64(TempDbCopy);
  finally
    if FileExists(TempDbCopy) then
      DeleteFile(TempDbCopy);
  end;

  TambahLog('Mengunggah database: ' + ExtractFileName(DbSource) + ' (' + FormatDateTime('yyyy-mm-dd', Now) + ')...');

  JsonPayload := '{"token":"' + EscapeJson(Token) + '",' +
                 '"action":"upload_db",' +
                 '"fileName":"DatabaseDLH_' + FormatDateTime('yyyy-mm-dd', Now) + '.db",' +
                 '"fileBase64":"' + EscapeJson(DbB64) + '"}';

  SuccessDb := False;
  try
    Resp := KirimJson(Url, JsonPayload);
    if Pos('"status":"success"', Resp) > 0 then
    begin
      SuccessDb := True;
      TambahLog('-> SUKSES: Database inventaris tersimpan di Google Drive folder Database_Backup.');
    end
    else
    begin
      TambahLog('-> GAGAL: Tanggapan dari server: ' + Resp);
    end;
  except
    on E: Exception do
      TambahLog('-> GAGAL koneksi saat upload database: ' + E.Message);
  end;

  // 2. Upload Foto Bukti Fisik per Folder Bulan
  TotalUploadedPhotos := 0;
  TotalSkippedPhotos := 0;
  ArsipBuktiDir := ExeDir + 'arsip_bukti';

  if DirectoryExists(ArsipBuktiDir) then
  begin
    TambahLog('Memindai folder arsip bukti fisik...');

    if FindFirst(ArsipBuktiDir + '\*.*', faDirectory, SRMonth) = 0 then
    begin
      try
        repeat
          if (SRMonth.Name <> '.') and (SRMonth.Name <> '..') and ((SRMonth.Attr and faDirectory) <> 0) then
          begin
            MonthName := SRMonth.Name; // Contoh: '2026-09'
            MonthDir := ArsipBuktiDir + '\' + MonthName;

            TambahLog('Memeriksa folder bulan [' + MonthName + ']...');

            if FindFirst(MonthDir + '\*.*', faAnyFile and not faDirectory, SRFile) = 0 then
            begin
              try
                repeat
                  PhotoFileName := SRFile.Name;
                  PhotoPath := MonthDir + '\' + PhotoFileName;

                  PhotoB64 := FileToBase64(PhotoPath);
                  if PhotoB64 <> '' then
                  begin
                    JsonPayload := '{"token":"' + EscapeJson(Token) + '",' +
                                   '"action":"upload_photo",' +
                                   '"monthFolder":"' + EscapeJson(MonthName) + '",' +
                                   '"fileName":"' + EscapeJson(PhotoFileName) + '",' +
                                   '"fileBase64":"' + EscapeJson(PhotoB64) + '"}';
                    try
                      Resp := KirimJson(Url, JsonPayload);
                      if Pos('"status":"success"', Resp) > 0 then
                      begin
                        Inc(TotalUploadedPhotos);
                        TambahLog('  [+] Terunggah ke Drive /' + MonthName + '/: ' + PhotoFileName);
                      end
                      else if Pos('"status":"skipped"', Resp) > 0 then
                      begin
                        Inc(TotalSkippedPhotos);
                        TambahLog('  [=] Sudah ada di Drive (lewati): ' + PhotoFileName);
                      end
                      else
                      begin
                        TambahLog('  [!] Gagal: ' + PhotoFileName + ' -> ' + Resp);
                      end;
                    except
                      on E: Exception do
                        TambahLog('  [!] Gagal upload ' + PhotoFileName + ': ' + E.Message);
                    end;
                  end;
                until FindNext(SRFile) <> 0;
              finally
                FindClose(SRFile);
              end;
            end;
          end;
        until FindNext(SRMonth) <> 0;
      finally
        FindClose(SRMonth);
      end;
    end;
  end;

  Result := SuccessDb;

  // Catat riwayat backup
  Ini := TIniFile.Create(FConfigFile);
  try
    Ini.WriteString('GoogleDrive', 'LastBackupDate', FormatDateTime('yyyy-mm-dd', Now));
    Ini.WriteString('GoogleDrive', 'LastBackupTime', FormatDateTime('hh:nn:ss', Now));
    if SuccessDb then
    begin
      Ini.WriteString('GoogleDrive', 'LastBackupStatus', 'Berhasil: DB + ' + IntToStr(TotalUploadedPhotos) + ' foto baru');
      LblStatusTerakhir.Caption := 'Status Terakhir: ' + FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + ' (Berhasil)';
      TambahLog('=== SELESAI: Backup Google Drive Berhasil 100%! ===');
      TambahLog('Ringkasan: Database berhasil, ' + IntToStr(TotalUploadedPhotos) + ' foto baru diunggah, ' + IntToStr(TotalSkippedPhotos) + ' foto telah sinkron.');

      if not Silent then
        ShowMessage('SELESAI!' + sLineBreak + sLineBreak +
                    'Database inventaris dan seluruh foto bukti fisik berhasil' + sLineBreak +
                    'dicadangkan ke Google Drive Dinas (Folder: "backup").' + sLineBreak + sLineBreak +
                    '• Database: DatabaseDLH_' + FormatDateTime('yyyy-mm-dd', Now) + '.db' + sLineBreak +
                    '• Foto baru diunggah: ' + IntToStr(TotalUploadedPhotos) + ' file' + sLineBreak +
                    '• Foto sudah sinkron: ' + IntToStr(TotalSkippedPhotos) + ' file');
    end
    else
    begin
      Ini.WriteString('GoogleDrive', 'LastBackupStatus', 'Gagal upload database');
      TambahLog('=== GAGAL: Terjadi kendala saat upload database ke Google Drive ===');
      if not Silent then
        ShowMessage('Gagal mencadangkan ke Google Drive Dinas. Periksa koneksi internet Anda.');
    end;
  finally
    Ini.Free;
  end;
end;

procedure TForm9.BtnBackupCloudClick(Sender: TObject);
begin
  BtnBackupCloud.Enabled := False;
  BtnExportZip.Enabled := False;
  BtnTutup.Enabled := False;
  try
    LakukanBackupCloud(False);
  finally
    BtnBackupCloud.Enabled := True;
    BtnExportZip.Enabled := True;
    BtnTutup.Enabled := True;
  end;
end;

procedure TForm9.BtnExportZipClick(Sender: TObject);
var
  ZipFile: TZipFile;
  ZipDest, ExeDir, DbSource, ArsipBuktiDir, ArsipSuratDir: string;
  SRMonth, SRFile: TSearchRec;
  MonthDir: string;
begin
  SaveDialog1.Title := 'Pilih Lokasi Simpan File ZIP Cadangan (Flashdisk / Komputer)';
  SaveDialog1.FileName := 'Backup_Inventaris_DLH_' + FormatDateTime('yyyy-mm-dd_hhnn', Now) + '.zip';
  SaveDialog1.DefaultExt := 'zip';

  if SaveDialog1.Execute then
  begin
    ZipDest := SaveDialog1.FileName;
    ExeDir := ExtractFilePath(ParamStr(0));
    DbSource := ExeDir + 'DatabaseDLH.db';

    TambahLog('Mengekspor arsip ZIP lengkap ke: ' + ZipDest);

    ZipFile := TZipFile.Create;
    try
      if FileExists(ZipDest) then
        DeleteFile(ZipDest);

      ZipFile.Open(ZipDest, zmWrite);

      // 1. Masukkan Database
      if FileExists(DbSource) then
      begin
        ZipFile.Add(DbSource, 'DatabaseDLH.db');
        TambahLog('  -> Memasukkan DatabaseDLH.db ke ZIP...');
      end;

      // 2. Masukkan seluruh arsip_bukti
      ArsipBuktiDir := ExeDir + 'arsip_bukti';
      if DirectoryExists(ArsipBuktiDir) then
      begin
        if FindFirst(ArsipBuktiDir + '\*.*', faDirectory, SRMonth) = 0 then
        begin
          try
            repeat
              if (SRMonth.Name <> '.') and (SRMonth.Name <> '..') and ((SRMonth.Attr and faDirectory) <> 0) then
              begin
                MonthDir := ArsipBuktiDir + '\' + SRMonth.Name;
                if FindFirst(MonthDir + '\*.*', faAnyFile and not faDirectory, SRFile) = 0 then
                begin
                  try
                    repeat
                      ZipFile.Add(MonthDir + '\' + SRFile.Name, 'arsip_bukti\' + SRMonth.Name + '\' + SRFile.Name);
                    until FindNext(SRFile) <> 0;
                  finally
                    FindClose(SRFile);
                  end;
                end;
              end;
            until FindNext(SRMonth) <> 0;
          finally
            FindClose(SRMonth);
          end;
        end;
      end;

      // 3. Masukkan arsip_surat jika ada
      ArsipSuratDir := ExeDir + 'arsip_surat';
      if DirectoryExists(ArsipSuratDir) then
      begin
        if FindFirst(ArsipSuratDir + '\*.*', faAnyFile and not faDirectory, SRFile) = 0 then
        begin
          try
            repeat
              ZipFile.Add(ArsipSuratDir + '\' + SRFile.Name, 'arsip_surat\' + SRFile.Name);
            until FindNext(SRFile) <> 0;
          finally
            FindClose(SRFile);
          end;
        end;
      end;

      ZipFile.Close;
      TambahLog('-> SUKSES! File cadangan ZIP berhasil dibuat: ' + ZipDest);
      ShowMessage('SUKSES!' + sLineBreak + sLineBreak +
                  'Arsip ZIP inventaris lengkap berhasil dibuat di:' + sLineBreak +
                  ZipDest + sLineBreak + sLineBreak +
                  'File ini siap disimpan ke Flashdisk atau drive penyimpanan lokal.');
    finally
      ZipFile.Free;
    end;
  end;
end;

procedure TForm9.AutoBackupIfNeeded;
var
  Ini: TIniFile;
  LastDate, TodayDate: string;
  AutoB: Boolean;
begin
  Ini := TIniFile.Create(FConfigFile);
  try
    AutoB := Ini.ReadBool('GoogleDrive', 'AutoBackup', True);
    LastDate := Ini.ReadString('GoogleDrive', 'LastBackupDate', '');
    TodayDate := FormatDateTime('yyyy-mm-dd', Now);

    if AutoB and (LastDate <> TodayDate) then
    begin
      // Jalankan backup harian secara silent
      LakukanBackupCloud(True);
    end;
  finally
    Ini.Free;
  end;
end;

end.
