package frEngine.animateControler.uvControler
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.BezierVo;

	public class VoffsetControler extends UvOffsetControlerBase
	{
		public function VoffsetControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.VoffsetControler;
		}
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return targetMesh.materialPrams.uvOffsetBase.y;
		}
		protected override function setTargetProperty(value:*):void
		{
			uvOffsetValue[1]=Number(value);
		}
		
		protected override function uvOffsetChangeHander(e:Event):void
		{
			changeBaseValue(null,targetMesh.materialPrams.uvOffsetBase.y);
			
		}
	}
}