object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Riwayat Transaksi & Audit Log - DLH Banjarmasin'
  ClientHeight = 600
  ClientWidth = 1000
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object PnlBg: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 0
    object PnlHeader: TPanel
      Left = 0
      Top = 0
      Width = 1000
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      Color = 3308846
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        1000
        60)
      object LblJudul: TLabel
        Left = 20
        Top = 15
        Width = 277
        Height = 25
        Caption = 'Riwayat Transaksi & Audit Log'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnKembali: TButton
        Left = 870
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
      end
    end
    object PnlFilter: TPanel
      Left = 0
      Top = 60
      Width = 1000
      Height = 65
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      DesignSize = (
        1000
        65)
      object LblKategori: TLabel
        Left = 20
        Top = 10
        Width = 99
        Height = 15
        Caption = 'Kategori Riwayat:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblCari: TLabel
        Left = 240
        Top = 10
        Width = 73
        Height = 15
        Caption = 'Cari Riwayat:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblDari: TLabel
        Left = 470
        Top = 10
        Width = 72
        Height = 15
        Caption = 'Dari Tanggal:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblSampai: TLabel
        Left = 595
        Top = 10
        Width = 67
        Height = 15
        Caption = 's/d Tanggal:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CboJenisHistory: TComboBox
        Left = 20
        Top = 28
        Width = 205
        Height = 25
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = CboJenisHistoryChange
        Items.Strings = (
          'Semua Riwayat'
          'Barang Masuk (Inbound)'
          'Pengajuan & Barang Keluar (Outbound)')
      end
      object EdCariHistory: TEdit
        Left = 240
        Top = 28
        Width = 215
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = EdCariHistoryChange
      end
      object DTPDari: TDateTimePicker
        Left = 470
        Top = 28
        Width = 115
        Height = 25
        Date = 46279.000000000000000000
        Time = 0.000000000000000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnChange = DTPDariChange
      end
      object DTPSampai: TDateTimePicker
        Left = 595
        Top = 28
        Width = 115
        Height = 25
        Date = 46279.000000000000000000
        Time = 0.000000000000000000
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnChange = DTPSampaiChange
      end
      object ChkFilterTanggal: TCheckBox
        Left = 720
        Top = 31
        Width = 95
        Height = 20
        Caption = 'Aktifkan Filter'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = ChkFilterTanggalClick
      end
      object BtnCetak: TButton
        Left = 830
        Top = 24
        Width = 150
        Height = 32
        Anchors = [akTop, akRight]
        Caption = 'Export ke CSV / Excel'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = BtnCetakClick
      end
    end
    object GridHistory: TStringGrid
      Left = 0
      Top = 125
      Width = 1000
      Height = 425
      Align = alClient
      ColCount = 7
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      TabOrder = 2
      OnDblClick = GridHistoryDblClick
      ColWidths = (
        50
        100
        180
        160
        180
        110
        230)
    end
    object PnlFooter: TPanel
      Left = 0
      Top = 550
      Width = 1000
      Height = 50
      Align = alBottom
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
      object LblTotalRecord: TLabel
        Left = 20
        Top = 6
        Width = 236
        Height = 17
        Caption = 'Total Riwayat Ditemukan: 0 Transaksi'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblPetunjuk: TLabel
        Left = 20
        Top = 26
        Width = 478
        Height = 15
        Caption = 'Petunjuk: Double-click pada baris riwayat untuk melihat rincian transaksi secara lengkap.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
      end
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'File Excel (CSV)|*.csv'
    Title = 'Export Riwayat Transaksi Inventaris'
    Left = 400
    Top = 20
  end
end
