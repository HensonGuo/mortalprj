package mortal.game.view.mount.data
{
	public class MountToolData
	{
		public var name:String;
		
		public var exp:int;
		
		public var level:int;
		
		public var index:int;
		
		public function MountToolData(name:String,obj:Object)
		{
			this.name = name;
			setInfo(obj);
		}
		
		private function setInfo(obj:Object):void
		{
			exp = obj.exp;
			level = obj.tl;
			index = obj.t;
		}
	}
}