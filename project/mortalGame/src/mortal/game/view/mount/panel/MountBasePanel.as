package mortal.game.view.mount.panel
{
	import com.mui.controls.GSprite;
	import mortal.game.view.mount.data.MountData;
	
	public class MountBasePanel extends GSprite
	{
		protected var _mountData:MountData;
		
		public function MountBasePanel()
		{
			super();
		}
		
		/**
		 * 设置mountData 
		 * @param data
		 * 
		 */		
		public function setMountInfo(mountData:MountData):void
		{
			_mountData = mountData;
			
		}
		
		public function clearWin():void
		{
			_mountData = null;
		}
		
		/**
		 * 设置内容 
		 * 
		 */		
		public function setInfo():void
		{
			if(_mountData == null || _mountData.sPublicMount == null)
			{
				clearWin();
				return;
			}
		}
	}
}