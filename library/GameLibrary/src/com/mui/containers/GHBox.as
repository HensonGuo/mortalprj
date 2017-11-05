package com.mui.containers
{
	import com.mui.containers.globalVariable.GBoxDirection;

	public class GHBox extends GBox
	{
		public function GHBox()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			this.direction = GBoxDirection.HORIZONTAL;
		}
	}
}