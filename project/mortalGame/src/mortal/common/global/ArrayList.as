/**
 * 实现动态数组
 * @date	2011-3-19 上午10:15:46
 * @author shiyong
 * 
 */

package mortal.common.global
{
	public class ArrayList
	{
		private var _dynamicArray:Array = [];
		public function ArrayList()
		{
		}
		
		/**
		 *增加 
		 * @param obj
		 * 
		 */		
		public function add(obj:Object):void
		{
			_dynamicArray.push(obj)
		}
		
		/**
		 * 增加集合
		 * @param index 插入的位置
		 * @param obj 暂只支持数组和ArrayList。暂默认插入到最后
		 * @return Boolean
		 * 
		 */		
		public function addAll(index:int,obj:Object):void
		{
			if(obj is Array){
				var tmpArray:Array = obj as Array;
				for(var i:int=0;i<tmpArray.length;i++){
					_dynamicArray.push(tmpArray[i]);
				}
			}
		}
		
		/**
		 * 检查列表中是否包含此元素
		 * @param obj 检查的元素
		 * @return Boolean,包含返回true
		 * 
		 */		
		public function contains(obj:Object):Boolean
		{
			if(_dynamicArray.indexOf(obj) != -1){
				return true;
			}else{
				return false;
			}
		}
		
		/**
		 * 获取指定索引处得元素
		 * @param index 索引
		 * @return 找到在返回，未找到返回null
		 * 
		 */		
		public function get(index:int):Object
		{
			if(index >= 0 && index <= _dynamicArray.length-1){
				return _dynamicArray[index];
			}else{
				return null;
			}
		}
		
		/**
		 *判断列表是否为空 
		 * @return 如果此列表中没有元素，则返回 true 
		 * 
		 */		
		public function isEmpty():Boolean
		{
			if(_dynamicArray.length > 0){
				return false;
			}else{
				return true;
			}
		}
		
		/**
		 *移除索引位置的元素 
		 * @param index 索引
		 * @return 返回移除的元素，此索引不存在返回null
		 * 
		 */		
		public function removeByIndex(index:int):Object
		{
			var rtnObj:Object;
			if(index == 0){
				return _dynamicArray.shift();
			}else if(index == _dynamicArray.length-1){
				return _dynamicArray.pop();
			}else if(index > 0 && index < _dynamicArray.length-1){//元素处于中间，它之后的所有元素往前移一位,删除最后一个元素
				rtnObj = _dynamicArray[index];
				for(var i:int=index;i<_dynamicArray.length-1;i++){
					_dynamicArray[i] = _dynamicArray[i+1];
				}
				_dynamicArray.pop();
				return rtnObj;
			}else{
				return null;
			}
		}
		
		/**
		 *移除此列表中首次出现的指定元素（如果存在）。 
		 * @param obj 需移除的元素
		 * @return 移除成功返回true，其他情况返回false
		 * 
		 */		
		public function remove(obj:Object):void
		{
			if(_dynamicArray.indexOf(obj) != -1){//存在，则删除
				var index:int = _dynamicArray.indexOf(obj);
				removeByIndex(index);
			}
		}
		
		/**
		 * 从列表中移除数组中所有的元素
		 * @param array
		 * @return Boolean
		 * 
		 */			
		public function removeAll(array:Array):void
		{
			for(var i:int=0;i<array.length;i++){
				var index:int = _dynamicArray.indexOf(array[i]);
				if(index != -1){//存在，则删除
					removeByIndex(index);
				}
			}
		}
		
		/**
		 * 返回列表大小
		 * @return int
		 * 
		 */		
		public function size():int
		{
			return _dynamicArray.length;
		}
		
		public function toString():String
		{
			return _dynamicArray.toString();
		}
		
		/**
		 *清空此列表 
		 * 
		 */		
		public function clear():void
		{
			_dynamicArray = [];
		}
	}
}