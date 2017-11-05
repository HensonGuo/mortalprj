package mortal.component.textBox
{
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.containers.GBox;
	
	import fl.core.InvalidationType;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	
	public class GTextBox extends GBox
	{
		public function GTextBox()
		{
			super();
		}
		
		private var _dataProvider:Array=[];
		private var _dataProviderChange:Boolean = false;
		public function set dataProvider(value:Array):void
		{
			if(_dataProvider == value)
				return;
			
			_dataProvider = value;
			_dataProviderChange = true;
			
			invalidate(InvalidationType.ALL);
		}
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		private var _selectedIndex:int = 0;
		private var _selectedChange:Boolean = false;
		public function set selectedIndex(value:int):void
		{
			if( (_selectedIndex != value||value==0) && _selectedIndex!=-1)
			{
				if( numChildren>_selectedIndex && getChildAt(_selectedIndex))
				{
					var textItem:GTextBoxItem = (getChildAt(_selectedIndex) as GTextBoxItem);
					textItem.mouseEnabled = true;
					textItem.removeSelectedSkin();
					if(_normalTextformat!=null)
					{
						textItem.textformat = _normalTextformat;
					}
				}
				
				_selectedIndex = value;
				_selectedChange = true;
				checkSelected();
				
				invalidate();
			}
		}
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		private function checkSelected():void
		{
			var textItem:GTextBoxItem;
			for(var i:int=0; i<numChildren; i++)
			{
				textItem = getChildAt(i) as GTextBoxItem;
				if(selectedIndex==i)
				{
					textItem.mouseEnabled = false;
					textItem.addSelectedSkin();
					if(_textformat!=null)
					{
						textItem.textformat = _textformat;
					}
					dispatchEvent(new DataEvent(EventName.GTextBoxSelectedChange, textItem.data));
				}
				else
				{
					if(!textItem.mouseEnabled)
					{
						textItem.mouseEnabled = true;
						if(_normalTextformat!=null)
						{
							textItem.textformat = _normalTextformat;
							textItem.removeSelectedSkin();
						}
					}
				}
			}
		}
		
		private var _textWidth:int = 100;
		public function set textWidth(value:int):void
		{
			_textWidth = value;
		}
		public function get textWidth():int
		{
			return _textWidth;
		}
		
		private var _textHeight:int = 20;
		public function set textHeight(value:int):void
		{
			_textHeight = value;
		}
		public function get textHeight():int
		{
			return _textHeight;
		}
		
		private var _textformat:TextFormat;
		public function set textformat(value:TextFormat):void
		{
			if(value==_textformat)
			{
				return;
			}
			_textformat = value;
		}
		
		private var _normalTextformat:TextFormat;
		public function set normalTextformat(value:TextFormat):void
		{
			if(value==_normalTextformat)
			{
				return;
			}
			_normalTextformat = value;
		}
		
		protected var alltextItem:Vector.<GTextBoxItem> = new Vector.<GTextBoxItem>;
		override protected function updateDisplayList():void
		{
			if(_dataProviderChange)
			{
				dispose();
				
				var textItem:GTextBoxItem;
				for each(var o:* in dataProvider)
				{
					textItem = ObjectPool.getObject(GTextBoxItem,textWidth,textHeight);
					textItem.data = o;
					if(_normalTextformat!=null)
					{
						textItem.textformat = _normalTextformat;
					}
					textItem.addEventListener(MouseEvent.CLICK, onTextBoxItemClickHandler);
					addChild(textItem);
					alltextItem.push(textItem);
				}
				checkSelected();
				_dataProviderChange = false;
			}
			if(_selectedChange)
			{
				_selectedChange = false;
				checkSelected();
			}
			super.updateDisplayList();
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			var textItem:GTextBoxItem;
			while(numChildren > 0)
			{
				textItem = (getChildAt(0) as GTextBoxItem);
				textItem.removeEventListener(MouseEvent.CLICK, onTextBoxItemClickHandler);
				removeChild(textItem);
				ObjectPool.disposeObject(textItem,GTextBoxItem);
			}
			this.height = 0;
			_selectedIndex = 0;
			alltextItem = new Vector.<GTextBoxItem>;
		}
		
		private function onTextBoxItemClickHandler(e:MouseEvent):void
		{
			var textItem:GTextBoxItem= e.target as GTextBoxItem;
			var index:int = getChildIndex(textItem);
			
			if(_selectedIndex!=index)
			{
				textItem.mouseEnabled = false;
				textItem.addSelectedSkin();
				if(_textformat!=null)
				{
					textItem.textformat = _textformat;
				}
				dispatchEvent(new DataEvent(EventName.GTextBoxSelectedChange, textItem.data));
				
				textItem = (getChildAt(_selectedIndex) as GTextBoxItem);
				textItem.mouseEnabled = true;
				textItem.removeSelectedSkin();
				if(_normalTextformat!=null)
				{
					textItem.textformat = _normalTextformat;
				}
				_selectedIndex = index;
			}
		}
		
	}
}