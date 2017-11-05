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

package frEngine.loaders.resource.info.image {
import flash.display.BitmapData;
import flash.events.Event;
import flash.utils.ByteArray;
import flash.utils.Endian;
/**
 * Handles dealing with targa image files.
 * +--------------------------------------+
 * | File Header                          |
 * +--------------------------------------+
 * | Bitmap Data                          |
 * +--------------------------------------+
 *
 * @author Wish
 */
public class TgaParser extends Image implements IImage {

    private var  FHimageIDLength   :int   =    0;
    private var  FHcolorMapType    :int   =    0; // 0 = no pallete
    private var  FHimageType       :int   =    0; // uncompressed RGB=2, uncompressed grayscale=3
    private var  FHcolorMapOrigin  :int   =    0;
    private var  FHcolorMapLength  :int   =    0;
    private var  FHcolorMapDepth   :int   =    0;
    private var  FHimageXOrigin    :int   =    0;
    private var  FHimageYOrigin    :int   =    0;
    private var  FHbitCount        :int   =    0; // 16,24,32
    private var  FHimageDescriptor :int   =    0; // 24 bit = 0x00, 32-bit=0x08
    private var  filePointer       :int   =    0;
    private var  fileContents      :ByteArray = null;


    public function TgaParser(bytes:ByteArray=null) 
	{
		if(bytes)
		{
			onLoad(null,bytes);
		}
    }
    public function getBPP():int {
        return FHbitCount;
    }
  public  function getImage():BitmapData{
	  var width :int = getWidth();
	  var height:int = getHeight();
      var bytePerPixel:int= getBPP()/8;

      var bitmap:BitmapData=new BitmapData(width,height,true,0x00000000);

      var imageData:Array = getData();
	  var i:int,j:int,index:int,alpha:int,color:int;
	  var maxH:int=height-1;
	  var bmpY:int;
	  if(bytePerPixel==4)
	  {
		  for(j = maxH; j >= 0; j--)
		  {
			  bmpY=maxH-j;
			  for(i = 0; i < width; i++) 
			  {
				  index = (j * width + i) * bytePerPixel;
				  color   =   (imageData[index + 3] & 0xFF) << 24|
							  (imageData[index + 0] & 0xFF) << 16|
							  (imageData[index + 1] & 0xFF) <<  8|
							  (imageData[index + 2] & 0xFF);
				  bitmap.setPixel32(i,bmpY, color);
			  }
		  }
	  }else
	  {
		  alpha= 255;
		  try
		  {
			  for(j = maxH; j >= 0; j--)
			  {
				  bmpY=maxH-j;
				  for(i = 0; i < width; i++) 
				  {
					  index = (j * width + i) * bytePerPixel;
					  color   =   (       alpha         & 0xFF) << 24|
						  (imageData[index + 0] & 0xFF) << 16|
						  (imageData[index + 1] & 0xFF) <<  8|
						  (imageData[index + 2] & 0xFF);
					  bitmap.setPixel32(i,bmpY, color);
				  }
			  } 
		  }catch(e:Error)
		  {
			  trace("tga paser error!");
		  }
		 
		  
	  }
      
        
      return bitmap;
    }

  public function printHeaders():void {
    trace("-----------------------------------");
    trace("File Header");
    trace("-----------------------------------");
    trace("      Image ID Length:"+FHimageIDLength);
    trace("       Color Map Type:"+FHcolorMapType);
    trace("           Image Type:"+FHimageType);
    trace("     Color Map Origin:"+FHcolorMapOrigin);
    trace("     Color Map Length:"+FHcolorMapLength);
    trace(" Color Map Entry Size:"+FHcolorMapDepth);
    trace("       Image X Origin:"+FHimageXOrigin);
    trace("       Image Y Origin:"+FHimageYOrigin);
    trace("                Width:"+imageWidth);
    trace("               Height:"+imageHeight);
    trace("                  BBP:"+FHbitCount);
    trace("     Image Descriptor:"+FHimageDescriptor);
  }
  public override function onLoad(event:Event,stream:ByteArray=null):void 
  {
    // reset everything
    FHimageIDLength   = 0;
    FHcolorMapType    = 0;
    FHimageType       = 0;
    FHcolorMapOrigin  = 0;
    FHcolorMapLength  = 0;
    FHcolorMapDepth   = 0;
    FHimageXOrigin    = 0;
    FHimageYOrigin    = 0;
    imageWidth           = 0;
    imageHeight          = 0;
    FHbitCount        = 0;
    FHimageDescriptor = 0;
    filePointer       = 0;

	if(event)
	{
		stream= ByteArray(event.target.data);
	}
	
	stream.endian = Endian.LITTLE_ENDIAN;
	stream.position=0;
	fileContents = new ByteArray();
	stream.readBytes(fileContents,0,stream.bytesAvailable);


      // read the file header
      FHimageIDLength   = readUnsignedByte();
      FHcolorMapType    = readUnsignedByte();
      FHimageType       = readUnsignedByte();
      FHcolorMapOrigin  =        readShort();
      FHcolorMapLength  =        readShort();
      FHcolorMapDepth   = readUnsignedByte();
      FHimageXOrigin    =        readShort();
      FHimageYOrigin    =        readShort();
      imageWidth           =        readShort();
      imageHeight          =        readShort();
      FHbitCount        = readUnsignedByte();
      FHimageDescriptor = readUnsignedByte();

      if(FHimageType == 10) 
	  { 
		loadCompressed();
      }else if(FHimageType==2 || FHimageType==3)
	  {
		  loadUncompressed();
	  }

     
	 fileContents = null;
	 dispatchEvent(new Event(Image.ONLOADCOMPLETE));

  }
  private function loadUncompressed():void 
  {
	  var bytesPerPixel:int = FHbitCount/8;
	  data = new Array(imageWidth*imageHeight*bytesPerPixel);
	  var len:int=data.length;
	  var i:int=0;
	  if(bytesPerPixel==3)
	  {
		  for(i=0;i<len;i+=3)
		  {
			  data[i]=fileContents[filePointer+i+2];
			  data[i+1]=fileContents[filePointer+i+1];
			  data[i+2]=fileContents[filePointer+i];
		  }
	  }else
	  {
		  for(i=0;i<len;i+=4)
		  {
			  data[i]=fileContents[filePointer+i+2];
			  data[i+1]=fileContents[filePointer+i+1];
			  data[i+2]=fileContents[filePointer+i];
			  data[i+3]=fileContents[filePointer+i+3];
		  }
	  }
  }
  private function loadCompressed():void {
      printHeaders();
	  var bytesPerPixel:int = Math.floor(FHbitCount/8);
      data = new Array(imageWidth*imageHeight*bytesPerPixel);

      var pixelcount:int  = imageWidth*imageHeight;
      var currentbyte:int  = 0;
	  var currentpixel:int = 0;

      var colorbuffer:Array = new Array(bytesPerPixel);

      do
	  {
        var chunkheader:int = 0;
        chunkheader = readUnsignedByte();
        if(chunkheader < 128)
		{
          chunkheader++;
          for(var counter:int = 0; counter < chunkheader; counter++)
		  {

            readColorBuffer(colorbuffer);
            data[currentbyte + 0] = colorbuffer[2];
            data[currentbyte + 1] = colorbuffer[1];
            data[currentbyte + 2] = colorbuffer[0];

            if(bytesPerPixel == 4)
			{
				data[currentbyte + 3] = readUnsignedByte();
			}
              

            currentbyte += bytesPerPixel;
            currentpixel++;
            if(currentpixel > pixelcount)
			{
             	//throw new IOException("Too many pixels read");
		    	trace("Too many pixels read");
			}
          }
        } 
		else 
		{
          chunkheader -= 127;
          readColorBuffer(colorbuffer);
          for(counter = 0; counter < chunkheader; counter++)
		  {																			// by the header
            data[currentbyte + 0] = colorbuffer[2];
            data[currentbyte + 1] = colorbuffer[1];
            data[currentbyte + 2] = colorbuffer[0];

            if(bytesPerPixel == 4)
              data[currentbyte + 3] = readUnsignedByte();

            currentbyte += bytesPerPixel;
            currentpixel++;
            if(currentpixel > pixelcount){
              	//throw new IOException("Too many pixels read");
		    	trace("Too many pixels read");
			}
          }
        }
      } while (currentpixel < pixelcount);
  }

  private function readColorBuffer( buffer:Array):void {
    buffer[0] = readUnsignedByte();
    buffer[1] = readUnsignedByte();
    buffer[2] = readUnsignedByte();
  }

  private function readUnsignedByte():int {
	return  fileContents[filePointer++] & 0xFF;
  }

  private function readShort():int {
     var s1:int = (fileContents[filePointer++] & 0xFF);
     var s2:int = (fileContents[filePointer++] & 0xFF) << 8;
    return (s1 | s2);
  }
}
}