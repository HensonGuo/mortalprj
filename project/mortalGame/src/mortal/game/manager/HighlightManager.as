/**
 * 主界面高亮按钮管理类
 * @date	2011-5-7 下午03:46:34
 * @author shiyong
 * 
 */

package mortal.game.manager
{
	import fl.controls.Button;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.view.common.ModuleType;

	public class HighlightManager
	{
		private static var _instance:HighlightManager = new HighlightManager();
		
		public function HighlightManager()
		{
			if( _instance != null )
			{
				throw new Error("HighlightManager 单例");
			}
		}
		
		public static function get instance():HighlightManager
		{
			return _instance;
		}
		
		public function initSmallMap():void
		{
		}
		
		/**
		 * glowFilter动画效果 
		 * @param target
		 * @param glow
		 * 
		 */
		public function glowEffectButton(target:DisplayObject,glow:Boolean=true):void
		{
			if(glow)
			{
				if(target)
				{
					EffectManager.glowFilterReg(target,[FilterConst.uiBtnFilter]);
					target.addEventListener(MouseEvent.CLICK,onTargetClickHandler);
				}
			}
			else
			{
				EffectManager.glowFilterUnReg(target);
			}
		}

		/**
		 * 目标点击事件 
		 * @param event
		 * 
		 */
		private function onTargetClickHandler(event:MouseEvent):void
		{
			var target:DisplayObject = event.currentTarget as DisplayObject;
			if(target)
			{
				EffectManager.glowFilterUnReg(target);
				target.removeEventListener(MouseEvent.CLICK,onTargetClickHandler);
			}
		}
	}
}