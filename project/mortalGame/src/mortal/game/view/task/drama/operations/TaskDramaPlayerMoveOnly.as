/**
 * 2014-4-11
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import flash.geom.Point;
	
	import mortal.common.net.CallLater;
	import mortal.game.Game;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.ai.AIManager;
	import mortal.game.scene3D.ai.AIType;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	import mortal.mvc.core.Dispatcher;
	
	public class TaskDramaPlayerMoveOnly implements ITaskDramaStepCommand
	{
		private var _callData:TTaskDrama;
		private var _callback:Function;
		private var _lastPoint:Point = new Point();
		private var _calling:Boolean = false;
		
		public function TaskDramaPlayerMoveOnly()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			if(_calling)
			{
				return;
			}
			_calling = true;
			_callData = data;
			Game.scene.lockSceen();
			_callback = callback;
			_lastPoint.x = RolePlayer.instance.x2d;
			_lastPoint.y = RolePlayer.instance.y2d;
			AIManager.cancelAll();
			AIManager.addMoveTo(new Point(data.valueOne, data.valueTwo), 20);
			Dispatcher.addEventListener(EventName.AI_MoveEnd, callEndHandler);
			AIManager.start();
		}
		
		private function callEndHandler(evt:DataEvent):void
		{
			Dispatcher.removeEventListener(EventName.AI_MoveEnd, callEndHandler);
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
			_calling = false;
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			_callback = callback;
			AIManager.cancelAll();
			if(data.valueOne > 0 || data.valueTwo > 0)
			{
				AIManager.addMoveTo(new Point(data.valueOne, data.valueTwo), 20);
			}
			else if(_lastPoint.x > 0 || _lastPoint.y > 0)
			{
				AIManager.addMoveTo(new Point(_lastPoint.x, _lastPoint.y), 2);
			}
			Dispatcher.addEventListener(EventName.AI_MoveEnd, cancelEndHandler);
			AIManager.start();
		}
		
		private function cancelEndHandler(evt:DataEvent):void
		{
			Game.scene.unLockSceen();
			Dispatcher.removeEventListener(EventName.AI_MoveEnd, cancelEndHandler);
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
		}
		
		public function dispose():void
		{
			Game.scene.unLockSceen();
			Dispatcher.removeEventListener(EventName.AI_MoveEnd, callEndHandler);
			Dispatcher.removeEventListener(EventName.AI_MoveEnd, cancelEndHandler);
			_callback = null;
		}
	}
}