/**
 * @date 2011-4-29 下午05:59:19
 * @author  宋立坤
 * 
 */  
package mortal.common.swfPlayer.data
{
	import mortal.common.swfPlayer.frames.FrameArray;
	
	
	public class SWFMovieClipData extends MovieClipData
	{
		public function SWFMovieClipData( type:String )
		{
			super(type);
		}
		
		override public function getFrames(action:int, direction:int):FrameArray
		{
			return super.getFrames(ActionType.Stand,DirectionType.DefaultDir);
		}
	}
}