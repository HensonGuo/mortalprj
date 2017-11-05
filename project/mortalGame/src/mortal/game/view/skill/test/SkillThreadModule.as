/**
 * 2014-3-3
 * @author chenriji
 **/
package mortal.game.view.skill.test
{
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	
	import fl.data.DataProvider;
	
	import mortal.component.window.Window;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.View;
	
	public class SkillThreadModule extends Window
	{
		private var _txtTitle:GTextFiled;
		private var _list:GTileList;
		
		public function SkillThreadModule()
		{
			super();
			setSize(230, 200);
		}
		
		public function updateList(data:DataProvider):void
		{
			_list.dataProvider = data;
			_list.drawNow();
		}
		
		public override function show(x:int=0, y:int=0):void
		{
			super.show(1000, 100);
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_txtTitle = UIFactory.gTextField("boss仇恨", 0, 0, 200, 20, this);
			_list = UIFactory.tileList(0, 30, 200, 200, this);
			_list.columnWidth = 180;
			_list.rowHeight = 18;
			_list.direction = GBoxDirection.VERTICAL;
			_list.setStyle("cellRenderer", SkillChouHenTestRender);
		
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			_txtTitle.dispose(isReuse);
			_txtTitle = null;
			_list.dispose(isReuse);
			_list = null;
		}
	}
}