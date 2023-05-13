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
        1,1,false,
        sprite.carried
      )
    end
  end
end

function reprtime(f,s,m)
  if (s<10) s="0"..s
  if (m<10) m="0"..m
  return m..":"..s
end

function draw_gameover()
  rectfill(0,16,128,112,1)
  --todo
end

function draw_levelwrap()
  if (deadbaby) then
    rectfill(0,16,128,112,8)
  else
    rectfill(0,16,128,112,3)
  end
end

function draw_chrome()
  rectfill(0,0,128,16,0)
  rectfill(0,112,128,128,0)
  print("l: "..reprtime(lt_f,lt_s,lt_m),0,113,4)
  print("t: "..reprtime(tt_f,tt_s,tt_m),0,119,4)
  print(reprtime(lr_f,lr_s,lr_m),64,113,9)
  print(reprtime(tr_f,tr_s,tr_m),64,119,9)
  print("level "..mapid,0,5,4)
  --print("another thing",0,11,4)
end
