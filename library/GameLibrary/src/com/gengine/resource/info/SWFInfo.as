package com.gengine.resource.info
{
	import com.gengine.debug.Log;
	
	import flash.display.BitmapData;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;

	public class SWFInfo extends ResourceInfo
	{
		private var _clip:MovieClip;
		
		private var _bitmapData:BitmapData;
		
		private var _appDomain:ApplicationDomain;
		
		public function SWFInfo(object:Object)
		{
			super(object);
		}
		
		public function get clip():MovieClip
		{
			return _clip;
		}
		
		public function get bitmapData():BitmapData
		{
			if( _bitmapData == null && _clip )
			{
				_clip.gotoAndStop(1);
				var rect:Rectangle = _clip.getBounds(_clip);
				if(rect.height==0 || rect.width==0)
				{
					
				}
				else
				{
					_bitmapData=new BitmapData(rect.width, rect.height, true, 0);
					_bitmapData.draw(_clip, new Matrix(1,0,0,1,-rect.x,-rect.y),null,null,null,false);
					_clip = null;
				}
			}
			return _bitmapData;
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			if( value is MovieClip )
			{
				_clip = value as MovieClip;
				_appDomain = _clip.loaderInfo.applicationDomain;
			}
			else if( value is LoaderInfo )
			{
				loaderInfo = value as LoaderInfo;
				_appDomain = loaderInfo.applicationDomain;
				if( loaderInfo.swfVersion >= 9 )
				{
					_clip = loaderInfo.content as MovieClip;
				}
				else
				{
					throw new Error( loaderInfo.url+"版本："+ loaderInfo.swfVersion);
				}
			}
			if( _clip )
			{
				_clip.gotoAndStop(1);
			}
		}
		
		public function getAssetClass(name:String):Class
		{          
			if (null == _appDomain) 
				throw new Error("not initialized");
			
			if (_appDomain.hasDefinition(name))
				return _appDomain.getDefinition(name) as Class;
			else
				return null;
		}
		
		override public function dispose():void
		{
			isLoaded = false;
			isLoading = false;
			_clip = null;
			_appDomain = null;
			if( _bitmapData )
			{
				_bitmapData.dispose();
				_bitmapData = null;
			}
			super.dispose();
		}
		
		override protected function unload(loaderInfo:LoaderInfo):void
		{
//			Log.system("unloadSWF:"+path);
			loaderInfo.loader.unloadAndStop();
			super.unload(loaderInfo);
		}
	}
}