package mortal.game.scene3D.display3d.text3d.staticText3d
{
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	
	import mortal.game.scene3D.display3d.text3d.Stext3DPlace;
	import mortal.game.scene3D.display3d.text3d.staticText3d.action.Action0MoveFun;
	import mortal.game.scene3D.display3d.text3d.staticText3d.action.Action1MoveFun;
	import mortal.game.scene3D.display3d.text3d.staticText3d.action.ActionMoveBase;
	import mortal.game.scene3D.display3d.text3d.staticText3d.action.ActionVo;
	
	public class Stext3DBox extends Pivot3D
	{
		public var list:Vector.<SText3D>;
		public var startFrame:uint;
		private var _x:Number=0;
		private var _y:Number=0;
		private var _z:Number=0;
		private var _targetBox:Pivot3D;

		private var _place:Stext3DPlace;
		private var _setTextWidth:Number=0;
		private var _targetVector:Vector.<Number>;
		private var _ix:int;
		private var _iy:int;
		private var _iz:int;
		private var _iw:int;
		private var _isShowing:Boolean = true;
		private var _gx:Number=0;
		private var _gy:Number=0;
		private var _gz:Number=0;

		private var _result:Vector3D=new Vector3D();
		private var _preframe:int=-1;
		private var _action0:ActionMoveBase;
		private var _action1:ActionMoveBase;
		private var _curAction:ActionMoveBase;
		private var _updataPos:Boolean=false;
		public function Stext3DBox(_arg1:String)
		{
			super(_arg1);
		}

		public override function set x(value:Number):void
		{
			this._x=value;
			_updataPos=true;
		}
		
		public override function set y(value:Number):void
		{
			this._y=value;
			_updataPos=true;
			
		}
		public override function set z(value:Number):void
		{
			this._z=value;
			_updataPos=true;
		}
		
		public override function get x():Number
		{
			return _x;
		}
		public override function get y():Number
		{
			return _y;
		}
		public override function get z():Number
		{
			return _z;
		}
		
		public function get textWidth():Number
		{
			return _setTextWidth;
		}
		
		public function set textWidth(value:Number):void
		{
			_setTextWidth=value;
		}
		
		private static var _temp0:Vector3D = new Vector3D();
		
		private function updatePos(e:Event=null):void
		{
			_updataPos=true;
			
		}
		
		
		
		public override function update():void
		{
			var frame:int=TimeControler.stageFrame-this.startFrame;
			if(_preframe==frame)
			{
				return;
			}
			_preframe=frame;

			if(_updataPos)
			{
				var _pos:Vector3D=_targetBox.getPosition(false,_temp0);
				_gx = _pos.x+this._x;
				_gy = _pos.y+this._y;
				_gz = _pos.z+this._z;
				_targetVector[_iz] = _gz;
				_updataPos=false;
			}
			if(_curAction.update(frame,_result))
			{
				_targetVector[_ix] = _gx+_result.x;
				_targetVector[_iy] = _gy+_result.y;
				_targetVector[_iw] = _result.z;

			}else
			{
				SText3DFactory.instance.disposeText3D(this);
			}
			
		}

		public function set place(value:Stext3DPlace):void
		{
			_place=value;
			_ix = _place.placeId*4;
			_iy = _ix + 1;
			_iz = _ix + 2;
			_iw = _ix + 3;
			_targetVector=_place.targetVector.list;
			/*_targetVector[_ix] = _gx+_result.x;
			_targetVector[_iy] = _gy+_result.y;
			_targetVector[_iz] = _gz;
			_targetVector[_iw] = _result.z;*/
			_updataPos=true;
		}
		public function get place():Stext3DPlace
		{
			return _place;
		}

		public function reInit($startFrame:int,text3dList:Vector.<SText3D>,$place:Stext3DPlace,$textWidth:Number,$parent:Pivot3D,$actionVo:ActionVo):void
		{
			list = text3dList;
			startFrame = $startFrame;
			textWidth=$textWidth;
			place=$place;
			_curAction=getAction($actionVo);
			_targetBox && _targetBox.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,updatePos);
			_targetBox=$parent;
			_targetBox.addEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,updatePos);
			updatePos(null);
			if(this.parent==null)
			{
				Device3D.scene.addChild(this);
			}
		}

		private function getAction($actionVo:ActionVo):ActionMoveBase
		{
			var _action:ActionMoveBase;
			if($actionVo.type==1)
			{
				if(!_action0)
				{
					_action0=new Action0MoveFun();
				}
				_action=_action0;
				
			}else
			{
				if(!_action1)
				{
					_action1=new Action1MoveFun();
				}
				_action=_action1;
			}
			_action.vo=$actionVo;
			return _action;
		}
		public function show():void
		{
			_targetVector[_iw] = _result.z;
			_isShowing = true;
			_targetBox && _targetBox.addEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,updatePos);
		}
		
		public function hide():void
		{
			_targetVector[_iw] = -1000;
			_isShowing = false;
			_targetBox && _targetBox.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,updatePos);
		}

		public function clear(clearEvent:Boolean):void
		{
			if(this.place)
			{
				this.hide();
				this.place.targetVector.clearSplace(this.place);
			}
			
			if(clearEvent)
			{
				_targetBox && _targetBox.removeEventListener(Engine3dEventName.UPDATE_TRANSFORM_EVENT,updatePos);
				_targetBox=null;
				if(this.parent)
				{
					this.parent.removeChild(this);
				}
			}
			
		}
		
	}
}