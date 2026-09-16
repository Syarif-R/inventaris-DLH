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
      Top = 29
      Width = 160
      Height = 45
      Cursor = crHandPoint
      Caption = '1. Barang Masuk'
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
      Top = 80
      Width = 160
      Height = 45
      Cursor = crHandPoint
      Caption = '2. Pengajuan Bidang'
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
      Caption = '3. Validasi & Arsip'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = BtnValidasiClick
    end
    object BtnHistory: TButton
      Left = 20
      Top = 182
      Width = 160
      Height = 45
      Cursor = crHandPoint
      Caption = '4. Riwayat Transaksi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = BtnHistoryClick
    end
    object BtnMaster: TButton
      Left = 20
      Top = 233
      Width = 160
      Height = 45
      Cursor = crHandPoint
      Caption = '5. Master Data Barang'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = BtnMasterClick
    end
    object BtnStockOpname: TButton
      Left = 20
      Top = 284
      Width = 160
      Height = 45
      Cursor = crHandPoint
      Caption = '6. Laporan Stock Opname'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = BtnStockOpnameClick
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
      Height = 450
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
          Control = ChartTanaman
          Row = 0
        end
        item
          Column = 1
          Control = ChartATK
          Row = 0
        end
        item
          Column = 0
          Control = ChartKertas
          Row = 1
        end
        item
          Column = 1
          Control = ChartKomputer
          Row = 1
        end>
      RowCollection = <
        item
          Value = 50.000000000000000000
        end
        item
          Value = 50.000000000000000000
        end>
      TabOrder = 0
      object ChartTanaman: TChart
        Left = 0
        Top = 0
        Width = 435
        Height = 225
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          '1. BAHAN / BIBIT TANAMAN')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
      object ChartATK: TChart
        Left = 435
        Top = 0
        Width = 435
        Height = 225
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          '2. ALAT TULIS KANTOR')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 1
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
      object ChartKertas: TChart
        Left = 0
        Top = 225
        Width = 435
        Height = 225
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          '3. KERTAS DAN COVER')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 2
        DefaultCanvas = 'TGDIPlusCanvas'
        ColorPaletteIndex = 13
      end
      object ChartKomputer: TChart
        Left = 435
        Top = 225
        Width = 435
        Height = 225
        Title.Font.Name = 'Segoe UI'
        Title.Font.Style = [fsBold]
        Title.Text.Strings = (
          '4. BAHAN KOMPUTER')
        View3D = False
        Align = alClient
        Color = clWhite
        TabOrder = 3
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
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object LblCari: TLabel
        Left = 5
        Top = 14
        Width = 70
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
        Left = 80
        Top = 10
        Width = 200
        Height = 25
        TabOrder = 0
        TextHint = 'Nama / Kode...'
        OnChange = EdCariChange
      end
      object LblKategori: TLabel
        Left = 290
        Top = 14
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
        Left = 345
        Top = 10
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
        Left = 500
        Top = 12
        Width = 145
        Height = 22
        Caption = 'Sembunyikan Stok 0'
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
        Left = 660
        Top = 8
        Width = 205
        Height = 30
        Anchors = [akTop, akRight]
        Caption = 'Download Excel (CSV)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = BtnDownloadClick
      end
    end
    object GridStok: TStringGrid
      Left = 15
      Top = 520
      Width = 870
      Height = 157
      Align = alClient
      ColCount = 6
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 3
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
