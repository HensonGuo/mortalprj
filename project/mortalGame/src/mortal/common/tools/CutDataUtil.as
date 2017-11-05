package mortal.common.tools
{
	import flash.utils.Dictionary;
	
	import mortal.game.resource.GameDefConfig;

	public class CutDataUtil
	{
		public function CutDataUtil()
		{
		}
		
		
		/**
		 * 如"a,b#a,b#a,b#..."  返回全部 a / b 的数组
		 * @param str
		 * @param index 0=a位置 ，1=b位置
		 * @return 
		 * 
		 */
		public static function  getStringValue( str:String, index:int ):Array
		{
			if (!str) 
			{
				return [];
			}
			
			var resultArr:Array = [];
			var arr:Array = str.split('#');
			var str:String;
			var sa:Array =[];
			var key:int;
			
			if (index >1) 
			{
				return [];
			}
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				str = arr[i] as String;
				if (str != null && str !="") 
				{
					sa = str.split(",");
					key = int(sa[index]);
					resultArr.push(key);
				}
			}
			return resultArr;
		}
		
		/**
		 *“1,1,1,1,1”  去掉逗号 返回数组
		 * @return 
		 * 
		 */		
		public static function getStringValueWithoutComma(str:String):Array
		{
			if (!str) 
			{
				return [];
			}
			var arr:Array = str.split(',');
			
			for (var i:int = 0; i < arr.length; i++)
			{
				if (arr[i] == "")
				{
					arr.splice(i,1);
				}
			}
			return arr;
		}
		
		/**
		 *“1#3#4#...”去掉逗号 返回数组 
		 * @return 
		 * 
		 */		
		public static function getStringWithoutSharp(str:String):Array
		{
			if (!str) 
			{
				return [];
			}
			
			var arr:Array = str.split('#');
			
			for (var i:int = 0; i < arr.length; i++)
			{
				if (arr[i] == "")
				{
					arr.splice(i,1);
				}
			}
			return arr;
		}
		
		/**
		 *“1#1#1#1#1”  去掉# 返回数组
		 * @return 
		 * 
		 */		
		public static function getStringValueWithoutsharp(str:String):Array
		{
			if (!str) 
			{
				return [];
			}
			var tempArr:Array = [];
			var tempArrII:Array = str.split("#");
			for (var j:int = 0; j < tempArrII.length; j++) 
			{
				if (tempArrII[j] && tempArrII[j] != "") 
				{
					tempArr.push(tempArrII[j]);
				}
			}
			
			return tempArr;
		}
		
		/**
		 *把[1,2,3,4]变成"1#2#3#4#" 
		 * @return 
		 * 
		 */		
		public static function getStringFromArray(arr:Array):String
		{
			if (arr) 
			{
				var str:String ="";
				for (var i:int = 0; i < arr.length; i++) 
				{
					str+= arr[i].toString() + "#";
				}
				return str;
			}
			return "";
		}
		
		
		public static var numReg:RegExp = new RegExp("[0-9]*[1-9][0-9]*","gi");
		/**
		 *传入字符串 阿拉伯数字换汉字 （不允许换行符号在内）
		 * @param str
		 * @return 
		 * 
		 */		
		public static function replaceNum2CHStr(str:String):String
		{
			var result:Object  = numReg.exec(str);
			while(result!=null)
			{
				str = str.replace(result[0],num2ChStr(result[0]));
				result = numReg.exec(str);
			}
			return str;
		}
		
		public static function num2ChStr(str:String):String
		{
			var resultStr:String = "";
			for (var i:int = 0; i < str.length; i++) 
			{
				resultStr += GameDefConfig.instance.getChineseNum(parseInt(str.charAt(i)));
			}
			return resultStr;
		}
		
		/**
		 *把  1,1000#20,50#14,20#..  ==> [{obj[key],obj[value]},{obj[key],obj[value]}...]
		 * @return 
		 * 
		 */		
		public static function getObjKeyValueArr(str:String):Array
		{
			if (!str) 
			{
				return [];
			}
			
			var resultArr:Array = [];
			var arr:Array = str.split('#');
			var str:String;
			var sa:Array =[];
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				str = arr[i] as String;
				if (str != null && str !="") 
				{
					sa = str.split(",");
					resultArr.push({key:int(sa[0]),value:int(sa[1])});
				}
			}
			return resultArr;
		}
		
		/**
		 *把  1,1000#20,50#14,20#..  ==> dict[key] = value;
		 * @return 
		 * 
		 */
		public static function getObjKeyValueDict(str:String):Dictionary
		{
			var dic:Dictionary = new Dictionary();
			if (!str) 
			{
				return dic;
			}
			
			var arr:Array = str.split('#');
			var str:String;
			var sa:Array =[];
			
			for (var i:int = 0; i < arr.length; i++) 
			{
				str = arr[i] as String;
				if (str != null && str !="") 
				{
					sa = str.split(",");
					dic[sa[0]] = int(sa[1]);
				}
			}
			return dic;
		}
		
		
		/**
		 *取数字的个位 
		 * @return 
		 * 
		 */		
		public static function getUnitNum(num:int):int
		{
			return num % 10;
		}
	}
}