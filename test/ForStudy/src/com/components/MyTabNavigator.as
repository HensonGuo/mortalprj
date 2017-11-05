package com.components
{
	import com.awt.containers.TabNavigator;
	import com.awt.controls.TabBar;
	
	public class MyTabNavigator extends TabNavigator
	{
		public function MyTabNavigator()
		{
			super();
			this._tabBar = super.tabBar;
		}
		
		public var _tabBar:TabBar;
	}
}