package frEngine.event
{
	import flash.events.Event;

	public class ParamsEvent extends Event
	{
		public var params:Array;
		public function ParamsEvent(type:String,$params:Array,bubbles:Boolean=false)
		{
			params=$params;
			super(type,bubbles,false);
		}
		public override function clone():Event
		{
			return new ParamsEvent(this.type,this.params,this.bubbles);
		}
	}
}