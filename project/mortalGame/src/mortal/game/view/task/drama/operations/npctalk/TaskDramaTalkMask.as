package mortal.game.view.task.drama.operations.npctalk
{
	import com.mui.controls.GTextFiled;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextLineMetrics;
	
	public class TaskDramaTalkMask extends Sprite
	{
		private var _data:TaskDramaTalkData;
		private var _masks:Array;
		private var _curIndex:int;
		private var _onEnd:Function;
		private var _lineNum:int;
		private var _text:GTextFiled;
		private var _isProcessing:Boolean = false;
		private var _nextWidth:Number = 600;
		private var _shouldReWidth:Boolean = false;
		
		public function TaskDramaTalkMask()
		{
			super();
			_masks = [];
		}
		
		public function reInit(data:TaskDramaTalkData, text:GTextFiled, callback:Function):void
		{
			this._data = data;
			this._lineNum = text.numLines;
			this._text = text;
			this._onEnd = callback;
			this._curIndex = 0;
			refleshAndStart();
		}
		
		public function finishRightNow():void
		{
			for(var i:int = 0; i < _masks.length; i++)
			{
				var sp:Sprite = _masks[i] as Sprite;
				sp.x = 0;
			}
			endAndCallback();
		}
		
		private var _reWidthed:Boolean = false;
		public function reWidth(value:Number):void
		{
			if(_data == null)
				return;
			if(_isProcessing)
			{
				_reWidthed = true;
				_isProcessing = false;
				endAndCallback();
			}
			for(var i:int = 0; i < _masks.length; i++)
			{
				var sp:Sprite = _masks[i] as Sprite;
				sp.graphics.clear();
				sp.graphics.beginFill(0xffffff, 0);
				sp.graphics.drawRect(0, 0, value, _data.talkFontSize + _data.talkFontLeading);
				sp.graphics.endFill();
				sp.x = 0;
			}
		}
		
		public function stop():void
		{
			_isProcessing = false;
			this.removeEventListener(Event.ENTER_FRAME, onEveryFrame);
		}
		
		private function refleshAndStart():void
		{
			initMasks();
			_isProcessing = true;
			this.addEventListener(Event.ENTER_FRAME, onEveryFrame);
		}
		
		private function onEveryFrame(evt:Event):void
		{
			if(_reWidthed)
			{
				_reWidthed = false;
				return;
			}
			var sp:Sprite = _masks[_curIndex] as Sprite;
			var metrics:TextLineMetrics = _text.getLineMetrics(_curIndex);
			sp.x += this._data.speed;
			if(sp.x > metrics.width + 8 - _data.rowWidth)
			{
				sp.x = metrics.width + 8 - _data.rowWidth;
				_curIndex++;
				if(_curIndex >= _lineNum)
				{
					endAndCallback();
				}
			}
		}
		
		private function endAndCallback():void
		{
			_isProcessing = false;
			this.removeEventListener(Event.ENTER_FRAME, onEveryFrame);
			if(_onEnd != null)
			{
				_onEnd.apply();
				_onEnd = null;
			}
		}
		
		private function initMasks():void
		{
			for(var i:int = 0; i < _lineNum + 1; i++)
			{
				var sp:Sprite;
				if(i < _masks.length)
				{
					sp = _masks[i] as Sprite;
					sp.graphics.clear();
					sp.graphics.beginFill(0xffffff, 0);
					sp.graphics.drawRect(0, 0, _data.rowWidth, _data.talkFontSize + _data.talkFontLeading);
					sp.graphics.endFill();
					sp.x = -_data.rowWidth; // 复原位
					sp.y = i * sp.height;
				}
				else
				{
					sp = new Sprite();
					sp.graphics.beginFill(0xffffff, 0);
					sp.graphics.drawRect(0, 0, _data.rowWidth, _data.talkFontSize + _data.talkFontLeading);
					sp.graphics.endFill();
					sp.x = -_data.rowWidth;
					sp.y = i * sp.height;
					_masks.push(sp);
					this.addChild(sp);// 复原位
				}
			}
		}
		
		private function getPixesNum():int
		{
			var res:int = 0;
			for(var i:int = 0; i < _data.talk.length; i++)
			{
				if(_data.talk.charCodeAt(i) < 255)
					res += _data.talkFontSize/2;
				else
					res += _data.talkFontSize;
			}
			return res;
		}
		
		public function getLineNum():int
		{
			return _lineNum;
		}
	}
}