package frEngine.loaders.resource.info
{
	import com.gengine.resource.info.DataInfo;
	
	import flash.utils.Endian;
	
	import frEngine.loaders.away3dMd5.MD5AnimByteArrayParser;
	import frEngine.loaders.away3dMd5.SkeletonAnimationSet;

	public class SkeletonInfo extends DataInfo
	{
		private var _animationSet:SkeletonAnimationSet;
		private var animParser:MD5AnimByteArrayParser;
		public var proceedParsed:Boolean=false;
		private var _callBackList:Array;
		public function SkeletonInfo(object:Object=null)
		{
			super(object);
		}
		public function get animationSet():SkeletonAnimationSet
		{
			return _animationSet;
		}
		public override function dispose():void
		{
			_animationSet && _animationSet.dispose();
			_callBackList=null;
			_animationSet=null;
			super.dispose();
		}

		public function addProceedParsedCallBack(fun:Function):void
		{
			if(proceedParsed)
			{
				return;
			}
			if(!_callBackList)
			{
				_callBackList=new Array();
			}
			if(_callBackList.indexOf(fun)==-1)
			{
				_callBackList.push(fun);
			}
		}
		override public function set data(value:Object):void
		{
			super.data = value;
			_callBackList=null;
			animParser=new MD5AnimByteArrayParser();
			proceedParsed=false;
			animParser.proceedParsingHead(_byteArray);
			
		}
		public function proceedParsing():void
		{
			if(!_byteArray && _byteArray.length==0)
			{
				return;
			}
			
			proceedParsed=animParser.proceedParsing();
			
			if(proceedParsed)
			{
				_animationSet=animParser.animationSet;
				
				while(_callBackList && _callBackList.length>0)
				{
					var fun:Function=_callBackList.shift();
					fun.apply();
				}
			}
			
		}
	}
}