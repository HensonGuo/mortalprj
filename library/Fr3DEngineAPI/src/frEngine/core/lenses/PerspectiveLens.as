package frEngine.core.lenses
{


	/**
	 * The PerspectiveLens object provides a projection matrix that projects 3D geometry with perspective distortion.
	 */
	public class PerspectiveLens extends LensBase
	{
		private var _fieldOfView:Number;

		private var _zoom:Number;

		private var _yMax:Number;

		private var _xMax:Number;

		private static const RAW_DATA_CONTAINER:Vector.<Number> = new Vector.<Number>(16);

		/**
		 * Creates a new PerspectiveLens object.
		 * @param fieldOfView The vertical field of view of the projection.
		 */
		public function PerspectiveLens(fieldOfView:Number = 60)
		{
			super();
			this.fieldOfView = fieldOfView;
		}

		/**
		 * The vertical field of view of the projection.
		 */
		public function get fieldOfView():Number
		{
			return _fieldOfView;
		}

		public function set fieldOfView(value:Number):void
		{
			if (value == _fieldOfView)
				return;
			_fieldOfView = value;
			// tan(fov/2)
			_zoom = Math.tan(_fieldOfView * Math.PI / 360);
			invalidateMatrix();

		}

		override public function clone():LensBase
		{
			var clone:PerspectiveLens = new PerspectiveLens(_fieldOfView);
			clone._near = _near;
			clone._far = _far;
			clone._aspectRatio = _aspectRatio;
			return clone;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateMatrix():void
		{
			
			var raw:Vector.<Number> = RAW_DATA_CONTAINER;
			/*
			_yMax = _near * _zoom;
			_xMax = _yMax * _aspectRatio;
			raw[0] = _near / _xMax;
			raw[5] = _near / _yMax;
			raw[10] = _far / (_far - _near);
			raw[11] = 1;
			raw[14] = -_near * raw[10];*/
			
			var _data1:Number = ((1 / _zoom) * _aspectRatio);
			var _data2:Number = (_data1 / _aspectRatio);
			raw[0] = _data2;
			raw[5] = _data1;
			raw[10] = far / (far-near);
			raw[11] = 1;
			raw[14] = -near*raw[10];
			
			raw[1] = raw[2] = raw[3] = raw[4] = raw[6] = raw[7] = raw[8] = raw[9] = raw[12] = raw[13] = raw[15] = 0;
			_matrix.copyRawDataFrom(raw);
			
			
			/*
			_yMax = _near * _zoom;
			_xMax = _yMax * _aspectRatio;
			var yMaxFar:Number = _far * _zoom;
			var xMaxFar:Number = yMaxFar * _aspectRatio;

			_frustumCorners[0] = _frustumCorners[9] = -_xMax;
			_frustumCorners[3] = _frustumCorners[6] = _xMax;
			_frustumCorners[1] = _frustumCorners[4] = -_yMax;
			_frustumCorners[7] = _frustumCorners[10] = _yMax;

			_frustumCorners[12] = _frustumCorners[21] = -xMaxFar;
			_frustumCorners[15] = _frustumCorners[18] = xMaxFar;
			_frustumCorners[13] = _frustumCorners[16] = -yMaxFar;
			_frustumCorners[19] = _frustumCorners[22] = yMaxFar;

			_frustumCorners[2] = _frustumCorners[5] = _frustumCorners[8] = _frustumCorners[11] = _near;
			_frustumCorners[14] = _frustumCorners[17] = _frustumCorners[20] = _frustumCorners[23] = _far;*/

			_matrixInvalid = false;
		}
	}
}
