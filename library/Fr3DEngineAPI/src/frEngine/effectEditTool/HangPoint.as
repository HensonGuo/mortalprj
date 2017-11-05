package frEngine.effectEditTool
{
	import flash.geom.Matrix3D;
	
	import baseEngine.core.Pivot3D;
	
	public class HangPoint extends Pivot3D
	{
		public var toUpdate:Boolean=false;
		public function HangPoint(_arg1:String)
		{
			super(_arg1);
		}
		public override function set offsetTransform(value:Matrix3D):void
		{
			toUpdate=true;
		}
		
	}
}