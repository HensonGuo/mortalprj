package frEngine.render
{
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Matrix3D;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.system.Device3D;
	
	import frEngine.core.FrSurface3D;
	import frEngine.core.mesh.NormalMesh3D;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.vertexFilters.Md5EdgeFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;
	import frEngine.shader.registType.FcParam;

	public class DefaultRender implements IRender
	{
		public static const instance:DefaultRender=new DefaultRender();
		private var depthColorRegister:FcParam;
		protected static var depthRenderMaterial:ShaderBase;
		private var edgeMaterial:ShaderBase;
		private var edgeMaterialParams:MaterialParams;
		private var _matrix3d:Matrix3D=Device3D.global;
		
		public function DefaultRender()
		{
			
			edgeMaterialParams=new MaterialParams();
			edgeMaterialParams.addFilte(new Md5EdgeFilter());
			edgeMaterial = new ShaderBase("edgeMaterial", new TransformFilter(), new ColorFilter(1, 1, 1, 1),edgeMaterialParams);
			
			depthRenderMaterial=new ShaderBase("depthRenderMaterial",new TransformFilter(),new ColorFilter(0,0,0,0),null);

		}
		public function completeDraw(mesh:Mesh3D):void
		{
			var _local3:Surface3D;
			var len:int=mesh.getSurfacesLen();
			for (var i:int=0;i<len;i++)
			{
				_local3=mesh.getSurface(i) as FrSurface3D;
				if (_local3.visible && mesh.material)
				{
					mesh.material.drawLeftNums(mesh,_local3);
				};
			};
		}
		public function drawEdge(mesh:Mesh3D,edgeColor:Number=0xffffff):void
		{
			var _local3:Surface3D;
			_local3=mesh.getSurface(0);
			
			if (_local3 && _local3.visible)
			{
				
				if(!edgeMaterial.hasPrepared(mesh, _local3))
				{
					return;
				}
				
				_matrix3d.copyFrom(mesh.world);
				var materialPrams:MaterialParams=mesh.materialPrams;
				edgeMaterial.draw(mesh, _local3,materialPrams.depthCompare,materialPrams.cullFace,false,materialPrams.sourceFactor,materialPrams.destFactor,_local3.firstIndex, _local3.numTriangles);
				Device3D.objectsDrawn++;
			}
		}
		
		public function drawDepth(mesh:Mesh3D,objectColor:Number=0, $alpha:Number=1):void
		{
			var _local3:Surface3D;
			_matrix3d.copyFrom(mesh.world);
			Device3D.objectsDrawn++;
			_local3=mesh.getSurface(0);
			if (_local3 && _local3.visible)
			{
				var toReBuiderProgram:Boolean=depthRenderMaterial.toReBuiderProgram;
				
				var _hasPrepared:Boolean =depthRenderMaterial.hasPrepared(mesh, _local3);
				
				if (!depthColorRegister || toReBuiderProgram)
				{
					depthColorRegister = depthRenderMaterial.getParam(FilterName.COLOR, false);
				}
				
				if(!_hasPrepared)
				{
					return;
				}
				
				depthColorRegister.value[0]=objectColor;
				depthColorRegister.value[3]=$alpha;
				var materialPrams:MaterialParams=mesh.materialPrams;
				depthRenderMaterial.draw(mesh, _local3,materialPrams.depthCompare,materialPrams.cullFace,true,Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA,_local3.firstIndex, _local3.numTriangles);
				
			}
			
		}
		
		public function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{

			var _local3:Surface3D;
			//Device3D.global.copyFrom(mesh.world);
			//mesh.scaleX=mesh.scaleY=mesh.scaleZ=0.5;
			_matrix3d.copyFrom(mesh.world);
			
			Device3D.objectsDrawn++;
			var len:int=mesh.getSurfacesLen();
			var _material:ShaderBase= (material || mesh.material);
			if(!_material || len==0)
			{
				return;
			}
			
			_local3=mesh.getSurface(0);
			
			if(!_material.hasPrepared(mesh, _local3))
			{
				return;
			}
			var materialPrams:MaterialParams=mesh.materialPrams;
			_material.draw(mesh, _local3,materialPrams.depthCompare ,materialPrams.cullFace,materialPrams.depthWrite,materialPrams.sourceFactor,materialPrams.destFactor, _local3.firstIndex, _local3.numTriangles);
		
			
			
		}
	}
}