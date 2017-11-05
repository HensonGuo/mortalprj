package frEngine.animateControler.cylinderControler
{
	import flash.events.Event;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.VcParam;
	
	public class CylinderControlerBase extends MeshAnimateBase
	{
		
		protected var params:Vector.<Number>=new Vector.<Number>(4,true);
		
		public function CylinderControlerBase()
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
			if(normalMaterial.vertexFilterType==FilterType.CylinderVertexFilter)
			{
				reBuilderHander(null);
			}
			
			normalMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
		}
		protected function reBuilderHander(e:Event):void
		{
			var register:VcParam=normalMaterial.getParam("{params}",true);
			if(register)
			{
				params=register.value;
			}
			
		}
		public override function dispose():void
		{
			normalMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
			var hasup:Boolean=targetMesh.hasControler(AnimateControlerType.CylinderUpRadiusControler);
			var hasdown:Boolean=targetMesh.hasControler(AnimateControlerType.CylinderDownRadiusControler)
			if(hasup && hasdown)
			{
				
			}else
			{
				var filter:FilterBase=targetMesh.materialPrams.getFilterByTypeId(FilterType.CylinderVertexFilter);
				targetMesh.materialPrams.removeFilte(filter);
			}
			
			super.dispose();
		}
		
	}
}

