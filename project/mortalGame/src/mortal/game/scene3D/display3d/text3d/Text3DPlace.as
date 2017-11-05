package mortal.game.scene3D.display3d.text3d
{
	public class Text3DPlace
	{
		public var targetVector:Vector.<Number>;
		public var placeId:uint;
		public var id:uint=0;
		public function Text3DPlace($targetVector:Vector.<Number>,$placeId:uint,$id:uint)
		{
			targetVector=$targetVector;
			placeId=$placeId;
			id=$id;
		}
		
	}
}