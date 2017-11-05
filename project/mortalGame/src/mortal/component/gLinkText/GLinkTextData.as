/**
 * 2014-2-24
 * @author chenriji
 **/
package mortal.component.gLinkText
{
	public class GLinkTextData
	{
		public static const Point:String = "point";
		public static const boss:String = "boss";
		public static const npc:String = "npc";
		
		///////////////////////////////////////////////////////////////////////////////////////////////////
		public var htmlText:String;
		
		public var mapId:int;
		public var x:int;
		public var y:int;
		public var type:String;
		public var value1:int;
		public var value2:int; // 对于npc来说， 是距离
		public var needBoot:Boolean = true;
		public var curNum:int;
		public var totalNum:int;
		/**
		 * 可以是TaskInfo，随便其他的 
		 */		
		public var data:Object;
		
		// 完成任务的条件
		public var isLevelEnouth:Boolean = false;
		
		public function GLinkTextData()
		{
		}
		
		public function get isShowNum():Boolean
		{
			return totalNum > 0;
		}
		
		public function parse(str:String):void
		{
			var arr:Array = str.split(GLinkTextConst.targetSpliter);
			this.mapId = int(arr[0]);
			this.x = int(arr[1]);
			this.y = int(arr[2]);
			this.type = String(arr[3]);
			this.value1 = int(arr[4]);
			if(arr.length >= 5)
			{
				this.value2 = int(arr[5]);
			}
		}
	}
}