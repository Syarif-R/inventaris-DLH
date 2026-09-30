object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'APLIKASI INVENTARIS DLH - KOTA BANJARMASIN'
  ClientHeight = 950
  ClientWidth = 1600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object PnlAtas: TPanel
    Left = 0
    Top = 0
    Width = 1600
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Color = 3308846
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      1600
      80)
    object LblLogo: TLabel
      Left = 16
      Top = 14
      Width = 40
      Height = 40
      Alignment = taCenter
      AutoSize = False
      Caption = 'DLH'
      Color = 2854702
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
    end
    object LblAppTitle: TLabel
      Left = 64
      Top = 10
      Width = 200
      Height = 22
      Caption = 'INVENTARIS'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -18
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblAppSubtitle: TLabel
      Left = 64
      Top = 34
      Width = 120
      Height = 15
      Caption = 'Kota Banjarmasin'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11599860
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object LblDashboardTitle: TLabel
      Left = 280
      Top = 14
      Width = 200
      Height = 25
      Caption = 'Dashboard Utama'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblDashboardSub: TLabel
      Left = 280
      Top = 44
      Width = 380
      Height = 15
      Caption = 'Ringkasan stok persediaan DLH '#8212' diperbarui hari ini'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11599860
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
    end
    object EdCari: TEdit
      Left = 960
      Top = 24
      Width = 280
      Height = 30
      Anchors = [akTop, akRight]
      TabOrder = 0
      TextHint = 'Cari barang... (Nama / Kode)'
      OnChange = EdCariChange
    end
    object BtnSetting: TButton
      Left = 1460
      Top = 22
      Width = 110
      Height = 36
      Anchors = [akTop, akRight]
      Cursor = crHandPoint
      Caption = 'Setting'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = BtnSettingClick
    end
  end
  object PnlKiri: TPanel
    Left = 0
    Top = 80
    Width = 235
    Height = 870
    Align = alLeft
    BevelOuter = bvNone
    Color = 16514043
    ParentBackground = False
    TabOrder = 1
    object BtnMasuk: TButton
      Left = 15
      Top = 20
      Width = 205
      Height = 44
      Cursor = crHandPoint
      Caption = 'Barang Masuk'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BtnMasukClick
    end
    object BtnPengajuan: TButton
      Left = 15
      Top = 72
      Width = 205
      Height = 44
      Cursor = crHandPoint
      Caption = 'Pengajuan Bidang'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = BtnPengajuanClick
    end
    object BtnValidasi: TButton
      Left = 15
      Top = 124
      Width = 205
      Height = 44
      Cursor = crHandPoint
      Caption = 'Validasi Pengajuan'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      WordWrap = True
      OnClick = BtnValidasiClick
    end
    object BtnArsipValidasi: TButton
      Left = 15
      Top = 176
      Width = 205
      Height = 44
      Cursor = crHandPoint
      Caption = 'Arsip Dokumen Fisik'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      WordWrap = True
      OnClick = BtnArsipValidasiClick
    end
    object BtnHistory: TButton
      Left = 15
      Top = 228
      Width = 205
      Height = 44
      Cursor = crHandPoint
      Caption = 'Riwayat Transaksi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = BtnHistoryClick
    end
    object BtnStockOpname: TButton
      Left = 15
      Top = 280
      Width = 205
      Height = 44
      Cursor = crHandPoint
      Caption = 'Laporan Stock Opname'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = BtnStockOpnameClick
    end
    object BtnBackup: TButton
      Left = 15
      Top = 332
      Width = 205
      Height = 44
      Cursor = crHandPoint
      Caption = 'Backup Cloud Drive'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = BtnBackupClick
    end
    object PnlAlertBox: TPanel
      Left = 15
      Top = 670
      Width = 205
      Height = 120
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = 15267304
      ParentBackground = False
      TabOrder = 7
      object LblAlertJudul: TLabel
        Left = 10
        Top = 8
        Width = 185
        Height = 15
        Alignment = taCenter
        AutoSize = False
        Caption = 'PERINGATAN'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3308846
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object BtnAlertStok: TButton
        Left = 10
        Top = 30
        Width = 185
        Height = 38
        Cursor = crHandPoint
        Caption = '5 Barang Kritis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        WordWrap = True
        OnClick = BtnAlertStokClick
      end
      object BtnRefreshDashboard: TButton
        Left = 10
        Top = 76
        Width = 185
        Height = 34
        Cursor = crHandPoint
        Caption = 'Segarkan Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = BtnRefreshDashboardClick
      end
    end
  end
  object PnlUtama: TPanel
    Left = 235
    Top = 80
    Width = 1365
    Height = 870
    Align = alClient
    BevelOuter = bvNone
    Color = 16053998
    ParentBackground = False
    Padding.Left = 16
    Padding.Top = 12
    Padding.Right = 16
    Padding.Bottom = 12
    TabOrder = 2
    object PnlStatCards: TPanel
      Left = 16
      Top = 12
      Width = 1333
      Height = 78
      Align = alTop
      BevelOuter = bvNone
      Color = 16053998
      ParentBackground = False
      TabOrder = 0
      object LblStatJenisTitle: TLabel
        Left = 15
        Top = 10
        Width = 100
        Height = 15
        Caption = 'Total Jenis Barang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object LblStatJenisValue: TLabel
        Left = 15
        Top = 30
        Width = 60
        Height = 32
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblStatStokTitle: TLabel
        Left = 348
        Top = 10
        Width = 60
        Height = 15
        Caption = 'Total Stok'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object LblStatStokValue: TLabel
        Left = 348
        Top = 30
        Width = 60
        Height = 32
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblStatKritisTitle: TLabel
        Left = 681
        Top = 10
        Width = 80
        Height = 15
        Caption = 'Barang Kritis'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object LblStatKritisValue: TLabel
        Left = 681
        Top = 30
        Width = 60
        Height = 32
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblStatTrxTitle: TLabel
        Left = 1014
        Top = 10
        Width = 120
        Height = 15
        Caption = 'Transaksi Bulan Ini'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object LblStatTrxValue: TLabel
        Left = 1014
        Top = 30
        Width = 60
        Height = 32
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -24
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object PnlCharts: TGridPanel
      Left = 16
      Top = 90
      Width = 1333
      Height = 235
      Align = alTop
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = ChartKategori
          Row = 0
        end
        item
          Column = 1
          Control = ChartTopStok
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 1
      object ChartKategori: TChart
        Left = 0
        Top = 0
        Width = 666
        Height = 235
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Total Stok per Kategori Persediaan')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
      object ChartTopStok: TChart
        Left = 666
        Top = 0
        Width = 667
        Height = 235
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'Top 7 Barang Stok Terbanyak (Stok > 0)')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 1
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
    end
    object PnlSpacer: TPanel
      Left = 16
      Top = 325
      Width = 1333
      Height = 8
      Align = alTop
      BevelOuter = bvNone
      Color = 16053998
      ParentBackground = False
      TabOrder = 2
    end
    object PnlCari: TPanel
      Left = 16
      Top = 333
      Width = 1333
      Height = 72
      Align = alTop
      BevelOuter = bvNone
      Color = 16053998
      ParentBackground = False
      TabOrder = 3
      DesignSize = (
        1333
        72)
      object LblDaftarPersediaan: TLabel
        Left = 5
        Top = 6
        Width = 170
        Height = 20
        Caption = 'Daftar Persediaan'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblKategori: TLabel
        Left = 5
        Top = 42
        Width = 50
        Height = 15
        Caption = 'Kategori:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblPetunjukGrid: TLabel
        Left = 560
        Top = 44
        Width = 240
        Height = 15
        Caption = '* Klik baris untuk Edit/Hapus/Penyesuaian'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
      end
      object CmbKategori: TComboBox
        Left = 62
        Top = 40
        Width = 155
        Height = 25
        Style = csDropDownList
        TabOrder = 0
        OnChange = CmbKategoriChange
        Items.Strings = (
          'Semua Kategori'
          'ATK'
          'Bahan Komputer'
          'Bibit Tanaman'
          'Kertas & Cover'
          'Persediaan Masyarakat')
      end
      object ChkHideZero: TCheckBox
        Left = 228
        Top = 42
        Width = 140
        Height = 22
        Caption = 'Sembunyikan Stok 0'
        Checked = True
        State = cbChecked
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = ChkHideZeroClick
      end
      object BtnTambahBarang: TButton
        Left = 930
        Top = 4
        Width = 150
        Height = 30
        Anchors = [akTop, akRight]
        Cursor = crHandPoint
        Caption = '+ Tambah Barang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = BtnTambahBarangClick
      end
      object BtnDownload: TButton
        Left = 1130
        Top = 4
        Width = 195
        Height = 30
        Anchors = [akTop, akRight]
        Caption = 'Download CSV'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = BtnDownloadClick
      end
      object BtnEditBarang: TButton
        Left = 380
        Top = 40
        Width = 80
        Height = 26
        Cursor = crHandPoint
        Caption = 'Edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = BtnEditBarangClick
      end
      object BtnHapusBarang: TButton
        Left = 468
        Top = 40
        Width = 80
        Height = 26
        Cursor = crHandPoint
        Caption = 'Hapus'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = BtnHapusBarangClick
      end
      object BtnPenyesuaianStok: TButton
        Left = 930
        Top = 40
        Width = 200
        Height = 26
        Anchors = [akTop, akRight]
        Cursor = crHandPoint
        Caption = 'Penyesuaian Stok (Rusak/Hilang)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = BtnPenyesuaianStokClick
      end
      object BtnToggleChart: TButton
        Left = 1140
        Top = 40
        Width = 185
        Height = 26
        Anchors = [akTop, akRight]
        Cursor = crHandPoint
        Caption = 'Grafik: Penggunaan Bidang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -10
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        WordWrap = True
        OnClick = BtnToggleChartClick
      end
    end
    object GridStok: TStringGrid
      Left = 16
      Top = 405
      Width = 1333
      Height = 453
      Align = alClient
      ColCount = 7
      DefaultRowHeight = 26
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 4
      OnDblClick = GridStokDblClick
      OnDrawCell = GridStokDrawCell
      ColWidths = (
        40
        170
        440
        140
        70
        80
        80)
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 500
    Top = 300
  end
end
