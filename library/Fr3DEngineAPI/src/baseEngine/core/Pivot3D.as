


//flare.core.Pivot3D

package baseEngine.core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.core.frame.TransformFrame;
	import baseEngine.materials.Material3D;
	import baseEngine.modifiers.Modifier;
	import baseEngine.system.Device3D;
	import baseEngine.system.Input3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.Engine3dEventName;
	import frEngine.TimeControler;
	import frEngine.animateControler.FightObjectControler;
	import frEngine.animateControler.Md5SkinAnimateControler;
	import frEngine.animateControler.colorControler.ColorControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.particleControler.LineRoadControler;
	import frEngine.animateControler.transformControler.FaceObjectControler;
	import frEngine.animateControler.transformControler.PosXControler;
	import frEngine.animateControler.transformControler.PosYControler;
	import frEngine.animateControler.transformControler.PosZControler;
	import frEngine.animateControler.transformControler.RotationXControler;
	import frEngine.animateControler.transformControler.RotationYControler;
	import frEngine.animateControler.transformControler.RotationZControler;
	import frEngine.animateControler.transformControler.ScaleXControler;
	import frEngine.animateControler.transformControler.ScaleXYZControler;
	import frEngine.animateControler.transformControler.ScaleYControler;
	import frEngine.animateControler.transformControler.ScaleZControler;
	import frEngine.animateControler.visible.VisibleControler;
	import frEngine.effectEditTool.temple.ETempleType;
	import frEngine.shader.ShaderBase;

	public class Pivot3D extends EventDispatcher
	{
		public var isDisposeToPool:Boolean = false;
		//public var lineRoadMesh3d:LineRoadMesh3D;
		private static const padToAngle:Number = 180 / Math.PI;
		private static const angleTopad:Number = Math.PI / 180;

		protected static const MOUSE_OVER:int = 1;
		protected static const MOUSE_OUT:int = (1 << 1);
		protected static const ENTER_DRAW_FLAG:int = (1 << 2);
		protected static const EXIT_DRAW_FLAG:int = (1 << 3);
		protected static const UPDATE_TRANSFORM_FLAG:int = (1 << 4);
		
		public static const VISIBLE_FLAG:int = (1 << 5);
		public static const PIVOT3D_UPDATE_FLAG:int = (1 << 6);

		protected static const _enterDrawEvent:Event = new Event(Engine3dEventName.ENTER_DRAW_EVENT);
		protected static const _exitDrawEvent:Event = new Event(Engine3dEventName.EXIT_DRAW_EVENT);
		
		protected static const _mouseOverEvent:Event = new Event(Engine3dEventName.MOUSE_OVER);
		protected static const _mouseOutEvent:Event = new Event(Engine3dEventName.MOUSE_OUT);
		
		protected static const _updateTransformEvent:Event = new Event(Engine3dEventName.UPDATE_TRANSFORM_EVENT);
		protected static const _visibleChangeEvent:Event = new Event(Engine3dEventName.VISIBLE_CHANGE_EVENT);
		protected static const _pivot3d_update:Event = new Event(Engine3dEventName.PIVOT3D_UPDATE,false,true);
		

		public static const SORT_NONE:int = 0;
		public static const SORT_CENTER:int = 1;
		public static const SORT_NEAR:int = 2;
		public static const SORT_FAR:int = 4;

		private static var _temp0:Vector3D = new Vector3D();
		private static var _temp1:Vector3D = new Vector3D();
		private static var _temp2:Vector3D = new Vector3D();
		private static var _dragTarget:Pivot3D;
		private static var _dragStartPos:Vector3D;
		private static var _dragStartDir:Vector3D;
		private static var _dragOffset:Vector3D;

		private var _transform:Matrix3D;
		private var _name:String;

		public var priority:int = 0;
		public var layer:int = 0;
		public var lock:Boolean = false;
		private var _vector:Vector3D;
		private var _children:Vector.<Pivot3D>;
		private var _visible:Boolean = true;
		private var _invGlobal:Matrix3D;
		private var _parent:Pivot3D;
		protected var _scene:Scene3D;
		private var _inScene:Boolean;
		protected var _sortMode:int = 1;
		public var _eventFlags:uint;
		private var _world:Matrix3D;

		private var _frameNull:Boolean;

		private var _updatable:Boolean = false;
		protected var _animateControlerList:Dictionary = new Dictionary(false);
		public var timerContorler:TimeControler;
		public var visibleControler:VisibleControler;
		private var _curHangControler:Md5SkinAnimateControler;
		
		private static const _matrix:Vector.<Number> = Vector.<Number>([0 , 0 , 0 , 1 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 1 , 0 , 0 , 0 , 1]);

		private var _pos:Vector3D = new Vector3D(0 , 0 , 0 , 1);

		private var _rot:Vector3D = new Vector3D();

		private var _scale:Vector3D = new Vector3D(1,1,1,1);

		public var worldTransformChanged:Boolean = false;
		private var localTransformChanged:Boolean = false;
		public var _dirtyInv:Boolean = false;
		public var isHide:Boolean = false;

		public function Pivot3D(_arg1:String)
		{
			super();
			this.name = _arg1;
			timerContorler = TimeControler.createTimerInstance(-1);
			this._transform = new Matrix3D();
			this._children = new Vector.<Pivot3D>();
			this._invGlobal = new Matrix3D();
			this._world = new Matrix3D();
		}

		
		
		public function set curHangControler(value:Md5SkinAnimateControler):void
		{
			_curHangControler=value;
		}
		
		public function setTempleParams(type:String,hasPassFrame:int,minDistance:Number,params:*):void
		{
			var controler:FightObjectControler=this.getAnimateControlerInstance(AnimateControlerType.FightObject) as FightObjectControler;
			
			switch(type)
			{
				case ETempleType.Fight:
					controler.resetMultyEmmiter(params,hasPassFrame,minDistance);
					break;
			}

		}
		
		public function get curHangControler():Md5SkinAnimateControler
		{
			return _curHangControler;
		}
		
		public function contains(child:Pivot3D):Boolean
		{
			return this.children && this.children.indexOf(child)!=-1;
		}
		final public function get transform():Matrix3D
		{
			if (localTransformChanged)
			{
				rebuildTransform();
			}
			return _transform;
		}

		public function setTransform(value:Matrix3D , update:Boolean):void
		{
			if (value == null)
			{
				throw new Error("transform不能为空");
			}

			this._transform = value;

			if (update)
			{
				var v:Vector.<Vector3D> = _transform.decompose();
				var t:Vector3D = v[0];
				var r:Vector3D = v[1];
				var s:Vector3D = v[2];
				_pos = t;
				_pos.w = 1;
				_rot = r;
				_rot.scaleBy(padToAngle);
				_scale.setTo(s.x,s.y,s.z);
			}

			updateTransforms(false , true);
		}
		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get animateControlerList():Dictionary
		{
			return _animateControlerList;
		}

		public function hasControler(type:int):Boolean
		{
			if (type == -1)
			{
				for each (var p:Modifier in _animateControlerList)
				{
					return true;
				}
				return false;
			}
			else
			{
				return _animateControlerList[type] != null;
			}

		}

		public function removeAnimateControler(animateControlerType:int):void
		{
			var modifier:Modifier = _animateControlerList[animateControlerType];
			if (modifier != null)
			{
				modifier.dispose();
				delete _animateControlerList[animateControlerType];
			}
			if (animateControlerType == AnimateControlerType.VisibleContoler)
			{
				visibleControler.dispose();
				visibleControler = null;
			}

		}

		public function clearAllControlers(dispose:Boolean):void
		{
			if (dispose)
			{
				for each (var p:Modifier in _animateControlerList)
				{
					p.dispose();
				}
				if (visibleControler)
				{
					visibleControler.dispose();
				}
			}
			visibleControler = null;
			_animateControlerList = new Dictionary(false);
		}

		public function copyToControlers(dic:Dictionary , $visibleControler:VisibleControler):void
		{
			if ($visibleControler)
			{
				getAnimateControlerInstance($visibleControler.type , $visibleControler);
			}
			if (!dic)
			{
				return;
			}
			for each (var p:Modifier in dic)
			{
				getAnimateControlerInstance(p.type , p);
				p.toUpdateAnimate(true);
			}
		}

		public function getAnimateControlerInstance(animateControlerType:int , instane:Modifier = null):Modifier
		{
			var modifier:Modifier;
			if (animateControlerType == AnimateControlerType.VisibleContoler)
			{
				if (!this.visibleControler)
				{
					modifier = instane ? instane : new VisibleControler();
					modifier.targetObject3d = this;
					this.visibleControler = VisibleControler(modifier);
				}

				return this.visibleControler;
			}

			modifier = _animateControlerList[animateControlerType];
			if (modifier == null)
			{
				switch (animateControlerType)
				{
					case AnimateControlerType.PosX:
						modifier = instane ? instane : new PosXControler();
						break;
					case AnimateControlerType.PosY:
						modifier = instane ? instane : new PosYControler();
						break;
					case AnimateControlerType.PosZ:
						modifier = instane ? instane : new PosZControler();
						break;
					case AnimateControlerType.ScaleX:
						modifier = instane ? instane : new ScaleXControler();
						break;
					case AnimateControlerType.ScaleY:
						modifier = instane ? instane : new ScaleYControler();
						break;
					case AnimateControlerType.ScaleZ:
						modifier = instane ? instane : new ScaleZControler();
						break;
					case AnimateControlerType.ScaleXYZ:
						modifier = instane ? instane : new ScaleXYZControler();
						break;
					case AnimateControlerType.RotationX:
						modifier = instane ? instane : new RotationXControler();
						break;
					case AnimateControlerType.RotationY:
						modifier = instane ? instane : new RotationYControler();
						break;
					case AnimateControlerType.RotationZ:
						modifier = instane ? instane : new RotationZControler();
						break;
					case AnimateControlerType.NodeFaceObject:
						modifier = instane ? instane : new FaceObjectControler();
						break;
					case AnimateControlerType.FightObject:
						modifier = instane ? instane : new FightObjectControler();
						break;
					case AnimateControlerType.colorAnimateControler:
						modifier = instane ? instane : new ColorControler();
						break;
					case AnimateControlerType.LineRoadControler:
						modifier = instane ? instane : new LineRoadControler();
						break;
					
				}
				if (modifier)
				{
					if (modifier is VisibleControler)
					{
						this.visibleControler = modifier as VisibleControler;
					}
					else
					{
						_animateControlerList[animateControlerType] = modifier;
					}

					modifier.targetObject3d = this;
				}

			}

			return modifier;
		}

		public function upload(_arg1:Scene3D , _arg2:Boolean = true):void
		{
			var _local3:Pivot3D;
			this._scene = _arg1;
			if (_arg2)
			{
				for each (_local3 in this._children)
				{
					_local3.upload(_arg1 , _arg2);
				}
			}
		}

		public function download(_arg1:Boolean = true):void
		{
			var _local2:Pivot3D;
			if (_arg1)
			{
				for each (_local2 in this._children)
				{
					_local2.download(_arg1);
				}
	
			}

		}

		public function copyFrom(_arg1:Pivot3D):void
		{
			var _local2:TransformFrame;
			var _local3:int;
			this.transform.copyFrom(_arg1.transform);
			this.visible = _arg1.visible;

			this.layer = _arg1.layer;
			this.lock = _arg1.lock;
		/* if (((((this.frames) && (this.frames.length))) && ((this.frames[0].type == TransformFrame.TYPE_NULL))))
		{
		this.frames = this.frames.concat();
		_local2 = new TransformFrame(this.transform.rawData, TransformFrame.TYPE_NULL);
		_local3 = 0;
		while (_local3 < this.frames.length)
		{
		this.frames[_local3] = _local2;
		_local3++;
		};
		this.transform = _local2;
		};*/
		}

		public function clone():Pivot3D
		{
			var _local2:Pivot3D;
			var _local1:Pivot3D = new Pivot3D(this.name);
			_local1.copyFrom(this);
			for each (_local2 in this.children)
			{
				if (!_local2.lock)
				{
					_local1.addChild(_local2.clone());
				}
	
			}

			return (_local1);
		}

		public function dispose(isReuse:Boolean=true):void
		{
			clearAllControlers(!isReuse);
			//dispatchEvent(new Event(Engine3dEventName.UNLOAD_EVENT));

			var _local2:int = this._children.length;
			var _local3:int;
			while (_local3 < _local2)
			{
				this._children.length>0 && this._children[0].dispose();
				_local3++;
			}


			if (this.parent)
			{
				this.parent.removeChild(this);
			}

			if (curHangControler)
			{
				curHangControler.removeHang(this);
			}

			curHangControler = null;
			this.parent = null;
			this._scene = null;
			this._vector = null;
			this.name = "";
			
			_pos.setTo(0,0,0);
			_rot.setTo(0,0,0);
			_scale.setTo(1,1,1);
			
			this._transform = new Matrix3D();
			this._children = new Vector.<Pivot3D>();
			this._invGlobal = new Matrix3D();
			this._world = new Matrix3D();
			
			
		}

		public function setPosition(_arg1:Number , _arg2:Number , _arg3:Number , _arg5:Boolean = true):void
		{
			if (_arg1 == _pos.x && _arg2 == _pos.y && _arg3 == _pos.z)
			{
				return;
			}
			
			_pos.setTo(_arg1 , _arg2 , _arg3);
			
			if (((!(_arg5)) && (this._parent)))
			{
				this._parent.globalToLocal(_pos , _pos);
			}

			this._transform.copyColumnFrom(3 , _pos);
			updateTransforms(false , true);
		}

		public function getPosition(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{
			if (_arg2 == null)
			{
				_arg2 = new Vector3D();
			}

			if (_arg1)
			{
				this.transform.copyColumnTo(3 , _arg2);
			}
			else
			{
				this.world.copyColumnTo(3 , _arg2);
			}

			return (_arg2);
		}

		public function setScale(xScale:Number , yScale:Number , zScale:Number):void
		{
			//Matrix3DUtils.setScale(this._transform, _arg1, _arg2, _arg3, _arg4);
			var needUpdata:Boolean = false;
			if (this._scale.x != xScale)
			{
				this._scale.x = xScale;
				needUpdata = true;
			}
			if (this._scale.y != yScale)
			{
				this._scale.y = yScale;
				needUpdata = true;
			}
			if (this._scale.z != zScale)
			{
				this._scale.z = zScale;
				needUpdata = true;
			}

			if (needUpdata)
			{
				updateTransforms(true , true);
			}


		}

		public function getScale(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{
			_arg2 = Matrix3DUtils.getScale(((_arg1) ? this.transform : this.world) , _arg2);
			return (_arg2);
		}

		/**
		 * 旋转 
		 * @param xRadians 沿着x轴旋转的弧度
		 * @param yRadians 沿着y轴旋转的弧度
		 * @param zRadians 沿着z轴旋转的弧度
		 * 
		 */		
		public function setRotation(xRadians:Number , yRadians:Number , zRadians:Number):void
		{
			//Matrix3DUtils.setRotation(this._transform, _arg1, _arg2, _arg3);
			//this.updateChildrenTransform(true);
			var needUpdata:Boolean = false;
			if (this._rot.x != xRadians)
			{
				this._rot.x = xRadians;
				needUpdata = true;
			}
			if (this._rot.y != yRadians)
			{
				this._rot.y = yRadians;
				needUpdata = true;
			}
			if (this._rot.z != zRadians)
			{
				this._rot.z = zRadians;
				needUpdata = true;
			}

			if (needUpdata)
			{
				updateTransforms(true , true);
			}
		}

		public function getRotation(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{

			if (_arg1)
			{
				_arg2 = _rot;
			}
			else
			{
				if (_arg2 == null)
				{
					_arg2 = new Vector3D();
				}
				_arg2 = Matrix3DUtils.getRotation(this.world , _arg2);
			}

			return (_arg2);
		}

		public function lookAt(_arg1:Number , _arg2:Number , _arg3:Number , _arg4:Vector3D = null , _arg5:Number = 1):void
		{
			Matrix3DUtils.lookAt(this.transform , _arg1 , _arg2 , _arg3 , _arg4 , _arg5);
			this.setTransform(_transform , true);
		}

		public function setOrientation(_arg1:Vector3D , _arg2:Vector3D = null , _arg3:Number = 1):void
		{
			Matrix3DUtils.setOrientation(this.transform , _arg1 , _arg2 , _arg3);
			this.setTransform(_transform , true);
		}

		public function setNormalOrientation(_arg1:Vector3D , _arg2:Number = 1):void
		{
			Matrix3DUtils.setNormalOrientation(this.transform , _arg1 , _arg2);
			this.setTransform(_transform , true);
		}

		public function rotateX(_arg1:Number , _arg2:Boolean = true , _arg3:Vector3D = null):void
		{
			this.rotateAxis(_arg1 , ((_arg2) ? this.getRight(true , _temp2) : Vector3D.X_AXIS) , _arg3);
		}

		public function rotateY(_arg1:Number , _arg2:Boolean = true , _arg3:Vector3D = null):void
		{
			this.rotateAxis(_arg1 , ((_arg2) ? this.getUp(true , _temp2) : Vector3D.Y_AXIS) , _arg3);
		}

		public function rotateZ(_arg1:Number , _arg2:Boolean = true , _arg3:Vector3D = null):void
		{
			this.rotateAxis(_arg1 , ((_arg2) ? this.getDir(true , _temp2) : Vector3D.Z_AXIS) , _arg3);
		}

		public function rotateAxis(_arg1:Number , _arg2:Vector3D , _arg3:Vector3D = null):void
		{
			_temp0.copyFrom(_arg2);
			_temp0.normalize();
			if (!_arg3)
			{
				this.transform.copyColumnTo(3 , _temp1);
				this.transform.appendRotation(_arg1 , _temp0 , _temp1);
			}
			else
			{
				this.transform.appendRotation(_arg1 , _temp0 , _arg3);
			}

			this.setTransform(_transform , true);
		}

		public function get x():Number
		{
			return _pos.x;
		}

		

		/**
		 * @private
		 */
		public function set x(value:Number):void
		{
			if (_pos.x != value)
			{
				_pos.x = value;
				this._transform.copyColumnFrom(3 , _pos);
				updateTransforms(false , true);
			}
		}

		/**
		 * Y coordinate.
		 */
		public function get y():Number
		{
			
			return _pos.y;
		}

		/**
		 * @private
		 */
		public function set y(value:Number):void
		{
			if (_pos.y != value)
			{
				_pos.y = value;
				this._transform.copyColumnFrom(3 , _pos);
				updateTransforms(false , true);
			}
		}

		/**
		 *  Z coordinate.
		 */
		public function get z():Number
		{
			return _pos.z;
		}

		/**
		 * @private
		 */
		public function set z(value:Number):void
		{
			if (_pos.z != value)
			{
				_pos.z = value;
				this._transform.copyColumnFrom(3 , _pos);
				updateTransforms(false , true);
			}
		}

		public function get pos():Vector3D
		{
			return _pos;
		}

		public function get rot():Vector3D
		{
			//this.transform.decompose(Orientation3D.AXIS_ANGLE);
			return _rot;
		}
		
		public function get scale():Vector3D
		{
			return _scale;
		}

		/**
		 *  The  angle of rotation of <code>Object3D</code> around the X-axis expressed in radians.
		 */
		public function get rotationX():Number
		{
			return _rot.x;
		}

		
		public function set rotationX(value:Number):void
		{
			if (_rot.x != value)
			{
				_rot.x = value;
				updateTransforms(true , true);
			}
		}

		/**
		 * The  angle of rotation of <code>Object3D</code> around the Y-axis expressed in radians.
		 */
		public function get rotationY():Number
		{
			return _rot.y;
		}

		/**
		 * @private
		 */
		public function set rotationY(value:Number):void
		{
			if (_rot.y != value)
			{
				_rot.y = value;
				updateTransforms(true , true);
			}
		}

		/**
		 * The  angle of rotation of <code>Object3D</code> around the Z-axis expressed in radians.
		 */
		public function get rotationZ():Number
		{
			return _rot.z;
		}

		/**
		 * @private
		 */
		public function set rotationZ(value:Number):void
		{
			if (_rot.z != value)
			{
				_rot.z = value;
				updateTransforms(true , true);
			}
		}

		/**
		 * The scale of the <code>Object3D</code> along the X-axis.
		 */
		public function get scaleX():Number
		{
			return this._scale.x;
		}

		/**
		 * @private
		 */
		public function set scaleX(value:Number):void
		{
			if (this._scale.x != value)
			{
				this._scale.x = value;
				updateTransforms(true , true);
			}
		}
		/**
		 * The scale of the <code>Object3D</code> along the Y-axis.
		 */
		public function get scaleY():Number
		{
			return this._scale.y;
		}

		/**
		 * @private
		 */
		public function set scaleY(value:Number):void
		{
			if (this._scale.y != value)
			{
				this._scale.y = value;
				updateTransforms(true , true);
			}
		}

		/**
		 * The scale of the <code>Object3D</code> along the Z-axis.
		 */
		public function get scaleZ():Number
		{
			return this._scale.z;
		}

		/**
		 * @private
		 */
		public function set scaleZ(value:Number):void
		{
			if (this._scale.z != value)
			{
				this._scale.z = value;
				updateTransforms(true , true);
			}
		}

		[inline]
		final protected function rebuildTransform():void
		{
			localTransformChanged = false;
			
			/*var cosX:Number = Math.cos(_rot.x*angleTopad);
			var sinX:Number = Math.sin(_rot.x*angleTopad);
			var cosY:Number = Math.cos(_rot.y*angleTopad);
			var sinY:Number = Math.sin(_rot.y*angleTopad);
			var cosZ:Number = Math.cos(_rot.z*angleTopad);
			var sinZ:Number = Math.sin(_rot.z*angleTopad);
			var cosZsinY:Number = cosZ*sinY;
			var sinZsinY:Number = sinZ*sinY;
			var cosYscaleX:Number = cosY*_scaleX;
			var sinXscaleY:Number = sinX*_scaleY;
			var cosXscaleY:Number = cosX*_scaleY;
			var cosXscaleZ:Number = cosX*_scaleZ;
			var sinXscaleZ:Number = sinX*_scaleZ;

			_matrix[0] = cosZ*cosYscaleX;
			_matrix[1] = cosZsinY*sinXscaleY - sinZ*cosXscaleY;
			_matrix[2] = cosZsinY*cosXscaleZ + sinZ*sinXscaleZ;
			_matrix[3] = pos.x;
			_matrix[4] = sinZ*cosYscaleX;
			_matrix[5] = sinZsinY*sinXscaleY + cosZ*cosXscaleY;
			_matrix[6] = sinZsinY*cosXscaleZ - cosZ*sinXscaleZ;
			_matrix[7] = pos.y;
			_matrix[8] = -sinY*_scaleX;
			_matrix[9] = cosY*sinXscaleY;
			_matrix[10] = cosY*cosXscaleZ;
			_matrix[11] = pos.z;
			_transform.copyRawDataFrom(_matrix,0,true);*/

			//var len:Number=_rot.normalize();
			var len:Number = _rot.length;
			
			_transform.identity();

			this._scale.x == 0 && (this._scale.x = 0.0001);
			this._scale.y == 0 && (this._scale.y = 0.0001);
			this._scale.z == 0 && (this._scale.z = 0.0001);

			_transform.appendScale(this._scale.x , this._scale.y , this._scale.z);
			
			_rot.x!=0 && _transform.appendRotation(_rot.x , Vector3D.X_AXIS);
			_rot.y!=0 && _transform.appendRotation(_rot.y , Vector3D.Y_AXIS);
			_rot.z!=0 && _transform.appendRotation(_rot.z , Vector3D.Z_AXIS);

			_transform.copyColumnFrom(3 , _pos);

		}


		public function setTranslation(_arg1:Number = 0 , _arg2:Number = 0 , _arg3:Number = 0 , _arg4:Boolean = true):void
		{
			Matrix3DUtils.setTranslation(this.transform , _arg1 , _arg2 , _arg3 , _arg4);
			this.setTransform(_transform , true);
		}

		public function translateX(_arg1:Number , _arg2:Boolean = true):void
		{
			Matrix3DUtils.translateX(this.transform , _arg1 , _arg2);
			this.setTransform(_transform , true);
		}

		public function translateY(_arg1:Number , _arg2:Boolean = true):void
		{
			Matrix3DUtils.translateY(this.transform , _arg1 , _arg2);
			this.setTransform(_transform , true);
		}

		public function translateZ(_arg1:Number , _arg2:Boolean = true):void
		{
			Matrix3DUtils.translateZ(this.transform , _arg1 , _arg2);
			this.setTransform(_transform , true);
		}

		public function translateAxis(_arg1:Number , _arg2:Vector3D):void
		{
			Matrix3DUtils.translateAxis(this.transform , _arg1 , _arg2);
			this.setTransform(_transform , true);
		}

		public function copyTransformFrom(_arg1:Pivot3D , _arg2:Boolean = true):void
		{
			if (_arg2)
			{
				this._transform.copyFrom(_arg1.transform);
				this.setTransform(_transform , true);
			}
			else
			{
				this.world = _arg1.world;
			}

		}

		public function resetTransforms():void
		{
			this.transform.identity();
			this.updateTransforms(true , true);
		}

		public function getRight(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{
			return (Matrix3DUtils.getRight(((_arg1) ? this.transform : this.world) , _arg2));
		}

		public function getLeft(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{
			return (Matrix3DUtils.getLeft(((_arg1) ? this.transform : this.world) , _arg2));
		}

		public function getUp(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{
			return (Matrix3DUtils.getUp(((_arg1) ? this.transform : this.world) , _arg2));
		}

		public function getDown(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{
			return (Matrix3DUtils.getDown(((_arg1) ? this.transform : this.world) , _arg2));
		}

		public function getDir(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{
			return (Matrix3DUtils.getDir(((_arg1) ? this.transform : this.world) , _arg2));
		}

		public function getBackward(_arg1:Boolean = true , _arg2:Vector3D = null):Vector3D
		{
			return (Matrix3DUtils.getBackward(((_arg1) ? this.transform : this.world) , _arg2));
		}

		public function localToGlobal(_arg1:Vector3D , _arg2:Vector3D = null):Vector3D
		{
			_arg2 = ((_arg2) || (new Vector3D()));
			Matrix3DUtils.transformVector(this.world , _arg1 , _arg2);
			return (_arg2);
		}

		public function localToGlobalVector(_arg1:Vector3D , _arg2:Vector3D = null):Vector3D
		{
			_arg2 = ((_arg2) || (new Vector3D()));
			Matrix3DUtils.deltaTransformVector(this.world , _arg1 , _arg2);
			return (_arg2);
		}

		public function globalToLocal(_arg1:Vector3D , _arg2:Vector3D = null):Vector3D
		{
			if (_arg2 == null)
			{
				_arg2 = new Vector3D();
			}

			Matrix3DUtils.transformVector(this.invWorld , _arg1 , _arg2);
			return (_arg2);
		}

		public function globalToLocalVector(_arg1:Vector3D , _arg2:Vector3D = null):Vector3D
		{
			if (_arg2 == null)
			{
				_arg2 = new Vector3D();
			}

			Matrix3DUtils.deltaTransformVector(this.invWorld , _arg1 , _arg2);
			return (_arg2);
		}

		public function getScreenCoords(_arg1:Vector3D = null , _arg2:Camera3D = null , _arg3:Rectangle = null):Vector3D
		{
			if (!_arg1)
			{
				_arg1 = new Vector3D();
			}

			if (((!(_arg3)) && (!(this.scene))))
			{
				throw(new Error("The object isn't in the scene"));
			}

			if (!_arg2)
			{
				_arg2 = Device3D.camera;
			}

			if (!_arg3)
			{
				_arg3 = Device3D.scene.viewPort;
			}

			var _local4:Vector3D = _arg2.viewProjection.transformVector(this.getPosition(false , _arg1));
			var _local5:Number = (_arg3.width * 0.5);
			var _local6:Number = (_arg3.height * 0.5);
			_arg1.x = ((((_local4.x / _local4.w) * _local5) + _local5) + _arg3.x);
			_arg1.y = ((((-(_local4.y) / _local4.w) * _local6) + _local6) + _arg3.y);
			_arg1.z = _local4.z;
			_arg1.w = _local4.w;
			return (_arg1);
		}

		public function startDrag(_arg1:Boolean = false , _arg2:Vector3D = null):void
		{
			var _local3:Vector3D;
			var _local4:Vector3D;
			if (!this.scene)
			{
				throw(new Error("The object isn't in the scene"));
			}

			if (_dragStartPos)
			{
				return;
			}

			if (((_dragTarget) && (!((_dragTarget == this)))))
			{
				_dragTarget.stopDrag();
			}

			_dragOffset = ((_dragOffset) || (new Vector3D()));
			_dragStartDir = ((_arg2) || (Device3D.camera.getDir(false)));
			_dragStartPos = this.getPosition(false);
			_dragTarget = this;
			if (!_arg1)
			{
				this.getPosition(false , _dragOffset);
				_local3 = Device3D.camera.getPosition(false);
				_local4 = Device3D.camera.getPointDir(Input3D.mouseX , Input3D.mouseY);
				_dragOffset.decrementBy(this.rayPlanePosition(_dragStartDir , _dragStartPos , _local3 , _local4));
			}

			this.scene.addEventListener(Engine3dEventName.PIVOT3D_UPDATE , this.updateDragEvent , false , 0 , true);
		}

		private function rayPlanePosition(_arg1:Vector3D , _arg2:Vector3D , _arg3:Vector3D , _arg4:Vector3D):Vector3D
		{
			var _local5:Number = (-((_arg1.dotProduct(_arg3) - _arg1.dotProduct(_arg2))) / _arg1.dotProduct(_arg4));
			return (new Vector3D((_arg3.x + (_arg4.x * _local5)) , (_arg3.y + (_arg4.y * _local5)) , (_arg3.z + (_arg4.z * _local5))));
		}

		private function updateDragEvent(_arg1:Event):void
		{
			if (_dragTarget != this)
			{
				return;
			}

			dispatchEvent(new Event("enterDrag"));
			var _local2:Camera3D = Device3D.camera;
			var _local3:Vector3D = Device3D.camera.getPosition(false);
			var _local4:Vector3D = Device3D.camera.getPointDir(Input3D.mouseX , Input3D.mouseY);
			var _local5:Vector3D = this.rayPlanePosition(_dragStartDir , _dragStartPos , _local3 , _local4);
			this.setPosition((_local5.x + _dragOffset.x) , (_local5.y + _dragOffset.y) , (_local5.z + _dragOffset.z) , false);
			dispatchEvent(new Event("exitDrag"));
		}

		public function stopDrag():void
		{
			this.scene.removeEventListener(Engine3dEventName.PIVOT3D_UPDATE , this.updateDragEvent);
			_dragStartPos = null;
			_dragStartDir = null;
			_dragTarget = null;
		}

		private var  _offsetTransform:Matrix3D;
		public function set offsetTransform(value:Matrix3D):void
		{
			_offsetTransform=value;
			updateChildrenTransform();
		}
		
		public function get offsetTransform():Matrix3D
		{
			return _offsetTransform;
		}
		public function identityOffsetTransform():void
		{
			if(_offsetTransform)
			{
				_offsetTransform.identity();
				updateChildrenTransform();
			}
		}
		final public function get world():Matrix3D
		{
			if (this.localTransformChanged || this.worldTransformChanged)
			{
				if (this.localTransformChanged)
				{
					this.rebuildTransform();
				}

				this._world.copyFrom(this._transform);
				
				if(_offsetTransform)
				{
					this._world.append(_offsetTransform);
				}
				
				if (((this._parent) && (!((this._parent == this._scene)))))
				{
					this._world.append(this._parent.world);
				}
				
				this.worldTransformChanged = false;
				this._dirtyInv = true;
			}

			return (this._world);
		}

		final public function set world(_arg1:Matrix3D):void
		{
			this.transform.copyFrom(_arg1);
			if (this.parent)
			{
				this._transform.append(this.parent.invWorld);
			}

			this.setTransform(_transform , true);
			this.updateTransforms(true , true);
		}

		final public function get invWorld():Matrix3D
		{
			if (_dirtyInv || this.localTransformChanged || this.worldTransformChanged)
			{
				this._invGlobal.copyFrom(this.world);
				this._invGlobal.invert();
				_dirtyInv = false;

			}

			return (this._invGlobal);
		}

		public function updateTransforms(updateLocle:Boolean , updateChildren:Boolean):void
		{
			this.worldTransformChanged = true;
			if (updateLocle)
			{
				this.localTransformChanged = true;
			}
			if (this._eventFlags & UPDATE_TRANSFORM_FLAG)
			{
				dispatchEvent(_updateTransformEvent);
			}

			if (updateChildren)
			{
				updateChildrenTransform();
			}

		}

		public function updateChildrenTransform():void
		{

			if (this._children)
			{
				var _local2:int;
				var _local3:int;
				_local2 = this._children.length;
				_local3 = 0;
				while (_local3 < _local2)
				{
					this._children[_local3].updateTransforms(false,true);
					_local3++;
				}
	
			}

			this.worldTransformChanged = true;
		}

		final public function get children():Vector.<Pivot3D>
		{
			return (this._children);
		}


		final public function get parent():Pivot3D
		{
			return (this._parent);
		}

		final public function set parent(_arg1:Pivot3D):void
		{
			var _local2:int;
			if (_arg1 == this._parent)
			{
				return;
			}

			if (this._parent)
			{
				_local2 = this._parent.children.indexOf(this);
				if (_local2 != -1)
				{
					this._parent.children.splice(_local2 , 1);
					this.dispatchEvent(new Event(Engine3dEventName.REMOVED_EVENT));
				}
	
			}

			this._parent = _arg1;
			if (_arg1)
			{
				_arg1.children.push(this);
				this.updateChildrenTransform()
				this.dispatchEvent(new Event(Engine3dEventName.ADDED_EVENT));
			}

			if (!this._inScene)
			{
				if (_arg1)
				{
					if ((_arg1 is Scene3D))
					{
						this.addedToScene((_arg1 as Scene3D));
					}
					else
					{
						if (_arg1._inScene)
						{
							this.addedToScene(_arg1.scene);
						}
			
					}
		
				}
	
			}
			else
			{
				if (!_arg1)
				{
					this.removedFromScene();
				}
				else
				{
					if (((!((_arg1 is Scene3D))) && (!(_arg1._inScene))))
					{
						this.removedFromScene();
					}
		
				}
	
			}

			this.dispatchEvent(new Event(Engine3dEventName.PARENT_CHANGE_EVENT));
		}

		public function addedToScene(_arg1:Scene3D):void
		{
			var _local2:Pivot3D;
			this._scene = _arg1;
			
			
			this._inScene = true;
			
			
			for each (_local2 in this._children)
			{
				_local2.addedToScene(this._scene);
			}

		}

		public function removedFromScene():void
		{
			var _local1:Pivot3D;
			this._scene = null;
			this._inScene = false;
			dispatchEvent(new Event(Engine3dEventName.REMOVED_FROM_SCENE_EVENT));
			for each (_local1 in this._children)
			{
				_local1.removedFromScene();
			}

		}


		public function addChild(_arg1:Pivot3D):Pivot3D
		{
			if (_arg1.parent == this)
			{
				return (_arg1);
			}


			_arg1.parent = this;


			return (_arg1);
		}

		public function removeChild(_arg1:Pivot3D):Pivot3D
		{
			_arg1.parent = null;
			return (_arg1);
		}

		public function getChildByName(_arg1:String , _arg2:int = -1 , _arg3:Boolean = true):Pivot3D
		{
			var _local4:Pivot3D;
			var _local5:Pivot3D;
			for each (_local4 in this._children)
			{
				if ((((_local4.name == _arg1)) && ((_arg2-- < 0))))
				{
					return (_local4);
				}
	
				if (_arg3)
				{
					_local5 = _local4.getChildByName(_arg1 , _arg2 , _arg3);
					if (_local5)
					{
						return (_local5);
					}
		
				}
	
			}

			return (null);
		}

		public function update():void
		{
			if (this.visibleControler)
			{
				this.visibleControler.toUpdateAnimate();
			}

			if (this.visible)
			{
				for each (var p:Modifier in _animateControlerList)
				{
					p.toUpdateAnimate();
				}

			}

			if ((this._eventFlags & PIVOT3D_UPDATE_FLAG))
			{
				dispatchEvent(_pivot3d_update);
			};
			for each (var child:Pivot3D in this.children)
			{
				child.update();
			}

		/* if ((this._eventFlags & ENTER_FRAME_FLAG))
		{
		dispatchEvent(_enterFrameEvent);
		};

		if ((this._eventFlags & EXIT_FRAME_FLAG))
		{
		dispatchEvent(_exitFrameEvent);
		};*/

		}

		final public function get visible():Boolean
		{
			return (this._visible);
		}

		final public function set visible(_arg1:Boolean):void
		{
			if(this._visible ==_arg1)
			{
				return;
			}
			var _preVisible:Boolean = _visible;
			var _local2:Pivot3D;
			this._visible = _arg1;
			/*for each (_local2 in this._children)
			{
			_local2.visible = _arg1;
			};*/
			if ((this._eventFlags & VISIBLE_FLAG) && _preVisible != _arg1)
			{
				dispatchEvent(_visibleChangeEvent);
			}

		}

		final public function get scene():Scene3D
		{
			return (this._scene);
		}

		/*public function setMaterial($material:*, _arg2:Boolean=true):void
		{
			var _local3:Pivot3D;
			if (_arg2)
			{
				for each (_local3 in this._children)
				{
					_local3.setMaterial($material, _arg2);
				};
			};
		}*/
		/*public function show():void
		{
			this._visible = true;
		}

		public function hide():void
		{
			this._visible = false;
		}*/

		public function draw(_drawChildren:Boolean=true, _material:ShaderBase=null):void
		{
			var _local3:Pivot3D;
			if ((this._eventFlags & ENTER_DRAW_FLAG))
			{
				dispatchEvent(_enterDrawEvent);
			}

			if (_drawChildren)
			{
				for each (_local3 in this.children)
				{
					_local3.draw(_drawChildren , _material);
				}
	
			}

			if ((this._eventFlags & EXIT_DRAW_FLAG))
			{
				dispatchEvent(_exitDrawEvent);
			}

		}

		/*public function completeDraw():void
		{

		}*/
		public function get sortMode():int
		{
			return (this._sortMode);
		}

		public function set sortMode(_arg1:int):void
		{
			this._sortMode = _arg1;
		}

		public function get inView():Boolean
		{
			return (true);
		}

		public function setLayer(_arg1:int , _arg2:Boolean = true):void
		{
			var _local3:Pivot3D;
			this.layer = _arg1;
			if (_arg2)
			{
				for each (_local3 in this._children)
				{
					_local3.setLayer(_arg1 , _arg2);
				}
	
			}

		}

		public function forEach(_arg1:Function , _arg2:Class = null , _arg3:Object = null , _arg4:Boolean = true):void
		{
			var _local5:Pivot3D;
			for each (_local5 in this._children)
			{
				if (!_arg2)
				{
					if (_arg3)
					{
						(_arg1(_local5 , _arg3));
					}
					else
					{
						(_arg1(_local5));
					}
		
				}
				else
				{
					if ((_local5 is _arg2))
					{
						if (_arg3)
						{
							(_arg1(_local5 , _arg3));
						}
						else
						{
							(_arg1(_local5));
						}
			
					}
		
				}
	
				if (_arg4)
				{
					_local5.forEach(_arg1 , _arg2 , _arg3 , _arg4);
				}
	
			}

		}

		public function getMaterialByName(_arg1:String , _arg2:Boolean = true):Material3D
		{
			var _local3:Pivot3D;
			var _local4:Material3D;
			if (!_arg2)
			{
				return (null);
			}

			for each (_local3 in this.children)
			{
				_local4 = _local3.getMaterialByName(_arg1 , _arg2);
				if (_local4)
				{
					return (_local4);
				}
	
			}

			return (null);
		}

		public function replaceMaterial(_arg1:Material3D , _arg2:Material3D , _arg3:Boolean = true):void
		{
			var _local4:Pivot3D;
			if (_arg1 == _arg2)
			{
				throw(new Error("Source and replaceFor parameters are the same instances!"));
			}

			if (_arg3)
			{
				for each (_local4 in this._children)
				{
					_local4.replaceMaterial(_arg1 , _arg2 , _arg3);
				}
	
			}

		}

		override public function addEventListener(_arg1:String , _arg2:Function , _arg3:Boolean = false , _arg4:int = 0 , _arg5:Boolean = false):void
		{
			var _local6:uint = this._eventFlags;
			switch (_arg1)
			{
				case Engine3dEventName.MOUSE_OVER:
					this._eventFlags = (this._eventFlags | MOUSE_OVER);
					break;
				case Engine3dEventName.MOUSE_OUT:
					this._eventFlags = (this._eventFlags | MOUSE_OUT);
					break;
				case Engine3dEventName.ENTER_DRAW_EVENT:
					this._eventFlags = (this._eventFlags | ENTER_DRAW_FLAG);
					break;
				case Engine3dEventName.EXIT_DRAW_EVENT:
					this._eventFlags = (this._eventFlags | EXIT_DRAW_FLAG);
					break;
				case Engine3dEventName.UPDATE_TRANSFORM_EVENT:
					this._eventFlags = (this._eventFlags | UPDATE_TRANSFORM_FLAG);
					break;
				
				case Engine3dEventName.VISIBLE_CHANGE_EVENT:
					this._eventFlags = (this._eventFlags | VISIBLE_FLAG);
					break;
				case Engine3dEventName.PIVOT3D_UPDATE:
					this._eventFlags = (this._eventFlags | PIVOT3D_UPDATE_FLAG);
					break;
			}
			if ((this._eventFlags & 3))
			{
				this.updatable = true;
			}
			super.addEventListener(_arg1 , _arg2 , _arg3 , _arg4 , _arg5);
		}
		
		/*public function get globlePos():Vector3D
		{
			var _pos:Vector3D
			if(this._parent)
			{
				_pos=this._parent.globlePos;
				
			}else
			{
				_pos=_temp0;
				_pos.setTo(0,0,0);
			}
			if(_offsetTransform!=null)
			{
				_offsetTransform.copyColumnTo(3,_temp1);
				_pos.incrementBy(_temp1);
			}
			
			_pos.incrementBy(this.pos);
			
			return _pos;
		}*/
		
		
		override public function removeEventListener(_arg1:String , _arg2:Function , _arg3:Boolean = false):void
		{
			super.removeEventListener(_arg1 , _arg2 , _arg3);
			switch (_arg1)
			{
				case Engine3dEventName.MOUSE_OVER:
					if (!hasEventListener(_arg1))
					{
						this._eventFlags = (this._eventFlags | MOUSE_OVER);
						this._eventFlags = (this._eventFlags - MOUSE_OVER);
					}
		
					return;
				case Engine3dEventName.MOUSE_OUT:
					if (!hasEventListener(_arg1))
					{
						this._eventFlags = (this._eventFlags | MOUSE_OUT);
						this._eventFlags = (this._eventFlags - MOUSE_OUT);
					}
		
					return;
				case Engine3dEventName.ENTER_DRAW_EVENT:
					if (!hasEventListener(_arg1))
					{
						this._eventFlags = (this._eventFlags | ENTER_DRAW_FLAG);
						this._eventFlags = (this._eventFlags - ENTER_DRAW_FLAG);
					}
		
					return;
				case Engine3dEventName.EXIT_DRAW_EVENT:
					if (!hasEventListener(_arg1))
					{
						this._eventFlags = (this._eventFlags | EXIT_DRAW_FLAG);
						this._eventFlags = (this._eventFlags - EXIT_DRAW_FLAG);
					}
		
					return;
				case Engine3dEventName.UPDATE_TRANSFORM_EVENT:
					if (!hasEventListener(_arg1))
					{
						this._eventFlags = (this._eventFlags | UPDATE_TRANSFORM_FLAG);
						this._eventFlags = (this._eventFlags - UPDATE_TRANSFORM_FLAG);
					}
		
					return;
				
				case Engine3dEventName.VISIBLE_CHANGE_EVENT:
					if (!hasEventListener(_arg1))
					{
						this._eventFlags = (this._eventFlags | VISIBLE_FLAG);
						this._eventFlags = (this._eventFlags - VISIBLE_FLAG);
					}
					return;
				case Engine3dEventName.PIVOT3D_UPDATE:
					if (!hasEventListener(_arg1))
					{
						this._eventFlags = (this._eventFlags | PIVOT3D_UPDATE_FLAG);
						this._eventFlags = (this._eventFlags - PIVOT3D_UPDATE_FLAG);
					}
					break;
			}

		}

		public function get updatable():Boolean
		{
			return (this._updatable);
		}

		public function set updatable(_arg1:Boolean):void
		{
			if (_arg1 == this._updatable)
			{
				return;
			}

			this._updatable = _arg1;
		/* if (this.scene)
		{
		if(this._updatable)
		{
		this.scene.insertIntoScene(this, true, false, false);
		}else
		{
		this.scene.removeFromScene(this, true, false, false);
		}

		};*/
		}
		private var _select:Boolean;
		public function set select(value:Boolean):void
		{
			if(_select==value)
			{
				return;
			}
			_select=value;
			if(_select)
			{
				this.dispatchEvent(_mouseOverEvent);
			}else
			{
				this.dispatchEvent(_mouseOutEvent);
			}
		}
		public function sendEvent(event:Event , down:Boolean , up:Boolean):Boolean
		{
			var success:Boolean = this.dispatchEvent(event);
			if (!success)
			{
				return false;
			}
			if (down)
			{
				var _local4:Pivot3D;
				for each (_local4 in this._children)
				{
					success = _local4.sendEvent(event , down , up);
					if (!success)
					{
						return false;
					}
				}
	
			}
			if (up)
			{
				if (this.parent)
				{
					success = this.parent.sendEvent(event , down , up);
					if (!success)
					{
						return false;
					}
				}
			}
			return true;
		}
	}
}


