/**
 * 2014-4-26
 * @author chenriji
 **/
package com.mui.manager
{
	/**
	 * 物品tips的接口 
	 * @author hdkiller
	 * 
	 */	
	public interface IToolTipBaseItem extends IToolTip
	{
		/**
		 * 小于0为非回购， 大于0为回购 
		 * @param price
		 * 
		 */		
		function setBuyback(price:int):void;
	}
}