unit BallApp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask,
  Vcl.ComCtrls, Vcl.Menus, Vcl.Samples.Spin;

type
  TBallAppFrame = class(TForm)
    Ball1Area: TBevel;
    Ball2Area: TBevel;
    Ball1Log: TListBox;
    Ball2Log: TListBox;
    BallColCounter: TLabel;
    Ball1: TShape;
    Ball2: TShape;
    Ball1Speed: TSpinEdit;
    Ball2Speed: TSpinEdit;
    Timer1: TTimer;
    Ball1ColorBox: TColorBox;
    Ball2ColorBox: TColorBox;
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Ball1ColorBoxSelect(Sender: TObject);
    procedure Ball2ColorBoxSelect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TBall = class                   //����� ����
      Name: string;
      CollCount: integer;
      CollPos1: string;
      CollPos2: string;
      VelocityR: integer;
      VelocityD: integer;
  end;
  TSpace = class                   //����� �����
      Name: string;
      LeftStart: integer;
      RightEnd: integer;
      TopStart: integer;
      Down: integer;
  end;
  function ColBool(Ball:TShape; BallArea:TSpace) : boolean;
var
  BallAppFrame: TBallAppFrame;
  B1, B2 : TBall;      //���������� ������� �����
  S1, S2 : TSpace;     //���������� ������� �����
  i: integer;

implementation

{$R *.dfm}
//�������� ����� - ���������� ������� � ���������, �������� ������������(SMELL)
procedure BallMove(Ball: TShape; BallSpeed: TSpinEdit; BallArea: TSpace; BallObj: TBall);
begin
if (Ball.Top<=BallArea.TopStart) or (Ball.Top>=BallArea.Down) then BallObj.VelocityD:=BallObj.VelocityD*(-1);
if (Ball.Left<=BallArea.LeftStart) or (Ball.Left>=BallArea.RightEnd) then BallObj.VelocityR:=BallObj.VelocityR*(-1);
Ball.Top := Ball.Top + BallSpeed.Value * BallObj.VelocityD;
Ball.Left := Ball.Left + BallSpeed.Value * BallObj.VelocityR;
end;

//������� ���������� ������������ �� �������
procedure CollisionCheck(Ball: TShape; BallArea: TSpace; BallObj: TBall; BallLable: TLabel; BallLog: TListBox);
begin
if ColBool(Ball, BallArea) then
begin
BallObj.CollCount:=BallObj.CollCount+1;
BallObj.CollPos1:=BallObj.CollPos2;

if (Ball.Top<=BallArea.TopStart) then
begin
if Ball.Left>((BallArea.RightEnd-BallArea.LeftStart)/2 + BallArea.LeftStart) then
BallObj.CollPos2:='Top Right'
else
BallObj.CollPos2:='Top Left';
end;

if (Ball.Top>=BallArea.Down) then
begin
if Ball.Left>((BallArea.RightEnd-BallArea.LeftStart)/2 + BallArea.LeftStart) then
BallObj.CollPos2:='Down Right'
else
BallObj.CollPos2:='Down Left';
end;

if (Ball.Left<=BallArea.LeftStart) then
begin
if Ball.Top>((BallArea.Down-BallArea.TopStart)/2 + BallArea.TopStart) then
BallObj.CollPos2:='Left Bottom'
else
BallObj.CollPos2:='Left Top';
end;

if (Ball.Left>=BallArea.RightEnd) then
begin
if Ball.Top>((BallArea.Down-BallArea.TopStart)/2 + BallArea.TopStart) then
BallObj.CollPos2:='Right Bottom'
else
BallObj.CollPos2:='Right Top';
end;
BallLable.Caption:='Ball #1 : ' + IntToStr(B1.CollCount) + ' collisions, Ball#2: '+ IntToStr(B2.CollCount) +' collisions';
BallLog.Items.Add(TimeToStr(now)+' '+BallObj.CollPos1+ ' -> '+BallObj.CollPos2);
end;
end;

//��������� ����������� �������
function ColBool(Ball:TShape; BallArea:TSpace) : boolean;
begin
  result := (Ball.Top<=BallArea.TopStart) or (Ball.Top>=BallArea.Down) or (Ball.Left<=BallArea.LeftStart) or (Ball.Left>=BallArea.RightEnd);
end;
//��������� ���� ����������� ������ ������������ ����������� ����
procedure SpaceCoord(Ball:TShape; Area:TSpace; BallArea: TBevel); //�������� ����� - ���������� ������� � ���������, �������� ������������(SMELL)
begin
 Area.Name:=Ball.Name+'Area';
 Area.LeftStart := BallArea.Left;
 Area.RightEnd := BallArea.Left+BallArea.Width - Ball.Width;
 Area.TopStart := BallArea.Top;
 Area.Down := BallArea.Top+BallArea.Height - Ball.Height;
end;
//������ ������� ������ 0,1 ������� � ���������� �������.
procedure TBallAppFrame.Timer1Timer(Sender: TObject);
begin
BallMove(Ball1, Ball1Speed, S1, B1); //������� ���
BallMove(Ball2, Ball2Speed, S2, B2); //������� ���
CollisionCheck(Ball1, S1, B1, BallColCounter, Ball1Log);//��������� �� ������������
CollisionCheck(Ball2, S2, B2, BallColCounter, Ball2Log);//��������� �� ������������
end;
//������ ���������� �1
procedure TBallAppFrame.Ball1ColorBoxSelect(Sender: TObject);//��� ������ ������� ����� - �������� ���� ������ �1
begin
Ball1.Brush.Color := Ball1ColorBox.Selected;
end;
//������ ���������� �2
procedure TBallAppFrame.Ball2ColorBoxSelect(Sender: TObject);
begin
Ball2.Brush.Color := Ball2ColorBox.Selected;
end;
//���������� ����� ������
procedure BallLoad (b: TBall; ball: TShape);
begin
b.Name:=ball.StyleName;
b.CollCount:=0;
b.VelocityR:=1;
b.VelocityD:=1;
end;
//����� ������� ��������� ��������� - ������������� ����� ��� ����� ��� ������� �����
procedure TBallAppFrame.FormActivate(Sender: TObject);
begin
B1 := TBall.Create;      //������ �������
B2 := TBall.Create;      //������ �������
S1 := TSpace.Create;     //������ �������, �� ���� �� ���� �� ��������
S2 := TSpace.Create;     //������ �������, �� ���� �� ���� �� ��������
BallLoad(B1, Ball1);
BallLoad(B2, Ball2);
SpaceCoord(Ball1, S1, Ball1Area);
SpaceCoord(Ball2, S2, Ball2Area);
end;
end.
