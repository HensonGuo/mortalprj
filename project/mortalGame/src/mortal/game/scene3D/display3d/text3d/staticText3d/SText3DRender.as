package mortal.game.scene3D.display3d.text3d.staticText3d
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.render.DefaultRender;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.registType.VcParam;
	
	import mortal.game.scene3D.GameScene3D;

	public class SText3DRender extends DefaultRender
	{
		private static var _instance:SText3DRender;

		private var _textSurface:FrSurface3D;
		private var _textMaterial:ShaderBase;
		private var _materialParams:MaterialParams;
		private var _textPosListRegister:VcParam;
		public var textBg0:Texture3D;
		public const maxNum:uint = 120;

		public function SText3DRender()
		{
			if (_instance && _instance != this)
			{
				return;
			}
			_instance = this;
		}

		public function init(scene:GameScene3D):void
		{
			initSurface();
			initMaterial(scene);
		}

		private function initMaterial(scene:GameScene3D):void
		{
			textBg0 = new Texture3D("fightNumbers.png", 0);
			_materialParams = new MaterialParams();
			_materialParams.setBlendMode(Material3D.BLEND_ALPHA0);
			_materialParams.depthWrite=false;
			/*_materialParams.sourceFactor=Context3DBlendFactor.SOURCE_ALPHA;
			_materialParams.destFactor=Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;*/
			_textMaterial = new ShaderBase("SText3DRender", new SText3DVertexFilter(), new SText3DFragmentFilter(textBg0), _materialParams);
			_textMaterial.addEventListener(Engine3dEventName.MATERIAL_REBUILDER, reBuildHander);
			_textMaterial.upload(scene);

		}

		private function reBuildHander(e:Event):void
		{
			_textPosListRegister = _textMaterial.getParam("{textPosList}", true);
			this._textMaterial.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER, reBuildHander);
		}

		private function initSurface():void
		{
			_textSurface = new FrSurface3D("texts");
			var _vertexBuffer3D:FrVertexBuffer3D = _textSurface.addVertexData(FilterName_ID.POSITION_ID, 3, true, null);
			_textSurface.addVertexDataToTargetBuffer(FilterName_ID.UV_ID, 2, null, _vertexBuffer3D);
			var vector:Vector.<Number> = createSinglePlaneVector(1, 1);
			var resultVector:Vector.<Number> = new Vector.<Number>();
			var _vertexBuffer3D_3:FrVertexBuffer3D = _textSurface.addVertexData(FilterName_ID.SKIN_INDICES_ID, 1, true, null);
			var vector_3:Vector.<Number> = _vertexBuffer3D_3.vertexVector;

			for (var i:int = 0; i < maxNum; i++)
			{
				resultVector = resultVector.concat(vector);
				vector_3.push(i,i,i,i);
			}

			_vertexBuffer3D.vertexVector = resultVector;

			var indexVector:Vector.<uint> = new Vector.<uint>();
			i = 0;
			while (i < maxNum)
			{
				var n:int = i * 4;
				indexVector.push(n, n + 2, n + 1);
				indexVector.push(n + 3, n + 2, n);
				i++;
			}

			_textSurface.indexVector = indexVector;

		}

		private function createSinglePlaneVector(w:Number, h:Number):Vector.<Number>
		{
			var v:Vector.<Vector3D> = new Vector.<Vector3D>();
			var h2:Number = h * 0.5;

			var out:Vector.<Number> = new Vector.<Number>();

			out.push(0, -h2, 0, 	0, 1);
			out.push(w, -h2, 0, 	1, 1);
			out.push(w, h2, 0, 	1, 0);
			out.push(0, h2, 0, 	0, 0);

			return out;
		}

		public static function get instance():SText3DRender
		{
			if (!_instance)
			{
				new SText3DRender();
			}
			return _instance;
		}


		public override function draw(mesh:Mesh3D, material:ShaderBase = null):void
		{
			if (!_textPosListRegister)
			{
				return;
			}


			Device3D.objectsDrawn++;

			if(!_textMaterial.hasPrepared(mesh, _textSurface))
			{
				return;
			}

			var _text3dMesh:SText3DMesh = SText3DMesh(mesh)
			var listArr:Vector.<VcList> = _text3dMesh.vcListMap;
			var len:int = listArr.length;

			for (var i:int = 0; i < len; i++)
			{
				Device3D.objectsDrawn++;
				var list1Values:Vector.<Number> = listArr[i].list;
				_textPosListRegister.value = list1Values;
				_textMaterial.draw(mesh, _textSurface,_materialParams.depthCompare, _materialParams.cullFace, false, _materialParams.sourceFactor, _materialParams.destFactor, 0, list1Values.length * 0.5);

			}
		}
	}
}
