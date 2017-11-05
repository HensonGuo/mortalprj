/**
 *为了修改滚动条宽度而加 
 */

package com.mui.controls.scrollBarResizable
{
	
	import fl.controls.ScrollBar;
	import fl.core.InvalidationType;
	
	public class ResizableScrollBar extends ScrollBar
	{
		
		public function ResizableScrollBar() 
		{
			// constructor code
			super();
			
		}
		
		override protected function draw():void 
		{				
			if (isInvalid(InvalidationType.SIZE))
			{
				var h:Number = super.height;
				downArrow.setSize(_width,_width - 2);//上下箭头压扁
				upArrow.setSize(_width,_width - 2);
				downArrow.move(0,  Math.max(upArrow.height, h-downArrow.height));
				track.move(2,_width -2);
				track.setSize(_width - 4, Math.max(0, h-(downArrow.height + upArrow.height)));
				thumb.setSize(_width,thumb.height);
				updateThumb();
			}
			if (isInvalid(InvalidationType.STYLES,InvalidationType.STATE)) {
				setStyles();
			}
			// Call drawNow on nested components to get around problems with nested render events:
			try
			{
				downArrow.drawNow();
				upArrow.drawNow();
				track.drawNow();
				thumb.drawNow();
				validate();
			}
			catch(e:Error){};
		}

	}
	
}
