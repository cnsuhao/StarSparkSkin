//------------------------------------------------------------------------------
//
// ...
// classname: DatePickerEvent
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-8-4
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.events
{
	import flash.events.Event;

	/**
	 * 日期选择器事件
	 * @author AoSnow
	 */
	public class DatePickerEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/** 当日期选择器中的单元格被点击时派发  **/
		public static const SELECTED:String = "dateSelected";

		/** 当日期选择器所选择的内容发生变化时派发  **/
		public static const CHANGED:String = "dateChanged";

		/** 当与日期选择器执行清空时派发  **/
		public static const CLEAR:String = "dateClear";

		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function DatePickerEvent( type:String, dateString:String = null )
		{
			super( type, false, false );
			_dateString = dateString;
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		private var _dateString:String;

		/**
		 * 日期控件当前选择的内容
		 * <p><b>注意</b>：该内容会随着用户的选择而改变。</p>
		 * @return
		 */
		public function get dateString():String
		{
			return _dateString;
		}

		//--------------------------------------------------------------------------
		//
		//	Override methods
		//
		//--------------------------------------------------------------------------

		override public function clone():Event
		{
			return new DatePickerEvent( type, dateString );
		}
	}
}
