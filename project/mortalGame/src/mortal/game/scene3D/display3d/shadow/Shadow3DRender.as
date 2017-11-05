package mortal.game.scene3D.display3d.shadow
{
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.render.DefaultRender;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.registType.VcParam;
	
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.GameScene3D;

	public class Shadow3DRender extends DefaultRender
	{
		private static var _instance:Shadow3DRender;
		public const list1Values:Vector.<Number>=new Vector.<Number>();
		public const list2Values:Vector.<Number>=new Vector.<Number>();
		private var _targetshadowSurface:FrSurface3D;
		private var _shadowMaterial:ShaderBase;
		private var _materialParams:MaterialParams;
		private var _shadowPosListRegister:VcParam;
 
		public function Shadow3DRender()
		{
			if(_instance && _instance!=this)
			{
				return;
			}
			_instance=this;
		}
		public function init(scene:GameScene3D):void
		{
			initshadows();
			initMaterial(scene);
		}
		private function initMaterial(scene:GameScene3D):void
		{
			var bmpdata0:BitmapData=GlobalClass.getBitmapData(ImagesConst.Shadow).clone();
			var shadowBg0:Texture3D=new Texture3D(bmpdata0,0,0);
			shadowBg0.upload(scene);
			_materialParams=new MaterialParams();
			_materialParams.setBlendMode(Material3D.BLEND_ALPHA0);
			_materialParams.depthWrite=false;
			_shadowMaterial=new ShaderBase("_shadowMaterial",new ShadowVertexFilter(),new ShadowFragmentFilter(shadowBg0),_materialParams);
			_shadowMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander);
			_shadowMaterial.upload(scene);
		}
		private function reBuildHander(e:Event):void
		{
			_shadowPosListRegister=_shadowMaterial.getParam("{shadowPosList}",true);
			this._shadowMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander);
		}
		private function initshadows():void
		{
			
			
			_targetshadowSurface=new FrSurface3D("shadows");
			var _vertexBuffer3D:FrVertexBuffer3D=_targetshadowSurface.addVertexData(FilterName_ID.POSITION_ID,3,true,null);
			_targetshadowSurface.addVertexDataToTargetBuffer(FilterName_ID.UV_ID,2,_vertexBuffer3D.bufferIndex,null);
			var vector:Vector.<Number>=createSinglePlaneVector(32,32);
			var resultVector:Vector.<Number>=new Vector.<Number>();
			var  _vertexBuffer3D_3:FrVertexBuffer3D=_targetshadowSurface.addVertexData(FilterName_ID.SKIN_INDICES_ID,1,true,null);
			var vector_3:Vector.<Number>=_vertexBuffer3D_3.vertexVector;

			for(var i:int=0;i<100;i++)
			{
				resultVector=resultVector.concat(vector);
				vector_3.push(i,i,i,i);
			}

			_vertexBuffer3D.vertexVector=resultVector;
			
			var indexVector:Vector.<uint>=new Vector.<uint>();
			i=0;
			while(i<100)
			{
				var n:int=i*4;
				indexVector.push(n,n+2,n+1);
				indexVector.push(n+3,n+2,n);
				i++;
			}
			
			_targetshadowSurface.indexVector=indexVector;
			
		}
		private function createSinglePlaneVector(w:int,h:int):Vector.<Number>
		{
			var v:Vector.<Vector3D>=new Vector.<Vector3D>();
			v.push(new Vector3D(-w,0,-h));
			v.push(new Vector3D(w,0,-h));
			v.push(new Vector3D(w,0,h));
			v.push(new Vector3D(-w,0,h));
			
			var v2:Vector.<Point>=new Vector.<Point>();
			v2.push(new Point(1,1));
			v2.push(new Point(1,0));
			v2.push(new Point(0,0));
			v2.push(new Point(0,1));
			
			
			var out:Vector.<Number>=new Vector.<Number>();
			for(var i:int=0;i<4;i++)
			{
				var _v:Vector3D=v[i];
				out.push(_v.x,_v.y,_v.z,v2[i].x,v2[i].y);
			}
			return out;
		}
		public static function get instance():Shadow3DRender
		{
			if(!_instance)
			{
				new Shadow3DRender();
			}
			return _instance;
		}
		
		
		public override function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{

			if(!_shadowPosListRegister)
			{
				return;
			}

			Device3D.objectsDrawn++;
			
			_shadowMaterial.hasReupload(mesh, _targetshadowSurface);
			
			if(list1Values.length>0)
			{
				_shadowPosListRegister.value=list1Values;
				_shadowMaterial.draw(mesh, _targetshadowSurface,_materialParams.cullFace,false,_materialParams.sourceFactor,_materialParams.destFactor, 0, list1Values.length*0.5);
			}
			
			if(list2Values.length>0)
			{
				_shadowPosListRegister.value=list2Values;
				_shadowMaterial.draw(mesh, _targetshadowSurface,_materialParams.cullFace,false,_materialParams.sourceFactor,_materialParams.destFactor, 0, list2Values.length*0.5);
			}
			
		}
	}
}