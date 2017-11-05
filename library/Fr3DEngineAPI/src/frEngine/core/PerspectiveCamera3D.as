package frEngine.core
{
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Camera3D;
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.core.lenses.PerspectiveLens;
	import frEngine.math.FrMathUtil;
	
	public class PerspectiveCamera3D extends Camera3D
	{
		private var _lens:PerspectiveLens;
		private static var _inv:Matrix3D;
		private var _tempPos:Vector3D=new Vector3D();
		private var _direction:Vector3D=new Vector3D();
		public function PerspectiveCamera3D(_arg1:String="", _arg2:Number=30)
		{
			_lens=new PerspectiveLens(_arg2);
			super(_arg1, _arg2, lens);
		}
		/**
		 * 获取一个屏幕上的点在世界坐标系中的方向
		 * @param _arg1
		 * @param _arg2
		 * @param _arg3
		 * @return 
		 * 
		 */		
		public override function getPointDir(screenX:Number, screenY:Number, resultCameraPos:Vector3D=null):Vector3D
		{
			if (!resultCameraPos)
			{
				resultCameraPos = new Vector3D();
			};
			screenToCamera(screenX,screenY,1,resultCameraPos);
			Matrix3DUtils.deltaTransformVector(world, resultCameraPos, resultCameraPos);
			return (resultCameraPos);
		}
		public override function screenToCamera(screenX:Number, screenY:Number,depthZ:Number, resultCameraPos:Vector3D):void
		{
			
			var _local4:Rectangle = Device3D.scene.viewPort;
			if (!_local4)
			{
				return;
			};
			
			screenX = (screenX - _local4.x);
			screenY = (screenY - _local4.y);
			resultCameraPos.x = (((screenX / _local4.width) - 0.5) * 2);
			resultCameraPos.y = (((-(screenY) / _local4.height) + 0.5) * 2);
			resultCameraPos.z = depthZ;
			_inv = ((_inv) || (new Matrix3D()));
			_inv.copyFrom(this.projection);
			_inv.invert();
			Matrix3DUtils.transformVector(_inv, resultCameraPos, resultCameraPos);//从屏幕到相机坐标
			resultCameraPos.x *= resultCameraPos.w;
			resultCameraPos.y *= resultCameraPos.w;//实际相机坐标值
		}
		
		/**
		 * 获取屏幕上的点与指定世界坐标点之间的距离
		 */
		public override function getScreenMouseDistance(screenX:Number,screenY:Number,worldPoint3d:Vector3D):Number
		{
			getPointDir(screenX,screenY,_direction);
			getPosition(false,_tempPos);
			return FrMathUtil.pointToLineDistance2(worldPoint3d,_tempPos,_direction);
		}
		public override function updateProj(cameraRect:Rectangle,targetProjection:Matrix3D):void
		{
			var _local4:Number;
			var _local5:Number;
			
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
			}
			if (isNaN(_local3))
			{
				_local3 = (_local4 / _local5);
			};
			
			_lens.fieldOfView=this.fieldOfView;
			_lens.near = this.near;
			_lens.far = this.far;
			_lens.aspectRatio=_local3;
			
			targetProjection.copyFrom(_lens.matrix);
		}
		override public function clone():Pivot3D
		{
			var _local2:Pivot3D;
			var _local1:PerspectiveCamera3D = new PerspectiveCamera3D(name);
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
	}
}