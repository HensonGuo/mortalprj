/**
 * 2014-4-14
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TBoss;
	import Message.DB.Tables.TTaskDrama;
	
	import com.mui.controls.Alert;
	
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mortal.game.manager.LayerManager;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MonsterPlayer;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaBossTalk implements ITaskDramaStepCommand
	{
		private var _callback:Function;
		private var timerId:int = -1;
		
		public function TaskDramaBossTalk()
		{
		}
		

		public function call(data:TTaskDrama, callback:Function=null):void
		{
			if(timerId > 0)
			{
				clearTimeout(timerId);
				timerId = -1;
			}
			
			_callback = callback;
			var boss:MonsterPlayer = this.getBossByCode(data.entity);
			if(boss != null)
			{
				LayerManager.entityTalkLayer.addTalk(boss, data.talkText, 5500);
				timerId = setTimeout(talkFinished, 5000);
			}
			else
			{
				Alert.show("没找到对应的boss：" + data.entity);
				talkFinished();
			}
		}
		private function talkFinished():void
		{
			timerId = -1;
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			if(timerId > 0)
			{
				clearTimeout(timerId);
				timerId = -1;
			}
			
			_callback = callback;
			var boss:MonsterPlayer = this.getBossByCode(data.talkNpc);
			if(boss != null)
			{
				LayerManager.entityTalkLayer.removeTalk(boss);
				timerId = setTimeout(cancelEnd, 5500);
			}
		}
		
		private function cancelEnd():void
		{
			timerId = -1;
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
		}
		
		private function getBossByCode(code:int):MonsterPlayer
		{
			var all:Dictionary = ThingUtil.entityUtil.entitysMap.allEntitys;
			for each(var entity:IEntity in all)
			{
				if(entity is MonsterPlayer)
				{
					var info:TBoss = (entity as MonsterPlayer)._bossInfo;
					if(info.code == code)
					{
						return entity as MonsterPlayer;
					}
				}
			}
			return null;
		}
		
		public function dispose():void
		{
			if(timerId > 0)
			{
				clearTimeout(timerId);
				timerId = -1;
			}
			if(_callback != null)
			{
				_callback.apply();
				_callback = null;
			}
		}
	}
}