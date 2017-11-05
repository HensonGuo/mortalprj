package com.mui.utils
{
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;

	public class SkinUtil
	{
		public function SkinUtil()
		{
		}
		
		public static function setStyle( component:UIComponent , skillObject:Object ):void
		{
			for ( var key:String in skillObject  )
			{
				component.setStyle(key,skillObject[key]);
			}
		}
	}
}