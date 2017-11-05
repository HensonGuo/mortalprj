package frEngine.render
{
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Matrix3D;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.system.Device3D;
	
	import frEngine.core.FrSurface3D;
	import frEngine.primitives.FrPlane;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.registType.FcParam;

	public class FrPlaneRender extends DefaultRender
	{
		private var depthColorRegister:FcParam;
		public static const instance:FrPlaneRender=new FrPlaneRender();
		private var _matrix3d:Matrix3D=Device3D.global;
		public function FrPlaneRender()
		{
			super();
		}
		public override function drawDepth(mesh:Mesh3D,objectColor:Number=0,$alpha:Number=1):void
		{
			
			var _local3:Surface3D;
			_matrix3d.copyFrom(mesh.world);
			_matrix3d.prepend(FrPlane(mesh).offsetMatrix);
			Device3D.objectsDrawn++;
			
			_local3=mesh.getSurface(0);
			if (_local3 && _local3.visible)
			{
				var toReBuiderProgram:Boolean=depthRenderMaterial.toReBuiderProgram;
				var hasPrepared:Boolean =depthRenderMaterial.hasPrepared(mesh, _local3);
				if (!depthColorRegister || toReBuiderProgram)
				{
					depthColorRegister = depthRenderMaterial.getParam(FilterName.COLOR, false);
				}
				if(!hasPrepared)
				{
					return;
				}
				
				depthColorRegister.value[0]=objectColor;
				depthColorRegister.value[3]=$alpha;
				
				var materialPrams:MaterialParams=mesh.materialPrams;
				depthRenderMaterial.draw(mesh, _local3,materialPrams.depthCompare,materialPrams.cullFace,true,Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA,_local3.firstIndex, _local3.numTriangles);
				
			}
			
		}
		
		public override function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{
			var len:int=mesh.getSurfacesLen();
			var _material:ShaderBase= (material || mesh.material);
			if(!_material || len==0)
			{
				return;
			}
			
			var plane:FrPlane=FrPlane(mesh);
			var _local3:Surface3D;
			_matrix3d.copyFrom(mesh.world);
			_matrix3d.prepend(plane.offsetMatrix);
			Device3D.objectsDrawn++;
			_local3=mesh.getSurface(0);
			if(!_material.hasPrepared(mesh, _local3))
			{
				return;
			}
			var materialPrams:MaterialParams=mesh.materialPrams;
			_material.draw(mesh, _local3,materialPrams.depthCompare,materialPrams.cullFace,materialPrams.depthWrite,materialPrams.sourceFactor,materialPrams.destFactor, _local3.firstIndex, _local3.numTriangles);
		}
	}
}