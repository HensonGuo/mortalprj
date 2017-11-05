// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//x2d.display.Camera2D

package de.nulldesign.nd2d.display
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import __AS3__.vec.Vector;
	
	import de.nulldesign.nd2d.utils.VectorUtil;
	
	public class Camera2D {
		
		protected var renderMatrixOrtho:Matrix3D;
		protected var renderMatrixPerspective:Matrix3D;
		protected var perspectiveProjectionMatrix:Matrix3D;
		protected var orthoProjectionMatrix:Matrix3D;
		protected var viewMatrix:Matrix3D;
		protected var _sceneWidth:Number;
		protected var _sceneHeight:Number;
		protected var _rawSceneWidth:Number;
		protected var _rawSceneHeight:Number;
		protected var _scaleCoff:Number = 1;
		protected var invalidated:Boolean = true;
		protected var _isStageCoord:Boolean = false;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _zoom:Number = 1;
		private var _rotation:Number = 0;
		
		public function Camera2D(_arg1:Number, _arg2:Number){
			this.renderMatrixOrtho = new Matrix3D();
			this.renderMatrixPerspective = new Matrix3D();
			this.perspectiveProjectionMatrix = new Matrix3D();
			this.orthoProjectionMatrix = new Matrix3D();
			this.viewMatrix = new Matrix3D();
			super();
			this.resizeCameraStage(_arg1, _arg2, 1);
		}
		
		public function resizeCameraStage(_arg1:Number, _arg2:Number, _arg3:Number=1):void{
			this._sceneWidth = _arg1;
			this._sceneHeight = _arg2;
			this._scaleCoff = _arg3;
			this._rawSceneWidth = (_arg1 / _arg3);
			this._rawSceneHeight = (_arg2 / _arg3);
			this.invalidated = true;
			this.orthoProjectionMatrix = this.makeOrtographicMatrix(0, _arg1, 0, _arg2);
			var _local4:Number = 60;
			var _local5:Number = Math.tan(VectorUtil.deg2rad((_local4 * 0.5)));
			var _local6:Matrix3D = this.makeProjectionMatrix(0.1, 2000, _local4, (_arg1 / _arg2));
			var _local7:Vector3D = new Vector3D(0, 0, 0);
			var _local8:Vector3D = new Vector3D(0, 0, (-((this._sceneHeight * 0.5)) / _local5));
			var _local9:Matrix3D = this.lookAt(_local7, _local8);
			_local9.append(_local6);
			this.perspectiveProjectionMatrix = _local9;
		}
		
		protected function lookAt(_arg1:Vector3D, _arg2:Vector3D):Matrix3D{
			var _local3:Vector3D = new Vector3D();
			_local3.x = Math.sin(0);
			_local3.y = -(Math.cos(0));
			_local3.z = 0;
			var _local4:Vector3D = new Vector3D();
			_local4.x = (_arg1.x - _arg2.x);
			_local4.y = (_arg1.y - _arg2.y);
			_local4.z = (_arg1.z - _arg2.z);
			_local4.normalize();
			var _local5:Vector3D = _local3.crossProduct(_local4);
			_local5.normalize();
			_local3 = _local5.crossProduct(_local4);
			_local3.normalize();
			var _local6:Vector.<Number> = new Vector.<Number>();
			_local6.push(-(_local5.x), -(_local5.y), -(_local5.z), 0, _local3.x, _local3.y, _local3.z, 0, -(_local4.x), -(_local4.y), -(_local4.z), 0, 0, 0, 0, 1);
			var _local7:Matrix3D = new Matrix3D(_local6);
			_local7.prependTranslation(-(_arg2.x), -(_arg2.y), -(_arg2.z));
			return (_local7);
		}
		
		protected function makeProjectionMatrix(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number):Matrix3D{
			var _local5:Number = (_arg1 * Math.tan((_arg3 * (Math.PI / 360))));
			var _local6:Number = (_local5 * _arg4);
			return (this.makeFrustumMatrix(-(_local6), _local6, -(_local5), _local5, _arg1, _arg2));
		}
		
		protected function makeFrustumMatrix(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number, _arg6:Number):Matrix3D{
			return (new Matrix3D(Vector.<Number>([((2 * _arg5) / (_arg2 - _arg1)), 0, ((_arg2 + _arg1) / (_arg2 - _arg1)), 0, 0, ((2 * _arg5) / (_arg3 - _arg4)), ((_arg3 + _arg4) / (_arg3 - _arg4)), 0, 0, 0, (_arg6 / (_arg5 - _arg6)), -1, 0, 0, ((_arg5 * _arg6) / (_arg5 - _arg6)), 0])));
		}
		
		protected function makeOrtographicMatrix(_arg1:Number, _arg2:Number, _arg3:Number, _arg4:Number, _arg5:Number=0, _arg6:Number=1):Matrix3D{
			return (new Matrix3D(Vector.<Number>([(2 / (_arg2 - _arg1)), 0, 0, 0, 0, (2 / (_arg3 - _arg4)), 0, 0, 0, 0, (1 / (_arg6 - _arg5)), 0, 0, 0, (_arg5 / (_arg5 - _arg6)), 1])));
		}
		
		public function getViewProjectionMatrix(_arg1:Boolean=true):Matrix3D{
			if (this.invalidated)
			{
				this.invalidated = false;
				this.viewMatrix.identity();
				if (this.isStageCoord)
				{
					this.viewMatrix.appendTranslation(((-(this._rawSceneWidth) / 2) - this.x), ((-(this._rawSceneHeight) / 2) - this.y), 0);
				} else
				{
					this.viewMatrix.appendTranslation(-(this.x), -(this.y), 0);
				};
				this.viewMatrix.appendTranslation(-(this.x), -(this.y), 0);
				this.viewMatrix.appendScale(this.zoom, this.zoom, 1);
				this.viewMatrix.appendRotation(this._rotation, Vector3D.Z_AXIS);
				this.renderMatrixOrtho.identity();
				this.renderMatrixOrtho.append(this.viewMatrix);
				this.renderMatrixPerspective.identity();
				this.renderMatrixPerspective.append(this.viewMatrix);
				this.renderMatrixOrtho.append(this.orthoProjectionMatrix);
				this.renderMatrixPerspective.append(this.perspectiveProjectionMatrix);
			};
			return (((_arg1) ? this.renderMatrixOrtho : this.renderMatrixPerspective));
		}
		
		public function reset():void{
			this.x = (this.y = (this.rotation = 0));
			this.zoom = 1;
		}
		
		public function get x():Number{
			return (this._x);
		}
		
		public function set x(_arg1:Number):void{
			this.invalidated = true;
			this._x = _arg1;
		}
		
		public function get y():Number{
			return (this._y);
		}
		
		public function set y(_arg1:Number):void{
			this.invalidated = true;
			this._y = _arg1;
		}
		
		public function get zoom():Number{
			return (this._zoom);
		}
		
		public function set zoom(_arg1:Number):void{
			this.invalidated = true;
			this._zoom = _arg1;
		}
		
		public function get rotation():Number{
			return (this._rotation);
		}
		
		public function set rotation(_arg1:Number):void{
			this.invalidated = true;
			this._rotation = _arg1;
		}
		
		public function get sceneWidth():Number{
			return (this._sceneWidth);
		}
		
		public function get sceneHeight():Number{
			return (this._sceneHeight);
		}
		
		public function get rawSceneWidth():Number{
			return (this._rawSceneWidth);
		}
		
		public function get rawSceneHeight():Number{
			return (this._rawSceneHeight);
		}
		
		public function get isStageCoord():Boolean{
			return (this._isStageCoord);
		}
		
		public function set isStageCoord(_arg1:Boolean):void{
			this._isStageCoord = _arg1;
		}
		
		
	}
}//package x2d.display

