object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Penerimaan Barang Masuk (Inbound dari Pusat) - DLH Banjarmasin'
  ClientHeight = 650
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
    Height = 650
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
        Width = 435
        Height = 25
        Caption = 'Penerimaan Barang Masuk (Inbound dari Pusat)'
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
      Height = 55
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object LblCari: TLabel
        Left = 20
        Top = 18
        Width = 98
        Height = 15
        Caption = 'Cari Cepat Barang:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblKategori: TLabel
        Left = 370
        Top = 18
        Width = 51
        Height = 15
        Caption = 'Kategori:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblPetunjukCepat: TLabel
        Left = 750
        Top = 18
        Width = 230
        Height = 15
        Caption = '💡 Klik barang di tabel, lalu atur di panel kanan.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        ParentFont = False
      end
      object EdCari: TEdit
        Left = 125
        Top = 14
        Width = 230
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        TextHint = 'Ketik nama / kode barang...'
        OnChange = EdCariChange
      end
      object CboKategori: TComboBox
        Left = 430
        Top = 14
        Width = 150
        Height = 25
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = CboKategoriChange
      end
      object BtnResetCari: TButton
        Left = 590
        Top = 13
        Width = 145
        Height = 27
        Caption = 'Tampilkan Semua'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = BtnResetCariClick
      end
    end
    object PnlBawah: TPanel
      Left = 0
      Top = 585
      Width = 1000
      Height = 65
      Align = alBottom
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      DesignSize = (
        1000
        65)
      object LblRingkasanMasuk: TLabel
        Left = 20
        Top = 22
        Width = 358
        Height = 20
        Caption = 'Total Barang Masuk yang Diisi: 0 Jenis (0 Unit Fisik)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -15
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnResetSemua: TButton
        Left = 560
        Top = 15
        Width = 135
        Height = 36
        Anchors = [akTop, akRight]
        Cursor = crHandPoint
        Caption = 'Reset Semua Nilai'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnClick = BtnResetSemuaClick
      end
      object BtnSimpan: TButton
        Left = 710
        Top = 10
        Width = 270
        Height = 45
        Anchors = [akTop, akRight]
        Cursor = crHandPoint
        Caption = 'Simpan Semua Barang Masuk'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -14
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnClick = BtnSimpanClick
      end
    end
    object PnlTengah: TPanel
      Left = 0
      Top = 115
      Width = 1000
      Height = 470
      Align = alClient
      BevelOuter = bvNone
      Color = clWhitesmoke
      ParentBackground = False
      TabOrder = 3
      object PnlKontelKanan: TPanel
        Left = 680
        Top = 0
        Width = 320
        Height = 470
        Align = alRight
        BevelOuter = bvNone
        Color = clWhitesmoke
        Padding.Left = 15
        Padding.Top = 10
        Padding.Right = 15
        Padding.Bottom = 15
        ParentBackground = False
        TabOrder = 0
        object LblPanelKananJudul: TLabel
          Left = 15
          Top = 10
          Width = 290
          Height = 20
          Align = alTop
          Caption = 'Atur Jumlah Masuk'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 129
        end
        object LblInputManual: TLabel
          Left = 15
          Top = 135
          Width = 131
          Height = 17
          Caption = 'Jumlah Barang Masuk:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object PnlCardBarang: TPanel
          Left = 15
          Top = 30
          Width = 290
          Height = 95
          Align = alTop
          BevelKind = bkFlat
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 0
          object LblNamaBarangPilih: TLabel
            Left = 10
            Top = 8
            Width = 265
            Height = 35
            AutoSize = False
            Caption = '(Klik barang pada tabel)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            WordWrap = True
          end
          object LblKodeRekPilih: TLabel
            Left = 10
            Top = 46
            Width = 39
            Height = 15
            Caption = 'Kode: -'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGrayText
            Font.Height = -11
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object LblStokSaatIni: TLabel
            Left = 10
            Top = 66
            Width = 79
            Height = 17
            Caption = 'Stok Sisa: -'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
        object PnlInputBaris: TPanel
          Left = 15
          Top = 156
          Width = 290
          Height = 40
          BevelOuter = bvNone
          Color = clWhitesmoke
          ParentBackground = False
          TabOrder = 1
          object BtnKurang1: TButton
            Left = 0
            Top = 0
            Width = 55
            Height = 38
            Cursor = crHandPoint
            Caption = '- 1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = BtnKurang1Click
          end
          object EdtJumlahMasuk: TEdit
            Left = 60
            Top = 0
            Width = 170
            Height = 38
            Alignment = taCenter
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -17
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            NumbersOnly = True
            ParentFont = False
            TabOrder = 1
            Text = '0'
            OnChange = EdtJumlahMasukChange
            OnKeyPress = EdtJumlahMasukKeyPress
          end
          object BtnTambah1: TButton
            Left = 235
            Top = 0
            Width = 55
            Height = 38
            Cursor = crHandPoint
            Caption = '+ 1'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -15
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = BtnTambah1Click
          end
        end
        object PnlTombolNominal: TPanel
          Left = 15
          Top = 202
          Width = 290
          Height = 35
          BevelOuter = bvNone
          Color = clWhitesmoke
          ParentBackground = False
          TabOrder = 2
          object BtnPlus5: TButton
            Left = 0
            Top = 0
            Width = 68
            Height = 32
            Cursor = crHandPoint
            Caption = '+ 5'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = BtnPlus5Click
          end
          object BtnPlus10: TButton
            Left = 74
            Top = 0
            Width = 68
            Height = 32
            Cursor = crHandPoint
            Caption = '+ 10'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = BtnPlus10Click
          end
          object BtnPlus50: TButton
            Left = 148
            Top = 0
            Width = 68
            Height = 32
            Cursor = crHandPoint
            Caption = '+ 50'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 2
            OnClick = BtnPlus50Click
          end
          object BtnPlus100: TButton
            Left = 222
            Top = 0
            Width = 68
            Height = 32
            Cursor = crHandPoint
            Caption = '+ 100'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 3
            OnClick = BtnPlus100Click
          end
        end
        object BtnKetikSendiri: TButton
          Left = 15
          Top = 245
          Width = 290
          Height = 38
          Cursor = crHandPoint
          Caption = 'Ketik Jumlah Sendiri'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 3
          OnClick = BtnKetikSendiriClick
        end
        object BtnResetBarang: TButton
          Left = 15
          Top = 290
          Width = 290
          Height = 32
          Cursor = crHandPoint
          Caption = 'Reset 0 (Barang Ini)'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 4
          OnClick = BtnResetBarangClick
        end
        object PnlInfoBantuan: TPanel
          Left = 15
          Top = 330
          Width = 290
          Height = 75
          BevelKind = bkFlat
          BevelOuter = bvNone
          Color = clInfoBk
          ParentBackground = False
          TabOrder = 5
          object LblBantuan: TLabel
            Left = 10
            Top = 8
            Width = 265
            Height = 55
            AutoSize = False
            Caption = 'Tips: Anda bisa mengklik tombol Ketik Jumlah Sendiri, tombol +/-, atau langsung mengetik angka di kolom Jumlah Masuk pada tabel.'
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
      object PnlTabel: TPanel
        Left = 0
        Top = 0
        Width = 680
        Height = 470
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        Padding.Left = 15
        Padding.Top = 10
        Padding.Right = 10
        Padding.Bottom = 10
        ParentBackground = False
        TabOrder = 1
        object LblJudulTabel: TLabel
          Left = 15
          Top = 10
          Width = 655
          Height = 20
          Align = alTop
          Caption = 'Daftar Seluruh Barang Persediaan Gudang DLH (Isi Jumlah Masuk):'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 407
        end
        object GridBarang: TStringGrid
          Left = 15
          Top = 30
          Width = 655
          Height = 430
          Align = alClient
          ColCount = 7
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect, goEditing]
          TabOrder = 0
          OnClick = GridBarangClick
          OnDblClick = GridBarangDblClick
          OnDrawCell = GridBarangDrawCell
          OnSelectCell = GridBarangSelectCell
          OnSetEditText = GridBarangSetEditText
          ColWidths = (
            40
            140
            180
            110
            80
            80
            110)
        end
      end
    end
  end
end
