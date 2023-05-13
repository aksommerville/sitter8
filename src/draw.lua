function draw_world()
  map(0,0,0,16,16,12)  
  for sprite in all(sprites) do
    if (sprite.draw) then
      sprite.draw(sprite)
    else
      spr(
        sprite.tileid,
        sprite.x,
        sprite.y+16,
        1,1,sprite.faceright,
        sprite.carried
      )
    end
  end
end

function draw_gameover()
  rectfill(0,16,128,112,1)
  print("game over",47,30,7)
  print(reprtime(tt_f,tt_s,tt_m)..", "..losscount.." losses",35,40)
  print("thanks for playing!",24,66,6)
  print("press jump to play again",16,72,6)
end

function draw_levelwrap()
  if (deadbaby) then
    rectfill(0,16,128,112,8)
    print("failure!",50,60,7)
  else
    rectfill(0,16,128,112,3)
    print("success!",50,35,7)
    print("level time: "..reprtime(lt_f,lt_s,lt_m),29,58,6)
    print("    record: "..reprtime(lr_f,lr_s,lr_m),29,64,6)
    print("total so far: "..reprtime(tt_f,tt_s,tt_m),21,74,6)
    print("      record: "..reprtime(tr_f,tr_s,tr_m),21,80,6)
    print("losses: "..losscount,45,90,6)
  end
end

function reprtime(f,s,m)
  if (s<10) s="0"..s
  if (m<10) m="0"..m
  return m..":"..s
end

function draw_chrome()
  rectfill(0,0,128,16,0)
  rectfill(0,112,128,128,0)
  if (mapid>0) then
    print("l: "..reprtime(lt_f,lt_s,lt_m),0,113,4)
    print(reprtime(lr_f,lr_s,lr_m),64,113,9)
  end
  print("t: "..reprtime(tt_f,tt_s,tt_m),0,119,4)
  print(reprtime(tr_f,tr_s,tr_m),64,119,9)
  print("level "..mapid,0,11,4)
end
