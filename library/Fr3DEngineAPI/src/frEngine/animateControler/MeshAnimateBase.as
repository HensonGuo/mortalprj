package frEngine.animateControler
{
	import flash.events.Event;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.Engine3dEventName;
	import frEngine.core.FrSurface3D;
	import frEngine.shader.ShaderBase;

	public class MeshAnimateBase extends Modifier
	{
		public var targetMesh:Mesh3D;
		public var normalMaterial:ShaderBase;
		public var targetSurface:FrSurface3D;
		private var _instance:Modifier;
		
		public function MeshAnimateBase()
		{
			super();
		}
		public function set instance(value:Modifier):void
		{
			_instance=value;
		}
		public function get instance():Modifier
		{
			return _instance;
		}
		
		public override function set targetObject3d(value:Pivot3D):void
		{
			targetMesh=Mesh3D(value);
			super.targetObject3d=value;
			if(targetMesh)
			{
				var surfaceNum:uint=targetMesh.getSurfacesLen()
				if(surfaceNum==0)
				{
					targetMesh.addEventListener(Engine3dEventName.SetMeshSurface,setSurfaceHander);
				}else
				{
					setSurfaceHander(null);
				}
			}
			
			
		}
		
		protected function setSurfaceHander(e:Event):void
		{
			
			targetSurface=targetMesh.getSurface(0);
			if(targetMesh.material)
			{
				setMaterialHander(null);
			}else
			{
				targetMesh.addEventListener(Engine3dEventName.MATERIAL_CHANGE,setMaterialHander);
			}
			
			
		}
		protected function setMaterialHander(e:Event):void
		{
			normalMaterial=targetMesh.material
		}
		public override function dispose():void
		{

			if(targetMesh)
			{
				targetMesh.removeEventListener(Engine3dEventName.MATERIAL_CHANGE,setMaterialHander);
				targetMesh.removeEventListener(Engine3dEventName.SetMeshSurface,setSurfaceHander);
			}
			
			super.dispose();
			normalMaterial=null;
			targetSurface=null
			targetMesh=null;
			instance=null;
		}
	}
}