program Life;

Uses Graph,KeyBoard,DPMILib;

Type Brain = Record
     Life: Boolean;
     MoF: Boolean;
     Oppos: Boolean;
     Generation: LongInt;
     Exp: LongInt;
     end;


Const XGLB = 160;
      YGLB = 100;
      X = XGLB-1;
      Y = YGLB-1;
      XS = XGLB;
      YS = YGLB;
      First_Creature_Percent=40;
      Stp = 1;
      FuckExp = 5;
      EatExp = 10;
      StayExp = 20;
      OpposGen = 5;
      ExpDead = 1000;


Var Main: Array [1..X,1..Y] of Brain;
    q,w: word;
    Temp: Brain;
    Count: LongInt;
    ScrSeg,S: Word;


Procedure ClearMass;

begin
  Temp.Life:=False;
  Temp.MoF:=False;
  Temp.Oppos:=False;
  Temp.Generation:=1;
  Temp.Exp:=0;
  For q:=1 to Y do
    begin
      For w:=1 to X do
       begin
         Main[w,q]:=Temp;
       end;
    end;
end;

Procedure InitMass;

begin
  Temp.Life:=True;
  Temp.Oppos:=False;
  Temp.Generation:=1;
  Temp.Exp:=0;
  For q:=1 to Y do
    begin
      For w:=1 to X do
        begin
          If Random(2) = 1 then Temp.MoF:=False else Temp.Mof:=True;
          If Random(2) = 1 then Temp.Oppos:=True else Temp.Oppos:=False;
          If Random(First_Creature_Percent) = First_Creature_Percent/2 then Main[w,q]:=Temp;
        end;
    end;
end;


Procedure Dead(xo,yo: Word);
begin
If Main[xo,yo].Exp > ExpDead then Main[xo,yo].Life:=False;
end;

Procedure CheDelat(xd,yd,x1d,y1d: LongInt);

Var RN: Byte;
    StayE: Boolean;

begin
StayE:=True;
Dead(xd,yd);
Dead(x1d,y1d);
If Main[xd,yd].MoF = True then If Main[xd,yd].Life = True then If Main[x1d,y1d].Life = true then If Main[xd,yd].MoF = Main[x1d,y1d].MoF then If Main[x1d,y1d].Oppos = Main[xd,yd].Oppos then
  begin
   Temp.Life:=True;
   Temp.Generation:=Main[xd,yd].Generation+1;
   If Random(2) = 1 then Temp.MoF:=True else Temp.Mof:=False;
   If Temp.Generation > OpposGen then
     If Random(2) = 1 then Temp.Oppos:=False
       else begin Temp.Oppos:=True; Temp.Generation:=1 end;
   Temp.Exp:=0;
    Case Random(7) of
     0: If Main[xd-Stp,yd].Life = False then If (Xd-Stp > 1) then Begin Main[xd-Stp,yd]:=Temp; StayE:=False; end;
     1: If Main[xd-Stp,yd-Stp].Life = False then If (Yd-Stp > 1) then If (Xd-Stp > 1) then Begin Main[xd-Stp,yd-Stp]:=Temp; StayE:=False; end;
     2: If Main[xd,yd-Stp].Life = False then If (Yd-Stp > 1) then Begin Main[xd,yd-Stp]:=Temp; StayE:=False; end;
     3: If Main[xd+Stp,yd-Stp].Life = False then If (Yd-Stp > 1) then If (Xd+Stp < X-1) then Begin Main[xd+Stp,yd-Stp]:=Temp; StayE:=False; end;
     4: If Main[xd+Stp,yd].Life = False then If (Xd+Stp < X-1) then Begin Main[xd+Stp,yd]:=Temp; StayE:=False; end;
     5: If Main[xd+Stp,yd+Stp].Life = False then If (Yd+Stp < Y-1) then If (Xd+Stp < X-1) then Begin Main[xd+Stp,yd+Stp]:=Temp; StayE:=False; end;
     6: If Main[xd,yd+Stp].Life = False then If (Yd+Stp < Y-1) then Begin Main[xd,yd+Stp]:=Temp; StayE:=False; end;
     7: If Main[xd-Stp,yd+Stp].Life = False then If (Yd+Stp < Y-1) then If (Xd-Stp > 1) then Begin Main[xd-Stp,yd+Stp]:=Temp; StayE:=False; end;
    end;
   If StayE = False then Main[xd,yd].Exp:=Main[xd,yd].Exp+FuckExp;
   If StayE = False then Main[x1d,y1d].Exp:=Main[x1d,y1d].Exp+FuckExp;
   If StayE = True then Main[xd,yd].Exp:=Main[xd,yd].Exp+StayExp;
  end;

If Main[xd,yd].Oppos <> Main[x1d,y1d].Oppos then
  begin
    If Main[xd,yd].Exp > Main[x1d,y1d].Exp then begin Main[x1d,y1d].Life:=False; Main[xd,yd].Exp:=Main[xd,yd].Exp+EatExp; end;
    If Main[xd,yd].Exp < Main[x1d,y1d].Exp then begin Main[xd,yd].Life:=False; Main[x1d,y1d].Exp:=Main[x1d,y1d].Exp+EatExp; end;
    If Main[xd,yd].Exp = Main[x1d,y1d].Exp then
      begin
        Case Random(1) of
         0: Begin Main[xd,yd].Life:=False; Main[x1d,y1d].Exp:=Main[x1d,y1d].Exp+EatExp; end;
         1: Begin Main[x1d,y1d].Life:=False; Main[xd,yd].Exp:=Main[xd,yd].Exp+EatExp; end;
      end;
  end;
