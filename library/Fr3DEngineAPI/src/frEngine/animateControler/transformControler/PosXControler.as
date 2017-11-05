package frEngine.animateControler.transformControler
{

	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.keyframe.AnimateControlerType;

	public class PosXControler extends Modifier
	{
		
		public function PosXControler()
		{
			super();
		}
		
		public override function get type():int
		{
			return AnimateControlerType.PosX;
		}
		
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return obj.x;
		}
		
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.x=Number(value);
		}
	}
}

