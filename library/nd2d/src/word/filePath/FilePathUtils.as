package word.filePath
{
	import flash.net.URLRequest;

	public class FilePathUtils
	{
		private static var cdnPath:String="http://res.t.game2.com.cn/"; 
		public static function get root():String
		{
			return cdnPath;
		}
		public static function getUrl(urlR:URLRequest):URLRequest
		{
			var urlStri:String=urlR.url;
			if(urlStri.indexOf(cdnPath)==-1){
				urlR.url=cdnPath+urlStri;
			}
			if(urlStri.indexOf("http://res.t.game2.com.cn/client/data/")!=-1)
			{
				urlR.url=urlR.url.replace(cdnPath,"");
			}
			if(urlStri.indexOf("http://res.t.game2.com.cn/client/maps/yuehecun/grid")!=-1)
			{
				urlR.url=urlR.url.replace("http://res.t.game2.com.cn/client/maps/yuehecun/grid","maps");
			}
			trace("#####################"+urlR.url);
			return urlR;
		}
	}
}