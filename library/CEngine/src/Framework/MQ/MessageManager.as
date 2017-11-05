package Framework.MQ
{
	public class MessageManager
	{
		public function MessageManager()
		{
		}
		
		public function regist( messageBase : IMessageBase ) : void
		{
			_object[ messageBase.getType() ] = messageBase;
		}
		
		public function unRegist( type : int ) : void
		{
			if(_object[type] == undefined){
				return;
			}
			delete _object[type];
		}
		
		public function findMessage( type : int ) : IMessageBase
		{
			if(_object[type] == undefined)
			{
				return null;
			}
			return _object[type];
		}
		
		public function  createMessage( type : int ) : IMessageBase
		{
			if(_object[type] == undefined)
			{
				return null;
			}
			return _object[type].clone();
		}
		
		public static function instance() : MessageManager
		{
			return _instance;
		}
		
		private static var _instance : MessageManager  = new MessageManager();
		private var _object:Object = new Object();
	}
}