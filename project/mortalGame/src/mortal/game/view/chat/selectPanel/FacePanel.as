/**
 * @date 2011-3-11 下午08:15:12
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.chat.selectPanel
{
	import com.gengine.global.Global;
	import com.mui.controls.GTabBar;
	import com.mui.core.GlobalClass;
	import com.mui.core.IFrUI;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import mortal.common.GTextFormat;
	import mortal.common.ResManager;
	import mortal.common.global.GlobalStyle;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.cache.Cache;
	import mortal.game.manager.LayerManager;
	import mortal.game.view.common.UIFactory;
	
	public class FacePanel extends Sprite
	{
		private var _loadTips:String;
		private var _notVipTips:String;
		
		private var _dicFaceMcNumber:Dictionary;
		
		private var _tfNotHaveFace:TextField;
		
		private var _tabBarData:Array;
		private var _tabBar:GTabBar;
		
		private var _normalPanel:Sprite;
		private var _vipPanel:Sprite;
		private var _maskSp:Sprite;
		
		public function FacePanel()
		{
			super();
			_loadTips = "正在加载表情...";
			_notVipTips = "您不是VIP,无法使用VIP表情";
			_dicFaceMcNumber = new Dictionary();
			createChildren();
		}
		
		private static var _instance:FacePanel;
		private static var _currentBtn:InteractiveObject;
		private static var _dicbtnCallback:Dictionary = new Dictionary()
		
		public static function get instance():FacePanel
		{
			if(!_instance)
			{
				_instance = new FacePanel();
			}
			return _instance;
		}
		
		/**
		 * 注册一个按钮 
		 * @param btn
		 * 
		 */
		public static function registBtn(btn:IFrUI,callBack:Function):void
		{
			_dicbtnCallback[btn] = callBack;
			btn.configEventListener(MouseEvent.CLICK,onClickBtn);
		}
		
		/**
		 * 取消注册按钮 
		 * @param btn
		 * 
		 */
		public static function unRegistBtn(btn:IFrUI):void
		{
			if(btn)
			{
				(btn as InteractiveObject).removeEventListener(MouseEvent.CLICK,onClickBtn);
				delete _dicbtnCallback[btn];
			}
		}
		
		/**
		 * 点击被注册的按钮 
		 * @param e
		 * 
		 */
		private static function onClickBtn(e:MouseEvent):void
		{
			var btn:InteractiveObject = e.target as InteractiveObject;
			_currentBtn = btn;
			ResManager.instance.LoadFace();
			ResManager.instance.LoadFaceVIP();
			if(FacePanel.instance.parent)
			{
				hide();
			}
			else
			{
				var p:Point = btn.parent.localToGlobal(new Point(btn.x,btn.y));
				FacePanel.instance.x = p.x;
				FacePanel.instance.y = p.y - 190;
				LayerManager.toolTipLayer.addChild(FacePanel.instance);
				FacePanel.instance.startAllFace();
				Global.instance.callLater(addFrameClickStage);
			}
		}
		
		private static function hide():void
		{	
			FacePanel.instance.parent.removeChild(FacePanel.instance);
			FacePanel.instance.stopAllFace();
			Global.stage.removeEventListener(MouseEvent.CLICK,onClickStage);
		}
			
		
		private static function addFrameClickStage():void
		{
			Global.stage.addEventListener(MouseEvent.CLICK,onClickStage);
		}
		
		private static function onClickStage(e:MouseEvent):void
		{
			var target:DisplayObject = e.target as DisplayObject;
			
			if(target != _currentBtn && target != FacePanel.instance && !FacePanel.instance.contains(target))
			{
				if(FacePanel.instance.parent)
				{
					hide();
				}
			}
		}
		
		private function createChildren():void
		{
			//背景
			var	scaleBg:ScaleBitmap = ResourceConst.getScaleBitmap("ToolTipBg");
			scaleBg.width = 310;
			scaleBg.height = 185;
			this.addChild(scaleBg);
			
			UIFactory.bg(10,155,299,1,this,"SplitLine");
			
			_tabBarData = [{name:"普通表情",label:"普通表情"},{name:"VIP表情",label:"VIP表情"}];
			_tabBar = UIFactory.gTabBar(8,157,_tabBarData,62,22,this,onTabBarChange);
			_tabBar.buttonStyleName = "ChatBtn";
			
			var tf:GTextFormat = GlobalStyle.textFormatBai;
			tf.center();
			_tfNotHaveFace = UIFactory.textField(_loadTips,30,70,240,20,null, tf);
			_normalPanel = new Sprite();
			this.addChild(_normalPanel);
			
			_vipPanel = new Sprite();
			_vipPanel.visible = false;
			this.addChild(_vipPanel);
			
			createNormal();
			createVIP();
			
			this.addChild(_tfNotHaveFace);
		}
		
		/**
		 * 创建普通的表情区域 
		 * 
		 */		
		private function createNormal():void
		{
			if(!ResManager.instance.isFaceLoaded)
			{
				ResManager.instance.registerFace(addFace);
			}
			else
			{
				addFace();
			}
			layOut();
		}
		
		private function addFace():void
		{
			//按钮
			for(var i:int = 1;i<=72;i++)
			{
				var mcFace:MovieClip = GlobalClass.getInstance("a" + (i - 1)) as MovieClip;
				mcFace.x = 5 + 25 * ((i - 1)%12);
				mcFace.y = 5 + 25 * Math.floor((i - 1)/12);
				mcFace.mouseEnabled = true;
				mcFace.buttonMode = true;
				_normalPanel.addChild(mcFace);
				
				mcFace.addEventListener(MouseEvent.MOUSE_OVER,selectHandler);
				mcFace.addEventListener(MouseEvent.MOUSE_OUT,selectHandler);
				mcFace.addEventListener(MouseEvent.CLICK,choseFaceHandler);
				_dicFaceMcNumber[mcFace] = i;
			}
			layOut();
		}
		
		/**
		 * 
		 * 创建VIP
		 */
		private function createVIP():void
		{
			if(!ResManager.instance.isFaceVIPLoaded)
			{
				ResManager.instance.registerFaceVIP(addFaceVIP);
			}
			else
			{
				addFaceVIP();
			}
			layOut();
		}
		
		/**
		 * 添加VIP表情 
		 * 
		 */
		private function addFaceVIP():void
		{
			//按钮
			for(var i:int = 1;i<=14;i++)
			{
				var mcFace:MovieClip = GlobalClass.getInstance("b" + (i - 1)) as MovieClip;
				mcFace.x = 11 + 60 * ((i - 1)%5);
				mcFace.y = 8 + 50 * Math.floor((i - 1)/5);
				mcFace.mouseEnabled = true;
				mcFace.buttonMode = true;
				_vipPanel.addChild(mcFace);
				
				mcFace.addEventListener(MouseEvent.MOUSE_OVER,selectHandler);
				mcFace.addEventListener(MouseEvent.MOUSE_OUT,selectHandler);
				mcFace.addEventListener(MouseEvent.CLICK,choseFaceHandler);
				_dicFaceMcNumber[mcFace] = "b" + i;
			}
			_maskSp = new Sprite();
			var maskBmp:Bitmap = new Bitmap();
			maskBmp.x = 3;
			maskBmp.y = 3;
			maskBmp.bitmapData = new BitmapData(304,154,true,0x66FFFFFF);
			maskBmp.visible = false;
			_maskSp.addChild(maskBmp);
			this.addChild(_maskSp);
			layOut();
		}
		
		/**
		 * 更新布局 
		 * 
		 */
		public function layOut():void
		{
			_tfNotHaveFace.visible = false;
			_normalPanel.visible = false;
			_vipPanel.visible = false;
//			_maskSp.visible = false;
			
			var chooseIndex:int = _tabBar.selectedIndex;
			if(chooseIndex == 0)
			{
				if(ResManager.instance.isFaceLoaded)
				{
					_normalPanel.visible = true;
				}
				else
				{
					_tfNotHaveFace.text = _loadTips;
					_tfNotHaveFace.visible = true;
				}
			}
			else if(chooseIndex == 1)
			{
//				if(!Cache.instance.vip.isVIP)
//				{
////					_maskSp.visible = true;
//					_tfNotHaveFace.text = _notVipTips;
//					_tfNotHaveFace.visible = true;
////					_vipPanel.visible = true;
//				}
				if(ResManager.instance.isFaceLoaded)
				{
					_vipPanel.visible = true;
				}
				else
				{
					_tfNotHaveFace.text = _loadTips;
					_tfNotHaveFace.visible = true;
				}
			}
		}
		
		/**
		 * tabBarChange调度 
		 * @param e
		 * 
		 */
		private function onTabBarChange(e:MuiEvent):void
		{
			layOut();
		}
		
		private function selectHandler(e:MouseEvent):void
		{
			var target:MovieClip = e.target as MovieClip;
			if(e.type == MouseEvent.MOUSE_OVER)
			{
				target.filters = [FilterConst.itemChooseFilter];
			}
			if(e.type == MouseEvent.MOUSE_OUT)
			{
				target.filters = [];
			}
		}
		
		private function choseFaceHandler(e:MouseEvent):void
		{
			FacePanel.hide();
			(_dicbtnCallback[_currentBtn] as Function).call(null,_dicFaceMcNumber[(e.currentTarget as MovieClip)]);
//			callAll(_dicFaceMcNumber[(e.currentTarget as MovieClip)]);
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			for (var mc:* in _dicFaceMcNumber)
			{
				if(mc is MovieClip)
				{
					if(value && Global.stage.contains(this))
					{
						(mc as MovieClip).play();
					}
					else
					{
						(mc as MovieClip).stop();
					}
				}
			}
		}
		
		public function stopAllFace():void
		{
			for (var mc:* in _dicFaceMcNumber)
			{
				if(mc is MovieClip)
				{
					(mc as MovieClip).stop();
				}
			}
		}
		
		public function startAllFace():void
		{
			for (var mc:* in _dicFaceMcNumber)
			{
				if(mc is MovieClip)
				{
					(mc as MovieClip).play();
				}
			}
		}
		
	}
}