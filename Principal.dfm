object p: Tp
  Left = 0
  Top = 0
  Caption = 'Chatbot - Inventarios- Buy n Large'
  ClientHeight = 438
  ClientWidth = 654
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    654
    438)
  PixelsPerInch = 96
  TextHeight = 13
  object Memopeticion: TMemo
    AlignWithMargins = True
    Left = 0
    Top = 356
    Width = 555
    Height = 79
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 0
  end
  object btEnviar: TButton
    Left = 561
    Top = 356
    Width = 85
    Height = 74
    Anchors = [akRight, akBottom]
    Caption = 'Enviar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Segoe UI Variable Text Semiligh'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btEnviarClick
  end
  object PnMenu: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 657
    Height = 33
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    object Label1: TLabel
      Left = 17
      Top = 13
      Width = 49
      Height = 13
      Caption = 'Conexion:'
      Color = clWhite
      ParentColor = False
    end
  end
  object MemoRespuesta: TRichEdit
    Left = 0
    Top = 32
    Width = 657
    Height = 318
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      '')
    ParentFont = False
    TabOrder = 3
    Zoom = 100
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=MSSQL')
    Left = 264
    Top = 88
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection
    Left = 328
    Top = 88
  end
end
