package frEngine.primitives
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import __AS3__.vec.Vector;
	
	import baseEngine.basic.RenderList;
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.core.FrSurface3D;
	import frEngine.core.FrVertexBuffer3D;
	import frEngine.render.FrQuadRender;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.vertexFilters.TransformFilter;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	
	public class FrQuad extends Mesh3D 
	{
		
		private var _x:Number;
		private var _y:Number;
		private var _width:Number;
		private var _height:Number;
		private static var _surf:FrSurface3D;
		private var _fullScreenMode:Boolean = false;
		protected var _toChange:Boolean=false;
		private static const defaultSceneRect:Rectangle=new Rectangle(0,0,800,600);
		protected var _sceneRect:Rectangle=defaultSceneRect;
		private static const _temp0:Vector3D=new Vector3D();
		private var _Zdepth1:Number=0;
		private var _Zdepth2:Number=0;
		private var _screenTransform:Matrix3D=new Matrix3D();
		public function FrQuad(_arg1:String="quad", $x:Number=0, $y:Number=0, $width:Number=100, $height:Number=100, isFullScreenMode:Boolean=false, material:*=null,$renderList:RenderList=null)
		{
			super(_arg1,true,$renderList);
			this.setMaterial(material,Texture3D.MIP_NONE,material);
			
			this.addSurface(surf);
			this.setTo($x, $y, $width, $height, isFullScreenMode);
			this.render=FrQuadRender.instance;

			
		}
		
		public static function get surf():FrSurface3D
		{
			if(!_surf)
			{
				_surf = new FrSurface3D("quad");
				_surf.addVertexData(FilterName_ID.POSITION_ID,3,false,null);
				_surf.addVertexData(FilterName_ID.UV_ID,2,false,null);
				
				var vertexVector:Vector.<Number>=_surf.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector;
				vertexVector.push(-1, 1, 0, 0, 0);
				vertexVector.push(1, 1, 0, 1, 0);
				vertexVector.push(-1, -1, 0, 0, 1);
				vertexVector.push(1, -1, 0, 1, 1);
				
				_surf.indexVector = new Vector.<uint>();
				_surf.indexVector.push(0, 1, 2, 3, 2, 1);
			}
			return _surf;
		}
		protected override function setShaderBase(materaial:ShaderBase):void
		{
			TransformFilter(materaial.vertexFilter).OpType=ECalculateOpType.WorldViewProj;
			super.setShaderBase(materaial);
			
		}
		public function setZdepth(value1:Number,value2:Number):void
		{

			if(_Zdepth1==value1 || _Zdepth2==value2)
			{
				return;
			}
			_Zdepth1=value1;
			_Zdepth2=value2;
			var _vertexBuffer:FrVertexBuffer3D=_surf.getVertexBufferByNameId(FilterName_ID.POSITION_ID)
			var vertexVector:Vector.<Number>=_vertexBuffer.vertexVector;
			vertexVector[2]=vertexVector[7]=_Zdepth1;
			vertexVector[12]=vertexVector[17]=_Zdepth2;
			_vertexBuffer._toUpdate=true;
		}
		public function get Zdepth1():Number
		{
			return _Zdepth1;
		}
		public function get Zdepth2():Number
		{
			return _Zdepth2;
		}
		public override function disposeSurfaces():void
		{
			this.surfaces = new Vector.<FrSurface3D>();
		}
		
		public function set sceneRect(value:Rectangle):void
		{
			if(_sceneRect.size!=value.size || _sceneRect.x!=value.x || _sceneRect.y!=value.y)
			{
				_toChange=true;
				_sceneRect.x=value.x;
				_sceneRect.y=value.y;
				_sceneRect.width=value.width;
				_sceneRect.height=value.height;
			}
			
			
		}
		
		public function get sceneRect():Rectangle
		{
			return _sceneRect
		}
		public override function addedToScene(_arg1:Scene3D):void
		{
			super.addedToScene(_arg1);
			_arg1.addEventListener(Engine3dEventName.SCENE_VIEWPORT_CHANGE,changTransformHander);
			if(_arg1.viewPort)
			{
				sceneRect=_arg1.viewPort;
			}
		}
		public override function removedFromScene():void
		{
			_scene && _scene.removeEventListener(Engine3dEventName.SCENE_VIEWPORT_CHANGE,changTransformHander);
			super.removedFromScene();
		}
		protected function changTransformHander(e:Event):void
		{
			_toChange=true;
			if(!_sceneRect && _scene)
			{
				sceneRect=_scene.viewPort;
			}
			
		}
		
		
		public function change():void
		{
			var _local4:Number;
			var _local5:Number;
			var _local6:Number;
			var _local7:Number;

			var pos:Vector3D=this.getPosition(false,_temp0);
			_local4 = (pos.x) / _sceneRect.width;
			_local5 = (pos.y) / _sceneRect.height;
			_local6 = this._width / _sceneRect.width;
			_local7 = this._height / _sceneRect.height;
			
			if (this._fullScreenMode)
			{
				_local6 = 1 - _local4;
				_local7 = 1 - _local5;
			};
			_screenTransform.identity();
			_screenTransform.appendScale(_local6 || 0.0001, _local7 || 0.0001, 1);
			_screenTransform.appendTranslation(((-1 + _local6) + (_local4 * 2)), ((1 - _local7) - (_local5 * 2)), 0);
			_toChange=false;
		}
		public override function updateChildrenTransform():void
		{
			super.updateChildrenTransform();
			_toChange=true;
		}
		public function setTo($x:Number, $y:Number, $width:Number, $height:Number, isFullScreenMode:Boolean=false):void
		{
			this.x = $x;
			this.y = $y;
			this._width = $width;
			this._height = $height;
			this._fullScreenMode = isFullScreenMode;
			_toChange=true;
		}
		public function set fullScreenMode(value:Boolean):void
		{
			if(this._fullScreenMode==value)
			{
				return;
			}
			this._fullScreenMode=value;
			_toChange=true;
		}
		public function get fullScreenMode():Boolean
		{
			return this._fullScreenMode;
		}
		
		public function set width(value:int):void
		{
			if(this._width==value)
			{
				return;
			}
			this._width=value;
			_toChange=true;
		}
		public function get width():int
		{
			return this._width;
		}
		public function set height(value:int):void
		{
			if(this._height==value)
			{
				return;
			}
			this._height=value;
			_toChange=true;
		}
		public function get height():int
		{
			return this._height;
		}
		public override function set x(value:Number):void
		{
			super.x=value;
			_toChange=true;
		}

		public override function set y(value:Number):void
		{
			super.y=value;
			_toChange=true;
		}

		override public function draw(_arg1:Boolean=true, _arg2:ShaderBase=null):void
		{
			if (!scene)
			{
				upload(Device3D.scene);
			};
			if (!visible)
			{
				return;
			}
			
			if(_toChange)
			{
				change();
			}
			
			Device3D.worldViewProj.copyFrom(this._screenTransform);
			
			render.draw(this,this.material);
			
		}
		
	}
}

//package flare.primitives

