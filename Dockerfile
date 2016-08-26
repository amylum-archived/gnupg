FROM dock0/pkgforge
MAINTAINER akerl <me@lesaker.org>
RUN pacman -S --needed --noconfirm transfig ghostscript imagemagick librsvg
