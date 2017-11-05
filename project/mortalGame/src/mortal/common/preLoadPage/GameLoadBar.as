/**
 * @date	2011-4-3 下午10:42:12
 * @author  jianglang
 * 
 */	

package mortal.common.preLoadPage
{
	import com.gengine.manager.BrowerManager;
	import com.gengine.resource.LoaderManager;
	import com.gengine.utils.BrowerUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import extend.language.Language;
	import extend.language.PreLanguage;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.ParamsConst;
	import mortal.common.global.PathConst;
	import mortal.common.global.ProxyType;
	import mortal.component.gconst.FilterConst;
	

	public class GameLoadBar extends Sprite
	{
		public var startTime:int; //测试用
		public var nowTime:int;
		private var _timerText:TextField;
		
		public var gameRoot:Stage;
		
		private static var _instance:GameLoadBar;
		
		public static var resourceLoader:Loader;
		
		private var _bg:Loader;
		private var _middlePart:Sprite;
		private var logo:Bitmap;
		private var _fanrenLogo:Loader;
		private var _forgameLogo:Loader;
		
		private var _barTotal:MovieClip;
		private var _barPart:MovieClip;
		private var _totalText:TextField;
		private var _partText:TextField;
		
		private var _tips:TextField;
		private var _tipsTimer:Timer;
		
		public var isGameLoadComplete:Boolean = false;
		
		public function GameLoadBar()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
		}
		
		public static function get instance():GameLoadBar
		{
			if(!_instance)
			{
				_instance = new GameLoadBar();
			}
			return _instance;
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			gameRoot.addEventListener(Event.RESIZE,stageResizeHandler);
			
			initLoaderBar();
		}
		
		/**
		 * 加载完进度条，logo等素材
		 * 
		 * */
		private function initLoaderBar():void
		{
			_bg = new Loader();
			_bg.contentLoaderInfo.addEventListener(Event.COMPLETE,bgCompleteHandler);
			//根据不同运营商加载不同背景页
			var url:String = ParamsConst.instance.preLoadPageBg;
			if(url == null || url == "")
			{
				url = "assets/modules/PreloaderPage/preLoadPageBg.jpg";
			}
			else
			{
				if(ParamsConst.instance.proxyType == ProxyType.TW)
				{
					if(ParamsConst.instance.player_id == 0)
					{
						url = ParamsConst.instance.preLoadPageBgCreateRole;
					}
				}
				else if(ParamsConst.instance.isNewServer == 1)
				{
					var splitUrl:Array = url.split(".");
					url = splitUrl[0] + "_newServer." + splitUrl[1];
				}
			}
			url = PathConst.mainPath + url+"?v="+ParamsConst.instance.preLoaderVersion;
			_bg.load(new URLRequest(url ));
			this.addChildAt(_bg,0);
			
			_middlePart = new Sprite();
			this.addChild(_middlePart);
			
//			logo = new Bitmap(getBitmapData("LOGO"));
//			_middlePart.addChild(logo);
			
//			var f11:Bitmap = new Bitmap(getBitmapData("F11"));
//			f11.x = 110;
//			f11.y = 0;
//			_middlePart.addChild(f11);
			
			_barTotal = getPreLoadBarMc("LoadBar");
			_barTotal.x = 180;
			_barTotal.y = 492;
			_barTotal.gotoAndStop(0);
			_middlePart.addChild(_barTotal);
			
			_totalText = new TextField();
			_totalText.x = _barTotal.x;
			_totalText.y = _barTotal.y + 24;
			_totalText.width = 630;
			_totalText.height = 20;
			_totalText.textColor = 0x58C7FF;
			_totalText.filters = [FilterConst.glowFilter];
			_totalText.autoSize = TextFieldAutoSize.RIGHT;
			_totalText.text = PreLanguage.getString(107);//"总进度：";
			_middlePart.addChild(_totalText);
			
			_tips = new TextField();
			_tips.filters = [FilterConst.glowFilter];
			_tips.x = _barTotal.x;
			_tips.y = _barTotal.y - 12;
			_tips.width = 662;
			_tips.height = 20;
			_tips.textColor = 0xFFFFFF;
			_tips.autoSize = TextFieldAutoSize.CENTER;
			changeTipsText();
			_middlePart.addChild(_tips);
			
			//测试用
			_timerText = new TextField();
			_timerText.x = _totalText.x + 140;
			_timerText.y = _totalText.y;
			_timerText.textColor = 0xFFFFFF;
			_timerText.filters = [FilterConst.glowFilter];
			_timerText.autoSize = TextFieldAutoSize.LEFT;
			_timerText.text = "";
			//_middlePart.addChild(_timerText);
			
			_barPart = getPreLoadBarMc("LoadBar");
			_barPart.y = _barTotal.y + 31;
			_barPart.x =_barTotal.x;
			_barPart.gotoAndStop(0);
			_middlePart.addChild(_barPart);
			
			_partText = new TextField();
			_partText.x = _barPart.x;
			_partText.y = _barPart.y + 24;
			_partText.width = 630;
			_partText.height = 20;
			_partText.textColor = 0x58C7FF;
			_partText.filters = [FilterConst.glowFilter];
			_partText.autoSize = TextFieldAutoSize.RIGHT;
			_partText.text = PreLanguage.getString(108);//"当前进度：";
			_middlePart.addChild(_partText);
			
//			var text1:TextField = new TextField();
//			text1.filters = [new GlowFilter(0x8f0808)]
//			text1.x = f11.x - 34;
//			text1.y = f11.y + 19;
//			text1.selectable = false;
//			text1.autoSize = TextFieldAutoSize.LEFT;
//			text1.text = "猛击       开启网页游戏客户端时代！！！";
//			text1.setTextFormat(new GTextFormat(FontUtil.songtiName,14,0xffde00,true),0,text1.text.length);
//			_middlePart.addChild(text1);
			
			var text2:TextField = new TextField();
			text2.filters = [FilterConst.glowFilter];
			text2.textColor = 0x54ff00;
			text2.x = _barTotal.x;
			text2.y = 568;
			text2.width = 662;
			text2.height = 20;
			text2.selectable = false;
			text2.autoSize = TextFieldAutoSize.CENTER;
			//text2.htmlText = "<font color='#eba102'>爱因斯坦说，首次穿越通常会比较费时。。。若加载不成功，</font><font color='#54ff00'><a href=\"event:\"><u>请点此刷新</u></a>。</font>";
			text2.htmlText = PreLanguage.getString(109);//"<font color='#FFFFFF'>如果您是第一次打开游戏，加载文件可能比较大，请耐心等待，</font><font color='#54ff00'><a href=\"event:\"><u>若加载不成功，请点此刷新。</u></a></font>";
			_middlePart.addChild(text2);
			
			text2.addEventListener(TextEvent.LINK,function link(e:Event):void
			{
//				trace("refresh");
				BrowerUtil.reload();
			});
			
			var text3:TextField = new TextField();
			text3.filters = [FilterConst.glowFilter];
			text3.x = _barTotal.x + 83;
			text3.y = text2.y - 18;
			text3.width = 200;
			text3.height = 20;
			text3.selectable = false;
			text3.autoSize = TextFieldAutoSize.LEFT;
			text3.htmlText = PreLanguage.getString(110);//"<font color='#ff0000'>此游戏：适用于18岁以上用户</font>";
			_middlePart.addChild(text3);
			
//			var text3:TextField = new TextField();
//			text3.x = text2.x + 323;
//			text3.y = text2.y + 2;
//			text3.selectable = false;
//			text3.mouseEnabled = true;
//			text3.autoSize = TextFieldAutoSize.LEFT;
//			text3.text = "请点此刷新。";
//			text3.setTextFormat(new GTextFormat(FontUtil.songtiName,12,0x54ff00,null,null,true),0,text3.text.length);
//			text3.filters = [FilterConst.glowFilter];
//			_middlePart.addChild(text3);
//			
			 
//			var text4:TextField = new TextField();
//			text4.filters = [FilterConst.glowFilter]; 
//			text4.textColor = 0xB1EFFC;
//			text4.x = 170;
//			text4.y = 570;
//			text4.selectable = false;
//			text4.autoSize = TextFieldAutoSize.LEFT;
//			text4.text = "抵制不良游戏  拒绝盗版游戏         适当游戏益脑 沉迷游戏伤身         注意自我保护  谨防受骗上当         合理安排时间  享受健康生活";
//			_middlePart.addChild(text4);
			
			//加载小贴士配置文件
			GametipsConfig.instance.load(new URLRequest(PathConst.mainPath + ParamsConst.instance.gameTipsPath + "?v=" + ParamsConst.instance.flashVersion),onTipsLoaded);
			
			if(ParamsConst.instance.proxyType != ProxyType.TW)
			{
				//加载小logo
				_fanrenLogo = new Loader();
				url = "assets/modules/PreloaderPage/FanRen_LOGO.png";
				url = PathConst.mainPath + url+"?v="+ParamsConst.instance.flashVersion;
				_fanrenLogo.load(new URLRequest(url));
				_fanrenLogo.x = 857;
				_fanrenLogo.y = 507;
				_middlePart.addChild(_fanrenLogo);
				
				//加载小logo
				_forgameLogo = new Loader();
				url = "assets/modules/PreloaderPage/Forgame_LOGO.png";
				url = PathConst.mainPath + url+"?v="+ParamsConst.instance.flashVersion;
				_forgameLogo.load(new URLRequest(url));
				_forgameLogo.x = 757;
				_forgameLogo.y = 465;
				_middlePart.addChild(_forgameLogo);
			}
			
			stageResizeHandler();
		}
		
		private function bgCompleteHandler(e:Event):void
		{
			_bg.contentLoaderInfo.removeEventListener(Event.COMPLETE,bgCompleteHandler);
			
			stageResizeHandler();
		}
		
		private function onTipsLoaded():void
		{
			startTips();
			changeTipsText();
		}
		
		/**
		 * 开始小提示定时器，随机显示小提示
		 * 
		 * */
		public function startTips():void
		{
			if(!_tipsTimer)
			{
				_tipsTimer = new Timer(GametipsConfig.instance.intervalTime);
				_tipsTimer.addEventListener(TimerEvent.TIMER,onTipsTimerEvent);
				_tipsTimer.start();
			}
		}
		
		private function onTipsTimerEvent(e:TimerEvent):void
		{
			changeTipsText();
		}
		
		/**
		 * 改变小提示信息
		 * 
		 * */
		private function changeTipsText():void
		{
			if(_tips)
			{
				var text:String = GametipsConfig.instance.getRandomTip();
				
				if(text != "")
				{
					_tips.text = PreLanguage.getString(111) + text;
				}
			}
		}
		
		public function show():void
		{
			if( gameRoot)
			{
				gameRoot.addChildAt(this,0);
			}
		}
		
		public function hide():void
		{
			if( this.parent )
			{
				this.parent.removeChild(this);
			}
			dispose();
		}
		
		/**
		 * 根据导出类名获取bitmapdata
		 * 
		 * */
		public function getBitmapData(fullClassName:String):BitmapData
		{
			if(resourceLoader)
			{
				var bmd:Class = resourceLoader.contentLoaderInfo.applicationDomain.getDefinition(fullClassName) as Class;
				return new bmd(0,0) as BitmapData;
			}
			return new BitmapData(0,0);
		}
		
		/**
		 * 获取进度条
		 * 
		 * */
		public function getPreLoadBarMc(fullClassName:String):MovieClip
		{
			if(resourceLoader)
			{
				var mc:Class = resourceLoader.contentLoaderInfo.applicationDomain.getDefinition(fullClassName) as Class;
				return new mc() as MovieClip;
			}
			return new MovieClip();
		}
		
		private var _lastTotalProgress:int = 0;
		
		/**
		 * 设置进度
		 * 
		 * */
		public function setProgress(index:int, value:Number , maxValue:Number,tip:String = "" ):void
		{
			var length:int = PreloaderConfig.config[index]["length"];
			var baseValue:int = PreloaderConfig.config[index]["baseValue"];
			var text:String = PreloaderConfig.config[index]["text"];
			
			var progress:int = Math.round(baseValue + (value/maxValue)*length);
			if(progress < _lastTotalProgress)
			{
				return;	
			}
			_lastTotalProgress = progress;
			if(_barTotal)
			{
				_barTotal.gotoAndStop(progress);
				_totalText.text = PreLanguage.getString(107) + progress + "%";
				
				//测试用
				if(!startTime)
				{
					startTime = getTimer();
				}
				else
				{
					nowTime = getTimer();
					_timerText.text = PreLanguage.getString(112) + ((nowTime-startTime)/1000) + PreLanguage.getString(113);
				}
			}
			if(_barPart)
			{
				progress = Math.round(100*value/maxValue);
				_barPart.gotoAndStop(progress);
				_partText.text = text + "：" + progress + "%";
			}
			
		}
		
		private function stageResizeHandler(e:Event = null):void
		{
			if(_middlePart)
			{
				//根据logo定位
//				_middlePart.x = gameRoot.stageWidth/2 - logo.width/2 - logo.x;
				_middlePart.x = gameRoot.stageWidth/2 - 500;
//				_middlePart.y = gameRoot.stageHeight < _middlePart.height ? (gameRoot.stageHeight - _middlePart.height)/2 : gameRoot.stageHeight - _middlePart.height ;
				_middlePart.y = gameRoot.stageHeight/2 - 290;
			}
			if(_bg && _bg.content)
			{
//				var scX:Number = gameRoot.stageWidth/_bg.content.width;
//				var scY:Number = gameRoot.stageHeight/_bg.content.height;
//				
//				var sc:Number = Math.max(0.5,Math.min(scX,scY));
//				
//				_bg.scaleX = sc;
//				_bg.scaleY = sc;
				
				_bg.x = (gameRoot.stageWidth - _bg.content.width)/2;
				_bg.y = (gameRoot.stageHeight - _bg.content.height)/2 - 40;
			}
//			if(_tips)
//			{
//				_tips.width = gameRoot.stageWidth;
//			}
		}
		
		/**
		 * 摧毁
		 * 
		 * */
		public function dispose():void
		{
			if(_tipsTimer)
			{
				_tipsTimer.stop();
				_tipsTimer = null;
			}
			_instance = null;
			
			resourceLoader.unload();
			resourceLoader = null;
			_lastTotalProgress = 0;
			
			_bg.contentLoaderInfo.removeEventListener(Event.COMPLETE,bgCompleteHandler);
			_bg.unload();
			_bg = null;
			
			if(ParamsConst.instance.proxyType != ProxyType.TW)
			{
				_fanrenLogo.unload();
				_fanrenLogo = null;
				
				_forgameLogo.unload();
				_forgameLogo = null;
			}
			
		}
		
	}
}
