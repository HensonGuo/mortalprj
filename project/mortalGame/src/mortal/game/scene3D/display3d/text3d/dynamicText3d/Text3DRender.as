package mortal.game.scene3D.display3d.text3d.dynamicText3d
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
	import frEngine.render.DefaultRender;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.registType.FsParam;
	import frEngine.shader.registType.VcParam;
	
	import mortal.game.scene3D.GameScene3D;

	public class Text3DRender extends DefaultRender
	{
		private static var _instance:Text3DRender;
		
		private var _textSurface:FrSurface3D;
		private var _textMaterial:ShaderBase;
		private var _materialParams:MaterialParams;
		private var _textPosListRegister:VcParam;
		private var _textTextureRegister:FsParam;
		private var _curIndex:int=0;
		private var _textConst:Vector.<Number>;
		public function Text3DRender()
		{
			if(_instance && _instance!=this)
			{
				return;
			}
			_instance=this;
		}
		public function init(scene:GameScene3D):void
		{
			inittexts();
			initMaterial(scene);
		}
		private function initMaterial(scene:GameScene3D):void
		{
			
			_materialParams=new MaterialParams();
			_materialParams.uvRepeat=false;
			_materialParams.setBlendMode(Material3D.BLEND_ALPHA0);
			_materialParams.depthWrite=false;
			/*_materialParams.sourceFactor=Context3DBlendFactor.SOURCE_ALPHA;
			_materialParams.destFactor=Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;*/
			var texture3d:Texture3D=Resource3dManager.instance.getTexture3d(Device3D.nullBitmapData,0);
			_textMaterial=new ShaderBase("Text3DRender",new Text3DVertexFilter(),new Text3DFragmentFilter(texture3d),_materialParams);
			_textMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander);
			_textMaterial.upload(scene);
			
		}
		private function reBuildHander(e:Event):void
		{
			_textPosListRegister=_textMaterial.getParam("{textPosList}",true);
			_textTextureRegister=_textMaterial.getParam("{textBg0}",false);
			_textConst=_textMaterial.getParam("{textConst}",true).value;
			this._textMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,reBuildHander);
		}
		private function inittexts():void
		{
			_textSurface=new FrSurface3D("texts");
			var _vertexBuffer3D:FrVertexBuffer3D=_textSurface.addVertexData(FilterName_ID.POSITION_ID,3,true,null);
			_textSurface.addVertexDataToTargetBuffer(FilterName_ID.UV_ID,2,null,_vertexBuffer3D);
			var vector:Vector.<Number>=createSinglePlaneVector(1,1);
			var resultVector:Vector.<Number>=new Vector.<Number>();
			var  _vertexBuffer3D_3:FrVertexBuffer3D=_textSurface.addVertexData(FilterName_ID.SKIN_INDICES_ID,1,true,null);
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
			
			_textSurface.indexVector=indexVector;
			
		}
		private function createSinglePlaneVector(w:Number,h:Number):Vector.<Number>
		{
			var v:Vector.<Vector3D>=new Vector.<Vector3D>();
			/*var w2:Number=w/2;
			var h2:Number=h/2;
			v.push(new Vector3D(-w2,-h2,0));
			v.push(new Vector3D(w2,-h2,0));
			v.push(new Vector3D(w2,h2,0));
			v.push(new Vector3D(-w2,h2,0));
			*/
			v.push(new Vector3D(0,0,0));
			v.push(new Vector3D(w,0,0));
			v.push(new Vector3D(w,h,0));
			v.push(new Vector3D(0,h,0));
			
			var v2:Vector.<Point>=new Vector.<Point>();
			v2.push(new Point(0,1));
			v2.push(new Point(1,1));
			v2.push(new Point(1,0));
			v2.push(new Point(0,0));

			var out:Vector.<Number>=new Vector.<Number>();
			var _v:Vector3D;
			for(var i:int=0;i<4;i++)
			{
				_v=v[i];
				out.push(_v.x,_v.y,_v.z,v2[i].x,v2[i].y);
			}
			return out;
		}
		public static function get instance():Text3DRender
		{
			if(!_instance)
			{
				new Text3DRender();
			}
			return _instance;
		}
		
		
		public override function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{
			if(!_textPosListRegister)
			{
				return;
			}

			_curIndex++;
			
			if(_curIndex>4)
			{
				_curIndex=0;
				Text3DFactory.instance.checkToUploadTexture();//每隔4帧检查是否要上传纹理
			}
			Device3D.objectsDrawn++;
			
			if(!_textMaterial.hasPrepared(mesh, _textSurface))
			{
				return;
			}
			
			var _text3dMesh:Text3DMesh=Text3DMesh(mesh)
			var listArr:Array=_text3dMesh.listArr;
			_textConst[3]=_text3dMesh.text3dWidth;
			var len:int=listArr.length;
			for(var i:int=0;i<len;i++)
			{
				Device3D.objectsDrawn++;
				var list1Values:Vector.<Number>=listArr[i];
				_textPosListRegister.value=list1Values;
				_textTextureRegister.value=_text3dMesh.textBg0;
				_textMaterial.draw(mesh, _textSurface,_materialParams.depthCompare,_materialParams.cullFace,false,_materialParams.sourceFactor,_materialParams.destFactor, 0, list1Values.length*0.5);
				
			}
		}
	}
}