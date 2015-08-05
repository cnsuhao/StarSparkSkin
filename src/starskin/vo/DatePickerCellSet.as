//------------------------------------------------------------------------------
//
// ...
// classname: DatePickerCellSet
// author: 喵大( blog.csdn.net/aosnowasp )
// created: 2015-8-3
// copyright (c) 2013 喵大( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.vo
{

	/**
	 * 日期单元格设置数据
	 * <p>
	 * 可以通过自定义 <code>OVER_COLOR、BACKGROUND_COLOR、OVER_BACKGROUND_COLOR、BOLD</code>
	 * 及 DatePickerSkin 的定制，来实现个性外观。
	 * </p>
	 * @author AoSnow
	 */
	public class DatePickerCellSet
	{

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/** 全局设置：文本经过颜色  **/
		public static var OVER_COLOR:uint = 0xffffff;

		/** 全局设置：默认背景颜色  **/
		public static var BACKGROUND_COLOR:uint = 0xf3f3f3;

		/** 全局设置：鼠标经过时背景颜色  **/
		public static var OVER_BACKGROUND_COLOR:uint = 0xADC6D1;

		/** 全局设置：默认文本样式  **/
		public static var BOLD:String = "normal";

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

		/**
		 * 此单元所对应的时间（毫秒）
		 */		
		public var time:Number;
		
		/**
		 * 单元格标签内容
		 */
		public var label:String;

		/**
		 * 单元格宽度
		 */
		public var width:Number;

		/**
		 * 单元格高度
		 */
		public var height:Number;

		/**
		 * 单元格默认文本颜色
		 */
		public var color:uint;
		
		/**
		 * 单元格鼠标经过的文本颜色
		 */
		public var overColor:uint = OVER_COLOR;

		/**
		 * 单元格默认背景色
		 */
		public var backgroundColor:uint = BACKGROUND_COLOR;

		/**
		 * 单元格鼠标经过的背景色
		 */
		public var overBackgroundColor:uint = OVER_BACKGROUND_COLOR;

		/**
		 * 文本样式：“bold、normal” 决定是否加粗标签内容
		 */
		public var bold:String = BOLD;

		/**
		 * 该单元格是否有效使用
		 */
		public var enabled:Boolean = true;
	}
}
