package mortal.game.view.pack
{	
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GButton;
	import com.mui.events.DragEvent;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.Button;
	import fl.core.InvalidationType;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class CanDropTabBar extends GBox
	{
		private var _checkDrag:Function;
		private var _timer:Timer = new Timer(1500,1);
		private var _dragBtn:GButton;
		public function CanDropTabBar()
		{
			super();
		}
		
		/**
		 * 是否可交换位置 
		 * @param value
		 * 
		 */		
		public function set checkDrag(value:Function):void
		{
			_checkDrag = value;
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
		private var _dataProvider:Array;
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
		 * 设置按钮样式
		 * */
		private var _buttonStyleName:String = "TabButton";
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
		private var _buttonWidth:int = 49;
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
		private var _buttonHeight:int = 25;
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
		private var _buttonFilters:Array;
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
		
		override protected function updateDisplayList():void
		{
			if(_dataProviderChange)
			{
				reset();
				
				for each(var o:Object in dataProvider)
				{
					var btn:GButton = UICompomentPool.getUICompoment(CanDropButton);
					btn.name = o.name;
					btn.label = o.label;
					btn.width = buttonWidth;
					btn.height = buttonHeight;
					btn.styleName = buttonStyleName;
					btn.addEventListener(MouseEvent.CLICK,btnClickHandler,false,0,true);
					btn.addEventListener(DragEvent.Event_Be_Drag_over,DragOverHandler);
					//--------------add by huanchunhao 
					btn.addEventListener(DragEvent.Event_Be_Drag_out,DragOutHandler);
					//--------------
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
			this.mouseChildren = true;
			this.mouseEnabled = true;
			this.configEventListener(DragEvent.Event_Be_Drag_over,DragOverHandler);
			super.updateDisplayList();
		}
		
		private function checkSelected():void
		{
			var btn:GButton;
			for(var i:int=0; i<numChildren; i++)
			{
				btn = getChildAt(i) as GButton;
				
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
		
		private function btnClickHandler(e:MouseEvent = null):void
		{
			SelectByButton(e.target as GButton);
		}
		
		private function SelectByButton(gbutton:Button):void
		{
			gbutton.enabled = false;
			
			var index:int = this.getChildIndex(gbutton);
			if(_selectedIndex != index)
			{
				(this.getChildAt(_selectedIndex) as GButton).enabled = true;
				_selectedIndex = index;
				
				dispatchEvent(new MuiEvent(MuiEvent.GTABBAR_SELECTED_CHANGE));
			}
		}
		
		private function DragOverHandler(e:DragEvent):void
		{
			if( e.target is GButton && _checkDrag!=null && _checkDrag(e.dragItem))
			{
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE,time_Complete);
				_dragBtn = e.target as GButton;
				
			}
		}
		
		private function time_Complete(e:TimerEvent):void
		{
			SelectByButton(_dragBtn);
		}
		
		private function DragOutHandler(e:DragEvent):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,time_Complete);
			_timer.reset();
		}
		
		protected function reset():void
		{
			var btn:GButton;
			this.selectedIndex = 0;
			for(var i:int=numChildren - 1;i>=0; i--)
			{
				if(getChildAt(i) as GButton)
				{
					btn = getChildAt(i) as GButton;
				}
				btn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				btn.removeEventListener(DragEvent.Event_Be_Drag_over,DragOverHandler);
				btn.removeEventListener(DragEvent.Event_Be_Drag_out,DragOutHandler);
				btn.dispose();
			}
		}
		
		override public function dispose(isResume:Boolean = true):void
		{
			reset();
			_dataProvider = [];
			_dataProviderChange = false;
			super.dispose(isResume);
		}
	}
}