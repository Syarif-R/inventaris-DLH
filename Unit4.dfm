object Form4: TForm4
  Left = 0
  Top = 0
  Caption = 'Validasi Arsip & Pemotongan Stok Fisik - DLH Banjarmasin'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object PnlBg: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 798
    ExplicitHeight = 592
    object PnlHeader: TPanel
      Left = 0
      Top = 0
      Width = 800
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      Color = 3308846
      ParentBackground = False
      TabOrder = 0
      ExplicitWidth = 798
      DesignSize = (
        800
        60)
      object LblJudul: TLabel
        Left = 20
        Top = 15
        Width = 333
        Height = 25
        Caption = 'Validasi Arsip & Pemotongan Stok Fisik'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnKembali: TButton
        Left = 670
        Top = 12
        Width = 110
        Height = 36
        Anchors = [akTop, akRight]
        Caption = '<- Kembali'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = BtnKembaliClick
        ExplicitLeft = 668
      end
    end
    object PnlKiri: TPanel
      Left = 0
      Top = 60
      Width = 460
      Height = 540
      Align = alLeft
      BevelOuter = bvNone
      Color = clWhitesmoke
      Padding.Left = 20
      Padding.Top = 15
      Padding.Right = 20
      Padding.Bottom = 20
      ParentBackground = False
      TabOrder = 1
      object LblPengajuan: TLabel
        Left = 20
        Top = 12
        Width = 420
        Height = 17
        Caption = 'Pilih Pengajuan Menunggu Validasi:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CboPengajuan: TComboBox
        Left = 20
        Top = 32
        Width = 420
        Height = 25
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = CboPengajuanChange
      end
      object LblDetailJudul: TLabel
        Left = 20
        Top = 64
        Width = 420
        Height = 17
        Caption = 'Daftar Barang yang Diajukan (Mohon Diperiksa):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3308846
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object GridDetailPengajuan: TStringGrid
        Left = 20
        Top = 84
        Width = 420
        Height = 145
        ColCount = 5
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 1
        ColWidths = (
          30
          180
          60
          60
          70)
      end
      object LblRingkasanDetail: TLabel
        Left = 20
        Top = 233
        Width = 420
        Height = 17
        Caption = 'Total: 0 Jenis Barang (0 Unit Fisik)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnCetakUlangSurat: TButton
        Left = 20
        Top = 255
        Width = 205
        Height = 36
        Cursor = crHandPoint
        Caption = 'Cetak / Lihat Surat'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = BtnCetakUlangSuratClick
      end
      object BtnTolakPengajuan: TButton
        Left = 235
        Top = 255
        Width = 205
        Height = 36
        Cursor = crHandPoint
        Caption = 'Tolak / Batalkan'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = BtnTolakPengajuanClick
      end
      object LblUpload: TLabel
        Left = 20
        Top = 300
        Width = 420
        Height = 17
        Caption = 'Upload Bukti Berkas Bertanda Tangan (PDF / Foto):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnUpload: TButton
        Left = 20
        Top = 322
        Width = 420
        Height = 38
        Cursor = crHandPoint
        Caption = 'Cari File PDF / Foto Dokumen...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = BtnUploadClick
      end
      object BtnResetFoto: TButton
        Left = 20
        Top = 364
        Width = 420
        Height = 30
        Cursor = crHandPoint
        Caption = 'Batal / Hapus Berkas'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = BtnResetFotoClick
      end
      object PnlStatus: TPanel
        Left = 20
        Top = 400
        Width = 420
        Height = 70
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clInfoBk
        ParentBackground = False
        TabOrder = 6
        object LblInfo: TLabel
          Left = 0
          Top = 0
          Width = 416
          Height = 66
          Align = alClient
          Caption = 
            'INFO: Pastikan rincian barang pada tabel cocok dengan fisik ' +
            'dokumen tanda terima sebelum melakukan pemotongan stok.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsItalic]
          ParentFont = False
          WordWrap = True
        end
      end
    end
    object PnlKanan: TPanel
      Left = 460
      Top = 60
      Width = 340
      Height = 540
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      Padding.Left = 20
      Padding.Top = 15
      Padding.Right = 20
      Padding.Bottom = 20
      ParentBackground = False
      TabOrder = 2
      ExplicitWidth = 458
      ExplicitHeight = 532
      object LblPreview: TLabel
        Left = 20
        Top = 15
        Width = 420
        Height = 17
        Align = alTop
        Caption = 'Pratinjau Dokumen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 120
      end
      object ImgBukti: TImage
        Left = 20
        Top = 32
        Width = 420
        Height = 438
        Cursor = crHandPoint
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
        OnClick = ImgBuktiClick
        ExplicitTop = 45
        ExplicitWidth = 400
        ExplicitHeight = 400
      end
      object BtnValidasi: TButton
        Left = 20
        Top = 470
        Width = 420
        Height = 50
        Cursor = crHandPoint
        Align = alBottom
        Caption = 'Validasi & Potong Stok Sekarang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = BtnValidasiClick
        ExplicitTop = 462
        ExplicitWidth = 418
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = 
      'Semua Dokumen Bukti (*.pdf;*.jpg;*.jpeg;*.png;*.bmp)|*.pdf;*.jpg' +
      ';*.jpeg;*.png;*.bmp|Dokumen Scan PDF (*.pdf)|*.pdf|File Foto / G' +
      'ambar (*.jpg;*.jpeg;*.png;*.bmp)|*.jpg;*.jpeg;*.png;*.bmp|Semua ' +
      'File (*.*)|*.*'
    Left = 400
    Top = 20
  end
end
