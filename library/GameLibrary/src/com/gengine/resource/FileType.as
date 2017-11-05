package com.gengine.resource
{
	import com.gengine.resource.info.DataInfo;
	import com.gengine.resource.info.ImageInfo;
	import com.gengine.resource.info.JTAInfo;
	import com.gengine.resource.info.MapDataInfo;
	import com.gengine.resource.info.SWFInfo;
	import com.gengine.resource.info.XMLInfo;
	import com.gengine.resource.loader.DataLoader;
	import com.gengine.resource.loader.ImageLoader;
	import com.gengine.resource.loader.JTALoader;
	import com.gengine.resource.loader.MapDataLoader;
	import com.gengine.resource.loader.SWFLoader;
	import com.gengine.resource.loader.XMLLoader;

	public class FileType
	{
		private static var _classRef:Object = {
			".XML":XMLLoader,
			".JPG":ImageLoader,
			".PNG":ImageLoader,
			".GIF":ImageLoader,
			".DATA":DataLoader,
			".SWF":SWFLoader,
			".MPT":MapDataLoader,
			".JTA":JTALoader,
			".EFFECT":DataLoader
		}
		public static function addClassRef(extendName:String,ref:Class,infoRef:Class):void
		{
			_classRef[extendName]= ref;
			_classInfoRef[extendName]=infoRef;
		}
		private static var _classInfoRef:Object = {
			".XML":XMLInfo,
			".JPG":ImageInfo,
			".PNG":ImageInfo,
			".GIF":ImageInfo,
			".DATA":DataInfo,
			".SWF":SWFInfo,
			".MPT":MapDataInfo,
			".JTA":JTAInfo,
			".EFFECT":DataInfo
		}
		
		public function FileType()
		{
		}
		
		public static function getLoaderByType( type:String ):Class
		{
			return _classRef[ type.toUpperCase() ];
		}
		
		public static function getLoaderInfoByType( type:String ):Class
		{
			return _classInfoRef[ type.toUpperCase() ];
		}
		
	}
}