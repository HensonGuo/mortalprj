package frEngine.math
{
	public class StringUtils
	{
		public function StringUtils()
		{
		}
		public static function getFolderUrl(fileUrl:String):String
		{
			var index:int=fileUrl.lastIndexOf("\\");
			var result:String="";
			if(index!=-1)
			{
				result=fileUrl.substr(0,index+1);
			}else 
			{
				index=fileUrl.lastIndexOf("\/");
				if(index!=-1)
				{
					result=fileUrl.substr(0,index+1);
				}
			}
			return result;
		}
		public static function getUrlFileName(fileUrl:String):String
		{
			var folderurl:String=getFolderUrl(fileUrl);
			var fileName:String=fileUrl.replace(folderurl,"");
			var indexNum:int=fileName.lastIndexOf("\.")
			if(indexNum!=-1)
			{
				fileName=fileName.substring(0,indexNum);
			}
			return fileName;
		}
	}
}