package mortal.game.scene3D.fight.dramaEffect.rule
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.utils.MathUitl;
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import mortal.game.scene3D.fight.dramaEffect.data.DramaMoveData;
	import mortal.game.scene3D.map3D.util.GameMapUtil;
	import mortal.game.scene3D.model.player.EffectPlayer;

	public class DramaUniformRule
	{
		protected var _effectPlayer:EffectPlayer;
		
		protected var _dramaMoveData:DramaMoveData;
		
		protected var _endCallBack:Function;
		
		protected var _timer:FrameTimer;
		
		//像素坐标
		protected var _startX:int;
		
		protected var _startY:int;
		
		protected var _endX:int;
		
		protected var _endY:int;
		
		protected var _currentX:int;
		
		protected var _currentY:int;
		
		protected var _runTime:int = 0;
		
		public function DramaUniformRule()
		{
			
		}
		
		public function play($effectPlayer:EffectPlayer,$dramaMoveData:DramaMoveData,endCallBack:Function = null):void
		{
			_endCallBack = endCallBack;
			
			_effectPlayer = $effectPlayer;
			
			_dramaMoveData = $dramaMoveData;
			
			_startX = _dramaMoveData.startX;
			_startY = _dramaMoveData.startY;
			
			_endX = _dramaMoveData.endX;
			_endY = _dramaMoveData.endY;
			
			_currentX = _startX;
			_currentY = _startY;
			
			_effectPlayer.scaleX = _dramaMoveData.startScale;
			_effectPlayer.scaleY = _dramaMoveData.startScale;
			_effectPlayer.scaleZ = _dramaMoveData.startScale;
			
			_timer = new FrameTimer(1,int.MAX_VALUE,true);
			_timer.addListener(TimerType.ENTERFRAME,onEnterFrame);
			_timer.start();
		}
		
		private function onEnterFrame(e:FrameTimer):void
		{
			_runTime += e.interval;
			if(e.isRepair)
			{
				return;
			}
			var radians:Number = MathUitl.getRadiansByXY(_dramaMoveData.startX,_dramaMoveData.startY,_dramaMoveData.endX,_dramaMoveData.endY);
			
			var distance:Number = MathUitl.getDistance(_startX,_endX,_startY,_endY);
			
			var per:Number;
			
			if(_dramaMoveData.moveTime > 0)
			{
				per = _runTime/_dramaMoveData.moveTime;
			}
			else
			{
				//小于0无限播放
				per = 0;
			}
			
			if(per < 1)
			{
				_currentX = _startX + Math.cos(radians) * per * distance;
				_currentY = _startY + Math.sin(radians) * per * distance;
				
				_effectPlayer.x2d = _currentX;
				_effectPlayer.y2d = _currentY;
				
				var currentScale:Number = _dramaMoveData.startScale + per * (_dramaMoveData.endScale - _dramaMoveData.startScale);
				_effectPlayer.scaleX = currentScale;
				_effectPlayer.scaleY = currentScale;
				_effectPlayer.scaleZ = currentScale;
			}
			else
			{
				playEnd();
			}
		}
		
		protected function playEnd():void
		{
			if(_endCallBack != null )
			{
				_endCallBack.call();
			}
			dispose();
		}
		
		public function dispose():void
		{
			_timer.stop();
			_timer.dispose();
			_timer = null;
			_effectPlayer = null;
			_endCallBack = null;
			_dramaMoveData = null;
			_runTime = 0;
			ObjectPool.disposeObject(this);
		}
	}
}