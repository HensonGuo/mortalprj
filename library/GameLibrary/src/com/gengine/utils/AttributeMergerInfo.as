/**
 
 * @date	2013-12-17 下午7:18:24
 
 *  @author  wuzhangliang
 *
 
 * 
 */	
package  com.gengine.utils
{
	import flash.utils.Dictionary;

	public class AttributeMergerInfo
	{
		/**
		 *json文件名 
		 */		
		public var fileName:String;
		/**
		 *关键字段 （唯一能标记该对象的字段名）
		 */		
		public var attrKeyCode:String="";
		/**
		 *合并方式 
		 */		
		public var mergerType:int;
		
		/**
		 *jsonDifferentKeyName 是key的名字(自己定义)(用于保存配置表数据obj时 其obj[jsonDifferentKeyName]用于保存绑定有 非绑没有的字段 ) 
		 */		
		public var jsonDifferentKeyName:String;
		
		/**
		 * 构建属性合并的对象
		 * @param name 文件名
		 * @param 
		 * 
		 */		
		public function AttributeMergerInfo(name:String,keyCode:String,type:int,differentKeyName:String)
		{
			this.fileName = name;
			this.attrKeyCode = keyCode;
			this.mergerType = type;
			this.jsonDifferentKeyName = differentKeyName;
		}
	}
}