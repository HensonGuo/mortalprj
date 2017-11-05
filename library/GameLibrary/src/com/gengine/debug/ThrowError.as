/**
 * @date	2011-4-20 下午02:34:55
 * @author  jianglang
 * 
 */	

package com.gengine.debug
{
	import com.gengine.global.Global;
	import com.mui.controls.Alert;

	public class ThrowError
	{
		public function ThrowError()
		{
			
		}
		
		public static function show( value:String ):void
		{
			if( Global.isDebugModle )
			{
				Alert.show(value);
			}
		}
	}
}
