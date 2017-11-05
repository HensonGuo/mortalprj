package mortal.game.scene3D.display3d.blood
{
	import com.gengine.debug.Log;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;
	
	import mortal.component.window.DebugWindow;

	public class Blood3D extends Pivot3D
	{
		private var _targetVector:Vector.<Number>;
		private var _ix:int;
		private var _iy:int;
		private var _iz:int;
		private var _iw:int;
		private var _isShowing:Boolean=false;
		private var _rate:Number=1;
		public function Blood3D()
		{
			super("");
			this.addEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT,visibleChangeHander);
			
		}
		public function set bloodRate(value:Number):void
		{
			if(_rate>1 || _rate<0)
			{
				Log.debugLog.print("出错了，血量为："+value+"，应为0，1之间，所以不显示血量！");
			}
			_rate=1-value;
			if(_isShowing)
			{
				_targetVector[_iw]=_rate;
			}
		}
		private static var _temp0:Vector3D = new Vector3D();
		private var _updataPos:Boolean=false;
		public function reInit(targetVector:Vector.<Number>):void
		{
			_targetVector=targetVector;
			_ix=targetVector.length;
			_iy=_ix+1;
			_iz=_ix+2;
			_iw=_ix+3;
			_updataPos=true;
			_targetVector[_ix]=0;
			_targetVector[_iy]=0;
			_targetVector[_iz]=0;
			_targetVector[_iw]=_rate;
			_isShowing=true;
			if(_targetVector.length>400)
			{
				throw new Error("超出范围");
			}
		}
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
		public function show():void
		{
			_targetVector[_iw]=_rate;
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