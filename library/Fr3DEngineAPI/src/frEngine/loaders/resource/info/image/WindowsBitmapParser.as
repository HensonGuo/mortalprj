/*
 * Copyright (c) 2003, Xith3D Project Group
 * All rights reserved.
 *
 * Portions based on the Java3D interface, Copyright by Sun Microsystems.
 * Many thanks to the developers of Java3D and Sun Microsystems for their
 * innovation and design.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * Neither the name of the 'Xith3D Project Group' nor the names of its
 * contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) A
 * RISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE
 *
 */

package frEngine.loaders.resource.info.image{
import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.events.Event;
/**
 * Handles dealing with windows bitmap files. This class doesn't handle palettized files.
 * +--------------------------------------+
 * | Bitmap File Header                   |
 * +--------------------------------------+
 * | Bitmap Information Header            |
 * +--------------------------------------+
 * | Palette Data (only in 8 bit files)   |
 * +--------------------------------------+
 * | Bitmap Data                          |
 * +--------------------------------------+
 *
 * @author Wish
 */
public class WindowsBitmapParser extends Image implements IImage {

  private var    FHsize:int             =    0;
  private var    FHreserved1:int        =    0;
  private var    FHreserved2:int        =    0;
  private var    FHoffsetBits:int       =    0;

  private var    IHsize :int            =    0;
  private var    IHplanes:int           =    0;
  private var    IHbitCount:int         =    0;
  private var    IHcompression:int      =    0;
  private var    IHsizeImage:int        =    0;
  private var    IHxpelsPerMeter:int    =    0;
  private var    IHypelsPerMeter :int   =    0;
  private var    IHcolorsUsed  :int     =    0;
  private var    IHcolorsImportant:int  =    0;
  private var    filePointer:int        =    0;
  private var    fileContents:ByteArray  ;

    public function WindowsBitmapParser() {
    }
    public function getBPP():int {
        return IHbitCount;
    }
    public function getImage():BitmapData{

      var width :int = getWidth();

	var height:int = getHeight();

      var bitmap:BitmapData=new BitmapData(width,height,true,0x00000000);

      var imageData:Array = getData();
      for(var j:int = height - 1; j >= 0; j--)
        for(var i:int = 0; i < width; i++) {
             var index:int = ((height - 1 - j)* width + i) * 3;
             var color:uint= (        255          & 0xFF) << 24|
                             (imageData[index + 2] & 0xFF) << 16|
                             (imageData[index + 1] & 0xFF) <<  8|
                             (imageData[index + 0] & 0xFF);
            bitmap.setPixel32(i,j, color);
        }
      return bitmap;
	}
    public function printHeaders():void {
        trace("-----------------------------------");
        trace("File Header");
        trace("-----------------------------------");
        trace("            File Size:"+FHsize);
        trace("           Reserved 1:"+FHreserved1);
        trace("           Reserved 2:"+FHreserved2);
        trace("          Data offset:"+FHoffsetBits);
        trace("-----------------------------------");
        trace("Info Header");
        trace("-----------------------------------");
        trace("     Info Header Size:"+IHsize);
        trace("                Width:"+imageWidth);
        trace("               Height:"+imageHeight);
        trace("               Planes:"+IHplanes);
        trace("                  BPP:"+IHbitCount);
        trace("          Compression:"+IHcompression);
        trace("           Image size:"+IHsizeImage);
        trace("     Pels Per Meter X:"+IHxpelsPerMeter);
        trace("     Pels Per Meter Y:"+IHypelsPerMeter);
        trace("     # of Colors Used:"+IHcolorsUsed);
        trace("# of Important Colors:"+IHcolorsImportant);
    }
    private function readShort():uint{
	var s1:uint = (fileContents[filePointer++] & 0xFF);
	var s2:uint = (fileContents[filePointer++] & 0xFF) << 8;
        return ((s1 | s2));
    }
    private function readInt():int{
     return   (fileContents[filePointer++] & 0xFF)      |
              (fileContents[filePointer++] & 0xFF) <<  8|
              (fileContents[filePointer++] & 0xFF) << 16|
              (fileContents[filePointer++] & 0xFF) << 24;
    }
    public override function onLoad(event:Event,stream:ByteArray=null):void {
	 // reset everything 
        FHsize            = 0;
        FHreserved1       = 0;
        FHreserved2       = 0;
        FHoffsetBits      = 0;
        IHsize            = 0;
        imageWidth        = 0;
        imageHeight       = 0;
        IHplanes          = 0;
        IHbitCount        = 0;
        IHcompression     = 0;
        IHsizeImage       = 0;
        IHxpelsPerMeter   = 0;
        IHypelsPerMeter   = 0;
        IHcolorsUsed      = 0;
        IHcolorsImportant = 0;
        filePointer       = 0;

		if(event)
		{
			stream= ByteArray(event.target.data);
		}
		
		trace("WindowsBitmapFile �ļ���ʼ���룡");
		stream.endian = Endian.LITTLE_ENDIAN;
		fileContents = new ByteArray();
            stream.readBytes(fileContents,0,stream.bytesAvailable);

            var magicNumber:int = readShort();

            //   FHtype
            // make sure it's windows bitmap file
            if(magicNumber != 19778)
            {
                fileContents = null;
		    trace('this is not the windows bitmap file!');
                return;
            }

            // read the file header
            FHsize       = readInt();
            FHreserved1  = readShort();
            FHreserved2  = readShort();
            FHoffsetBits = readInt();

            // read the info header
            IHsize            = readInt();
            imageWidth           = readInt();
            imageHeight          = readInt();
            IHplanes          = readShort();
            IHbitCount        = readShort();
            IHcompression     = readInt();
            IHsizeImage       = readInt();
            IHxpelsPerMeter   = readInt();
            IHypelsPerMeter   = readInt();
            IHcolorsUsed      = readInt();
            IHcolorsImportant = readInt();

            // allocate memory for the pixel data
            data = new Array(IHsizeImage);

           // System.arraycopy(fileContents, FHoffsetBits, data, 0, IHsizeImage);
	     for(var i:int=0;i<IHsizeImage;i++){
		     data[i]=fileContents[FHoffsetBits+i];
		}
            fileContents = null;

            // swap the R and B values to get RGB, bitmap color format is BGR
           // for(var loop:int=0;loop<IHsizeImage;loop+=3)
            //{
               // var btemp:uint = data[loop];
               // data[loop] = data[loop+2];
               // data[loop+2] = btemp;
            //}
		printHeaders();
		trace("WindowsBitmapFile �ļ�������� !");
		dispatchEvent(new Event(Image.ONLOADCOMPLETE));
	}
    }
}