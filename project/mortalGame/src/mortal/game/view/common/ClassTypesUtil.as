/**
 * @date 2013-1-25 下午10:00:36
 * @author chenriji
 */
package mortal.game.view.common
{
	public class ClassTypesUtil
	{
		public function ClassTypesUtil()
		{
		}
		
		/**
		 * 两个数组的值是否相同
		 */
		public static function isArrayTheSameValue(arr1:Array, arr2:Array):Boolean
		{
			if(arr1 == null && arr2 == null)
			{
				return true;
			}
			if(arr1 == null || arr2 == null)
			{
				return false;
			}
			if(arr1.length != arr2.length)
			{
				return false;
			}
			if(arr1.length == 0 && arr2.length == 0)
			{
				return true;
			}
			for(var i:int = 0; i < arr1.length; i++)
			{
				if(arr1[i] != arr2[i])
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * 获取某一位的二进制值, bitIndex = 0表示第一位
		 */
		public static function getBitValue(value:int, bitIndex:int):int
		{
			if(bitIndex < 0)
			{
				return 0;
			}
			var temp:int = 0x0001<<bitIndex;
			return (value&temp)>>bitIndex;
		}
		
		/**
		 * 获得设置某一位的值的结果,  bitIndex = 0表示第一位
		 */
		public static function getSetBitValueResult(source:int, bitIndex:int, bitValue:int):int
		{
			if(bitIndex < 0)
			{
				return source;
			}
			var tmp:int = (bitValue<<bitIndex);
			var t1:int = (~(1 << bitIndex)) ;
			source = (source & t1);
			return (source | tmp);
		}
		
		/**
		 * 获取二进制位值为1的最高位的位置， 0代表没有1, 1代表第一位 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function getHighestBitPlace(value:int):int
		{
			var res:int = 31;
			while(res > 0)
			{
				if(((0x0001<<(res - 1))&value) > 0)
				{
					return res;
				}
				res--;
			}
			return 0;
		}
		
		/**
		 * 复制值， 将data的每一个字段的值复制到target（结构）中对应的公共属性 
		 * @param target 目标结构
		 * @param data 原数据
		 * 
		 */		
		public static function copyValue(target:Object, data:Object):void
		{
			for(var key:Object in data)
			{
				target[key] = data[key];
			}
		}
	}
}