package frEngine.loaders.away3dMd5
{
	import flash.utils.Dictionary;

	public class SkeletonAnimationSet
	{
		private var _animations:Vector.<AnimationClipNodeBase> = new Vector.<AnimationClipNodeBase>();
		private var _animationNames:Vector.<String> = new Vector.<String>();
		private var _animationDictionary:Dictionary = new Dictionary(true);
		private var _jointsPerVertex : uint;

		/**
		 * Returns the amount of skeleton joints that can be linked to a single vertex via skinned weight values. For GPU-base animation, the 
		 * maximum allowed value is 4.
		 */
		public function get jointsPerVertex() : uint
		{
			return _jointsPerVertex;
		}
		public function get animations():Vector.<AnimationClipNodeBase>
		{
			return _animations;
		}
		public function dispose():void
		{
			for each (var activeNode:SkeletonClipNode in _animationDictionary)
			{
				activeNode.dispose();
			}
			_animationDictionary=null;
			
		}
		/**
		 * Returns a vector of animation state objects that make up the contents of the animation data set.
		 */
		public function get animationNames():Vector.<String>
		{
			return _animationNames;
		}
		public function addAnimation(node:AnimationClipNodeBase):void
		{
			if (_animationDictionary[node.trackName])
			{
				throw new Error("root node name '" + node.trackName + "' already exists in the set");
			}
			
			
			_animationDictionary[node.trackName] = node;
			
			_animations.push(node);
			
			_animationNames.push(node.trackName);
		}
		/**
		 * Check to determine whether a state is registered in the animation set under the given name.
		 *
		 * @param stateName The name of the animation state object to be checked.
		 */
		public function hasAnimation(name:String):Boolean
		{
			return _animationDictionary[name] != null;
		}
		
		/**
		 * Retrieves the animation state object registered in the animation data set under the given name.
		 *
		 * @param stateName The name of the animation state object to be retrieved.
		 */
		public function getAnimation(name:String):AnimationClipNodeBase
		{
			return _animationDictionary[name];
		}
		/**
		 * Creates a new <code>SkeletonAnimationSet</code> object.
		 * 
		 * @param jointsPerVertex Sets the amount of skeleton joints that can be linked to a single vertex via skinned weight values. For GPU-base animation, the maximum allowed value is 4. Defaults to 4.
		 */
		public function SkeletonAnimationSet()
		{
			
		}
	}
}
