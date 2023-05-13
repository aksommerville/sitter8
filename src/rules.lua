

function sprite_victorious(sprite)
  local x=sprite.x
  local y=sprite.y+sprite.h
  local w=sprite.w
  local h=1
  if (map_flag_in_rect(x,y,w,h,2)) then
    return true
  end
  for other in all(sprites) do
    if (
      other.solid and
      (other.x<x+w) and
      (other.y<y+h) and
      (other.x+other.w>x) and
      (other.y+other.h>y) and
      sprite_victorious(other)
    ) then
      return true
    end
  end
  return false
end

function all_sprites_victorious()
  for sprite in all(sprites) do
    if (
      sprite.human and
      not sprite_victorious(sprite)
    ) then
      return false
    end
  end
  return true
end

function check_victory()
  deadtime+=1 -- hero resets if alive
  if (deadtime>60) then
    levelwrap=true
    deadbaby=true
    losscount+=1
    music(2)
    sfx(4)
    return
  end
  if (all_sprites_victorious()) then
    victorytime+=1
    if (victorytime>=20) then
      if (deadbaby) then
        losscount+=1
        sfx(4)
      else
        sfx(5)
      end
      levelwrap=true
      music(2)
    end
  else
    victorytime=0
  end
end

function world_update()
  clocks_tick()
  for sprite in all(sprites) do
    if (sprite.update) then
      sprite.update(sprite)
    end
  end
  check_victory()
end
