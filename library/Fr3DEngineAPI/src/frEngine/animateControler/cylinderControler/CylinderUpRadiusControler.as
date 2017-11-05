package frEngine.animateControler.cylinderControler
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.primitives.FrAnimCylinder;
	
	public class CylinderUpRadiusControler extends CylinderControlerBase
	{
		public function CylinderUpRadiusControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.CylinderUpRadiusControler;
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			var cylinder:FrAnimCylinder=FrAnimCylinder(obj);
			return cylinder.topR;
		}
		protected override function reBuilderHander(e:Event):void
		{
			var curValue:Number=params[0];
			super.reBuilderHander(e);
			params[0]=curValue;
		}
		protected override function setTargetProperty(value:*):void
		{
			params[0]=Number(value);
		}
	}
}

