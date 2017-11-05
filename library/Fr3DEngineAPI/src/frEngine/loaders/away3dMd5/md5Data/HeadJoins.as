package frEngine.loaders.away3dMd5.md5Data
{

	public class HeadJoins
	{
		public var magic:uint;
		public var version:uint;
		public var joinsList:Vector.<HierarchyData>;
		public var numAnimatedComponents:uint;
		public var tracksList:Vector.<TrackInfo> = new Vector.<TrackInfo>();
		public var isCompress:Boolean;
		public function get tracksNum():uint
		{

			return tracksList.length;

		}

		public function get numJoints():uint
		{
			return joinsList.length;
		}
	}
}


