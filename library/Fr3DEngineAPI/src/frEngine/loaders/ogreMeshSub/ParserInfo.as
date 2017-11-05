package frEngine.loaders.ogreMeshSub
{
	import baseEngine.core.Pivot3D;

	public class ParserInfo
	{
		public var exportAnimate:Boolean;
		public var targetMesh:Pivot3D;
		//public var pahtTransformBox:Pivot3D;
		public var childenInfo:childrenInfo;
		public function ParserInfo($parentInfo:ParserInfo)
		{
			exportAnimate=true;
			if($parentInfo)
			{
				childenInfo=$parentInfo.childenInfo;
			}
		}
		public function createChildrenInfo():void
		{
			childenInfo=new childrenInfo();
		}
	}
}
import flash.utils.Dictionary;

class childrenInfo
{
	private var dic:Dictionary=new Dictionary(false);
	private var dicIndex:Dictionary=new Dictionary(false);
	private var curIndex:int=0;
	public var list:Array=new Array();
	public function childrenInfo()
	{
		
	}
	public function addKey(keyName:String,keyValue:String):void
	{
		dic[keyName]=keyName+"="+keyValue;
		if(dicIndex[keyName]==null)
		{
			dicIndex[keyName]=curIndex;
			curIndex++;
		}
		var targetindex:int=dicIndex[keyName];
		list[targetindex]=dic[keyName];
	}
	public function getKeyByIndex(index:int):String
	{
		return dicIndex[index];
	}
	public function getLen():int
	{
		return curIndex;
	}
}