package mortal.game.view.miniGame.fishing.ObjController
{
	import com.gengine.global.Global;

	public class HookMoveController extends HookController
	{
		public function HookMoveController()
		{
			super();
		}
		
		override protected function addListeners():void
		{
			Global.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			FishingGlobal.scene.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		override protected function removeListeners():void
		{
			Global.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			FishingGlobal.scene.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if((_target as Hook).hookState == HookState.swing)
			{
				if(!FishingGlobal.isHaveFishTime)
				{
					return;
				}
				var x:Number = FishingGlobal.scene.mouseX;
				x = x < 0?0:x;
				x = x > FishingScene.AREAWIDTH?FishingScene.AREAWIDTH:x;
				_target.x = x;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			startHook();
		}
	}
}