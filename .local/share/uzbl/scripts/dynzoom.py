#!/usr/bin/env python

# dynzoom.py - dynamic zooming for uzbl, based on dynzoom.js
# Usage:
# @on_event GEOMETRY_CHANGED spawn /path/to/dynzoom.py \@geometry 1024 768
# Where 1024x768 is the resolution where we start to zoom out

import sys, re

" Parses WxH+X+Y into a 4-tuple of ints "
def get_geometry(geo):
    return map(int, re.match(r'(\d+)x(\d+)[\+-](\d+)[\+-](\d+)', geo).groups())

" Calculate the zoom level "
def calc_zoom(geo, min_width, min_height):
    width, height, x, y = get_geometry(geo)
    w = min(1, width/float(min_width))
    h = min(1, height/float(min_height))
    return (w + h)/2

" Set the zoom level "
def set_zoom(fifo, level):
    with open(fifo, 'a') as f:
        f.write('set zoom_level = %f\n' % level)
if __name__ == '__main__':
    set_zoom(sys.argv[4], calc_zoom(*sys.argv[8:11]))
