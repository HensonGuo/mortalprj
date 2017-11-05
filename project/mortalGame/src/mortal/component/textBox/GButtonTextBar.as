package mortal.component.textBox
{
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GButton;
	import com.mui.controls.GTabBar;
	import com.mui.events.MuiEvent;
	
	import fl.controls.Button;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.component.gconst.FilterConst;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	
	public class GButtonTextBar extends GTabBar
	{
		private var _textBox:GTextBox;
		public function GButtonTextBar()
		{
			super();
		}
		
		private var _textDataProvider:Array=[];
		public function set textDataProvider(value:Array):void
		{
			_textDataProvider = value;
		}
		
		public function get textDataProvider():Array
		{
			return _textDataProvider;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			resetBarPosition(_selectedIndex);
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			super.btnClickHandler(e);
			resetBarPosition(_selectedIndex);
		}
		
		private function onTextBoxSelectedHandler(e:DataEvent):void
		{
			dispatchEvent(new DataEvent(EventName.GButtonTextBarChange,e.data));
		}
		
		public function resetBarPosition(index:int):void
		{
			var textArray:Array = textDataProvider[index];
			if(textArray==null || (textArray&&textArray.length<=0))
			{
				return;
			}
			
			if(_textBox==null)
			{
				_textBox = new GTextBox();
				_textBox.x = 5;
				_textBox.textWidth = this.buttonWidth;
				_textBox.textHeight = 38;
				_textBox.verticalGap = 3;
				_textBox.direction = GBoxDirection.VERTICAL;
				var selectedTf:GTextFormat = new GTextFormat("",12,0xffff00);
				_textBox.textformat = selectedTf;
				var normalTf:GTextFormat = new GTextFormat("",12,0xB1efff,null,null,null,null,null,TextFormatAlign.CENTER);
				_textBox.normalTextformat = normalTf;
				_textBox.addEventListener(EventName.GTextBoxSelectedChange, onTextBoxSelectedHandler);
			}
			if(_textBox && _textBox.dataProvider != textArray)
			{
				_textBox.dataProvider = textArray;
				_textBox.selectedIndex = 0;
				_textBox.drawNow();
			}
			
			if(_textBox && _textBox.parent)
			{
				removeChild(_textBox);
			}
			
			var i:int = 0;
			var len:int = 0;
			const numChildren:int = this.numChildren;
			var o:DisplayObject;
			if (this.direction == GBoxDirection.VERTICAL)
			{
				for (i = 0; i < numChildren; i++)
				{
					o = this.getChildAt(i);
					o.y = len + verticalGap;
					if( i==_selectedIndex)
					{
						_textBox.y = o.y + o.height + 5;
						len = _textBox.y + _textBox.height + 5;
					}
					else
					{
						len = o.y + o.height;
					}
					if(!o.filters)
					{
						o.filters = [FilterConst.glowFilter]
					}
				}
			}
			addChild(_textBox);
		}
		
		public function setTextBoxSelectedIndex(value:int):void
		{
			if(_textBox)
			{
				_textBox.selectedIndex = value;
			}
		}
		
		override protected function reset():void
		{
			var displayObj:DisplayObject;
			while(numChildren > 0)
			{
				displayObj = getChildAt(0);
				if(displayObj is GButton)
				{
					(displayObj as GButton).removeEventListener(MouseEvent.CLICK,btnClickHandler);
				}
				this.removeChild(displayObj);
			}
			allButtons = new Vector.<Button>;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
		}
		
	}
}