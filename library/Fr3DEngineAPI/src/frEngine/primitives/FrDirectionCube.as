package frEngine.primitives
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import __AS3__.vec.Vector;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.core.FrSurface3D;
	import frEngine.render.DirectionRender;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;
	
	
	public class FrDirectionCube extends Mesh3D 
	{
		
		private var _width:Number;
		private var _height:Number;
		private var _depth:Number;
		private var _segments:int;
		
		/**
		 * 贴图从上到下左到右，2行3列共6个区域， 对应的cube的面的顺序为下、上、左、右、后、前  
		 * @param meshName
		 * @param width
		 * @param height
		 * @param depth
		 * @param segments
		 * @param material
		 * @param $canInsertToScene
		 * 
		 */	
		public function FrDirectionCube(meshName:String="", width:Number=10, height:Number=10, depth:Number=10, segments:int=1, material:Material3D=null,$renderList:RenderList=null)
		{
			super(meshName,true,$renderList);
			this._segments = segments;
			this._depth = depth;
			this._height = height;
			this._width = width;
			if (!material)
			{
				material=new ShaderBase("FrDirectionCube",new TransformFilter(),new ColorFilter(0.6,0.6,0.6,1),this.materialPrams);
			};
			var _m:FrSurface3D= new FrSurface3D(meshName);
			this.setSurface(0,_m);
			_m.addVertexData(FilterName_ID.POSITION_ID,3,false,null);
			_m.addVertexData(FilterName_ID.NORMAL_ID,3,false,null);
			_m.addVertexData(FilterName_ID.UV_ID,2,false,null);
			_m.indexVector = new Vector.<uint>();
			this.createPlane(width, height, (depth * 0.5), segments, 0, "+xy");
			this.createPlane(width, height, (depth * 0.5), segments, 1, "-xy");
			this.createPlane(depth, height, (width * 0.5), segments, 2, "+yz");
			this.createPlane(depth, height, (width * 0.5), segments, 3, "-yz");
			this.createPlane(width, depth, (height * 0.5), segments, 4, "+xz");
			this.createPlane(width, depth, (height * 0.5), segments, 5, "-xz");
			this.setMaterial( material,Texture3D.MIP_NONE ,material.name);
			var _local7:Number = (Math.max(width, height, depth) * 0.5);
			bounds = new Boundings3D();
			bounds.max.setTo((width * 0.5), (height * 0.5), (depth * 0.5));
			bounds.min.setTo((-(width) * 0.5), (-(height) * 0.5), (-(depth) * 0.5));
			bounds.length = bounds.max.subtract(bounds.min);
			bounds.radius = Vector3D.distance(bounds.center, bounds.max);
			
		}
		
		private function createPlane(_arg1:Number, _arg2:Number, _arg3:Number, segments:int, index:int, _arg6:String):void
		{
			var _local7:int;
			var _local8:int;
			var _local9:Number;
			var _local10:Number;
			var _local11:Number;
			var _local12:Number;
			var _local13:FrSurface3D = this.getSurface(0);
			var _vertexVector:Vector.<Number>=_local13.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector;
			var _local14:Matrix3D = new Matrix3D();
			if (_arg6 == "+xy")
			{
				Matrix3DUtils.setOrientation(_local14, new Vector3D(0, 0, -1));
			}
			else
			{
				if (_arg6 == "-xy")
				{
					Matrix3DUtils.setOrientation(_local14, new Vector3D(0, 0, 1));
				}
				else
				{
					if (_arg6 == "+xz")
					{
						Matrix3DUtils.setOrientation(_local14, new Vector3D(0, 1, 0));
					}
					else
					{
						if (_arg6 == "-xz")
						{
							Matrix3DUtils.setOrientation(_local14, new Vector3D(0, -1, 0));
						}
						else
						{
							if (_arg6 == "+yz")
							{
								Matrix3DUtils.setOrientation(_local14, new Vector3D(1, 0, 0));
							}
							else
							{
								if (_arg6 == "-yz")
								{
									Matrix3DUtils.setOrientation(_local14, new Vector3D(-1, 0, 0));
								};
							};
						};
					};
				};
			};
			Matrix3DUtils.setScale(_local14, _arg1, _arg2, 1);
			Matrix3DUtils.translateZ(_local14, _arg3);
			var _local15:Vector.<Number> = _local14.rawData;
			var _local16:Vector3D = Matrix3DUtils.getDir(_local14);
			_local7 = (_vertexVector.length / _local13.sizePerVertex);
			_local8 = _local7;
			_local10 = 0;
			
			
			var peru:Number=1/3;
			var perv:Number=1/2;
			var offu:Number=1-peru*(index%3);
			var offv:Number=1-int(index/3)*perv;
			while (_local10 <= segments)
			{
				_local9 = 0;
				var pery:Number=_local10 / segments;
				while (_local9 <= segments)
				{
					_local11 = ((_local9 / segments) - 0.5);
					_local12 = (pery - 0.5);
					_vertexVector.push(
						(((_local11 * _local15[0]) + (_local12 * _local15[4])) + _local15[12]),(((_local11 * _local15[1]) + (_local12 * _local15[5])) + _local15[13]),(((_local11 * _local15[2]) + (_local12 * _local15[6])) + _local15[14]),
						_local16.x, _local16.y, _local16.z,
						(offu - _local9 / segments * peru), (offv - pery*perv)
					);
					_local7++;
					_local9++;
				};
				_local10++;
			};
			var _indexVector:Vector.<uint>=_local13.indexVector
			_local7 = _indexVector.length;
			_local10 = 0;
			while (_local10 < segments)
			{
				_local9 = 0;
				while (_local9 < segments)
				{
					
					_indexVector[_local7++] = (((_local9 + 1) + (_local10 * (segments + 1))) + _local8);
					
					_indexVector[_local7++] = (((_local9 + 1) + ((_local10 + 1) * (segments + 1))) + _local8);
					
					_indexVector[_local7++] = ((_local9 + ((_local10 + 1) * (segments + 1))) + _local8);
					
					_indexVector[_local7++] = ((_local9 + (_local10 * (segments + 1))) + _local8);
					
					_indexVector[_local7++] = (((_local9 + 1) + (_local10 * (segments + 1))) + _local8);
					
					_indexVector[_local7++] = ((_local9 + ((_local10 + 1) * (segments + 1))) + _local8);
					
					_local9++;
				};
				_local10++;
			};
		}
		public function get segments():int
		{
			return (this._segments);
		}
		public function get depth():Number
		{
			return (this._depth);
		}
		public function get height():Number
		{
			return (this._height);
		}
		public function get width():Number
		{
			return (this._width);
		}
		
	}
}

//package flare.primitives
