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
    procedure Timer1Timer(Sender: TObject);
    procedure Ball1ColorBoxSelect(Sender: TObject);
    procedure Ball2ColorBoxSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public

  end;
      MainController = class

    end;
  TBall = class                   //ball class
      CollCount: integer;
      CollPos1: string;
      CollPos2: string;
      VelocityH: integer;
      VelocityV: integer;
  end;
  TSpace = class                   //area class
      LeftStart: integer;
      RightEnd: integer;
      TopStart: integer;
      Down: integer;
  end;
  procedure Collision(Ball: TShape; BallArea: TSpace; BallObj: TBall; BallCC: TLabel; BallLog: TListBox);
var
  BallAppFrame: TBallAppFrame;
  B1, B2 : TBall;      //declaring ball objects
  S1, S2 : TSpace;     //declaring area objects

implementation

{$R *.dfm}
//Ball movement
procedure BallMove(Ball: TShape; BallSpeed: TSpinEdit; BallArea: TSpace; BallObj: TBall; BallCC: TLabel; BallLog: TListBox);
begin
if (Ball.Top<=BallArea.TopStart) or (Ball.Top>=BallArea.Down) then
begin
BallObj.VelocityV:=BallObj.VelocityV*(-1);
Collision(Ball, BallArea, BallObj, BallCC, BallLog);
end;
if (Ball.Left<=BallArea.LeftStart) or (Ball.Left>=BallArea.RightEnd) then
begin
BallObj.VelocityH:=BallObj.VelocityH*(-1);
Collision(Ball, BallArea, BallObj, BallCC, BallLog);
end;

Ball.Top := Ball.Top + BallSpeed.Value * BallObj.VelocityV;
Ball.Left := Ball.Left + BallSpeed.Value * BallObj.VelocityH;
end;

procedure Collision(Ball: TShape; BallArea: TSpace; BallObj: TBall; BallCC: TLabel; BallLog: TListBox);
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
BallCC.Caption:='Ball #1 : ' + IntToStr(B1.CollCount) + ' collisions, Ball#2: '+ IntToStr(B2.CollCount) +' collisions';
BallLog.Items.Add(TimeToStr(now)+' '+BallObj.CollPos1+ ' -> '+BallObj.CollPos2);

BallLog.Perform(WM_VSCROLL, SB_BOTTOM, 0);
BallLog.Perform( WM_VSCROLL, SB_ENDSCROLL, 0 );
end;

//Filling in the fields of instances of the ball movement space class
procedure SpaceCoord(Ball:TShape; Area:TSpace; BallArea: TBevel);
begin
 Area.LeftStart := BallArea.Left;
 Area.RightEnd := BallArea.Left+BallArea.Width - Ball.Width;
 Area.TopStart := BallArea.Top;
 Area.Down := BallArea.Top+BallArea.Height - Ball.Height;
end;
//The timer counts every 0.1 seconds and generates events.
procedure TBallAppFrame.Timer1Timer(Sender: TObject);
begin
BallMove(Ball1, Ball1Speed, S1, B1, BallColCounter, Ball1Log);
BallMove(Ball2, Ball2Speed, S2, B2, BallColCounter, Ball2Log);
end;
//repaint ¹1
procedure TBallAppFrame.Ball1ColorBoxSelect(Sender: TObject);
begin
Ball1.Brush.Color := Ball1ColorBox.Selected;
end;
//repaint ¹2
procedure TBallAppFrame.Ball2ColorBoxSelect(Sender: TObject);
begin
Ball2.Brush.Color := Ball2ColorBox.Selected;
end;
//Filling in the fields of the ball
procedure BallLoad (b: TBall);
begin
b.CollCount:=0;
b.VelocityH:=1;
b.VelocityV:=1;
end;
//The most important starting procedure is to launch everything that is needed when a program is detected
procedure TBallAppFrame.FormCreate(Sender: TObject);
begin
B1 := TBall.Create;      //Create Objects
B2 := TBall.Create;      //Create Objects
S1 := TSpace.Create;     //Create Objects
S2 := TSpace.Create;     //Create Objects
BallLoad(B1);
BallLoad(B2);
SpaceCoord(Ball1, S1, Ball1Area);
SpaceCoord(Ball2, S2, Ball2Area);
end;

end.
