package com.mui.controls
{	
	import com.gengine.core.IDispose;
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.Button;
	import fl.core.InvalidationType;
	
	import flash.events.MouseEvent;
	
	public class GTabBar extends GBox
	{
		
		public function GTabBar()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
		}
		
		/**
		 * 
		 * 数据源
		 * 必须的属性：
		 * name：按钮名称
		 * label：按钮显示标签
		 * 
		 * */
		protected var _dataProvider:Array;
		protected var _dataProviderChange:Boolean = false;
		public function set dataProvider(value:Array):void
		{
			if(_dataProvider == value)
				return;
			
			_dataProvider = value;
			_dataProviderChange = true;
			
			invalidate(InvalidationType.ALL);
		}
		
		override public function invalidate(arg0:String="all", arg1:Boolean=true):void
		{
			_dataProviderChange = true;
			super.invalidate(arg0,arg1);
		}
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		protected var _selectedIndex:int = 0;
		protected var _selectedChange:Boolean = false;
		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex != value)
			{
				_selectedIndex = value;
				_selectedChange = true;
				
				invalidate();
			}
		}
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		/**
		 * 取得当前选中按钮的dataProvider数据 
		 * @return Object
		 * 
		 */		
		public function get selectedItem():Object
		{
			if(_dataProvider && _dataProvider.length > _selectedIndex)
			{
				return _dataProvider[_selectedIndex];
			}
			return null;
		}
		
		/**
		 * 设置按钮样式
		 * */
		protected var _buttonStyleName:String = "TabButton";
		public function set buttonStyleName(value:String):void
		{
			_buttonStyleName = value;
			
			invalidate(InvalidationType.STYLES);
		}
		public function get buttonStyleName():String
		{
			return _buttonStyleName;
		}
		
		/**
		 * tabBar显示的每个按钮的宽
		 * */
		protected var _buttonWidth:int = 67;
		public function set buttonWidth(value:int):void
		{
			_buttonWidth = value;
		}
		public function get buttonWidth():int
		{
			return _buttonWidth;
		}
		
		/**
		 * tabBar显示的每个按钮的高
		 * */
		protected var _buttonHeight:int = 22;
		public function set buttonHeight(value:int):void
		{
			_buttonHeight = value;
		}
		public function get buttonHeight():int
		{
			return _buttonHeight;
		}
		
		/**
		 * 
		 * 设置按钮显示标题滤镜
		 * 
		 * */
		protected var _buttonFilters:Array;
		public function set buttonFilters(value:Array):void
		{
			if(_buttonFilters == value)
				return;
			
			_buttonFilters = value;
		}
		public function get buttonFilters():Array
		{
			return _buttonFilters;
		}
		
		private var _labelName:String = "";
		/**
		 * 设置显示的label读哪个属性 
		 * @param value
		 * 
		 */		
		public function set labelName(value:String):void
		{
			_labelName = value;
		}
		
		public function getButtonAt(index:int):Button
		{
			if(index < allButtons.length)
			{
				return allButtons[index];
			}
			else
			{
				return null;
			}
		}
		
		protected var allButtons:Vector.<Button> = new Vector.<Button>;
		override protected function updateDisplayList():void
		{
			if(_dataProviderChange)
			{
				reset();
				
				for each(var o:Object in dataProvider)
				{
					var btn:GButton = UICompomentPool.getUICompoment(GButton);
					btn.name = o.name;
					btn.width = buttonWidth;
					btn.height = buttonHeight;
					btn.styleName = buttonStyleName;
					btn.textField.multiline = true;
					
					if(_labelName != "" && _labelName != null)
					{
						btn.label = o[_labelName];
					}
					else
					{
						btn.label = o.label;
					}
					allButtons.push(btn);
					btn.configEventListener(MouseEvent.CLICK,btnClickHandler,false,0,true);
					if(_buttonFilters)
					{
						btn.textField.filters = _buttonFilters;
					}
					this.addChild(btn);
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
		
		protected function checkSelected():void
		{
			var btn:Button;
			for(var i:int=0; i<numChildren; i++)
			{
				btn = getChildAt(i) as Button;
				
				if(selectedIndex == i)
				{
					btn.enabled = false;
				}
				else
				{
					if(!btn.enabled)
						btn.enabled = true;
				}
				
				btn.drawNow();
			}
		}
		
		override protected function updateSize():void
		{
			super.updateSize();
			
			this.width = direction == GBoxDirection.HORIZONTAL ? numChildren*(buttonWidth+horizontalGap) : buttonWidth;
			this.height = direction == GBoxDirection.HORIZONTAL ? buttonHeight : numChildren*(buttonHeight+verticalGap);
		}
		
		protected function btnClickHandler(e:MouseEvent):void
		{
			(e.currentTarget as Button).enabled = false;
			
			var index:int = this.getChildIndex(e.currentTarget as Button);
			if(_selectedIndex != index && _selectedIndex >= 0 && _selectedIndex < numChildren)
			{
				(this.getChildAt(_selectedIndex) as Button).enabled = true;
			}
			_selectedIndex = index;
			dispatchEvent(new MuiEvent(MuiEvent.GTABBAR_SELECTED_CHANGE,index));
		}
		
		protected function reset():void
		{
			var btn:Button;
			for(var i:int=0; i<allButtons.length; i++)
			{
				btn = allButtons[i];
				btn.textField.filters = [];
				btn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				if(btn is IDispose)
				{
					(btn as IDispose).dispose();
				}
			}
			allButtons = new Vector.<Button>;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			reset();
			_dataProvider = [];
			_dataProviderChange = false;
			buttonFilters = [];
			buttonStyleName = "TabButton";
			_selectedIndex = 0;
			super.dispose(isReuse);
		}
	}
}