/**
 * 自动摇摆的鱼钩控制器 
 */
package mortal.game.view.miniGame.fishing.ObjController
{
	import com.gengine.core.frame.FrameTimer;
	
	import flash.events.MouseEvent;
	
	import mortal.game.view.miniGame.fishing.FishingGlobal;
	import mortal.game.view.miniGame.fishing.Obj.Hook;
	import mortal.game.view.miniGame.fishing.defin.HookState;

	public class HookAutoSwingController extends HookController
	{
		private const MaxAngle:Number = 60;
		private const MinAngle:Number = -60;
		private const Speed:Number = 1.5;
		
		public function HookAutoSwingController()
		{
			super();
		}
		
		override protected function addListeners():void
		{
			FishingGlobal.scene.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		override protected function removeListeners():void
		{
			FishingGlobal.scene.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		private var _isAdd:Boolean = true;
		override public function autoRun():void
		{
			super.autoRun();
			var hook:Hook = _target as Hook;
			if(hook.hookState == HookState.swing)
			{
				var angle:Number = hook.angle;
				if(_isAdd)
				{
					angle += Speed;
					if(angle >= MaxAngle)
					{
						angle = MaxAngle;
						_isAdd = !_isAdd;
					}
				}
				else
				{
					angle -= Speed;
					if(angle <= MinAngle)
					{
						angle = MinAngle;
						_isAdd = !_isAdd;
					}
				}
				hook.angle = angle;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			var hook:Hook = _target as Hook;
			super.startHook();
		}
	}
}