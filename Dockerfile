FROM ruby:2.2
MAINTAINER Cloudinary <support@cloudinary.com>

# Install Microsoft fonts
RUN echo "deb http://http.us.debian.org/debian jessie contrib" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org jessie/updates contrib" >> /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y ttf-mscorefonts-installer

# Install OpenCV
RUN apt-get install -y unzip cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
RUN wget http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.13/opencv-2.4.13.zip/download -O /tmp/opencv-2.4.13.zip
RUN unzip /tmp/opencv-2.4.13.zip -d /tmp/
RUN mkdir /tmp/opencv-2.4.13/release
RUN cd /tmp/opencv-2.4.13/release && cmake -D WITH_FFMPEG=0 -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local .. && make && make install
RUN rm -rf /tmp/opencv-2.4.13

# Create home directory
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install Gems
ADD Gemfile* $APP_HOME/
RUN bundle install

ADD . $APP_HOME
