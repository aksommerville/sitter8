

function hero_jump_down(sprite)
  if (
    oneway_in_rect(
      sprite.x,sprite.y+sprite.h-1,
      sprite.w,2,1
    ) and not map_flag_in_rect(
      sprite.x,sprite.y,
      sprite.w,sprite.h,0
    )
  ) then
    sprite.y+=1
    hjvp=#hjvv
  end
end

function find_pumpkin(x,y,w,h)
  for sprite in all(sprites) do
    if (
      sprite.pickup and
      sprite.solid and
      (sprite.x<x+w) and
      (sprite.y<y+h) and
      (sprite.x+sprite.w>x) and
      (sprite.y+sprite.h>y)
    ) then
      return sprite
    end
  end
  return nil
end

function toss_all(hero,sprite,dx)
  sprite.carried=false
  sprite.solid=true
  hero.y+=sprite.h
  hero.h-=sprite.h
  if (dx<0) then
    sprite.x=hero.x
    sprite_move(sprite,-8,0)
  elseif (dx>0) then
    sprite.x=hero.x+hero.w-sprite.w
    sprite_move(sprite,8,0)
  end
end

function toss(hero,sprite,dx)
  toss_all(hero,sprite,dx)
  sprite.xiner=dx*24
end

function drop(hero,sprite,dx)
  toss_all(hero,sprite,dx)
end

function toss_up(hero,sprite)
  toss_all(hero,sprite,0)
  sprite_move(sprite,0,-4)
end

function toss_down(hero,sprite)
  toss_all(hero,sprite,0)
  hero.y=sprite.y
  sprite.y=hero.y+hero.h
end

function hero_pickup_or_toss(sprite)
  if (sprite.armsup) then
    sprite.armsup=false
    if (sprite.facey<0) then
      toss_up(sprite,sprite.pumpkin)
    elseif (sprite.facey>0) then
      toss_down(sprite,sprite.pumpkin)
    elseif (sprite.faceright) then
      if (btn(1)) then
        toss(sprite,sprite.pumpkin,1)
      else
        drop(sprite,sprite.pumpkin,1)
      end
    else
      if (btn(0)) then
        toss(sprite,sprite.pumpkin,-1)
      else
        drop(sprite,sprite.pumpkin,-1)
      end
    end
    sprite.pumpkin=nil
  else
    local pumpkin=nil
    if (sprite.facey<0) then
      pumpkin=find_pumpkin(
        sprite.x,
        sprite.y-4,
        sprite.w,
        4
      )
    elseif (sprite.facey>0) then
      pumpkin=find_pumpkin(
        sprite.x,
        sprite.y+sprite.h,
        sprite.w,4,
        4
      )
    elseif (sprite.faceright) then
      pumpkin=find_pumpkin(
        sprite.x+sprite.w,
        sprite.y,
        4,sprite.h
      )
    else
      pumpkin=find_pumpkin(
        sprite.x-4,
        sprite.y,
        4,sprite.h
      )
    end
    --todo ensure head room exists
    --todo if picking up from below, trade places vertically
    if (pumpkin) then
      sprite.armsup=true
      sprite.pumpkin=pumpkin
      pumpkin.carried=true
      pumpkin.solid=false
      if (sprite.facey>0) then
        sprite.x=pumpkin.x
      else
        pumpkin.x=sprite.x+sprite.w/2-pumpkin.w/2
      end
      pumpkin.y=sprite.y-pumpkin.h
      sprite.y-=pumpkin.h
      sprite.h+=pumpkin.h
      if (sprite.facey>0) then
        sprite.y+=pumpkin.h
      end
    end
  end
end

function hero_animate_legs(sprite)
  if (sprite.walkclock>0) then
    sprite.walkclock-=1
  else
    sprite.walkclock=4
    sprite.walkframe+=1
    if (sprite.walkframe>=4) then
      sprite.walkframe=0
    end
  end
end

function hero_update(sprite)
  deadtime=0

  -- walk
  if (btn(0)) then 
    sprite.faceright=false
    sprite_move(sprite,-hwvv[hwvp],0)
    if (hwvp<#hwvv) hwvp+=1
    hero_animate_legs(sprite)
  elseif (btn(1)) then 
    sprite.faceright=true
    sprite_move(sprite,hwvv[hwvp],0)
    if (hwvp<#hwvv) hwvp+=1
    hero_animate_legs(sprite)
  else
    sprite.walkframe=0
    sprite.walkclock=0
    if (hwvp>1) then
      if (sprite.faceright) then
        sprite_move(sprite,hwvv[hwvp],0)
      else
        sprite_move(sprite,-hwvv[hwvp],0)
      end
      hwvp-=1
    end
  end
  
  -- jump or gravity
  -- there's btnp() but it auto-repeats
  if (btn(4) and not btn4pv and (sprite.facey>0)) then
    hero_jump_down(sprite)
  end
  if (btn(4) and (hjvp<#hjvv)) then
    sprite_move(sprite,0,-hjvv[hjvp])
    hjvp+=1
  else
    if (sprite_move(sprite,0,2)) then
      hjvp=#hjvv
    elseif (not btn(4)) then
      hjvp=1
    end
  end
  btn4pv=btn(4)
  
  -- face up/down/level
  if (btn(2)) then
    sprite.facey=-1
  elseif (btn(3)) then
    sprite.facey=1
  else 
    sprite.facey=0
  end
  
  -- pickup/toss
  if (btn(5) and not btn5pv) then
    hero_pickup_or_toss(sprite)
  end
  btn5pv=btn(5)
  
  -- update pumpkin
  if (sprite.pumpkin) then
    sprite.pumpkin.x=sprite.x+sprite.w/2-sprite.pumpkin.w/2
    sprite.pumpkin.y=sprite.y
  end
end

function hero_draw(sprite)
  local headtile=16
  if (sprite.facey<0) then
    headtile=20
  elseif (sprite.facey>0) then
    headtile=21
  end
  local dsty=sprite.y+16
  if (sprite.pumpkin) then
    dsty+=sprite.pumpkin.h
  end
  spr(
    headtile,
    sprite.x,
    dsty-2,1,1,
    sprite.faceright
  )
  local bodytile=0x11
  if (sprite.walkframe==1) then
    bodytile=0x16
  elseif (sprite.walkframe==2) then
    bodytile=0x17
  elseif (sprite.walkframe==3) then
    bodytile=0x18
  end
  spr(
    bodytile,
    sprite.x,
    dsty+6,1,1,
    sprite.faceright
  )
  if (sprite.armsup) then
    spr(
      19,
      sprite.x,
      dsty-1,1,1,
      sprite.faceright
    )
  else
    spr(
      18,
      sprite.x,
      dsty+6,
      1,1,
      sprite.faceright
    )
  end
end
