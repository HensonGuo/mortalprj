/**
 * @heartspeak
 * 2014-1-6 
 */   	
package mortal.game.scene3D.layer3D
{
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.player.item.JumpPlayer;
	import mortal.game.scene3D.player.item.PassPlayer;
	
	public class JumpDictionary extends Dictionary
	{
		private var _map:Dictionary;
		
		public function JumpDictionary( weakKeys:Boolean = false )
		{
			_map = new Dictionary( weakKeys );
		}
		
		public function addJump( x:int,y:int , jump:JumpPlayer ):JumpPlayer
		{
			_map[ x*1000 +y ] = jump;
			return jump;
		}
		
		public function removeJump( x:int,y:int ):JumpPlayer
		{
			var jumpId:int = x*1000 +y;
			var jump:JumpPlayer = _map[ jumpId ];
			if( jump )
			{
				delete _map[ jumpId ];
			}
			return jump;
		}
		
		public function getJump( x:int,y:int ):JumpPlayer
		{
			return _map[ x*1000 +y ];
		}
		
		public function hasJump( x:int,y:int ):Boolean
		{
			return (x*1000 +y) in _map;
		}
		
		public function removeAll():void
		{
			for each( var jump:JumpPlayer in _map  )
			{
				if( jump )
				{
					jump.dispose();
				}
			}
			_map = new Dictionary();
		}
	}
}
