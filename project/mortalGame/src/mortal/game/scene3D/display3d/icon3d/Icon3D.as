package mortal.game.scene3D.display3d.icon3d
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;

	public class Icon3D extends Pivot3D
	{
		private var _targetVector:Vector.<Number>;
		private var _ix:int;
		private var _iy:int;
		private var _iz:int;
		private var _iw:int;
		private var _isShowing:Boolean=false;
		public var bigImgUrl:String;
		private var posValue:uint=0;
		public function Icon3D($bigImgUrl:String)
		{
			super("");
			bigImgUrl=$bigImgUrl;
			this.addEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT,visibleChangeHander);
		}

		public override function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			this.removeEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT,visibleChangeHander);
		}
		public function reInit(targetVector:Vector.<Number>):void
		{
			_targetVector=targetVector;
			_ix=targetVector.length;
			_iy=_ix+1;
			_iz=_ix+2;
			_iw=_ix+3;
			_targetVector[_ix]=0;
			_targetVector[_iy]=0;
			_targetVector[_iz]=0;
			_targetVector[_iw]=posValue;
			_isShowing=true;
			_updataPos=true;
			if(_targetVector.length>400)
			{
				throw new Error("超出icon3d范围");
			}
		}
		private static var _temp0:Vector3D = new Vector3D();
		public override function update():void
		{
			if(_updataPos)
			{
				var _pos:Vector3D=this.getPosition(false,_temp0);
				_targetVector[_ix]=_pos.x;
				_targetVector[_iy]=_pos.y;
				_targetVector[_iz]=_pos.z;
				_updataPos=false;
			}
			
		}
		public function setImgPos(xid:uint,yid:uint):void
		{
			posValue=yid*8+xid;
			if(_isShowing)
			{
				_targetVector[_iw]=posValue;
			}
		}
		public function show():void
		{
			_targetVector[_iw]=posValue;
			_isShowing=true;
		}
		public function hide():void
		{
			_targetVector[_iw]=-1;
			_isShowing=false;
		}

		private function visibleChangeHander(e:Event):void
		{
			if(this.visible)
			{
				show();
			}else
			{
				hide();
			}
		}
		private var _updataPos:Boolean=false;
		public override function updateChildrenTransform():void
		{
			this.worldTransformChanged = true;
			_updataPos=true;
		}
		public override  function updateTransforms(updateLocle:Boolean , updateChildren:Boolean):void
		{
			this.worldTransformChanged = true;
			var _pos:Vector3D=this.getPosition(false,_temp0);
			_targetVector[_ix]=_pos.x;
			_targetVector[_iy]=_pos.y;
			_targetVector[_iz]=_pos.z;
			_updataPos=false;

		}
		
	}
}