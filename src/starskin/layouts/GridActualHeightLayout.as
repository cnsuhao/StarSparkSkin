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
			gridDimensions.variableRowHeight = true;
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
		//	Class properties
		//
		//--------------------------------------------------------------------------

		protected var _measureContentHeight:Number = 0;

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

			grid.measuredHeight = _measureContentHeight = gridDimensions.getContentHeight();
		}

		override public function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );

			// 由于 gridDimensions.getContentHeight() 等得到尺寸的方法，需要 updateDisplayList 之后才能正常运作
			// 此处在处理完之后，检测度量高度是否与更新完后的内容高度相同，不同则更新 grid 的 size
			if( _measureContentHeight != gridDimensions.getContentHeight())
			{
				grid.measuredHeight = gridDimensions.getContentHeight();
				grid.invalidateSize();
			}
		}
	}
}
