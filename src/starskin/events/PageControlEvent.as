//------------------------------------------------------------------------------
//
// ...
// classname: PageControlEvent
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-7-21
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.events
{
	import flash.events.Event;

	import spark.components.supportClasses.ButtonBase;

	public class PageControlEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/** 当分页控制器的页码发生改变时派发  **/
		public static const CHANGED:String = "PageControlEvent_Index_Changed";

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function PageControlEvent( type:String, index:int = -1 )
		{
			super( type, false, false );
			_index = index;
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------------
		//  index
		//----------------------------------------

		private var _index:int;

		/**
		 * 当前页码
		 * @return
		 */
		public function get index():int
		{
			return _index;
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override public function clone():Event
		{
			return new PageControlEvent( type, index );
		}
	}
}
