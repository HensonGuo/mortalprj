package mortal.component.fontTabBar
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	import com.gengine.utils.HTMLUtil;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GButton;
	import com.mui.controls.GTabBar;
	import com.mui.events.MuiEvent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	public class FontTabBar extends GTabBar
	{
		protected var _btnTips:Array;
		protected var _tipsChange:Boolean;
		
		protected var _disableWidth:int;
		protected var _disableHeight:int;
		
		public function FontTabBar()
		{
			super();
		}
		
		public function set disableWidth(value:int):void
		{
			_disableWidth = value;
		}
		
		public function get disableWidth():int
		{
			return _disableWidth;
		}
		
		public function set disableHeight(value:int):void
		{
			_disableHeight = value;
		}
		
		public function get disableHeight():int
		{
			return _disableHeight;
		}
		
		protected function updateBtnSize(btn:FontBtn,disable:Boolean):void
		{
			if(disable)
			{
				btn.updateBtnSize(buttonWidth,buttonHeight);
			}
			else
			{
				var changeW:int = disableWidth == 0 ? buttonWidth : disableWidth;
				var changeH:int = disableHeight == 0 ? buttonHeight : disableHeight;
				btn.updateBtnSize(changeW,changeH);
			}
		}
		
		/**
		 * 鼠标移上 
		 * @param event
		 * 
		 */
		private function onBtnMouseOverHandler(event:MouseEvent):void
		{
			var btn:FontBtn = event.target as FontBtn;
			updateBtnSize(btn,false);
			btn.addEventListener(MouseEvent.MOUSE_OUT,onBtnMouseOutHandler);
		}
		
		/**
		 * 鼠标移出 
		 * @param event
		 * 
		 */
		private function onBtnMouseOutHandler(event:MouseEvent):void
		{
			var btn:FontBtn = event.target as FontBtn;
			if(btn.enabled)
			{
				updateBtnSize(btn,true);
			}
			btn.removeEventListener(MouseEvent.MOUSE_OUT,onBtnMouseOutHandler);
		}
			
		override protected function resetPosition():void
		{
			var i:int, len:int = 0;
			const numChildren:int = this.numChildren;
			var o:FontBtn;
			
			if (this.direction == GBoxDirection.VERTICAL)
			{
				for (i = 0; i < numChildren; i++)
				{
					o = this.getChildAt(i) as FontBtn;
					o.x = 0;
					o.y = len + verticalGap;
					len = o.y + o.height;
				}
			}
			else if (this.direction == GBoxDirection.HORIZONTAL)
			{
				for (i = 0; i < numChildren; i++)
				{
					o = this.getChildAt(i) as FontBtn;
					o.x = o.x + len + horizontalGap;
					o.y = o.y;
					len = o.x + buttonWidth - o.btnx;
				}
			}
		}
		
		override protected function updateDisplayList():void
		{
			if(_dataProviderChange)
			{
				reset();
				
				for each(var o:Object in dataProvider)
				{
					var btn:FontBtn = new FontBtn();
					btn.name = o.name;
					btn.imgUrl = o.img;
					
					if(buttonWidth != 0)
					{
						btn.width = buttonWidth;
					}
					
					if(buttonHeight != 0)
					{
						btn.height = buttonHeight;
					}
					
					btn.styleName = buttonStyleName;
					allButtons.push(btn);
					btn.addEventListener(MouseEvent.CLICK,btnClickHandler,false,0,true);
					btn.addEventListener(MouseEvent.MOUSE_OVER,onBtnMouseOverHandler);
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

			if(_tipsChange && _btnTips != null && _btnTips.length != 0)
			{
				_tipsChange = false;
				var index:int;
				var length:int = allButtons.length;
				var gbtn:FontBtn;
				while(index < length)
				{
					gbtn = getButtonAt(index) as FontBtn;
					gbtn.toolTipData = HTMLUtil.addColor(_btnTips[index],"#00ff00");
					index++;
				}
			}
		}
		
		override protected function checkSelected():void
		{
			var btn:FontBtn;
			for(var i:int=0; i<numChildren; i++)
			{
				btn = getChildAt(i) as FontBtn;
				
				if(selectedIndex == i)
				{
					btn.enabled = false;
				}
				else
				{
					if(!btn.enabled)
					{
						btn.enabled = true;
					}
				}
				
				updateBtnSize(btn,btn.enabled);
				btn.drawNow();
			}
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			var curBtn:FontBtn = e.target as FontBtn;
			curBtn.enabled = false;
			updateBtnSize(curBtn,curBtn.enabled);
			
			var index:int = this.getChildIndex(curBtn);
			if(_selectedIndex != index && _selectedIndex >= 0 && _selectedIndex < numChildren)
			{
				var selectBtn:FontBtn = this.getChildAt(_selectedIndex) as FontBtn;
				selectBtn.enabled = true;
				updateBtnSize(selectBtn,selectBtn.enabled);
			}
			_selectedIndex = index;
			dispatchEvent(new MuiEvent(MuiEvent.GTABBAR_SELECTED_CHANGE,index));
		}
		
		override public function set toolTipData(value:*):void
		{
			if(value != null && value is Array)
			{
				_btnTips = value as Array;
				_tipsChange = true;
			}
			else
			{
				super.toolTipData = value;
			}
		}
	}
}