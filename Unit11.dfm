object Form11: TForm11
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Penyesuaian Stok Gudang - DLH Banjarmasin'
  ClientHeight = 440
  ClientWidth = 560
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 560
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    Color = 3308846
    ParentBackground = False
    TabOrder = 0
    object LblJudul: TLabel
      Left = 20
      Top = 15
      Width = 360
      Height = 23
      Caption = 'Penyesuaian Stok (Rusak / Kadaluarsa)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object PnlKonten: TPanel
    Left = 0
    Top = 55
    Width = 560
    Height = 385
    Align = alClient
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 1
    object LblKode: TLabel
      Left = 25
      Top = 15
      Width = 83
      Height = 15
      Caption = 'Kode Rekening:'
      Font.Style = [fsBold]
    end
    object EdtKode: TEdit
      Left = 25
      Top = 33
      Width = 510
      Height = 26
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object LblNama: TLabel
      Left = 25
      Top = 67
      Width = 98
      Height = 15
      Caption = 'Nama Persediaan:'
      Font.Style = [fsBold]
    end
    object EdtNama: TEdit
      Left = 25
      Top = 85
      Width = 350
      Height = 26
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 1
    end
    object LblStok: TLabel
      Left = 390
      Top = 67
      Width = 79
      Height = 15
      Caption = 'Sisa Stok Saat Ini:'
      Font.Style = [fsBold]
    end
    object EdtStok: TEdit
      Left = 390
      Top = 85
      Width = 145
      Height = 26
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 2
    end
    object LblJenis: TLabel
      Left = 25
      Top = 120
      Width = 149
      Height = 15
      Caption = 'Jenis / Alasan Penyesuaian:'
      Font.Style = [fsBold]
    end
    object CboJenis: TComboBox
      Left = 25
      Top = 138
      Width = 510
      Height = 25
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = '1. Barang Rusak / Cacat Fisik (Pengurangan Stok)'
      Items.Strings = (
        '1. Barang Rusak / Cacat Fisik (Pengurangan Stok)'
        '2. Barang Kadaluarsa / Expired (Pengurangan Stok)'
        '3. Selisih Kurang Stock Opname (Pengurangan Stok)'
        '4. Selisih Lebih Stock Opname (Penambahan Stok)')
    end
    object LblJumlah: TLabel
      Left = 25
      Top = 175
      Width = 178
      Height = 15
      Caption = 'Jumlah Unit yang Disesuaikan:'
      Font.Style = [fsBold]
    end
    object EdtJumlah: TEdit
      Left = 25
      Top = 193
      Width = 180
      Height = 26
      TabOrder = 4
      Text = '1'
    end
    object LblSatuanInfo: TLabel
      Left = 215
      Top = 198
      Width = 50
      Height = 15
      Caption = 'Satuan'
      Font.Color = clGray
      Font.Style = [fsBold]
    end
    object LblKeterangan: TLabel
      Left = 25
      Top = 230
      Width = 234
      Height = 15
      Caption = 'Keterangan Rinci / Catatan Berita Acara:'
      Font.Style = [fsBold]
    end
    object EdtKeterangan: TEdit
      Left = 25
      Top = 248
      Width = 510
      Height = 26
      TabOrder = 5
      TextHint = 'Contoh: Kemasan bocor saat pemindahan rak, rusak kena air, dll.'
    end
    object PnlPeringatan: TPanel
      Left = 25
      Top = 285
      Width = 510
      Height = 35
      BevelOuter = bvNone
      Color = 15724527
      ParentBackground = False
      TabOrder = 6
      object LblPeringatan: TLabel
        Left = 10
        Top = 9
        Width = 490
        Height = 15
        Caption = 'Tindakan ini akan langsung memperbarui stok fisik dan tercatat dalam Berita Acara resmi.'
        Font.Color = 3308846
        Font.Height = -11
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object BtnSimpan: TButton
      Left = 250
      Top = 332
      Width = 175
      Height = 38
      Cursor = crHandPoint
      Caption = 'Simpan Penyesuaian'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = BtnSimpanClick
    end
    object BtnBatal: TButton
      Left = 435
      Top = 332
      Width = 100
      Height = 38
      Cursor = crHandPoint
      Caption = 'Batal'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = BtnBatalClick
    end
  end
end