package frEngine.animateControler.cylinderControler
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.primitives.FrAnimCylinder;
	
	public class CylinderHControler extends CylinderControlerBase
	{
		public function CylinderHControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.CylinderHControler;
		}
		
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			var cylinder:FrAnimCylinder=FrAnimCylinder(obj);
			return cylinder.height;
		}
		protected override function reBuilderHander(e:Event):void
		{
			var curValue:Number=params[1];
			super.reBuilderHander(e);
			params[1]=curValue;
		}
		protected override function setTargetProperty(value:*):void
		{
			params[1]=Number(value);
		}
	}
}

