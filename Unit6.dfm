object Form6: TForm6
  Left = 0
  Top = 0
  Caption = 'Kelola Master Data Barang - DLH Banjarmasin'
  ClientHeight = 600
  ClientWidth = 900
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
    Width = 900
    Height = 600
    Align = alClient
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 0
    object PnlHeader: TPanel
      Left = 0
      Top = 0
      Width = 900
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      Color = 3308846
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        900
        60)
      object LblJudul: TLabel
        Left = 20
        Top = 15
        Width = 370
        Height = 25
        Caption = 'Kelola Master Data Barang (Tambah, Edit, Hapus)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnKembali: TButton
        Left = 770
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
    object PnlKiri: TPanel
      Left = 0
      Top = 60
      Width = 360
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
      object LblKode: TLabel
        Left = 20
        Top = 15
        Width = 113
        Height = 17
        Caption = 'Kode Rekening Bar:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EdtKode: TEdit
        Left = 20
        Top = 35
        Width = 320
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnKeyPress = EdtKodeKeyPress
      end
      object LblNama: TLabel
        Left = 20
        Top = 70
        Width = 152
        Height = 17
        Caption = 'Nama Barang / Persediaan:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EdtNama: TEdit
        Left = 20
        Top = 90
        Width = 320
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object LblKategori: TLabel
        Left = 20
        Top = 125
        Width = 99
        Height = 17
        Caption = 'Kategori Barang:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CboKategori: TComboBox
        Left = 20
        Top = 145
        Width = 320
        Height = 25
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnChange = CboKategoriChange
      end
      object LblSatuan: TLabel
        Left = 20
        Top = 180
        Width = 91
        Height = 17
        Caption = 'Satuan Barang:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EdtSatuan: TEdit
        Left = 20
        Top = 200
        Width = 150
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object LblStok: TLabel
        Left = 190
        Top = 180
        Width = 104
        Height = 17
        Caption = 'Stok Sisa / Awal:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object EdtStok: TEdit
        Left = 190
        Top = 200
        Width = 150
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        NumbersOnly = True
        ParentFont = False
        TabOrder = 4
      end
      object BtnTambah: TButton
        Left = 20
        Top = 245
        Width = 320
        Height = 38
        Cursor = crHandPoint
        Caption = '+ Tambah Barang Baru'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnClick = BtnTambahClick
      end
      object BtnEdit: TButton
        Left = 20
        Top = 290
        Width = 155
        Height = 36
        Cursor = crHandPoint
        Caption = 'Simpan Edit'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnClick = BtnEditClick
      end
      object BtnHapus: TButton
        Left = 185
        Top = 290
        Width = 155
        Height = 36
        Cursor = crHandPoint
        Caption = 'Hapus Barang'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 7
        OnClick = BtnHapusClick
      end
      object BtnBatal: TButton
        Left = 20
        Top = 335
        Width = 320
        Height = 32
        Cursor = crHandPoint
        Caption = 'Batal / Reset Form'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
        OnClick = BtnBatalClick
      end
    end
    object PnlKanan: TPanel
      Left = 360
      Top = 60
      Width = 540
      Height = 540
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      Padding.Left = 15
      Padding.Top = 15
      Padding.Right = 15
      Padding.Bottom = 15
      ParentBackground = False
      TabOrder = 2
      object PnlCariMaster: TPanel
        Left = 15
        Top = 15
        Width = 510
        Height = 40
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        object LblCariMaster: TLabel
          Left = 5
          Top = 10
          Width = 26
          Height = 15
          Caption = 'Cari:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object EdCariMaster: TEdit
          Left = 36
          Top = 7
          Width = 140
          Height = 25
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          TextHint = 'Nama/Kode...'
          OnChange = EdCariMasterChange
        end
        object LblKatFilterMaster: TLabel
          Left = 184
          Top = 10
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
        object CmbKatFilterMaster: TComboBox
          Left = 238
          Top = 7
          Width = 130
          Height = 25
          Style = csDropDownList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnChange = CmbKatFilterMasterChange
          Items.Strings = (
            'Semua Kategori'
            'ATK'
            'Bahan Komputer'
            'Bibit Tanaman'
            'Kertas & Cover'
            'Persediaan Masyarakat')
        end
        object ChkHideZeroMaster: TCheckBox
          Left = 375
          Top = 9
          Width = 130
          Height = 22
          Caption = 'Sembunyikan Stok 0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          OnClick = ChkHideZeroMasterClick
        end
      end
      object GridMaster: TStringGrid
        Left = 15
        Top = 55
        Width = 510
        Height = 470
        Align = alClient
        ColCount = 6
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 1
        OnClick = GridMasterClick
        ColWidths = (
          40
          130
          180
          110
          70
          70)
      end
    end
  end
end
