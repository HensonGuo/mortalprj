package frEngine.primitives
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Surface3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.core.FrSurface3D;
	import frEngine.render.FrPlaneRender;
	import frEngine.render.layer.Layer3DManager;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.vertexFilters.TransformFilter;



	public class FrPlane extends Mesh3D
	{

		private var _width:Number;
		private var _height:Number;
		private var _segments:int;
		private var _axis:String;
		
		private static var _surfXY:FrSurface3D;
		private static var _surfXYNeg:FrSurface3D
		private static var _surfXZ:FrSurface3D;
		private static var _surfXZNeg:FrSurface3D
		private static var _surfYZ:FrSurface3D;
		private static var _surfYZNeg:FrSurface3D
		public var offsetMatrix:Matrix3D=new Matrix3D();
		public function FrPlane(_arg1:String,$renderList:RenderList, $width:Number = 10, $height:Number = 10, $material:Material3D = null, $axis:String = "+xy")
		{
			
			super(_arg1, true, $renderList);
			
			if (!$material)
			{
				$material = new ShaderBase("FrPlane", new TransformFilter(), new ColorFilter(0.3, 0.3, 0.3, 1),this.materialPrams);
			}
			
			this.setMateiralBlendMode(Material3D.BLEND_LIGHT);
			this.materialPrams.depthWrite=false;
			this.materialPrams.twoSided=true;
			this.setLayer(Layer3DManager.AlphaLayer0);
			this._axis = $axis;
			this._segments = 1;
			this._height = $height;
			this._width = $width;
			
			switch($axis)
			{
				case "+xy":	
					!_surfXY 	&& (_surfXY=createPlane(1,$axis));		
					this.setSurface(0, _surfXY);	
					offsetMatrix.appendScale($width,$height,1);
					break;
				case "-xy":	
					!_surfXYNeg && (_surfXYNeg=createPlane(1,$axis));	
					this.setSurface(0, _surfXYNeg);
					offsetMatrix.appendScale($width,$height,1);
					break;
				case "+xz":	
					!_surfXZ 	&& (_surfXZ=createPlane(1,$axis));		
					this.setSurface(0, _surfXZ);	
					offsetMatrix.appendScale($width,1,$height);
					break;
				case "-xz":	
					!_surfXZNeg && (_surfXZNeg=createPlane(1,$axis));	
					this.setSurface(0, _surfXZNeg);
					offsetMatrix.appendScale($width,1,$height);
					break;
				case "+yz":	
					!_surfYZ 	&& (_surfYZ=createPlane(1,$axis));		
					this.setSurface(0, _surfYZ);	
					offsetMatrix.appendScale(1,$width,$height);
					break;
				case "-yz":	
					!_surfYZNeg && (_surfYZNeg=createPlane(1,$axis));	
					this.setSurface(0, _surfYZNeg);
					offsetMatrix.appendScale(1,$width,$height);
					break;
			}
			
			
			
			this.setMaterial($material,Texture3D.MIP_NONE,$material.name);
			
			updateBounds();
			
			this.render=FrPlaneRender.instance;
		}
		
		/*public override function setMaterial(_arg1:*,mipType:int):void
		{
			super.setMaterial(_arg1,mipType);
			this.priority=HelpUtils.getSortIdByName("#plane#"+this.axis);
		}*/
		
		public override function disposeSurfaces():void
		{
			this.surfaces = new Vector.<FrSurface3D>();
		}
		private function updateBounds():void
		{
			var _maxW:Number = width * 0.5;
			var _maxH:Number = height * 0.5;
			var bounds:Boundings3D = new Boundings3D();
			if (this._axis.indexOf("xy") != -1)
			{
				bounds.max.setTo(_maxW, _maxH, 0);
				bounds.min.setTo(-_maxW, -_maxH, 0);
			}
			else
			{
				if (this._axis.indexOf("xz") != -1)
				{
					bounds.max.setTo(_maxW, 0, _maxH);
					bounds.min.setTo(-_maxW, 0, -_maxH);
				}
				else
				{
					if (this._axis.indexOf("yz") != -1)
					{
						bounds.max.setTo(0, _maxW, _maxH);
						bounds.min.setTo(0, -_maxW, -_maxH);
					}
					
				}
				
			}
			
			bounds.length = bounds.max.subtract(bounds.min);
			bounds.radius = Vector3D.distance(bounds.center, bounds.max);
			this.bounds=bounds;
		}
		/*public override function update():void
		{
			super.update();
		}*/
		private static function createPlane($segments:int,$axis:String):FrSurface3D
		{
			var _local7:int;
			var _local8:Number;
			var _local9:Number;
			var _local10:Number;
			var _local11:Number;

			var _local16:FrSurface3D = new FrSurface3D("plane");
			
			_local16.addVertexData(FilterName_ID.POSITION_ID, 3, false, null);
			_local16.addVertexData(FilterName_ID.NORMAL_ID, 3, false, null);
			_local16.addVertexData(FilterName_ID.UV_ID, 2, false, null);
			var _vector:Vector.<Number>=_local16.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector
			var _local12:Matrix3D = new Matrix3D();
			if ($axis == "+xy")
			{
				Matrix3DUtils.setOrientation(_local12, new Vector3D(0, 0, -1));
			}
			else
			{
				if ($axis == "-xy")
				{
					Matrix3DUtils.setOrientation(_local12, new Vector3D(0, 0, 1));
				}
				else
				{
					if ($axis == "+xz")
					{
						Matrix3DUtils.setOrientation(_local12, new Vector3D(0, 1, 0));
						//_local12.appendRotation(90,Vector3D.Y_AXIS);
					}
					else
					{
						if ($axis == "-xz")
						{
							Matrix3DUtils.setOrientation(_local12, new Vector3D(0, -1, 0));
							//_local12.appendRotation(90,Vector3D.Y_AXIS);
						}
						else
						{
							if ($axis == "+yz")
							{
								Matrix3DUtils.setOrientation(_local12, new Vector3D(1, 0, 0));
							}
							else
							{
								if ($axis == "-yz")
								{
									Matrix3DUtils.setOrientation(_local12, new Vector3D(-1, 0, 0));
								}
								else
								{
									Matrix3DUtils.setOrientation(_local12, new Vector3D(0, 0, -1));
								}
								
							}
							
						}
						
					}
					
				}
				
			}
			
			//Matrix3DUtils.setScale(_local12, $width, $height, 1);
			var _local13:Vector.<Number> = _local12.rawData;
			var _local14:Vector3D = Matrix3DUtils.getDir(_local12);
			
			_local7 = 0;
			_local9 = 0;
			while (_local9 <= $segments)
			{
				_local8 = 0;
				while (_local8 <= $segments)
				{
					_local10 = ((_local8 / $segments) - 0.5);
					_local11 = ((_local9 / $segments) - 0.5);
					_vector.push(_local10 * _local13[0] + _local11 * _local13[4] + _local13[12], _local10 * _local13[1] + _local11 * _local13[5] + _local13[13], _local10 * _local13[2] + _local11 * _local13[6] + _local13[14], _local14.x, _local14.y, _local14.z,_local8 / $segments,1- _local9 / $segments );
					_local7++;
					_local8++;
				}
				
				_local9++;
			}
			
			_local7 = 0;
			_local9 = 0;
			var _indexVector:Vector.<uint>=_local16.indexVector;
			while (_local9 < $segments)
			{
				_local8 = 0;
				while (_local8 < $segments)
				{
					
					_indexVector[_local7++] = ((_local8 + 1) + (_local9 * ($segments + 1)));
					
					_indexVector[_local7++] = ((_local8 + 1) + ((_local9 + 1) * ($segments + 1)));
					
					_indexVector[_local7++] = (_local8 + ((_local9 + 1) * ($segments + 1)));
					
					_indexVector[_local7++] = (_local8 + (_local9 * ($segments + 1)));
					
					_indexVector[_local7++] = ((_local8 + 1) + (_local9 * ($segments + 1)));
					
					_indexVector[_local7++] = (_local8 + ((_local9 + 1) * ($segments + 1)));
					_local8++;
				}
				
				_local9++;
			}
			return _local16;
			//_local16.updateBoundings();
		}
		public function get axis():String
		{
			return (this._axis);
		}

		public function get segments():int
		{
			return (this._segments);
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
} //package flare.primitives

