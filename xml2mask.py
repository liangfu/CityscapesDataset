#!/usr/bin/env python

"""
usage example:
  python olist2mask.py Anno_OList/SSDB00001_olist.mat StreetScenes/SegmentationClass/000001.png
"""

import cv2
import numpy as np
import xml, sys, os
from utils import getpallete
import Image
from pprint import pprint

w, h = 1280, 960
pallete = getpallete(256)
classes = ['__background__','sky','building','store','tree',
           'road','sidewalk','car','bicycle','pedestrian']
priority=range(len(classes))
class2id=dict(zip(classes,priority))
id2class=dict(zip(priority,classes))

# pprint(np.array(pallete).reshape((256,3)))

def main():
    basename,extname = os.path.splitext(sys.argv[1])
    segfile = sys.argv[2] # basename+'.png'
    print(segfile)
    mask = np.zeros((h, w)).astype(np.uint8)
    fp = open(sys.argv[1])
    version = fp.readline()
    nclasses = int(fp.readline().split()[0])
    objects = {}
    print '%s has %d nclasses' % (os.path.basename(sys.argv[1]),nclasses,)
    for t in range(nclasses):
        classname = fp.readline().split()[0]
        if classname not in classes:
            raise Exception("class name %s not in dictionary." % (classname,))
        objects[classname]=[]
        nobjects = int(fp.readline().split()[0])
        for obj in range(nobjects):
            info = fp.readline()
            xpos = map(lambda x:int(x), fp.readline().split())
            ypos = map(lambda x:int(x), fp.readline().split())
            pts = np.array([xpos,ypos],np.int32).T #[:-1,:]
            objects[classname].append(pts)
        fp.readline()
        # print '\t%d %s' % (nobjects, classname, )
    # pprint(objects)
    for classname in classes:
        idval = class2id[classname]

        # set `sky,building,store,tree` to background
        # if idval<5: idval=0 
        # idval=idval-4
        if idval>=3: idval = idval-1

        if objects.get(classname) is not None:
            # cv2.drawContours(mask, objects[classname], -1, idval,cv2.FILLED)
            for obj in objects[classname]:
                cv2.fillPoly(mask, [obj], idval)
        # else:
        #     print 'no',classname
    out_img = Image.fromarray(mask)
    out_img.putpalette(pallete)
    out_img.save(segfile)
        
if __name__=='__main__':
    main()
