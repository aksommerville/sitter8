

-- clocks
-- tt=total time
-- lr=level record
-- (f)rame, (s)econd, (m)inute
-- splitting out like this bc
-- numbers are 15-bit, we'd run out
tt_f=0
tt_s=0
tt_m=0
lt_f=0
lt_s=0
lt_m=0
tr_f=0
tr_s=0
tr_m=0
lr_f=0
lr_s=0
lr_m=0

function clocks_clear()
  tt_f=0
  tt_s=0
  tt_m=0
  lt_f=0
  lt_s=0
  lt_m=0
  tr_f=peek(0x5e00)
  tr_s=peek(0x5e01)
  tr_m=peek(0x5e02)
  if (tr_f+tr_s+tr_m<1) then
    tr_s=59
    tr_m=59
  end
  lr_f=0
  lr_s=59
  lr_m=59
end

function clocks_clear_level()
  lt_f=0
  lt_s=0
  lt_m=0
  lr_f=peek(0x5e00+mapid*3)
  lr_s=peek(0x5e01+mapid*3)
  lr_m=peek(0x5e02+mapid*3)
  if (lr_f+lr_s+lr_m<1) then
    lr_s=59
    lr_m=59
  end
end

function clocks_write_level_if()
  if (mapid<1) return
  if (lt_m>lr_m) return
  if (lt_m==lr_m) then
    if (lt_s>lr_s) return
    if (lt_s==lr_s) then
      if (lt_f>lr_f) return
    end
  end
  poke(0x5e00+mapid*3,lt_f)
  poke(0x5e01+mapid*3,lt_s)
  poke(0x5e02+mapid*3,lt_m)
end

function clocks_write_total_if()
  if (tt_m>tr_m) return
  if (tt_m==tr_m) then
    if (tt_s>tr_s) return
    if (tt_s==tr_s) then
      if (tt_f>tr_f) return
    end
  end
  poke(0x5e00,tt_f)
  poke(0x5e01,tt_s)
  poke(0x5e02,tt_m)
end

function clocks_tick()
  lt_f+=1
  if (lt_f>=30) then
    lt_f=0
    lt_s+=1
    if (lt_s>=60) then
      lt_s=0
      lt_m+=1
    end
  end
  tt_f+=1
  if (tt_f>=30) then
    tt_f=0
    tt_s+=1
    if (tt_s>=60) then
      tt_s=0
      tt_m+=1
    end
  end
end
