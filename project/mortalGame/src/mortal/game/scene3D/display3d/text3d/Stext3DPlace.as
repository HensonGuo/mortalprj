package mortal.game.scene3D.display3d.text3d
{
	import mortal.game.scene3D.display3d.text3d.staticText3d.VcList;

	public class Stext3DPlace
	{
		public var targetVector:VcList;
		public var placeId:uint;
		public var isUsed:Boolean=false;
		public function Stext3DPlace($targetVcList:VcList,$placeId:uint)
		{
			targetVector=$targetVcList;
			placeId=$placeId;
		}
	}
}

