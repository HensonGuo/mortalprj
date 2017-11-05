package frEngine.loaders.away3dMd5
{

	import flash.geom.Vector3D;
	
	import baseEngine.core.Label3D;

	
	/**
	 * Provides an abstract base class for nodes with time-based animation data in an animation blend tree.
	 */
	public class AnimationClipNodeBase extends Label3D
	{
		protected var _looping:Boolean = true;

		protected var _lastFrame : uint;
		
		protected var _stitchDirty:Boolean = true;
		protected var _stitchFinalFrame:Boolean = false;
		public var numFrames : uint = 0;
		
		protected var _totalDelta : Vector3D = new Vector3D();
		
		public var fixedFrameRate:Boolean = true;
		
		/**
		 * Determines whether the contents of the animation node have looping characteristics enabled.
		 */
		public function get looping():Boolean
		{	
			return _looping;
		}
		
		public function set looping(value:Boolean):void
		{
			if (_looping == value)
				return;
			
			_looping = value;
			
			_stitchDirty = true;
		}
		
		/**
		 * Defines if looping content blends the final frame of animation data with the first (true) or works on the
		 * assumption that both first and last frames are identical (false). Defaults to false.
		 */
		public function get stitchFinalFrame() : Boolean
		{
			return _stitchFinalFrame;
		}
		
		public function set stitchFinalFrame(value:Boolean):void
		{
			if (_stitchFinalFrame == value)
				return;
			
			_stitchFinalFrame = value;
			
			_stitchDirty = true;
		}
		

		public function get totalDelta():Vector3D
		{
			if (_stitchDirty)
				updateStitch();
			
			return _totalDelta;
		}
		
		public function get lastFrame():uint
		{
			if (_stitchDirty)
				updateStitch();
			
			return _lastFrame;
		}

		/**
		 * Creates a new <code>AnimationClipNodeBase</code> object.
		 */
		public function AnimationClipNodeBase(_arg2:int, _arg3:int,$trackName:String,$fightOnFrame:uint, $numFrames : uint)
		{
			super(_arg2,_arg3,$trackName,$fightOnFrame);
			numFrames = $numFrames;
		}
		
		/**
		 * Updates the node's final frame stitch state.
		 * 
		 * @see #stitchFinalFrame
		 */
		protected function updateStitch():void
		{
			_stitchDirty = false;
			
			_lastFrame = (_stitchFinalFrame)? numFrames : numFrames - 1;

			_totalDelta.x = 0;
			_totalDelta.y = 0;
			_totalDelta.z = 0;
		}
	}
}
