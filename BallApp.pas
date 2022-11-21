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
  TBall = class                   //класс м€ча
      Name: string;
      CollCount: integer;
      CollPos1: string;
      CollPos2: string;
      VelocityR: integer;
      VelocityD: integer;
  end;
  TSpace = class                   //класс рамки
      Name: string;
      LeftStart: integer;
      RightEnd: integer;
      TopStart: integer;
      Down: integer;
  end;
  function ColBool(Ball:TShape; BallArea:TSpace) : boolean;
var
  BallAppFrame: TBallAppFrame;
  B1, B2 : TBall;      //объ€влл€ем объекты м€чей
  S1, S2 : TSpace;     //объ€влл€ем объекты рамок
  i: integer;

implementation

{$R *.dfm}
//ƒвижение м€чей - отправл€ем объекты в процедуру, избегаем дублировани€(SMELL)
procedure BallMove(Ball: TShape; BallSpeed: TSpinEdit; BallArea: TSpace; BallObj: TBall);
begin
if (Ball.Top<=BallArea.TopStart) or (Ball.Top>=BallArea.Down) then BallObj.VelocityD:=BallObj.VelocityD*(-1);
if (Ball.Left<=BallArea.LeftStart) or (Ball.Left>=BallArea.RightEnd) then BallObj.VelocityR:=BallObj.VelocityR*(-1);
Ball.Top := Ball.Top + BallSpeed.Value * BallObj.VelocityD;
Ball.Left := Ball.Left + BallSpeed.Value * BallObj.VelocityR;
end;

//считаем количество столкновений со стенкой
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

//ѕровер€ем пересечение границы
function ColBool(Ball:TShape; BallArea:TSpace) : boolean;
begin
  result := (Ball.Top<=BallArea.TopStart) or (Ball.Top>=BallArea.Down) or (Ball.Left<=BallArea.LeftStart) or (Ball.Left>=BallArea.RightEnd);
end;
//«аполн€ем пол€ экземпл€ров класса пространства перемещени€ м€ча
procedure SpaceCoord(Ball:TShape; Area:TSpace; BallArea: TBevel); //ƒвижение м€чей - отправл€ем объекты в процедуру, избегаем дублировани€(SMELL)
begin
 Area.Name:=Ball.Name+'Area';
 Area.LeftStart := BallArea.Left;
 Area.RightEnd := BallArea.Left+BallArea.Width - Ball.Width;
 Area.TopStart := BallArea.Top;
 Area.Down := BallArea.Top+BallArea.Height - Ball.Height;
end;
//“аймер каунтит каждую 0,1 секунды и генерирует событи€.
procedure TBallAppFrame.Timer1Timer(Sender: TObject);
begin
BallMove(Ball1, Ball1Speed, S1, B1); //двигаем м€ч
BallMove(Ball2, Ball2Speed, S2, B2); //двигаем м€ч
CollisionCheck(Ball1, S1, B1, BallColCounter, Ball1Log);//провер€ем на столкновение
CollisionCheck(Ball2, S2, B2, BallColCounter, Ball2Log);//провер€ем на столкновение
end;
//просто перекраска є1
procedure TBallAppFrame.Ball1ColorBoxSelect(Sender: TObject);//при выборе другого цвета - мен€етс€ цвет шарика є1
begin
Ball1.Brush.Color := Ball1ColorBox.Selected;
end;
//просто перекраска є2
procedure TBallAppFrame.Ball2ColorBoxSelect(Sender: TObject);
begin
Ball2.Brush.Color := Ball2ColorBox.Selected;
end;
//«аполнение полей м€чика
procedure BallLoad (b: TBall; ball: TShape);
begin
b.Name:=ball.StyleName;
b.CollCount:=0;
b.VelocityR:=1;
b.VelocityD:=1;
end;
//—ама€ главна€ стартова€ процедура - инициализаци€ всего что нужно при запуске проги
procedure TBallAppFrame.FormActivate(Sender: TObject);
begin
B1 := TBall.Create;      //создаЄм объекты
B2 := TBall.Create;      //создаЄм объекты
S1 := TSpace.Create;     //создаЄм объекты, но пока не €сна их нужность
S2 := TSpace.Create;     //создаЄм объекты, но пока не €сна их нужность
BallLoad(B1, Ball1);
BallLoad(B2, Ball2);
SpaceCoord(Ball1, S1, Ball1Area);
SpaceCoord(Ball2, S2, Ball2Area);
end;
end.
