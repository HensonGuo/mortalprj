/**
 * 2014-2-11
 * @author chenriji
 **/
package mortal.game.scene3D.ai.ais
{
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mortal.game.scene3D.ai.base.AICommand;
	
	public class DelayAI extends AICommand
	{
		public function DelayAI()
		{
			super();
		}
		
		private var timerId:int = -1;
		public override function start(onEnd:Function=null):void
		{
			super.start(onEnd);
			
			var millonSecond:int = int(data.params);
			if(millonSecond <= 0)
			{
				stop();
			}
			timerId = setTimeout(stop, millonSecond);
			_startTime = getTimer();
			trace("de lay start time:" + getTimer());
		}
		private var _startTime:int;
		
		public override function stop():void
		{
			if(timerId > 0)
			{
				clearTimeout(timerId);
				timerId = -1;
			}
			trace("de lay end time:" + (_startTime - getTimer()));
			super.stop();
		}
	}
}