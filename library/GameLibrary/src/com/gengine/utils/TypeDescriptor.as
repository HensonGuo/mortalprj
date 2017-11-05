package com.gengine.utils
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 使用 flash.utils.describeType 获取类详细信息并缓存 
	 * @author jianglang
	 * 
	 */	
	public class TypeDescriptor
	{
		
		/**
		* 缓存已经反射过了的对象
		*/
		private static var typeCache:Object = new Object();

		
		
		/**
		 * 获取类信息
		 * @param target 要获取的目标对象
		 * @return TypeDescriptorEntry 实例
		 * 
		 */
		public static function describeType (target:*):TypeDescription {

			var className:String = getQualifiedClassName(target);			

			/**
			* 检查缓存中是否已经有目标对象项, 如果有就返回缓存中的内容
			*/
			if (className in typeCache)
				return typeCache[className];
				
			
			/**
			* 暂存属性列表
			*/
			var propertyNames:Array = [];
			

			/**
			* 获取类信息, 如果传入的是实例则获取实例类型的类信息
			*/
			var typeInfo:XML = flash.utils.describeType(target is Class ? target : getDefinitionByName(className) as Class);
			
			
			/**
			* 获取类中所有的属性和访问器
			*/
			var properties:XMLList = typeInfo.factory..accessor.(@access != "writeonly") + typeInfo..variable;

			
			/**
			* 遍历并存放到 propertyNames 中
			*/
			for each (var propertyInfo:XML in properties)
				propertyNames.push(propertyInfo.@name);
				
			
			/**
			* 创建 TypeDescriptorEntry 的实例并把 propertyNames 等属性丢进去
			*/
			var entry:TypeDescription = new TypeDescription();
			entry.name = className;
			entry.properties = propertyNames;
			entry.typeInfo = typeInfo;
			
			
			/**
			* 缓存到 typeCache 中以便下次从缓存中读取
			*/
			typeCache[className] = entry;
			
			return entry;
		}
 	
		/**
		 * 静态类无须实例化
		 * @return 
		 * 
		 */
		public function TypeDescriptor () { }
	}
}