package frEngine.core
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Camera3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.core.lenses.OrthographicLens;
	import frEngine.math.FrMathUtil;
	
	public class OrthographicCamera3D extends Camera3D 
	{
		private var _lens:OrthographicLens;
		private var _tempPos:Vector3D=new Vector3D();
		private var _direction:Vector3D=new Vector3D();
		private static var _inv:Matrix3D;
		public function OrthographicCamera3D(_arg1:String="", _arg2:Number=75)
		{
			_lens= new OrthographicLens()
			super(_arg1,_arg2, _lens);
		}

		public function setSceenScale($scaleX:Number,$scaleY:Number):void
		{
			_lens.setScale($scaleX,$scaleY);
			
		}
		public override function updateProj(cameraRect:Rectangle,targetProjection:Matrix3D):void
		{
			var _local4:Number;
			var _local5:Number;
			var _local1:Number = this.near;
			var _local2:Number = this.far;
			var _local3:Number = this.aspectRatio;
			var _local6:Scene3D = ((this.scene) || (Device3D.scene));
			if (cameraRect)
			{
				_local4 = cameraRect.width;
				_local5 = cameraRect.height;
			}
			else
			{
				if(!_local6 || !_local6.viewPort)
				{
					return;
				}
				_local4 = _local6.viewPort.width;
				_local5 = _local6.viewPort.height;
				
			};
			if (isNaN(_local3))
			{
				_local3 = (_local4 / _local5);
			};
			
			_lens.projectionHeight=_local5/this.zoom;
			_lens.aspectRatio=_local3;
 
			targetProjection.copyFrom(_lens.matrix);
		}
		
		override public function clone():Pivot3D
		{
			var _local2:Pivot3D;
			var _local1:OrthographicCamera3D = new OrthographicCamera3D(name);
			_local1.copyFrom(this);
			_local1.near = this.near;
			_local1.far = this.far;
			_local1.fieldOfView = this.fieldOfView;
			for each (_local2 in children)
			{
				if (!_local2.lock)
				{
					_local1.addChild(_local2.clone());
				};
			};
			return (_local1);
		}
		public override function screenToCamera(screenX:Number, screenY:Number,depthZ:Number, resultCameraPos:Vector3D):void
		{
			
			resultCameraPos.x=screenX;
			resultCameraPos.y=screenY;
			resultCameraPos.z=depthZ*(this.far-this.near)+this.near;
			
		}
		public override function getPointDir(screenX:Number, screenY:Number, resultCameraPos:Vector3D=null):Vector3D
		{
			if (!resultCameraPos)
			{
				resultCameraPos = new Vector3D();
			};
			this.getDir(false,_direction);
			resultCameraPos.x = _direction.x
			resultCameraPos.y = _direction.y;
			resultCameraPos.z = _direction.z;
			return (resultCameraPos);
		}
		public override function getScreenMouseDistance(screenX:Number,screenY:Number,worldPoint3d:Vector3D):Number
		{
			var _local4:Rectangle = Device3D.scene.viewPort;
			if (!_local4)
			{
				return Number.MAX_VALUE;
			};
			
			
			screenX = (screenX - _local4.x);
			screenY = (screenY - _local4.y);
			_tempPos.x = (((screenX / _local4.width) - 0.5) * 2);
			_tempPos.y = (((-(screenY) / _local4.height) + 0.5) * 2);
			_tempPos.z = 1;
			
			_inv = ((_inv) || (new Matrix3D()));
			_inv.copyFrom(this.projection);
			_inv.invert();
			Matrix3DUtils.transformVector(_inv, _tempPos, _tempPos);//从屏幕坐标转换到相机坐标
			Matrix3DUtils.transformVector(world, _tempPos, _tempPos);//从相机坐标转到世界坐标
			getDir(false,_direction);

			return FrMathUtil.pointToLineDistance2(worldPoint3d,_tempPos,_direction);
		}
		
	}
}


