package mortal.common.cd
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class KeyBoardCd
	{
		private static var _keyMap:Dictionary= new Dictionary();
		
		public function KeyBoardCd()
		{
			
		}
		
		public static function isKeyDown( key:int ):Boolean
		{
			var num:int = _keyMap[ key ];
			if( getTimer() > num )
			{
				return true;
			}
			return false;
		}
		
		public static function keyUp( key:int ):void
		{
			_keyMap[ key ] = getTimer()+200;
		}
	}
}