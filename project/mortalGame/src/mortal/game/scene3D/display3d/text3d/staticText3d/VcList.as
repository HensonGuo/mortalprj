package mortal.game.scene3D.display3d.text3d.staticText3d
{
	import mortal.game.scene3D.display3d.text3d.Stext3DPlace;

	public class VcList
	{
		public var list:Vector.<Number>=new Vector.<Number>();
		public var placePool:Vector.<Stext3DPlace>=new Vector.<Stext3DPlace>();
		private var hasUseNum:int=0;
		private var maxNum:uint=SText3DRender.instance.maxNum;
		public static var totalUseNum:int=0;
		public function VcList()
		{
			placePool.length=maxNum;
			list.length=maxNum*4;
		}
		public function getPlaces(num:int,result:Vector.<Stext3DPlace>):Boolean
		{
			if(hasUseNum+num>maxNum)
			{
				return false;
			}
			hasUseNum+=num;
			totalUseNum+=num;
			var createNum:int=0;
			for(var i:int=0;i<maxNum;i++)
			{
				var place:Stext3DPlace=placePool[i];
				if(!place)
				{
					place=new Stext3DPlace(this,i);
					placePool[i]=place
					result[createNum++]=place;
					place.isUsed=true;
				}
				else if(!place.isUsed)
				{
					result[createNum++]=place;
					place.isUsed=true;
				}
				if(createNum==num)
				{
					return true;
				}
			}
			return false;
		}
		public function clearSplace(splace:Stext3DPlace):void
		{
			splace.isUsed=false;
			hasUseNum--;
			totalUseNum--;
		}
		public function dispose():void
		{
			for(var i:int=0;i<maxNum;i++)
			{
				var place:Stext3DPlace=placePool[i];
				if(place)
				{
					place.isUsed=false;
					list[place.placeId*4+3]=-1000;
				}
			}
			hasUseNum=0;
		}
	}
}