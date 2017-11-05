package frEngine.render
{
	import baseEngine.core.Mesh3D;
	import frEngine.core.FrSurface3D;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	
	public class FrQuadRender implements IRender
	{
		public static const instance:FrQuadRender=new FrQuadRender();
		public function FrQuadRender()
		{
		}
		
		public function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{
			
			var matrial:ShaderBase=ShaderBase(((material) || (mesh.material)));
			var surf:FrSurface3D=mesh.getSurface(0);
			if(!matrial.hasPrepared(mesh,surf))
			{
				return;
			}
			var materialPrams:MaterialParams=mesh.materialPrams;
			matrial.draw(mesh,surf,materialPrams.depthCompare,materialPrams.cullFace,materialPrams.depthWrite,materialPrams.sourceFactor,materialPrams.destFactor);
			
		}
		
		public function drawDepth(mesh:Mesh3D, objectColor:Number=0, $alpha:Number=1):void
		{
		}
		
		public function drawEdge(mesh:Mesh3D, edgeColor:Number=0xffffff):void
		{
		}
		
		public function completeDraw(mesh:Mesh3D):void
		{
		}
	}
}