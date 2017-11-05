package Engine.RMI
{
	import Framework.Protocol.CDFProtocol.EncryptProtocol;
	import Framework.Protocol.IProtocol;
	
	public class CommunicatorManager
	{
		private static var instance:CommunicatorManager;
		public static function getInstance():CommunicatorManager
		{
			if(instance == null){
				instance = new CommunicatorManager();
			}	
			return instance;
		}
		
		public function CommunicatorManager()
		{
			if( instance != null )
			{
				throw new Error("singler");
			}
			_communicators = new Array();
		}
		
		/**
		 * to create communicator
		 * */
		public function createCommunicator( 
			url : String , protocol : IProtocol = null ) : Communicator
		{
			var communicatorTemp : Communicator;
			for ( var i : int = 0 ; i < _communicators.length ; i ++ )
			{
				communicatorTemp = _communicators[i] as Communicator;
				if( communicatorTemp.url == url )
				{
					return communicatorTemp;
				}
			}
			
			communicatorTemp = new Communicator( protocol );
			communicatorTemp.url = url;
			_communicators.push( communicatorTemp );			
			return communicatorTemp;
		}
		
		/**
		 * to remove communicator
		 * */
		public function removeCommunicator( 
			url : String ) : Boolean
		{
			var communicatorTemp : Communicator;
			var i : int;
			var find : Boolean = false;
			for ( i = 0 ; i < _communicators.length ; i ++ )
			{
				communicatorTemp = _communicators[i] as Communicator;
				if( communicatorTemp.url == url )
				{
					_communicators.splice( i , 1 );
					find = true;
				}
			}
			return false;
		}
		
		private var _communicators : Array;
}
}