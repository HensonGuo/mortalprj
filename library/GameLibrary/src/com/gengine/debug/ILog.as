/**
 * @date	2011-2-23 下午02:23:27
 * @author  jianglang
 * 
 */	

package com.gengine.debug
{
	public interface ILog
	{
		function print(...rest):void;
		function error(...rest):void;
	}
}