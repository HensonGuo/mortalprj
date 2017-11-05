/**
 * @date 2011-4-15 上午10:06:32
 * @author  宋立坤
 * 
 */  
package mortal.game.manager
{
	import com.gengine.utils.HTMLUtil;
	
	import extend.language.Language;
	
	import flash.display.Sprite;
	
	import mortal.game.model.TaskTargetInfo;
	import mortal.game.view.guide.GuideTips;

	public class GuideTipsManager
	{
		private static var _target:TaskTargetInfo;//当前的目标
		
		public static const Dir_BL:int = 1;//左下
		public static const Dir_BR:int = 2;//右下
		public static const Dir_TL:int = 3;//左上
		public static const Dir_TR:int = 4;//右上
		
		public static const Txt_Fly:String = Language.getString(20323) + HTMLUtil.addColor(Language.getString(20324),"#00ff00") + Language.getString(20325);//"点击<font color='#00ff00'>筋斗云</font>直接传送";
		public static const Txt_Dialog:String = Language.getString(20323);//"点击";
		public static const Txt_VIPFly:String = Language.getStringByParam(20326,HTMLUtil.addColor(Language.getString(20324),"#00ff00"));//"使用<font color='#00ff00'>筋斗云</font>可瞬间到达";
		
		private static var _guideTips:GuideTips;
		private static var _guideTips2:GuideTips;
		
		private static var _callBack:Function;//回调函数
		private static var _daily:int;//延迟n毫秒
		private static var _thumbParent:Sprite = new Sprite();
		
		public function GuideTipsManager()
		{
		}
		
		public static function get guideTips():GuideTips
		{
			if(!_guideTips)
			{
				_guideTips = new GuideTips;
			}
			return _guideTips;
		}
		
		public static function get guideTips2():GuideTips
		{
			if(!_guideTips2)
			{
				_guideTips2 = new GuideTips();
			}
			return _guideTips2;
		}
		
		public static function get target():TaskTargetInfo
		{
			return _target;
		}
		
		/**
		 * 辅助提示框 
		 * @param dir
		 * @param txt
		 * @return 
		 * 
		 */
		public static function getGuideTips2(dir:int,txt:String):GuideTips
		{
			hideGuideTips2();
			
			guideTips2.updateTxt(txt);
			guideTips2.updateDir(dir);
			return guideTips2;
		}
		
		/**
		 * 延迟时间到 
		 * 
		 */
		private static function onDailyTimeOut():void
		{
			hideGuideTips();
		}
		
		/**
		 * 隐藏箭头提示 
		 * 
		 */
		public static function hideGuideTips():void
		{
			if(_guideTips && _guideTips.parent != _thumbParent)
			{
				_thumbParent.addChild(_guideTips);
				_guideTips.dispose();
				_target = null;
			}
		}
		
		/**
		 * 隐藏箭头提示 
		 * 
		 */
		public static function hideGuideTips2():void
		{
			
			if(_guideTips2 && _guideTips2.parent != _thumbParent)
			{
				_thumbParent.addChild(_guideTips2);
				_guideTips2.dispose();
			}
		}
		
		/**
		 * 舞台大小改变 
		 * 
		 */
		public static function stageResize():void
		{
			if(_guideTips && _guideTips.parent != _thumbParent)
			{
				if(_guideTips.baseLayer)
				{
					_guideTips.x = _guideTips.baseX + _guideTips.baseLayer.x;
					_guideTips.y = _guideTips.baseY + _guideTips.baseLayer.y;
				}
			}
		}
	}
}