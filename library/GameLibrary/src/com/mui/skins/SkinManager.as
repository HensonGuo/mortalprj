package com.mui.skins
{
	import com.gengine.global.Global;
	import com.mui.core.Library;
	
	import fl.core.UIComponent;
	import fl.managers.StyleManager;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class SkinManager
	{
		private static var _skinObject:Dictionary = new Dictionary();
		
		public function SkinManager()
		{
			
		}
		
		public static function addStyleSkin( styleName:String,styleSkin:Object ):void
		{
			_skinObject[styleName] = styleSkin;
		}
		
		public static function getStyleSkin( styleName:String ):Object
		{
			return _skinObject[styleName];
		}
		
		public static function removeStyleSkin( styleName:String ):void
		{
			_skinObject[ styleName ] = null;
			delete _skinObject[ styleName ];
		}
		
		public static function setComponentStyle(component:UIComponent, styleName:String):void
		{
			var skinStyle:Class = _skinObject[styleName] as Class;
			if( skinStyle )
			{
				var style:SkinStyle = new skinStyle() as SkinStyle;
				style.setStyle(component);
			}
		}
	}
}