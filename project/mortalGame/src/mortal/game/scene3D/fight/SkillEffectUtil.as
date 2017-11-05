/**
 * @heartspeak
 * 2014-1-10 
 */   	

package mortal.game.scene3D.fight
{
	import baseEngine.system.Device3D;
	
	import com.gengine.debug.Log;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import frEngine.effectEditTool.temple.TempleFight;
	import frEngine.effectEditTool.temple.TempleRole;
	
	import mortal.game.Game;
	import mortal.game.manager.LayerManager;
	import mortal.game.resource.DramaEffectConfig;
	import mortal.game.resource.info.DramaEffectInfo;
	import mortal.game.scene3D.fight.dramaEffect.DramaEffect;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.player.WeaponPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;
	import mortal.game.scene3D.player.entity.SpritePlayer;
	import mortal.game.scene3D.player.entity.UserPlayer;
	import mortal.game.view.systemSetting.SystemSetting;

	public class SkillEffectUtil
	{
		public function SkillEffectUtil()
		{
		}
		
		/**
		 * 对象添加特效 
		 * @param player
		 * 
		 */		
		public static function addPlayerEffect(player:SpritePlayer,url:String,callBack:Function = null, isRepeat:Boolean = false,isFollowRotate:Boolean = false):EffectPlayer
		{
			if(SystemSetting.instance.isHideAllEffect.bValue || SystemSetting.instance.isHideSkill.bValue)
			{
				if(callBack != null)
				{
					callBack.call(null);
				}
				return null;
			}
			var effectPlayer:EffectPlayer = EffectPlayerPool.instance.getEffectPlayer(url);
			
			if(effectPlayer.temple is TempleRole)
			{
				(effectPlayer.temple as TempleRole).setRoleParams(player.bodyPlayer,callBack);
			}
			else
			{
				if(isFollowRotate && player.bodyPlayer)
				{
					player.bodyPlayer.addChild(effectPlayer);	
				}
				else
				{
					player.addChild(effectPlayer);
				}
			}
			effectPlayer.play(isRepeat);
			return effectPlayer;
		}
		
		/**
		 * 目标点添加特效 
		 * @param player
		 * 
		 */		
		public static function addPointEffect(point:Point,url:String,direction:Number = 0):void
		{
			if(SystemSetting.instance.isHideAllEffect.bValue || SystemSetting.instance.isHideSkill.bValue)
			{
				return;
			}
			var effectPlayer:EffectPlayer = EffectPlayerPool.instance.getEffectPlayer(url);
			effectPlayer.x2d = point.x;
			effectPlayer.y2d = point.y;
			effectPlayer.direction = direction;
			Game.scene.playerLayer.addChild(effectPlayer);
			effectPlayer.play(false);
		}
		
		/**
		 * 添加弹道特效 
		 * @param fromPlayer
		 * @param toPlayer
		 * @param url
		 * @return 
		 * 
		 */		
		public static function addTrackPlayer(fromPlayer:SpritePlayer,toPlayer:SpritePlayer,url:String,callBack:Function):EffectPlayer
		{
			if(SystemSetting.instance.isHideAllEffect.bValue || SystemSetting.instance.isHideSkill.bValue)
			{
				if(callBack != null)
				{
					callBack.call(null);
				}
				return null;
			}
			var effectPlayer:EffectPlayer = EffectPlayerPool.instance.getEffectPlayer(url);
			
			if(!fromPlayer || !toPlayer)
			{
				callBack.call(null);
				return null;
			}
			if(effectPlayer.temple is TempleFight)
			{
				Log.debug("弹道开始：",getTimer());
				var weaponPlayer:WeaponPlayer;
				if(fromPlayer is UserPlayer)
				{
					weaponPlayer = (fromPlayer as UserPlayer).weaponPlayer;
				}
				(effectPlayer.temple as TempleFight).setFightParams(fromPlayer.bodyPlayer,toPlayer.bodyPlayer,weaponPlayer,true,callBack); 
				effectPlayer.play(false);
				return effectPlayer;
			}
			else if(effectPlayer.temple is TempleRole)
			{
				(effectPlayer.temple as TempleRole).setRoleParams(fromPlayer.bodyPlayer,callBack);
				effectPlayer.play(false);
				return effectPlayer;
			}
			else
			{
				callBack.call();
				return null;
			}
		}
		
		private static var _aryDramaEffect:Array = [];
		
		public static function addDramaEffect(effectCode:int,callBack:Function = null):void
		{
			var dramaEffectInfo:DramaEffectInfo = DramaEffectConfig.instance.getDramaEffectInfo(effectCode);
			if(!dramaEffectInfo)
			{
				return;
			}
			var dramaEffect:DramaEffect = new DramaEffect(dramaEffectInfo,callBack);
			_aryDramaEffect.push(dramaEffect);
		}
		
		/**
		 * 移除特效 
		 * @param effectCode
		 * 
		 */
		public static function removeDramaEffect(effectCode:int):void
		{
			for(var i:int = _aryDramaEffect.length - 1;i >= 0;i--)
			{
				var dramaEffect:DramaEffect = _aryDramaEffect[i] as DramaEffect;
				if(dramaEffect && dramaEffect.dramaEffectInfo && dramaEffect.dramaEffectInfo.code == effectCode)
				{
					dramaEffect.removeAllChildren();
					dramaEffect.dispose();
				}
			}
		}
		
		public static function removeAllChildren():void
		{
			for(var i:int = 0;i < _aryDramaEffect.length;i++)
			{
				var dramaEffect:DramaEffect = _aryDramaEffect[i] as DramaEffect;
				dramaEffect.dispose();
			}
			_aryDramaEffect = [];
		}
	}
}