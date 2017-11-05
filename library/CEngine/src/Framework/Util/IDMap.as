package Framework.Util
{
	public class IDMap
	{
		public function IDMap()
		{
			_messagId = 0;
		}
		
		public function insert( v : Object ) : int
		{
			var newId:int = 1;
			for(var i:String in _object){
				if(newId <= int(i)){
					newId = int(i) + 1;
				}
			}
			_messagId = newId;
			_object[_messagId] = v;
			return _messagId;
		}
		
		public function remove( id : int ) : Boolean
		{
			if(_object[id] == undefined){
				return false;
			} 
			delete _object[id];
			return true;
		}
		
		public function findAndRemove( id : int ):Object
		{
			if( _object[id] == undefined ){	
				return null;
			}
			var obj:Object = _object[id];
			delete _object[id];
			return obj;
		}
		
		private var _messagId : int;
		private var _object:Object = new Object();
	}
}