package mortal
{
	public class GameScene3dConfig
	{
		public static const instance:GameScene3dConfig=new GameScene3dConfig();
		public function GameScene3dConfig()
		{
			
		}
		public function getMeshUrlById(id:String):String
		{
			var targetUrl:String="";
			switch(id)
			{
				case "1":targetUrl="97_zsntest.md5mesh";break;
			}
			return targetUrl;
		}
		public function getBoneUrlById(id:String):String
		{
			var targetUrl:String="";
			switch(id)
			{
				case "1":targetUrl="97_zsntest.skeleton";break;
			}
			return targetUrl;
		}
		public function getTextureUrlById(id:String):String
		{
			var targetUrl:String="";
			switch(id)
			{
				case "1":targetUrl="zsn.png";break;
			}
			return targetUrl;
		}
		public function getEffectUrlById(id:String):String
		{
			return id + ".effect";
		}
	}
}