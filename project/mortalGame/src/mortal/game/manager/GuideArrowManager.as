/**
 * @date 2011-4-27 上午11:46:59
 * @author  宋立坤
 * 
 */  
package mortal.game.manager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.game.GameLayout;
	import mortal.game.view.guide.GuideArrow;

	public class GuideArrowManager
	{
		public static const Dir_T:int = 5;//上
		public static const Dir_B:int = 6;//下
		public static const Dir_L:int = 7;//左
		public static const Dir_R:int = 8;//右
		
		private static var _guideArrow:GuideArrow = new GuideArrow();
		private static var _dialogArrow:GuideArrow = new GuideArrow();
		private static var _timerKey:uint;
		private static var _onDelay:Function;
		private static var _params:Object;
		private static var _thumbParent:Sprite = new Sprite();
		
		public function GuideArrowManager()
		{
		}
		
		public static function get guideArrow():GuideArrow
		{
			return _guideArrow;
		}
		
		public static function get dialogArrow():GuideArrow
		{
			return _dialogArrow;
		}
		
		/**
		 * 显示箭头指引 
		 * @param dir
		 * @param onDelay 延时时间到的回调函数
		 * @param delay 要显示多久 单位毫秒
		 * @return 
		 * 
		 */
		public static function getGuideArrow(dir:int,onDelay:Function=null,delay:int=20000,extObj:Object=null):GuideArrow
		{
			hideGuideArrow();
			_guideArrow.updateDir(dir);
			if(delay > 0)
			{
				_timerKey = setTimeout(onTimerOut,delay);
			}
			if(onDelay != null)
			{
				_onDelay = onDelay;
				if(extObj)
				{
					_params = extObj;
				}
			}
			return _guideArrow;
		}
		
		/**
		 * npc对话箭头 
		 * @param dir
		 * @return 
		 * 
		 */
		public static function getDialogGuideArrow(dir:int):GuideArrow
		{
			hideDialogArrow();
			_dialogArrow.updateDir(dir);
			return _dialogArrow;
		}

		/**
		 * 在指定的层显示箭头 
		 * @param layer
		 * @param px
		 * @param py
		 * 
		 */
		public static function showGuideArrowAtLayer(layer:DisplayObjectContainer,px:int,py:int,dir:int,onDelay:Function=null,delay:int=20000):void
		{
			var arrow:GuideArrow = getGuideArrow(dir,onDelay,delay);
			arrow.x = px;
			arrow.y = py;
			layer.addChild(arrow);
		}
		
		/**
		 * 延迟时间到 
		 * 
		 */
		private static function onTimerOut():void
		{
			if(_onDelay != null)
			{
				if(_params)
				{
					_onDelay(_params);
				}
				else
				{
					_onDelay();
				}
			}
			hideGuideArrow();
		}
		
		/**
		 * 清理延迟计时
		 * 
		 */
		private static function clearTimer():void
		{
			clearTimeout(_timerKey);
			_onDelay = null;
			_params = null;
		}
		
		/**
		 * 隐藏箭头指引 
		 * 
		 */
		public static function hideGuideArrow():void
		{
			clearTimer();
			if(_guideArrow.parent != _thumbParent)
			{
				_thumbParent.addChild(_guideArrow);
				_guideArrow.dispose();
			}
		}
		
		/**
		 * 隐藏对话指引箭头 
		 * 
		 */
		public static function hideDialogArrow():void
		{
			if(_dialogArrow.parent != _thumbParent)
			{
				_thumbParent.addChild(_dialogArrow);
				_dialogArrow.dispose();
			}
		}
		
		/**
		 * 改变舞台坐标 
		 * 
		 */
		public static function stageResize():void
		{
			if(_guideArrow && _guideArrow.parent != _thumbParent)
			{
				if(_guideArrow.baseLayer)
				{
					_guideArrow.x = _guideArrow.baseX + _guideArrow.baseLayer.x;
					_guideArrow.y = _guideArrow.baseY + _guideArrow.baseLayer.y;
				}
			}
		}
	}
}