package mortal.game.scene3D.display3d.text3d.dynamicText3d
{
	public class Text3DInfo
	{
		public var offsetY:int;
		public var width:int;
		public var height:int;
		public var targetBigImg:Text3DBigImg;
		public function Text3DInfo($offsetY:uint,$width:uint,$height:uint,$targetBigImg:Text3DBigImg)
		{
			offsetY=$offsetY;
			width=$width;
			height=$height;
			targetBigImg=$targetBigImg;
		}
	}
}