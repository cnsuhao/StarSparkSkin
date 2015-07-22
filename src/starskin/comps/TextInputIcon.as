//------------------------------------------------------------------------------
//
// ...
// classname: TextInputIcon
// author: 喵大斯( blog.csdn.net/aosnowasp )
// created: 2015-6-22
// copyright (c) 2013 喵大斯( aosnow@yeah.net )
//
//------------------------------------------------------------------------------

package starskin.comps
{
	import spark.components.TextInput;

	/**
	 *  Class or instance to use as the default icon.
	 *  The icon can render from various graphical sources, including the following:
	 *  <ul>
	 *   <li>A Bitmap or BitmapData instance.</li>
	 *   <li>A class representing a subclass of DisplayObject. The BitmapFill
	 *       instantiates the class and creates a bitmap rendering of it.</li>
	 *   <li>An instance of a DisplayObject. The BitmapFill copies it into a
	 *       Bitmap for filling.</li>
	 *   <li>The name of an external image file. </li>
	 *  </ul>
	 *
	 *  @default null
	 *
	 *  @see spark.primitives.BitmapImage.source
	 */
	[Style( name = "icon", type = "Object", inherit = "no" )]

	/**
	 *  Orientation of the icon in relation to the label.
	 *  Valid MXML values are <code>right</code>, <code>left</code>.
	 *
	 *  <p>In ActionScript, you can use the following constants
	 *  to set this property:
	 *  <code>IconPlacement.RIGHT</code>,
	 *  <code>IconPlacement.LEFT</code>,
	 *
	 *  @default IconPlacement.LEFT
	 */
	[Style( name = "iconPlacement", type = "String", enumeration = "right,left", inherit = "no" )]
	
	/**
	 * 图标与边缘的距离
	 * 
	 * @default 5
	 */	
	[Style( name = "iconMargin", type = "int", inherit = "no" )]

	public class TextInputIcon extends TextInput
	{
		//--------------------------------------------------------------------------
		//
		//  Class constructor
		//
		//--------------------------------------------------------------------------

		public function TextInputIcon()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//	Class properties
		//
		//--------------------------------------------------------------------------

	}
}
