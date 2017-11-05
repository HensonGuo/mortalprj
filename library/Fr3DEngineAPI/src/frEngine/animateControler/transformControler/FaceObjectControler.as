package frEngine.animateControler.transformControler
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Pivot3D;
	import baseEngine.modifiers.Modifier;
	import baseEngine.system.Device3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.keyframe.AnimateControlerType;

	public class FaceObjectControler extends Modifier
	{
		private var _faceCameraMatrix3d:Matrix3D = new Matrix3D();

		private var _right:Vector3D = new Vector3D();
		private var _dir:Vector3D = new Vector3D();
		private var _temp:Vector3D = new Vector3D();
		
		private var _faceObject:Pivot3D;
		private var _isFaceCamera:Boolean = false;
		private var _const1:Number = 180 / Math.PI;
		private var _axis:Vector3D;
		private static const ZERO:Vector3D = new Vector3D();

		private var _hasChange:Boolean=true;
		private var _curTargetObject3dParent:Pivot3D;

		public function FaceObjectControler()
		{
			
		}

		public function setFaceObject(value:Pivot3D,$axis:Vector3D=null):void
		{
			if(_faceObject)
			{
				_faceObject.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,transformChangeHander);
			}
			_faceObject = value;
			_isFaceCamera = (_faceObject == Device3D.camera);
			if(_isFaceCamera)
			{
				Device3D.scene.addEventListener(Engine3dEventName.CHANGE_CAMERA,changeCameraHander);
			}else
			{
				Device3D.scene.removeEventListener(Engine3dEventName.CHANGE_CAMERA,changeCameraHander);
			}
			_faceCameraMatrix3d=targetObject3d.transform
			_axis=$axis;
			if(_axis)
			{
				_axis.normalize();
				_axis.w = 0;
			}
			_faceObject.addEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,transformChangeHander);
		}
		private function changeCameraHander(e:Event):void
		{
			setFaceObject(Device3D.camera,_axis);
			_hasChange=true;
		}

		public override function set targetObject3d(value:Pivot3D):void
		{
			if(_curTargetObject3dParent)
			{
				_curTargetObject3dParent.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,transformChangeHander);
				_curTargetObject3dParent=null;
			}
			if(targetObject3d)
			{
				targetObject3d.removeEventListener(Engine3dEventName.PARENT_CHANGE_EVENT,addTargetParentTransformChange);
			}
			super.targetObject3d=value;
			
			if(value)
			{
				_curTargetObject3dParent=value.parent;
				if(_curTargetObject3dParent)
				{
					_curTargetObject3dParent.addEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,transformChangeHander);
				}
				value.addEventListener(Engine3dEventName.PARENT_CHANGE_EVENT,addTargetParentTransformChange);
			}
			
		}
		private function addTargetParentTransformChange(e:Event):void
		{
			if(_curTargetObject3dParent)
			{
				_curTargetObject3dParent.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,transformChangeHander);
			}
			_curTargetObject3dParent=targetObject3d.parent;
			if(_curTargetObject3dParent)
			{
				_curTargetObject3dParent.addEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,transformChangeHander);
			}
			
		}
		private function transformChangeHander(e:Event):void
		{
			_hasChange=true;
		}
		public override function get type():int
		{
			return AnimateControlerType.NodeFaceObject;
		}

		public override function toUpdateAnimate(forceUpdate:Boolean=false):void
		{
			if( (!forceUpdate && !_hasChange) || !targetObject3d.parent)
			{
				return;
			}
			_hasChange=false;
			if (_isFaceCamera)
			{
				
				if(_axis)
				{
					_axis.normalize();
					Device3D.camera.getDir(true, _right);
					
					targetObject3d.parent.globalToLocalVector(_right,_right);
					
					_right = _right.crossProduct(_axis);
					_right.normalize();
					_dir = _axis.crossProduct(_right);
					
					_right.w = 0;
					_dir.w = 0;
					
					_right.scaleBy(targetObject3d.scaleX);
					_axis.scaleBy(targetObject3d.scaleY);
					_dir.scaleBy(targetObject3d.scaleZ);
					
					_faceCameraMatrix3d.copyColumnFrom(0, _right);
					_faceCameraMatrix3d.copyColumnFrom(1, _axis);
					_faceCameraMatrix3d.copyColumnFrom(2, _dir);
					
					_faceCameraMatrix3d.copyColumnFrom(3,targetObject3d.pos);
					targetObject3d.setTransform(_faceCameraMatrix3d,true);
				}else
				{
					var p:Vector3D=Device3D.camera.pos;
					Matrix3DUtils.lookAt(targetObject3d.world , p.x , p.y , p.z );
					targetObject3d.world=targetObject3d.world;
				}
			}
			else
			{
				_faceObject.getPosition(false,_temp);
				Matrix3DUtils.lookAt(targetObject3d.world , _temp.x , _temp.y , _temp.z );
				targetObject3d.world=targetObject3d.world;
			}
		}
		public override function dispose():void
		{
			_faceObject &&　_faceObject.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,transformChangeHander);
			targetObject3d.removeEventListener(Engine3dEventName.PARENT_CHANGE_EVENT,addTargetParentTransformChange);
			Device3D.scene.removeEventListener(Engine3dEventName.CHANGE_CAMERA,changeCameraHander);
			if(_curTargetObject3dParent)
			{
				_curTargetObject3dParent.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,transformChangeHander);
				_curTargetObject3dParent=null;
			}
			
			_faceObject=null;
			super.dispose();
		}

	}
}

