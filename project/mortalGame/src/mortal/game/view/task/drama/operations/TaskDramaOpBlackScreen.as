package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import com.gengine.global.Global;
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;

	public class TaskDramaOpBlackScreen implements ITaskDramaStepCommand
	{
		private var _sp:Sprite;
		
		private static var _instance:TaskDramaOpBlackScreen;
		
		public function TaskDramaOpBlackScreen()
		{
		}
		
		public static function get instance():TaskDramaOpBlackScreen
		{
			if(_instance == null)
			{
				_instance = new TaskDramaOpBlackScreen();
			}
			return _instance;
		}

		public function call(data:TTaskDrama, callback:Function=null):void
		{
			LayerManager.highestLayer.addChild(sp);
			setTimeout(onTime, 500);
			function onTime():void
			{
				if(callback != null)
					callback.apply();
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			if(sp.parent != null)
				sp.parent.removeChild(sp);
			if(callback != null)
				callback.apply();
			
		}
		
		public function dispose():void
		{
			sp.graphics.clear();
			_sp = null;
		}
		
		private function get sp():Sprite
		{
			if(_sp == null)
			{
				_sp = new Sprite();
				_sp.graphics.beginFill(0x000000, 1.0);
				_sp.graphics.drawRect(0, 0, Global.stage.stageWidth, Global.stage.stageHeight);
				_sp.graphics.endFill();
				_sp.mouseChildren = false;
				_sp.mouseEnabled = false;
			}
			return _sp;
		}
	}
}