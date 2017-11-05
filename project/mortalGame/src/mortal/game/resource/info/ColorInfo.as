package mortal.game.resource.info
{
	public class ColorInfo
	{
		public var type:String;
		public var id:String;
		
		private var _color:String = "#ffffff";
		
		private var _colorText:String;
		
		//private var css

		public function get colorText():String
		{
			return _colorText;
		}

		public function set colorText(value:String):void
		{
			_colorText = value;
		}

		public function get color():String
		{
			return _color;
		}
		public function set color(value:String):void
		{
			_color = value;
		}
		//数字颜色
		public function get intColor():uint
		{
			return parseInt(_color.substr(1), 16);
		}		
		
		public function set intColor(value:uint):void
		{
			_color = "#" + value.toString(16);
		}
		
		public function ColorInfo()
		{
		}
	}
}