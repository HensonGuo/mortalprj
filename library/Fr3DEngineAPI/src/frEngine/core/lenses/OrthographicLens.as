package frEngine.core.lenses
{

	/**
	 * The PerspectiveLens object provides a projection matrix that projects 3D geometry isometrically. This entails
	 * there is no perspective distortion, and lines that are parallel in the scene will remain parallel on the screen.
	 */
	public class OrthographicLens extends LensBase
	{
		private var _projectionHeight : Number;
		private var _xMax : Number;
		private var _yMax : Number;
		private static const RAW_DATA_CONTAINER:Vector.<Number> = Vector.<Number>([	0,0,0,0,
																						0,0,0,0,
																						0,0,0,0,
																						0,0,0,1
																					]);

		/**
		 * Creates a new OrthogonalLens object.
		 */
		public function OrthographicLens(projectionHeight : Number = 500)
		{
			super();
			_projectionHeight = projectionHeight;
		}

		/**
		 * The vertical field of view of the projection.
		 */
		public function get projectionHeight() : Number
		{
			return _projectionHeight;
		}

		public function set projectionHeight(value : Number) : void
		{
			if (value == _projectionHeight) return;
			_projectionHeight = value;
			invalidateMatrix();
		}

		private var _scaleX:Number=1;
		private var _scaleY:Number=1;
		public function setScale(scaleX:Number,scaleY:Number):void
		{
			_scaleX=scaleX; 
			_scaleY=scaleY;
			invalidateMatrix();
		}
		override public function clone() : LensBase
		{
			var clone : OrthographicLens = new OrthographicLens();
			clone._near = _near;
			clone._far = _far;
			clone._aspectRatio = _aspectRatio;
			clone.projectionHeight = _projectionHeight;
			return clone;
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateMatrix() : void
		{
			var raw : Vector.<Number> = RAW_DATA_CONTAINER;
			//_yMax = _projectionHeight*.5;
			//_xMax = _yMax*_aspectRatio;

			// assume symmetric frustum
			raw[0] = 2/(_projectionHeight*_aspectRatio)*_scaleX;
			raw[5] = 2/_projectionHeight*_scaleY;
			raw[10] = 1/(_far-_near);
			raw[14] = _near/(_near-_far);

			/*_frustumCorners[0] = _frustumCorners[9] = _frustumCorners[12] = _frustumCorners[21] = -_xMax;
			_frustumCorners[3] = _frustumCorners[6] = _frustumCorners[15] = _frustumCorners[18] = _xMax;
			_frustumCorners[1] = _frustumCorners[4] = _frustumCorners[13] = _frustumCorners[16] = -_yMax;
			_frustumCorners[7] = _frustumCorners[10] = _frustumCorners[19] = _frustumCorners[22] = _yMax;
			_frustumCorners[2] = _frustumCorners[5] = _frustumCorners[8] = _frustumCorners[11] = _near;
			_frustumCorners[14] = _frustumCorners[17] = _frustumCorners[20] = _frustumCorners[23] = _far;*/

			_matrix.copyRawDataFrom(raw);

			_matrixInvalid = false;
		}
	}
}