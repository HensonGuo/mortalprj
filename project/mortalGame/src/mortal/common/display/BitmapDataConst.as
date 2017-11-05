package mortal.common.display
{
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	
	import mortal.game.view.common.UIFactory;

	/**
	 * bitmapdata常量 
	 * @author jianglang
	 * 
	 */	
	public class BitmapDataConst
	{
		
		/**
		 * 背包遮罩 
		 */
		public static const LockedBMD:String = "LockedBMD";
		public static const UsedBMD:String = "UsedBMD";
		public static const NoDurabilityBMD:String = "NoDurabilityBMD";
		public static const HasExpiredBMD:String = "HasExpiredBMD";
		public static const NotMeetCareerBMD:String = "NotMeetCareerBMD";
		//常用透明背景
		public static const AlphaBMD:String = "AlphaBMD";
		
		public static function registToGlobal():void
		{
			//注册到GlobalClass
			GlobalClass.addBitmapData(BitmapDataConst.LockedBMD,new BitmapData(10,10,true,0xAA000000));
			GlobalClass.addBitmapData(BitmapDataConst.UsedBMD,new BitmapData(10,10,true,0x55FF0000));
			GlobalClass.addBitmapData(BitmapDataConst.NoDurabilityBMD,new BitmapData(10,10,true,0x66FF0000));
			GlobalClass.addBitmapData(BitmapDataConst.HasExpiredBMD,new BitmapData(10,10,true,0x66FF0000));
			GlobalClass.addBitmapData(BitmapDataConst.NotMeetCareerBMD,new BitmapData(10,10,true,0x66AA0000));
			GlobalClass.addBitmapData(BitmapDataConst.AlphaBMD,new BitmapData(10,10,true,0x00FFFFFF));
		}
		
		public function BitmapDataConst()
		{
		}
	}
}