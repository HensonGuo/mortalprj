/**
 * 移动的鱼钩控制器 
 */
package mortal.game.view.miniGame.fishing.ObjController
{
	import com.gengine.global.Global;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.view.miniGame.MiniGameBaseController;
	import mortal.game.view.miniGame.MiniGameObject;
	import mortal.game.view.miniGame.fishing.FishingGlobal;
	import mortal.game.view.miniGame.fishing.FishingScene;
	import mortal.game.view.miniGame.fishing.Obj.Hook;
	import mortal.game.view.miniGame.fishing.defin.HookState;
	import mortal.mvc.core.Dispatcher;

	public class HookController extends MiniGameBaseController
	{
		protected var _speed:Number = 30;
		public function HookController()
		{
			super();
			addListeners();
		}
		
		protected function addListeners():void
		{
			
		}
		
		protected function removeListeners():void
		{
			
		}
		
		protected function startHook():void
		{
			var hook:Hook = _target as Hook;
			if(hook.hookState == HookState.swing)
			{
				if(!FishingGlobal.isHaveFishTime)
				{
					MsgManager.showRollTipsMsg(Language.getString(41522));
					return;
				}
				//如果没有鱼钩
				if(!FishingGlobal.isHaveFishHook)
				{
					MsgManager.showRollTipsMsg(Language.getString(41523));
					return;
				}
				//如果鱼篓已经满
				if(Cache.instance.pack.fishPackCache.getBackPackIsFullOrNot())
				{
					MsgManager.showRollTipsMsg(Language.getString(41525));
					return;
				}
				hook.hookState = HookState.down;
				Dispatcher.dispatchEvent( new DataEvent(EventName.FishMiniGameFishStart));
			}
		}
		
		public function autoRun():void
		{
			var hook:Hook = _target as Hook;
			var speed:Number = getSpeed();
			if(hook.hookState == HookState.down)
			{
				hook.speed = speed;
			}
			if(hook.hookState == HookState.up)
			{
				hook.speed = -1 * speed;
			}
		}
		
		protected function getSpeed():Number
		{
			var startPos:Number = 20;
			var endPos:Number = FishingScene.AREAHEIGHT - 40;
			var maxSpeed:Number = 8;
			var minSpeed:Number = 3;
			
			var yPos:Number = (_target as Hook).length;
			var per:Number = (endPos - yPos)/(endPos - startPos);
			var speed:Number = minSpeed + per * per * (maxSpeed - minSpeed);
			return speed;
		}
		
		override public function set target(obj:MiniGameObject):void
		{
			if(obj is Hook)
			{
				super.target = obj;
			}
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose();
			_speed = 0;
			removeListeners();
		}
	}
}