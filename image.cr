require "magickwand-crystal"
require "./colors.cr"

# Init with image
LibMagick.magickWandGenesis
wand = LibMagick.newMagickWand
LibMagick.magickReadImage wand, "tmp/github.svg"

# Resize
w1 = LibMagick.magickGetImageWidth(wand) / 5
h1 = LibMagick.magickGetImageHeight(wand) / 5
LibMagick.magickScaleImage wand, w1, h1
LibMagick.magickWriteImage wand, "tmp/github.png"

# Get information from image
LibMagick.magickReadImage wand, "tmp/github.png"
width = LibMagick.magickGetImageWidth(wand)
height = LibMagick.magickGetImageHeight(wand)

def code_for_pixel(pixel)
  red = LibMagick.pixelGetRed(pixel)
  green = LibMagick.pixelGetGreen(pixel)
  blue = LibMagick.pixelGetBlue(pixel)
  code = rgb(red, green, blue)
  code_for_colour(code)
end

def rgb(r, g, b)
  "#%02x%02x%02x" % [r, g, b].map { |v| v * 255 + 0.5 }
end

def code_for_colour(colour)
  if COLORS.includes?(colour)
    return COLORS.index(colour)
  end
  0
end

BLOCK = "\x1b[38;5;%dm\x1b[38;5;%dm"

def get_block(bgcolor, fgcolor=0, width=5)
  return BLOCK % [bgcolor, fgcolor]
end

lower_pixel = LibMagick.newPixelWand()
upper_pixel = LibMagick.newPixelWand()

(0..height).step(2).each do |i|
  (0..width).step(1).each do |j|
    LibMagick.magickGetImagePixelColor(wand, j, i, upper_pixel)
    upper_code = code_for_pixel(upper_pixel)
    lower_code = 0
    if (i+1) < height
      LibMagick.magickGetImagePixelColor(wand, j, i+1, lower_pixel)
      lower_code = code_for_pixel(lower_pixel)
    end
    printf get_block(lower_code, upper_code)
    print "•"
    print "\n" if j == width
  end
end
# End
LibMagick.destroyMagickWand wand
LibMagick.magickWandTerminus
