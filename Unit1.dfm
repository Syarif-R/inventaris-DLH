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
    Caption = 'APLIKASI INVENTARIS DLH - KOTA BANJARMASIN'
    Color = 3308846
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -21
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
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
      TabOrder = 0
      OnClick = BtnSettingClick
    end
  end
  object PnlKiri: TPanel
    Left = 0
    Top = 80
    Width = 235
    Height = 870
    Align = alLeft
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
      Top = 390
      Width = 205
      Height = 195
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = 15267304
      ParentBackground = False
      TabOrder = 7
      object LblAlertJudul: TLabel
        Left = 10
        Top = 10
        Width = 185
        Height = 18
        Alignment = taCenter
        AutoSize = False
        Caption = 'STATUS && PERINGATAN'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3308846
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object BtnAlertStok: TButton
        Left = 10
        Top = 36
        Width = 185
        Height = 44
        Cursor = crHandPoint
        Caption = 'Barang Kritis: -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        WordWrap = True
        OnClick = BtnAlertStokClick
      end
      object BtnRefreshDashboard: TButton
        Left = 10
        Top = 88
        Width = 185
        Height = 44
        Cursor = crHandPoint
        Caption = 'Segarkan Status'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = BtnRefreshDashboardClick
      end
      object BtnToggleChart: TButton
        Left = 10
        Top = 140
        Width = 185
        Height = 44
        Cursor = crHandPoint
        Caption = 'Grafik: Penggunaan Bidang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        WordWrap = True
        OnClick = BtnToggleChartClick
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
    Padding.Left = 20
    Padding.Top = 18
    Padding.Right = 20
    Padding.Bottom = 18
    TabOrder = 2
    object PnlCharts: TGridPanel
      Left = 20
      Top = 18
      Width = 1325
      Height = 250
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
      TabOrder = 0
      object ChartKategori: TChart
        Left = 0
        Top = 0
        Width = 662
        Height = 250
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'TOTAL STOK PER KATEGORI PERSEDIAAN')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
      object ChartTopStok: TChart
        Left = 662
        Top = 0
        Width = 663
        Height = 250
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'TOP 7 BARANG STOK TERBANYAK (STOK > 0)')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 1
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
    end
    object PnlSpacer: TPanel
      Left = 20
      Top = 268
      Width = 1325
      Height = 12
      Align = alTop
      BevelOuter = bvNone
      Color = 16053998
      ParentBackground = False
      TabOrder = 1
    end
    object PnlCari: TPanel
      Left = 20
      Top = 280
      Width = 1325
      Height = 84
      Align = alTop
      BevelOuter = bvNone
      Color = 16053998
      ParentBackground = False
      TabOrder = 2
      object LblCari: TLabel
        Left = 5
        Top = 11
        Width = 66
        Height = 15
        Caption = 'Cari Barang:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EdCari: TEdit
        Left = 78
        Top = 8
        Width = 220
        Height = 25
        TabOrder = 0
        TextHint = 'Nama / Kode Rekening...'
        OnChange = EdCariChange
      end
      object LblKategori: TLabel
        Left = 315
        Top = 11
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
      object CmbKategori: TComboBox
        Left = 372
        Top = 8
        Width = 175
        Height = 25
        Style = csDropDownList
        TabOrder = 1
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
        Left = 565
        Top = 10
        Width = 150
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
        TabOrder = 2
        OnClick = ChkHideZeroClick
      end
      object BtnDownload: TButton
        Left = 1125
        Top = 6
        Width = 195
        Height = 28
        Anchors = [akTop, akRight]
        Caption = 'Download Excel (CSV)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = BtnDownloadClick
      end
      object BtnTambahBarang: TButton
        Left = 5
        Top = 44
        Width = 145
        Height = 32
        Cursor = crHandPoint
        Caption = '+ Tambah Barang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = BtnTambahBarangClick
      end
      object BtnEditBarang: TButton
        Left = 158
        Top = 44
        Width = 115
        Height = 32
        Cursor = crHandPoint
        Caption = 'Edit Barang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = BtnEditBarangClick
      end
      object BtnHapusBarang: TButton
        Left = 281
        Top = 44
        Width = 115
        Height = 32
        Cursor = crHandPoint
        Caption = 'Hapus Barang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = BtnHapusBarangClick
      end
      object BtnPenyesuaianStok: TButton
        Left = 404
        Top = 44
        Width = 230
        Height = 32
        Cursor = crHandPoint
        Caption = 'Penyesuaian Stok (Rusak/Hilang)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        OnClick = BtnPenyesuaianStokClick
      end
      object LblPetunjukGrid: TLabel
        Left = 648
        Top = 52
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
    end
    object GridStok: TStringGrid
      Left = 20
      Top = 364
      Width = 1325
      Height = 488
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 26
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 3
      OnDblClick = GridStokDblClick
      OnDrawCell = GridStokDrawCell
      ColWidths = (
        50
        170
        550
        190
        90
        120)
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 500
    Top = 300
  end
end
