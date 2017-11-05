
package
{
	import com.gengine.debug.FPS;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	import com.gengine.manager.CacheManager;
	import com.gengine.manager.MenuManager;
	import com.gengine.resource.ConfigManager;
	import com.gengine.resource.FileType;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.core.StreamManager;
	import com.gengine.resource.info.ResourceInfo;
	import com.gengine.resource.loader.DataLoader;
	import com.gengine.ui.Application;
	import com.gengine.utils.TimerTest;
	import com.mui.controls.Alert;
	import com.mui.controls.GImageBitmap;
	import com.mui.controls.GLoadingButton;
	import com.mui.core.GlobalClass;
	import com.mui.core.IFrUI;
	import com.mui.events.LibraryEvent;
	import com.mui.manager.DragManager;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.UICompomentPool;
	
	import extend.js.JSASSender;
	import extend.language.Language;
	import extend.php.PHPSender;
	import extend.php.SenderType;
	
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.setTimeout;
	
	import frEngine.loaders.resource.info.ABCInfo;
	import frEngine.loaders.resource.info.DDSInfo;
	import frEngine.loaders.resource.info.EffectInfo;
	import frEngine.loaders.resource.info.Md5MeshInfo;
	import frEngine.loaders.resource.info.MeshInfo;
	import frEngine.loaders.resource.info.ParticleInfo;
	import frEngine.loaders.resource.info.SkeletonInfo;
	import frEngine.loaders.resource.info.TGAInfo;
	import frEngine.loaders.resource.loader.ABCLoader;
	
	import mortal.common.GlobalError;
	import mortal.common.display.BitmapDataConst;
	import mortal.common.font.FontUtil;
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.common.preLoadPage.GameLoadBar;
	import mortal.common.preLoadPage.PreLoginProxy;
	import mortal.common.preLoadPage.PreloaderConfig;
	import mortal.component.skin.GlobalSkin;
	import mortal.component.window.DebugWindow;
	import mortal.game.control.LoginController;
	import mortal.game.manager.EffectManager;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.LayerManager;
	import mortal.game.manager.StageMouseManager;
	import mortal.game.manager.WindowLayer;
	import mortal.game.mvc.GameController;
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.ResConfig;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.util.MoveUtil;
	import mortal.game.view.chat.selectPanel.FacePanel;
	import mortal.game.view.common.alertwins.CustomAlertWin;
	import mortal.game.view.common.tooltip.Tooltip;
	
	[SWF(width=1000, height=580, frameRate=60, backgroundColor=0)]
	//[Frame(factoryClass="mortal.load.Preloader",label="hello")]
	/**
	 * 加载流程 
	 * 登陆验证服务器 - 加载创建角色--开始加载主程序---初始化基本设置 -- 加载配置文件--连接服务器 --登陆游戏服务器-- 初始化应用程序
	 * @author jianglang
	 *
	 */
	public class MainGame extends Application
	{
		public function MainGame()
		{ 
//			FramesData.setData();
		}
		
		/**
		 * 初始化程序
		 * 初始化 管理组件 层次 URL 参数 加载资源
		 * @param event
		 * 
		 */  
		override protected function initApp():void
		{
			UICompomentPool.clientDisposeFun = mortalDisposeUI;
			MoveUtil.init();
			CacheManager.instance.initCache();
			FontUtil.init();
			initLoaderParams();
			JSASSender.instance.start();
			SceneRange.screenResolutionX = Capabilities.screenResolutionX;
			SceneRange.screenResolutionY = Capabilities.screenResolutionY;
			
//			Log.debug(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			LoaderManager.instance.maxQueue = 4;  //最大队列数
			StreamManager.init();
			//RMIConfig.DefultTimeOut = 60000;  //设置RMI超时
			
			Log.isSystem=true;
			
			ParamsConst.instance.init(stage); //初始化URL参数
			
			
			if( Global.isDebugModle == false )
			{
				Log.closeAll();
			}
			
			Log.isError = true;
			Log.isWarn = true;
//			Log.isSystem = true;
			//Log.closeAll();
			this.stage.scaleMode=StageScaleMode.NO_SCALE;
			this.stage.align=StageAlign.TOP_LEFT;
//			this.stage.quality=StageQuality.LOW;
			this.stage.tabChildren=false;
			this.stage.stageFocusRect=false;
			
			setTimeout(initConfig, ParamsConst.Delay);
//			initConfig();
		}
		
		private function initLoaderParams():void
		{
			//FileType.addClassRef(".TGA",DataLoader,TGAInfo);
			//FileType.addClassRef(".DDS",DataLoader,DDSInfo);
			FileType.addClassRef(".ABC",ABCLoader,ABCInfo);
			FileType.addClassRef(".CMP0",ABCLoader,ABCInfo);
			FileType.addClassRef(".CMP1",ABCLoader,ABCInfo);
			FileType.addClassRef(".CMP2",ABCLoader,ABCInfo);
			
			FileType.addClassRef(".MESH",DataLoader,MeshInfo);
			FileType.addClassRef(".MD5MESH",DataLoader,Md5MeshInfo);
			FileType.addClassRef(".PARTICLE",DataLoader,ParticleInfo);
			FileType.addClassRef(".SKELETON",DataLoader,SkeletonInfo);
			FileType.addClassRef(".EFFECT",DataLoader,EffectInfo);
		}
		
		private function onClearCacheHandler():void
		{
			CacheManager.instance.clear();
		}
		
		/**
		 * 配置文件
		 *
		 */
		private function initConfig():void
		{
			Log.system("开始加载配置文件","系统总内存:",System.totalMemory);
			ConfigManager.instance.addEventListener(Event.COMPLETE, onConfigCompleteHandler);
			ConfigManager.instance.addEventListener(ProgressEvent.PROGRESS,configLoadProgressHandler);
			ConfigManager.instance.addEventListener(ErrorEvent.ERROR,onConfigErrorHandler);
			ConfigManager.instance.addEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
			ConfigManager.instance.load(PathConst.configUrl);
		}
		
		private function configLoadProgressHandler(e:ProgressEvent):void
		{
			setProgress(PreloaderConfig.LOAD_CONFIG,e.bytesLoaded,e.bytesTotal);
		}
		
		private function onConfigErrorHandler(e:ErrorEvent):void
		{
			if( PHPSender.isCreateRole )
			{
				PHPSender.sendToURLByPHP(SenderType.LoadConfigFail,e.text);//加载配置文件失败
			}
		}
		
		/**
		 * data文件损坏，解压出错 
		 * @param e
		 * 
		 */		
		private function onIOErrorHandler(e:Event):void
		{
			ConfigManager.instance.load(PathConst.configUrl + Math.random());
		}
		
		
		/**
		 * 配置文件加载完成 所有 配置文件都可以使用
		 *
		 * 资源库加载 所有皮肤都可以用
		 * @param eventas
		 *
		 */
		
		//private var _libraryUrls:Array=["mainUI.swf","imageLib.swf", "skillUI.swf", "Face.swf"];
		private var _libraryUrls:Array=["assets/uifla/imageLib.swf"];
		
		private function onConfigCompleteHandler(event:Event):void
		{
			ConfigManager.instance.removeEventListener(Event.COMPLETE, onConfigCompleteHandler);
			ConfigManager.instance.removeEventListener(ProgressEvent.PROGRESS,configLoadProgressHandler);
			ConfigManager.instance.removeEventListener(ErrorEvent.ERROR,onConfigErrorHandler);
			ConfigManager.instance.removeEventListener(IOErrorEvent.IO_ERROR,onIOErrorHandler);
			
			if( PHPSender.isCreateRole )
			{ 
				PHPSender.sendToURLByPHP(SenderType.LoadConfigSuccess);//加载配置文件成功
				// 添加预加载
				// 添加预加载
				if( ParamsConst.instance.preloaders != null && ParamsConst.instance.preloaders != "" )
				{
					PreloaderConfig.preResUrl = ParamsConst.instance.preloaders.split(",");
					if( PreloaderConfig.preResUrl != null && PreloaderConfig.preResUrl.length> 0 )
					{
						_libraryUrls = _libraryUrls.concat(PreloaderConfig.preResUrl);
					}
				}
			}
			
			GLoadingButton.setGetPath(setGetButtonPath);
			
			GameMapConfig.instance;
			
			MenuManager.instance.initMenu(this);
			MenuManager.instance.addItem(Language.getString(10001)+ParamsConst.Version,function():void{});//"版本号："
			MenuManager.instance.addItem(Language.getString(10002),onClearCacheHandler);//清理缓存
			
			if( ParamsConst.instance.gameName == null )
			{
				ParamsConst.instance.gameName = "无名新项目";//"凡人修真2"
			}
			//资源库加载
			GlobalClass.libaray.addEventListener(LibraryEvent.LOAD_COMPLETE, onlibraryCompleteHandler);
			GlobalClass.libaray.addEventListener(ProgressEvent.PROGRESS,resourceLoadProgressHandler);
			GlobalClass.libaray.addEventListener(ErrorEvent.ERROR,onLibraryErrorHandler);
			
			for (var i:int=0; i < _libraryUrls.length; i++)
			{
				var path:String = PathConst.mainPath + _libraryUrls[i] + "?v=" + ParamsConst.instance.flashVersion;
				GlobalClass.libaray.loadSWF(path);
			}
			Log.system("开始加载素材文件","系统总内存:",System.totalMemory);
			
			//对Alert框赋值
			Alert.okLabelDefault = Language.getString(10015);
			Alert.calcelLabelDefault = Language.getString(10016);
			Alert.yesLabelDefault = Language.getString(10017);
			Alert.noLabelDefault = Language.getString(10018);
			Alert.checkBoxLabelDefault = Language.getString(10019);
			 
			Alert.okLabel = Alert.okLabelDefault;
			Alert.calcelLabel = Alert.calcelLabelDefault;
			Alert.yesLabel = Alert.yesLabelDefault;
			Alert.noLabel = Alert.noLabelDefault;
			Alert.checkBoxLabel = Alert.checkBoxLabelDefault;
			
			TimerTest.tipText = Language.getString(10020);
			//Log.debug(TypeDescriptor.describeType(this).properties);
		}
		
		private function onLibraryErrorHandler( event:ErrorEvent ):void
		{
			if( PHPSender.isCreateRole )
			{
				PHPSender.sendToURLByPHP(SenderType.LoadResourceFail,event.text); ////加载资源失败
			}
		}
		
		private function resourceLoadProgressHandler(e:ProgressEvent):void
		{
			setProgress(PreloaderConfig.LOAD_RESCOUSE,e.bytesLoaded,e.bytesTotal);
		}
		
		/**
		 * 初始化皮肤
		 * @param event
		 *
		 */
		private function onlibraryCompleteHandler(event:LibraryEvent):void
		{
			Log.system("像素文件加载完毕","系统总内存:",System.totalMemory);
			if( PHPSender.isCreateRole )
			{
				PHPSender.sendToURLByPHP(SenderType.LoadResourceSuccess); //加载资源成功
			}
			LayerManager.init();
			WindowLayer.topLayerChangeHander = LayerManager.setWindowLayerTop;
			
			ToolTipsManager.init(LayerManager.toolTipLayer);
			ToolTipsManager.defaultRenderClass=Tooltip;
			
			DragManager.init(LayerManager.dragLayer);
			Alert.init(LayerManager.alertLayer);
			Alert.defaultAlertWinRenderer=CustomAlertWin;
			
			if( Global.isDebugModle )
			{
				Global.stage.addChild( FPS.instance );
//				DebugUtil.addUIPriofiler(); 
				GameManager.instance.init(); //游戏初始化 比如键盘监听开始
			}
			
			Log.system("Alert Drag toolTip初始化完毕","系统总内存:",System.totalMemory);
			
			GameController.init(); //初始化服务监听
			StageMouseManager.instance.start();
			
			Log.system("控制器初始化完毕","系统总内存:",System.totalMemory);
			
			GlobalSkin.initStyleSkin(); // 初始化皮肤
			
			Log.system("皮肤初始化完毕","系统总内存:",System.totalMemory);
			
			BitmapDataConst.registToGlobal();//注册常用BitmapData
			
			Log.debugLog = DebugWindow.instance; // 设置debug信息面板
			
			GlobalError.instance.listenerError(); //全局异常事件监听
			
			//SWFModelConfig.instance.init();
			
			//GameController.login.login(); // 游戏登陆
			GameLoadBar.instance.isGameLoadComplete = true;
			
			Log.system("准备登陆游戏","系统总内存:",System.totalMemory);
			
			if(PreLoginProxy.instance.isLoginSuccess)
			{
				LoginController.instance.loadGame();
			}
			
			PreLoginProxy.instance.addEventListener(PreLoginProxy.LOGIN_SUCCESS,loginSuccessHandler);
			
			removeLoadListeners();
		}
		
		private function removeLoadListeners():void
		{
			GlobalClass.libaray.removeEventListener(LibraryEvent.LOAD_COMPLETE, onlibraryCompleteHandler);
			GlobalClass.libaray.removeEventListener(ProgressEvent.PROGRESS,resourceLoadProgressHandler);
			GlobalClass.libaray.removeEventListener(ErrorEvent.ERROR,onLibraryErrorHandler);
		}
		
		private function loginSuccessHandler(e:Event):void 
		{
			PreLoginProxy.instance.removeEventListener(PreLoginProxy.LOGIN_SUCCESS,loginSuccessHandler);
			
			setProgress(PreloaderConfig.LOAD_RESCOUSE,100,100);
			LoginController.instance.loadGame();
		}
		
		private function multipleLoginSuccessHandler(e:Event):void 
		{
			PreLoginProxy.instance.removeEventListener(PreLoginProxy.LOGIN_SUCCESS,multipleLoginSuccessHandler);
			
			LoginController.instance.loadGame();
		}
		
		/**
		 * 设置加载页面进度
		 *  
		 * */
		private function setProgress(index:int,bytesLoaded:Number,bytesTotal:Number):void
		{
			if(GameLoadBar.instance)
			{
				GameLoadBar.instance.setProgress(index,bytesLoaded,bytesTotal);
			}
		}
		
		/**
		 * 设置获取加载按钮的路径位置
		 * @param resName
		 * 
		 */
		private function setGetButtonPath(resName:String):String
		{
			resName = GImageBitmap.getUrl(resName);
			var resInfo:ResourceInfo = ResConfig.instance.getInfoByName(resName);
			if(resInfo)
			{
				return resInfo.path;
			}
			else
			{
				Log.debug("GLoadedButton找不到资源路径：" + resName);
				return PathConst.mainPath + "assets/uifla/button/" + resName + ".swf?v=" + resInfo.time;
			}
		}
		
		private function mortalDisposeUI(obj:DisplayObject):void
		{
			EffectManager.glowFilterUnReg(obj);
			if(obj is IFrUI)
			{
				FacePanel.unRegistBtn(obj as IFrUI);
			}
		}
	}
}