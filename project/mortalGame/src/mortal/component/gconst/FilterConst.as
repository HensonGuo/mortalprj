package mortal.component.gconst
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	import flash.utils.Dictionary;

	/**
	 * 滤镜全局类 
	 * @author jianglang
	 * 
	 */	
	public class FilterConst
	{
		private static var _textColorFilters:Dictionary = new Dictionary();
		private static var _glowColorFilters:Dictionary = new Dictionary();
		
		public static const windowTextFilter:DropShadowFilter = new DropShadowFilter(2,90,0x000000,0.5,0,0,0.9);
		public static const glowFilter:GlowFilter = new GlowFilter(0x091722,1,2,2,10);
		public static const titleFilter:GlowFilter = new GlowFilter(0x70645f,0.4,2,2,10);
		public static const titleShadowFilter:DropShadowFilter = new DropShadowFilter(0,120,0x000c0e,0.75,5,5);//title的投影滤镜
		public static const nameGlowFilter:GlowFilter = new GlowFilter(0x001417,1,2,2,10);//角色名描边
		public static const vipNameGlowFilter:GlowFilter = new GlowFilter(0x620303,1,2,2,10);//vip角色名描边
		public static const buttonDropShadowFilter:DropShadowFilter = new DropShadowFilter(1,90,0x444444,0.75);//按钮投影
		public static const buttonGlowFilter:GlowFilter = new GlowFilter(0x280e0e,1,2,2,10);//按钮发光
		public static const fightTextFilter:GlowFilter = new GlowFilter(0xFFFFFF,1,1,1,1,1,false,false);//飘字描边
		public static const guideTipsFilter:GlowFilter = new GlowFilter(0xffff00,1,10,10,2);//新手引导框
		public static const taskShowTargetFilter:GlowFilter = new GlowFilter(0xFF00FF,1,10,10,4,10);//任务目标提示
		public static const itemChooseFilter:GlowFilter = new GlowFilter(0x00FF00);//装备进阶选中目标的描边
		public static const chatTipsFilter:GlowFilter = new GlowFilter(0xffff00,1,4,4,2,1,false);//聊天闪烁滤镜
		
		public static const hintIconFilter:GlowFilter = new GlowFilter(0xfffff66,1,3,2,3);//飘字提示滤镜
		public static const noticeItemFilter:GlowFilter = new GlowFilter(0x00ba95,0.6,15,15,2,1);//广播飘字提示滤镜 0x336633
		public static const noticeItemFilter2:GlowFilter = new GlowFilter(0x222222,1,2,2,10);//广播飘字提示滤镜 0x336633
		public static const sceneDesFilter:GlowFilter = new GlowFilter(0x0066FF,0.6,5,5,3,10);//场景切换发光效果
		public static const plotShowFilter:DropShadowFilter = new DropShadowFilter(2,45,0);//诗句效果阴影
		public static const plotShowFilter2:GlowFilter = new GlowFilter(0,1,2,2,4);//诗句效果描边
		public static const rollTipsFilter:GlowFilter = new GlowFilter(0,1,2,2,2);//飘字提示描边
		public static const rollTipsFilter2:DropShadowFilter = new DropShadowFilter(1,45,0x00ba95,1);//飘字提示阴影
		public static const crossGuildWarStageBtnFilter:GlowFilter = new GlowFilter(0xC63307, 0.9, 8, 8, 3);//发光描边
		
		public static const colorFilter:ColorMatrixFilter = new ColorMatrixFilter([
			                       0.31,0.61,0.08,0,
			                       0,0.31,0.61,0.08,
				                   0,0,0.31,0.61,0.08,
				                   0,0,0,0,0,1,0
			                    ]);
//			([ //黑白滤镜
//			                        1,0,0,0,0,   
//			                        1,0,0,0,0,   
//			                        1,0,0,0,0,   
//		    	                    0,0,0,1,0  
//		                       ]);  
		
		public static const colorFilter2:ColorMatrixFilter = new ColorMatrixFilter([ //灰色滤镜
									0.5086,0.2094,0.082,0,0,
									0.5086,0.2094,0.082,0,0,
									0.5086,0.2094,0.082,0,0,
									0,0,0,1,0
								]);

		public static const colorFilterRed:ColorMatrixFilter = new ColorMatrixFilter([//红色滤镜
									0.5,0.5,1,0,0,   
									0.2,0.2,0.2,0,0,   
									0.2,0.2,0.2,0,0,   
									0,0,0,1,0  
								]);
		
		/**
		 * 黄色渐变滤镜
		 */
		public static const gradientGlowFilter:GradientGlowFilter = new GradientGlowFilter(0,45,
			[0xffff66, 0xffff00],[0,1],[0,255],5,5,2,BitmapFilterQuality.HIGH,BitmapFilterType.OUTER);
		
		/**
		 * 描边 
		 * @param color
		 * @return 
		 * 
		 */
		public static function textStrokeFilter(color:uint=0x000000):GlowFilter
		{
			if(!_textColorFilters.hasOwnProperty(color))
			{
				_textColorFilters[color] = new GlowFilter(color,1,2,2,50,1,false,false);
			}
			return _textColorFilters[color];
		}

		/**
		 * 颜色发光滤镜 
		 * @param color
		 * @return 
		 * 
		 */
		public static function colorGlowFilter(color:uint=0x000000):GlowFilter
		{
			if(!_glowColorFilters.hasOwnProperty(color))
			{
				_glowColorFilters[color] = new GlowFilter(color,1,10,10,2);
			}
			return _glowColorFilters[color];
		}
		
		public function FilterConst()
		{
			
		}
	}
}