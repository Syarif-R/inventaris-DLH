object Form10: TForm10
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Pengaturan Akun Cloud Google Drive - DLH Banjarmasin'
  ClientHeight = 510
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object PnlBg: TPanel
    Left = 0
    Top = 0
    Width = 640
    Height = 510
    Align = alClient
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 0
    object PnlHeader: TPanel
      Left = 0
      Top = 0
      Width = 640
      Height = 55
      Align = alTop
      BevelOuter = bvNone
      Color = 3308846
      ParentBackground = False
      TabOrder = 0
      object LblJudul: TLabel
        Left = 20
        Top = 15
        Width = 360
        Height = 23
        Caption = 'Pengaturan Akun Cloud && Sistem'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -17
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object PnlKonten: TPanel
      Left = 0
      Top = 55
      Width = 640
      Height = 455
      Align = alClient
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object GrpAkun: TGroupBox
        Left = 20
        Top = 15
        Width = 600
        Height = 240
        Caption = ' Informasi Akun Google Drive Dinas '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object LblDriveUrl: TLabel
          Left = 16
          Top = 26
          Width = 246
          Height = 15
          Caption = 'Link Folder Google Drive (Penyimpanan Cadangan):'
          Font.Style = []
        end
        object EdtDriveUrl: TEdit
          Left = 16
          Top = 46
          Width = 410
          Height = 26
          Font.Style = []
          TabOrder = 0
        end
        object BtnBukaDrive: TButton
          Left = 434
          Top = 45
          Width = 72
          Height = 28
          Cursor = crHandPoint
          Caption = 'Buka Web'
          Font.Style = [fsBold]
          TabOrder = 1
          OnClick = BtnBukaDriveClick
        end
        object BtnCopyDrive: TButton
          Left = 512
          Top = 45
          Width = 72
          Height = 28
          Cursor = crHandPoint
          Caption = 'Salin Link'
          Font.Style = [fsBold]
          TabOrder = 2
          OnClick = BtnCopyDriveClick
        end
        object LblEmail: TLabel
          Left = 16
          Top = 82
          Width = 127
          Height = 15
          Caption = 'Email Google Akun Dinas:'
          Font.Style = []
        end
        object EdtEmail: TEdit
          Left = 16
          Top = 102
          Width = 410
          Height = 26
          Font.Style = []
          TabOrder = 3
        end
        object BtnCopyEmail: TButton
          Left = 434
          Top = 101
          Width = 150
          Height = 28
          Cursor = crHandPoint
          Caption = 'Salin Email'
          Font.Style = [fsBold]
          TabOrder = 4
          OnClick = BtnCopyEmailClick
        end
        object LblPassword: TLabel
          Left = 16
          Top = 138
          Width = 111
          Height = 15
          Caption = 'Password Akun Dinas:'
          Font.Style = []
        end
        object EdtPassword: TEdit
          Left = 16
          Top = 158
          Width = 310
          Height = 26
          Font.Style = []
          PasswordChar = '*'
          TabOrder = 5
        end
        object BtnTogglePassword: TButton
          Left = 334
          Top = 157
          Width = 115
          Height = 28
          Cursor = crHandPoint
          Caption = 'Lihat Password'
          Font.Style = [fsBold]
          TabOrder = 6
          OnClick = BtnTogglePasswordClick
        end
        object BtnCopyPassword: TButton
          Left = 455
          Top = 157
          Width = 129
          Height = 28
          Cursor = crHandPoint
          Caption = 'Salin Password'
          Font.Style = [fsBold]
          TabOrder = 7
          OnClick = BtnCopyPasswordClick
        end
        object LblCatatan: TLabel
          Left = 16
          Top = 196
          Width = 560
          Height = 30
          AutoSize = False
          Caption = 
            'Catatan: Komputer ini dapat mencadangkan file ke Google Drive se' +
            'cara langsung tanpa login. Gunakan email && password di atas jik' +
            'a ingin login manual ke Google Drive di browser.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3308846
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsItalic]
          ParentFont = False
          WordWrap = True
        end
      end
      object GrpWebhook: TGroupBox
        Left = 20
        Top = 265
        Width = 600
        Height = 115
        Caption = ' Layanan Sinkronisasi Cloud (Google Apps Script) '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object LblWebhookUrl: TLabel
          Left = 16
          Top = 26
          Width = 175
          Height = 15
          Caption = 'Webhook Service Deployment URL:'
          Font.Style = []
        end
        object EdtWebhookUrl: TEdit
          Left = 16
          Top = 46
          Width = 430
          Height = 26
          Font.Style = []
          TabOrder = 0
        end
        object BtnBukaBackup: TButton
          Left = 454
          Top = 45
          Width = 130
          Height = 28
          Cursor = crHandPoint
          Caption = 'Menu Backup Drive'
          Font.Style = [fsBold]
          TabOrder = 1
          OnClick = BtnBukaBackupClick
        end
        object LblWebhookInfo: TLabel
          Left = 16
          Top = 82
          Width = 550
          Height = 15
          Caption = 
            'Webhook ini menghubungkan aplikasi langsung ke Google Drive dina' +
            's secara otomatis dan terenkripsi.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
        end
      end
      object PnlBawah: TPanel
        Left = 20
        Top = 390
        Width = 600
        Height = 50
        BevelOuter = bvNone
        Color = clWhitesmoke
        ParentBackground = False
        TabOrder = 2
        object BtnSimpan: TButton
          Left = 320
          Top = 6
          Width = 160
          Height = 38
          Cursor = crHandPoint
          Caption = 'Simpan Pengaturan'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BtnSimpanClick
        end
        object BtnTutup: TButton
          Left = 490
          Top = 6
          Width = 100
          Height = 38
          Cursor = crHandPoint
          Caption = 'Tutup'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = BtnTutupClick
        end
      end
    end
  end
end