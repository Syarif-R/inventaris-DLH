object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 752
  ClientWidth = 1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnResize = FormResize
  TextHeight = 15
  object PnlAtas: TPanel
    Left = 0
    Top = 0
    Width = 1100
    Height = 60
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
  end
  object PnlKiri: TPanel
    Left = 0
    Top = 60
    Width = 200
    Height = 692
    Align = alLeft
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 1
    object BtnMasuk: TButton
      Left = 20
      Top = 25
      Width = 160
      Height = 45
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
      Left = 20
      Top = 78
      Width = 160
      Height = 45
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
      Left = 20
      Top = 131
      Width = 160
      Height = 45
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
      Left = 20
      Top = 184
      Width = 160
      Height = 45
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
      Left = 20
      Top = 237
      Width = 160
      Height = 45
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
      Left = 20
      Top = 290
      Width = 160
      Height = 45
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
    object PnlAlertBox: TPanel
      Left = 12
      Top = 350
      Width = 176
      Height = 135
      BevelKind = bkFlat
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 6
      object LblAlertJudul: TLabel
        Left = 10
        Top = 8
        Width = 156
        Height = 15
        Alignment = taCenter
        AutoSize = False
        Caption = 'STATUS && PERINGATAN'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 3308846
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ShowAccelChar = False
      end
      object BtnAlertStok: TButton
        Left = 8
        Top = 28
        Width = 156
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
        Left = 8
        Top = 78
        Width = 156
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
    end
  end
  object PnlUtama: TPanel
    Left = 200
    Top = 60
    Width = 900
    Height = 692
    Align = alClient
    BevelOuter = bvNone
    Padding.Left = 15
    Padding.Top = 15
    Padding.Right = 15
    Padding.Bottom = 15
    TabOrder = 2
    object PnlCharts: TGridPanel
      Left = 15
      Top = 15
      Width = 870
      Height = 220
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
        Width = 435
        Height = 220
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
        Left = 435
        Top = 0
        Width = 435
        Height = 220
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          'TOP BARANG STOK TERBANYAK (STOK > 0)')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 1
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
    end
    object PnlSpacer: TPanel
      Left = 15
      Top = 465
      Width = 870
      Height = 10
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
    object PnlCari: TPanel
      Left = 15
      Top = 475
      Width = 870
      Height = 82
      Align = alTop
      BevelOuter = bvNone
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
        Width = 175
        Height = 25
        TabOrder = 0
        TextHint = 'Nama / Kode...'
        OnChange = EdCariChange
      end
      object LblKategori: TLabel
        Left = 265
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
        Left = 320
        Top = 8
        Width = 145
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
        Left = 478
        Top = 10
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
        TabOrder = 2
        OnClick = ChkHideZeroClick
      end
      object BtnDownload: TButton
        Left = 670
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
        Top = 42
        Width = 135
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
        Left = 146
        Top = 42
        Width = 110
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
        Left = 262
        Top = 42
        Width = 110
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
      object LblPetunjukGrid: TLabel
        Left = 385
        Top = 50
        Width = 270
        Height = 15
        Caption = '* Klik baris tabel untuk Edit / Hapus barang master'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
      end
    end
    object GridStok: TStringGrid
      Left = 15
      Top = 557
      Width = 870
      Height = 120
      Align = alClient
      ColCount = 6
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 3
      OnDblClick = GridStokDblClick
      ColWidths = (
        40
        160
        220
        120
        80
        100)
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 500
    Top = 300
  end
end
