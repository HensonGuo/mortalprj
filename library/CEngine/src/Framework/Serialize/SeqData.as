package Framework.Serialize
{
	import flash.utils.ByteArray;
	
	public class SeqData
	{
		public function SeqData( numElements : int , minSize : int )
		{
			this.numElements = numElements ;
			this.minSize = minSize ;
		}
		public var numElements : int;
		public var minSize : int;
		public var previous : SeqData ;
	}
}