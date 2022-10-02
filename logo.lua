-- draw a rough logo

function logo(x,y)
  local offset_x = 35
  local offset_y = 17
  local quads = {
   -- zero = getTile(k_tiles_trans,35,16),
    b = getTile(k_tiles_trans,offset_x + 1,offset_y + 1),
    u = getTile(k_tiles_trans,offset_x + 7,offset_y + 2),
    i = getTile(k_tiles_trans,offset_x + 8,offset_y + 1),
    l = getTile(k_tiles_trans,offset_x + 11,offset_y + 1),
    d = getTile(k_tiles_trans,offset_x + 3,offset_y + 1),
    n = getTile(k_tiles_trans,offset_x + 0,offset_y + 2),
    o = getTile(k_tiles_trans,offset_x + 1,offset_y + 2),
    c = getTile(k_tiles_trans,offset_x + 2,offset_y + 1),
    k = getTile(k_tiles_trans,offset_x + 10,offset_y + 1),
    s = getTile(k_tiles_trans,offset_x + 5,offset_y + 2),
    block = getTile(k_tiles_trans,offset_x + 4,offset_y - 3)
  }
  
  love.graphics.draw(k_tiles_trans, quads.b, x, y)
  love.graphics.draw(k_tiles_trans, quads.block, x, y)
  love.graphics.draw(k_tiles_trans, quads.u, x+(16*1), y)
  love.graphics.draw(k_tiles_trans, quads.block, x+(16*1), y)
  love.graphics.draw(k_tiles_trans, quads.i, x+(16*2), y)
  love.graphics.draw(k_tiles_trans, quads.block, x+(16*2), y)
  love.graphics.draw(k_tiles_trans, quads.l, x+(16*3), y)
  love.graphics.draw(k_tiles_trans, quads.block, x+(16*3), y)
  love.graphics.draw(k_tiles_trans, quads.d, x+(16*4), y)
  love.graphics.draw(k_tiles_trans, quads.block, x+(16*4), y)

  love.graphics.draw(k_tiles_trans, quads.n, x+(16*2), y+16)
  love.graphics.draw(k_tiles_trans, quads.block, x+(16*2), y+16)

  love.graphics.draw(k_tiles_trans, quads.b, x-8, y+32)
  love.graphics.draw(k_tiles_trans, quads.block, x-8, y+32)
  love.graphics.draw(k_tiles_trans, quads.l, x-8+(16*1), y+32)
  love.graphics.draw(k_tiles_trans, quads.block, x-8+(16*1), y+32)
  love.graphics.draw(k_tiles_trans, quads.o, x-8+(16*2), y+32)
  love.graphics.draw(k_tiles_trans, quads.block, x-8+(16*2), y+32)
  love.graphics.draw(k_tiles_trans, quads.c, x-8+(16*3), y+32)
  love.graphics.draw(k_tiles_trans, quads.block, x-8+(16*3), y+32)
  love.graphics.draw(k_tiles_trans, quads.k, x-8+(16*4), y+32)
  love.graphics.draw(k_tiles_trans, quads.block, x-8+(16*4), y+32)
  love.graphics.draw(k_tiles_trans, quads.s, x-8+(16*5), y+32)
  love.graphics.draw(k_tiles_trans, quads.block, x-8+(16*5), y+32)

end
