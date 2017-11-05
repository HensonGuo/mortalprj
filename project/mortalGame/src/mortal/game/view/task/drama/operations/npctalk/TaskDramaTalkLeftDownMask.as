package mortal.game.view.task.drama.operations.npctalk
{
	import com.gengine.global.Global;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextLineMetrics;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class TaskDramaTalkLeftDownMask extends Sprite
	{
		private var _masks:Array;
		private var _curIndex:int;
		private var _onEnd:Function;
		private var _fontSize:int;
		private var _lineHeight:int;
		private var _num:int;
		private var _distanceX:int;
		private var _curStage:int = 0;
		private var _timerId:int = -1;
		
		private const Stage_Stoping:int = 0;
		private const Stage_Tweening:int = 1;
		private const Stage_AllShowing:int = 2;
		
		public function TaskDramaTalkLeftDownMask()
		{
			super();
			_masks = [];
		}
		
		public function reInit(num:int, fontSize:int, lineHeight:int, distanceX:int, callback:Function):void
		{
			_num = num;
			_lineHeight = lineHeight;
			_fontSize = fontSize;
			_distanceX = distanceX;
			this._onEnd = callback;
			this._curIndex = 0;
			_curStage = Stage_Tweening;
			initMasks();
			maskWorking();
		}
		
		public function skip():void
		{
			if(_curStage == Stage_Stoping)
			{
				return;
			}
			else if(_curStage == Stage_Tweening)
			{
				TweenMax.killAll();
				for(var i:int = 0; i < _masks.length; i++)
				{
					var curMask:Sprite = this._masks[i] as Sprite;
					curMask.y = 0;
				}
				tweenEnd();
			}
			else if(_curStage == Stage_AllShowing)
			{
				callbackEnd();
			}
		}
		
		private function maskWorking():void
		{
			if(_curStage != Stage_Tweening)
			{
				return;
			}
			if(this._curIndex >= this._num)
			{
				tweenEnd();
				return;
			}
			var curMask:Sprite = this._masks[this._curIndex++] as Sprite;
			curMask.y = -curMask.height;
			TweenMax.to(curMask, _lineHeight/150, {"y":0, "onComplete":maskWorking});
		}
		
		private function tweenEnd():void
		{
			_curStage = Stage_AllShowing;
			_timerId = setTimeout(callbackEnd, 2000);
		}
		
		private function callbackEnd():void
		{
			clearTimeout(_timerId);
			_timerId = -1;
			_curStage = Stage_Stoping;
			if(_onEnd != null)
			{
				_onEnd.apply();
				_onEnd = null;
			}
		}
		
		private function initMasks():void
		{
			for(var i:int = 0; i < _num; i++)
			{
				var sp:Sprite;
				if(i < _masks.length)
				{
					sp = _masks[i] as Sprite;
					sp.graphics.clear();
				}
				else
				{
					sp = new Sprite();
					_masks.push(sp);
					this.addChild(sp);// 复原位
				}
				sp.graphics.beginFill(0xffffff, 1);
				sp.graphics.drawRect(0, 0, _fontSize + 3, _lineHeight + 2);
				sp.graphics.endFill();
				sp.x = (_fontSize + _distanceX) * (-i); // 复原位
				sp.y = - sp.height;
			}
		}
	}
}