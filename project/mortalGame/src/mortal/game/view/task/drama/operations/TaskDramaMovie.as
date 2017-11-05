/**
 * 2014-5-5
 * @author chenriji
 **/
package mortal.game.view.task.drama.operations
{
	import Message.DB.Tables.TTaskDrama;
	
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.BitmapData;
	
	import mortal.common.DisplayUtil;
	import mortal.common.swfPlayer.SWFPlayer;
	import mortal.common.swfPlayer.data.ModelType;
	import mortal.game.manager.LayerManager;
	import mortal.game.scene3D.player.info.ModelInfo;
	import mortal.game.view.task.drama.interfaces.ITaskDramaStepCommand;
	
	public class TaskDramaMovie implements ITaskDramaStepCommand
	{
		private var _callback:Function;
		private var _player:SWFPlayer;
		private var _mWidth:int;
		private var _mHeight:int;
		
		public function TaskDramaMovie()
		{
		}
		
		public function call(data:TTaskDrama, callback:Function=null):void
		{
			_callback = callback;
			blacker.call(data);
			if(_player == null)
			{
				_player = ObjectPool.getObject(SWFPlayer);
				_player.loadedPlay = true;
				_player.timeRate = 3;
				LayerManager.highestLayer.addChild(_player);
				_player.move(21, 21);
				_player.playNum = 1;
				_player.loadComplete = loadedComplete;
			}
			_player.load(data.talkText, ModelType.NormalSwf, null);
			_player.actionPlayCompleteHandler = callEnd;
		}
		
		private function loadedComplete(info:*):void
		{
			if(_player != null)
			{
				_player.play();
			}
			
			var bm:BitmapData = _player.bitmapData;
			_mWidth = bm.width;
			_mHeight = bm.height;
			onStageResize();
		}
		
		public function onStageResize():void
		{
			if(_player != null)
			{
				_player.move((Global.stage.stageWidth - _mWidth)/2 + 200, (Global.stage.stageHeight - _mHeight)/2 + 200);
			}
		}
		
		public function cancel(data:TTaskDrama, callback:Function=null):void
		{
			_callback = callback;
			blacker.cancel(data);
		}
		
		private function callEnd():void
		{
			if(_player != null)
			{
				DisplayUtil.removeMe(_player);
				_player.stop();
			}
			blacker.cancel(null);
			
			if(_callback != null)
			{
				_callback.call();
				_callback = null;
			}
		}
		
		public function get blacker():TaskDramaOpBlackScreen
		{
			return TaskDramaOpBlackScreen.instance;
		}
	}
}