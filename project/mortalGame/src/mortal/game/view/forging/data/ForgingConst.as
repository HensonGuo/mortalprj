package mortal.game.view.forging.data
{
	/**
	 * @date   2014-3-24 下午5:52:00
	 * @author dengwj
	 */	 
	public class ForgingConst
	{
		/** 总强化进度值 */
		public static const TotalStrengProgress:int = 10000;
		/** 最高强化等级 */
		public static const MaxStrengLevel:int      = 12;
		/** 黄色滤镜类型 */
		public static const YellowFilter:int		= 1;
		/** 蓝色滤镜类型 */
		public static const BlueFilter:int			= 2;
		/** 宝石镶嵌包中每页显的格子数 */
		public static const PageSize:int			= 14;
		/** 宝石最高等级 */
		public static const GemMaxLevel:int         = 10;
		/** 每次摘除宝石消耗铜钱 */
		public static const CoinCostOnExcise:int    = 1000;
		
		/** 宝石强化等级美术字cellWidth */
		public static const ArtWordCellWidth:int    = 32;
		/** 宝石强化等级美术字cellHeight */
		public static const ArtWordCellHeight:int   = 40;
		/** 每个字间的间距 */
		public static const ArtWordGap:int          = -6;
		
		/** 宝石特效等级1 */
		public static const GemEffectLevel1:int     = 3;
		/** 宝石特效等级2 */
		public static const GemEffectLevel2:int     = 6;
		/** 宝石特效等级3 */
		public static const GemEffectLevel3:int     = 9;
		/** 宝石特效等级4 */
		public static const GemEffectLevel4:int     = 10;
		
		/** 宝石特效路径1 */
		public static const EffectPath1:String      = "baoshi-lv";
		/** 宝石特效路径2 */
		public static const EffectPath2:String      = "baoshi-lan";
		/** 宝石特效路径3 */
		public static const EffectPath3:String      = "baoshi-zi";
		/** 宝石特效路径4 */
		public static const EffectPath4:String      = "baoshi-cheng";
		
		/** 宝石点击特效路径1 */
		public static const EffectClickPath1:String = "baoshi-lv-dianji";
		/** 宝石点击特效路径2 */
		public static const EffectClickPath2:String = "baoshi-lan-dianji";
		/** 宝石点击特效路径3 */
		public static const EffectClickPath3:String = "baoshi-zi-dianji";
		/** 宝石点击特效路径4 */
		public static const EffectClickPath4:String = "baoshi-cheng-dianji";
		
		public function ForgingConst()
		{
				
		}
	}
}