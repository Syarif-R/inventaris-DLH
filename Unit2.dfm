object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Input Barang Masuk - DLH Banjarmasin'
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
        Width = 335
        Height = 25
        Caption = 'Penerimaan Barang Masuk (Inbound)'
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
      object LblCariBarang: TLabel
        Left = 20
        Top = 15
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
        Top = 37
        Width = 300
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TextHint = 'Ketik nama atau kode barang (misal: peti)...'
        OnChange = EdCariBarangChange
      end
      object LblHasilCari: TLabel
        Left = 20
        Top = 65
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
        Top = 88
        Width = 105
        Height = 20
        Caption = '1. Pilih Barang:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CboBarang: TComboBox
        Left = 20
        Top = 110
        Width = 300
        Height = 28
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = CboBarangChange
      end
      object LblStokInfo: TLabel
        Left = 20
        Top = 142
        Width = 300
        Height = 20
        Caption = 'Stok Saat Ini: -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblJumlah: TLabel
        Left = 20
        Top = 170
        Width = 123
        Height = 20
        Caption = '2. Jumlah Masuk:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblSatuan: TLabel
        Left = 170
        Top = 170
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
      object EdtJumlah: TEdit
        Left = 20
        Top = 192
        Width = 130
        Height = 28
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        NumbersOnly = True
        ParentFont = False
        TabOrder = 2
        OnKeyPress = EdtJumlahKeyPress
      end
      object EdtSatuan: TEdit
        Left = 170
        Top = 192
        Width = 150
        Height = 28
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '-'
      end
      object BtnTambah: TButton
        Left = 20
        Top = 232
        Width = 300
        Height = 38
        Cursor = crHandPoint
        Caption = '+ Tambah ke Daftar Masuk'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = BtnTambahClick
      end
      object BtnHapusItem: TButton
        Left = 20
        Top = 277
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
        TabOrder = 5
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
        Caption = 'Daftar Barang Masuk'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 149
      end
      object GridMasuk: TStringGrid
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
        OnDblClick = GridMasukDblClick
        ExplicitWidth = 418
        ExplicitHeight = 422
        ColWidths = (
          50
          200
          80
          80)
      end
      object BtnSimpan: TButton
        Left = 20
        Top = 465
        Width = 420
        Height = 55
        Cursor = crHandPoint
        Align = alBottom
        Caption = 'Simpan Semua Barang Masuk'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = BtnSimpanClick
        ExplicitTop = 457
        ExplicitWidth = 418
      end
    end
  end
end
