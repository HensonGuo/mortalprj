package frEngine.loaders.away3dMd5.md5Data
{
	public class TrackInfo
	{
		public var name:String;
		public var frameNum:uint;
		public var fightOnframe:uint;
		public var exportSkipFrame:uint;
		public function TrackInfo($name:String,$frameNum:uint,$fightOnframe:uint,$exportSkipFrame:uint)
		{
			name=$name;
			frameNum=$frameNum;
			fightOnframe=$fightOnframe;
			exportSkipFrame=$exportSkipFrame;
		}
	}
}