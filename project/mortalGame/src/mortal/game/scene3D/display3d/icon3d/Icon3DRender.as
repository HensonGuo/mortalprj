package mortal.game.scene3D.display3d.icon3d
{
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
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.math.Quaternion;
	import frEngine.render.DefaultRender;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.registType.FsParam;
	import frEngine.shader.registType.VcParam;
	
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;

	public class Icon3DRender extends DefaultRender
	{
		private static var _instance:Icon3DRender;
		
		private var _targeticonSurface:FrSurface3D;
		private var _iconMaterial:ShaderBase;
		private var _materialParams:MaterialParams;
		private var _iconPosListRegister:VcParam;
		private var _iconTextureRegister:FsParam;
		public function Icon3DRender()
		{
			if(_instance && _instance!=this)
			{
				return;
			}
			_instance=this;
		}
		public function init(scene:GameScene3D):void
		{
			initicons();
			initMaterial(scene);
		}
		private function initMaterial(scene:GameScene3D):void
		{
			
			_materialParams=new MaterialParams();
			_materialParams.setBlendMode(Material3D.BLEND_ALPHA0);
			_materialParams.depthWrite=false;
			var texture3d:Texture3D=Resource3dManager.instance.getTexture3d(Device3D.nullBitmapData,0);
			_iconMaterial=new ShaderBase("_iconMaterial",new Icon3DVertexFilter(),new Icon3DFragmentFilter(texture3d),_materialParams);
			_iconMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander);
			_iconMaterial.upload(scene);
		}
		private function reBuildHander(e:Event):void
		{
			_iconPosListRegister=_iconMaterial.getParam("{iconPosList}",true);
			_iconTextureRegister=_iconMaterial.getParam("{iconBg0}",false);
			this._iconMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander);
		}
		private function initicons():void
		{
			_targeticonSurface=new FrSurface3D("icons");
			var _vertexBuffer3D:FrVertexBuffer3D=_targeticonSurface.addVertexData(FilterName_ID.POSITION_ID,3,true,null);
			_targeticonSurface.addVertexDataToTargetBuffer(FilterName_ID.UV_ID,2,null,_vertexBuffer3D);
			var vector:Vector.<Number>=createSinglePlaneVector(16,16);
			var resultVector:Vector.<Number>=new Vector.<Number>();
			var  _vertexBuffer3D_3:FrVertexBuffer3D=_targeticonSurface.addVertexData(FilterName_ID.SKIN_INDICES_ID,1,true,null);
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
			
			_targeticonSurface.indexVector=indexVector;
			
		}
		private function createSinglePlaneVector(w:int,h:int):Vector.<Number>
		{
			var v:Vector.<Vector3D>=new Vector.<Vector3D>();
			v.push(new Vector3D(-w,-h,0));
			v.push(new Vector3D(w,-h,0));
			v.push(new Vector3D(w,h,0));
			v.push(new Vector3D(-w,h,0));
			
			var v2:Vector.<Point>=new Vector.<Point>();
			var m:Number=1/8;
			v2.push(new Point(0,m));
			v2.push(new Point(m,m));
			v2.push(new Point(m,0));
			v2.push(new Point(0,0));
			
			
			var _faceCamera:Quaternion=Scene3DUtil.cameraQuaternion;
			var out:Vector.<Number>=new Vector.<Number>();
			var _v:Vector3D=new Vector3D();
			for(var i:int=0;i<4;i++)
			{
				_faceCamera.rotatePoint(v[i],_v);
				out.push(_v.x,_v.y,_v.z,v2[i].x,v2[i].y);
			}
			return out;
		}
		public static function get instance():Icon3DRender
		{
			if(!_instance)
			{
				new Icon3DRender();
			}
			return _instance;
		}
		
		
		public override function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{

			if(!_iconPosListRegister)
			{
				return;
			}
			if(!_iconMaterial.hasPrepared(mesh, _targeticonSurface))
			{
				return;
			}
			var listArr:Array=Icon3DMesh(mesh).listArr;
			var len:int=listArr.length;
			for(var i:int=0;i<len;i++)
			{
				Device3D.objectsDrawn++;
				var list1Values:Vector.<Number>=listArr[i];
				_iconPosListRegister.value=list1Values;
				_iconTextureRegister.value=Icon3DMesh(mesh).iconBg0;
				_iconMaterial.draw(mesh, _targeticonSurface,_materialParams.depthCompare,_materialParams.cullFace,false,_materialParams.sourceFactor,_materialParams.destFactor, 0, list1Values.length*0.5);
			
			}
			
		}
	}
}