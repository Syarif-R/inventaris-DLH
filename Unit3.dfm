object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Pengajuan & Distribusi Barang (Outbound) - DLH Banjarmasin'
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
  OnResize = FormResize
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
        Width = 369
        Height = 25
        Caption = 'Pengajuan & Distribusi Barang (Outbound)'
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
      Width = 340
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
      ExplicitHeight = 532
      object LblBidang: TLabel
        Left = 20
        Top = 15
        Width = 124
        Height = 20
        Caption = 'Bidang Pemohon:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblCariBarang: TLabel
        Left = 20
        Top = 75
        Width = 120
        Height = 17
        Caption = 'Cari Barang (Ketik):'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EdCariBarang: TEdit
        Left = 20
        Top = 95
        Width = 300
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TextHint = 'Ketik nama atau kode barang (misal: peti)...'
        OnChange = EdCariBarangChange
      end
      object LblHasilCari: TLabel
        Left = 20
        Top = 123
        Width = 300
        Height = 15
        Caption = '[Info] Ketik nama/kode barang di atas untuk mencari.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblBarang: TLabel
        Left = 20
        Top = 145
        Width = 88
        Height = 20
        Caption = 'Pilih Barang:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CboBarang: TComboBox
        Left = 20
        Top = 168
        Width = 300
        Height = 28
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnChange = CboBarangChange
      end
      object LblStokInfo: TLabel
        Left = 20
        Top = 200
        Width = 300
        Height = 20
        Caption = 'Sisa Stok Gudang: -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblJumlah: TLabel
        Left = 20
        Top = 228
        Width = 115
        Height = 20
        Caption = 'Jumlah Diminta:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblSatuan: TLabel
        Left = 170
        Top = 228
        Width = 48
        Height = 20
        Caption = 'Satuan:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object CboBidang: TComboBox
        Left = 20
        Top = 38
        Width = 300
        Height = 28
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnChange = CboBidangChange
      end
      object EdtJumlah: TEdit
        Left = 20
        Top = 250
        Width = 130
        Height = 28
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        NumbersOnly = True
        ParentFont = False
        TabOrder = 3
        OnKeyPress = EdtJumlahKeyPress
      end
      object EdtSatuan: TEdit
        Left = 170
        Top = 250
        Width = 150
        Height = 28
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        Text = '-'
      end
      object BtnTambah: TButton
        Left = 20
        Top = 290
        Width = 300
        Height = 38
        Cursor = crHandPoint
        Caption = '+ Masukkan ke Keranjang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = BtnTambahClick
      end
      object BtnHapusItem: TButton
        Left = 20
        Top = 335
        Width = 300
        Height = 35
        Cursor = crHandPoint
        Caption = '- Hapus Item Keranjang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = BtnHapusItemClick
      end
    end
    object PnlKanan: TPanel
      Left = 340
      Top = 60
      Width = 460
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
      object LblDaftar: TLabel
        Left = 20
        Top = 15
        Width = 420
        Height = 20
        Align = alTop
        Caption = 'Keranjang Permintaan Barang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 210
      end
      object GridKeranjang: TStringGrid
        Left = 20
        Top = 35
        Width = 420
        Height = 430
        Align = alClient
        ColCount = 4
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 0
        OnDblClick = GridKeranjangDblClick
        ExplicitWidth = 418
        ExplicitHeight = 422
        ColWidths = (
          50
          200
          80
          80)
      end
      object BtnSimpanCetak: TButton
        Left = 20
        Top = 465
        Width = 420
        Height = 55
        Cursor = crHandPoint
        Align = alBottom
        Caption = 'Simpan & Cetak Surat Tanda Terima'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = BtnSimpanCetakClick
        ExplicitTop = 457
        ExplicitWidth = 418
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 400
    Top = 20
  end
end
