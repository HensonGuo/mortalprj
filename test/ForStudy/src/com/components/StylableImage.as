package com.components
{
	import com.awt.controls.Image;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class StylableImage extends Image
	{
		
		private var border:Shape;
		
		public function StylableImage()
		{
			super();
		}
		
		override protected function onAddedToStage():void
		{
			border = new Shape();
			
			this.addChild(border);
			
			this.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
			
			super.onAddedToStage();
		}
		
		override public function validateSize():void
		{
			if(invalidateSizeFlag)
			{
				border.graphics.clear();
//				border.graphics.beginFill(0,0);
				border.graphics.lineStyle(2,0xFFFFFF);
				border.graphics.drawRect(0,0,this.height,this.width);
//				border.graphics.endFill();
				border.visible = false;
			}
				
			super.validateSize();
		}
		
		private function mouseOverHandler(e:MouseEvent):void
		{
			border.visible = true;
		}
		
		private function mouseOutHandler(e:MouseEvent):void
		{
			border.visible = false;
		}
	}
}