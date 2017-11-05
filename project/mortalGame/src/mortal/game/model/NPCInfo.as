package mortal.game.model
{
	import Message.DB.Tables.TNpc;
	import Message.Public.SNpc;
	
	import mortal.game.resource.tableConfig.NPCConfig;
	
	public class NPCInfo
	{
		private var _snpc:SNpc;  //场景NPC 数据
		
		private var _tnpc:TNpc;	// NPC 详细数据
		
		private var _minShowLevel:int; //显示在小地图上的最小世界等级
		private var _maxShowLevel:int = int.MAX_VALUE; //显示在小地图上的最大世界等级
		
		private var _taskStatus:int = -1;// 任务状态 参考ETaskStatus.as
		
		public var isAddStage:Boolean = true;
		
		public var isClick:Boolean = true;
		
		public function NPCInfo()
		{
			
		}

		public function get tnpc():TNpc
		{
			return _tnpc;
		}

		public function get snpc():SNpc
		{
			return _snpc;
		}

		public function set snpc(value:SNpc):void
		{
			_taskStatus = -1;
			_snpc = value;
			_tnpc = NPCConfig.instance.getInfoByCode(_snpc.npcId); 
			
//			if(value.showInMapLevel && value.showInMapLevel != "")
//			{
//				_minShowLevel = parseInt(value.showInMapLevel.split("#")[0]);
//				_maxShowLevel = parseInt(value.showInMapLevel.split("#")[1]);
//			}
		}
		
		public function set taskStatus(status:int):void
		{
			_taskStatus = status;
		}
		
		public function get taskStatus():int
		{
			return _taskStatus;
		}
		
		public function get headImgsrc():String
		{
//			return "headid_" + _tnpc.headId + ".swf";
			return "";
		}
		
		public function get headImgCode():String
		{
//			return "headid_" + _tnpc.headId;
			return "";
		}
		
		public function get minShowLevel():int
		{
			return _minShowLevel;
		}
		
		public function get maxShowLevel():int
		{
			return _maxShowLevel;
		}
		
		/**
		 * 获取宽度 
		 * @return 
		 * 
		 */		
		public function get width():Number
		{
			return 80.0 * _tnpc.modelScale/100;
		}
		
		/**
		 * 获取高度 
		 * @return 
		 * 
		 */	
		public function get height():Number
		{
			return 110.0 * _tnpc.modelScale/100;
		}
		
	}
}
