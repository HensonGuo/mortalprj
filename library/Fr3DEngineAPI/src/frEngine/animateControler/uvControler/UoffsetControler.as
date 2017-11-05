package frEngine.animateControler.uvControler
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.BezierVo;

	public class UoffsetControler extends UvOffsetControlerBase
	{
		public function UoffsetControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.UoffsetControler;
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return targetMesh.materialPrams.uvOffsetBase.x;
		}
		protected override function setTargetProperty(value:*):void
		{
			uvOffsetValue[0]=Number(value);

		}
		
		protected override function uvOffsetChangeHander(e:Event):void
		{
			changeBaseValue(null,targetMesh.materialPrams.uvOffsetBase.x);
			
		}
		
	}
}