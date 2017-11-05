package com.gengine.global
{
	import com.gengine.keyBoard.KeyBoardManager;
	
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class StageFocus
	{
		public function StageFocus()
		{
			
		}
		
		public static function setFocus( object:InteractiveObject ):void
		{
			if( object is TextField )
			{
				if( (object as TextField).type == TextFieldType.INPUT  )
				{
					KeyBoardManager.instance.changeImeEnable(true);
				}
			}
			else
			{
				KeyBoardManager.instance.changeImeEnable(false);
			}
			
			Global.stage.focus = object;
		}
		
		public static function getFocus():InteractiveObject
		{
			return Global.stage.focus;
		}
	}
}