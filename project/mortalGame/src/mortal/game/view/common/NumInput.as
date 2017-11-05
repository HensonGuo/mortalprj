/**
 * @date 2011-6-7 下午09:57:59
 * @author  hexiaoming
 * 
 */ 
package mortal.game.view.common
{
	import com.gengine.global.Global;
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextInput;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class NumInput extends GSprite
	{
		private var _numTxt:GTextInput;
		
		private var _minNum:int = 1;
		private var _maxNum:int = int.MAX_VALUE;
		private var _currnetNum:int;
		private var _isSubDown:Boolean = false;
		private var _isAddDown:Boolean = false;
		private var _count:int = 0;
		private var _stepNumber:int = 1;//步数
		
		private var _subBtn:GButton;
		private var _addBtn:GButton;
		
		private var _editable:Boolean;
		public function set editable(value:Boolean):void
		{
			_editable = value;
			
			_subBtn.enabled = _editable;
			_numTxt.editable = _editable;
			_addBtn.enabled = _editable;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			_subBtn = UIFactory.gButton("",0,0,18,18,this);
			_subBtn.styleName = "AddBtn";
			_subBtn.configEventListener(MouseEvent.CLICK, onSubBtnClickHandler);
			_subBtn.configEventListener(MouseEvent.MOUSE_DOWN, onSubBtnMouseDownHandler);
			_subBtn.drawNow();
			
			_numTxt = UIFactory.gTextInput(23,0,40,20,this);
			_numTxt.text = "1";
			_numTxt.styleName = "GTextInput";
			_numTxt.configEventListener(Event.CHANGE, onNumChangeHandler);
			_numTxt.drawNow();
			
			_addBtn = UIFactory.gButton("",68,0,18,18,this);
			_addBtn.styleName = "AddBtn";
			_addBtn.configEventListener(MouseEvent.CLICK, onAddBtnClickHandler);
			_addBtn.configEventListener(MouseEvent.MOUSE_DOWN, onAddBtnMouseDownHandler);
			_addBtn.drawNow();
			
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			_subBtn.removeEventListener(MouseEvent.CLICK, onSubBtnClickHandler);
			_subBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onSubBtnMouseDownHandler);
			
			_numTxt.removeEventListener(Event.CHANGE, onNumChangeHandler);
			
			_addBtn.removeEventListener(MouseEvent.CLICK, onAddBtnClickHandler);
			_addBtn.removeEventListener(MouseEvent.MOUSE_DOWN, onAddBtnMouseDownHandler);
			
			_subBtn.dispose(isReuse);
			_numTxt.dispose(isReuse);
			_addBtn.dispose(isReuse);
			
			_subBtn = null;
			_numTxt = null;
			_addBtn = null;
			
			_minNum = 1;
			_maxNum = int.MAX_VALUE;
			_currnetNum = 0;
			_stepNumber = 1;//步数
			_editable = true;
			onRemoveEnterframe();
			super.disposeImpl(isReuse);
		}
		
		public function get editable():Boolean
		{
			return _editable;
		}
		
		
		public function NumInput()
		{
			init();
		}
		
		private function init():void
		{
			
		}
		
		public function onSubBtnClickHandler(e:MouseEvent):void
		{
			if(_stepNumber == 1)
			{
				--_currnetNum;
			}
			else
			{
				_currnetNum -= _stepNumber;
			}
			setInRange(_currnetNum);
		}
		
		public function onSubBtnMouseDownHandler(e:MouseEvent):void
		{
			_isSubDown = true;
			addEventListener(Event.ENTER_FRAME, onEnterframeHandler);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,onRemoveEnterframe);
		}
		
		public function onNumChangeHandler(e:Event):void
		{
			setInRange(parseInt(_numTxt.text));
		}
		
		private function setInRange(num:int):void
		{
//			num = num > 0?num:1;
			num = num < _maxNum?num:_maxNum;
			num = num < _minNum?_minNum:num;
			_currnetNum = num;
			_numTxt.text = _currnetNum.toString();
			this.dispatchEvent( new Event(Event.CHANGE));
		}
		
		public function onAddBtnClickHandler(e:MouseEvent):void
		{
			if(_stepNumber == 1)
			{
				++_currnetNum;
			}
			else
			{
				_currnetNum += _stepNumber;
			}
			setInRange(_currnetNum);
		}
		
		public function onAddBtnMouseDownHandler(e:MouseEvent):void
		{
			_isAddDown = true;
			addEventListener(Event.ENTER_FRAME, onEnterframeHandler);
			Global.stage.addEventListener(MouseEvent.MOUSE_UP,onRemoveEnterframe);
		}
		
		public function onRemoveEnterframe(e:Event = null):void
		{
			Global.stage.removeEventListener(MouseEvent.MOUSE_UP,onRemoveEnterframe);
			removeEventListener(Event.ENTER_FRAME, onEnterframeHandler);
			_count = 0;
			_isAddDown = false;
			_isSubDown = false;
		}
		
		public function onEnterframeHandler(e:Event):void
		{
			_count++;
			if(_count > 6)
			{
				if(_isAddDown)
				{
//					setInRange(++_currnetNum);
					if(_stepNumber == 1)
					{
						++_currnetNum;
					}
					else
					{
						_currnetNum += _stepNumber;
					}
					setInRange(_currnetNum);
				}
				if(_isSubDown)
				{
					if(_stepNumber == 1)
					{
						--_currnetNum;
					}
					else
					{
						_currnetNum -= _stepNumber;
					}
					setInRange(_currnetNum);
//					setInRange(--_currnetNum);
				}
			}
		}
		
		public function set maxNum(value:int):void
		{
			_maxNum = value;
			_currnetNum = _maxNum;
			_numTxt.text = _currnetNum.toString();
		}
		
		public function get currentNum():int
		{
			return _currnetNum;
		}

		public function set currentNum(value:int):void
		{
			setInRange(value);
		}

		public function get minNum():int
		{
			return _minNum;
		}

		public function set minNum(value:int):void
		{
			_minNum = value;
			_currnetNum = value;
			_numTxt.text = _currnetNum.toString();
		}

		public function set stepNumber(value:int):void
		{
			_stepNumber = (value <= 1)?1:value;
		}
		
		/**
		 * 设置样式，按钮为翻页按钮样式
		 * @param value
		 * 
		 */		
		public function setStyleName(value:String):void
		{
			if(value == "PageButton")
			{
				_addBtn.styleName = "NextPageButton";
				_addBtn.width = 21;
				_addBtn.height = 20;
				_addBtn.drawNow();
				_subBtn.styleName = "PrevPageButton";
				_subBtn.width = 21;
				_subBtn.height = 20;
				_subBtn.drawNow();
			}
		}
		
		/**
		 *设置最大数量 
		 * @param amount
		 * 
		 */		
		public function setMaxNum(amount:int):void
		{
			_maxNum = amount;
		}
		
		override public function set width(value:Number):void
		{
			_numTxt.width = value - _subBtn.width - _addBtn.width - 10;
			onResize();
		}
		
		override public function set height(value:Number):void
		{
			_numTxt.height = value;
			onResize();
		}
		
		public function onResize():void
		{
			_subBtn.y = (_numTxt.height - _subBtn.height)/2;
			
			_addBtn.x = _subBtn.width + _numTxt.width + 10;
			_addBtn.y = (_numTxt.height - _subBtn.height)/2;
		}
	}
}