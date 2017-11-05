/**
 * 2014-4-14
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import mortal.common.net.CallLater;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.map3D.AstarAnyDirection.data.GeomUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	import mortal.mvc.core.Dispatcher;
	
	public class TaskDramaPlayerScreenMove implements ITaskDramaStepCommand
	{
		private var _callback:Function;
		private var _myData:TTaskDrama;
		public function TaskDramaPlayerScreenMove()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			_myData = data;
			_callback = callback;
			AIManager.cancelAll();
			var tp:Point = GameMapUtil.getTilePoint(data.valueOne, data.valueTwo);
			tp = GameMapUtil.getPixelPoint(tp.x,tp.y);
			AIManager.addMoveTo(new Point(tp.x,tp.y), 0);
			Dispatcher.addEventListener(EventName.AI_MoveEnd, aiMoveEndHandler);
			AIManager.start();
			
		}
		
		private function aiMoveEndHandler(evt:DataEvent):void
		{
			Dispatcher.removeEventListener(EventName.AI_MoveEnd, aiMoveEndHandler);
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			_callback = callback;
			Dispatcher.removeEventListener(EventName.AI_MoveEnd, aiMoveEndHandler);
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
		}
		
		public function dispose():void
		{
			Dispatcher.removeEventListener(EventName.AI_MoveEnd, aiMoveEndHandler);
		}
	}
}