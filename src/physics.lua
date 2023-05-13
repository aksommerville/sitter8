

function map_flag_in_rect(x,y,w,h,f)
  local cola=flr(x/8)
  local rowa=flr(y/8)
  local colz=flr((x+w-1)/8)
  local rowz=flr((y+h-1)/8)
  for row=rowa,rowz do
    for col=cola,colz do
      local v=mget(col,row)
      if (fget(v,f)) then
        return true
      end
    end
  end
  return false
end

-- map_flag_in_rect, but only the top edge
function oneway_in_rect(x,y,w,h,f)
  local cola=flr(x/8)
  local rowa=flr(y/8)
  local colz=flr((x+w-1)/8)
  local rowz=flr((y+h-1)/8)
  if (rowa>=rowz) then
    return false
  end
  rowa+=1
  for row=rowa,rowz do
    for col=cola,colz do
      local v=mget(col,row)
      if (fget(v,f)) then
        return true
      end
    end
  end
  return false
end

-- one of (dx,dy) must be zero.
-- returns true if moved fully.
function sprite_move(sprite,dx,dy)
  sprite.x+=dx
  sprite.y+=dy
  local result=true
  
  -- clamp hard to edges
  if (sprite.x<0) then
    sprite.x=0
    result=false
  elseif (sprite.y<0) then
    sprite.y=0
    result=false
  elseif (sprite.x+sprite.w>128) then
    sprite.x=128-sprite.w
    result=false
  elseif (sprite.y+sprite.h>96) then
    sprite.y=96-sprite.h
    result=false
  end
  
  -- non-solid sprites, that's all
  if (not sprite.solid) then
    return result
  end
  
  -- check leading edge against the map
  local tx=sprite.x
  local ty=sprite.y
  local tw=1
  local th=1
  local fixx=sprite.x
  local fixy=sprite.y
  if (dx<0) then
    th=sprite.h
    fixx=band(sprite.x+7,bnot(7))
  elseif (dx>0) then
    th=sprite.h
    tx+=sprite.w-1
    fixx=flr(band(sprite.x+sprite.w-1,bnot(7))-sprite.w)
  elseif (dy<0) then
    tw=sprite.w
    fixy=band(sprite.y+7,bnot(7))
  elseif (dy>0) then
    tw=sprite.w
    ty+=sprite.h-1
    fixy=flr(band(sprite.y+sprite.h-1,bnot(7))-sprite.h)
  else
    result=false
  end
  if (map_flag_in_rect(tx,ty,tw,th,0)) then
    sprite.x=fixx
    sprite.y=fixy
    result=false
  end
  if ((dy>0) and oneway_in_rect(tx,ty-dy,tw,dy+1,1)) then
    sprite.y=fixy
    result=false
  end
  
  -- check solid sprites
  sprite.suspend_collision=true
  for other in all(sprites) do
    if (
      (other!=sprite) and
      other.solid and
      not other.suspend_collision and
      (other.x<sprite.x+sprite.w) and
      (other.y<sprite.y+sprite.h) and
      (other.x+other.w>sprite.x) and
      (other.y+other.h>sprite.y)
    ) then
      if (dx<0) then
        sprite_move(other,-1,0)
        sprite.x=other.x+other.w
        result=false
      elseif (dx>0) then
        sprite_move(other,1,0)
        sprite.x=other.x-sprite.w
        result=false
      elseif (dy<0) then
        sprite_move(other,0,-1)
        sprite.y=other.y+other.h
        result=false
      elseif (dy>0) then
        sprite_move(other,0,1)
        sprite.y=other.y-sprite.h
        result=false
      end
    end
  end
  sprite.suspend_collision=false
  
  return result
end