end;


end;


Procedure Step(xm,ym: LongInt);

begin

Case Random(14) of
0: Begin If Main[xm-Stp,ym].Life = true then Begin CheDelat(xm,ym,xm-Stp,ym); Exit; end;If (Xm-Stp < 1) then Exit; Main[xm-Stp,ym]:=Main[xm,ym]; Main[xm-Stp,ym].Life:=True; Main[xm,ym].Life:=False; Dead(xm-Stp,ym); end;
1: Begin If Main[xm-Stp,ym-Stp].Life = true then Begin CheDelat(xm,ym,xm-Stp,ym-Stp); Exit; end;If (Ym-Stp < 1) then Exit; If (Xm-Stp < 1) then Exit; Main[xm-Stp,ym-Stp]:=Main[xm,ym]; Main[xm-Stp,ym-Stp].Life:=True; Main[xm,ym].Life:=False; Dead(xm-Stp,ym-Stp); end;
2: Begin If Main[xm,ym-Stp].Life = true then Begin CheDelat(xm,ym,xm,ym-Stp); Exit; end;If (Ym-Stp < 1) then Exit; Main[xm,ym-Stp]:=Main[xm,ym]; Main[xm,ym-Stp].Life:=True; Main[xm,ym].Life:=False; Dead(xm,ym-Stp); end;
3: Begin If Main[xm+Stp,ym-Stp].Life = true then Begin CheDelat(xm,ym,xm+Stp,ym-Stp); Exit;end; If (Ym-Stp < 1) then Exit; If (Xm+Stp > X-1) then Exit; Main[xm+Stp,ym-Stp]:=Main[xm,ym]; Main[xm+Stp,ym-Stp].Life:=True; Main[xm,ym].Life:=False; Dead(xm+Stp,ym-Stp); end;
4: Begin If Main[xm+Stp,ym].Life = true then Begin CheDelat(xm,ym,xm+Stp,ym); Exit; end;If (Xm+Stp > X-1) then Exit; Main[xm+Stp,ym]:=Main[xm,ym]; Main[xm+Stp,ym].Life:=True; Main[xm,ym].Life:=False; Dead(xm+Stp,ym); end;
5: Begin If Main[xm+Stp,ym+Stp].Life = true then Begin CheDelat(xm,ym,xm+Stp,ym+Stp); Exit;end; If (Ym+Stp > Y-1) then Exit; If (Xm+Stp > X-1) then Exit; Main[xm+Stp,ym+Stp]:=Main[xm,ym]; Main[xm+Stp,ym+Stp].Life:=True; Main[xm,ym].Life:=False; Dead(xm+Stp,ym+Stp); end;
6: Begin If Main[xm,ym+Stp].Life = true then Begin CheDelat(xm,ym,xm,ym+Stp); Exit;end; If (Ym+Stp > Y-1) then Exit; Main[xm,ym+Stp]:=Main[xm,ym]; Main[xm,ym+Stp].Life:=True; Main[xm,ym].Life:=False; Dead(xm,ym+Stp); end;
7: Begin If Main[xm-Stp,ym+Stp].Life = true then Begin CheDelat(xm,ym,xm-Stp,ym+Stp); Exit;end; If (Ym+Stp > Y-1) then Exit; If (Xm-Stp < 1) then Exit; Main[xm-Stp,ym+Stp]:=Main[xm,ym]; Main[xm-Stp,ym+Stp].Life:=True; Main[xm,ym].Life:=False; Dead(xm-Stp,ym+Stp); end;
end;
end;

Procedure Interation;
begin
For q:=1 to Y do
begin
For w:=1 to X do
begin
If Main[w,q].Life = True then Step(w,q);
end;
end;
end;

begin
Count:=0;
asm mov ax,$13; int $10; end;
ScrSeg:=CreateDataDescriptor($A0000,$FFFF);
ClearPage;
Randomize;
ClearMass;
InitMass;

Repeat

For q:=0 to YS-1 do
  begin
    For w:=0 to XS-1 do
      begin
        If Main[w,q].Life = True then
          Begin
            If Main[w,q].Oppos = False then
              begin
                If Main[w,q].MoF = False then FarPutByte(ScrSeg,w+q*320,15) else FarPutByte(ScrSeg,w+q*320,4);
              end;
            If Main[w,q].Oppos = True then
              Begin
                If Main[w,q].MoF = False then FarPutByte(ScrSeg,w+q*320,14) else FarPutByte(ScrSeg,w+q*320,13);
              end;
          end;
        If Main[w,q].Life = false then FarPutByte(ScrSeg,w+q*320,0);
      end;
  end;
Interation;
Inc(Count);
{ClearDevice;}
Until xKeyPressed;
FreeDescriptor(ScrSeg);
asm mov ax,$03; int $10; end;
WriteLn(Count);
end.