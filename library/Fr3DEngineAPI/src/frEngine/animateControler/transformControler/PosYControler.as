package frEngine.animateControler.transformControler
{
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	
	public class PosYControler extends Modifier
	{
		
		public function PosYControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.PosY;
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return obj.y;
		}
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.y=Number(value);
		}
	
	}
}

