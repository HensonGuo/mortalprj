package mortal.game.view.task.drama.operations
{
	import com.gengine.global.Global;
	import com.gengine.keyBoard.KeyBoardManager;
	
	import mortal.game.Game;
	import mortal.game.manager.LayerManager;

	public class TaskDramaMouseKeyboardControl
	{
		public function TaskDramaMouseKeyboardControl()
		{
		}
		
		public static function set enablePlayerOp(value:Boolean):void
		{
//			Game.scene.mouseChildren = value;
			Game.scene.setMouseEnabled(value);
//			Global.stage.mouseEnabled = value;
//			Global.stage.mouseChildren = value;
			
			if(value)
			{
				KeyBoardManager.instance.cancelListener();
				KeyBoardManager.instance.addListener();
			}
			else
			{
				KeyBoardManager.instance.cancelListener();
			}
		}
		
		public static function set enableViews(value:Boolean):void
		{
//			LayerManager.uiLayer.visible = value;
			if(!Global.isDebugModle)
			{
				LayerManager.windowLayer.visible = value;
			}
			LayerManager.topLayer.visible = value;
			LayerManager.popupLayer.visible = value;
//			LayerManager.issmBtnLayer.visible = value;
			LayerManager.guideLayer.visible = value;
			LayerManager.dragLayer.visible = value;
			LayerManager.toolTipLayer.visible = value;
			LayerManager.msgTipLayer.visible = value;
		}
	}
}