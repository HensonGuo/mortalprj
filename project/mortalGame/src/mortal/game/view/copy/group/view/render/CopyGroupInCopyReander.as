/**
 * 2014-3-18
 * @author chenriji
 **/
package mortal.game.view.copy.group.view.render
{
	import mortal.component.processbar.PointProcessBar;
	import mortal.game.view.common.UIFactory;

	public class CopyGroupInCopyReander extends CopyGroupOutCopyRender
	{
		protected var _bar:PointProcessBar;
		
		public function CopyGroupInCopyReander()
		{
			super();
		}
		
		public override function set data(value:Object):void
		{
			super.data = value;
			_bar.setProcess(_info.progress);
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_bar = UIFactory.pointProcessBar(217, 7, 37, 13, this);
			
			_txtTeamNum.x = 160;
			_txtFight.x = 317;
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_bar.dispose(isReuse);
			_bar = null;
			
		}
	}
}