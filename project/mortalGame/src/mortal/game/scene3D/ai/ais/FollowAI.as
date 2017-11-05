/**
 * 2013-12-16
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import mortal.game.scene3D.ai.base.AICommand;
	import mortal.game.scene3D.ai.base.IAICommand;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.player.entity.MovePlayer;
	
	/**
	 * 跟随着一个目标
	 * @author chenriji
	 * 
	 */	
	public class FollowAI extends MoveAI
	{
		protected var _player:MovePlayer;
		public function FollowAI()
		{
			super();
		}
		
		public override function start(onEnd:Function=null):void
		{
			_player = _data.target as MovePlayer;
			_callback = onEnd;
			if(_player == null)
			{
				super.stop();
				return;
			}
			_player.pointChangeHandler = onTargetChangeHandler;
//			onTargetChangeHandler();
			super.start(onEnd);
		}
		
		public override function stop():void
		{
			_player.pointChangeHandler = null;
			super.stop();
		}
		
		public function onTargetChangeHandler():void
		{
			updateTilePoint();
			sceneMove(_targetPixPoint);
		}
		
		/**
		 * 移动完成
		 * @param evt
		 */
		protected override function onWalkEnd(evt:PlayerEvent):void
		{
			if(isInRange())
			{
				if(_meRole.isMove)
				{
					_meRole.stopWalking();
				}
			}
			else
			{
				sceneMove(_targetPixPoint);
			}
		}
		
		/**
		 * 格子移动完成
		 * @param evt
		 */
		protected override function onGirdWalkEnd(evt:PlayerEvent):void
		{
			if(isInRange())
			{
				if(_meRole.isMove)
				{
					_meRole.stopWalking();
				}
			}
		}
	}
}