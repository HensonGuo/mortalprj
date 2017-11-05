package frEngine.render
{
	import flash.geom.Vector3D;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.system.Device3D;
	
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	
	public class DirectionRender extends DefaultRender
	{
		private var pos:Vector3D=new Vector3D(0,0,1000,1);
		public function DirectionRender()
		{
			super();
		}
		
		public override function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{
			var _local3:Surface3D;

			Device3D.worldViewProj.copyFrom(mesh.world);
			Device3D.worldViewProj.append(Device3D.view);
			Device3D.worldViewProj.copyColumnFrom(3, pos);
			Device3D.worldViewProj.append(Device3D.proj);
			Device3D.objectsDrawn++;
			
			_local3=mesh.getSurface(0);
			if (_local3.visible)
			{
				var _material:ShaderBase=mesh.material;
				if(_material)
				{
					if(!_material.hasPrepared(mesh, _local3))
					{
						return;
					}
					var materialPrams:MaterialParams=mesh.materialPrams;
					_material.draw(mesh, _local3,materialPrams.depthCompare,materialPrams.cullFace,materialPrams.depthWrite,materialPrams.sourceFactor,materialPrams.destFactor, _local3.firstIndex, _local3.numTriangles);
				}
				
			}
		}
		
	}
}