unit Unit10;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IniFiles;

type
  TForm10 = class(TForm)
    PnlBg: TPanel;
    PnlHeader: TPanel;
    LblJudul: TLabel;
    PnlKonten: TPanel;
    GrpAkun: TGroupBox;
    LblDriveUrl: TLabel;
    EdtDriveUrl: TEdit;
    BtnBukaDrive: TButton;
    BtnCopyDrive: TButton;
    LblEmail: TLabel;
    EdtEmail: TEdit;
    BtnCopyEmail: TButton;
    LblPassword: TLabel;
    EdtPassword: TEdit;
    BtnTogglePassword: TButton;
    BtnCopyPassword: TButton;
    LblCatatan: TLabel;
    GrpWebhook: TGroupBox;
    LblWebhookUrl: TLabel;
    EdtWebhookUrl: TEdit;
    BtnBukaBackup: TButton;
    LblWebhookInfo: TLabel;
    PnlBawah: TPanel;
    BtnSimpan: TButton;
    BtnTutup: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnBukaDriveClick(Sender: TObject);
    procedure BtnCopyDriveClick(Sender: TObject);
    procedure BtnCopyEmailClick(Sender: TObject);
    procedure BtnTogglePasswordClick(Sender: TObject);
    procedure BtnCopyPasswordClick(Sender: TObject);
    procedure BtnBukaBackupClick(Sender: TObject);
    procedure BtnSimpanClick(Sender: TObject);
    procedure BtnTutupClick(Sender: TObject);
  private
    FConfigFile: string;
    procedure LoadConfig;
    procedure SaveConfig;
  public
  end;

var
  Form10: TForm10;

implementation

uses
  Winapi.ShellAPI, Vcl.Clipbrd, Unit9;

{$R *.dfm}

const
  DEFAULT_DRIVE_URL = 'https://drive.google.com/drive/folders/1ujJRecUFp5KL4WA77YpwgJax4Lny0QO7?usp=sharing';
  DEFAULT_EMAIL = 'inventarisdlh1082026@gmail.com';
  DEFAULT_PASSWORD = '1november2026';
  DEFAULT_WEBHOOK_URL = 'https://script.google.com/macros/s/AKfycbxWhgDlgKnelkNMNclTC7CmQT5hWknAPejDZH2W2WcLViRMx3MvszNM_ZUMqSCFc1rWog/exec';

procedure TForm10.FormCreate(Sender: TObject);
begin
  FConfigFile := ExtractFilePath(ParamStr(0)) + 'Config.ini';
  LoadConfig;
end;

procedure TForm10.FormShow(Sender: TObject);
begin
  LoadConfig;
  EdtPassword.PasswordChar := '*';
  BtnTogglePassword.Caption := 'Lihat Password';
end;

procedure TForm10.LoadConfig;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FConfigFile);
  try
    EdtDriveUrl.Text := Ini.ReadString('GoogleDrive', 'FolderUrl', DEFAULT_DRIVE_URL);
    EdtEmail.Text := Ini.ReadString('GoogleDrive', 'Email', DEFAULT_EMAIL);
    EdtPassword.Text := Ini.ReadString('GoogleDrive', 'Password', DEFAULT_PASSWORD);
    EdtWebhookUrl.Text := Ini.ReadString('GoogleDrive', 'WebhookUrl', DEFAULT_WEBHOOK_URL);
  finally
    Ini.Free;
  end;
end;

procedure TForm10.SaveConfig;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FConfigFile);
  try
    Ini.WriteString('GoogleDrive', 'FolderUrl', Trim(EdtDriveUrl.Text));
    Ini.WriteString('GoogleDrive', 'Email', Trim(EdtEmail.Text));
    Ini.WriteString('GoogleDrive', 'Password', Trim(EdtPassword.Text));
    Ini.WriteString('GoogleDrive', 'WebhookUrl', Trim(EdtWebhookUrl.Text));
  finally
    Ini.Free;
  end;
end;

procedure TForm10.BtnBukaDriveClick(Sender: TObject);
var
  Url: string;
begin
  Url := Trim(EdtDriveUrl.Text);
  if Url = '' then
  begin
    ShowMessage('Link folder Google Drive masih kosong!');
    Exit;
  end;
  ShellExecute(0, 'open', PChar(Url), nil, nil, SW_SHOWNORMAL);
end;

procedure TForm10.BtnCopyDriveClick(Sender: TObject);
begin
  Clipboard.AsText := Trim(EdtDriveUrl.Text);
  ShowMessage('Link folder Google Drive berhasil disalin ke clipboard!');
end;

procedure TForm10.BtnCopyEmailClick(Sender: TObject);
begin
  Clipboard.AsText := Trim(EdtEmail.Text);
  ShowMessage('Email akun dinas berhasil disalin ke clipboard!');
end;

procedure TForm10.BtnTogglePasswordClick(Sender: TObject);
begin
  if EdtPassword.PasswordChar = '*' then
  begin
    EdtPassword.PasswordChar := #0;
    BtnTogglePassword.Caption := 'Sembunyikan';
  end
  else
  begin
    EdtPassword.PasswordChar := '*';
    BtnTogglePassword.Caption := 'Lihat Password';
  end;
end;

procedure TForm10.BtnCopyPasswordClick(Sender: TObject);
begin
  Clipboard.AsText := EdtPassword.Text;
  ShowMessage('Password akun dinas berhasil disalin ke clipboard!');
end;

procedure TForm10.BtnBukaBackupClick(Sender: TObject);
begin
  Form9.ShowModal;
end;

procedure TForm10.BtnSimpanClick(Sender: TObject);
begin
  SaveConfig;
  ShowMessage('Pengaturan akun cloud dan sistem berhasil disimpan ke Config.ini!');
end;

procedure TForm10.BtnTutupClick(Sender: TObject);
begin
  Close;
end;

end.