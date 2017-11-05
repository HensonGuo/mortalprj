package frEngine.animateControler.transformControler
{
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	
	public class RotationYControler extends Modifier
	{
		
		public function RotationYControler()
		{
			super();
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return obj.rotationY;
		}
		public override function get type():int
		{
			return AnimateControlerType.RotationY;
		}
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.rotationY=Number(value);
		}
		/*public override function set targetObject3d(value:Pivot3D):void
		{
			if(value)
			{
				_offsetValue=value.rotationY;
			}else
			{
				if(this.targetObject3d!=null)
				{
					targetObject3d.rotationY=_offsetValue;
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

