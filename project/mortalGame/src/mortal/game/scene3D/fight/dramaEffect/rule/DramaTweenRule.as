package mortal.game.scene3D.fight.dramaEffect.rule
{
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenLite;
	
	import flash.geom.Point;
	
	import mortal.game.scene3D.fight.dramaEffect.data.DramaMoveData;
	import mortal.game.scene3D.model.player.EffectPlayer;
	
	public class DramaTweenRule
	{
		protected var _effectPlayer:EffectPlayer;
		
		protected var _dramaMoveData:DramaMoveData;
		
		protected var _endCallBack:Function;
		
		public function DramaTweenRule()
		{
			
		}
		
		public function play($effectPlayer:EffectPlayer,$dramaMoveData:DramaMoveData,endCallBack:Function = null):void
		{
			_endCallBack = endCallBack;
			
			_effectPlayer = $effectPlayer;
			
			_dramaMoveData = $dramaMoveData;
			
			_effectPlayer.x = _dramaMoveData.startX;
			_effectPlayer.y = _dramaMoveData.startY;
			
			_effectPlayer.scaleX = _dramaMoveData.startScale;
			_effectPlayer.scaleY = _dramaMoveData.startScale;
			_effectPlayer.scaleZ = _dramaMoveData.startScale;
			
			TweenLite.to(_effectPlayer,_dramaMoveData.moveTime/1000,{x:_dramaMoveData.endX,y:_dramaMoveData.endY,scaleX:_dramaMoveData.endScale,scaleY:_dramaMoveData.endScale,scaleZ:_dramaMoveData.endScale,onComplete:function():void
			{
				playEnd();
			}});
				
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
			_effectPlayer = null;
			_dramaMoveData = null;
			_endCallBack = null;
			ObjectPool.disposeObject(this);
		}
	}
}