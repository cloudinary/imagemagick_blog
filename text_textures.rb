require 'rmagick'

if ARGV.length < 3
  puts "Usage: ruby #{__FILE__} text texture_file dest"
  exit
end

def create_text_mask(text)
  draw = Magick::Draw.new
  draw.fill = "white"
  draw.font_family = "Arial"
  draw.pointsize = 100
  draw.font_weight = Magick::BoldWeight
  draw.gravity = Magick::CenterGravity

  metrics = draw.get_type_metrics(text)
  mask = Magick::Image.new(metrics.width, metrics.height) { self.background_color = "transparent" }

  draw.annotate(mask, 0, 0, 0, 0, text)
  mask
end

def cut_image_to_text!(image, text)
  mask = create_text_mask(text)

  # Copy the mask's pixels alpha channel (which controls opacity) to the image's pixels.
  # This results the hiding of all image pixels which are not part of the text letters region.
  image.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)
  mask.destroy!
  image.trim!
end

# Turns all transparent pixels in the image to opaque white.
# Needed when the dest format is 'jpeg', which does not honor image opacity.
def opacify!(image)
  opacified = Magick::Image.new(image.columns, image.rows) { self.background_color = "white" }
  opacified.composite!(image, Magick::CenterGravity, Magick::OverCompositeOp)
  image.destroy!
  opacified
end

text = ARGV[0]
source = Magick::Image.read(ARGV[1]).first
dest = ARGV[2]

opacify!(cut_image_to_text!(source, text)).write(dest)

# Or you can simply use cloudinary:
# http://res.cloudinary.com/demo/image/upload/l_text:Arial_100_bold:Flowers,fl_cutter/yellow_tulip.png
