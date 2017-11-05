package mortal.common.font
{
	import flash.utils.Dictionary;

	public class FontName
	{
		private var _fontName:String;
		
		public static var dcFontName:Dictionary = new Dictionary();
		
		public function FontName(fontName:String)
		{
			_fontName = fontName;
			dcFontName[fontName] = this;
		}
		
		public static function getFontByName(name:String):FontName
		{
			if(dcFontName.hasOwnProperty(name))
			{
				return dcFontName[name];
			}
			return null;
		}
		
		public function get fontName():String
		{
			return _fontName;
		}

		public function set fontName(value:String):void
		{
			_fontName = value;
		}

		public function getFontSize(size:int):int
		{
			return size;
		}
	}
}