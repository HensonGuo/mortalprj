package frEngine.animateControler.cylinderControler
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.primitives.FrAnimCylinder;
	
	public class CylinderDownRadiusControler extends CylinderControlerBase
	{
		public function CylinderDownRadiusControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.CylinderDownRadiusControler;
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			var cylinder:FrAnimCylinder=FrAnimCylinder(obj);
			return cylinder.bottomR;
		}
		protected override function reBuilderHander(e:Event):void
		{
			var curValue:Number=params[2];
			super.reBuilderHander(e);
			params[2]=curValue;
		}

		protected override function setTargetProperty(value:*):void
		{
			params[2]=Number(value);
		}
	}
}

