


//flare.utils.Texture3DUtils

package baseEngine.utils
{
    import flash.display.BitmapData;
    import flash.display.Shader;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.textures.CubeTexture;
    import flash.display3D.textures.Texture;
    import flash.display3D.textures.TextureBase;
    import flash.filters.ShaderFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import baseEngine.core.Texture3D;
    import baseEngine.system.Device3D;

    public class Texture3DUtils 
    {

       // private static var NormalMap:Class = Texture3DUtils_NormalMap;
        private static var normalMapData:ByteArray;
        private static var shader:Shader;
        private static var filter:ShaderFilter;
		private static var textureByRequest:Dictionary=new Dictionary(false);
		private static var _id:int=0;
		private static var idMap:Dictionary=new Dictionary(false);
		
        public static function toNormalMap(_arg1:BitmapData, _arg2:Number=1, _arg3:Number=1):BitmapData
        {
            if (!normalMapData)
            {
                //shader = new Shader(new NormalMap());
                shader.data.x.value = [_arg2];
                shader.data.y.value = [_arg3];
                filter = new ShaderFilter(shader);
            };
            _arg1.applyFilter(_arg1, _arg1.rect, new Point(), filter);
            return (_arg1);
        }
		
		
		public static function unloadTexture(_request:*,mipType:int):void
		{
			var _id:String=getTexureId(_request,mipType);
			if(textureByRequest[_id])
			{
				var texture:TextureBase=textureByRequest[_id];
				delete textureByRequest[_id];
				texture.dispose();
			}
			delete idMap[_request];
		}
		
		public static function getTexureId(request:*,mipType:int):String
		{
			var headId:String=idMap[request];
			if(!headId)
			{
				idMap[request]=headId=String(_id);
				_id++;
			}
			return headId+":"+mipType;
		}
		
		
		public static function createTexture(_request:*,_data:*,format:int,typeMode:int,mipType:int,optimizeForRenderToTexture:Boolean):TextureBase
		{
			var _id:String=getTexureId(_request,mipType);
			if(textureByRequest[_id])
			{
				return textureByRequest[_id];
			}
			var mip:Boolean = mipType != Texture3D.MIP_NONE
			var _local2:ByteArray;
			var _local3:int;
			var _local4:int;
			var _local5:String;
			var _local6:Number;
			var _local7:Number;
			var _local8:int;
			var sceneContext:Context3D=Device3D.scene.context;

			if(!sceneContext || !_data)
			{
				return null;
			}
			var texture:TextureBase;
			
			
			if (format == Texture3D.FORMAT_RGBA)
			{
				if ((_data is Point))
				{
					texture=sceneContext.createTexture(_data.x, _data.y, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
					sceneContext.setRenderToTexture(texture);
					sceneContext.clear();
					sceneContext.setRenderToBackBuffer();
				}
				else
				{
					texture=uploadWithMipmaps(null,_data,0,mip,typeMode,optimizeForRenderToTexture,_request);
					
				}
			}
			else
			{
				if (format == Texture3D.FORMAT_COMPRESSED || format == Texture3D.FORMAT_COMPRESSED_ALPHA || format == Texture3D.FORMAT_COMPRESSED_BGRA)
				{
					_local2=(_data as ByteArray);
					_local2.position=6;
					_local3=_local2.readUnsignedByte();
					_local4=(_local3 >> 7);
					switch ((_local3 & 127))
					{
						case 0:
						case 1:
							_local5=Context3DTextureFormat.BGRA;
							break;
						case 2:
						case 3:
							_local5=Context3DTextureFormat.COMPRESSED;
							break;
						case 4:
						case 5:
							_local5="compressedAlpha";
							break;
					}
					_local6=(1 << _local2.readUnsignedByte());
					_local7=(1 << _local2.readUnsignedByte());
					if (_local4 == 0)
					{
						//targetTexture3d.typeMode=TYPE_2D;
						texture=sceneContext.createTexture(_local6, _local7, _local5, optimizeForRenderToTexture);
						Texture(texture).uploadCompressedTextureFromByteArray(_local2, 0,true);
					}
					else
					{
						//targetTexture3d.typeMode=TYPE_CUBE;
						texture=sceneContext.createCubeTexture(_local6, _local5, optimizeForRenderToTexture);
						CubeTexture(texture).uploadCompressedTextureFromByteArray(_local2, 0,true);
					}
				}
				else
				{
					if ((((format == Texture3D.FORMAT_CUBEMAP)) && ((_data is Array))))
					{
						if ((_data is Point))
						{
							texture=sceneContext.createCubeTexture(_data.x, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
						}
						
						_local8=0;
						while (_local8 < 6)
						{
							uploadWithMipmaps(texture,_data[_local8], _local8,mip,typeMode,optimizeForRenderToTexture,_request);
							_local8++;
						}
					}
				}
			}
			textureByRequest[_id]=texture;
			return texture;
		}
		private static function uploadWithMipmaps(texture:TextureBase,bmpdata:BitmapData, _side:int,mipMode:Boolean,typeMode:int,optimizeForRenderToTexture:Boolean,_request:*):TextureBase
		{
			var _local15:BitmapData;
			var _local16:BitmapData;
			var _local4:Number=Device3D.maxTextureSize;
			var _local5:int=(((bmpdata.width < _local4)) ? bmpdata.width : _local4);
			var _local6:int=(((bmpdata.height < _local4)) ? bmpdata.height : _local4);
			var _local7:int=1;
			while (_local7 < _local5)
			{
				_local7=(_local7 << 1);
			}
			
			var _local8:int=1;
			while (_local8 < _local6)
			{
				_local8=(_local8 << 1);
			}
			//trace("create texture ,w:"+_local7+",h:"+_local8+",url:"+_request);
			if (Device3D.isOpenGL)
			{
				var newBitmapdata:BitmapData = new BitmapData(bmpdata.width, bmpdata.height, true, 0x0);
				newBitmapdata.draw(bmpdata);
				bmpdata = newBitmapdata;
			};
			if(!texture)
			{
				var sceneContext:Context3D=Device3D.scene.context;
				texture=sceneContext.createTexture(_local7, _local8, Context3DTextureFormat.BGRA, optimizeForRenderToTexture);
			}
			var _local9:Matrix=new Matrix();
			var _local10:Matrix=new Matrix((_local7 / bmpdata.width), 0, 0, (_local8 / bmpdata.height));
			var _local11:Rectangle=bmpdata.rect;
			var _local12:Rectangle=new Rectangle();
			var _local13:int;
			var _levels:BitmapData;
			var _mips:BitmapData;
			if (!mipMode)
			{
				if (((!((_local7 == _local5))) || (!((_local8 == _local6)))))
				{
					if (!_levels)
					{
						_levels=new BitmapData(_local7, _local8, true, 0);
					}
					else
					{
						_levels.fillRect(_levels.rect, 0);
					}
					
					_levels.draw(bmpdata, _local10, null, null, null, true);
				}
				
				if (typeMode == Texture3D.TYPE_2D)
				{
					Texture(texture).uploadFromBitmapData(((_levels) || (bmpdata)), 0);
				}
				else
				{
					if (typeMode == Texture3D.TYPE_CUBE)
					{
						CubeTexture(texture).uploadFromBitmapData(((_levels) || (bmpdata)), _side, 0);
					}
					
				}
				
			}
			else
			{
				_mips= bmpdata.clone();
				while ((((_local7 >= 1)) || ((_local8 >= 1))))
				{
					if ((((_local7 == _local5)) && ((_local8 == _local6))))
					{
						if (typeMode == Texture3D.TYPE_2D)
						{
							Texture(texture).uploadFromBitmapData(bmpdata, _local13);
						}
						else
						{
							if (typeMode == Texture3D.TYPE_CUBE)
							{
								CubeTexture(texture).uploadFromBitmapData(bmpdata, _side, _local13);
							}
							
						}
						
					}
					else
					{
						_local12.width=_local7;
						_local12.height=_local8;
						if (!_levels)
						{
							_levels=new BitmapData(((_local7) || (1)), ((_local8) || (1)), true, 0);
						}
						else
						{
							_levels.fillRect(_local12, 0);
						}
						
						_levels.draw(_mips, _local10, null, null, _local12, true);
						if (typeMode == Texture3D.TYPE_2D)
						{
							Texture(texture).uploadFromBitmapData(_levels, _local13);
						}
						else
						{
							if (typeMode == Texture3D.TYPE_CUBE)
							{
								CubeTexture(texture).uploadFromBitmapData(_levels, _side, _local13);
							}
							
						}
						
					}
					
					if (_levels)
					{
						_local15=_mips;
						_mips=_levels;
						_levels=_local15;
					}
					
					_local10.a=0.5;
					_local10.d=0.5;
					_local7=(_local7 >> 1);
					_local8=(_local8 >> 1);
					_local13++;
				}
				
			}
			_levels && _levels.dispose();
			_mips && _mips.dispose();
			Device3D.isOpenGL && bmpdata.dispose();
			
			return texture;
		}
        public static function extractCubeMap(_arg1:BitmapData):Array
        {
            var _local6:Array;
            var _local8:BitmapData;
            var _local2:Array = [];
            var _local3:Matrix = new Matrix();
            var _local4:BitmapData = _arg1;
            var _local5:int = (((_local4.width > _local4.height)) ? (_local4.width / 4) : (_local4.width / 3));
            if (_local4.width > _local4.height)
            {
                _local6 = [2, 1, 0, 0, 1, 0, 1, 0, 0, 1, 2, 0, 1, 1, 0, 3, 1, 0];
            }
            else
            {
                _local6 = [2, 1, 0, 0, 1, 0, 1, 0, 0, 1, 2, 0, 1, 1, 0, 2, 4, Math.PI];
            };
            var _local7:int;
            while (_local7 < 6)
            {
                _local8 = new BitmapData(_local5, _local5, _local4.transparent, 0);
                _local3.identity();
                _local3.translate((-(_local5) * _local6[(_local7 * 3)]), (-(_local5) * _local6[((_local7 * 3) + 1)]));
                _local3.rotate(_local6[((_local7 * 3) + 2)]);
                _local8.fillRect(_local8.rect, 0);
                _local8.draw(_local4, _local3);
                _local2.push(_local8);
                _local7++;
            };
            return (_local2);
        }

    }
}//package flare.utils

