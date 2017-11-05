/**
 * @heartspeak
 * 2013-12-18 
 */   	

package mortal.game.scene3D.util
{
	import Message.Public.SPoint;
	
	import com.gengine.debug.Log;
	import com.gengine.utils.MathUitl;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.utils.getTimer;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.data.ActionType;
	import mortal.game.scene3D.player.entity.MovePlayer;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.mvc.core.Dispatcher;

	public class JumpUtil
	{
		public static var minJumpTime:Number = 0.5;
		
		/**
		 * 处理连跳 
		 * @param player
		 * @param ary
		 * 
		 */		
		public static function jumpPoints(player:MovePlayer,ary:Array):void
		{
			ary.shift();
				
			jumpNext();
			
			function jumpNext():void
			{
				var point:SPoint = ary.shift();
				if(point)
				{
					jump(player,point.x,point.y,jumpNext);
				}
				else
				{
					player.dispatchEvent(new PlayerEvent(PlayerEvent.JumpPointEnd, player));
				}
			}
		}
		
		public static function jump(player:MovePlayer,toX:int,toY:int,jumpCallBack:Function = null):void
		{
//			Log.debug("跳跃开始时间",getTimer());
			player.stopMove();
			player.setAction(ActionType.Jump,ActionName.Jump);
			player.bodyPlayer.gotoFrame(0);
			player.direction = MathUitl.getAngleByXY(player.x2d,player.y2d,toX,toY);
			if(TweenMax.isTweening(player))
			{
				return;
			}
//			var jumpHeight:int = 200;
//			var distance:Number = GameMapUtil.getDistance(toX,toY,player.x2d,player.y2d);
//			var time:Number = Math.max((distance / speed), JumpUtil.minJumpTime);
//			var firstBezierY:Number = player.y2d - jumpHeight;
//			var secondBezierY:Number = toY - jumpHeight;
			player.isJumping = true;
			var tm:TweenMax = TweenMax.to(player, 1, {
				"x2d":toX,
				"y2d":toY,
				"frameInterval":1,
				//"bezier":[{"y2d":firstBezierY}, {"y2d":secondBezierY}],
				"ease":Linear.easeIn,
				"onUpdate":function ():void
				{
					if(player is RolePlayer)
					{
						(player as RolePlayer).setCurrentPointImpl();
						ThingUtil.isMoveChange = true;
					}
				},
				"onComplete":function ():void
				{
					player.isJumping = false;
					player.updateCurrentAlpha();
					if(jumpCallBack != null)
					{
						jumpCallBack.call();
					}
				}
			});
		}
		
		/**
		 * 翻滚 
		 * @param player
		 * @param toX
		 * @param toY
		 * @param speed
		 * @param jumpCallBack
		 * 
		 */		
		public static function somersault(player:MovePlayer,toX:int,toY:int,jumpCallBack:Function = null):void
		{
			if(!player)
			{
				return;
			}
			Log.debug("翻滚开始时间",getTimer());
			player.stopMove();
			player.setAction(ActionType.Jump,ActionName.Somersault);
			player.direction = MathUitl.getAngleByXY(player.x2d,player.y2d,toX,toY);
			if(TweenMax.isTweening(player))
			{
				return;
			}
			player.isJumping = true;
			var tm:TweenMax = TweenMax.to(player, 0.5, {
				"x2d":toX,
				"y2d":toY,
				"frameInterval":1,
				"ease":Linear.easeIn,
				"onUpdate":function ():void
				{
					if(player is RolePlayer)
					{
						(player as RolePlayer).setCurrentPointImpl();
						ThingUtil.isMoveChange = true;
					}
				},
				"onComplete":function ():void
				{
					player.isJumping = false;
					player.updateCurrentAlpha();
					if(jumpCallBack != null)
					{
						jumpCallBack.call();
					}
				}
			});
		}
		
		/**
		 * 跳斩  动作由技能控制
		 * @param player
		 * @param toX
		 * @param toY
		 * @param speed
		 * @param jumpCallBack
		 * 
		 */		
		public static function jumpCut(player:MovePlayer,toX:int,toY:int,time:Number = 0.7,jumpCallBack:Function = null):void
		{
			player.stopMove();
			player.direction = MathUitl.getAngleByXY(player.x2d,player.y2d,toX,toY);
			if(TweenMax.isTweening(player))
			{
				return;
			}
			player.isJumping = true;
			var tm:TweenMax = TweenMax.to(player, time, {
				"x2d":toX,
				"y2d":toY,
				"frameInterval":1,
				"ease":Linear.easeIn,
				"onUpdate":function ():void
				{
					if(player is RolePlayer)
					{
						(player as RolePlayer).setCurrentPointImpl();
						ThingUtil.isMoveChange = true;
					}
				},
				"onComplete":function ():void
				{
					player.updateCurrentAlpha();
					player.isJumping = false;
					player.dispatchEvent(new PlayerEvent(PlayerEvent.SkillPointEnd, player));
				}
			});
		}
	}
}