package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import com.gengine.global.Global;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	import mortal.game.view.task.drama.operations.TaskDramaOpBlackScreen;
	import mortal.game.view.task.drama.operations.npctalk.TaskDramaTalkData;
	import mortal.game.view.task.drama.operations.npctalk.TaskDramaTalkMaskText;

	public class TaskDramaOpBlackScreenThenTips implements ITaskDramaStepCommand
	{
		private var _isInited:Boolean;
		private var _maskText:TaskDramaTalkMaskText;
		
		public function TaskDramaOpBlackScreenThenTips()
		{
		}
		
		public function dispose():void
		{
			if(_maskText != null)
			{
				_maskText.dispose();
			}
		}
		
		public function call(config:TTaskDrama, callback:Function=null):void
		{
			var tips:String = config.talkText;
			var showTime:Number = 2800;
			if(!_isInited)
			{
				init();
				_isInited = true;
			}
			// 获得一个npc对话的data
			var data:TaskDramaTalkData = getNpcTalkData(tips, showTime);
			blacker.call(config);
			
			_maskText.x = (Global.stage.stageWidth - data.rowWidth)/2;
			_maskText.y = Global.stage.stageHeight/2 - 50;
			LayerManager.highestLayer.addChild(_maskText);
			_maskText.show(data, onEnd);
			
			function onEnd():void
			{
				blacker.cancel(config);
				if(_maskText.parent != null)
					_maskText.parent.removeChild(_maskText);
				if(callback != null)
					callback.apply();
			}
		}
		
		public function cancel(config:TTaskDrama, callback:Function=null):void
		{
			blacker.cancel(config);
			if(_maskText.parent != null)
				_maskText.parent.removeChild(_maskText);
			if(callback != null)
				callback.apply();
		}
		
		private function getNpcTalkData(talk:String, showTime:Number):TaskDramaTalkData
		{
			var res:TaskDramaTalkData = new TaskDramaTalkData();
			res.popupTime = 0;
			res.rowWidth = Math.min(Global.stage.stageWidth, 800);
			res.showTime = showTime;
			res.speed = 5;
			res.talk = talk;
			res.talkFontLeading = 6;
			res.talkFontSize = 24;
			
			return res;
		}
		
		private function init():void
		{
			_maskText = new TaskDramaTalkMaskText();
		}
		
		public function get blacker():TaskDramaOpBlackScreen
		{
			return TaskDramaOpBlackScreen.instance;
		}
	}
}