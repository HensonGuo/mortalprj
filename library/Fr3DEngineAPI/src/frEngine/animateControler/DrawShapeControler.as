package frEngine.animateControler
{
	import flash.display3D.Context3DBlendFactor;
	import flash.events.Event;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.core.Surface3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.line.LineSurfaceVo;
	import frEngine.core.FrSurface3D;
	import frEngine.render.IRender;
	import frEngine.shader.MaterialParams;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.vertexFilters.Line3dFilter;
	import frEngine.shader.registType.VcParam;

	public class DrawShapeControler extends MeshAnimateBase implements IRender
	{
		public static var lineSizeSclae:Number=1;
		

		private var size:VcParam;
		private var _color:VcParam;
		private var _material:ShaderBase;

		private var _colorFilter:ColorFilter;
		private var _surfaceList:Array=new Array();
		
		public function DrawShapeControler()
		{
			_colorFilter=new ColorFilter(0,0,0,0);
			
			_material=new ShaderBase("DrawShapeControler",new Line3dFilter(),_colorFilter,null);
			_material.addEventListener(Engine3dEventName.MATERIAL_REBUILDER,setingParams);
			
			_isPlaying=true;
		}
		public function clear():void
		{
			var _local1:Surface3D;
			var len:int=targetMesh.getSurfacesLen();
			for (var i:int=0;i<len;i++)
			{
				_local1=targetMesh.getSurface(i);
				_local1.download();
			};
			targetMesh.clearSurface();
			_surfaceList=new Array();
		}
		public override function get type():int
		{
			return AnimateControlerType.DrawShapeControler;
		}
		private function setingParams(e:Event):void
		{
			_material.removeEventListener(Engine3dEventName.MATERIAL_REBUILDER,setingParams);
			size = this._material.getParam("{size}",true) as VcParam;

		}
		public override function set targetObject3d(value:Pivot3D):void
		{
			super.targetObject3d=value;

			if(targetMesh)
			{
				targetMesh.materialPrams.sourceFactor=Context3DBlendFactor.SOURCE_ALPHA;
				targetMesh.materialPrams.destFactor=Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
				targetMesh.materialPrams.depthWrite=true;
				targetMesh.materialPrams.twoSided=true;
				_material.materialParams=targetMesh.materialPrams;
				targetMesh.setMaterial(_material,Texture3D.MIP_NONE,"drawShapeControl");
			}
			
		}
		public override function toUpdateAnimate(forceUpdate:Boolean=false):void
		{
			super.toUpdateAnimate(forceUpdate);
			if(size)
			{
				size.value[0] = (Device3D.camera.zoom / Device3D.viewPortW)*lineSizeSclae;
			}
			
		}
		
		public function lineStyle(_arg1:Number=1, _arg2:uint=0xFFFFFF, _arg3:Number=1,surfaceIndex:uint=0):void
		{
			var lineSurfaceVo:LineSurfaceVo=this._surfaceList[surfaceIndex];
			if(!lineSurfaceVo)
			{
				this._surfaceList[surfaceIndex]=lineSurfaceVo=new LineSurfaceVo();
			}
			lineSurfaceVo.alpha = _arg3;
			lineSurfaceVo.thickness = _arg1;
			lineSurfaceVo.r = (((_arg2 >> 16) & 0xFF) / 0xFF);
			lineSurfaceVo.g = (((_arg2 >> 8) & 0xFF) / 0xFF);
			lineSurfaceVo.b = ((_arg2 & 0xFF) / 0xFF);
			//this._surf = null;
		}
		public function moveTo(_arg1:Number, _arg2:Number, _arg3:Number,surfaceIndex:int=0):void
		{
			var lineSurfaceVo:LineSurfaceVo=this._surfaceList[surfaceIndex];
			lineSurfaceVo.lx = _arg1;
			lineSurfaceVo.ly = _arg2;
			lineSurfaceVo.lz = _arg3;
		}
		public function drawEdge(mesh:Mesh3D,edgeColor:Number=0xffffff):void
		{
			
		}
		
		public function drawDepth(mesh:Mesh3D,objectColor:Number=0, $alpha:Number=1):void
		{
			
			
		}
		
		public function draw(mesh:Mesh3D, material:ShaderBase=null):void
		{
			var _local3:Surface3D;
			var len:int=this._surfaceList.length;
			for(var i:int=0;i<len;i++)
			{
				var lineSurfaceVo:LineSurfaceVo=this._surfaceList[i];
				_local3=lineSurfaceVo.surface;
				if(!_material.hasPrepared(mesh, _local3))
				{
					return;
				}
				var materialPrams:MaterialParams=mesh.materialPrams;
				_colorFilter.colorValue[0]=lineSurfaceVo.r;
				_colorFilter.colorValue[1]=lineSurfaceVo.g;
				_colorFilter.colorValue[2]=lineSurfaceVo.b;
				_colorFilter.colorValue[3]=lineSurfaceVo.alpha;
				_material.draw(mesh, _local3,materialPrams.depthCompare ,materialPrams.cullFace,materialPrams.depthWrite,materialPrams.sourceFactor,materialPrams.destFactor, _local3.firstIndex, _local3.numTriangles);
				Device3D.objectsDrawn++;
			}
			
			
			
		}
		public function completeDraw(mesh:Mesh3D):void
		{
			
		}
		
		
		
		public function lineTo(_arg1:Number, _arg2:Number, _arg3:Number,surfaceIndex:int=0):void
		{
			var lineSurfaceVo:LineSurfaceVo=this._surfaceList[surfaceIndex];
			var _surf:FrSurface3D=lineSurfaceVo.surface;
			var _local4:uint;
			var _vector:Vector.<Number>;
			if (!_surf)
			{
				_surf = new FrSurface3D((targetMesh.name + "_surface"));
				_surf.addVertexData(FilterName_ID.POSITION_ID,3,false,null);
				_surf.addVertexData(FilterName_ID.PARAM0_ID,3,false,null);
				_surf.addVertexData(FilterName_ID.PARAM1_ID,1,false,null);
				_surf.indexVector = new Vector.<uint>();
				targetMesh.addSurface(_surf);
				lineSurfaceVo.surface=_surf;
			}
			
			_vector=_surf.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector
				
			_local4 = _vector.length / _surf.sizePerVertex

			var _lx:Number=lineSurfaceVo.lx
			var _ly:Number=lineSurfaceVo.ly
			var _lz:Number=lineSurfaceVo.lz
			var _thickness:Number=lineSurfaceVo.thickness
			
			_vector.push(	_lx, 	_ly, 	_lz, 	_arg1, 	_arg2, 	_arg3, 	_thickness,	
											_arg1, _arg2, 	_arg3, 	_lx, 	_ly, 	_lz, 	-_thickness,
											_lx, 	_ly, 	_lz, 	_arg1, 	_arg2, 	_arg3, 	-_thickness,
											_arg1, _arg2, 	_arg3, 	_lx, 	_ly, 	_lz, 	_thickness	
			);
			_surf.indexVector.push((_local4 + 2), (_local4 + 1), _local4, (_local4 + 1), (_local4 + 2), (_local4 + 3));
			
			lineSurfaceVo.lx = _arg1;
			lineSurfaceVo.ly = _arg2;
			lineSurfaceVo.lz = _arg3;

		}
	}
}