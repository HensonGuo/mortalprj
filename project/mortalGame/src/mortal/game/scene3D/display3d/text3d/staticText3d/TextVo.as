package mortal.game.scene3D.display3d.text3d.staticText3d
{
	public class TextVo
	{
		public var u:Number;
		public var v:Number;
		public var offsetX:Number;
		public var width:uint;
		public var height:uint;
		public static const su:Number=1/24;
		public static const sv:Number=1/10;
		public static const sw:Number=512/24;
		public static const sh:Number=256/10;
		public function TextVo($u:uint,$v:uint,$ox:Number,$w:uint,$h:uint)
		{
			u=$u*su;
			v=$v*sv;
			offsetX=$ox;
			width=$w;
			height=$h;
		}
	}
}