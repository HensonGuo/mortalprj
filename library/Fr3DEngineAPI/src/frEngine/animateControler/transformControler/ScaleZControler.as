package frEngine.animateControler.transformControler
{
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	
	public class ScaleZControler extends Modifier
	{
		
		public function ScaleZControler()
		{
			super();
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return obj.scaleZ;
		}
		public override function get type():int
		{
			return AnimateControlerType.ScaleZ;
		}
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.scaleZ=Number(value);
		}
		protected override function calculateFrameValue(tframe:int):void
		{
			super.calculateFrameValue(tframe);
			if(_cache[tframe]==0)
			{
				_cache[tframe]=0.0001;
			}
		}
		/*public override function set targetObject3d(value:Pivot3D):void
		{
			if(value)
			{
				_offsetValue=value.scaleZ;
			}else
			{
				if(this.targetObject3d!=null)
				{
					targetObject3d.scaleZ=_offsetValue;
				}
			}
			super.targetObject3d=value;
		}*/
	}
}

