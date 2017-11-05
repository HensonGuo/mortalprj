package mortal.game.scene3D.fight.dramaEffect
{
	import com.gengine.utils.pools.ObjectPool;
	
	import mortal.game.scene3D.fight.dramaEffect.data.DramaMoveData;
	import mortal.game.scene3D.fight.dramaEffect.rule.DramaTweenRule;
	import mortal.game.scene3D.fight.dramaEffect.rule.DramaUniformRule;
	import mortal.game.scene3D.model.player.EffectPlayer;

	//一段特效序列
	public class DramaEffectArray
	{
		private var _aryMoveData:Array;
		
		private var _currentIndex:int = 0;
		
		private var _effectPlayer:EffectPlayer;
		
		private var _endCallBack:Function;
		
		public function DramaEffectArray()
		{
			
		}
		
		public function play(effectPlayer:EffectPlayer,aryMoveData:Array,endCallBack:Function):void
		{
			_aryMoveData = aryMoveData;
			_effectPlayer = effectPlayer;
			_endCallBack = endCallBack;
			playNext();
		}
		
		private function playNext():void
		{
			if(_currentIndex >= _aryMoveData.length)
			{
				playEnd();
				return;
			}
			
			var callBack:Function;
			if(_currentIndex == _aryMoveData.length - 1)
			{
				callBack = playEnd;
			}
			else
			{
				callBack = playNext;
			}
			
			var dramaMoveData:DramaMoveData = _aryMoveData[_currentIndex] as DramaMoveData;
			_currentIndex++;
			playDramaMove(_effectPlayer,dramaMoveData,callBack);
		}
		
		private function playDramaMove(effectPlayer:EffectPlayer,dramaMoveData:DramaMoveData,endCallBack:Function):void
		{
			if(dramaMoveData.moveType == DramaMoveType.MoveTypeUniform)
			{
				(ObjectPool.getObject(DramaUniformRule) as DramaUniformRule).play(effectPlayer,dramaMoveData,endCallBack);
			}
			else if(dramaMoveData.moveType == DramaMoveType.MoveTypeTween)
			{
				(ObjectPool.getObject(DramaTweenRule) as DramaTweenRule).play(effectPlayer,dramaMoveData,endCallBack);
			}
		}
		
		private function playEnd():void
		{
			if(_endCallBack != null)
			{
				_endCallBack.call();
			}
			dispose();
		}
		
		public function dispose():void
		{
			_aryMoveData = [];
			_currentIndex = 0;
			_effectPlayer = null;
			_endCallBack = null;
			ObjectPool.disposeObject(this);
		}
	}
}