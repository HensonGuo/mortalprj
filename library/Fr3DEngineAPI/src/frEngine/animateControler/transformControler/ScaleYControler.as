package frEngine.animateControler.transformControler
{
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	
	public class ScaleYControler extends Modifier
	{
		
		public function ScaleYControler()
		{
			super();
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return obj.scaleY;
		}
		public override function get type():int
		{
			return AnimateControlerType.ScaleY;
		}
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.scaleY=Number(value);
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
				_offsetValue=value.scaleY;
			}else
			{
				if(this.targetObject3d!=null)
				{
					targetObject3d.scaleY=_offsetValue;
				}
			}
			super.targetObject3d=value;
		}*/
	}
}

