package mortal.game.utils
{
	import com.fyGame.utils.ValidatorUitl;
	import com.gengine.utils.Arithmetic;

	public class DescUtil
	{
		public function DescUtil()
		{
		}
		
		private static var reg:RegExp = /\{([^{}]*)\}/img;
		private static var reg1:RegExp = /[*+-\/]/img;
		private static var reg2:RegExp = /[^*%+-_\/0-9]/;
		
		/**
		 * 解析字符串 
		 */	
		public static function analyzeStr(str:String,obj:Object):String
		{
			str = str.replace(reg,regHandler);
			return str;
			function regHandler():String
			{
				var str:String = arguments[1];
				var value:String;
//				if( str.search(reg1)>-1 )
//				{
					str = replaceByObjAttri(str,obj);
					var index:int = str.indexOf("!");
					if( index > -1)
					{
						var endStr:String = str.slice(index + 1);
						var baseStr:String = str.slice(0,index);
						return baseStr.replace(new RegExp(endStr,"g"),"");
					}
					else if( str.search(reg2)>-1 )
					{
						return str;
					}
					else
					{
						return Arithmetic.exec(str).toString();
					}
//				}
//				return "{" + str + "}";
			}
		}
		
		/**
		 * 替换属性 
		 */	
		private static function replaceByObjAttri(str:String,obj:Object):String
		{
			str = str.replace(/ /g,"");
			var tempStr:String = str;
			var attriArray:Array = new Array();
			var startPos:int = 0;
			var attriStrBase:String;
			var attriStr:String;
			for(var i:int = 0;i < str.length;i++)
			{
				var char:String = tempStr.charAt(i);
				if(char == "*" || char == "/" || char == "-" || char == "+" || char == "(" || char == ")" || char == "!")
				{
					attriStr = str.substring(startPos,i);
					attriStrBase = attriStr;
					startPos = i + 1;
					if(attriStr.length > 0 && !ValidatorUitl.isNumber(attriStr))
					{
						attriStr = getAttriNoLine(attriStr);
						if(obj.hasOwnProperty(attriStr))
						{
							tempStr = tempStr.replace(new RegExp(attriStrBase,"g"),obj[attriStr].toString());
						}
					}
				}
			}
			
			if(startPos < str.length - 1)
			{
				attriStr = str.substring(startPos);
				attriStrBase = attriStr;
				startPos = i + 1;
				if(attriStr.length > 0 && !ValidatorUitl.isNumber(attriStr))
				{
					attriStr = getAttriNoLine(attriStr);
					if(obj.hasOwnProperty(attriStr))
					{
						tempStr = tempStr.replace(new RegExp(attriStrBase,"g"),obj[attriStr].toString());
					}
				}
			}
			
			return tempStr;
		}
		
		/**
		 * 去掉下划线，后面一个之母大写 
		 * @param attriStr
		 * @return 
		 * 
		 */		
		private static function getAttriNoLine(attriStr:String):String
		{
			for(var i:int = 0 ;i < attriStr.length;i++)
			{
				if(attriStr.charAt(i) == "_" && i != attriStr.length -1)
				{
					var sChar:String = attriStr.charAt(i + 1);
					
					var leftStr:String = attriStr.substring(0,i + 1);
					var rightStr:String = attriStr.substring(i+2);
					
					attriStr = leftStr + sChar.toLocaleUpperCase() + rightStr;
				}
			}
			
			return attriStr.replace(/_/g,"");
		}
	}
	
}

