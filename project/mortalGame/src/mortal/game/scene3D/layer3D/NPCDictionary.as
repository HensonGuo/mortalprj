package mortal.game.scene3D.layer3D
{
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.player.entity.NPCPlayer;

	public class NPCDictionary 
	{
	
		private var _map:Dictionary;
		
		public function NPCDictionary( weakKeys:Boolean = false )
		{
			_map = new Dictionary( weakKeys );
		}
		
		public function addNpc( npcID:int , npc:NPCPlayer ):NPCPlayer
		{
			_map[ npcID ] = npc;
			return npc;
		}
		
		public function removeNpc( npcid:int ):NPCPlayer
		{
			var npc:NPCPlayer = _map[ npcid ];
			if( npc )
			{
				delete _map[ npcid ];
			}
			return npc;
		}
		
		public function removeAllNpc():void
		{
			_map = new Dictionary();
		}
		/**
		 * 根据id返回实体 
		 * @param npcid
		 * @return 
		 */
		public function getNpc( npcid:int ):NPCPlayer
		{
			return _map[ npcid ];
		}
		
		public function get map():Dictionary
		{
			return _map;
		}
		 
		
		public function removeAll():void
		{
			var npc:NPCPlayer;
			for each( npc in _map )
			{
				if( npc )
				{
					npc.dispose();
				}
			}
			removeAllNpc();
		}
	}
}
