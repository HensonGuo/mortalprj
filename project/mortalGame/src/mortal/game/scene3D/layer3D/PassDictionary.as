package mortal.game.scene3D.layer3D
{
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.player.item.PassPlayer;

	public class PassDictionary extends Dictionary
	{
		private var _map:Dictionary;
		
		public function PassDictionary( weakKeys:Boolean = false )
		{
			_map = new Dictionary( weakKeys );
		}
		
		public function addPass( passID:int , pass:PassPlayer ):PassPlayer
		{
			_map[ passID ] = pass;
			return pass;
		}
		
		public function removePass( passid:int ):PassPlayer
		{
			var pass:PassPlayer = _map[ passid ];
			if( pass )
			{
				delete _map[ passid ];
			}
			return pass;
		}
		
		public function getPass( passid:int ):PassPlayer
		{
			return _map[ passid ];
		}
		
		public function hasPass( passid:int ):Boolean
		{
			return passid in _map;
		}
		
		public function removeAll():void
		{
			for each( var pass:PassPlayer in _map  )
			{
				if( pass )
				{
					pass.dispose();
				}
			}
			_map = new Dictionary();
		}
	}
}
