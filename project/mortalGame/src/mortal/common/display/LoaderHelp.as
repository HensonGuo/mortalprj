package mortal.common.display
{
	import com.gengine.core.call.Caller;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ResourceInfo;
	import com.gengine.resource.info.SWFInfo;
	import com.mui.controls.Alert;
	import com.mui.controls.GImageBitmap;
	import com.mui.core.GlobalClass;
	import com.mui.events.LibraryEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.utils.Dictionary;
	
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.game.resource.ResConfig;

	/**
	 * 四种方式：
	 *  动态加载
		1、单独图片转成SWF   GImageBitmap
		2、按钮模式          GLoadedButton
		3、批量资源模式（多个小的文件打包成一个SWF）LoaderHelp.addResCallBack(resName,callBack)
		
		4、其他整体压缩包 (imageLibs) 
	 * @author jianglang
	 * 
	 */	
	public class LoaderHelp
	{
		public function LoaderHelp()
		{
			
		}
		
		//资源名字对应的callBack
		private static var _dicResCallBack:Dictionary = new Dictionary();
		
		//加载资源的caller
		private static var _loadCaller:Caller = new Caller();
		//已经加载过的资源名字列表
		private static var _aryResLoaded:Array = new Array();
		//正在加载的资源名字列表
		private static var _aryResLoading:Array = new Array();
		
		/**
		 * 是否加载过这个资源包 
		 * @param resName
		 * @return 
		 * 
		 */
		private static function isResLoaded(resName:String):Boolean
		{
			return _aryResLoaded.indexOf(resName) > -1;
		}
		
		/**
		 * 是否在加载中 
		 * @param resName
		 * @return 
		 * 
		 */		
		private static function isResLoading(resName:String):Boolean
		{
			return _aryResLoading.indexOf(resName) > -1;
		}
		
		private static var _isAddListener:Boolean = false;
		
		private static function addListener():void
		{
			if(!_isAddListener)
			{
				GlobalClass.libaray.addEventListener(LibraryEvent.SINGLELOAD_COMPLETE, onlibraryCompleteHandler);
				_isAddListener = true;
			}
		}
		
		/**
		 * 加载资源，并在加载成功后进行回调 
		 * @param resName
		 * @param callBack
		 * @param resComplPath 不是在uifla文件夹下的文件需要填这个
		 */
		public static function addResCallBack(resName:String,callBack:Function = null,resComplPath:String = ""):void
		{
			addListener();
			resName = GImageBitmap.getUrl(resName);
			if(isResLoaded(resName))
			{
				if(callBack is Function)
				{
					callBack.call();
				}
			}
			else if(isResLoading(resName))
			{
				_loadCaller.addCall(resName,callBack);
			}
			else
			{
				_loadCaller.addCall(resName,callBack);
				_aryResLoading.push(resName);
				var path:String = resComplPath;
				if(path == "" || path == null)
				{
					path = getPath(resName);
				}
				if(path)
				{
					GlobalClass.libaray.loadSWF(path,resName);
				}
			}
			
			function onErrorEvent(e:ErrorEvent):void
			{
				Log.debug("LoderHelp找不到资源：" + resName );
			}
		}
		
		private static function onlibraryCompleteHandler(event:LibraryEvent):void
		{
			var resName:String = String(event.data);
			_loadCaller.call(resName);
			_loadCaller.removeCallByType(resName);
			//添加到已加载列表中
			_aryResLoaded.push(resName);
			//从加载中的列表中移除
			if(isResLoading(resName))
			{
				_aryResLoading.splice(_aryResLoading.indexOf(resName),1);
			}
		}
		
		/**
		 * 得到资源路径 
		 * @return 
		 * 
		 */		
		private static function getPath(resName:String):String
		{
			var resInfo:ResourceInfo = ResConfig.instance.getInfoByName(resName);
			if(resInfo)
			{
				return resInfo.path;
			}
			else
			{ 
				Log.debug("LoaderHelp找不到资源路径：" + resName);
			}
			return PathConst.mainPath + "assets/uifla/" + resName + ".swf?v=" + resInfo.time;
		}
		
		public static function setBitmapdata( url:String , bitmap:Bitmap,x:Number = 0,y:Number= 0, width:Number = -1,height:Number = -1):void
		{
			LoaderManager.instance.load(url,function( info:* ):void
			{
				if( x != 0 )
				{
					bitmap.x = x;
				}
				if( y !=0 )
				{
					bitmap.y = y;
				}
				bitmap.bitmapData = info.bitmapData as BitmapData;
				if(width > 0)
				{
					bitmap.width = width;
				}
				if(height > 0)
				{
					bitmap.height = height;
				}
			});
		}
	}
}