package frEngine.animateControler.visible
{
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.keyframe.BezierVo;
	import frEngine.animateControler.keyframe.NodeAnimateKey;

	public class VisibleControler extends Modifier
	{
		public function VisibleControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.VisibleContoler;
		}
		protected override function calculateFrameValue(tframe:int):void
		{
			var index:int=getTimeIndex(tframe,_keyframes);
			var m1:NodeAnimateKey=_keyframes[index];
			_cache[currentFrame]=m1.value
		}
		public function getStartVisibleFrame():int
		{
			var index:int=getTimeIndex(this.currentFrame,_keyframes);
			var m1:NodeAnimateKey=_keyframes[index];
			return m1.frame;
		}
		
		public override function parserKeyFrames(keyFrames:Object):void
		{
			super.parserKeyFrames(keyFrames);
			targetObject3d.visible=_keyframes[0].value;
		}
		public override function editKeyFrame(track:Object, keyIndex:int, attribute:String, value:*,bezierVo:BezierVo):Object
		{
			if(keyIndex==0)
			{ 
				targetObject3d.visible=value;
			}
			return super.editKeyFrame(track,keyIndex,attribute,value,null);
		}
		
		protected override function setTargetProperty(value:*):void
		{
			targetObject3d.visible=Boolean(value);
		}
	}
}