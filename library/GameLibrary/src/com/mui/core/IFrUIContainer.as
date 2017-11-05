package com.mui.core
{
	public interface IFrUIContainer extends IFrUI
	{
//		/**释放子对象*/
//		function disposeChild(isReuse:Boolean=true):void;
		/**创建被释放的子对象*/
		function createDisposedChildren():void;
	}
}