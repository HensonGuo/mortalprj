package mortal.game.scene3D.fight.dramaEffect
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import mortal.game.Game;
	import mortal.game.resource.info.DramaEffectInfo;
	import mortal.game.scene3D.fight.dramaEffect.data.DramaMoveData;
	import mortal.game.scene3D.model.player.EffectPlayer;
	import mortal.game.scene3D.model.pools.EffectPlayerPool;

	public class DramaEffect
	{
		private var _dramaEffectInfo:DramaEffectInfo;
		
		private var _aryMoveData:Array;
		
		private var _timer:FrameTimer;
		
		private var _callBack:Function;
		
		private var _aryPlayer:Array = [];
		
		public function DramaEffect($dramaEffectData:DramaEffectInfo,callBack:Function)
		{
			_dramaEffectInfo = $dramaEffectData;
			_callBack = callBack;
			init();
		}
		
		/**
		 * 初始化 
		 * 
		 */
		private function init():void
		{
			alzData();
			if(_dramaEffectInfo.delay > 0)
			{
				setTimeout(start,_dramaEffectInfo.delay);
			}
			else
			{
				start();
			}
		}
		
		private function start():void
		{
			if(_dramaEffectInfo.repeatCount > 1 || _dramaEffectInfo.repeatCount == -1)
			{
				if(_dramaEffectInfo.repeatCount == -1)
				{
					if(_callBack != null)
					{
						_callBack.call();
					}
				}
				addFrameTimer();
			}
			else
			{
				if(_dramaEffectInfo.effectType == DramaEffectType.EffectTypeMove)
				{
					move(true);
				}
				else if(_dramaEffectInfo.effectType == DramaEffectType.EffectTypeSkill)
				{
					fireSkill(true);
				}
			}
		}
		
		/**
		 * 分解数据 
		 * 
		 */		
		private function alzData():void
		{
			_aryMoveData = [];
			if(_dramaEffectInfo.effectType == DramaEffectType.EffectTypeMove)
			{
				for(var i:int = 0; i < _dramaEffectInfo.points.length - 1;i++)
				{
					if(_dramaEffectInfo.moveTime.length > i && _dramaEffectInfo.moveType.length > i
					&& _dramaEffectInfo.scale.length > (i + 1))
					{
						var dramaMoveData:DramaMoveData = new DramaMoveData();
						var startPoint:Point = _dramaEffectInfo.points[i] as Point;
						var endPoint:Point = _dramaEffectInfo.points[i + 1] as Point;
						dramaMoveData.startX = startPoint.x;
						dramaMoveData.startY = startPoint.y;
						dramaMoveData.endX = endPoint.x;
						dramaMoveData.endY = endPoint.y;
						dramaMoveData.startScale = _dramaEffectInfo.scale[i];
						dramaMoveData.endScale = _dramaEffectInfo.scale[i + 1];
						dramaMoveData.moveType = _dramaEffectInfo.moveType[i];
						dramaMoveData.moveTime = _dramaEffectInfo.moveTime[i];
						_aryMoveData.push(dramaMoveData);
					}
				}
			}
		}
		
		private function addFrameTimer():void
		{
			var repeatCount:int = _dramaEffectInfo.repeatCount;
			if(repeatCount == -1)
			{
				repeatCount = int.MAX_VALUE;
			}
			_timer = new FrameTimer(_dramaEffectInfo.repeatInterval,repeatCount);
			_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			_timer.start();
		}
		
		/**
		 * 每帧执行 
		 * @param timer
		 * 
		 */		
		private function onEnterFrame(timer:FrameTimer):void
		{
			var isLast:Boolean = timer.repeatCount == 0;
			if(_dramaEffectInfo.effectType == DramaEffectType.EffectTypeMove)
			{
				move(isLast);
			}
			else if(_dramaEffectInfo.effectType == DramaEffectType.EffectTypeMove)
			{
				fireSkill(isLast);
			}
		}
		
		/**
		 * 开始播放 
		 * 
		 */
		public function move(isLast:Boolean = false):void
		{
			var effectPlayer:EffectPlayer = EffectPlayerPool.instance.getEffectPlayer(_dramaEffectInfo.src);
			Game.scene.playerLayer.addChild(effectPlayer);
			effectPlayer.play(true);
			_aryPlayer.push(effectPlayer);
			
			if(_aryMoveData.length > 0)
			{
				var dramaMoveData:DramaMoveData = _aryMoveData[0] as DramaMoveData;
				effectPlayer.x2d = dramaMoveData.startX;
				effectPlayer.y2d = dramaMoveData.startY;
				(ObjectPool.getObject(DramaEffectArray) as DramaEffectArray).play(effectPlayer,_aryMoveData,playEnd);
			}
			
			function playEnd():void
			{
				_aryPlayer = _aryPlayer.splice(_aryPlayer.indexOf(effectPlayer),1);
				effectPlayer.dispose();
				
				if(isLast)
				{
					if(_callBack != null)
					{
						_callBack.call();
					}
					dispose();
				}
			}
		}
		
		/**
		 * 释放技能 
		 * 
		 */
		public function fireSkill(isLast:Boolean = false):void
		{
			for(var i:int = 0;i < _dramaEffectInfo.points.length;i++)
			{
				var p:Point = _dramaEffectInfo.points[i] as Point;
				var effectPlayer:EffectPlayer = EffectPlayerPool.instance.getEffectPlayer(_dramaEffectInfo.src);
				Game.scene.playerLayer.addChild(effectPlayer);
				if(_dramaEffectInfo.scale.length > i)
				{
					effectPlayer.scaleX = _dramaEffectInfo.scale[i];
					effectPlayer.scaleY = _dramaEffectInfo.scale[i];
					effectPlayer.scaleZ = _dramaEffectInfo.scale[i];
				}
				effectPlayer.x2d = p.x;
				effectPlayer.y2d = p.y;
			}
			if(isLast)
			{
				if(_callBack != null)
				{
					_callBack.call();
				}
				dispose();
			}
		}
		
		public function removeAllChildren():void
		{
			for(var i:int = 0; i < _aryPlayer.length;i++)
			{
				var effectPlayer:EffectPlayer = _aryPlayer[i] as EffectPlayer;
				if(effectPlayer)
				{
					effectPlayer.dispose();
				}
			}
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			if(_timer)
			{
				_timer.stop();
				_timer.dispose();
				_timer = null;
			}
			_aryMoveData = [];
			_callBack = null;
			_dramaEffectInfo = null;
			var length:int = _aryPlayer.length;
			for(var i:int = 0;i < _aryPlayer.length;i++)
			{
				(_aryPlayer[i] as EffectPlayer).dispose();
			}
			_aryPlayer = [];
		}

		public function get dramaEffectInfo():DramaEffectInfo
		{
			return _dramaEffectInfo;
		}

	}
}