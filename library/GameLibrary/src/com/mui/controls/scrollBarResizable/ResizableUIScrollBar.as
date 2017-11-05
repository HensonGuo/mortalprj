/**
 *为了修改滚动条宽度而加 
 */
package com.mui.controls.scrollBarResizable
{
	
	import fl.controls.UIScrollBar;
	import fl.core.InvalidationType;
	
	public class ResizableUIScrollBar extends UIScrollBar{
		
		public function ResizableUIScrollBar()
		{
			// constructor code
			super();
		}
		
		override protected function draw():void 
		{				
			//从UIScrollBar类拷贝过来的代码
			if (isInvalid(InvalidationType.DATA))
			{
				updateScrollTargetProperties();
			}
			//从ScrollBar类拷贝过来的代码
			if (isInvalid(InvalidationType.SIZE))
			{
				var h:Number = super.height;
				downArrow.setSize(_width,_width);
				upArrow.setSize(_width,_width);
				downArrow.move(0,  Math.max(upArrow.height, h-downArrow.height));
				track.move(0,_width);
				track.setSize(_width, Math.max(0, h-(downArrow.height + upArrow.height)));
				thumb.setSize(_width,thumb.height);
				updateThumb();
			}
			if (isInvalid(InvalidationType.STYLES,InvalidationType.STATE))
			{
				setStyles();
			}
			// Call drawNow on nested components to get around problems with nested render events:
			downArrow.drawNow();
			upArrow.drawNow();
			track.drawNow();
			thumb.drawNow();
			validate();
		}

	}
	
}
