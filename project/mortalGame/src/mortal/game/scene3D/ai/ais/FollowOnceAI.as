/**
 * 2014-1-13
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import mortal.game.scene3D.events.PlayerEvent;

	/**
	 * 只跟随一次 
	 * @author chenriji
	 * 
	 */	
	public class FollowOnceAI extends FollowAI
	{
		public function FollowOnceAI()
		{
			super();
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
					super.stop();
				}
			}
			else
			{
				sceneMove(_targetPixPoint);
			}
		}
	}
}