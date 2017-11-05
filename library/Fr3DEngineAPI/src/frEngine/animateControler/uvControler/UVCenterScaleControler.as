package frEngine.animateControler.uvControler
{
	import flash.events.Event;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.fragmentFilters.UvCenterScaleFilter;
	import frEngine.shader.registType.FcParam;
	
	public class UVCenterScaleControler extends MeshAnimateBase
	{
		public var params:Vector.<Number>=Vector.<Number>([0.5,0.5,1,-1]);
		public function UVCenterScaleControler()
		{
			super();
		}
		
		public override function get type():int
		{
			return AnimateControlerType.UVCenterScaleController;
		}
		
		protected override function setMaterialHander(e:Event):void
		{
			super.setMaterialHander(e);
			
			var filter:FilterBase = targetMesh.materialPrams.getFilterByTypeId(FilterType.UVCenterScale);
			if(!filter)
			{
				targetMesh.materialPrams.addFilte(new UvCenterScaleFilter());
			}
			reBuilderHander(null);
			
			normalMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
		}
		private function reBuilderHander(e:Event):void
		{
			var register:FcParam=normalMaterial.getParam("{scaleSize}", false);
			if(register)
			{
				register.value=params;
			}
			
		}
		
		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return 0;
		}

		protected override function setTargetProperty(value:*):void
		{
			params[2] = value; // 缩放大小
		}

		public override function dispose():void
		{
			normalMaterial && normalMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuilderHander);
			var filter:FilterBase = targetMesh.materialPrams.getFilterByTypeId(FilterType.UVCenterScale);
			if(filter)
			{
				targetMesh.materialPrams.removeFilte(filter,true);
			}
			super.dispose();
		}
	}
}

