require 'rmagick'

if ARGV.length < 3
  puts "Usage: ruby #{__FILE__} source author dest"
  exit
end

SEPIA_LEVEL = Magick::QuantumRange * 60 / 100
def sepiatize_image!(image)
  image.sepiatone(SEPIA_LEVEL)
end

def add_author_to_image!(image, author)
  # Create the Draw object, and set it's properties.
  text = Magick::Draw.new
  text.fill = "white"
  text.font_family = "Arial"
  text.pointsize = 30
  text.gravity = Magick::CenterGravity

  # Overlay image size should match the text dimensions.
  # We therefore calculate the text dimensions before creating the overlay image.
  metrics = text.get_type_metrics(author)

  author_overlay = Magick::Image.new(metrics.width, metrics.height) {
    # Background color is a semi transparent 'black' (notice the last 2 hexa digits, which represent the alpha channel).
    self.background_color = "#00000080"
  }

  # Draw the text over the semi transparent background.
  text.annotate(author_overlay, 0, 0, 0, 0, author)

  # Position the author overlay on top of the given image
  image.composite!(author_overlay, Magick::SouthEastGravity, Magick::OverCompositeOp)

  # Don't forget to clean up!
  author_overlay.destroy!

  image
end

source_image = Magick::Image.read(ARGV[0]).first
author = ARGV[1]
dest = ARGV[2]

add_author_to_image!(sepiatize_image!(source_image), author).write(dest)

# Or you can simply use Cloudinary:
# http://res.cloudinary.com/demo/image/upload/e_sepia:60/l_text:Arial_30:John%20Doe%20Photography%20%C2%AE,co_white,g_south_east,b_rgb:00000090/yellow_tulip.png
