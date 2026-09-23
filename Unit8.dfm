object Form8: TForm8
  Left = 0
  Top = 0
  Caption = 'Arsip Dokumen Bukti Validasi - DLH Banjarmasin'
  ClientHeight = 650
  ClientWidth = 1050
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
    Width = 1050
    Height = 650
    Align = alClient
    BevelOuter = bvNone
    Color = clWhitesmoke
    ParentBackground = False
    TabOrder = 0
    object PnlHeader: TPanel
      Left = 0
      Top = 0
      Width = 1050
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      Color = 3308846
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        1050
        60)
      object LblJudul: TLabel
        Left = 20
        Top = 15
        Width = 278
        Height = 25
        Caption = 'Arsip Dokumen Bukti Validasi'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object BtnKembali: TButton
        Left = 920
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
      Width = 1050
      Height = 70
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object LblBulan: TLabel
        Left = 20
        Top = 10
        Width = 34
        Height = 15
        Caption = 'Bulan:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblTahun: TLabel
        Left = 145
        Top = 10
        Width = 37
        Height = 15
        Caption = 'Tahun:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblDari: TLabel
        Left = 230
        Top = 10
        Width = 26
        Height = 15
        Caption = 'Dari:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblSampai: TLabel
        Left = 350
        Top = 10
        Width = 23
        Height = 15
        Caption = 's/d:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblBidang: TLabel
        Left = 575
        Top = 10
        Width = 95
        Height = 15
        Caption = 'Bidang Pemohon:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object LblCari: TLabel
        Left = 770
        Top = 10
        Width = 60
        Height = 15
        Caption = 'Cari Berkas:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object CboBulan: TComboBox
        Left = 20
        Top = 30
        Width = 115
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
        Text = 'Semua Bulan'
        OnChange = CboBulanChange
        Items.Strings = (
          'Semua Bulan'
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
        Left = 145
        Top = 30
        Width = 70
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
      object DTPDari: TDateTimePicker
        Left = 230
        Top = 30
        Width = 110
        Height = 25
        Date = 46279.000000000000000000
        Time = 46279.000000000000000000
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
        Left = 350
        Top = 30
        Width = 110
        Height = 25
        Date = 46279.000000000000000000
        Time = 46279.000000000000000000
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
        Left = 470
        Top = 33
        Width = 95
        Height = 20
        Caption = 'Aktifkan'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
        OnClick = ChkFilterTanggalClick
      end
      object CboBidang: TComboBox
        Left = 575
        Top = 30
        Width = 180
        Height = 25
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnChange = CboBidangChange
      end
      object EdCari: TEdit
        Left = 770
        Top = 30
        Width = 260
        Height = 25
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        TextHint = 'No Pengajuan / Nama File...'
        OnChange = EdCariChange
      end
    end
    object PnlKonten: TPanel
      Left = 0
      Top = 130
      Width = 1050
      Height = 520
      Align = alClient
      BevelOuter = bvNone
      Color = clWhitesmoke
      ParentBackground = False
      TabOrder = 2
      object PnlPreview: TPanel
        Left = 630
        Top = 0
        Width = 420
        Height = 520
        Align = alRight
        BevelOuter = bvNone
        Color = clWhite
        Padding.Left = 15
        Padding.Top = 15
        Padding.Right = 15
        Padding.Bottom = 15
        ParentBackground = False
        TabOrder = 0
        object LblJudulPreview: TLabel
          Left = 15
          Top = 15
          Width = 390
          Height = 20
          Align = alTop
          Caption = 'Pratinjau Dokumen Bukti Fisik'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 197
        end
        object PnlInfoDoc: TPanel
          Left = 15
          Top = 35
          Width = 390
          Height = 75
          Align = alTop
          BevelKind = bkFlat
          BevelOuter = bvNone
          Color = clWhitesmoke
          ParentBackground = False
          TabOrder = 0
          object LblNoDoc: TLabel
            Left = 10
            Top = 6
            Width = 104
            Height = 15
            Caption = 'No. Pengajuan: -'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object LblBidangDoc: TLabel
            Left = 10
            Top = 23
            Width = 53
            Height = 15
            Caption = 'Bidang: -'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object LblTglDoc: TLabel
            Left = 220
            Top = 23
            Width = 56
            Height = 15
            Caption = 'Tanggal: -'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object LblFileDoc: TLabel
            Left = 10
            Top = 42
            Width = 165
            Height = 15
            Caption = 'Berkas: (Pilih dokumen di tabel)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsItalic]
            ParentFont = False
          end
        end
        object ImgPreview: TImage
          Left = 15
          Top = 110
          Width = 390
          Height = 305
          Cursor = crHandPoint
          Align = alClient
          Center = True
          Proportional = True
          Stretch = True
          OnClick = ImgPreviewClick
          ExplicitTop = 115
          ExplicitHeight = 300
        end
        object PnlAksi: TPanel
          Left = 15
          Top = 380
          Width = 390
          Height = 125
          Align = alBottom
          BevelOuter = bvNone
          Color = clWhite
          ParentBackground = False
          TabOrder = 1
          object BtnBukaFile: TButton
            Left = 0
            Top = 4
            Width = 390
            Height = 36
            Cursor = crHandPoint
            Caption = 'Buka Berkas Bukti Scan / Foto (Asli)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            OnClick = BtnBukaFileClick
          end
          object BtnCetakTandaTerima: TButton
            Left = 0
            Top = 44
            Width = 390
            Height = 38
            Cursor = crHandPoint
            Caption = 'Cetak Ulang Surat Tanda Terima Fisik (HTML)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 1
            OnClick = BtnCetakTandaTerimaClick
          end
          object BtnBukaFolder: TButton
            Left = 0
            Top = 86
            Width = 390
            Height = 34
            Cursor = crHandPoint
            Caption = 'Buka Folder Arsip di Windows Explorer'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = BtnBukaFolderClick
          end
        end
      end
      object PnlDaftar: TPanel
        Left = 0
        Top = 0
        Width = 630
        Height = 520
        Align = alClient
        BevelOuter = bvNone
        Color = clWhitesmoke
        Padding.Left = 15
        Padding.Top = 10
        Padding.Right = 10
        Padding.Bottom = 10
        ParentBackground = False
        TabOrder = 1
        object LblDaftar: TLabel
          Left = 15
          Top = 10
          Width = 605
          Height = 20
          Align = alTop
          Caption = 'Daftar Dokumen Tanda Terima Fisik Tervalidasi'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Segoe UI'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 265
        end
        object GridArsip: TStringGrid
          Left = 15
          Top = 30
          Width = 605
          Height = 445
          Align = alClient
          ColCount = 7
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          TabOrder = 0
          OnClick = GridArsipClick
          OnDblClick = GridArsipDblClick
          ColWidths = (
            40
            90
            150
            180
            70
            200
            0)
        end
        object PnlFooterDaftar: TPanel
          Left = 15
          Top = 475
          Width = 605
          Height = 35
          Align = alBottom
          BevelOuter = bvNone
          Color = clWhitesmoke
          ParentBackground = False
          TabOrder = 1
          object LblTotalRecord: TLabel
            Left = 5
            Top = 8
            Width = 217
            Height = 17
            Caption = 'Total Berkas Arsip Ditemukan: 0 Dokumen'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
  end
end
