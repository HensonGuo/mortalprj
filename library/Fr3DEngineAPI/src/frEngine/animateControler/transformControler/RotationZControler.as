package frEngine.animateControler.transformControler
{
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	
	public class RotationZControler extends Modifier
	{
		
		public function RotationZControler()
		{
			super();
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return obj.rotationZ;
		}
		public override function get type():int
		{
			return AnimateControlerType.RotationZ;
		}
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.rotationZ=Number(value);
		}
		/*public override function set targetObject3d(value:Pivot3D):void
		{
			if(value)
			{
				_offsetValue=value.rotationZ;
			}else
			{
				if(this.targetObject3d!=null)
				{
					targetObject3d.rotationZ=_offsetValue;
				}
			}
			super.targetObject3d=value;
		}*/
		/*public override function editKeyFrame(track:Object,keyIndex:int,attribute:String,value:Object):Object
		{
			return super.editKeyFrame(track,keyIndex,attribute,Number(value)*angleToPad);
		}*/
	}
}

