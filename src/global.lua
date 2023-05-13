hwvv={
  0,
  1,1,1,
  2
}
hwvp=1
hjvv={
  5,4,3,3,2,2,2,
  1,1,1,1,1,0,0,0
}
hjvp=#hjvv
btn4pv=false
btn5pv=false
sprites={}
victorytime=0
deadtime=0
mapid=0
gameover=false
levelwrap=false
losscount=0
deadbaby=false

function _init()
  cartdata("sitter_hi_scores")
  reinit()
end

function _update()
  if (gameover) then
    if (btnp(4)) then
      reinit()
    end
  elseif (levelwrap) then
    if (btnp(4)) then
      levelwrap=false
      if (deadbaby) mapid-=1
      next_map()
    end
  else
    world_update()
  end
end

function _draw()
  if (gameover) then
    draw_gameover()
  elseif (levelwrap) then
    draw_levelwrap()
  else
    draw_world()
  end
  draw_chrome()
end
