


//flare.core.Texture3D

package baseEngine.core
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display3D.textures.TextureBase;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.system.Device3D;
	import baseEngine.utils.Texture3DUtils;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.loaders.resource.encryption.EncryptUtils;
	import frEngine.loaders.resource.info.ABCInfo;

	public class Texture3D extends EventDispatcher
	{

		public static const FORMAT_RGBA:int=0;
		public static const FORMAT_COMPRESSED:int=1;
		public static const FORMAT_COMPRESSED_ALPHA:int=2;
		public static const FORMAT_CUBEMAP:int=3;
		public static const FORMAT_COMPRESSED_BGRA:int=4;

		public static const FILTER_NEAREST:int=0;
		public static const FILTER_LINEAR:int=1;

		public static const TYPE_2D:int=0;
		public static const TYPE_CUBE:int=1;
		public static const MIP_NONE:int=0;
		public static const MIP_NEAREST:int=1;
		public static const MIP_LINEAR:int=2;

		private var _texture:TextureBase;
		private var _data:*;
		private var _request:*;

		private var _optimizeForRenderToTexture:Boolean=false;
		private var _loaded:Boolean=false;
		private var _scene:Scene3D;
		public var filterMode:int=1;
		//public var wrapMode:int = WRAP_REPEAT;
		public var mipMode:int=MIP_NONE;
		public var typeMode:int=TYPE_2D;
		public var bias:int=0;
		public var options:int=0;
		public var format:int;

		public function Texture3D(_arg1:*, $mipType:int, $format:int=0)
		{
			super();
			this.mipMode=$mipType;
			this.format=$format;

			if (_arg1)
			{
				this.request=_arg1
			}
			
		}

		
		
		public function set request(value:*):void
		{
			
			download();
			this._request=value;
			if (value is String && this.format==0)
			{
				var flag:String=String(value);
				flag=flag.substr(flag.length - 4, 4);
				if (flag == EncryptUtils.extensionCompress)
				{
					this.format=FORMAT_COMPRESSED;
				}
				else if (flag == EncryptUtils.extensionCompress_alpha)
				{
					this.format=FORMAT_COMPRESSED_ALPHA;
				}
				else if (flag == EncryptUtils.extensionCompress_bgra)
				{
					this.format=FORMAT_COMPRESSED_BGRA;
				}
			}
			var typeString:String=getQualifiedClassName(value).toLowerCase();
			var arr:Array=typeString.split("::");
			typeString=arr.pop();
			var _local4:int;
			var _local5:DisplayObject;
			var _local6:Rectangle;
			var _local7:Matrix;
			if (format == FORMAT_COMPRESSED || format == FORMAT_COMPRESSED_ALPHA || format == FORMAT_COMPRESSED_BGRA)
			{
				switch (typeString)
				{
					case "bytearray":
						this._data=this._request;
						this._loaded=true;
						break;
					case "string":
						break;
					default:
						throw new Error("不符合texture3d类型");
				}
			}
			else if (format == FORMAT_CUBEMAP)
			{
				switch (typeString)
				{
					case "array":
						this._data=[];
						_local4=0;
						while (_local4 < 6)
						{
							this._data[_local4]=(((this._request[_local4] is BitmapData)) ? this._request[_local4] : this._request[_local4].bitmapData);
							_local4++;
						}
						this._loaded=true;
						break;
					case "bitmap":
						this._data=Texture3DUtils.extractCubeMap(this._request.bitmapData);
						this._loaded=true;
						break;
					case "bitmapdata":
						this._data=Texture3DUtils.extractCubeMap(this._request);
						break;
					case "point":
						this._optimizeForRenderToTexture=true;
						this._data=this._request;
						this._loaded=true;
						break;
					case "string":
						break;
					default:
						throw new Error("不符合texture3d类型");
				}
				this.typeMode=TYPE_CUBE;
			}
			else
			{
				switch (typeString)
				{
					case "point":
						this._optimizeForRenderToTexture=true;
						this._data=this._request;
						this._loaded=true;
						break;
					case "bitmapdata":
						this._data=(this._request as BitmapData);
						this._loaded=true;
						break;
					case "btmap":
						this._data=this._request.bitmapData;
						this._loaded=true;
						break;
					case "displayobject":
						_local5=(this._request as DisplayObject);
						_local6=_local5.getBounds(_local5);
						_local7=new Matrix(1, 0, 0, 1, -(_local6.x), -(_local6.y));
						this._data=new BitmapData(((_local6.width) || (1)), ((_local6.height) || (1)), true, 0);
						this._data.draw(this._request, _local7);
						this._loaded=true;
						break;
					case "string":
						break;
					default:
						throw new Error("不符合texture3d类型");
				}
			}

		}

		public function set texture(value:TextureBase):void
		{
			_texture=value;
			_loaded=true;
			this.dispatchEvent(new Event(Engine3dEventName.TEXTURE_CREATE));
		}

		public function get texture():TextureBase
		{
			return _texture;
		}

		public function dispose():void
		{
			Resource3dManager.instance.disposeTexture3d(this);
		}
		public function disposeImp():void
		{

			this.download();

			if (this._data && (_data is BitmapData))
			{
				if (this._data != Device3D.nullBitmapData)
				{
					this._data.dispose();
				}
				this._data=null;
			}

			this._request=null;
			this._loaded=false;
			this._data=null;
		}

		public function upload(_arg1:Scene3D,toCheck:Boolean):Boolean
		{
			if (this.scene && this.texture)
			{
				return true;
			}

			this.scene=_arg1;
			
			if (!this._loaded)
			{
				this.load();
			}
			return this.contextEvent(null,toCheck);
			
		}

		public function get scene():Scene3D
		{
			return _scene;
		}

		public function set scene(value:Scene3D):void
		{
			if (_scene)
			{
				_scene.removeEventListener(Event.CONTEXT3D_CREATE, contextEvent);
				_scene.textures.splice(_scene.textures.indexOf(this), 1);
			}
			_scene=value;
			if (_scene)
			{
				_scene.addEventListener(Event.CONTEXT3D_CREATE, contextEvent);
				_scene.textures.push(this);
			}

		}

		public function download():void
		{
			if (this.texture)
			{
				Texture3DUtils.unloadTexture(this._request,this.mipMode);
				this.texture=null;
			}

			this.scene=null;
			this._loaded=false;

		}

		public function get request():*
		{
			return (this._request);
		}

		/*public function set request(_arg1:*):void
		{
			this._request = _arg1;
		}*/

		public function get optimizeForRenderToTexture():Boolean
		{
			return (this._optimizeForRenderToTexture);
		}
		public function set optimizeForRenderToTexture(value:Boolean):void
		{
			this._optimizeForRenderToTexture=value;
		}

		public function load():void
		{
			if (this._loaded)
			{
				return;
			}
			LoaderManager.instance.load(this._request, completeEvent);
		}

		private function contextEvent(e:Event=null,toCheck:Boolean=true):Boolean
		{
			if(this.texture)
			{
				return true;
			}
			if (this._loaded && this._data && (!toCheck || (getTimer()-TimeControler.stageTime<TimeControler.minFpsTime)) )
			{
				if (this._data is TextureBase  )
				{
					this.texture=this._data;
				}
				else
				{
					this.texture=Texture3DUtils.createTexture(_request,_data, format, typeMode, mipMode,_optimizeForRenderToTexture);
				}
				_data=null;
				dispatchEvent(new Event(Engine3dEventName.TEXTURE_LOADED));
				return true
			}else
			{
				return false;
			}

		}

		private function completeEvent(info:ImageInfo):void
		{

			this._loaded=true;

			if (this.format == FORMAT_RGBA)
			{
				this._data=info.bitmapData;
			}
			else if (this.format == FORMAT_CUBEMAP)
			{
				this._data=Texture3DUtils.extractCubeMap(info.bitmapData);
			}
			else if (this.format == FORMAT_COMPRESSED || this.format == FORMAT_COMPRESSED_ALPHA || this.format ==FORMAT_COMPRESSED_BGRA)
			{
				this._data=ABCInfo(info).ATFByteArray
			}

			if (((this.scene) && (this.scene.context)))
			{
				this.contextEvent();
			}
			
		}

		override public function toString():String
		{
			return ((("[object Texture3D name:" + this._request) + "]"));
		}

	}
} //package flare.core

