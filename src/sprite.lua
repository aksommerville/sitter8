

function sprite_update(sprite)
  if ((sprite.xiner<-16) or (sprite.xiner>16)) then
    sprite_move(sprite,0,-1)
  elseif (sprite.solid) then
    sprite_move(sprite,0,2)
  end
  if (sprite.xiner<-10) then
    sprite_move(sprite,-2,0)
    sprite.xiner+=2
  elseif (sprite.xiner<0) then
    sprite_move(sprite,-1,0)
    sprite.xiner+=1
  elseif (sprite.xiner>10) then
    sprite_move(sprite,2,0)
    sprite.xiner-=2
  elseif (sprite.xiner>0) then
    sprite_move(sprite,1,0)
    sprite.xiner-=1
  end
end

function explode_draw(sprite)
  local f=flr(sprite.clock/4)%6
  if (f>=3) then
    sprite.tileid=0x33-(f-3)
  else
    sprite.tileid=0x30+f
  end
  for i=0,9 do
    local dx=cos(i/10)*sprite.clock
    local dy=sin(i/10)*sprite.clock
    spr(sprite.tileid,
      sprite.x+dx-4,
      sprite.y+dy-4+16
    )
  end
end

function explode_update(sprite)
  sprite.clock+=1
  if (sprite.clock>120) then
    del(sprites,sprite)
  end
end

function explode(sprite)
  sfx(6)
  local e=mksprite(0,0)
  add(sprites,e)
  e.x=sprite.x+sprite.w/2
  e.y=sprite.y+sprite.h/2
  e.clock=0
  e.draw=explode_draw
  e.update=explode_update
end

function fire_update(sprite)
  sprite.animclock+=1
  if (sprite.animclock>=5) then
    sprite.animclock=0
    if (sprite.tileid==0x22) then
      sprite.tileid=0x23
    else
      sprite.tileid=0x22
    end
  end
  for victim in all(sprites) do
    if (
      victim.fragile and
      (victim.x<sprite.x+sprite.w) and
      (victim.y<sprite.y+sprite.h) and
      (victim.x+victim.w>sprite.x) and
      (victim.y+victim.h>sprite.y)
    ) then
      del(sprites,victim)
      explode(victim)
      if (victim.human) then
        deadbaby=true
      end
    end
  end
end

function susie_update(sprite)
  sprite_update(sprite)
  sprite.animclock+=1
  if (sprite.animclock>6) then
    sprite.animclock=0
    sprite.animframe+=1
    if (sprite.animframe>=4) sprite.animframe=0
    if (sprite.animframe==0) then
      sprite.tileid=0x24
    elseif (sprite.animframe==1) then
      sprite.tileid=0x25
    elseif (sprite.animframe==2) then
      sprite.tileid=0x24
    elseif (sprite.animframe==3) then
      sprite.tileid=0x26
    end
  end
  local walkok=false
  if (sprite.faceright) then
    walkok=sprite_move(sprite,1,0)
  else
    walkok=sprite_move(sprite,-1,0)
  end
  if (not walkok) then
    sprite.faceright=not sprite.faceright
  end
end
