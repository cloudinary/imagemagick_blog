require 'opencv'
require 'rmagick'

include OpenCV

if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} source dest"
  exit
end

def transform_faces(image_file, output_file, operation)
  image = Magick::Image.read(image_file).first

  # This example uses the `ruby-opencv` gem in order to detect face regions.
  # `detect_faces` can be easily modified to use a different face detection library or implementation.
  detect_faces(image_file).each do |region|
    transform_region!(image, region, operation)
  end

  image.write(output_file)
end

HAARCASCADE_FILE_PATH = './data/haarcascades/haarcascade_frontalface_alt.xml'
def detect_faces(image_file)
  detector = CvHaarClassifierCascade::load(HAARCASCADE_FILE_PATH)
  image = CvMat.load(image_file)
  detector.detect_objects(image)
end

def transform_region!(image, region, operation)
  cropped_region = image.crop(region.top_left.x, region.top_left.y, region.width, region.height)
  cropped_region = send("#{operation}_image!", cropped_region)
  image.composite!(cropped_region, region.top_left.x, region.top_left.y, Magick::OverCompositeOp)
  cropped_region.destroy!
  image
end

PIXELATE_FACTOR = 5
def pixelate_image!(image)
  image.scale!(1 / PIXELATE_FACTOR.to_f).scale!(PIXELATE_FACTOR)
end

# We could easily add additional operations:
# def blur_image!(image)
#   image.blur_image(0, 3)
# end

source = ARGV[0]
dest = ARGV[1]

transform_faces(source, dest, "pixelate")

# Or you can simply use Cloudinary:
# http://res.cloudinary.com/demo/image/fetch/e_pixelate_faces/http://upload.wikimedia.org/wikipedia/commons/4/45/Spain_national_football_team_Euro_2012_final.jpg
# http://res.cloudinary.com/demo/image/fetch/e_blur_faces/http://upload.wikimedia.org/wikipedia/commons/4/45/Spain_national_football_team_Euro_2012_final.jpg
