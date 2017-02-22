# Dependencies and installation
For simplicity's sake, prerequisites (OpenCV and ImageMagick) were containerized.
The only prerequisite is therefore docker installed.

### Sepia and Overlay
Example which shows how to apply a sepia effect over an image, and add a author name overlay.

![Sepia and Overlay](http://res.cloudinary.com/demo/image/upload/e_sepia:60/l_text:Arial_30:John%20Doe%20Photography%20%C2%AE,co_white,g_south_east,b_rgb:00000090/w_250/yellow_tulip.png
)
```
docker run --volume=$(pwd):/app cloudinaryltd/imagemagick_blog ruby sepia_and_overlay.rb <source> <author> <dest>
```

```
docker run --volume=$(pwd):/app cloudinaryltd/imagemagick_blog ruby sepia_and_overlay.rb pictures/yellow_tulip.png "John Doe Photography" result.jpg
```

### Text Textures
Example which shows how to apply a texture image over a text.

![Text Textures](http://res.cloudinary.com/demo/image/upload/l_text:Coustard_100_bold:Flowers,fl_cutter/w_250/yellow_tulip.png)
```
docker run --volume=$(pwd):/app cloudinaryltd/imagemagick_blog ruby text_textures.rb <text> <source> <dest>
```

```
docker run --volume=$(pwd):/app cloudinaryltd/imagemagick_blog ruby text_textures.rb "Flowers" pictures/yellow_tulip.png result.jpg
```

### Pixelate Faces
Example which shows how to leverage OpenCV face detection capabilities with ImageMagick.
Specifically it shows how to 'pixelate' faces in a source image.

![Pixelate Faces](http://res.cloudinary.com/demo/image/fetch/e_pixelate_faces/w_250/http://upload.wikimedia.org/wikipedia/commons/4/45/Spain_national_football_team_Euro_2012_final.jpg)

```
docker run --volume=$(pwd):/app cloudinaryltd/imagemagick_blog ruby pixelate_faces.rb <source> <dest>
```

```
docker run --volume=$(pwd):/app cloudinaryltd/imagemagick_blog ruby pixelate_faces.rb pictures/spain_football_team.jpg result.jpg
```
