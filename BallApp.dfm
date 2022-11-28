object BallAppFrame: TBallAppFrame
  Left = 0
  Top = 0
  Caption = 'BallAppFrame'
  ClientHeight = 623
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Ball1Area: TBevel
    Left = 24
    Top = 80
    Width = 345
    Height = 313
    Shape = bsFrame
  end
  object Ball2Area: TBevel
    Left = 408
    Top = 80
    Width = 345
    Height = 313
    Shape = bsFrame
  end
  object BallColCounter: TLabel
    Left = 24
    Top = 8
    Width = 274
    Height = 18
    Caption = 'Ball #1 : 0 collisions, Ball#2: 0 collisions'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 18
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Ball2: TShape
    Left = 576
    Top = 120
    Width = 49
    Height = 49
    Brush.Color = clLime
    Shape = stCircle
  end
  object Ball1: TShape
    Left = 88
    Top = 104
    Width = 49
    Height = 49
    Brush.Color = clRed
    Shape = stCircle
  end
  object Ball2Log: TListBox
    Left = 408
    Top = 408
    Width = 345
    Height = 175
    DragMode = dmAutomatic
    ItemHeight = 15
    TabOrder = 1
  end
  object Ball1Log: TListBox
    Left = 24
    Top = 408
    Width = 345
    Height = 175
    DragMode = dmAutomatic
    ItemHeight = 15
    TabOrder = 0
  end
  object Ball1Speed: TSpinEdit
    Left = 288
    Top = 42
    Width = 81
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    MaxValue = 20
    MinValue = 1
    ParentFont = False
    TabOrder = 2
    Value = 1
  end
  object Ball2Speed: TSpinEdit
    Left = 672
    Top = 42
    Width = 81
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    MaxValue = 20
    MinValue = 1
    ParentFont = False
    TabOrder = 3
    Value = 1
  end
  object Ball1ColorBox: TColorBox
    Left = 112
    Top = 42
    Width = 145
    Height = 22
    NoneColorColor = clWhite
    Selected = clRed
    TabOrder = 4
    OnSelect = Ball1ColorBoxSelect
  end
  object Ball2ColorBox: TColorBox
    Left = 496
    Top = 42
    Width = 145
    Height = 22
    NoneColorColor = clWhite
    Selected = clLime
    TabOrder = 5
    OnSelect = Ball2ColorBoxSelect
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 396
    Top = 8
  end
end
