//------------------------------------------------------------------------------
//
// ...
// classname: GridActualHeightLayout
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-15
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.layouts
{
	import spark.components.Grid;
	import spark.components.gridClasses.GridLayout;

	/**
	 * 实现Grid自动撑高达到内容实际高度的布局类
	 * @author AoSnow
	 */
	public class GridActualHeightLayout extends GridLayout
	{
		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function GridActualHeightLayout()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  DataGrid Access
		//
		//--------------------------------------------------------------------------

		private function get grid():Grid
		{
			return target as Grid;
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override public function measure():void
		{
			super.measure();

			if( !grid )
				return;

			grid.measuredHeight = gridDimensions.getContentHeight();
		}
	}
}
