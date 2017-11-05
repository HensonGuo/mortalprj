package mortal.game.scene3D.display3d.text3d.dynamicText3d
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	
	import frEngine.Engine3dEventName;
	
	import mortal.game.scene3D.display3d.text3d.Text3DPlace;
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;

	public class Text3D extends Pivot3D
	{
		public var place:Text3DPlace;
		private var _targetVector:Vector.<Number>;
		private var _ix:int;
		private var _iy:int;
		private var _iz:int;
		private var _iw:int;
		private var _isShowing:Boolean = false;
		public var textValue:String;
		public var bigImg:Text3DBigImg;
		private var _offsetY:uint = 0;
		public var textWidth:int = 0;
		public var textHeight:int = 0

		public function Text3D()
		{
			super("");
			this.addEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT, visibleChangeHander);
		}

		public override function dispose(isReuse:Boolean = true):void
		{
			super.dispose(isReuse);
			this.removeEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT, visibleChangeHander);
		}


		private function visibleChangeHander(e:Event):void
		{
			if (this.visible)
			{
				show();
			}
			else
			{
				hide();
			}
		}

		public function clear():void
		{
			bigImg = null;
			_targetVector = null;
			this.removeEventListener(Engine3dEventName.VISIBLE_CHANGE_EVENT, visibleChangeHander);
		}

		public function reInit($bigImg:Text3DBigImg,$place:Text3DPlace):void
		{
			bigImg = $bigImg;
			
			place=$place;
			_targetVector = place.targetVector;
			_ix = place.placeId*4;
			_iy = _ix + 1;
			_iz = _ix + 2;
			_iw = _ix + 3;
			
			_targetVector[_ix] = 0;
			_targetVector[_iy] = 0;
			_targetVector[_iz] = 0;
			_targetVector[_iw] = textHeight;
			_isShowing = true;
			
			if (_targetVector.length > 400)
			{
				throw new Error("超出范围");
			}
		}

		public function setImgPos($offsetY:uint, _w:uint, _h:uint,$textValue:String):void
		{
			textHeight = _h;
			textWidth = _w;
			_offsetY = $offsetY;
			textValue = $textValue;
			_targetVector[_iz] = _offsetY
			show();
		}

		public function show():void
		{
			_targetVector[_iw] = textHeight;
			_isShowing = true;
		}

		public function hide():void
		{
			_targetVector[_iw] = -1;
			_isShowing = false;
		}
		private static var _temp0:Vector3D = new Vector3D();
		private var _updataPos:Boolean=false;
		public override function update():void
		{
			if(_updataPos)
			{
				var _pos:Vector3D=this.getPosition(false,_temp0);
				var pos2d:Point=Scene3DUtil.change3Dto2D(_pos);
				_targetVector[_ix] = int(pos2d.x);
				_targetVector[_iy] = int(pos2d.y);
				_updataPos=false;
			}
		}

		public override function updateChildrenTransform():void
		{
			this.worldTransformChanged = true;
			_updataPos=true;
		}

		public override function updateTransforms(updateLocle:Boolean, updateChildren:Boolean):void
		{
			this.worldTransformChanged = true;
			var _pos:Vector3D=this.getPosition(false,_temp0);
			var pos2d:Point=Scene3DUtil.change3Dto2D(_pos);
			_targetVector[_ix] = int(pos2d.x);
			_targetVector[_iy] = int(pos2d.y);
			_updataPos=false;
		}

	}
}
