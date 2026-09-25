object Form9: TForm9
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Backup Cloud Google Drive Dinas & Lokal - DLH Banjarmasin'
  ClientHeight = 560
  ClientWidth = 620
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
    Width = 620
    Height = 560
    Align = alClient
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 0
    object PnlHeader: TPanel
      Left = 0
      Top = 0
      Width = 620
      Height = 55
      Align = alTop
      BevelOuter = bvNone
      Color = 3308846
      ParentBackground = False
      TabOrder = 0
      object LblJudul: TLabel
        Left = 20
        Top = 15
        Width = 320
        Height = 23
        Caption = 'Backup Cloud Google Drive Dinas'
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
      Width = 620
      Height = 505
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Top = 10
      Padding.Right = 15
      Padding.Bottom = 15
      ParentBackground = False
      TabOrder = 1
      object PnlInfo: TPanel
        Left = 15
        Top = 10
        Width = 590
        Height = 75
        Align = alTop
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object LblPenjelasan: TLabel
          Left = 12
          Top = 8
          Width = 560
          Height = 32
          AutoSize = False
          Caption = 
            'Mencadangkan database inventaris dan seluruh foto bukti fisik ta' +
            'nda terima basah langsung ke folder Google Drive Dinas tanpa har' +
            'us login akun dinas di komputer ini.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 3308846
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
        object LblStatusTerakhir: TLabel
          Left = 12
          Top = 48
          Width = 240
          Height = 15
          Caption = 'Status Terakhir: Belum pernah dicadangkan'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsItalic]
          ParentFont = False
        end
      end
      object PnlConfig: TPanel
        Left = 15
        Top = 90
        Width = 590
        Height = 155
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object LblUrl: TLabel
          Left = 12
          Top = 8
          Width = 197
          Height = 15
          Caption = 'URL Web App Google Drive Dinas:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EdtUrl: TEdit
          Left = 12
          Top = 26
          Width = 560
          Height = 23
          TabOrder = 0
          OnChange = EdtUrlChange
        end
        object LblToken: TLabel
          Left = 12
          Top = 56
          Width = 154
          Height = 15
          Caption = 'Token Keamanan (Secret):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EdtToken: TEdit
          Left = 12
          Top = 74
          Width = 560
          Height = 23
          PasswordChar = '*'
          TabOrder = 1
          OnChange = EdtTokenChange
        end
        object ChkAutoBackup: TCheckBox
          Left = 12
          Top = 110
          Width = 560
          Height = 25
          Caption = 'Auto-backup otomatis ke Google Drive setiap kali aplikasi dibuka (1x sehari)'
          Checked = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          State = cbChecked
          TabOrder = 2
          OnClick = ChkAutoBackupClick
        end
      end
      object PnlLog: TPanel
        Left = 15
        Top = 250
        Width = 590
        Height = 175
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        object LblLog: TLabel
          Left = 12
          Top = 6
          Width = 135
          Height = 15
          Caption = 'Log Aktivitas Cadangan:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object MemoLog: TMemo
          Left = 12
          Top = 24
          Width = 560
          Height = 140
          Color = 16316664
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Consolas'
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
      object PnlAksi: TPanel
        Left = 15
        Top = 432
        Width = 590
        Height = 55
        BevelOuter = bvNone
        TabOrder = 3
        object BtnBackupCloud: TButton
          Left = 0
          Top = 6
          Width = 265
          Height = 42
          Cursor = crHandPoint
          Caption = #9729'  Backup ke Google Drive Sekarang'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnClick = BtnBackupCloudClick
        end
        object BtnExportZip: TButton
          Left = 275
          Top = 6
          Width = 205
          Height = 42
          Cursor = crHandPoint
          Caption = #128190'  Ekspor ZIP ke Flashdisk'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnClick = BtnExportZipClick
        end
        object BtnTutup: TButton
          Left = 490
          Top = 6
          Width = 98
          Height = 42
          Cursor = crHandPoint
          Caption = 'Tutup'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = BtnTutupClick
        end
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'File Arsip ZIP (*.zip)|*.zip'
    Left = 530
    Top = 15
  end
end
