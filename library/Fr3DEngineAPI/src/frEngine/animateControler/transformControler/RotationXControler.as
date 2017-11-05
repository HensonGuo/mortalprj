package frEngine.animateControler.transformControler
{
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	
	public class RotationXControler extends Modifier
	{
		
		public function RotationXControler()
		{
			super();
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return obj.rotationX;
		}
		public override function get type():int
		{
			return AnimateControlerType.RotationX;
		}
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.rotationX=Number(value);
		}

		/*public override function editKeyFrame(track:Object,keyIndex:int,attribute:String,value:Object):Object
		{
			return super.editKeyFrame(track,keyIndex,attribute,Number(value)*angleToPad);
		}*/
	}
}

