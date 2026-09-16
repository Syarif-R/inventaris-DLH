object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Laporan & Berita Acara Stock Opname - DLH Banjarmasin'
  ClientHeight = 720
  ClientWidth = 1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  OnResize = FormResize
  TextHeight = 15
  object PnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 1080
    Height = 55
    Align = alTop
    Color = 3308846
    ParentBackground = False
    TabOrder = 0
    object LblJudul: TLabel
      Left = 20
      Top = 14
      Width = 490
      Height = 25
      Caption = 'LAPORAN & BERITA ACARA STOCK OPNAME DLH'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BtnKembali: TButton
      Left = 960
      Top = 10
      Width = 100
      Height = 35
      Anchors = [akTop, akRight]
      Cursor = crHandPoint
      Caption = 'Kembali'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BtnKembaliClick
    end
  end
  object PnlPengaturan: TPanel
    Left = 0
    Top = 55
    Width = 1080
    Height = 150
    Align = alTop
    BevelOuter = bvNone
    Color = clWhitesmoke
    Padding.Left = 20
    Padding.Top = 10
    Padding.Right = 20
    Padding.Bottom = 10
    ParentBackground = False
    TabOrder = 1
    object LblBulan: TLabel
      Left = 20
      Top = 12
      Width = 79
      Height = 17
      Caption = 'Periode Bulan:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblTahun: TLabel
      Left = 190
      Top = 12
      Width = 38
      Height = 17
      Caption = 'Tahun:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblNoSurat: TLabel
      Left = 290
      Top = 12
      Width = 124
      Height = 17
      Caption = 'Nomor Berita Acara:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblTanggal: TLabel
      Left = 560
      Top = 12
      Width = 124
      Height = 17
      Caption = 'Tanggal Berita Acara:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblKasubbag: TLabel
      Left = 20
      Top = 75
      Width = 195
      Height = 17
      Caption = 'Kasubbag. Umum & Kepegawaian:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblPengurus: TLabel
      Left = 370
      Top = 75
      Width = 101
      Height = 17
      Caption = 'Pengurus Barang:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblKadis: TLabel
      Left = 720
      Top = 75
      Width = 156
      Height = 17
      Caption = 'Kepala Dinas (Mengetahui):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CboBulan: TComboBox
      Left = 20
      Top = 35
      Width = 150
      Height = 25
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ItemIndex = 0
      ParentFont = False
      TabOrder = 0
      Text = 'Januari'
      OnChange = CboBulanChange
      Items.Strings = (
        'Januari'
        'Februari'
        'Maret'
        'April'
        'Mei'
        'Juni'
        'Juli'
        'Agustus'
        'September'
        'Oktober'
        'November'
        'Desember')
    end
    object EdtTahun: TEdit
      Left = 190
      Top = 35
      Width = 80
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '2026'
      OnChange = EdtTahunChange
    end
    object EdtNoSurat: TEdit
      Left = 290
      Top = 35
      Width = 250
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Text = '000.2.3.1 /      /Set-DLH /2026'
    end
    object DTPTanggal: TDateTimePicker
      Left = 560
      Top = 35
      Width = 160
      Height = 25
      Date = 46270.000000000000000000
      Time = 0.360000000000000000
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnChange = DTPTanggalChange
    end
    object ChkHideZero: TCheckBox
      Left = 740
      Top = 37
      Width = 160
      Height = 22
      Caption = 'Sembunyikan Stok 0'
      Checked = True
      State = cbChecked
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = ChkHideZeroClick
    end
    object EdtKasubbagNama: TEdit
      Left = 20
      Top = 95
      Width = 200
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = 'LISNAWATI, S.KM. M. Ling'
    end
    object EdtKasubbagNIP: TEdit
      Left = 20
      Top = 122
      Width = 200
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = 'NIP. 19790124 201001 2 011'
    end
    object EdtPengurusNama: TEdit
      Left = 370
      Top = 95
      Width = 200
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      Text = 'H.HUSAINI'
    end
    object EdtPengurusNIP: TEdit
      Left = 370
      Top = 122
      Width = 200
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = 'NIP.19730705 201406 1 007'
    end
    object EdtKadisNama: TEdit
      Left = 720
      Top = 95
      Width = 230
      Height = 25
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      Text = 'JEFRIE FRANSYAH, S.H M.H.'
    end
    object EdtKadisNIP: TEdit
      Left = 720
      Top = 122
      Width = 230
      Height = 23
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      Text = 'NIP. 196841019 201001 1 012'
    end
  end
  object PnlBawah: TPanel
    Left = 0
    Top = 660
    Width = 1080
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    Padding.Left = 20
    Padding.Top = 10
    Padding.Right = 20
    Padding.Bottom = 10
    ParentBackground = False
    TabOrder = 2
    object LblTotalNilai: TLabel
      Left = 20
      Top = 18
      Width = 350
      Height = 23
      Caption = 'TOTAL NILAI PERSEDIAAN: Rp 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 3308846
      Font.Height = -17
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object BtnCetakPDF: TButton
      Left = 620
      Top = 10
      Width = 260
      Height = 40
      Anchors = [akTop, akRight]
      Cursor = crHandPoint
      Caption = 'Cetak Berita Acara (HTML / PDF)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = BtnCetakPDFClick
    end
    object BtnExportExcel: TButton
      Left = 890
      Top = 10
      Width = 170
      Height = 40
      Anchors = [akTop, akRight]
      Cursor = crHandPoint
      Caption = 'Export Excel (CSV)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = BtnExportExcelClick
    end
  end
  object GridOpname: TStringGrid
    Left = 0
    Top = 205
    Width = 1080
    Height = 455
    Align = alClient
    ColCount = 7
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 3
    ColWidths = (
      40
      180
      340
      80
      100
      140
      160)
  end
  object SaveDialog1: TSaveDialog
    Left = 520
    Top = 360
  end
end
