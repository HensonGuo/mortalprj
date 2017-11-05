package mortal.game.scene3D.layer3D.utils
{
	import baseEngine.system.Device3D;
	
	import com.gengine.debug.Log;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.game.Game;
	import mortal.game.scene3D.layer3D.PlayerLayer;
	import mortal.game.scene3D.map3D.SceneRange;
	import mortal.game.scene3D.map3D.sceneInfo.SceneEffectData;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;
	import mortal.game.view.systemSetting.SystemSetting;
	
	public class EffectUtil extends EntityLayerUtil
	{
		private var _map:Dictionary = new Dictionary();
		
		
		public function EffectUtil($layer:PlayerLayer)
		{
			super($layer);
		}
		
		public function getEffect( id:String ):EffectPlayer
		{
			return _map[id];
		}
		
		private function addEffectToMap( id:String ,effect:EffectPlayer):void
		{
			_map[id] = effect;
		}
		
		/**
		 * 添加单个特效
		 * 
		 */		
		public function addEffect( effectInfo:SceneEffectData ):EffectPlayer
		{
			var src:String = effectInfo.effectName;
			if( src )
			{
				var effect:EffectPlayer = getEffect(effectInfo.key) as EffectPlayer;
				if( effect == null )
				{
					effect = EffectPlayerPool.instance.getEffectPlayer(src.split(".")[0]);
					addEffectToMap(effectInfo.key, effect);
				}
				effect.x2d = effectInfo.x;
				effect.y2d = effectInfo.y;
				effect.play(true);
				Log.debug("增加特效:" + effectInfo.effectName,src);
				addToStage( effect );
				return effect;
			}
			return null
		}
		
		public function removeEffect( id:String ):void
		{
			var effect:EffectPlayer = getEffect(id);
			if( effect )
			{
				delete _map[id];
				effect.dispose();
			}
		}
		
		public function addToStage( effect:EffectPlayer,isBgEffect:Boolean = false):void
		{
			if(!isBgEffect)
			{
				Game.scene.playerLayer.addChild(effect);
			}
			else
			{
				//添加到背景层
			}
		}
		
		/**
		 * 抖动某个DisplayObject
		 */
		public static function wiggle(obj:DisplayObject):void
		{
			var x:Number = obj.x;
			var y:Number = obj.y;
			var timeLite:TimelineLite = new TimelineLite();
			timeLite.append( new TweenLite(obj,0.02,{x:x-7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y+5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x+7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y-5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x-7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y+5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x+7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y-5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x-7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y+5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x+7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y-5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y,onComplete:function():void
			{
				timeLite.stop();
				timeLite.kill();
				timeLite = null;
			}}));
			timeLite.play();
		}
		
		override public function removeAll():void
		{
			for each( var effect:EffectPlayer in _map)
			{
				effect.dispose();
			}
			_map = new Dictionary();
		}
		
		override public function updateEntity():void
		{
			if (!Game.sceneInfo)
			{
				return;
			}
			var ary:Array=Game.sceneInfo.effectInfos;
			if (ary.length < 1)
				return;
			var effect:EffectPlayer;
			var point:Point;
			for each (var effectInfo:SceneEffectData in ary)
			{
				//在场景范围内
				if (SceneRange.isInEffectRange(effectInfo.x, effectInfo.y) && !SystemSetting.instance.isHideAllEffect.bValue)// && effectInfo.isAddStage)
				{
					effect = getEffect(effectInfo.key);
					if (effect == null)
					{
						effect = addEffect(effectInfo);
					}
					else
					{
						if (effect.parent == null)
						{
							addToStage(effect);
						}
					}
				}
				else
				{
					removeEffect(effectInfo.key);
				}
			}
		}
	}
}