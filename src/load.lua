

function mksprite(col,row)
  local sprite={}
  sprite.x=col*8
  sprite.y=row*8
  sprite.update=sprite_update
  sprite.w=8
  sprite.h=8
  sprite.suspend_collision=false
  sprite.carried=false
  sprite.xiner=0
  sprite.human=false
  return sprite
end

function mkhero(col,row)
  local sprite=mksprite(col,row)
  sprite.tileid=0x10
  sprite.draw=hero_draw
  sprite.update=hero_update
  sprite.y-=6
  sprite.h+=6
  sprite.faceright=false
  sprite.facey=0
  sprite.armsup=false
  sprite.solid=true
  sprite.walkframe=0
  sprite.walkclock=0
  sprite.human=true
  sprite.fragile=true
  return sprite
end

function mkdesmond(col,row)
  local sprite=mksprite(col,row)
  sprite.tileid=0x21
  sprite.pickup=true
  sprite.solid=true
  sprite.human=true
  sprite.fragile=true
  return sprite
end

function mktomato(col,row)
  local sprite=mksprite(col,row)
  sprite.tileid=0x20
  sprite.pickup=true
  sprite.solid=true
  sprite.fragile=true
  return sprite
end

function mkfire(col,row)
  local sprite=mksprite(col,row)
  sprite.tileid=0x22
  sprite.update=fire_update
  sprite.animclock=0
  return sprite
end

function clear_map()
  local dstp=0x2000
  for i=1,12 do
    memset(dstp,0,16)
    dstp+=128
  end
end

function copy_map_to_scratch(srcx,srcy)
  local dstp=0x2000
  local srcp=0x2000+srcy*128+srcx
  for i=1,12 do
    memcpy(dstp,srcp,16)
    dstp+=128
    srcp+=128
  end
end

function load_sprites()
  for y=0,11 do
    for x=0,15 do
      local v=mget(x,y)
      if (v==0x10) then
        add(sprites,mkhero(x,y))
        mset(x,y,3)
      elseif (v==0x20) then
        add(sprites,mktomato(x,y))
        mset(x,y,3)
      elseif (v==0x21) then
        add(sprites,mkdesmond(x,y))
        mset(x,y,3)
      elseif (v==0x22) then
        add(sprites,mkfire(x,y))
        mset(x,y,3)
      end
    end
  end
end

function next_map()
  clocks_write_level_if()
  mapid+=1
  clocks_clear_level()
  if ((mapid<1) or (mapid>=40)) then
    -- 0 is the scratch space
    -- 40 is the absolute limit
    mapid=0
    clear_map()
  else
    local mapsrcx=band(mapid,7)*16
    local mapsrcy=band(shr(mapid,3),0xff)*12
    copy_map_to_scratch(mapsrcx,mapsrcy)
  end
  deadbaby=false
  sprites={}
  victorytime=0
  hwvp=1
  hjvp=#hjvv
  load_sprites()
  if (#sprites==0) then
    clocks_write_total_if()
    gameover=true
    mapid=0
  end
end

function reinit()
  mapid=0
  gameover=false
  losscount=0
  clocks_clear()
  next_map()
end
