program FlyingBalls;

uses
  Vcl.Forms,
  BallApp in 'BallApp.pas' {BallAppFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TBallAppFrame, BallAppFrame);
  Application.Run;
end.
