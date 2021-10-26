#!/usr/bin/env python3
#
# Compute extents of a binary mask on all axes, reporting in mm RAS

import argparse
import nibabel
import numpy

parser = argparse.ArgumentParser()
parser.add_argument('img_niigz')
args = parser.parse_args()
img_niigz = args.img_niigz

img = nibabel.load(img_niigz)
imgdata = img.get_fdata()

locs = numpy.where(imgdata>0)

imin = min(locs[0])
imax = max(locs[0])
jmin = min(locs[1])
jmax = max(locs[1])
kmin = min(locs[2])
kmax = max(locs[2])

x1 = nibabel.affines.apply_affine(img.affine,[imin, jmin, kmin])[0]
x2 = nibabel.affines.apply_affine(img.affine,[imax, jmax, kmax])[0]
y1 = nibabel.affines.apply_affine(img.affine,[imin, jmin, kmin])[1]
y2 = nibabel.affines.apply_affine(img.affine,[imax, jmax, kmax])[1]
z1 = nibabel.affines.apply_affine(img.affine,[imin, jmin, kmin])[2]
z2 = nibabel.affines.apply_affine(img.affine,[imax, jmax, kmax])[2]

xmin = round(min(x1, x2))
xmax = round(max(x1, x2))
ymin = round(min(y1, y2))
ymax = round(max(y1, y2))
zmin = round(min(z1, z2))
zmax = round(max(z1, z2))

#print(f'{imin} {imax} {jmin} {jmax} {kmin} {kmax}')

print(f'{xmin} {xmax} {ymin} {ymax} {zmin} {zmax}')
