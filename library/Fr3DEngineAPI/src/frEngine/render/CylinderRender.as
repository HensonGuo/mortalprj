package frEngine.render
{
	import flash.display3D.Context3DBlendFactor;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.system.Device3D;
	
	import frEngine.primitives.FrAnimCylinder;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.vertexFilters.CylinderAnimaterVertexFilter;
	import frEngine.shader.registType.FcParam;

	public class CylinderRender extends DefaultRender
	{
		private var depthColorRegister:FcParam;
		public static const instance:CylinderRender=new CylinderRender();
		private var cylinderVertexFilter:CylinderAnimaterVertexFilter;
		private var cylinderDepthMaterial:ShaderBase;
		private var cylinderParams:Vector.<Number>;
		public function CylinderRender()
		{
			super();
			cylinderVertexFilter=new CylinderAnimaterVertexFilter(10,10,10)
			cylinderDepthMaterial=new ShaderBase("CylinderRender",cylinderVertexFilter,new ColorFilter(0,0,0,1),null);
			cylinderParams=cylinderVertexFilter.params;
			
		}

		public override function drawDepth(mesh:Mesh3D,objectColor:Number=0,$alpha:Number=1):void
		{
			var _local3:Surface3D;
			_local3=mesh.getSurface(0);
			if (_local3 && _local3.visible)
			{
				var toReBuiderProgram:Boolean=cylinderDepthMaterial.toReBuiderProgram;
				
				var hasPrepared:Boolean =cylinderDepthMaterial.hasPrepared(mesh, _local3)
					
				if (!depthColorRegister || toReBuiderProgram)
				{
					depthColorRegister = cylinderDepthMaterial.getParam(FilterName.COLOR, false);
				}
				
				if(!hasPrepared)
				{
					return;
				}
				
				
				var cylinderMesh:FrAnimCylinder=FrAnimCylinder(mesh);
				cylinderParams[0]=cylinderMesh.topR;
				cylinderParams[1]=cylinderMesh.height;
				cylinderParams[2]=cylinderMesh.bottomR;
				
				Device3D.global.copyFrom(mesh.world);
				Device3D.objectsDrawn++;
				
				
				
				if(depthColorRegister)
				{
					depthColorRegister.value[0]=objectColor;
					depthColorRegister.value[3]=$alpha;
					var materialPrams:MaterialParams=mesh.materialPrams;
					cylinderDepthMaterial.draw(mesh, _local3,materialPrams.depthCompare,materialPrams.cullFace,true,Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA , _local3.firstIndex, _local3.numTriangles);
					
				}
				
			};
			
		}
	}
}