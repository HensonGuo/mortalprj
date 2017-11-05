/**
 * 处理调试命令
 * @date	2011-8-9 下午09:09:18
 * @author shiyong
 * 
 */

package mortal.common.tools
{
	import com.gengine.core.FrameUtil;
	import com.gengine.debug.FPS;
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import mortal.common.global.ParamsConst;
	import mortal.component.window.DebugWindow;
	import mortal.game.manager.MsgManager;
	import mortal.game.scene3D.layer3D.utils.EntityUtil;

	public class DebugUtil
	{
		/**
		 *命令集 
		 */		
		private static var _commandArray:Array = [
//			"cd/showFPS", 		//显示信息框
//			"cd/closeFPS",  	//关闭信息框
			"cd/showDebug",	//显示debug信息
			"cd/closeDebug",	//关闭debug信息
			"cd/showAll",	   //显示所有信息
			"cd/showUITool",	   //显示所有信息
			
			"cd/openFightTest",	   //开启团战测试
			"cd/closeFightTest",	   //关闭团战测试
			
			"cd/showGuildCalculate" // 显示仙盟调试信息
		];
		
		public function DebugUtil()
		{
		}
		
		/**
		 *判断给定的字符串是否为调试命令 
		 * @param command
		 * @return 
		 * 
		 */		
		public static function isDebugCommand(command:String):Boolean
		{
			var isCommand:Boolean;
			var tmp:String;
			for(var i:int=0;i<_commandArray.length;i++)
			{
				tmp = _commandArray[i] as String;
				if(command == tmp)
				{
					isCommand = true;
					break;
				}
			}
			return isCommand;
		}
		
		public static function set isDebug( value:Boolean ):void
		{
			if( value )
			{
				Global.isDebugModle = true;
				FPS.instance.show();
				Log.debugLog = DebugWindow.instance;
				DebugWindow.instance.show();
			}
			else
			{
				Global.isDebugModle = false;
				FPS.instance.hide();
				Log.debugLog = null;
				DebugWindow.instance.hide();
			}
		}
		
		/**
		 *执行debug命令 
		 * @param command
		 * 
		 */		
		public static function runDebugCommand(command:String):void
		{
			if(isDebugCommand(command))
			{
				switch(command)
				{
					case "cd/showDebug":
					{
						if(ParamsConst.instance.isShowError)
						{
							isDebug = true;
						}
						break;
					}
					case "cd/closeDebug":
					{
						isDebug = false;
						break;
					}
					case "cd/showAll":
					{
						if(ParamsConst.instance.isShowError)
						{
//							EntityUtil.traceAllEntitys();
						}
						break;
					}
					case "cd/openFightTest": //开启团战测试
					{
						FrameUtil.isOpen = true;
						MsgManager.showRollTipsMsg("成功开启团战优化测试1");
						break;
					}
					case "cd/closeFightTest": //关闭团战测试
					{
						FrameUtil.isOpen = false;
						MsgManager.showRollTipsMsg("成功关闭团战优化测试1");
						break;
					}
				}
			}
		}
	}
}