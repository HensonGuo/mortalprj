package mortal.common
{
	import com.gengine.core.Singleton;
	import com.gengine.core.call.Caller;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.LoaderPriority;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ResourceInfo;
	import com.gengine.resource.info.SWFInfo;
	
	import flash.text.Font;
	
	import mortal.common.display.LoaderHelp;
	import mortal.game.cache.Cache;
	
	/**
	 * 资源加载管理类 
	 * @author jianglang
	 * 
	 */	
	public class ResManager extends Singleton
	{
		private static var _instance:ResManager;
		
		private var _caller:Caller = new Caller();
		
		private static const TitleCall:String = "TitleCall";
		private static const FaceCall:String = "FaceCall";
		private static const FaceVIPCall:String = "FaceVIPCall";
		private static const NumberCall:String = "NumberCall";
		private static const EnglishCall:String = "EnglishCall";
		
		public function ResManager()
		{
			super();
		}
		
		public static function get instance():ResManager
		{
			if( _instance == null )
			{
				_instance = new ResManager();
			}
			return _instance;
		}
		
		private var _isFaceLoaded:Boolean = false;
		private var _isFaceVIPLoaded:Boolean = false;
		private var _isTitleLoaded:Boolean = false;
		private var _isBaseLoaded:Boolean = false;
		private var _isNumberLoaded:Boolean = false;
		private var _isSkillLoaded:Boolean = false;
		private var _isEnglishLoaded:Boolean = false;
		
		public function get isSkillLoaded():Boolean
		{
			return _isSkillLoaded;
		}
		
		public function get isTitleLoaded():Boolean
		{
			return _isTitleLoaded;
		}
		
		public function get isFaceLoaded():Boolean
		{
			return _isFaceLoaded;
		}
		
		public function get isFaceVIPLoaded():Boolean
		{
			return _isFaceVIPLoaded;
		}
		
		public function get isNumberLoaded():Boolean
		{
			return _isNumberLoaded;
		}
		
		public function get isEnglishLoaded():Boolean
		{
			return _isEnglishLoaded;
		}
		
		/**
		 * 加载表情 
		 * 
		 */		
		public function LoadFace():void
		{
			if(!_isFaceLoaded)
			{
				var info:ResourceInfo = ResourceManager.getInfoByName("Face.swf");
				LoaderHelp.addResCallBack("Face",faceCompl,info.path);
			}
		}
		
		private function faceCompl():void
		{
			_isFaceLoaded = true;
			_caller.call(FaceCall);
			_caller.removeCallByType(FaceCall);
		}
		
		/**
		 * 加载VIP表情 
		 * 
		 */		
		public function LoadFaceVIP():void
		{
			if(!_isFaceVIPLoaded)
			{
				var info:ResourceInfo = ResourceManager.getInfoByName("faceVIP.swf");
				LoaderHelp.addResCallBack("faceVIP",faceVIPCompl,info.path);
			}
		}
		
		private function faceVIPCompl():void
		{
			_isFaceVIPLoaded = true;
			_caller.call(FaceVIPCall);
			_caller.removeCallByType(FaceVIPCall);
		}
		
		/**
		 * 加载基本的属性文字
		 * 
		 */
		public function LoadFontBase():void
		{
			if( _isBaseLoaded == false )
			{
				LoadFont("FontBase.swf","font.FontBase_base",loadBaseComplete);
			}
		}
		
		private function loadBaseComplete():void
		{
			_isBaseLoaded = true;
		}
		
		/**
		 * 加载数字
		 * 
		 */
		public function LoadFontNumber():void
		{
			if( _isNumberLoaded == false )
			{
				LoadFont("FontNumber.swf","font.FontNumber_number",loadNumberComplete);
			}
		}
		
		private function loadNumberComplete():void
		{
			_isNumberLoaded = true;
			_caller.call(NumberCall);
			_caller.removeCallByType(NumberCall);
		}
		
		/**
		 * 加载标题 
		 * 
		 */
		public function LoadFontTitle():void
		{
			if( _isTitleLoaded == false )
			{
				LoadFont("FontTitle.swf","font.FontTitle_title",loadTitleComplete);
			}
		}
		
		private function loadTitleComplete():void
		{
			_isTitleLoaded = true;
			_caller.call(TitleCall);
			_caller.removeCallByType(TitleCall);
		}
		
		/**
		 * 加载技能名字
		 * 
		 */
		public function LoadFontSkill():void
		{
			if( _isSkillLoaded == false )
			{
				LoadFont("FontSkill.swf","font.FontSkill_skill",loadSkillComplete);
			}
		}
		
		private function loadSkillComplete():void
		{
			_isSkillLoaded = true;
			_caller.call(NumberCall);
			_caller.removeCallByType(NumberCall);
		}
		
		/**
		 * 加载英文嵌入字体
		 * 
		 */
		public function LoadFontEnglish():void
		{
			if( _isEnglishLoaded == false )
			{
				LoadFont("FontEnglish.swf","font.FontEnglish_englishFont1,font.FontEnglish_englishFont2",loadEnglishComplete,LoaderPriority.LevelA);
			}
		}
		
		private function loadEnglishComplete():void
		{
			_isEnglishLoaded = true;
			_caller.call(EnglishCall);
			_caller.removeCallByType(EnglishCall);
		}
		
		/**
		 * 加载字体 
		 * @param swfName
		 * @param className
		 * 
		 */		
		public function LoadFont(swfName:String,className:String,completeCall:Function = null,loaderPriority:int = 3):void
		{
			function onLoadedHandler(info:SWFInfo):void
			{
				var aryClassName:Array = className.split(",");
				
				for each(className in aryClassName)
				{
					var cls:Class = info.getAssetClass(className);
					if(cls != null)
					{
						Font.registerFont(cls);
					}
				}
				
				if( completeCall is Function )
				{
					completeCall();
				}
			}
			LoaderManager.instance.load(swfName,onLoadedHandler,loaderPriority,className);
		}
		
		
		public function registerTitle( callback:Function ):void
		{
			if( _isTitleLoaded == false )
			{
				_caller.addCall(TitleCall,callback);
			}
		}
		
		public function registerFace( callback:Function ):void
		{
			if( _isFaceLoaded == false )
			{
				_caller.addCall(FaceCall,callback);
			}
		}
		
		public function registerFaceVIP( callback:Function ):void
		{
			if( _isFaceVIPLoaded == false )
			{
				_caller.addCall(FaceVIPCall,callback);
			}
		}
		
		public function registerNumber( callback:Function ):void
		{
			if( _isNumberLoaded == false )
			{
				_caller.addCall(NumberCall,callback);
			}
		}
		
		public function registerEnglish( callback:Function ):void
		{
			if( _isEnglishLoaded == false )
			{
				_caller.addCall(EnglishCall,callback);
			}
		}
		
		public function loadLevelRes():void
		{
			var level:int = Cache.instance.role.entityInfo.level;
			if( level > 0 )
			{
				LoadFontBase();
				LoadFontNumber();
			}
			if( level > 2 )
			{
				LoadFontTitle();
			}
//			if( level > 16 )
//			{
//				LoadFontSkill();
//			}
			if( level > 13)
			{
				LoadFace();
				LoadFaceVIP();
			}
		}
	}
}