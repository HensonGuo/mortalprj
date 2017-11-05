/**
 * 可以显示tooltip的对象
 */

package com.mui.manager
{

	public interface IToolTipItem
	{
		/**
		 * 获取tooltip数据 
		 * @return 
		 */
		function get toolTipData():*;
		/**
		 * 设置tooltip数据 
		 * @param value
		 */		
		function set toolTipData(value:*):void;
	}
}