package frEngine.animateControler.uvControler
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.shader.registType.FcParam;

	public class UvOffsetControlerBase extends MeshAnimateBase
	{

		protected var uvOffsetValue:Vector.<Number>=Vector.<Number>([0,0,0,0]);
		
		public function UvOffsetControlerBase()
		{
			super();
		}
		public override function get type():int
		{
			throw new Error("请覆盖type方法！");
			return -1;
		}
		protected override function setMaterialHander(e:Event):void
		{
			super.setMaterialHander(e);
			
			targetMesh.materialPrams.uvOffsetAminUse=true;
			
			reBuilderHander(null);
		
			
			normalMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
		}
		public override function set targetObject3d(value:Pivot3D):void
		{
			if(targetMesh)
			{
				targetMesh.materialPrams.removeEventListener(Engine3dEventName.UVOFFSET_CHANGE,uvOffsetChangeHander);
			}
			super.targetObject3d=value;
			if(targetMesh)
			{
				targetMesh.materialPrams.addEventListener(Engine3dEventName.UVOFFSET_CHANGE,uvOffsetChangeHander);
			}
		}
		protected function uvOffsetChangeHander(e:Event):void
		{
			
		}
		private function reBuilderHander(e:Event):void
		{
			var register:FcParam=normalMaterial.getParam("{UVoffset}",false);
			if(register)
			{
				register.value=uvOffsetValue;
			}
			
		}
		public override function dispose():void
		{
			normalMaterial && normalMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
			var hasu:Boolean=targetMesh.hasControler(AnimateControlerType.VoffsetControler);
			var hasv:Boolean=targetMesh.hasControler(AnimateControlerType.UoffsetControler)
			if(hasu && hasv)
			{
				
			}else
			{
				targetMesh.materialPrams.uvOffsetAminUse=false;
			}
			super.dispose();
		}

	}
}