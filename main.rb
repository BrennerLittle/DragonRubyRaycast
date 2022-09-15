$mapX = 8
$mapY = 8
$mapS = 64
$map = [
  1, 1, 1, 1, 1, 1, 1, 1,
  1, 0, 1, 0, 0, 0, 0, 1,
  1, 0, 1, 0, 0, 0, 0, 1,
  1, 0, 1, 0, 0, 0, 0, 1,
  1, 0, 0, 0, 0, 0, 0, 1,
  1, 0, 0, 0, 0, 1, 0, 1,
  1, 0, 0, 0, 0, 0, 0, 1,
  1, 1, 1, 1, 1, 1, 1, 1,
]
$px = 250
$py = 250
$pdx = 0
$pdy = 0
$pa = 0

def drawMap2D args

for y in 0..$mapY - 1 do
  for x in 0..$mapX - 1 do

    if $map[y.to_i * $mapX + x.to_i] == 1

color = [1, 1, 1]
else

  color = [255, 255, 255]
end
xo = x.to_i * $mapS
yo = y.to_i * $mapS

args.render_target(:map).solids << [xo, yo, 64, 64, color]
end
end

end
def degToRad a
  return a * Math::PI / 180.0
end
def FixAng a
  if a > 359
    a -= 360
  end
  if a < 0
    a += 360
  end
  return a
end
def drawPlayer2D args

  args.render_target(:map).solids << [$px, $py, 8, 8, 255, 255,0]

end
def pinput args

  xo=0
  
   if $pdx<0
     xo=-20
    else
      xo=20
  end                                
  yo=0
   if $pdy<0
     yo=-20
   else 
    yo= 20 
  end                                 
  ipx=$px/64.0
  ipx = ipx.to_i
  ipx_add_xo=($px+xo)/64.0 
  ipx_add_xo = ipx_add_xo.to_i
  ipx_sub_xo=($px-xo)/64.0   
  ipx_sub_xo = ipx_sub_xo.to_i  
  ipy=$py/64.0
  ipy = ipy.to_i
  ipy_add_yo=($py+yo)/64.0
  ipy_add_yo = ipy_add_yo.to_i
  ipy_sub_yo=($py-yo)/64.0
  ipy_sub_yo = ipy_sub_yo.to_i        
  if args.inputs.keyboard.key_held.right
    $pa -= 5
    $pa = FixAng($pa)
    $pdx = Math.cos(degToRad($pa))
    $pdy = -Math.sin(degToRad($pa))
  end
  if args.inputs.keyboard.key_held.left
    $pa += 5
    $pa = FixAng($pa)
    $pdx = Math.cos(degToRad($pa))
    $pdy = -Math.sin(degToRad($pa))
  end
  if args.inputs.keyboard.key_held.up

    if $map[ipy*$mapX + ipx_add_xo]==0
      $px += $pdx * 5
    end
    
  if $map[ipy_add_yo * $mapX + ipx]==0 
    $py += $pdy * 5
  end

  end
  if args.inputs.keyboard.key_held.down
    if $map[ipy*$mapX        + ipx_sub_xo]==0
      $px -= $pdx * 5
    end
    if $map[ipy_sub_yo*$mapX + ipx       ]==0
      $py -= $pdy * 5
    end

  end
  args.render_target(:map).solids << [ipx*64.to_i,ipy*64.to_i, 64, 64, 255, 0,0]
end
def distance ax, ay, bx, by, ang
  return Math.Cos(degToRad(ang)) * (bx - ax) - Math.Sin( degToRad(ang) ) * (by - ay)
end
def drawRays2D args


args.render_target(:screen).solids << [0, 0, 750, 160, 0,255,255]
args.render_target(:screen).solids << [0, 160, 750, 160, 0,0,255]


ra = FixAng($pa + 30) 
for r in 0..60 do
    
      dof = 0
      side = 0
      disV = 100000
      tan = Math.tan(degToRad(ra))
      if Math.cos(degToRad(ra)) > 0.001
      rx = (($px >> 6) << 6) + 64
      ry = ($px - rx) * tan + $py;
      xo = 64
      yo = -xo * tan

      elsif Math.cos(degToRad(ra)) < -0.001
      rx = (($px >> 6) << 6) - 0.0001
      ry = ($px - rx) * tan + $py
      xo = -64
      yo = -xo * tan 

      else
      rx = $px
      ry = $py
      dof = 8 
      end
      while dof < 8

      mx = rx >> 6
      mx = mx.to_i
      my = ry >> 6
      my = my.to_i
      mp = my * $mapX + mx
      if mp > 0 && mp < $mapX * $mapY && $map[mp] == 1
        dof = 8
        disV = Math.cos(degToRad(ra)) * (rx - $px) - Math.sin(degToRad(ra)) * (ry - $py)    
      else
        rx += xo
        ry += yo
        dof += 1
      end
      end
      vx = rx
      vy = ry


      dof = 0
      disH = 100000
      tan = 1.0 / tan
      if Math.sin(degToRad(ra)) > 0.001

        ry = (($py >> 6) << 6) - 0.0001;
        rx = ($py - ry) * tan + $px;
        yo = -64;
        xo = -yo * tan;
        
 
      elsif Math.sin(degToRad(ra)) < -0.001
      ry = (($py >> 6) << 6) + 64;
      rx = ($py - ry) * tan + $px;
      yo = 64;
      xo = -yo * tan;

      else
        rx = $px
      ry = $py
      dof = 8
      end


      while dof < 8

      mx = (rx) >> 6
      my = (ry) >> 6
      mp = my *$mapX + mx
      if mp > 0 && mp <$mapX * $mapY && $map[mp] == 1
      dof = 8
      disH = Math.cos(degToRad(ra)) * (rx - $px) - Math.sin(degToRad(ra)) * (ry - $py) # //hit         
      else
        rx += xo
      ry += yo
      dof += 1
      end
    end

 
      col= [0,204,0]
      if disV < disH
      rx = vx
      ry = vy
      disH = disV

      col = [0,153,0]
      end


args.render_target(:map).lines << [$px, $py, rx, ry,col]

ca = FixAng($pa - ra);
disH = disH * Math.cos(degToRad(ca)) 
lineH = ($mapS * 320) / (disH)
if lineH > 320
lineH = 320
end

lineOff = 160 - (lineH >> 1) 

args.render_target(:screen).solids << [r*8, lineOff, 8, lineH, col]

ra = FixAng(ra - 1)
end
end
def tick args

drawMap2D args
drawPlayer2D args
pinput args
drawRays2D args
args.outputs.sprites << [ 0,0,1280*2.66,720*2.25,:screen]
args.outputs.sprites << [ 0,592,1280/4,720/4,:map]
args.outputs.labels << [0, 20, "FPS: #{args.gtk.current_framerate.round}"]

end
