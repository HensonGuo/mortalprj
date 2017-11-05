package mortal.game.scene3D.display3d.blood
{
	import flash.display.Bitmap;
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
	import frEngine.math.Quaternion;
	import frEngine.render.DefaultRender;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.registType.VcParam;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;

	public class Blood3DRender extends DefaultRender
	{
		private static var _instance:Blood3DRender;
		public const list1Values:Vector.<Number>=new Vector.<Number>();
		public const list2Values:Vector.<Number>=new Vector.<Number>();
		private var _targetBloodSurface:FrSurface3D;
		private var _bloodMaterial:ShaderBase;
		private var _materialParams:MaterialParams;
		private var _bloodPosListRegister:VcParam;
 
		public function Blood3DRender()
		{
			if(_instance && _instance!=this)
			{
				return;
			}
			_instance=this;
		}
		public function init(scene:GameScene3D):void
		{
			initBloods();
			initMaterial(scene);
		}
		private function initMaterial(scene:GameScene3D):void
		{
			var bmpBg:Bitmap=ResourceConst.getScaleBitmap(ImagesConst.lifeBg,10,250,64,8,null);
			var bloodBg0:Texture3D=new Texture3D(bmpBg.bitmapData,0,0);
			var bmpTop:Bitmap=ResourceConst.getScaleBitmap(ImagesConst.lifeTop,10,100,64,8,null);

			var bloodBg1:Texture3D=new Texture3D(bmpTop.bitmapData,0,0);
			bloodBg0.upload(scene,false);
			bloodBg1.upload(scene,false);
			_materialParams=new MaterialParams();
			_materialParams.setBlendMode(Material3D.BLEND_ALPHA0);
			_materialParams.depthWrite=false;
			_bloodMaterial=new ShaderBase("_bloodMaterial",new BloodVertexFilter(),new BloodFragmentFilter(bloodBg0,bloodBg1),_materialParams);
			_bloodMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander);
			_bloodMaterial.upload(scene);
		}
		private function reBuildHander(e:Event):void
		{
			_bloodPosListRegister=_bloodMaterial.getParam("{bloodPosList}",true);
			this._bloodMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander);
		}
		private function initBloods():void
		{
			_targetBloodSurface=new FrSurface3D("bloods");
			var _vertexBuffer3D:FrVertexBuffer3D=_targetBloodSurface.addVertexData(FilterName_ID.POSITION_ID,3,true,null);
			_targetBloodSurface.addVertexDataToTargetBuffer(FilterName_ID.UV_ID,2,null,_vertexBuffer3D);
			var vector:Vector.<Number>=createSinglePlaneVector(30,4);
			var resultVector:Vector.<Number>=new Vector.<Number>();
			var  _vertexBuffer3D_3:FrVertexBuffer3D=_targetBloodSurface.addVertexData(FilterName_ID.SKIN_INDICES_ID,1,true,null);
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
			
			_targetBloodSurface.indexVector=indexVector;
			
		}
		private function createSinglePlaneVector(w:int,h:int):Vector.<Number>
		{
			var v:Vector.<Vector3D>=new Vector.<Vector3D>();
			v.push(new Vector3D(-w,-h,0));
			v.push(new Vector3D(w,-h,0));
			v.push(new Vector3D(w,h,0));
			v.push(new Vector3D(-w,h,0));
			
			var v2:Vector.<Point>=new Vector.<Point>();
			v2.push(new Point(1,1));
			v2.push(new Point(0,1));
			v2.push(new Point(0,0));
			v2.push(new Point(1,0));
			
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
		public static function get instance():Blood3DRender
		{
			if(!_instance)
			{
				new Blood3DRender();
			}
			return _instance;
		}
		
		
		public override function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{

			if(!_bloodPosListRegister)
			{
				return;
			}

			
			
			if(!_bloodMaterial.hasPrepared(mesh, _targetBloodSurface))
			{
				return;
			}
			
			Device3D.objectsDrawn++;
			
			if(list1Values.length>0)
			{
				_bloodPosListRegister.value=list1Values;
				_bloodMaterial.draw(mesh, _targetBloodSurface,_materialParams.depthCompare,_materialParams.cullFace,true,_materialParams.sourceFactor,_materialParams.destFactor, 0, list1Values.length*0.5);
			}
			
			if(list2Values.length>0)
			{
				_bloodPosListRegister.value=list2Values;
				_bloodMaterial.draw(mesh, _targetBloodSurface,_materialParams.depthCompare,_materialParams.cullFace,true,_materialParams.sourceFactor,_materialParams.destFactor, 0, list2Values.length*0.5);
			}
			
		}
	}
}