package com.mui.serialization.css
{
	import mx.utils.StringUtil;
	
	public class CssDeserializer
	{
		public function CssDeserializer()
		{
		}
		
		public static function separateIntoTags(param1:String, param2:String = "{", param3:String = "}") : Array
		{
			var _loc_6:int;
			var _loc_7:Array;
			var _loc_4:Array = [];
			var _loc_5:* = param1.split(param2);
			_loc_4.push(_loc_5[0]);
			_loc_6 = 1;
			while (_loc_6 < _loc_5.length)
			{
				// label
				_loc_7 = _loc_5[_loc_6].toString().split(param3);
				if (_loc_7.length == 2)
				{
					_loc_4.push(_loc_7[0]);
					_loc_4.push(_loc_7[1]);
				}
				else
				{
					//com.awtLogger.Error(CssDeserializer, "separateIntoTags compiler error at [" + _loc_5[_loc_6] + "]");
				}// end else if
				_loc_6++;
			}// end while
			return _loc_4;
		}
		
		public static function analyseToObject(code:String):Object
		{
			//source="default.swf", symbol="N_Panel_backgroundSkin"
			var obj:Object = new Object();
			var arr:Array = code.split(",");
			var i:int;
			var reg:RegExp = new RegExp("\"", "/g");
			
			for (i = 0; i < arr.length; i ++)
			{
				if (arr[i].toString().length == 0)
					continue;
				var arr1:Array = arr[i].toString().split("=");
				obj[StringUtil.trim(arr1[0])] = arr1[1].toString().replace(reg, "");
			}
			return obj;
		}
	}
}