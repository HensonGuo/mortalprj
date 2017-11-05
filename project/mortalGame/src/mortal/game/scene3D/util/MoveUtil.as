package mortal.game.scene3D.util
{
	import com.gengine.global.Global;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.player.entity.IEntity;
	import mortal.game.scene3D.player.entity.MovePlayer;

	public class MoveUtil
	{
		public static var lastMoveTime:int = 0;
		public static const speedIntervalBase:Number = 1000/60;
		public static var speedInterval:Number = 1000/60;
		public static var dif:Number = 0;
		
		private static var _isActive:Boolean = true;
		
		public static function init():void
		{
			Global.stage.addEventListener(Event.ACTIVATE,onActivateHandler,false,99999);
			Global.stage.addEventListener(Event.DEACTIVATE,onDeactivateHandler,false,99999);
		}
		
		public static function onActivateHandler(e:Event):void
		{
			_isActive = true;
			lastMoveTime = getTimer();
			dif = 0;
		}
		
		public static function onDeactivateHandler(e:Event):void
		{
			_isActive = false;
			dif = 0;
		}
		
		public static function updateEntityPos():void
		{
			if(lastMoveTime == 0)
			{
				lastMoveTime = getTimer();
				return;
			}
			var nowTime:int = getTimer();
			speedInterval = speedIntervalBase;
			if(_isActive)
			{
				dif += nowTime - lastMoveTime - speedIntervalBase;
				var dif2:Number = 0;
				if(dif > speedIntervalBase)
				{
					dif2 = dif * 0.1;
				}
				else if(dif > 0)
				{
					dif2 = 0.1 * speedIntervalBase;
				}
				speedInterval = speedIntervalBase + dif2;
				dif -= dif2;
			}
			lastMoveTime = nowTime;
			
			for each(var iEntity:IEntity in ThingUtil.entityUtil.entitysMap.allEntitys)
			{
				if(iEntity is MovePlayer)
				{
					(iEntity as MovePlayer).updatePos();
				}
			}
		}
	}
}