package mortal.game.resource.info
{
	/**
	 * id:地图Id  
		version:版本  
		//isLoadConfig:是否需要加载地图配置文件  
		hasBossPoint:有BOSS刷新点
		copyid:对应副本ID
		name :地图名称
		des:场景描述
	 * @author jianglang
	 * 
	 */	
	public class GMapInfo
	{
		public var id:int;
		public var name:String;
		public var version:String;
		public var hasBossPoint:Boolean;
		public var copyid:int;
		public var des:String;
		public var mapscene:int;
		public var bgInfo:GMapBgInfo;
		
		private var _desArray:Array;
		
		public function GMapInfo()
		{
			
		}
		
		public function get desArray():Array
		{
			if(!_desArray)
			{
				if(des)
				{
					_desArray = des.split("|");
				}
				else
				{
					return [];
				}
			}
			return _desArray;
		}
	}
}