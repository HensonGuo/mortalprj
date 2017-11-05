/**
 * 障碍物 
 */
package mortal.game.view.miniGame.fishing.Obj
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import mortal.game.scene.modle.SWFPlayer;
	import mortal.game.view.miniGame.fishing.ObjController.FishBaseController;

	public class Obstacle extends FishActionObject
	{
		public function Obstacle(ctrl:FishBaseController,swfPlayer:SWFPlayer = null)
		{
			super(ctrl,swfPlayer);
			this.minDepth = 80;
			this.maxDepth = 120;
		}
		
		private var _isInShake:Boolean = false;
		
		/**
		 * 是否在抖动 
		 * @return 
		 * 
		 */		
		public function get isInShake():Boolean
		{
			return _isInShake;
		}

		/**
		 * 抖动 
		 */		
		public function shake(totalTime:Number = 0.1):void
		{
			if(_isInShake)
			{
				return;
			}
			_isInShake = true;
			var oldX:Number = x;
			var oldY:Number = y;
			var timeLite:TimelineLite = new TimelineLite();
			for(var i:int = 0;i<int(totalTime/0.2);i++)
			{
				timeLite.append( new TweenLite(this,0.1,{x:oldX - 15}));
				timeLite.append( new TweenLite(this,0.1,{x:oldX + 15}));
			}
			timeLite.append( new TweenLite(this,0.1,{x:oldX - 15}));
			timeLite.append( new TweenLite(this,0.1,{x:oldX - 5,onComplete:function():void
			{
				x = oldX;
				_isInShake = false;
				timeLite.stop();
				timeLite = null;
			}}));
			timeLite.play();
		}
	}
}