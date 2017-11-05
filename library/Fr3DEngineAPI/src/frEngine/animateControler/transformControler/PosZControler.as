package frEngine.animateControler.transformControler
{
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	
	public class PosZControler extends Modifier
	{
		public function PosZControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.PosZ;
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return obj.z;
		}
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.z=Number(value);
		}
	}
}

