package
{
	import com.gengine.debug.Log;
	
	import flash.display.Loader; 
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import extend.language.PreLanguage;
	import extend.php.PHPSender;
	import extend.php.SenderType;
	
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.common.preLoadPage.ForgameLogo;
	import mortal.common.preLoadPage.GameLoadBar;
	import mortal.common.preLoadPage.PreLoginProxy;
	import mortal.common.preLoadPage.PreloaderConfig;
	
	[SWF(width=1000, height=580, frameRate=60, backgroundColor=0)]
	public class Preloader extends Sprite
	{
		public function Preloader()
		{ 
			//-advanced-telemetry
			if(stage)
			{
				init();
			}
			else
			{
				this.addEventListener(Event.ADDED_TO_STAGE,init);
			}
		}
		
		//		public function jsClose():void
		//		{
		//			if( PHPSender.isCreateRole )
		//			{
		//				PHPSender.sendToURLByPHP(SenderType.FlashClose);
		//			}
		//		}
		/**
		 * 初始化开始
		 * @param event
		 *
		 */
		private function init(e:Event=null):void
		{ 
			//加载语言配置
			GameLoadBar.instance.gameRoot = stage;
			ParamsConst.instance.init(stage);
			PreLanguage.init(initGame);
		}
		
		private function initGame():void
		{
//			if( ExternalInterface.available )
//			{
//				ExternalInterface.addCallback("jsClose",jsClose);
//			}
			
//			GameLoadBar.instance.gameRoot = stage;
//			ParamsConst.instance.init(stage);
			
			if( PHPSender.isCreateRole )
			{
				PHPSender.clearUserName(ParamsConst.instance.username);
				PHPSender.sendToURLByPHP(SenderType.Preloader);
			}
			
			this.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
		}
		
//		private var _text:TextField;
		private function onEnterFrameHandler( event:Event ):void
		{
			if (loaderInfo.bytesLoaded == loaderInfo.bytesTotal)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
				
//				_text = new TextField();
//				_text.selectable = false;
//				_text.text = PreLanguage.getString(101);//"正在进入游戏...";
//				_text.textColor = 0xFFFFFF;
//				_text.x = stage.stageWidth/2 - 30;
//				_text.y = stage.stageHeight/2 - 15;
//				_text.autoSize = TextFieldAutoSize.LEFT;
//				this.addChild(_text);
				
				//进入游戏前播放forgame片头
				//ForgameLogo.instance.loadAndPlay(stage,onForgameLogoPlayComplete);
				onForgameLogoPlayComplete();
			}
		}
		
		private function onForgameLogoPlayComplete():void
		{
			PreLoginProxy.instance.rootStage = stage;
			PreLoginProxy.instance.login(); // 游戏登陆
			
			onloadPrePage();
		}
		
		/**
		 * 开始下载加载页 
		 * 
		 */		
		private function onloadPrePage():void
		{
			//by cjx 
			GameLoadBar.resourceLoader = new Loader();
			GameLoadBar.resourceLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadCompleteHandler);
			GameLoadBar.resourceLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,loadProgressHandler);
			GameLoadBar.resourceLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadErrorHandler);
			GameLoadBar.resourceLoader.load(new URLRequest(PathConst.mainPath + "assets/modules/PreloaderPage/preLoadPage.swf" + "?v=" + ParamsConst.instance.flashVersion));
		}
		
		private function loadCompleteHandler(e:Event):void
		{
			ForgameLogo.instance.dispose();
			GameLoadBar.resourceLoader.removeEventListener(Event.COMPLETE,loadCompleteHandler);
			
//			this.removeChild(_text);
//			_text = null;
			GameLoadBar.instance.show();
			GameLoadBar.instance.setProgress(PreloaderConfig.LOGIN_GAME,0.8,1);
		}
		
		private function loadProgressHandler(e:ProgressEvent):void
		{
//			_text.text = PreLanguage.getString(101) + Math.round(100*e.bytesLoaded/e.bytesTotal) + "%"; 
		}
		
		private function loadErrorHandler(e:ErrorEvent):void
		{
			Log.system("资源加载失败！" + (e.target as LoaderInfo).url);
		}
	}
}