package mortal.common.global
{
	public class PathConst
	{
		private static var _mainPath:String="";//"";//全局路径
		
		public static var configUrl:String=""; //mainPath+"data/data";
		
		public static var createRoleUrl:String;
		
		public static var gameUrl:String;
		
		public static var mapPath:String;
		
		public static var modelPath:String;
		
		public static var mapLocalPath:String = "otherRes/maps/";
		
		public static var mapBgLocalPath:String = "otherRes/bgMaps/";
		
		public static var headImagePath:String = "../user_image/";
		
		public static var isPay:Boolean = true;
		
		public function PathConst()
		{
			
		}
		
		public static function get mainPath():String
		{
			return _mainPath;
		}

		public static function set mainPath(value:String):void
		{
			_mainPath = value;
			createRoleUrl = _mainPath + ParamsConst.instance.createRoleUrl + "?" + ParamsConst.instance.createRoleVersion;
			gameUrl = _mainPath + ParamsConst.instance.gameUrl;
			configUrl = _mainPath + ParamsConst.instance.configUrl;
			mapPath = _mainPath+mapLocalPath;
			modelPath = _mainPath + "assets/models/";
		}

	}
}