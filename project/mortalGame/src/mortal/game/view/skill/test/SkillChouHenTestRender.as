/**
 * 2014-3-3
 * @author chenriji
 **/
package mortal.game.view.skill.test
{
	import Message.Public.SThreat;
	
	import com.mui.controls.GCellRenderer;
	import com.mui.controls.GTextFiled;
	
	import mortal.game.view.common.UIFactory;
	
	public class SkillChouHenTestRender extends GCellRenderer
	{
		private var _txt:GTextFiled;
		private var _myData:SkillThreatData;
		
		public function SkillChouHenTestRender()
		{
			super();
		}
		
		public override function set data(value:Object):void
		{
			_myData = value as SkillThreatData;
			if(_myData.isHight)
			{
				_txt.textColor = 0xff0000;
			}
			else if(_myData.isLow)
			{
				_txt.textColor = 0x00ff00;
			}
			var t:SThreat = _myData.data;
			_txt.text = _myData.index + "    " + t.name + "    " + t.value;
		}
		
		public override function set label(value:String):void
		{
			
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_txt = UIFactory.gTextField("", 0, 0, 180, 20, this);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
		}
	}
}