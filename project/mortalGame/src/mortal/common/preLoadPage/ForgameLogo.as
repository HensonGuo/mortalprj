/**
 * @date 2013-4-1 下午07:50:47
 * @author cjx
 */
package mortal.common.preLoadPage
{
	import flash.display.AVM1Movie;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;

	public class ForgameLogo
	{
		
		private static var _instance:ForgameLogo;
		
		private var _forgameSwf:MovieClip;
		
		private var _stage:Stage;
		private var _callBack:Function;
		
		public function ForgameLogo()
		{
			if(_instance)
			{
				throw new Error("ForgameLogo 单例");
			}
		}
		
		public static function get instance():ForgameLogo
		{
			if(!_instance)
			{
				_instance = new ForgameLogo();
			}
			return _instance;
		}
		
		/**
		 * 加载并播放forgame片头 
		 * @param stage
		 * @param callBack
		 * 
		 */		
		public function loadAndPlay(stage:Stage,callBack:Function):void
		{
			dispose();
			
			_stage = stage;
			_callBack = callBack;
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
			var url:String = PathConst.mainPath + "assets/modules/PreloaderPage/Forgame_LOGO.swf" + "?v=" + ParamsConst.instance.forgameLogoVersion;
			loader.load(new URLRequest(url ));
		}
		
		private function loadCompleteHandler(e:Event):void
		{
			var loader:LoaderInfo = e.target as LoaderInfo;
			loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
			
			_forgameSwf = (loader.content as MovieClip).getChildByName("forgameLOGO") as MovieClip;
			_forgameSwf.addEventListener(Event.ENTER_FRAME,onForgameSwfEnterframeHandler);
			_forgameSwf.scaleX = 0.5;
			_forgameSwf.scaleY = 0.5;
			_stage.addChild(_forgameSwf);
			
			stageResizeHandler();
		}
		
		private function loadErrorHandler(e:*):void
		{
			var loader:LoaderInfo = e.target as LoaderInfo;
			loader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
			
			if(_callBack != null)
			{
				_callBack.call();
			}
			dispose();
		}
		
		private function onForgameSwfEnterframeHandler(e:Event):void
		{
			if(_forgameSwf.currentFrame == _forgameSwf.totalFrames)
			{
				_forgameSwf.removeEventListener(Event.ENTER_FRAME,onForgameSwfEnterframeHandler);
				if(_callBack != null)
				{
					_callBack.call();
				}
				dispose();
			}
		}
		
		private function stageResizeHandler(e:Event = null):void
		{
			if(_forgameSwf)
			{
				_forgameSwf.x = (_stage.stageWidth - _forgameSwf.width)/2;
				_forgameSwf.y = (_stage.stageHeight - _forgameSwf.height)/2;
			}
		}
		
		/**
		 * 销毁 
		 * 
		 */		
		public function dispose():void
		{
			_stage = null;
			_callBack = null;
			
			if(_forgameSwf)
			{
				if(_forgameSwf.parent)
				{
					_forgameSwf.parent.removeChild(_forgameSwf);
				}
				_forgameSwf.removeEventListener(Event.ENTER_FRAME,onForgameSwfEnterframeHandler);
				_forgameSwf = null;
			}
		}
		
	}
}