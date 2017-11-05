package mortal.game.view.chat.data
{
	import mortal.game.resource.GameMapConfig;
	import mortal.game.resource.info.GMapInfo;

	public class ChatShowPoint
	{
		public function ChatShowPoint($mapId:int,$x:int,$y:int)
		{
			mapId = $mapId;
			x = $x;
			y = $y;
		}
		
		public var mapId:int = 0;
		public var x:int = 0;
		public var y:int = 0;
		
		/**
		 * mapNameString 
		 * 
		 */		
		public function mapNameString():String
		{
			var mapInfo:GMapInfo = GameMapConfig.instance.getMapInfo(mapId);
			if(mapInfo)
			{
				return mapInfo.name + "[" + x + "," + y + "]";
			}
			else
			{
				return "";
			}
		}
		
		/**
		 * mapIdString 
		 * 
		 */		
		public function mapIdString():String
		{
			return "[" + mapId + "," + x + "," + y + "]";
		}
	}
}