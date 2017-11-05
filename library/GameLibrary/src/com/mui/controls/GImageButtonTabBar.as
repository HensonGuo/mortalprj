package com.mui.controls
{
	import com.mui.core.IFrUI;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.Button;
	
	import flash.events.MouseEvent;

	public class GImageButtonTabBar extends GTabBar
	{
		public function GImageButtonTabBar()
		{
			super();
			buttonWidth = 66;
			buttonHeight = 65;
		}
		
		override protected function updateDisplayList():void
		{
			if(_dataProviderChange)
			{
				reset();
				
				for each(var o:Object in dataProvider)
				{
					var btn:GLoadingButton = UICompomentPool.getUICompoment(GLoadingButton);
					btn.name = o.name;
					btn.label = "";
					btn.width = buttonWidth;
					btn.height = buttonHeight;
					btn.isDisableOverSkin = true;
					if(o.styleName)
					{
						btn.styleName = o.styleName;
					}
					allButtons.push(btn);
					btn.configEventListener(MouseEvent.CLICK,btnClickHandler,false,0,true);
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
		
		override protected function checkSelected():void
		{
			super.checkSelected();
			
			dispatchEvent(new MuiEvent(MuiEvent.GTABBAR_SELECTED_CHANGE,_selectedIndex));
		}
		
		public function getSelectedButton():Button
		{
			var btn:Button;
			for(var i:int=0; i<allButtons.length; i++)
			{
				btn = getChildAt(i) as Button;
				
				if(selectedIndex == i)
				{
					break;
				}
			}
			return btn;
		}
		
	}
}