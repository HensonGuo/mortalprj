/**
 * @date 2011-5-3 上午10:38:35
 * @author  宋立坤
 * 
 */  
package mortal.game.manager
{
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.manager.item.LineBox;
	import mortal.game.view.effect.GlowFilterEffect;
	import mortal.game.view.effect.UIMaskEffect;

	public class EffectManager
	{
		private static var _glowFilter:GlowFilterEffect = new GlowFilterEffect();
		private static var _uiMaskEffect:UIMaskEffect = new UIMaskEffect();
		
		public function EffectManager()
		{
		}
		
		/**
		 * 注册发光滤镜动画
		 * @param target 目标
		 * @param filters 滤镜数组
		 * @param step 偏移步长
		 * @param max XY最大偏移量
		 * @param min XY最小偏移量
		 * @param repeat 播放次数 0=不限制
		 * 
		 */
		public static function glowFilterReg(target:DisplayObject,filters:Array=null,step:Number=1,max:int=10,min:int=0,repeat:int=0):void
		{
			if(filters == null)
			{
				filters = [FilterConst.guideTipsFilter];
			}
			_glowFilter.regist(target,filters,step,max,min,repeat);
		}
		
		/**
		 * 卸载发光滤镜动画 
		 * 
		 */
		public static function glowFilterUnReg(target:DisplayObject):void
		{
			_glowFilter.unRegist(target);
		}
		
		/**
		 * 返回target的滤镜 
		 * @param target
		 * @return 
		 * 
		 */
		public static function getGlowFilters(target:DisplayObject):Array
		{
			return _glowFilter.getFilters(target);
		}
		
		/**
		 * 返回发光线框 
		 * @param w
		 * @param h
		 * @param color 颜色数组
		 * @param step 更新频率 秒
		 * @param border 笔触大小
		 * @param palpha 透明度
		 * @return 
		 * 
		 */
		public static function getLineBox(w:int,h:int,color:Array=null,step:Number=0.5,border:Number=1,palpha:Number=1):LineBox
		{
			var lineBox:LineBox = ObjectPool.getObject(LineBox);
			if(color == null)
			{
				color = [0xff0000,0xffff00];
			}
			lineBox.updateLine(w,h,color,step,border,palpha);
			return lineBox;
		}
	
		/**
		 * 销毁发光线框 
		 * @param lineBox
		 * 
		 */
		public static function disposeLineBox(lineBox:LineBox):void
		{
			if(!lineBox)return;
			lineBox.dispose();
			ObjectPool.disposeObject(lineBox,LineBox);
		}
		
		/**
		 * 添加蒙版 
		 * @param masks masks[i] = MaskInfo.as 挖空区域列表
		 * @param daily 蒙版有效时间
		 * @param clickBack 点击回调函数
		 * 
		 */
		public static function addUIMask(masks:Array,daily:int = 10000,alpha:Number = 0.3,clickBack:Function = null):void
		{
			_uiMaskEffect.showMask(masks,daily,alpha,clickBack);
		}
		
		/**
		 * 移出蒙版 
		 * 
		 */
		public static function hideUIMask():void
		{
			_uiMaskEffect.hideMask();
		}
		
		/**
		 * 是否有蒙版UI 
		 * @return 
		 * 
		 */
		public static function hasUIMask():Boolean
		{
			return !_uiMaskEffect.isHide;
		}
			
		/**
		 * 舞台大小改变 
		 * 
		 */
		public static function stageResize():void
		{
			_uiMaskEffect.stageResize();
		}
		
		/**
		 * 获取LightMask 
		 * @return 
		 * 
		 */		
		public static function getLightMask(width:Number,height:Number):LightMask
		{
			var lightMask:LightMask = ObjectPool.getObject(LightMask);
			lightMask.transform.matrix = new Matrix();
			lightMask.scaleX = width/42.5;
			lightMask.scaleY = height/42.5;
			return lightMask;
		}
		
		/**
		 * 释放LightMask 
		 * @param lightMask
		 * 
		 */		
		public static function disposeLightMask(lightMask:LightMask):void
		{
			if(lightMask)
			{
				if(lightMask.parent)
				{
					lightMask.parent.removeChild(lightMask);
				}
				lightMask.x = 0;
				lightMask.y = 0;
				lightMask.width = 40;
				lightMask.height = 40;
				ObjectPool.disposeObject(lightMask);
			}
		}
	}
}